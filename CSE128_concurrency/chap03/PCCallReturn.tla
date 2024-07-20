---- MODULE PCCallReturn ----
EXTENDS Naturals 
CONSTANTS Input, RtnVal(_) 

Output == {RtnVal(v) : v \in Input}

VARIABLE iFace

\* CRTypeOK == iFace \in [arg |-> Input, aBit |-> {0,1},
\*                         rtn |-> Output, rBit |-> {0,1}]

(*
    위의 방식은 field를 지정하는 방식이다. 즉 arg의 값은 Input이고 aBit의 값은 {0,1}이다.
    아래의 : 방식은 arg가 Input안에 있는 값이될 수 있다는 것을 의미한다.
*)

CRTypeOK == iFace \in [arg : Input,  aBit : {0,1},
                       rtn : Output, rBit : {0,1}]

CRInit == \E v \in Input, w \in Output: 
            iFace = [arg |-> v,         aBit |-> 0,
                     rtn |-> w, rBit |-> 0]

Call(v) == iFace' = [arg |-> v,        aBit |-> (iFace.aBit + 1)%2,
                     rtn |-> iFace.rtn, rBit |-> iFace.rBit]

Return(v) == iFace' = [arg |-> iFace.arg, aBit |-> iFace.aBit,
                       rtn |-> v,         rBit |-> (iFace.rBit + 1)%2]
====