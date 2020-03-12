
import BRAMFIFO     :: *;
import BuildVector  :: *;
import ClientServer :: *;
import FIFO         :: *;
import FIFOF        :: *;
import GetPut       :: *;
import Vector       :: *;

import ConnectalConfig :: *;
import ConnectalMemTypes::*;

// ================================================================
// Project imports

import P2_Core  :: *;
import SoC_Map  :: *;

// The basic core
import Core_IFC :: *;
import Core     :: *;

// External interrupt request interface
import PLIC :: *;    // for PLIC_Source_IFC type which is exposed at P2_Core interface

// Main Fabric
import AXI4_Types   :: *;
import AXI4_Fabric  :: *;
import Fabric_Defs  :: *;

`ifdef INCLUDE_TANDEM_VERIF
import TV_Info :: *;
import AXI4_Stream ::*;
`endif

`ifdef INCLUDE_GDB_CONTROL
import Debug_Module :: *;
import JtagTap      :: *;
import Giraffe_IFC  :: *;
`endif

import AWSP2_IFC   :: *;

interface AWSP2;
  interface AWSP2_Request request;
  interface Vector#(2, MemReadClient#(DataBusWidth)) readClients;
  interface Vector#(2, MemWriteClient#(DataBusWidth)) writeClients;
endinterface

module mkAWSP2#(AWSP2_Response response)(AWSP2);

   P2_Core_IFC p2_core <- mkP2_Core();

   Reg#(Bool) ready <- mkReg(False);

   Vector#(16, Reg#(Bit#(8)))    objIds <- replicateM(mkReg(0));

   FIFOF#(MemRequest) readReqFifo0 <- mkFIFOF();
   FIFOF#(MemRequest) writeReqFifo0 <- mkFIFOF();
   FIFOF#(MemData#(DataBusWidth))   readDataFifo0 <- mkSizedBRAMFIFOF(64);
   FIFOF#(MemData#(DataBusWidth))   writeDataFifo0 <- mkSizedBRAMFIFOF(64);
   FIFO#(Bit#(MemTagSize)) doneFifo0 <- mkFIFO();

   Wire#(Bool) w_arready0 <- mkDWire(False);
   Wire#(Bool) w_awready0 <- mkDWire(False);
   Wire#(Bool) w_rvalid0  <- mkDWire(False);

   FIFOF#(MemRequest) readReqFifo1 <- mkFIFOF();
   FIFOF#(MemRequest) writeReqFifo1 <- mkFIFOF();
   FIFOF#(MemData#(DataBusWidth))   readDataFifo1 <- mkSizedBRAMFIFOF(64);
   FIFOF#(MemData#(DataBusWidth))   writeDataFifo1 <- mkSizedBRAMFIFOF(64);
   FIFO#(Bit#(MemTagSize)) doneFifo1 <- mkFIFO();

   Wire#(Bool) w_arready1 <- mkDWire(False);
   Wire#(Bool) w_awready1 <- mkDWire(False);
   Wire#(Bool) w_rvalid1  <- mkDWire(False);

   rule master0_aw if (p2_core.master0.m_awvalid() && ready);
      let awaddr = p2_core.master0.m_awaddr();
      let len    = p2_core.master0.m_awlen();
      let size   = p2_core.master0.m_awsize();
      let awid   = p2_core.master0.m_awid();
      $display("master0 awaddr %h len=%d size=%d", awaddr, len, size);
      w_awready0 <= writeReqFifo0.notFull();

      Bit#(4)  objNumber = truncate(awaddr >> 28);
      Bit#(24) objOffset = truncate(awaddr);
      let objId = objIds[objNumber];
      writeReqFifo0.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: 64, tag: extend(awid) });

   endrule
   rule master0_wdata if (p2_core.master0.m_wvalid());
      let wdata = p2_core.master0.m_wdata;
      $display("master0 wdata %h", wdata);
      p2_core.master0.m_wready(p2_core.master0.m_wvalid());
   endrule
   //rule master0_b;
   //   p2_core.master0.m_bvalid();
   //endrule

   rule master0_a_ready;
      p2_core.master0.m_arready(w_arready0);
      p2_core.master0.m_awready(w_awready0);
   endrule
   rule debug0 if (False);
      if (p2_core.master0.m_arvalid()
      	 || w_arready0
	 || w_rvalid0
	 || p2_core.master0.m_rready())
         $display("master0 arvalid %d arready %d rvalid %d rready %d", p2_core.master0.m_arvalid(), w_arready0, w_rvalid0, p2_core.master0.m_rready());
   endrule

   rule master0_ar if (p2_core.master0.m_arvalid() && ready);
      let araddr = p2_core.master0.m_araddr();
      let len    = p2_core.master0.m_arlen();
      let size   = p2_core.master0.m_arsize();
      let arid   = p2_core.master0.m_arid();
      $display("master0 araddr %h len=%d size=%d id=%d", araddr, len, size, arid);

      w_arready0 <= readReqFifo0.notFull();

      Bit#(4) objNumber = truncate(araddr >> 28);
      Bit#(24) objOffset = truncate(araddr);

      let objId = objIds[objNumber];
      readReqFifo0.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: 64, tag: extend(arid) });

   endrule

   rule master0_rdata if (ready);
      let rdata = readDataFifo0.first;
      //$display("master0 rdata data %h rid %d last %d", rdata.data, rdata.tag, rdata.last);

      w_rvalid0 <= readDataFifo0.notEmpty();
      p2_core.master0.m_rvalid(readDataFifo0.notEmpty(),
			       truncate(rdata.tag),
			       rdata.data,
			       0,  // rresp
			       rdata.last,
			       0); // ruser
   endrule

   // this is in a second rule to avoid combinational loop on rvalid
   rule master0_rdata_deq if (w_rvalid0 && p2_core.master0.m_rready());
      //$display("master0_rdata_deq rvalid %d rready %d", w_rvalid0, p2_core.master0.m_rready());
      readDataFifo0.deq();
   endrule

   rule master1_aw if (p2_core.master1.m_awvalid() && ready);
      let awaddr = p2_core.master1.m_awaddr();
      let len    = p2_core.master1.m_awlen();
      let size   = p2_core.master1.m_awsize();
      let awid   = p2_core.master1.m_awid();
      $display("master1 awaddr %h len=%d size=%d", awaddr, len, size);
      w_awready1 <= writeReqFifo1.notFull();

      Bit#(4)  objNumber = truncate(awaddr >> 28);
      Bit#(24) objOffset = truncate(awaddr);
      let objId = objIds[objNumber];
      writeReqFifo1.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: 64, tag: extend(awid) });

   endrule
   rule master1_w if (p2_core.master1.m_wvalid());
      let wdata = p2_core.master1.m_wdata;
      //$display("master1 wdata %h", wdata);
      p2_core.master1.m_wready(p2_core.master1.m_wvalid());
   endrule
   //rule master1_b;
   //   p2_core.master1.m_bvalid();
   //endrule

   rule master1_a_ready;
      p2_core.master1.m_arready(w_arready1);
      p2_core.master1.m_awready(w_awready1);
   endrule
   rule debug1 if (False);
      if (p2_core.master1.m_arvalid()
      	 || w_arready1
	 || w_rvalid1
	 || p2_core.master1.m_rready())
         $display("master 1 arvalid %d arready %d rvalid %d rready %d", p2_core.master1.m_arvalid(), w_arready1, w_rvalid1, p2_core.master1.m_rready());
   endrule

   rule master1_ar if (p2_core.master1.m_arvalid() && ready);
      let araddr = p2_core.master1.m_araddr();
      let len    = p2_core.master1.m_arlen();
      let size   = p2_core.master1.m_arsize();
      let arid   = p2_core.master1.m_arid();
      $display("master1 araddr %h len=%d size=%d id=%d", araddr, len, size, arid);

      w_arready1 <= readReqFifo1.notFull();

      Bit#(4) objNumber = truncate(araddr >> 28);
      Bit#(24) objOffset = truncate(araddr);

      let objId = objIds[objNumber];
      readReqFifo1.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: 64, tag: extend(arid) });

   endrule

   rule master1_rdata if (ready);
      let rdata = readDataFifo1.first;
      //$display("master1 rdata data %h rid %d last %d", rdata.data, rdata.tag, rdata.last);

      w_rvalid1 <= readDataFifo1.notEmpty();
      p2_core.master1.m_rvalid(readDataFifo1.notEmpty(),
			       truncate(rdata.tag),
			       rdata.data,
			       1,  // rresp
			       rdata.last,
			       ?); // ruser
   endrule

   // this is in a second rule to avoid combinational loop on rvalid
   rule master1_rdata_deq if (w_rvalid1 && p2_core.master1.m_rready());
      readDataFifo1.deq();
   endrule

