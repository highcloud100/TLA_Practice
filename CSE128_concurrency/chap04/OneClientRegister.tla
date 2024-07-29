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


====