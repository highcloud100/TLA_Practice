--------------------------- MODULE FGAltPgm ---------------------------
EXTENDS FGCallReturn
VARIABLES x, pc
-----------------------------------------------------------------------------
FGAltPgmInit == /\ FGCRInit 
                /\ x=0
                /\ pc = [c |-> "c1", r |-> "r1"]

CGoTo(loc1, loc2) == /\ pc.c = loc1 
                     /\ pc' = [c |-> loc2, r |-> pc.r]
RGoTo(loc1, loc2) == /\ pc.r = loc1 
                     /\ pc' = [c |-> pc.c, r |-> loc2]

FGAltPgmDoC ==  \/ /\ CGoTo("c1", "c2")
                   /\ x = 0
                   /\ UNCHANGED <<x, iFace>>
                \/ /\ pc.c = "c2"
                   /\ FGCall
                   /\ pc' = [c |-> IF FGCallDone' THEN "c3" ELSE "c2", r |-> pc.r]
                   /\ UNCHANGED <<x>>
                \/ /\ CGoTo("c3", "c1")
                   /\ x' = 1
                   /\ UNCHANGED <<iFace>>

FGAltPgmDoR == \/ /\ RGoTo("r1", "r2")
                /\ x = 1
                /\ UNCHANGED <<x, iFace>>
             \/ /\ pc.r = "r2"
                /\ FGReturn
                /\ pc' = [c |-> pc.c, 
                          r |-> IF FGReturnDone' THEN "r3" ELSE "r2"]
                /\ UNCHANGED <<x>>
             \/ /\ RGoTo("r3", "r1")
                /\ x' = 0
                /\ UNCHANGED <<iFace>>

FGAltPgmNext == FGAltPgmDoC \/ FGAltPgmDoR
-----------------------------------------------------------------------------
FGAltPgmSpec == FGAltPgmInit /\ [][FGAltPgmNext]_<<x, pc, iFace>>

FGAltPgmTypeOK == /\ FGCRInvariant
                /\ x \in {0,1}
                /\ pc \in [c : {"c1", "c2", "c3"}, r : {"r1", "r2", "r3"}]

FGAltPgmInvariant == /\ (pc.c # "c1") => (x = 0)
                   /\ (pc.r # "r1") => (x = 1)

Bar == INSTANCE FGAlternation
     WITH  x <- IF(pc.c = "c3") \/ (pc.r = "r3") THEN (x+1)%2 ELSE x

(*
    FGAltPgmSpec -> FGAltSpec

    FGAltSpec은 arg와 x값이 동시에 변경된다. 
    하지만 FGAltPgmSpec은 arg가 먼저 바뀌고, pc와 x가 변경된다.

    그렇기에 pc.c나 pc.r 일 때 (x+1)%2로 미리 뒤집어 준다. 

*)

FGAltSpec == Bar!FGAltSpec

THEOREM FGAltPgmSpec => [](FGAltPgmTypeOK /\ FGAltPgmInvariant)
=============================================================================