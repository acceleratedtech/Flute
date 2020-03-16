

interface AWSP2_Request;
  method Action set_debug_verbosity(Bit#(4) verbosity);
  method Action set_fabric_verbosity(Bit#(4) verbosity);
  method Action dmi_read(Bit#(7) req_addr);
  method Action dmi_write(Bit#(7) req_addr, Bit#(32) req_data);

  method Action register_region(Bit#(32) region, Bit#(32) objectId);
  method Action memory_ready();

  method Action io_rdata(Bit#(64) data, Bit#(8) rid, Bit#(8) rresp);
  method Action io_bdone(Bit#(8) bresp, Bit#(8) bid);
endinterface

interface AWSP2_Response;
  method Action dmi_read_data(Bit#(32) rsp_data);
  method Action io_awaddr(Bit#(32) awaddr, Bit#(8) awlen, Bit#(8) awsize, Bit#(8) awid);
  method Action io_araddr(Bit#(32) araddr, Bit#(8) arlen, Bit#(8) arsize, Bit#(8) arid);
  method Action io_wdata(Bit#(64) wdata, Bit#(8) wstrb);
endinterface
