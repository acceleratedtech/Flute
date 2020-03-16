
import BRAMFIFO     :: *;
import BuildVector  :: *;
import ClientServer :: *;
import Connectable  :: *;
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

   Fabric_Addr ddr4_0_uncached_addr_base = 'h_8000_0000;
   Fabric_Addr ddr4_0_uncached_addr_size = 'h_4000_0000;    // 1G
   Fabric_Addr ddr4_0_uncached_addr_lim  = ddr4_0_uncached_addr_base + ddr4_0_uncached_addr_size;

   Fabric_Addr ddr4_0_cached_addr_base = 'h_C000_0000;
   Fabric_Addr ddr4_0_cached_addr_size = 'h_4000_0000;    // 1G
   Fabric_Addr ddr4_0_cached_addr_lim  = ddr4_0_cached_addr_base + ddr4_0_cached_addr_size;

(* synthesize *)
module mkAXI4_Fabric_2x2(AXI4_Fabric_IFC#(2, 2, 4, 64, 64, 0));

    function Tuple2 #(Bool, Bit #(TLog #(2))) fn_addr_to_slave_num(Bit #(64) addr);
	if ((ddr4_0_uncached_addr_base <= addr) && (addr < ddr4_0_uncached_addr_lim)) begin
	   return tuple2(True, 0);
	end
	else if ((ddr4_0_cached_addr_base <= addr) && (addr < ddr4_0_cached_addr_lim)) begin
	   return tuple2(True, 0);
	end
	else begin
	   return tuple2(True, 1);
	end
    endfunction

   AXI4_Fabric_IFC#(2, 2, 4, 64, 64, 0) axiFabric <- mkAXI4_Fabric(fn_addr_to_slave_num);

   method reset = axiFabric.reset;
   method set_verbosity = axiFabric.set_verbosity;
   interface v_from_masters = axiFabric.v_from_masters;
   interface v_to_slaves = axiFabric.v_to_slaves;
endmodule

module mkAWSP2#(AWSP2_Response response)(AWSP2);

   P2_Core_IFC p2_core <- mkP2_Core();

   Reg#(Bit#(4)) rg_verbosity <- mkReg(0);
   Reg#(Bool) rg_ready <- mkReg(False);

   Vector#(16, Reg#(Bit#(8)))    objIds <- replicateM(mkReg(0));

   // FIXME: add boot ROM slave interface
`define USE_FABRIC_2X2
`ifdef USE_FABRIC_2X2
   AXI4_Fabric_IFC#(2, 2, 4, 64, 64, 0) axiFabric <- mkAXI4_Fabric_2x2();
   mkConnection(p2_core.master0, axiFabric.v_from_masters[0]);
   mkConnection(p2_core.master1, axiFabric.v_from_masters[1]);
   let to_slave0 = axiFabric.v_to_slaves[0];
   let to_slave1 = axiFabric.v_to_slaves[1];
`else
   let to_slave0 = p2_core.master0;
   let to_slave1 = p2_core.master1;
`endif

   FIFOF#(MemRequest) readReqFifo0 <- mkFIFOF();
   FIFOF#(MemRequest) writeReqFifo0 <- mkFIFOF();
   FIFOF#(MemData#(DataBusWidth))   readDataFifo0 <- mkSizedBRAMFIFOF(64);
   FIFOF#(MemData#(DataBusWidth))   writeDataFifo0 <- mkSizedBRAMFIFOF(64);
   FIFOF#(Bit#(MemTagSize)) doneFifo0 <- mkFIFOF();

   Wire#(Bool) w_arready0 <- mkDWire(False);
   Wire#(Bool) w_awready0 <- mkDWire(False);
   Wire#(Bool) w_wready0  <- mkDWire(False);
   Wire#(Bool) w_rready0  <- mkDWire(False);
   Wire#(Bool) w_rvalid0  <- mkDWire(False);

   FIFOF#(MemRequest) readReqFifo1 <- mkFIFOF();
   FIFOF#(MemRequest) writeReqFifo1 <- mkFIFOF();
   FIFOF#(MemData#(DataBusWidth))   readDataFifo1 <- mkSizedBRAMFIFOF(64);
   FIFOF#(MemData#(DataBusWidth))   writeDataFifo1 <- mkSizedBRAMFIFOF(64);
   FIFOF#(Bit#(MemTagSize)) doneFifo1 <- mkFIFOF();

   Wire#(Bool) w_arready1 <- mkDWire(False);
   Wire#(Bool) w_awready1 <- mkDWire(False);
   Wire#(Bool) w_wready1  <- mkDWire(False);
   Wire#(Bool) w_rready1  <- mkDWire(False);
   Wire#(Bool) w_rvalid1  <- mkDWire(False);

   rule master0_handshake;
      to_slave0.m_awready(w_awready0);
      to_slave0.m_arready(w_arready0);
      to_slave0.m_wready(w_wready0);
   endrule

   rule debug0 if (False);
      if (to_slave0.m_arvalid()
         || w_arready0
         || w_rvalid0
         || to_slave0.m_rready())
         $display("master0 arvalid %d arready %d rvalid %d rready %d", to_slave0.m_arvalid(), w_arready0, w_rvalid0, to_slave0.m_rready());
   endrule

   rule master0_aw if (rg_ready);
      if (to_slave0.m_awvalid()) begin
          let awaddr = to_slave0.m_awaddr();
          let len    = to_slave0.m_awlen();
          let size   = to_slave0.m_awsize();
          let awid   = to_slave0.m_awid();

          Bit#(4)  objNumber = truncate(awaddr >> 28);
          Bit#(28) objOffset = truncate(awaddr);
          let objId = objIds[objNumber];
          let burstLen = 8 * (len + 1);
          $display("master0 awaddr %h len=%d size=%d id=%d objId=%d objOffset=%h", awaddr, len, size, awid, objId, objOffset);
          writeReqFifo0.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: extend(burstLen), tag: extend(awid) });
      end
      w_awready0 <= writeReqFifo0.notFull();
   endrule

   rule master0_wdata if (rg_ready);
      if (to_slave0.m_wvalid()) begin
          let wdata = to_slave0.m_wdata;
          let wstrb = to_slave0.m_wstrb;
          let wlast = to_slave0.m_wlast;
          $display("master0 wdata %h wstrb %h", wdata, wstrb);
          writeDataFifo0.enq(MemData { data: wdata, tag: 0, last: wlast});
       end
       w_wready0 <= writeDataFifo0.notFull();
    endrule

   rule master0_b if (rg_ready);
      let bvalid = doneFifo0.notEmpty();
      let bid    = doneFifo0.first();
      let bresp = 0;
      let buser = 0;
      to_slave0.m_bvalid(bvalid, truncate(bid), bresp, buser);
      if (to_slave0.m_bready()) begin
          doneFifo0.deq();
      end
   endrule

   rule master0_ar if (rg_ready);
      if (to_slave0.m_arvalid()) begin
          let araddr = to_slave0.m_araddr();
          let len    = to_slave0.m_arlen();
          let size   = to_slave0.m_arsize();
          let arid   = to_slave0.m_arid();

          Bit#(4) objNumber = truncate(araddr >> 28);
          Bit#(28) objOffset = truncate(araddr);

          let objId = objIds[objNumber];
          let burstLen = 8 * (len + 1);
          $display("master0 araddr %h len=%d size=%d id=%d objId=%d objOffset=%h", araddr, len, size, arid, objId, objOffset);
          readReqFifo0.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: extend(burstLen), tag: extend(arid) });
      end
      w_arready0 <= readReqFifo0.notFull();

   endrule

   rule master0_rdata if (rg_ready);
      let rdata = readDataFifo0.first;
      $display("master0 rdata data %h rid %d last %d", rdata.data, rdata.tag, rdata.last);

      w_rvalid0 <= readDataFifo0.notEmpty();
      to_slave0.m_rvalid(readDataFifo0.notEmpty(),
                               truncate(rdata.tag),
                               rdata.data,
                               0,  // rresp
                               rdata.last,
                               0); // ruser


      if (to_slave0.m_rready()) begin
          //$display("master0_rdata_deq rvalid %d rready %d", w_rvalid0, to_slave0.m_rready());
         readDataFifo0.deq();
      end
   endrule

   rule master1_handshake;
      to_slave1.m_awready(w_awready1);
      to_slave1.m_arready(w_arready1);
      to_slave1.m_wready(w_wready1);
   endrule

   rule debug1 if (False);
      if (to_slave1.m_arvalid()
         || w_arready1
         || w_rvalid1
         || to_slave1.m_rready())
         $display("master1 arvalid %d arready %d rvalid %d rready %d", to_slave1.m_arvalid(), w_arready1, w_rvalid1, to_slave1.m_rready());
   endrule

   rule master1_aw if (rg_ready);
      if (to_slave1.m_awvalid()) begin
          let awaddr = to_slave1.m_awaddr();
          let len    = to_slave1.m_awlen();
          let size   = to_slave1.m_awsize();
          let awid   = to_slave1.m_awid();

          Bit#(4)  objNumber = truncate(awaddr >> 28);
          Bit#(28) objOffset = truncate(awaddr);
          let objId = objIds[objNumber];
          let burstLen = 8 * (len + 1);
          $display("master1 awaddr %h len=%d size=%d id=%d objId=%d objOffset=%h", awaddr, len, size, awid, objId, objOffset);
          writeReqFifo1.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: extend(burstLen), tag: extend(awid) });
      end
      w_awready1 <= writeReqFifo1.notFull();
   endrule

   rule master1_wdata if (rg_ready);
      if (to_slave1.m_wvalid()) begin
          let wdata = to_slave1.m_wdata;
          let wstrb = to_slave1.m_wstrb;
          let wlast = to_slave1.m_wlast;
          $display("master1 wdata %h wstrb %h", wdata, wstrb);
          writeDataFifo1.enq(MemData { data: wdata, tag: 1, last: wlast});
       end
       w_wready1 <= writeDataFifo1.notFull();
    endrule

   rule master1_b if (rg_ready);
      let bvalid = doneFifo1.notEmpty();
      let bid    = doneFifo1.first();
      let bresp = 0;
      let buser = 0;
      to_slave1.m_bvalid(bvalid, truncate(bid), bresp, buser);
      if (to_slave1.m_bready()) begin
          doneFifo1.deq();
      end
   endrule

   rule master1_ar if (rg_ready);
      if (to_slave1.m_arvalid()) begin
          let araddr = to_slave1.m_araddr();
          let len    = to_slave1.m_arlen();
          let size   = to_slave1.m_arsize();
          let arid   = to_slave1.m_arid();

          Bit#(4) objNumber = truncate(araddr >> 28);
          Bit#(28) objOffset = truncate(araddr);

          let objId = objIds[objNumber];
          let burstLen = 8 * (len + 1);
          $display("master1 araddr %h len=%d size=%d id=%d objId=%d objOffset=%h", araddr, len, size, arid, objId, objOffset);
          readReqFifo1.enq(MemRequest { sglId: extend(objId), offset: extend(objOffset), burstLen: extend(burstLen), tag: extend(arid) });
      end
      w_arready1 <= readReqFifo1.notFull();

   endrule

   rule master1_rdata if (rg_ready);
      let rdata = readDataFifo1.first;
      $display("master1 rdata data %h rid %d last %d", rdata.data, rdata.tag, rdata.last);

      w_rvalid1 <= readDataFifo1.notEmpty();
      to_slave1.m_rvalid(readDataFifo1.notEmpty(),
                               truncate(rdata.tag),
                               rdata.data,
                               0,  // rresp
                               rdata.last,
                               0); // ruser


      if (to_slave1.m_rready()) begin
          //$display("master1_rdata_deq rvalid %d rready %d", w_rvalid1, to_slave1.m_rready());
         readDataFifo1.deq();
      end
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
          rg_ready <= True;
      endmethod
   endinterface

   interface readClients = vec(readClient0, readClient1);
   interface writeClients = vec(writeClient0, writeClient1);

endmodule
