---- MODULE OneClientRegister ----
EXTENDS TLC
CONSTANTS RegisterVal

Request == [type: {"read"}] \cup [type: {"write"}, val: RegisterVal]

State == RegisterVal 

\* choose a value in ": conditions"
InitialState == CHOOSE v \in RegisterVal : TRUE

ResponseVal(req, s) == 
    IF req.type = "read" THEN s
    ELSE "OK"

NewState(req, s) == IF req.type = "read" THEN s ELSE req.val

VARIABLE iFace
INSTANCE OneClientServer 

(*
    이를 TLC로 체크할 수 없다. 
    OCSSpec 안의 Exists operator를 처리하지 못한다. 
    이를 다루기 위해서는 internal specification을 사용해야 한다.

    OneClientServer대신 IOneClientServer를 instance하는 
    IOneClientRegister를 만들어 사용해보자. 
*)

====