---- MODULE duplicates ----
EXTENDS TLC, Integers, Sequences 

(*--algorithm duplicates
variables seq \in {<<1,2,3,2>>,<<1,2,3,4>>};
index = 1;
seen = {};
is_unique = TRUE;

begin
    Iterate:
        while index <= Len(seq) do 
            if seq[index] \notin seen then 
                seen := seen \union {seq[index]};
            else 
                is_unique := FALSE;
            end if;
            index := index + 1;
        end while;
end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "33e8d847" /\ chksum(tla) = "da13da94")
VARIABLES seq, index, seen, is_unique, pc

vars == << seq, index, seen, is_unique, pc >>

Init == (* Global variables *)
        /\ seq \in {<<1,2,3,2>>,<<1,2,3,4>>}
        /\ index = 1
        /\ seen = {}
        /\ is_unique = TRUE
        /\ pc = "Iterate"

Iterate == /\ pc = "Iterate"
           /\ IF index <= Len(seq)
                 THEN /\ IF seq[index] \notin seen
                            THEN /\ seen' = (seen \union {seq[index]})
                                 /\ UNCHANGED is_unique
                            ELSE /\ is_unique' = FALSE
                                 /\ seen' = seen
                      /\ index' = index + 1
                      /\ pc' = "Iterate"
                 ELSE /\ pc' = "Done"
                      /\ UNCHANGED << index, seen, is_unique >>
           /\ seq' = seq

(* Allow infinite stuttering to prevent deadlock on termination. *)
Terminating == pc = "Done" /\ UNCHANGED vars

Next == Iterate
           \/ Terminating

Spec == Init /\ [][Next]_vars

Termination == <>(pc = "Done")

\* END TRANSLATION 
====
