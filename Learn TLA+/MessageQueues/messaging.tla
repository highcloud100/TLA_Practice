---- MODULE messaging ----
EXTENDS Sequences, Integers, TLC, FiniteSets
CONSTANTS Writer, Readers, Data, NULL, MaxQueue

ASSUME Writer \notin Readers
ASSUME NULL\notin Data

SeqOf(set, n) == UNION {[1..m -> set] : m \in 0..n}
seq (+) elem == Append(seq, elem)

(*--algorithm polling

begin
    skip;
end algorithm; *)

====