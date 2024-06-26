---- MODULE MCConstant ----
EXTENDS constant

ConstS == 1..5

Zip(seq1, seq2) ==
    LET Min(a, b) == IF a < b THEN a ELSE b 
        N == Min(Len(seq1), Len(seq2)) 
    IN  
        [i \in 1..N |-> <<seq1[i], seq2[i]>>]
====