---- MODULE Semaphores ----
EXTENDS Naturals

P(s) == /\ s > 0
        /\ s' = s - 1

V(s) == s' = s + 1
====