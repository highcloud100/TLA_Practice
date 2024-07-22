---- MODULE NProcProducerConsumer ----
EXTENDS PCCallReturn, FiniteSets, Naturals

CONSTANT N 
ASSUME (N \in Nat) /\ (N > 0)

VARIABLES buf, cSemA, rSemA, pc 

NProcPCTypeOK == /\ CRTypeOK 
                 /\ buf \in [0..(N-1) -> Input \cup Output] 
                 /\ cSemA \in [0..(N-1) -> 0..1]
                 /\ rSemA \in [0..(N-1) -> 0..1]
                 /\ pc \in [0..(N-1) -> {"c", "r"}]

NProcPCInvariant == /\ Cardinality({i\in 0..(N-1) : cSemA[i] = 1}) = 1
                    /\ Cardinality({i\in 0..(N-1) : rSemA[i] = 1}) = 1

NProcPCInit == /\ CRInit 
               /\ buf \in [0..(N-1) -> Output]
               /\ cSemA = [i \in 0..(N-1) |-> IF i = 0 THEN 1 ELSE 0]
               /\ rSemA = [i \in 0..(N-1) |-> IF i = 0 THEN 1 ELSE 0]
               /\ pc = [i \in 0..(N-1) |-> "c"] 

GoTo(i, loc1, loc2) == /\ pc[i] = loc1 
                      /\ pc' = [pc EXCEPT ![i] = loc2]

NProcPCCall(i, v) == /\ GoTo(i, "c", "r")
                     /\ cSemA[i] > 0 
                     /\ cSemA' = [cSemA EXCEPT  
                                  ![i] = cSemA[i] - 1,
                                  ![(i+1)% N] = cSemA[(i+1) % N] + 1]
                     /\ buf' = [buf EXCEPT ![i] = v] 
                     /\ Call(v) 
                     /\ UNCHANGED rSemA 

NProcPCReturn(i) == /\ GoTo(i, "r", "c")
                    /\ rSemA[i] > 0 
                    /\ rSemA' = [rSemA EXCEPT  
                                 ![i] = rSemA[i] - 1,
                                 ![(i+1) % N] = rSemA[(i+1) % N] + 1] 
                    /\ buf' = [buf EXCEPT ![i] = RtnVal(buf[i])]
                    /\ Return(buf'[i])
                    /\ UNCHANGED cSemA

NProcPCNext == \E i \in 0..(N-1) : \/ \E v \in Input : NProcPCCall(i, v)
                                   \/ NProcPCReturn(i)

NProcPCSpec == NProcPCInit /\ [][NProcPCNext]_<<buf, cSemA, rSemA, pc, iFace>>


THEOREM NProcPCSpec => [](NProcPCTypeOK /\ NProcPCInvariant)

====