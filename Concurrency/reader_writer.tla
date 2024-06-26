---- MODULE reader_writer ----
EXTENDS TLC, Integers, Sequences 

Writer == {1,2,3}

(*--algorithm reader_writer
variables 
    queue = <<>>;
    total = 0;

process writer \in Writer
variables 
    i=0;
begin
    AddToQueue:
        
        await queue = <<>>; \* bounded queue
        queue := Append(queue, 1);
        \* while i<2 do  \* 전체는 atomic 하지 않다. iteration 단위로 atomic하다.
        \*     queue := Append(queue, 1);
        \*     i := i + 1;
        \* end while;    
end process;

process reader = 0
begin
    ReadFromQueue:
        \* if queue # <<>> then 
        await queue # <<>>; 
            total := total + Head(queue);
            queue := Tail(queue);
        
        \* \end if;
        \* run reader forever
        goto ReadFromQueue;
end process;
    
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "65f3070a" /\ chksum(tla) = "25eafaed")
VARIABLES queue, total, pc, i

vars == << queue, total, pc, i >>

ProcSet == (Writer) \cup {0}

Init == (* Global variables *)
        /\ queue = <<>>
        /\ total = 0
        (* Process writer *)
        /\ i = [self \in Writer |-> 0]
        /\ pc = [self \in ProcSet |-> CASE self \in Writer -> "AddToQueue"
                                        [] self = 0 -> "ReadFromQueue"]

AddToQueue(self) == /\ pc[self] = "AddToQueue"
                    /\ queue = <<>>
                    /\ queue' = Append(queue, 1)
                    /\ pc' = [pc EXCEPT ![self] = "Done"]
                    /\ UNCHANGED << total, i >>

writer(self) == AddToQueue(self)

ReadFromQueue == /\ pc[0] = "ReadFromQueue"
                 /\ queue # <<>>
                 /\ total' = total + Head(queue)
                 /\ queue' = Tail(queue)
                 /\ pc' = [pc EXCEPT ![0] = "ReadFromQueue"]
                 /\ i' = i

reader == ReadFromQueue

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == /\ \A self \in ProcSet: pc[self] = "Done"
               /\ UNCHANGED vars

Next == reader
           \/ (\E self \in Writer: writer(self))
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(\A self \in ProcSet: pc[self] = "Done")

\* END TRANSLATION 
====
