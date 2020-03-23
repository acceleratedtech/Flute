
import Vector     :: *;
import AXI4_Types :: *;

interface AWSP2_Request;
  method Action set_debug_verbosity(Bit#(4) verbosity);
  method Action set_fabric_verbosity(Bit#(4) verbosity);
  method Action dmi_read(Bit#(7) req_addr);
  method Action dmi_write(Bit#(7) req_addr, Bit#(32) req_data);
  method Action dmi_status();

  method Action register_region(Bit#(32) region, Bit#(32) objectId);
  method Action memory_ready();
  method Action capture_tv_info(Bool c);

  method Action io_rdata(Bit#(64) data, Bit#(16) rid, Bit#(8) rresp, Bool last);
  method Action io_bdone(Bit#(16) bid, Bit#(8) bresp);
endinterface

interface AWSP2_Response;
  method Action dmi_read_data(Bit#(32) rsp_data);
  method Action dmi_status_data(Bit#(8) status);
  method Action io_awaddr(Bit#(32) awaddr, Bit#(16) awlen, Bit#(16) awid);
  method Action io_araddr(Bit#(32) araddr, Bit#(16) arlen, Bit#(16) arid);
  method Action io_wdata(Bit#(64) wdata, Bit#(8) wstrb);
  method Action tandem_packet(Bit#(32) num_bytes, Vector#(72, Bit#(8)) bytes);
endinterface

interface AWSP2_Pin_IFC;
  (* always_ready, always_enabled, prefix="" *)
  interface AXI4_Master_IFC#(16, 64, 512, 0) ddr;
endinterface
