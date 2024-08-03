---- MODULE IBankingSystem ----
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

VARIABLES iFace, sstate, cstate
INSTANCE ISimpleMultiClientServer

====

이 상태로 실행하면 다음과 같은 오류가 나온다.

```
but can't enumerate the value of the `amt' field:
Nat
```

이 오류는 amt가 Nat이고, 이에 가능한 공간이 무한대가 된다. 
TLC는 이를 체크할 수 없고, 유한 상태 공간으로 바꾸어야한다.

이를 해결하기 위해 MCBankingSystem 모듈을 추가하여 제한된 상태 공간을 만들어보자.