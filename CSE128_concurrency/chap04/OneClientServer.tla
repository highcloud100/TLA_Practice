---- MODULE OneClientServer ----
CONSTANTS  Request, State, InitialState, ResponseVal(_,_),
    NewState(_, _)

VARIABLE iFace

Inner(sstate, cstate) == INSTANCE IOneClientServer 
OCSSpec == \E sstate, cstate : Inner(sstate, cstate)!IOCSSpec

(*
    기존 IOCSSpec은 내부 변수인 sstate와 cstate를 가지는
    internal specification이다. 

    이들이 숨겨진 실제 spec은 위와 같다. 
    
*)
====