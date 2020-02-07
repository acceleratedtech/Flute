
import DefaultValue::*;
import Vector::*;
import TagMonitor_IFC::*;

`ifdef OVERFLOW_POLICY
import OverflowPolicy       ::*;
`endif
`ifdef PUBLIC_ACCESS_POLICY
import PublicAccessPolicy   :: *;
`endif
`ifdef SIZED_POINTER_POLICY
import SizedPointerPolicy   :: *;
`endif
`ifdef USER_INFLUENCED_POLICY
import UserInfluencedPolicy :: *;
`endif

import ISA_Decls :: *;

export TagMonitor, mkTagMonitor, TagT(..), TaggedData(..);

typedef Struct2 TagT;
typedef Struct3 ArgsAndCsrs;
typedef Module2 Policy;

module mkTagMonitor#(Bit#(XLEN) tagctrl, Vector#(8, Bit#(XLEN)) tagCSRs)(TagMonitor#(XLEN, TagT));
`ifdef OVERFLOW_POLICY
    let tp <- mkOverflowPolicy();
`endif
`ifdef PUBLIC_ACCESS_POLICY
    let tp <- mkPublicAccessPolicy();
`endif
`ifdef SIZED_POINTER_POLICY :: *;
    let tp <- mkSizedPointerPolicy();
`endif
`ifdef USER_INFLUENCED_POLICY
    let tp <- mkUserInfluencedPolicy();
`endif
    let policy = tp.policy;

    Bool tagActive = unpack(tagctrl[0]);

    function TagT applyTagFn(function TagT tag_fn(ArgsAndCsrs args), TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result);
        Struct3 args = Struct3 { a: tagActive,
                                aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
                                aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
                                aaaaaaaaaa: Struct4 { data: v1.data, tag: v1.tag },
                                aaaaaaaaaaa: Struct4 { data: v2.data, tag: v2.tag },
                                aaaaaaaaaaaa: result };
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
        Struct7 args = Struct7 { a: tagActive,
                                aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
                                aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
                                aaaaaaaaaa:  Struct4 { data: addr.data, tag: addr.tag },
                                aaaaaaaaaaa: pc };
        Bool is_legal = policy.is_legal_load_address(args);
        return is_legal;
    endmethod
    method Bool  is_legal_store_address( TaggedData#(XLEN, TagT) addr, Bit#(XLEN) pc );
        Struct7 args = Struct7 { a: tagActive,
				aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
				aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
				aaaaaaaaaa:  Struct4 { data: addr.data, tag: addr.tag },
				aaaaaaaaaaa: pc };
        Bool is_legal = policy.is_legal_store_address(args);
        return is_legal;
    endmethod
    method Bool  is_legal_next_pc( TaggedData#(XLEN, TagT) next_pc );
        Struct6 args = Struct6 { a: tagActive,
				aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
				aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
				aaaaaaaaaa:  Struct4 { data: next_pc.data, tag: next_pc.tag } };
        Bool is_legal = policy.is_legal_next_pc(args);
        return is_legal;
    endmethod

    method TagT default_tag_op( TaggedData#(XLEN, TagT) v1, TaggedData#(XLEN, TagT) v2, Bit#(XLEN) result );
       //TagT x6 = default_op.default_public_access_op(Struct1 { a: v1.tag, aa: v2.tag });
       return defaultValue;
    endmethod
    method TagT constant_tag( Bit#(XLEN) x );
        Struct5 args = Struct5 { a: tagActive,
				aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
				aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
				aaaaaaaaaa: x };
        return policy.constant_tag(args);
    endmethod
    method TagT pc_tag( Bit#(XLEN) x );
        Struct5 args = Struct5 { a: tagActive,
				aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
				aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
				aaaaaaaaaa: x };
        return policy.pc_tag(args);
    endmethod
    method TagT unknown_tag( Bit#(XLEN) x );
        Struct5 args = Struct5 { a: tagActive,
				aa: tagCSRs[0],     aaa:     tagCSRs[1],     aaaa: tagCSRs[2], aaaaa:     tagCSRs[3],
				aaaaaa: tagCSRs[4], aaaaaaa: tagCSRs[5], aaaaaaaa: tagCSRs[6], aaaaaaaaa: tagCSRs[7],
				aaaaaaaaaa: x };
        return policy.unknown_tag(args);
    endmethod

endmodule
