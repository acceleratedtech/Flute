import Vector::*;

typedef struct {
    Bit#(xlen)  data;
    tag_t       tag;
} TaggedData#(numeric type xlen, type tag_t) deriving (Bits, Eq, FShow);

function TaggedData#(xlen, tag_t) applyTagFn( function tag_t tag_fn( Bit#(xlen) res ) , Bit#(xlen) result );
    return TaggedData{ data: result, tag: tag_fn(result) };
endfunction

interface TagMonitor#(numeric type xlen, type tag_t);
    method tag_t alu_add(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_addw( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_sub(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_subw( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_and(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_or(   TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_xor(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_slt(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_sltu( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_sll(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_sllw( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_srl(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_sra(  TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_srlw( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t alu_sraw( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );

    method Bool  is_legal_load_address( TaggedData#(xlen, tag_t) addr, Bit#(xlen) pc );
    method Bool  is_legal_store_address( TaggedData#(xlen, tag_t) addr, Bit#(xlen) pc );
    method Bool  is_legal_next_pc( TaggedData#(xlen, tag_t) next_pc );

    method tag_t default_tag_op( TaggedData#(xlen, tag_t) a, TaggedData#(xlen, tag_t) b, Bit#(xlen) result );
    method tag_t constant_tag( Bit#(xlen) x );
    method tag_t pc_tag( Bit#(xlen) x );
    method tag_t unknown_tag( Bit#(xlen) x );
endinterface

TagMonitor#(xlen, void) voidTagMonitor =
    interface TagMonitor;
        method void alu_add(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_addw( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_sub(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_subw( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_and(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_or(   TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_xor(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_slt(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_sltu( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_sll(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_sllw( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_srl(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_sra(  TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_srlw( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void alu_sraw( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;

        method Bool is_legal_load_address( TaggedData#(xlen, void) addr, Bit#(xlen) pc ) = True;
        method Bool is_legal_store_address( TaggedData#(xlen, void) addr, Bit#(xlen) pc ) = True;
        method Bool is_legal_next_pc( TaggedData#(xlen, void) next_pc ) = True;

        method void default_tag_op( TaggedData#(xlen, void) a, TaggedData#(xlen, void) b, Bit#(xlen) result ) = ?;
        method void constant_tag( Bit#(xlen) x ) = ?;
        method void pc_tag( Bit#(xlen) x ) = ?;
        method void unknown_tag( Bit#(xlen) x ) = ?;
    endinterface;

(* synthesize *)
module mkVoidTagMonitor(TagMonitor#(64, void));
    return voidTagMonitor;
endmodule
