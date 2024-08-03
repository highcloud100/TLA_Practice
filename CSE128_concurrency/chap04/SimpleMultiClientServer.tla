---------------------- MODULE SimpleMultiClientServer  ---------------------- 
CONSTANTS Client, Request, State, InitialState,
          NewState(_, _, _), ResponseVal(_, _, _)

ASSUME /\ InitialState \in State
       /\ \A c \in Client, v \in Request, s \in State :
            NewState(c, v, s) \in State

Response == {ResponseVal(c, v, s) : 
               c \in Client, v \in Request, s \in State}
-----------------------------------------------------------------------------
VARIABLE sstate, cstate, iFace

INSTANCE CSCallReturn WITH Input  <- Client \X Request,
                           Output <- Client \X Response
-----------------------------------------------------------------------------
SMCInit == /\ sstate = InitialState
           /\ \E v \in Response : 
                cstate = [c \in Client |-> [ctl |-> "idle", val |-> v]]
           /\ CRInit

SMCTypeInvariant ==  
  /\ sstate \in State
  /\ cstate \in [Client -> [ctl : {"idle", "calling", "returning"},
                            val : Request \cup Response ]]
  /\ \A c \in Client :
       /\ (cstate[c].ctl \in {"calling"}) => (cstate[c].val \in Request)
       /\ (cstate[c].ctl \in {"returning", "idle"}) => 
             (cstate[c].val \in Response)
-----------------------------------------------------------------------------
SMCIssueRequest(c, req) ==
  /\ cstate[c].ctl = "idle"
  /\ Call(<<c, req>>)
  /\ cstate' = [cstate EXCEPT ![c] = [ctl |-> "calling", val |-> req]]
  /\ UNCHANGED sstate

SMCDo(c) ==
  /\ cstate[c].ctl = "calling"
  /\ sstate' = NewState(c, cstate[c].val, sstate)
  /\ cstate' = [cstate EXCEPT 
                  ![c] = [ctl |-> "returning", 
                          val |-> ResponseVal(c, cstate[c].val, sstate)]]
  /\ UNCHANGED iFace

SMCRespond(c) == /\ cstate[c].ctl = "returning"
                 /\ Return(<<c, cstate[c].val>>)
                 /\ cstate' = [cstate EXCEPT ![c].ctl = "idle"]
                 /\ UNCHANGED sstate

SMCNext == \E c \in Client : 
              \/ \E req \in Request : SMCIssueRequest(c, req)
              \/ SMCDo(c)
              \/ SMCRespond(c)

ocsvars == <<cstate, sstate, iFace>>

SMCSpec == /\ SMCInit 
           /\ [][SMCNext]_ocsvars 
           /\ \A c \in Client : WF_ocsvars(SMCDo(c) \/ SMCRespond(c))
===========================================================================

