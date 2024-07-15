---- MODULE AltImplementsOsc ----
EXTENDS Naturals, Alternation

\* "_x" in "[][~~]_x" menas [~~] \/ unchanged x
OscSpec == (x=0) /\ [][x' = (x+1)%2]_x

THEOREM AltSpec => OscSpec

====