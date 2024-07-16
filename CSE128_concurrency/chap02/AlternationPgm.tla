--------------------------- MODULE AlternationPgm ---------------------------
EXTENDS CallReturn
VARIABLES x, pc
-----------------------------------------------------------------------------
AltPgmInit == /\ CRInit 
              /\ x=0
              /\ pc = [c |-> "c1", r |-> "r1"]

CGoTo(loc1, loc2) == /\ pc.c = loc1 
                     /\ pc' = [c |-> loc2, r |-> pc.r]
RGoTo(loc1, loc2) == /\ pc.r = loc1 
                     /\ pc' = [c |-> pc.c, r |-> loc2]

AltPgmDoC == \/ /\ CGoTo("c1", "c2")
                /\ x = 0
                /\ UNCHANGED <<x, iFace>>
             \/ /\ CGoTo("c2", "c3")
                /\ Call
                /\ UNCHANGED <<x>>
             \/ /\ CGoTo("c3", "c1")
                /\ x' = 1
                /\ UNCHANGED <<iFace>>
 
AltPgmDoR == \/ /\ RGoTo("r1", "r2")
                /\ x = 1
                /\ UNCHANGED <<x, iFace>>
             \/ /\ RGoTo("r2", "r3")
                /\ Return
                /\ UNCHANGED <<x>>
             \/ /\ RGoTo("r3", "r1")
                /\ x' = 0
                /\ UNCHANGED <<iFace>>

AltPgmNext == AltPgmDoC \/ AltPgmDoR
-----------------------------------------------------------------------------
AltPgmSpec == AltPgmInit /\ [][AltPgmNext]_<<x, pc, iFace>>

AltPgmTypeOK == /\ CRInvariant
                /\ x \in {0,1}
                /\ pc \in [c : {"c1", "c2", "c3"}, r : {"r1", "r2", "r3"}]

AltPgmInvariant == /\ (pc.c # "c1") => (x = 0)
                   /\ (pc.r # "r1") => (x = 1)

(*
    하나의 pc가 2, 3번째 상태라면 다른 pc는 1번째 상태여야 한다.
*)

THEOREM AltPgmSpec => [](AltPgmTypeOK /\ AltPgmInvariant)
=============================================================================