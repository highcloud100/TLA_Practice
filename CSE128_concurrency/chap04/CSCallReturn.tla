---- MODULE CSCallReturn ----
EXTENDS Naturals
CONSTANTS Input, Output

VARIABLE iFace 

CRTypeOK == iFace \in [
    arg: Input, aBit : {0,1},
    rtn: Output, rBit : {0,1}
]

CRInit == \E v \in Input, w \in Output :
     iFace = [arg |-> v, aBit |-> 0, rtn |-> w, rBit |-> 0]

Call(v) == 
    iFace' = [
        arg |-> v, aBit |-> (iFace.aBit + 1) % 2,
        rtn |-> iFace.rtn, rBit |-> iFace.rBit
    ]

Return(v) == 
    iFace' = [
        arg |-> iFace.arg, aBit |-> iFace.aBit,
        rtn |-> v, rBit |-> (iFace.rBit + 1) % 2
    ]


====