`ifdef INCLUDE_GDB_CONTROL
   rule dmi_rsp;
      let rdata <- p2_core.dmi.read_data();
      response.dmi_read_data(rdata);
   endrule
`endif

   MemReadClient#(DataBusWidth) readClient0 = (interface MemReadClient;
      interface Get readReq = toGet(readReqFifo0);
      interface Put readData;
        method Action put(MemData#(DataBusWidth) rdata);
	  readDataFifo0.enq(rdata);
	endmethod
      endinterface
   endinterface );
   MemWriteClient#(DataBusWidth) writeClient0 = (interface MemWriteClient;
      interface Get writeReq = toGet(writeReqFifo0);
      interface Get writeData = toGet(writeDataFifo0);
      interface Put writeDone = toPut(doneFifo0);
   endinterface );

   MemReadClient#(DataBusWidth) readClient1 = (interface MemReadClient;
      interface Get readReq = toGet(readReqFifo1);
      interface Put readData;
        method Action put(MemData#(DataBusWidth) rdata);
	  readDataFifo1.enq(rdata);
	endmethod
      endinterface
   endinterface );
   MemWriteClient#(DataBusWidth) writeClient1 = (interface MemWriteClient;
      interface Get writeReq = toGet(writeReqFifo1);
      interface Get writeData = toGet(writeDataFifo1);
      interface Put writeDone = toPut(doneFifo1);
   endinterface );

   interface AWSP2_Request request;
      method Action dmi_read(Bit#(7) addr);
`ifdef INCLUDE_GDB_CONTROL
         p2_core.dmi.read_addr(addr);
`else
	response.dmi_read_data('hbeef);
`endif
      endmethod
      method Action dmi_write(Bit#(7) addr, Bit#(32) data);
`ifdef INCLUDE_GDB_CONTROL
         p2_core.dmi.write(addr, data);
`endif
      endmethod
      method Action register_region(Bit#(32) region, Bit#(32) objectId);
         objIds[region] <= truncate(objectId);
      endmethod
      method Action memory_ready();
          $display("memory_ready");
          ready <= True;
      endmethod
   endinterface

   interface readClients = vec(readClient0, readClient1);
   interface writeClients = vec(writeClient0, writeClient1);

endmodule
