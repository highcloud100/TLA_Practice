---- MODULE CallReturn ----
EXTENDS Naturals 

Input == 0..15
Output == 0..255
RtnVal(n) == n^2

VARIABLES arg, rtn  

\* this module just defines the Call, Return Actions

CRInit == /\ arg = 0
          /\ rtn = 0

Call == /\ arg' \in Input 
        /\ rtn' = rtn 

Return == /\ rtn' = RtnVal(arg)
          /\ arg' = arg

iFace == <<arg, rtn>>

CRInvariant == /\ arg \in Input
               /\ rtn \in Output

====