---- MODULE PCCallReturn ----
EXTENDS Naturals 
CONSTANTS Input, RtnVal(_) 

Output == {RtnVal(v) : v \in Input}

VARIABLE iFace

CRTypeOk == iFace \in [arg |-> Input, aBit |-> {0,1},
                        rtn |-> Output, rBit |-> {0,1}]

CRInit == \E v \in Input, w \in Output: 
            iFace = [arg |-> v,         aBit |-> 0,
                     rtn |-> w, rBit |-> 0]

Call(v) == iFace' = [arg |-> v,        aBit |-> (iFace.aBit + 1)%2,
                     rtn |-> iFace.rtn, rBit |-> iFace.rBit]

Return(w) == iFace' = [arg |-> iFace.arg, aBit |-> iFace.aBit,
                       rtn |-> w,         rBit |-> (iFace.rBit + 1)%2]
====