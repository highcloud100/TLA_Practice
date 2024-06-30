---- MODULE counters ----
EXTENDS TLC, Integers

Counters == {1,2}

(*--algorithm counters
variables 
    values = [i \in Counters |-> 0];

define
    CounterOnlyIncreases_not_work == 
        \A c \in Counters:
            [][values[c]' >= values[c]]_values[c]
    \* 위에처럼 quantifier 안에 action property를 넣어주면 TLC가 체크할 수 없다.

    CounterOnlyIncreases == 
        [][
        \A c \in Counters: 
            values[c]' >= values[c]
        ]_values 
    
end define;

macro increment() begin
    values[self] := values[self] + 1;
end macro;

process counter \in Counters
begin
    A:
        increment();
    B:  
        increment();
end process;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "1d0ec7f6" /\ chksum(tla) = "24c32b0")
VARIABLES values, pc

(* define statement *)
CounterOnlyIncreases ==
    \A c \in Counters:
        [][values[c]' >= values[c]]_values[c]


vars == << values, pc >>

ProcSet == (Counters)

Init == (* Global variables *)
        /\ values = [i \in Counters |-> 0]
        /\ pc = [self \in ProcSet |-> "A"]

A(self) == /\ pc[self] = "A"
           /\ values' = [values EXCEPT ![self] = values[self] + 1]
           /\ pc' = [pc EXCEPT ![self] = "B"]

B(self) == /\ pc[self] = "B"
           /\ values' = [values EXCEPT ![self] = values[self] + 1]
           /\ pc' = [pc EXCEPT ![self] = "Done"]

counter(self) == A(self) \/ B(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Counters: counter(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
====
