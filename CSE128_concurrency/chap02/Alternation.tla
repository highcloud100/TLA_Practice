----------------- MODULE Alternation ------------------
EXTENDS CallReturn
VARIABLE x
-------------------------------------------------------
AltInit == CRInit /\ (x=0)

AltCall == /\ x = 0
           /\ Call
           /\ x' = 1

AltReturn == /\ x = 1
             /\ Return
             /\ x' = 0

AltNext == AltCall \/ AltReturn
-------------------------------------------------------
AltSpec == AltInit /\ [][AltNext]_<<iFace, x>>

AltInvariant == CRInvariant /\ (x \in {0,1})

CSLiveness == \forall n \in 0..4 :
                (arg = n) ~> (rtn = RtnVal(n))

CSAltSpec == AltSpec /\ WF_<<x, iFace>>(AltReturn)

NonstopAltSpec_1 ==
    WF_<<x, iFace>>(AltNext)

NonstopAltSpec_2 == 
    WF_<<x, iFace>>(AltCall) /\ WF_<<x, iFace>>(AltReturn)

problem2_3 ==
    /\ NonstopAltSpec_1 => NonstopAltSpec_2
    /\ NonstopAltSpec_2 => NonstopAltSpec_1

THEOREM AltSpec => []AltInvariant
=======================================================