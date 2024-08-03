

---- MODULE ISimpleMultiClientServer ----
CONSTANTS Client, Request, State, InitialState, ResponseVal(_,_, _),
    NewState(_, _,_)

ASSUME /\ InitialState \in State 
       /\ \forall c \in Client, v \in Request, s \in State : 
                NewState(c, v, s) \in State

Response == {
    ResponseVal(c,v,s) : c \in Client, v \in Request, s \in State
}

VARIABLE sstate, cstate, iFace

INSTANCE CSCallReturn WITH 
            Input <- Client \X Request, Output <- Client \X Response

SMCInit == /\ sstate = InitialState 
           /\ \E v \in Response : 
                    cstate = [c \in Client |-> [ctl|->"idle", val |-> v]]
           /\ CRInit 

SMCTypeInvariant == 
    /\ sstate \in State
    /\ cstate \in [Client -> [ctl:{"idle", "calling", "returning"},
                                val : Request \cup Response]]
    /\ \A c \in Client :
        /\ (cstate[c].ctl \in {"calling"}) => (cstate[c].val \in Request)
        /\ (cstate[c].ctl \in {"returning", "idle"}) => (cstate[c].val \in Response)

SMCIssueRequest(c, req) == 
    /\ cstate[c].ctl = "idle"
    /\ Call(<<c, req>>)
    /\ cstate' = [cstate EXCEPT ![c] = [ctl|-> "calling", val|-> req]]
    /\ UNCHANGED sstate

SMCDo(c) == 
    /\ cstate[c].ctl = "calling"
    /\ sstate' = NewState(c, cstate[c].val, sstate)
    /\ cstate' = [cstate EXCEPT 
                    ![c] = [ctl |-> "returning",
                            val |-> ResponseVal(c, cstate[c].val, sstate)]]
    /\ UNCHANGED iFace
(*
    서버 상태를 request와 response 사이에 변경되도록 만든 것은
    one-client server spec에 영향을 주지 않는다. (??? page 92)
    하지만 multi-client server spec에는 중요한 영향을 준다.

    이것이 의미하는 바는
    request가 완전히 완료되는(response 값이 계산되고 state가 변경된 상태) 순서는 
    requests와 responses의 발행 순서에 묶이지 않는다. 

    issue req1 
    issue req2
    do req1
    do req2

    c2의 요청이후 c1의 요청이 완료될 수 있다. 
    오직 c2의 요청 발행 이전에 c1의 요청을 서버가 반응 완료한 경우만 
    c1의 요청이 c2의 요청보다 먼저 완료될 수 있다. 

    그니까 서버에 적용되는 순서와 반환되는 순서가 다를 수 있다. 
    만약 returning이 완료되는 action에서 서버 상태도 같이 변경되면 
    서버에 적용되는 순서와 반환되는 순서가 같아진다.

    또 반대로 요청과 동시에 서버 상태가 변경되는 경우도 있다.
    이경우는 요청한 순서와 서버에 적용되는 순서가 같다.

    하지만 별도의 action으로 빼면, 서버에 적용되는 순서와 전달되는, 반환되는 순서가 다를 수 있다.
    이는 멀티 클라이언트 서버에서 중요한 부분이다.
*)


SMCRespond(c) == 
    /\ cstate[c].ctl = "returning"
    /\ Return(<<c, cstate[c].val>>)
    /\ cstate' = [cstate EXCEPT ![c].ctl = "idle"]
    /\ UNCHANGED sstate

SMCNext == \E c \in Client : 
            \/  \E req \in Request : SMCIssueRequest(c, req)
            \/ SMCDo(c) 
            \/ SMCRespond(c)

ocsvars == <<cstate, sstate, iFace>>

ISMCSpec == SMCInit /\ [][SMCNext]_ocsvars 
            /\ \forall c \in Client : WF_ocsvars(SMCDo(c) \/ SMCRespond(c))




====
