
#include <stdio.h>

#include "GeneratedTypes.h"
#include "dmaManager.h"
#include "AWSP2_Request.h"
#include "AWSP2_Response.h"

class AWSP2_Response : public AWSP2_ResponseWrapper {
public:
    AWSP2_Response(int id)
	:     AWSP2_ResponseWrapper(id) {
    }
    virtual void dmi_read_data(uint32_t rsp_data) {
	fprintf(stderr, "dmi_read_data data=%08x\n", rsp_data);
    }
};

AWSP2_Response *response;

int main(int argc, const char **argv)
{
    AWSP2_RequestProxy *request = new AWSP2_RequestProxy(IfcNames_AWSP2_RequestS2H);
    response = new AWSP2_Response(IfcNames_AWSP2_ResponseH2S);
    DmaManager *dma = platformInit();
    
    // allocate a shared memory object for Flash
    size_t flash_alloc_sz = 1024*1024; 
    int flashObject = portalAlloc(flash_alloc_sz, 0);
    unsigned int *flashBuffer = (unsigned int *)portalMmap(flashObject, flash_alloc_sz);
    fprintf(stderr, "flashBuffer=%lx\n", (long)flashBuffer);
    size_t dram_alloc_sz = 16*1024*1024; 
    int dramObject = portalAlloc(dram_alloc_sz, 0);
    unsigned int *dramBuffer = (unsigned int *)portalMmap(dramObject, dram_alloc_sz);
    fprintf(stderr, "dramBuffer=%lx\n", (long)dramBuffer);

    // load the ROM code into Flash
    //TBD

    // load the app code into DRAM
    //TBD

    // register the Flash memory object with the SoC (and program the MMU)
    request->register_region(7, dma->reference(flashObject));
    // register the DRAM memory object with the SoC (and program the MMU)
    request->register_region(8, dma->reference(dramObject));

    // unblock memory accesses in the SoC
    request->memory_ready();

    // test that we can read a DMI register
    request->dmi_read(0); // result will be printed at the moment

    while (1) {
      // event processing is in the other thread
      sleep(1);
    }
    return 0;
}
