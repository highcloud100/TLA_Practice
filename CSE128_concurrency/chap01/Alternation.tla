---- MODULE Alternation ----
EXTENDS CallReturn
VARIABLE x 

(*
x describes a discrete oscillator 
How we can proof x works as an oscillator?

First, we need to specify the oscillator's behavior.
Next, we need to proof following properties:
- Every state satisfying AltInit also satisfies OsclInit.
- Every step satisfying AltNext also satisfies OscNewt.

In other words, 
 AltInit => Osclnit /\ AltNext => OscNext.
*)


AltInit == CRInit /\ (x=0)

AltCall == /\ x = 0
           /\ Call 
           /\ x' = 1

AltReturn == /\ x = 1
             /\ Return
             /\ x' = 0

AltNext == AltCall \/ AltReturn

AltInvariant == CRInvariant /\ (x \in 0..1)

-----------------------------------

AltSpec == AltInit /\ [][AltNext]_<<iFace, x>>

THEOREM AltSpec => []AltInvariant

====