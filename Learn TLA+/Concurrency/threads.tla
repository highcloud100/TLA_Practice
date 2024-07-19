---- MODULE threads ----
EXTENDS TLC, Sequences, Integers
CONSTANT NULL

NumThreads == 2
Threads == 1..NumThreads 

(*--algorithm threads
variables 
    counter = 0;
    lock = NULL;

define
    AllDone == 
        \A t \in Threads : pc[t] = "Done"
    Correct == 
        AllDone => counter = NumThreads
end define;

process thread \in Threads
variables temp = 0;
begin  
    GetLock:
        await lock = NULL;
        lock := self;
    
    GetCounter:
        temp := counter;
    
    IncCounter:
        counter := temp + 1;
    
    ReleaseLock:
        assert lock = self;
        lock := NULL;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "47edb42d" /\ chksum(tla) = "81b832df")
VARIABLES counter, lock, pc

(* define statement *)
AllDone ==
    \A t \in Threads : pc[t] = "Done"
Correct ==
    AllDone => counter = NumThreads

VARIABLE temp

vars == << counter, lock, pc, temp >>

ProcSet == (Threads)

Init == (* Global variables *)
        /\ counter = 0
        /\ lock = NULL
        (* Process thread *)
        /\ temp = [self \in Threads |-> 0]
        /\ pc = [self \in ProcSet |-> "GetLock"]

GetLock(self) == /\ pc[self] = "GetLock"
                 /\ lock = NULL
                 /\ lock' = self
                 /\ pc' = [pc EXCEPT ![self] = "GetCounter"]
                 /\ UNCHANGED << counter, temp >>

GetCounter(self) == /\ pc[self] = "GetCounter"
                    /\ temp' = [temp EXCEPT ![self] = counter]
                    /\ pc' = [pc EXCEPT ![self] = "IncCounter"]
                    /\ UNCHANGED << counter, lock >>

IncCounter(self) == /\ pc[self] = "IncCounter"
                    /\ counter' = temp[self] + 1
                    /\ pc' = [pc EXCEPT ![self] = "ReleaseLock"]
                    /\ UNCHANGED << lock, temp >>

ReleaseLock(self) == /\ pc[self] = "ReleaseLock"
                     /\ lock' = NULL
                     /\ pc' = [pc EXCEPT ![self] = "Done"]
                     /\ UNCHANGED << counter, temp >>

thread(self) == GetLock(self) \/ GetCounter(self) \/ IncCounter(self)
                   \/ ReleaseLock(self)

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == (\E self \in Threads: thread(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 

====
