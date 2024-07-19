---- MODULE threads ----
EXTENDS TLC, Integers 
CONSTANT NULL

NumThreads == 2
Threads == 1..NumThreads

(*--algorithm threads

variables 
    counter = 0;
    lock = NULL;

define
    (*
        Actions in Temporal Logic of Actions (TLA)

        - string은 ""로 감싸준다. 그 이유는 '는 사용처가 있기 때문이다.
        - x'는 x의 다음 상태를 의미한다.
    
        [](x' >= x)는 x가 계속 증가하는 것을 의미한다.

        만약 [](x' = x + 1)이라고 지정하면 어떤 문제가 있을까?
        - 이 경우에는 x가 1씩 증가하는 것을 의미한다.
        tla에서는 stutter step을 허용한다. 
        즉 step 어디든 stutter step을 넣을 수 있다.
        그래서 위의 property는 자명하게 틀리다. 

        고로 다음과 같이 써주어야 한다. 
        [](x' = x + 1 \/ unchanged x) 
        syntactic sugar로 아래와 같이 쓸 수 있다. 
        [][x' = x + 1]_x 
        이걸 box action formula 라고 부른다. ( 다음 장에서 다룰 예정이다. )
        
        - TLC는 box action formula 인 action properties 만 체크할 수 있다.
      
        다음은 모두 같다. 
        [counter' > counter]_counter
        counter' > counter \/ UNCHANGED counter
        counter' > counter \/ counter' = counter
        counter' >= counter
        
    
    *)
    CounterOnlyIncreases == 
        [][counter' >= counter]_counter
    
    LockCantBeStolen == 
        [][lock # NULL => lock' = NULL]_lock
    
    LockNullBeforeAcquired == 
        [][lock' # NULL => lock = NULL]_lock
end define;

process thread \in Threads
variables tmp = 0;
begin
    GetLock:
        \* await lock = NULL;
        lock  := self;

    GetCounter:
        tmp := counter;
    
    IncCounter:
        counter := tmp + 1;
        \*counter := tmp + IF tmp = 0 THEN 1 ELSE -1;
    
    ReleaseLock:
        lock := NULL;
end process;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "5642a9dc" /\ chksum(tla) = "b1a5bbd")
VARIABLES counter, lock, pc

(* define statement *)
CounterOnlyIncreases ==
    [][counter' >= counter]_counter

LockCantBeStolen ==
    [][lock # NULL => lock' = NULL]_lock

VARIABLE tmp

vars == << counter, lock, pc, tmp >>

ProcSet == (Threads)

Init == (* Global variables *)
        /\ counter = 0
        /\ lock = NULL
        (* Process thread *)
        /\ tmp = [self \in Threads |-> 0]
        /\ pc = [self \in ProcSet |-> "GetLock"]

GetLock(self) == /\ pc[self] = "GetLock"
                 /\ lock' = self
                 /\ pc' = [pc EXCEPT ![self] = "GetCounter"]
                 /\ UNCHANGED << counter, tmp >>

GetCounter(self) == /\ pc[self] = "GetCounter"
                    /\ tmp' = [tmp EXCEPT ![self] = counter]
                    /\ pc' = [pc EXCEPT ![self] = "IncCounter"]
                    /\ UNCHANGED << counter, lock >>

IncCounter(self) == /\ pc[self] = "IncCounter"
                    /\ counter' = tmp[self] + 1
                    /\ pc' = [pc EXCEPT ![self] = "ReleaseLock"]
                    /\ UNCHANGED << lock, tmp >>

ReleaseLock(self) == /\ pc[self] = "ReleaseLock"
                     /\ lock' = NULL
                     /\ pc' = [pc EXCEPT ![self] = "Done"]
                     /\ UNCHANGED << counter, tmp >>

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
