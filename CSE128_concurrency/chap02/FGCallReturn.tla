------------------ MODULE FGCallReturn -----------------
EXTENDS Naturals
--------------------------------------------------------
Input     == 0..15
Output    == 0..255
RtnVal(n) == n^2
--------------------------------------------------------
VARIABLES arg, rtn, FGCallDone, FGReturnDone

FGCRInit == /\ arg = 0
            /\ rtn = 0
            /\ FGCallDone   = TRUE
            /\ FGReturnDone = TRUE

FGCall == /\ arg' \in Input
          /\ FGCallDone' \in {TRUE, FALSE}
          /\ UNCHANGED <<rtn, FGReturnDone>>

FGReturn == /\ \/ /\ rtn' \in Output
                  /\ FGReturnDone' = FALSE
               \/ /\ rtn' = arg^2
                  /\ FGReturnDone' = TRUE
            /\ UNCHANGED <<arg, FGCallDone>>

iFace == <<arg, rtn, FGCallDone, FGReturnDone>>

FGCRInvariant == /\ arg \in Input
                 /\ rtn \in Output
                 /\ FGCallDone   \in {TRUE, FALSE}
                 /\ FGReturnDone \in {TRUE, FALSE}
========================================================