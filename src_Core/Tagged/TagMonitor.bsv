import DefaultValue::*;
import Vector::*;
import TagUtil::*;
import TagPolicy::*;

import ISA_Decls :: *;

export TagMonitor, mkTagMonitor, TagT(..);

typedef Struct2 TagT;
typedef Struct3 ArgsAndCsrs;
typedef Module2 Policy;

interface TagPolicy;
   interface Module1 default_op;
   interface Module2 policy;
endinterface

module mkTagPolicy (TagPolicy);
    Module1 m1 <-  mkModule1 ();
    Module2 m2 <-  mkModule2 (m1.default_public_access_op);
    interface default_op = m1;
    interface policy = m2;
endmodule

module mkTagMonitor#(Bool tagActive, Vector#(8, Bit#(XLEN)) tagCSRs)(TagMonitor#(XLEN, Struct2));
    TagPolicy tp <- mkTagPolicy();
    Module1 default_op = tp.default_op;
    Policy policy = tp.policy;

    function TagT applyTagFn(function TagT tag_fn(ArgsAndCsrs args), TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result);
        StructEx a = StructEx { a: tagActive,
	                        aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
	                        aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7] };
        ArgsAndCsrs args = ArgsAndCsrs { a: a,
	                                 aaaa: Struct4 { data: v1.data, tag: v1.tag },
	                                 aaaaa: Struct4 { data: v2.data, tag: v2.tag },
					 aaaaaa: result };
        TagT newtag = tag_fn(args);
	return newtag;
    endfunction

    method TagT alu_add(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_add, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_addw( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_addw, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_sub(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_sub, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_subw( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_subw, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_and(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_and, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_or(   TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_or, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_xor(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_xor, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_slt(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_slt, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_sltu( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_sltu, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_sll(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_sll, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_sllw( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_sllw, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_srl(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_srl, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_sra(  TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_sra, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_srlw( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_srlw, v1, v2, result);
	return newtag;
    endmethod
    method TagT alu_sraw( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
        TagT newtag = applyTagFn(policy.alu_sraw, v1, v2, result);
	return newtag;
    endmethod
    method Bool  is_legal_load_address( TaggedData#(XLEN, TagT) addr, Bit#(XLEN) pc );
       //FIXME
       return False;
    endmethod
    method Bool  is_legal_store_address( TaggedData#(XLEN, TagT) addr, Bit#(XLEN) pc );
       //FIXME
       return False;
    endmethod
    method Bool  is_legal_next_pc( TaggedData#(XLEN, TagT) next_pc );
       //FIXME
       return False;
    endmethod

    method TagT default_tag_op( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
       TagT x6 = default_op.default_public_access_op(Struct1 { a: v1.tag, aa: v2.tag });
       return x6;
    endmethod
    method TagT constant_tag( Bit#(XLEN) x );
        StructEx a = StructEx { a: tagActive,
	                        aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
	                        aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7] };
	return policy.constant_tag(Struct5 { a: a, aaaa: x });
    endmethod
    method TagT pc_tag( Bit#(XLEN) x );
        StructEx a = StructEx { a: tagActive,
	                        aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
	                        aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7] };
	return policy.pc_tag(Struct5 { a: a, aaaa: x });
    endmethod
    method TagT unknown_tag( Bit#(XLEN) x );
        StructEx a = StructEx { a: tagActive,
	                        aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
	                        aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7] };
	return policy.unknown_tag(Struct5 { a: a, aaaa: x });
    endmethod

endmodule
