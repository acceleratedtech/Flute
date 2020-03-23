#pragma once

#include "AWSP2_Request.h"
#include "AWSP2_Response.h"

#define DM_CONTROL_REG 0x10
#define DM_STATUS_REG 0x11
#define DM_HALTSUM1_REG 0x13
#define DM_COMMAND_REG 0x17
#define DM_SBCS_REG 0x38
#define DM_SBADDRESS0_REG 0x39
#define DM_SBADDRESS1_REG 0x3a
#define DM_SBADDRESS2_REG 0x3b
#define DM_SBADDRESS3_REG 0x37 // note out of order reg address
#define DM_SBDATA0_REG 0x3c
#define DM_SBDATA1_REG 0x3d
#define DM_SBDATA2_REG 0x3e
#define DM_SBDATA3_REG 0x3f

#define DM_CONTROL_HALTREQ (1 << 31)
#define DM_CONTROL_RESUMEREQ (1 << 30)

#define DM_COMMAND_ACCESS_REGISTER 0
#define DM_COMMAND_ACCESS_MEMORY 2

#define AAMVIRTUAL (1 << 23)
#define AAMSIZE_8 (3 << 20)
#define AAMPOSTINCREMENT (1 << 19)
#define WRITE (1 << 16)

#define SBCS_SBREADONDATA (1 << 15)
#define SBCS_SBAUTOINCREMENT (1 << 16)
#define SBCS_SBACCESS32 (2 << 17)
#define SBCS_SBREADONADDR (1 << 20)
#define SBCS_SBBUSY (1 << 21)
#define SBCS_SBBUSYERROR (1 << 22)

class AWSP2 : public AWSP2_ResponseWrapper {
    sem_t sem;
    AWSP2_RequestProxy *request;
    uint32_t rsp_data;
    uint32_t last_addr;
public:
    AWSP2(int id)
      : AWSP2_ResponseWrapper(id), last_addr(0) {
        sem_init(&sem, 0, 0);
        request = new AWSP2_RequestProxy(IfcNames_AWSP2_RequestS2H);
    }
    virtual void dmi_read_data(uint32_t rsp_data) {
        //fprintf(stderr, "dmi_read_data data=%08x\n", rsp_data);
        this->rsp_data = rsp_data;
        sem_post(&sem);
    }
    virtual void dmi_status_data(uint16_t rsp_data) {
        this->rsp_data = rsp_data;
        sem_post(&sem);
    }
    virtual void tandem_packet(const uint32_t num_bytes, const bsvvector_Luint8_t_L72 bytes) {
        //uint32_t *words = (uint32_t *)bytes;
        fprintf(stderr, "[TV] %d bytes", num_bytes);
        if (num_bytes < 72) {
            for (uint32_t i = 0; i < num_bytes; i++) {
                fprintf(stderr, " %02x", bytes[71 - i] & 0xFF);
            }
        }
        fprintf(stderr, "\n");
    }

    void wait() {
        //fprintf(stderr, "fpga::wait\n");
        sem_wait(&sem);
    }

    uint32_t dmi_status() {
        request->dmi_status();
        wait();
        return rsp_data;
    }
    uint32_t dmi_read(uint32_t addr) {
        //fprintf(stderr, "sw dmi_read %x\n", addr);
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

    uint64_t read_csr(int i) {
        dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | i);
        uint64_t val = dmi_read(5);
        val <<=  32;
        val |= dmi_read(4);
        return val;
    }

