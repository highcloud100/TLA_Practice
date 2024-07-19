---- MODULE SemAlternation ----
EXTENDS CallReturn, Semaphores

VARIABLES cSem, rSem

SemAltInit == /\ CRInit 
              /\ cSem = 1
              /\ rSem = 0

SemAltCall == /\ P(cSem)
              /\ Call 
              /\ V(rSem)

SemAltReturn == /\ P(rSem)
                /\ Return
                /\ V(cSem)

SemAltNext == SemAltCall \/ SemAltReturn

SemAltSpec == SemAltInit /\ [][SemAltNext]_<<iFace, cSem, rSem>>

SemAltInvariant == /\ CRInvariant 
                   /\ cSem \in {0,1}
                   /\ rSem \in {0,1}
                   /\ cSem + rSem = 1

THEOREM SemAltSpec => []SemAltInvariant

====