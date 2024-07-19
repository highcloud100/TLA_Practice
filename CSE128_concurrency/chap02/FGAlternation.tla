----------------- MODULE FGAlternation ------------------
EXTENDS FGCallReturn
VARIABLE x
-------------------------------------------------------
FGAltInit == FGCRInit /\ (x=0)

FGAltCall == /\ x = 0
           /\ FGCall
           /\ x' = IF FGCallDone' THEN 1 ELSE x

FGAltReturn == /\ x = 1
             /\ FGReturn
             /\ x' = IF FGReturnDone' THEN 0 ELSE x

FGAltNext == FGAltCall \/ FGAltReturn
-------------------------------------------------------
FGAltSpec == FGAltInit /\ [][FGAltNext]_<<iFace, x>>

FGAltInvariant == FGCRInvariant /\ (x \in {0,1})

THEOREM FGAltSpec => []FGAltInvariant
=======================================================