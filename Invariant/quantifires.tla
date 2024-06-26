---- MODULE quantifires ----
EXTENDS TLC, Integers, Sequences, FiniteSets

S == 1..10

Test == LET 
    seq == <<1,2,3,4>>
    s == 1..4
IN 
    CHOOSE p \in s \X s: seq[p[1]] = seq[p[2]]

(*--algorithm duplicates
variables 
    seq \in S \X S \X S \X S;
    index = 1;
    seen = {};
    is_unique = TRUE;

define
    (*
        IsUnique(s) == Cardinality(seen) = Len(s)
    
        3가지 문제점이 있다. 
        1. seen이라는 variable을 가지고 정의 된 Invariant다. 
            - unique한지 안한지는 actual behavior와는 독립되어야 한다.
            - IsUnique는 s이외 다른 외부 변수들과 관계가 없어야한다.     
        2. Uniqueness에 대한 정의를 이용한 것이 아니다.  
            - clever한 trick을 이용해서, 즉 coincidentally identical to uniqueness를 이용했다.
        3. Finally, this doesn’t give us anywhere to go. 
            We could represent uniqueness this way, but what about, say, sortedness?
    
        => quantifier 등장!
    

    *)
    Contains(_seq, elem) == 
        \E i \in 1..Len(_seq) : _seq[i] = elem
    
    IsUnique(s) == 
        \* this is wrong
        \* \A i, j \in 1..Len(s) : s[i] # s[j]
        \A i, j \in 1..Len(s) : i # j => s[i] # s[j]
    
    IsCorrect == pc = "Done" => is_unique = IsUnique(seq)  
    
    TypeInvariant == 
        /\ is_unique \in BOOLEAN
        /\ seen \subseteq S 
        /\ index \in 1..Len(seq)+1
end define;

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
\* BEGIN TRANSLATION (chksum(pcal) = "1cb7c1ac" /\ chksum(tla) = "48407e2c")
VARIABLES seq, index, seen, is_unique, pc

(* define statement *)
Contains(_seq, elem) ==
    \E i \in 1..Len(_seq) : _seq[i] = elem

IsUnique(s) ==


    \A i, j \in 1..Len(s) : i # j => s[i] # s[j]

IsCorrect == pc = "Done" => is_unique = IsUnique(seq)

TypeInvariant ==
    /\ is_unique \in BOOLEAN
    /\ seen \subseteq S
    /\ index \in 1..Len(seq)+1


vars == << seq, index, seen, is_unique, pc >>

Init == (* Global variables *)
        /\ seq \in S \X S \X S \X S
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