    void write_csr(int i, uint64_t val) {
        dmi_write(5, (val >> 32) & 0xFFFFFFFF);
        dmi_write(4, (val >>  0) & 0xFFFFFFFF);
        dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | (1 << 16) | i);
    }

    uint64_t read_gpr(int i) {
        dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | 0x1000 | i);
        uint64_t val = dmi_read(5);
        val <<=  32;
        val |= dmi_read(4);
        return val;
    }

    void write_gpr(int i, uint64_t val) {
        dmi_write(5, (val >> 32) & 0xFFFFFFFF);
        dmi_write(4, (val >>  0) & 0xFFFFFFFF);
        dmi_write(DM_COMMAND_REG, DM_COMMAND_ACCESS_REGISTER | (3 << 20) | (1 << 17) | (1 << 16) | 0x1000 | i);
    }

    void sbcs_wait() {
        uint32_t sbcs = 0;
        int count = 0;
        do {
            sbcs = dmi_read(DM_SBCS_REG);
            if (++count % 8) {
                fprintf(stderr, "sbcs=%x\n", sbcs);
            }
        } while (sbcs & SBCS_SBBUSY);
    }

    uint32_t read32(uint32_t addr) {
        if (last_addr != addr) {
            dmi_write(DM_SBCS_REG, SBCS_SBACCESS32 | SBCS_SBREADONDATA | SBCS_SBAUTOINCREMENT | SBCS_SBBUSYERROR);
            dmi_write(DM_SBADDRESS0_REG, addr);
        }
        sbcs_wait();
        uint64_t lo = dmi_read(DM_SBDATA0_REG);
        last_addr = addr + 4;
        return lo;
    }

    uint64_t read64(uint32_t addr) {
        if (last_addr != addr) {
            dmi_write(DM_SBCS_REG, SBCS_SBACCESS32 | SBCS_SBREADONDATA | SBCS_SBAUTOINCREMENT | SBCS_SBBUSYERROR);
            dmi_write(DM_SBADDRESS0_REG, addr);
        }
        sbcs_wait();
        uint64_t lo = dmi_read(DM_SBDATA0_REG);
        sbcs_wait();
        uint64_t hi = dmi_read(DM_SBDATA0_REG);
        last_addr = addr + 8;
        return (hi << 32) | lo;
    }

    void write32(uint32_t addr, uint32_t val) {
        if (last_addr != addr) {
            dmi_write(DM_SBCS_REG, SBCS_SBACCESS32 | SBCS_SBREADONDATA | SBCS_SBAUTOINCREMENT);
            dmi_write(DM_SBADDRESS0_REG, addr);
        }
        sbcs_wait();
        dmi_write(DM_SBDATA0_REG, (val >>  0) & 0xFFFFFFFF);
        last_addr = addr + 4;
    }

    void write64(uint32_t addr, uint64_t val) {
        if (last_addr != addr) {
            dmi_write(DM_SBCS_REG, SBCS_SBACCESS32 | SBCS_SBREADONDATA | SBCS_SBAUTOINCREMENT);
            dmi_write(DM_SBADDRESS0_REG, addr);
        }
        dmi_write(DM_SBDATA0_REG, (val >>  0) & 0xFFFFFFFF);
        sbcs_wait();
        dmi_write(DM_SBDATA0_REG, (val >>  32) & 0xFFFFFFFF);
        sbcs_wait();
        last_addr = addr + 8;
    }

    void halt(int timeout = 100) {
        dmi_write(DM_CONTROL_REG, DM_CONTROL_HALTREQ | dmi_read(DM_CONTROL_REG));
        for (int i = 0; i < 100; i++) {
            uint32_t status = dmi_read(DM_STATUS_REG);
            if (status & (1 << 9))
                break;
        }
        dmi_write(DM_CONTROL_REG, ~DM_CONTROL_HALTREQ & dmi_read(DM_CONTROL_REG));
    }
    void resume(int timeout = 100) {
        dmi_write(DM_CONTROL_REG, DM_CONTROL_RESUMEREQ | dmi_read(DM_CONTROL_REG));
        for (int i = 0; i < 100; i++) {
            uint32_t status = dmi_read(DM_STATUS_REG);
            if (status & (1 << 17))
                break;
        }
        dmi_write(DM_CONTROL_REG, ~DM_CONTROL_RESUMEREQ & dmi_read(DM_CONTROL_REG));
    }

    void io_awaddr(uint32_t awaddr, uint16_t awlen, uint16_t awid) {
        fprintf(stderr, "io_awaddr awaddr=%x\n", awaddr);
    }

    void io_araddr(uint32_t araddr, uint16_t arlen, uint16_t arid) {
        fprintf(stderr, "io_araddr araddr=%x arlen=%d\n", araddr, arlen);
        for (int i = 0; i < arlen / 8; i++) {
            int last = i == ((arlen / 8) - 1);
            request->io_rdata(0, arid, 0, last);
        }
    }

    void io_wdata(uint64_t wdata, uint8_t wstrb) {
        fprintf(stderr, "io_wdata wdata=%lx wstrb=%x\n", wdata, wstrb);
    }

    void set_fabric_verbosity(uint8_t verbosity) {
        request->set_fabric_verbosity(verbosity);
    }
};
