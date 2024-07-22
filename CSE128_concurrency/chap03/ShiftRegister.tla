---- MODULE ShiftRegister  ----
EXTENDS PCCallReturn, Naturals, Sequences

CONSTANTS  N 
ASSUME (N \in Nat) /\ (N > 0)

Empty == CHOOSE v : v \notin Input 

VARIABLE sr 

SHRtnVal(v) == v

SRInit == /\ CRInit 
          /\ sr = [i \in 1..N |-> Empty]

SRTypeOK == /\ CRTypeOK
            /\ sr \in [1..N -> Input \cup {Empty}]

SRCall(v) == /\ sr[1] = Empty 
             /\ Call(v) 
             /\ sr' = [sr EXCEPT ![1] = v]

SRReturn == /\ sr[N] # Empty 
             /\ Return(sr[N]) 
             /\ sr' = [sr EXCEPT ![N] = Empty]

SRShift(i) == /\ sr[i] # Empty 
              /\ sr[i+1] = Empty
              /\ sr' = [sr EXCEPT ![i] = Empty, ![i+1] = sr[i]]
              /\ UNCHANGED iFace

SRNext == \/ \E v \in Input: SRCall(v)
          \/ \E i \in 1..(N-1): SRShift(i)
          \/ SRReturn 

SRSpec == SRInit /\ [][SRNext]_<<sr, iFace>>

qBar == LET F[i \in 0..N] == 
            IF i=0 THEN <<>> 
                ELSE IF sr[i] = Empty THEN F[i-1] 
                     ELSE (<<sr[i]>> \o F[i-1])
            IN F[N]

(* The Refinement Mapping

    위의 shift spec은 
    - call하면 배열의 첫번째가 비어있는지 확인하고, 비어있으면 값을 넣는다.
    - return하면 배열의 마지막이 비어있지 않은지 확인하고, 비어있지 않으면 값을 return한다.
    - shift하면 배열의 i번째가 비어있지 않고, i+1번째가 비어있으면 i번째를 i+1번째로 옮긴다.

    이를 producer consumer로 변환하면
    producer consumer는 fifo 배열을 가진다. 가장 앞이 먼저 들어온 값이고, 배열에는 empty가 존재하지 않는다. 
    고로 shift의 배열을 producer consumer의 배열로 변환하려면, 다음과 같은 과정을 진행한다.
    1. empty 삭제
    2. 역순 정렬 

    이렇게 q를 정의하면 
    SRSpec -> PCSpec을 보일 수 있다. 

*)

bar == INSTANCE ProducerConsumer
       WITH q <- qBar

PCSpec_ == bar!PCSpec

THEOREM SRSpec => []SRTypeOK

====