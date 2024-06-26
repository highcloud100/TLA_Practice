---- MODULE squares ----
EXTENDS Integers, Sequences, FiniteSets

ToSeconds(time) == time[1]*3600 + time[2]*60 + time[3]
Earlier(t1, t2) == ToSeconds(t1) < ToSeconds(t2)

ClockType == (0..23) \X (0..59) \X (0..59)
Squares == {x*x : x \in 1..4}
Evens == {x \in 1..4: x%2 = 0}

ToClock(seconds) ==
    LET seconds_per_day == 86400
    IN CHOOSE  x \in ClockType: ToSeconds(x) = seconds % seconds_per_day

ThreeMax(a, b, c) ==
    LET 
        Max(x, y) == IF x > y THEN x ELSE y
    IN  
        Max(Max(a,b), c)

====

Cardinality(ClockType)
ToClock(86401)
