---- MODULE RandomWalk ----
EXTENDS Naturals
VARIABLE x

RWInit == x = 0

Inc == x' = (x + 1)%101
Dec == x' = (x - 1)%101

RWNext == Inc \/ Dec 

TypeInv == x \in 0..100

RWSpec == RWInit /\ [][RWNext]_x

====