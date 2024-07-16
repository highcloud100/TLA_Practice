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

THEOREM AltSpec => []AltInvariant
=======================================================