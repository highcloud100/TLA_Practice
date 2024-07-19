---- MODULE threads ----
EXTENDS TLC, Integers 
CONSTANT NULL = -1

Threads == 1..2

(*--algorithm threads
variable lock = NULL;

define
    Liveness == 
        \A t \in Threads:
            <> (lock = t)
end define;

fair process thread \in Threads
begin
    GetLock:
        await lock = NULL;
        lock := self;
    ReleaseLock:
        lock := NULL;
    Reset:
        goto GetLock;
end process;

end algorithm; *)
====

(*
 So even if the system infinitely stutters all the safety properties will still hold. 
 
*)