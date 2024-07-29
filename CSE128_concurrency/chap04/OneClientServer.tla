---- MODULE OneClientServer ----
CONSTANTS  Request, State, InitialState, ResponseVal(_,_),
    NewState(_, _)

VARIABLE iFace

Inner(sstate, cstate) == INSTANCE IOneClientServer 
OCSSpec == \E sstate, cstate : Inner(sstate, cstate)!IOCSSpec

====