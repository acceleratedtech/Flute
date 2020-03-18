
#include <errno.h>
#include <fcntl.h>
#include <getopt.h>
#include <stdio.h>
#include <semaphore.h>
#include <sys/types.h>
#include <sys/stat.h>

#include "GeneratedTypes.h"
#include "dmaManager.h"
#include <portal.h>
#include "fpga.h"
#include "loadelf.h"

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

const struct option long_options[] = {
    { "bootrom", required_argument, 0, 'b' },
    { "cpuverbosity",   required_argument, 0, 'v' },
    { "elf",     required_argument, 0, 'e' },
    { "entry",   required_argument, 0, 'E' },
    { "flash",   required_argument, 0, 'f' },
    { 0,         0,                 0, 0 }
};

void usage(const char *name)
{
    fprintf(stderr, "Usage: %s [-b bootrombin] [--bootrom bootrombin] [--flash flashbin] [--elf elf] [ -e elf] [elf] [--cpuverbosity n]\n", name);
}

int main(int argc, char * const *argv)
{
    const char *bootrom_filename = 0;
    const char *elf_filename = 0;
    const char *flash_filename = 0;
    int cpuverbosity = 0;
    uint32_t entry = 0;
    while (1) {
        int option_index = optind ? optind : 1;
        char c = getopt_long(argc, argv, "b:e:h",
                             long_options, &option_index);
        if (c == -1)
            break;

        switch (c) {
        case 'b':
            bootrom_filename = optarg;
            break;
        case 'e':
            elf_filename = optarg;
            break;
        case 'E':
            entry = strtoul(optarg, 0, 0);
            break;
        case 'f':
            flash_filename = optarg;
            break;
        case 'h':
	    usage(argv[0]);
	    return 2;
        case 'v':
            cpuverbosity = strtoul(optarg, 0, 0);
            break;
        }
    }

    if (optind < argc) {
        elf_filename = argv[optind];
    }
    if (!bootrom_filename && !elf_filename) {
        usage(argv[0]);
        return -1;
    }

    //AWSP2_RequestProxy *request = new AWSP2_RequestProxy(IfcNames_AWSP2_RequestS2H);
    AWSP2 *fpga = new AWSP2(IfcNames_AWSP2_ResponseH2S);
    DmaManager *dma = platformInit();
    
    // allocate a shared memory object for Rom
    size_t rom_alloc_sz = 1024*1024; 
    int romObject = portalAlloc(rom_alloc_sz, 0);
    uint8_t *romBuffer = (uint8_t *)portalMmap(romObject, rom_alloc_sz);
    fprintf(stderr, "romBuffer=%lx\n", (long)romBuffer);

    // allocate a shared memory object for Flash
    size_t flash_alloc_sz = 0x08000000; 
    int flashObject = portalAlloc(flash_alloc_sz, 0);
    uint8_t *flashBuffer = (uint8_t *)portalMmap(flashObject, flash_alloc_sz);
    fprintf(stderr, "flashBuffer=%lx\n", (long)flashBuffer);

    size_t dram_alloc_sz = 256*1024*1024; 
    int dramObject = portalAlloc(dram_alloc_sz, 0);
    uint8_t *dramBuffer = (uint8_t *)portalMmap(dramObject, dram_alloc_sz);
    fprintf(stderr, "dramBuffer=%lx\n", (long)dramBuffer);

    // load the ROM code into Flash

    if (bootrom_filename)
        copyFile((char *)romBuffer, bootrom_filename, rom_alloc_sz);

    // where is this coming from?
    if (flash_filename)
        copyFile((char *)flashBuffer, flash_filename, flash_alloc_sz);

    fpga->dmi_write(0x60, cpuverbosity);

    // load the app code into DRAM
    memset(dramBuffer, 0x42, flash_alloc_sz);
    uint64_t tohost_address = 0;
    uint64_t elf_entry = loadElf(dramBuffer, elf_filename, dram_alloc_sz, &tohost_address);
    fprintf(stderr, "elf_entry=%08lx tohost_address=%08lx\n", elf_entry, tohost_address);

    // register the Flash memory object with the SoC (and program the MMU)
    fpga->register_region(7, dma->reference(romObject));
    fpga->register_region(4, dma->reference(flashObject));
    // register the DRAM memory object with the SoC (and program the MMU)
    fpga->register_region(8, dma->reference(dramObject));

    // unblock memory accesses in the SoC
    fpga->memory_ready();

    fprintf(stderr, "status  %x\n", fpga->dmi_read(DM_STATUS_REG));
    fprintf(stderr, "control %x\n", fpga->dmi_read(DM_CONTROL_REG));
    fprintf(stderr, "sbcs    %x\n", fpga->dmi_read(DM_SBCS_REG));
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
    if (!entry)
        entry = elf_entry;

    // copy sm.state as a test
    for (int i = 0; i < 360; i += 8) {
	uint64_t *image = (uint64_t *)dramBuffer;
	uint32_t addr = 0x80000000 + i;
	fpga->write_mem(addr, dramBuffer[i / 8]);
	uint64_t readback = fpga->read_mem(0x80000000 + i);
	if (image[i / 8] != readback) {
	    fprintf(stderr, "mem[%08x] expected %08lx actual %08lx\n",
		    addr, image[i / 8], readback);
	}
    }

    fprintf(stderr, "setting pc val %#08x.%#08x\n", 0, entry);
    fpga->dmi_write(5, 0);
    fpga->dmi_write(4, entry);
    // update the dpc
    fpga->dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | (1 << 16) | 0x7b1);

    fprintf(stderr, "status %x\n", fpga->dmi_read(DM_STATUS_REG));
    fprintf(stderr, "haltsum1 %x\n", fpga->dmi_read(DM_HALTSUM1_REG));
    fpga->dmi_write(DM_CONTROL_REG, DM_CONTROL_RESUMEREQ | fpga->dmi_read(DM_CONTROL_REG));
    fprintf(stderr, "status %x\n", fpga->dmi_read(DM_STATUS_REG));
    fprintf(stderr, "haltsum1 %x\n", fpga->dmi_read(DM_HALTSUM1_REG));

    while (1) {
        // event processing is in the other thread
        fpga->halt();

	uint64_t dpc = fpga->read_csr(0x7b1);
        fprintf(stderr, "pc val %08lx\n", dpc);
        if (dpc == 0x1000) {
            for (int i = 0; i < 32; i++) {
                fprintf(stderr, "reg %d val %08lx\n", i, fpga->read_gpr(i));
            }

            fprintf(stderr, "mepc   %08lx\n", fpga->read_csr(0x341));
            fprintf(stderr, "mcause %08lx\n", fpga->read_csr(0x342));
            fprintf(stderr, "mepc   %08lx\n", fpga->read_csr(0x343));

            break;    
        }
        fpga->resume();

        sleep(1);
    }
    return 0;
}
