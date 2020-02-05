//
// Generated by the MIT HSC
//

import Vector::*;
import DefaultValue::*;

typedef struct { Struct2 a; Struct2 aa;  } Struct1 deriving(Eq, Bits);
typedef struct { Bool is_secret;  } Struct2 deriving(Eq, Bits, DefaultValue, FShow);

typedef Struct2 TagT;

typedef struct {
   Bool a; 
   Bit#(64) aa; Bit#(64) aaa; Bit#(64) aaaa; Bit#(64) aaaaa;
   Bit#(64) aaaaaa; Bit#(64) aaaaaaa; Bit#(64) aaaaaaaa; Bit#(64) aaaaaaaaa;
} StructEx deriving(Eq, Bits);

typedef struct { Bit#(64) data; Struct2 tag;  } Struct4 deriving(Eq, Bits);

typedef struct { StructEx a; Struct4 aaaa; Struct4 aaaaa; Bit#(64) aaaaaa;  } Struct3 deriving(Eq, Bits);
typedef struct { StructEx a; Bit#(64) aaaa;  } Struct5 deriving(Eq, Bits);
typedef struct { StructEx a; Struct4 aaaa;  } Struct6 deriving(Eq, Bits);
typedef struct { StructEx a; Struct4 aaaa; Bit#(64) aaaaa;  } Struct7 deriving(Eq, Bits);

interface Module1;
    method Struct2 default_public_access_op (Struct1 x_0);
    
endinterface

module mkModule1 (Module1);
    
    // No rules in this module
    
    method Struct2 default_public_access_op (Struct1 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Struct2 x_2 = ((x_0).a);
        Struct2 x_3 = ((x_0).aa);
        Struct2 x_4 = (Struct2 {is_secret : ((x_2).is_secret) ||
        ((x_3).is_secret)});
        return x_4;
    endmethod
    
endmodule

interface Module2;
    method Struct2 alu_add (Struct3 x_0);
    method Struct2 alu_addw (Struct3 x_0);
    method Struct2 alu_sub (Struct3 x_0);
    method Struct2 alu_subw (Struct3 x_0);
    method Struct2 alu_and (Struct3 x_0);
    method Struct2 alu_or (Struct3 x_0);
    method Struct2 alu_xor (Struct3 x_0);
    method Struct2 alu_slt (Struct3 x_0);
    method Struct2 alu_sltu (Struct3 x_0);
    method Struct2 alu_sll (Struct3 x_0);
    method Struct2 alu_sllw (Struct3 x_0);
    method Struct2 alu_srl (Struct3 x_0);
    method Struct2 alu_sra (Struct3 x_0);
    method Struct2 alu_srlw (Struct3 x_0);
    method Struct2 alu_sraw (Struct3 x_0);
    method Struct2 unknown_tag (Struct5 x_0);
    method Struct2 pc_tag (Struct5 x_0);
    method Struct2 constant_tag (Struct5 x_0);
    method Bool is_legal_next_pc (Struct6 x_0);
    method Bool is_legal_store_address (Struct7 x_0);
    method Bool is_legal_load_address (Struct7 x_0);
    
endinterface


module
  mkModule2#(function Struct2 default_public_access_op(Struct1 _))(Module2);
    
    // No rules in this module
    
    method Struct2 alu_add (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_addw (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_sub (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_subw (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_and (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_or (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_xor (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_slt (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_sltu (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_sll (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_sllw (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_srl (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_sra (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_srlw (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 alu_sraw (Struct3 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Struct4 x_6 = ((x_0).aaaaa);
        Bit#(64) x_7 = ((x_0).aaaaaa);
        let x_8 =  default_public_access_op(Struct1 {a : (x_5).tag, aa :
        (x_6).tag});
        Struct2 x_9 = (x_8);
        return x_9;
    endmethod
    
    method Struct2 unknown_tag (Struct5 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Bit#(64) x_5 = ((x_0).aaaa);
        Struct2 x_6 = (Struct2 {is_secret : (Bool)'(False)});
        return x_6;
    endmethod
    
    method Struct2 pc_tag (Struct5 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Bit#(64) x_5 = ((x_0).aaaa);
        Struct2 x_6 = (Struct2 {is_secret : (Bool)'(False)});
        return x_6;
    endmethod
    
    method Struct2 constant_tag (Struct5 x_0);
        Struct2 x_1 = ((Struct2)'(Struct2 {is_secret: False}));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Bit#(64) x_5 = ((x_0).aaaa);
        Struct2 x_6 = (Struct2 {is_secret : (Bool)'(False)});
        return x_6;
    endmethod
    
    method Bool is_legal_next_pc (Struct6 x_0);
        Bool x_1 = ((Bool)'(False));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Bool x_6 = ((Bool)'(True));
        return x_6;
    endmethod
    
    method Bool is_legal_store_address (Struct7 x_0);
        Bool x_1 = ((Bool)'(False));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Bit#(64) x_6 = ((x_0).aaaaa);
        Bool x_7 = ((((x_5).tag).is_secret ? ((((x_3) < (x_6)) || (! ((x_6) <
        (x_3)))) && (((x_6) < (x_4)) || (! ((x_4) < (x_6))))) :
        ((Bool)'(True))));
        return x_7;
    endmethod
    
    method Bool is_legal_load_address (Struct7 x_0);
        Bool x_1 = ((Bool)'(False));
        Bool x_2 = ((x_0).a.a);
        Bit#(64) x_3 = ((x_0).a.aa);
        Bit#(64) x_4 = ((x_0).a.aaa);
        Struct4 x_5 = ((x_0).aaaa);
        Bit#(64) x_6 = ((x_0).aaaaa);
        Bool x_7 = ((((x_5).tag).is_secret ? ((((x_3) < (x_6)) || (! ((x_6) <
        (x_3)))) && (((x_6) < (x_4)) || (! ((x_4) < (x_6))))) :
        ((Bool)'(True))));
        return x_7;
    endmethod
    
endmodule
