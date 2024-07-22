---- MODULE SemProducerConsumer ----
EXTENDS PCCallReturn, Semaphores, Naturals

CONSTANT N 
ASSUME (N \in Nat) /\ (N > 0)

VARIABLES buf, nxtC, nxtR, cSem, rSem

SemPCTypeOK == /\ CRTypeOK 
               /\ buf \in [0..(N-1) -> Input \cup Output]
               /\ nxtC \in 0..(N-1)
               /\ nxtR \in 0..(N-1)
               /\ cSem \in 0..N
               /\ rSem \in 0..N

SemPCInvariant == cSem + rSem = N 

SemPCInit ==    /\ CRInit
                /\ buf \in [0..(N-1) -> Output]
                /\ nxtC = 0
                /\ nxtR = 0
                /\ cSem = N
                /\ rSem = 0

SemPCCall(v) == /\ P(cSem) 
                /\ buf' = [buf EXCEPT ![nxtC] = v] 
                /\ Call(v) 
                /\ nxtC' = (nxtC + 1) % N
                /\ V(rSem) 
                /\ UNCHANGED nxtR 

SemPCReturn == /\ P(rSem)
               /\ buf' = [buf EXCEPT ![nxtR] = RtnVal(buf[nxtR])]
               /\ Return(buf'[nxtR]) \* return 값을 구하고, Return함수에 던짐: 그래서 buf'
               /\ nxtR' = (nxtR + 1) % N
               /\ V(cSem)
               /\ UNCHANGED nxtC

SemPCNext == (\E v \in Input: SemPCCall(v)) \/ SemPCReturn

SemPCSpec == SemPCInit /\ [][SemPCNext]_<<buf, nxtC, nxtR, cSem, rSem, iFace>>  

PCCS == INSTANCE ProducerConsumer 
                    WITH q <- [i \in 1..rSem |-> buf[(nxtR + i - 1)%N]]

PCSpec_ == PCCS!PCSpec 

THEOREM SemPCSpec => [](SemPCTypeOK /\ SemPCInvariant)

====