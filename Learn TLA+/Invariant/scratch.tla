---- MODULE scratch ----
EXTENDS Integers, TLC, Sequences

Test == LET
  seq == <<1, 2, 3, 4>>
  s == 1..4
IN
  CHOOSE p \in s \X s: seq[p[1]] = seq[p[2]]
====
Test 