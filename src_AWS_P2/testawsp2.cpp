
#include <errno.h>
#include <fcntl.h>
#include <stdio.h>
#include <semaphore.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "GeneratedTypes.h"
#include "dmaManager.h"
#include <portal.h>
#include "AWSP2_Request.h"
#include "AWSP2_Response.h"

#define DM_CONTROL_REG 0x10
#define DM_STATUS_REG 0x11
#define DM_HALTSUM1_REG 0x13
#define DM_COMMAND_REG 0x17

#define DM_CONTROL_HALTREQ (1 << 31)
#define DM_CONTROL_RESUMEREQ (1 << 30)

#define DM_COMMAND_ACCESS_REGISTER 0

class AWSP2 : public AWSP2_ResponseWrapper {
  sem_t sem;
  AWSP2_RequestProxy *request;
  uint32_t rsp_data;
public:
    AWSP2(int id)
    : AWSP2_ResponseWrapper(id) {
	sem_init(&sem, 0, 0);
      request = new AWSP2_RequestProxy(IfcNames_AWSP2_RequestS2H);
    }
    virtual void dmi_read_data(uint32_t rsp_data) {
	//fprintf(stderr, "dmi_read_data data=%08x\n", rsp_data);
	this->rsp_data = rsp_data;
	sem_post(&sem);
    }
  void wait() {
    sem_wait(&sem);
  }
  uint32_t dmi_read(uint32_t addr) {
    request->dmi_read(addr);
    wait();
    return rsp_data;
  }
  void dmi_write(uint32_t addr, uint32_t data) {
    request->dmi_write(addr, data);
  }

  void register_region(uint32_t region, uint32_t objid) {
    request->register_region(region, objid);
  }
  void memory_ready() {
    request->memory_ready();
  }

};


int copyFile(char *buffer, const char *filename, size_t buffer_size)
{
    int fd = open(filename, O_RDONLY);
    if (fd < 0) {
	fprintf(stderr, "Error: failed to open file %s: %s\n", filename, strerror(errno));
	return -errno;
    }
    size_t bytes_copied = 0;
    do {
	char readbuf[4096];
	size_t readsize = sizeof(readbuf);
	if (readsize > (buffer_size - bytes_copied))
	    readsize = (buffer_size - bytes_copied);
	int bytes_read = read(fd, readbuf, readsize);
	if (readsize <= 0) {
	    fprintf(stderr, "Error: failed to read file %s at offset %ld: %s\n", filename, bytes_copied, strerror(errno));
	    return -errno;
	}
	if (!bytes_read)
	    break;
	memcpy(buffer + bytes_copied, readbuf, bytes_read);
	bytes_copied += bytes_read;
	fprintf(stderr, "Copied %d bytes %ld bytes total readsize %ld\n", bytes_read, bytes_copied, readsize);
    } while (bytes_copied < buffer_size);
    close(fd);
    fprintf(stderr, "Read %ld bytes from %s\n", bytes_copied, filename);
    return bytes_copied;
}

int main(int argc, const char **argv)
{
  //AWSP2_RequestProxy *request = new AWSP2_RequestProxy(IfcNames_AWSP2_RequestS2H);
    AWSP2 *fpga = new AWSP2(IfcNames_AWSP2_ResponseH2S);
    DmaManager *dma = platformInit();
    
    // allocate a shared memory object for Rom
    size_t rom_alloc_sz = 1024*1024; 
    int romObject = portalAlloc(rom_alloc_sz, 0);
    unsigned int *romBuffer = (unsigned int *)portalMmap(romObject, rom_alloc_sz);
    fprintf(stderr, "romBuffer=%lx\n", (long)romBuffer);

    // allocate a shared memory object for Flash
    size_t flash_alloc_sz = 0x08000000; 
    int flashObject = portalAlloc(flash_alloc_sz, 0);
    unsigned int *flashBuffer = (unsigned int *)portalMmap(flashObject, flash_alloc_sz);
    fprintf(stderr, "flashBuffer=%lx\n", (long)flashBuffer);

    size_t dram_alloc_sz = 16*1024*1024; 
    int dramObject = portalAlloc(dram_alloc_sz, 0);
    unsigned int *dramBuffer = (unsigned int *)portalMmap(dramObject, dram_alloc_sz);
    fprintf(stderr, "dramBuffer=%lx\n", (long)dramBuffer);

    // load the ROM code into Flash
    copyFile((char *)romBuffer, "../../../../bootrom/bootrom.img", rom_alloc_sz);

    // where is this coming from?
    copyFile((char *)flashBuffer, "../../../../bootrom/bootrom.img", flash_alloc_sz);

    // load the app code into DRAM
    memset(dramBuffer, 0x42, flash_alloc_sz);

    // register the Flash memory object with the SoC (and program the MMU)
    fpga->register_region(7, dma->reference(romObject));
    fpga->register_region(4, dma->reference(flashObject));
    // register the DRAM memory object with the SoC (and program the MMU)
    fpga->register_region(8, dma->reference(dramObject));

    // unblock memory accesses in the SoC
    fpga->memory_ready();

    sleep(1);
    fprintf(stderr, "status %x\n", fpga->dmi_read(DM_STATUS_REG));
    fprintf(stderr, "control %x\n", fpga->dmi_read(DM_CONTROL_REG));
    fprintf(stderr, "haltsum1 %x\n", fpga->dmi_read(DM_HALTSUM1_REG));
    fprintf(stderr, "asserting haltreq\n");
    fpga->dmi_write(DM_CONTROL_REG, DM_CONTROL_HALTREQ | fpga->dmi_read(DM_CONTROL_REG));
    for (int i = 0; i < 100; i++) {
	uint32_t status = fpga->dmi_read(DM_STATUS_REG);
	if (status & (1 << 9))
	    break;
    }
    // test that we can read a DMI register
    for (int i =  0; i < 10; i++) {
	fprintf(stderr, "DM register %#02x: %#08x\n", 0x10 + i, fpga->dmi_read(0x10 + i));
    }
    fprintf(stderr, "status %x\n", fpga->dmi_read(DM_STATUS_REG));
    for (int i = 0; i < 32; i++) {
	// transfer GPR i into data reg
	fpga->dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | 0x1000 | i);
	// read GPR value from data reg
	fprintf(stderr, "reg %d val %#08x.%#08x\n", i, fpga->dmi_read(5), fpga->dmi_read(4));
    }
    // read dpc
    fpga->dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | 0x7b1);
    fprintf(stderr, "reg pc val %#08x.%#08x\n", fpga->dmi_read(5), fpga->dmi_read(4));
    fpga->dmi_write(5, 0);
    fpga->dmi_write(4, 0x8000c000);
    fpga->dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | (1 << 16) | 0x7b1);

    fprintf(stderr, "status %x\n", fpga->dmi_read(DM_STATUS_REG));
    fprintf(stderr, "haltsum1 %x\n", fpga->dmi_read(DM_HALTSUM1_REG));
    fpga->dmi_write(DM_CONTROL_REG, DM_CONTROL_RESUMEREQ | fpga->dmi_read(DM_CONTROL_REG));
    fprintf(stderr, "status %x\n", fpga->dmi_read(DM_STATUS_REG));
    fprintf(stderr, "haltsum1 %x\n", fpga->dmi_read(DM_HALTSUM1_REG));

    return 0;

    while (1) {
      // event processing is in the other thread
      sleep(1);
    }
    return 0;
}
