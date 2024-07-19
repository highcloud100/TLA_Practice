---- MODULE threads ----
EXTENDS TLC, Sequences, Integers

NumThreads == 2
Threads == 1..NumThreads

(*--algorithm threads

variables 
    counter = 0;

define
    AllDone == 
        \A t \in Threads : pc[t] = "Done"
    
    Correct == 
        AllDone => counter = NumThreads
end define;

process thread \in Threads
begin
    IncCounter:
        counter := counter + 1;
end process;
end algorithm; *)

\* BEGIN TRANSLATION (chksum(pcal) = "98416dfd" /\ chksum(tla) = "d96387a7")
VARIABLES counter, pc

(* define statement *)
AllDone ==
    \A t \in Threads : pc[t] = "Done"

Correct ==
    AllDone => counter = NumThreads


vars == << counter, pc >>

ProcSet == (Threads)

Init == (* Global variables *)
        /\ counter = 0
        /\ pc = [self \in ProcSet |-> "IncCounter"]
        \* pc는 함수로 정의된다. process val -> label

IncCounter(self) == /\ pc[self] = "IncCounter"
                    /\ counter' = counter + 1
                    /\ pc' = [pc EXCEPT ![self] = "Done"]
        \* pc[self] = "IncCounter" label 일때만 enable된다. 
        \* pc[self]를 "Done" label로 바꾼다.
        \* 각각의 label은 정확히 하나의 action에 상응한다.  

(*
    PlusCal -> TLA+의
    transition은 다음과 같이 만들어진다. 
    
    Trans(state, from, to) == 
        /\ pc[state] = from 
        /\ pc' = [pc EXCEPT ![state] = to]
    
    IncCounter(self) == 
        /\ Trans(self, "IncCounter", "Done")
        /\ counter' = counter + 1

*)

thread(self) == IncCounter(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Threads: thread(self))
           \/ Terminating
        \* concurrency는 단지 thread 집합의 thread가 참인 요소가 존재함을 의미한다.

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
====

(*
    FAIRNESS in TLA+ 

    알아야할 것
    1. ENABLED A : A can be true this step == it can describe the next step
    > In the next step, the system can change in a way that satisfies A. 
    > https://www.youtube.com/watch?v=ilCrIRUbDHI

    2. <<A>>_v : A is true and v changes.

    fiarness는 다음과 같이 정의된다.
    
    WF_v(A) == <>[](ENABLED <<A>>_v) => []<><<A>>_v 
    SF_v(A) == []<>(ENABLED <<A>>_v) => []<><<A>>_v

    영어로 다음과 같다 .

    WF_v(A) (A is weakly fair): 
        If it is eventually always true that the A action can happen 
        (in a way that changes v),
        then it will eventually happen (and change v).

    A가 약한 fairness를 가지고 있다의 의미는 
    언젠가 A가 계속(항상) 발생할 수 있다면 -> 언젠가 A가 발생한다.

    만약 특정 시점부터 계속 next가 enable이 아니라면, 항상 실행되지는 않는다. 

    SF_v(A) (A is strongly fair): 
        If it is always eventually true that the A action can happen 
        (in a way that changes v), 
        then it will eventually happen (and change v).

    A가 강한 fairness를 가지고 있다의 의미는
    항상 언젠가 A가 발생할 수 있다면 -> 언젠가 A가 발생한다. 

    계속 반복적으로(ex: 주기를 가짐) next가 enable이라면, 결국 실행된다.
*)