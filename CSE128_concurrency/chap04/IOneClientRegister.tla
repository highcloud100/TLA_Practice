---- MODULE IOneClientRegister ----

EXTENDS TLC

CONSTANTS RegisterVal
VARIABLES iFace, sstate, cstate 

Request == [type: {"read"}] \cup [type: {"write"}, val: RegisterVal]

OK == CHOOSE x : x \notin Request

State == RegisterVal 

\* choose a value in ": conditions"
InitialState == CHOOSE v \in RegisterVal : TRUE

ResponseVal(req, s) == 
    IF req.type = "read" THEN [val |-> s] \* 만약 그냥 s로 하면, s가 record가 아니라서 오류 발생
    ELSE OK 

(*
    /\ cstate \in [ctl:{"idle", "calling", "returning"}, val: Request \cup Response] 
    invariant에서 Request와 Response을 union으로 묶어 판단한다.
    이때 두 set의 타입이 다르기에 비교가 불가능하다. -> 오류 발생
    고로 같은 타입으로 맞춰주어야 한다.
*)

NewState(req, s) == IF req.type = "read" THEN s ELSE req.val

INSTANCE IOneClientServer 


====