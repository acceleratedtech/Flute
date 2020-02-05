//
// Generated by Bluespec Compiler, version 2017.07.A (build 1da80f1, 2017-07-21)
//
// On Thu Feb  6 15:23:00 EST 2020
//
//
// Ports:
// Name                         I/O  size props
// RDY_alu_add                    O     1 const
// RDY_alu_addw                   O     1 const
// RDY_alu_sub                    O     1 const
// RDY_alu_subw                   O     1 const
// RDY_alu_and                    O     1 const
// RDY_alu_or                     O     1 const
// RDY_alu_xor                    O     1 const
// RDY_alu_slt                    O     1 const
// RDY_alu_sltu                   O     1 const
// RDY_alu_sll                    O     1 const
// RDY_alu_sllw                   O     1 const
// RDY_alu_srl                    O     1 const
// RDY_alu_sra                    O     1 const
// RDY_alu_srlw                   O     1 const
// RDY_alu_sraw                   O     1 const
// is_legal_load_address          O     1 const
// RDY_is_legal_load_address      O     1 const
// is_legal_store_address         O     1 const
// RDY_is_legal_store_address     O     1 const
// is_legal_next_pc               O     1 const
// RDY_is_legal_next_pc           O     1 const
// RDY_default_tag_op             O     1 const
// RDY_constant_tag               O     1 const
// RDY_pc_tag                     O     1 const
// RDY_unknown_tag                O     1 const
// CLK                            I     1 unused
// RST_N                          I     1 unused
// alu_add_a                      I    64 unused
// alu_add_b                      I    64 unused
// alu_add_result                 I    64 unused
// alu_addw_a                     I    64 unused
// alu_addw_b                     I    64 unused
// alu_addw_result                I    64 unused
// alu_sub_a                      I    64 unused
// alu_sub_b                      I    64 unused
// alu_sub_result                 I    64 unused
// alu_subw_a                     I    64 unused
// alu_subw_b                     I    64 unused
// alu_subw_result                I    64 unused
// alu_and_a                      I    64 unused
// alu_and_b                      I    64 unused
// alu_and_result                 I    64 unused
// alu_or_a                       I    64 unused
// alu_or_b                       I    64 unused
// alu_or_result                  I    64 unused
// alu_xor_a                      I    64 unused
// alu_xor_b                      I    64 unused
// alu_xor_result                 I    64 unused
// alu_slt_a                      I    64 unused
// alu_slt_b                      I    64 unused
// alu_slt_result                 I    64 unused
// alu_sltu_a                     I    64 unused
// alu_sltu_b                     I    64 unused
// alu_sltu_result                I    64 unused
// alu_sll_a                      I    64 unused
// alu_sll_b                      I    64 unused
// alu_sll_result                 I    64 unused
// alu_sllw_a                     I    64 unused
// alu_sllw_b                     I    64 unused
// alu_sllw_result                I    64 unused
// alu_srl_a                      I    64 unused
// alu_srl_b                      I    64 unused
// alu_srl_result                 I    64 unused
// alu_sra_a                      I    64 unused
// alu_sra_b                      I    64 unused
// alu_sra_result                 I    64 unused
// alu_srlw_a                     I    64 unused
// alu_srlw_b                     I    64 unused
// alu_srlw_result                I    64 unused
// alu_sraw_a                     I    64 unused
// alu_sraw_b                     I    64 unused
// alu_sraw_result                I    64 unused
// is_legal_load_address_addr     I    64 unused
// is_legal_load_address_pc       I    64 unused
// is_legal_store_address_addr    I    64 unused
// is_legal_store_address_pc      I    64 unused
// is_legal_next_pc_next_pc       I    64 unused
// default_tag_op_a               I    64 unused
// default_tag_op_b               I    64 unused
// default_tag_op_result          I    64 unused
// constant_tag_x                 I    64 unused
// pc_tag_x                       I    64 unused
// unknown_tag_x                  I    64 unused
//
// No combinational paths from inputs to outputs
//
//

`ifdef BSV_ASSIGNMENT_DELAY
`else
  `define BSV_ASSIGNMENT_DELAY
`endif

`ifdef BSV_POSITIVE_RESET
  `define BSV_RESET_VALUE 1'b1
  `define BSV_RESET_EDGE posedge
`else
  `define BSV_RESET_VALUE 1'b0
  `define BSV_RESET_EDGE negedge
