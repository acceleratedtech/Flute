

interface AWSP2_Request;
  method Action dmi_read(Bit#(7) req_addr);
  method Action dmi_write(Bit#(7) req_addr, Bit#(32) req_data);

  method Action register_region(Bit#(32) region, Bit#(32) objectId);
  method Action memory_ready();
endinterface

interface AWSP2_Response;
  method Action dmi_read_data(Bit#(32) rsp_data);
endinterface
