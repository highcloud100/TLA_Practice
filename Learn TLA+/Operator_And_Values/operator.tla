---- MODULE operator ----
EXTENDS TLC, Integers, Sequences, FiniteSets

MinutesToSeconds(m) == m*60

Abs(x) == IF x < 0 THEN -x ELSE x 

S == <<"a">>

ClockType == (0..23) \X (0..59) \X (0..59)

sequares == {x*x : x \in 1..10}
Evens == {x \in 1..4 : x % 2 = 0}

====

(*
    sequence / tuple(fixed length seq)
    - 1 indexed
*)
Append(S, "b")
S \o <<"b", "c">>
Head(S)
Tail(<<1,2,3>>)
Len(S)
SubSeq(<<1,3,5>>,1,2)

(*
    Sets
    unordered, unique
    can't contain different types
*)

{1,2,3} \union {4,5,6}
{1,2,3} \intersect {2,3,4}
(* set intersection : in both sets 
    cup : union
    cap : intersection
*)
{1,2,3} \ {2,3}
(* set difference : in set1 but not in set2 *)

Cardinality({1,2,3,3})
(* EXTEND FiniteSet 
number of elements in set *)

Cardinality(ClockType)

(*
    Sets -> Map, filter
*)

\* sequares == {x*x : x \in 1..10}
sequares

\* Evens == {x \in 1..4 : x % 2 = 0}
Evens 

CHOOSE x \in 1..10 : x = 5
(* choose an element from set that satisfies the condition *)

(*
    ToClock(seconds) == CHOOSE x \in ClockType : 
                                ToSeconds(x) = seconds
*)

(*
LET : local operator

“programming way” of ToClock
 
ToClock2(seconds) ==  
  LET
    h == seconds \div 3600
    h_left == seconds % 3600
    m == h_left \div 60
    m_left == h_left % 60
    s == m_left
  IN
    <<h, m, s>>

*)