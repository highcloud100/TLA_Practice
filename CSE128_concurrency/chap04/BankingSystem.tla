---- MODULE BankingSystem ----
EXTENDS Naturals

CONSTANT Client

Request == [type: {"deposit", "withdraw"}, amt: Nat] \cup 
            [type: {"transfer"}, dest : Client, amt: Nat]

State == [Client -> Nat]

InitialState == [c \in Client |-> 0]

NewState(c, req, st) == 
        CASE req.type = "deposit" -> [st EXCEPT ![c] = st[c] + req.amt]
        [] req.type = "withdraw" ->
            IF req.amt <= st[c] THEN  [st EXCEPT ![c] = st[c] - req.amt]
                                ELSE st
        [] req.type = "transfer" -> 
            IF req.amt <= st[c] 
                THEN [st EXCEPT ![c] = st[c] - req.amt, 
                        ![req.dest] = st[req.dest] + req.amt]
                ELSE st

ResponseVal(c, req, st) == 
    [type |-> "response", val |-> IF \/ req.type = "deposit"
                                    \/ req.amt <= st[c] 
                                    THEN "OK"
                                    ELSE "No"]

VARIABLES iFace 
INSTANCE SimpleMultiClientServer

====