`endif

module mkVoidTagMonitor(CLK,
			RST_N,

			alu_add_a,
			alu_add_b,
			alu_add_result,
			RDY_alu_add,

			alu_addw_a,
			alu_addw_b,
			alu_addw_result,
			RDY_alu_addw,

			alu_sub_a,
			alu_sub_b,
			alu_sub_result,
			RDY_alu_sub,

			alu_subw_a,
			alu_subw_b,
			alu_subw_result,
			RDY_alu_subw,

			alu_and_a,
			alu_and_b,
			alu_and_result,
			RDY_alu_and,

			alu_or_a,
			alu_or_b,
			alu_or_result,
			RDY_alu_or,

			alu_xor_a,
			alu_xor_b,
			alu_xor_result,
			RDY_alu_xor,

			alu_slt_a,
			alu_slt_b,
			alu_slt_result,
			RDY_alu_slt,

			alu_sltu_a,
			alu_sltu_b,
			alu_sltu_result,
			RDY_alu_sltu,

			alu_sll_a,
			alu_sll_b,
			alu_sll_result,
			RDY_alu_sll,

			alu_sllw_a,
			alu_sllw_b,
			alu_sllw_result,
			RDY_alu_sllw,

			alu_srl_a,
			alu_srl_b,
			alu_srl_result,
			RDY_alu_srl,

			alu_sra_a,
			alu_sra_b,
			alu_sra_result,
			RDY_alu_sra,

			alu_srlw_a,
			alu_srlw_b,
			alu_srlw_result,
			RDY_alu_srlw,

			alu_sraw_a,
			alu_sraw_b,
			alu_sraw_result,
			RDY_alu_sraw,

			is_legal_load_address_addr,
			is_legal_load_address_pc,
			is_legal_load_address,
			RDY_is_legal_load_address,

			is_legal_store_address_addr,
			is_legal_store_address_pc,
			is_legal_store_address,
			RDY_is_legal_store_address,

			is_legal_next_pc_next_pc,
			is_legal_next_pc,
			RDY_is_legal_next_pc,

			default_tag_op_a,
			default_tag_op_b,
			default_tag_op_result,
			RDY_default_tag_op,

			constant_tag_x,
			RDY_constant_tag,

			pc_tag_x,
			RDY_pc_tag,

			unknown_tag_x,
			RDY_unknown_tag);
  input  CLK;
  input  RST_N;

  // value method alu_add
  input  [63 : 0] alu_add_a;
  input  [63 : 0] alu_add_b;
  input  [63 : 0] alu_add_result;
  output RDY_alu_add;

  // value method alu_addw
  input  [63 : 0] alu_addw_a;
  input  [63 : 0] alu_addw_b;
  input  [63 : 0] alu_addw_result;
  output RDY_alu_addw;

  // value method alu_sub
  input  [63 : 0] alu_sub_a;
  input  [63 : 0] alu_sub_b;
  input  [63 : 0] alu_sub_result;
  output RDY_alu_sub;

  // value method alu_subw
  input  [63 : 0] alu_subw_a;
  input  [63 : 0] alu_subw_b;
  input  [63 : 0] alu_subw_result;
  output RDY_alu_subw;

  // value method alu_and
  input  [63 : 0] alu_and_a;
  input  [63 : 0] alu_and_b;
  input  [63 : 0] alu_and_result;
  output RDY_alu_and;

  // value method alu_or
  input  [63 : 0] alu_or_a;
  input  [63 : 0] alu_or_b;
  input  [63 : 0] alu_or_result;
  output RDY_alu_or;

  // value method alu_xor
  input  [63 : 0] alu_xor_a;
  input  [63 : 0] alu_xor_b;
  input  [63 : 0] alu_xor_result;
  output RDY_alu_xor;

  // value method alu_slt
  input  [63 : 0] alu_slt_a;
  input  [63 : 0] alu_slt_b;
  input  [63 : 0] alu_slt_result;
  output RDY_alu_slt;

  // value method alu_sltu
  input  [63 : 0] alu_sltu_a;
  input  [63 : 0] alu_sltu_b;
  input  [63 : 0] alu_sltu_result;
  output RDY_alu_sltu;

  // value method alu_sll
  input  [63 : 0] alu_sll_a;
  input  [63 : 0] alu_sll_b;
  input  [63 : 0] alu_sll_result;
  output RDY_alu_sll;

  // value method alu_sllw
  input  [63 : 0] alu_sllw_a;
  input  [63 : 0] alu_sllw_b;
  input  [63 : 0] alu_sllw_result;
  output RDY_alu_sllw;

  // value method alu_srl
  input  [63 : 0] alu_srl_a;
  input  [63 : 0] alu_srl_b;
  input  [63 : 0] alu_srl_result;
  output RDY_alu_srl;

  // value method alu_sra
  input  [63 : 0] alu_sra_a;
  input  [63 : 0] alu_sra_b;
  input  [63 : 0] alu_sra_result;
  output RDY_alu_sra;

  // value method alu_srlw
  input  [63 : 0] alu_srlw_a;
  input  [63 : 0] alu_srlw_b;
  input  [63 : 0] alu_srlw_result;
  output RDY_alu_srlw;

  // value method alu_sraw
  input  [63 : 0] alu_sraw_a;
  input  [63 : 0] alu_sraw_b;
  input  [63 : 0] alu_sraw_result;
  output RDY_alu_sraw;

  // value method is_legal_load_address
  input  [63 : 0] is_legal_load_address_addr;
  input  [63 : 0] is_legal_load_address_pc;
  output is_legal_load_address;
  output RDY_is_legal_load_address;

  // value method is_legal_store_address
  input  [63 : 0] is_legal_store_address_addr;
  input  [63 : 0] is_legal_store_address_pc;
  output is_legal_store_address;
  output RDY_is_legal_store_address;

  // value method is_legal_next_pc
  input  [63 : 0] is_legal_next_pc_next_pc;
  output is_legal_next_pc;
  output RDY_is_legal_next_pc;

  // value method default_tag_op
  input  [63 : 0] default_tag_op_a;
  input  [63 : 0] default_tag_op_b;
  input  [63 : 0] default_tag_op_result;
  output RDY_default_tag_op;

  // value method constant_tag
  input  [63 : 0] constant_tag_x;
  output RDY_constant_tag;

  // value method pc_tag
  input  [63 : 0] pc_tag_x;
  output RDY_pc_tag;

  // value method unknown_tag
  input  [63 : 0] unknown_tag_x;
  output RDY_unknown_tag;

  // signals for module outputs
  wire RDY_alu_add,
       RDY_alu_addw,
       RDY_alu_and,
       RDY_alu_or,
       RDY_alu_sll,
       RDY_alu_sllw,
       RDY_alu_slt,
       RDY_alu_sltu,
       RDY_alu_sra,
       RDY_alu_sraw,
       RDY_alu_srl,
       RDY_alu_srlw,
       RDY_alu_sub,
       RDY_alu_subw,
       RDY_alu_xor,
       RDY_constant_tag,
       RDY_default_tag_op,
       RDY_is_legal_load_address,
       RDY_is_legal_next_pc,
       RDY_is_legal_store_address,
       RDY_pc_tag,
       RDY_unknown_tag,
       is_legal_load_address,
       is_legal_next_pc,
       is_legal_store_address;

  // value method alu_add
  assign RDY_alu_add = 1'd1 ;

  // value method alu_addw
  assign RDY_alu_addw = 1'd1 ;

  // value method alu_sub
  assign RDY_alu_sub = 1'd1 ;

  // value method alu_subw
  assign RDY_alu_subw = 1'd1 ;

  // value method alu_and
  assign RDY_alu_and = 1'd1 ;

  // value method alu_or
  assign RDY_alu_or = 1'd1 ;

  // value method alu_xor
  assign RDY_alu_xor = 1'd1 ;

  // value method alu_slt
  assign RDY_alu_slt = 1'd1 ;

  // value method alu_sltu
  assign RDY_alu_sltu = 1'd1 ;

  // value method alu_sll
  assign RDY_alu_sll = 1'd1 ;

  // value method alu_sllw
  assign RDY_alu_sllw = 1'd1 ;

  // value method alu_srl
  assign RDY_alu_srl = 1'd1 ;

  // value method alu_sra
  assign RDY_alu_sra = 1'd1 ;

  // value method alu_srlw
  assign RDY_alu_srlw = 1'd1 ;

  // value method alu_sraw
  assign RDY_alu_sraw = 1'd1 ;

  // value method is_legal_load_address
  assign is_legal_load_address = 1'd1 ;
  assign RDY_is_legal_load_address = 1'd1 ;

  // value method is_legal_store_address
  assign is_legal_store_address = 1'd1 ;
  assign RDY_is_legal_store_address = 1'd1 ;

  // value method is_legal_next_pc
  assign is_legal_next_pc = 1'd1 ;
  assign RDY_is_legal_next_pc = 1'd1 ;

  // value method default_tag_op
  assign RDY_default_tag_op = 1'd1 ;

  // value method constant_tag
  assign RDY_constant_tag = 1'd1 ;

  // value method pc_tag
  assign RDY_pc_tag = 1'd1 ;

  // value method unknown_tag
  assign RDY_unknown_tag = 1'd1 ;
endmodule  // mkVoidTagMonitor

