---- MODULE diehard ----
EXTENDS TLC, Integers


VARIABLES 
    small, big  

solution == big # 4

TypeOk == /\ small \in 0..3
          /\ big \in 0..5

Init == /\ small = 0
        /\ big = 0

FillSmall == 
    /\ small' = 3
    /\ big' = big 

FillBig ==
    /\ big' = 5
    /\ small' = small

SmallToBig == 
    IF big + small <= 5
        THEN 
            /\ big' = big + small 
            /\ small' = 0 
        ELSE 
            /\ big' = 5
            /\ small' = small - (5 - big)

BigToSmall == 
    IF big + small <= 3
        THEN 
            /\ big' = 0 
            /\ small' = big+small 
        ELSE 
            /\ small' = 3
            /\ big' = big-(3-small) 

EmptySmall == 
    /\ small' = 0
    /\ big' = big 

EmptyBig == 
    /\ small' = small
    /\ big' = 0

Next == \/ FillSmall
        \/ FillBig
        \/ EmptySmall
        \/ EmptyBig
        \/ SmallToBig
        \/ BigToSmall

Spec == Init /\ [][Next]_<<big, small>>

====