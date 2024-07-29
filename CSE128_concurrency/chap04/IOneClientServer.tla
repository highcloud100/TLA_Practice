---- MODULE IOneClientServer ----
CONSTANTS Request, State, InitialState, ResponseVal(_,_),
    NewState(_, _) 

ASSUME /\ InitialState \in State 
       /\ \A v \in Request, s \in State 
            : NewState(v, s) \in State
\* quantifier 
\* - \A set : formula

Response == {
    \* Map
    ResponseVal(v, s) : v \in Request, s \in State
}

\* server state, interface 
VARIABLES sstate, cstate, iFace 

\* sstate and cstate are internal variables of the systems.
\* The only visible variable is iFace.
\* iFace describes the communication between the client and the server.

INSTANCE CSCallReturn WITH 
            Input <- Request, Output <- Response
            \* iFace 
            \* we let it be instantiated by a variable of the same name 

OCSInit == /\ sstate = InitialState
           /\ \E v \in Response : cstate = [ctl |-> "idle", val |-> v]
           /\ CRInit 

OCSTypeInvariant == 
    /\ sstate \in State 
    /\ cstate \in [ctl:{"idle", "calling", "returning"}, val: Request \cup Response]
    /\ (cstate.ctl \in {"calling"}) => (cstate.val \in Request)
    /\ (cstate.ctl \in {"returning", "idle"}) => (cstate.val \in Response)
    /\ CRTypeOK 

(*
    idle : The client can issue a request.  
    calling : The client has issued a request, 
                but the server has not responded yet.
    returning : The server's state has changed, 
                but the server has not yet issued a response to the client's request.
*)

OCSIssueRequest(req) == 
    /\ cstate.ctl = "idle"
    /\ Call(req) 
    /\ cstate' = [ctl |-> "calling", val |-> req]
    /\ UNCHANGED sstate 

OCSDo == 
    /\ cstate.ctl = "calling"
    /\ sstate' = NewState(cstate.val, sstate)
    /\ cstate' = [ctl |-> "returning", 
                val |-> ResponseVal(cstate.val, sstate)]
    /\ UNCHANGED iFace

OCSRespond == 
    /\ cstate.ctl = "returning"
    /\ Return(cstate.val)
    /\ cstate' = [cstate EXCEPT !.ctl = "idle"]
    /\ UNCHANGED sstate

OCSNext == \/ \E req \in Request : OCSIssueRequest(req)
           \/ OCSDo \/ OCSRespond

ocsvars == <<cstate, sstate, iFace>>


IOCSSpec == /\ OCSInit 
            /\ [][OCSNext]_ocsvars 
            /\ WF_ocsvars(OCSDo \/ OCSRespond)  
====