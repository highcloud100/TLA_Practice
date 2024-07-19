---- MODULE orchestrator ----
EXTENDS TLC, Integers, FiniteSets

Servers == {"s1", "s2"}

(*--algorithm orchestrator

variables 
    online = Servers;

define
    (*
        safety : system이 bad things를 하지 않는다.
        liveness : system이 항상 good things를 한다.
    
        예로
        safety -> 시스템이 database 제약을 위반하지 않는다. 
        liveness -> 모든 transaction은 complete 혹은 rollback된다. 
    
        invariant는 모두 safety property이다. 
        하지만
        safety property는 모두 invariant가 아니다. 
    
        |---safety-------------------|
        |           --- invariant ---|
        |           |                |
        |           |                |
        |           -----------------|
        |----------------------------|

        https://lamport.azurewebsites.net/tla/rhtml/stuttering-step.html
        https://www.hillelwayne.com/post/safety-and-liveness/
        https://lamport.azurewebsites.net/tla/safety-liveness.pdf    
    
        “There is at least one server that’s always online” 에 관한
         property들이다.  
    *)
    
    Invariant == \E s \in Servers: s \in online
    Safety == \E s \in Servers: [](s \in online)

    (*
        invariant
            -> At any given point in time, there is at least one server online.
        safety
            -> In every behavior, there is a particular server, 
                and that server is online at all points in time.
        
        single state만 보고 violated 되었는지 확인할 수 없다. 
        만약 어떤 상태 online = {1}을 주고서 safety가 violated 되었는지 확인할 수 있을까?
        불가능하다. 다른 1 \notin online이라는 상태가 있다는 정보를 알아야만 가능하다.
        invariant는 모든 state마다 만족해야하는 반면, 
        safety는 특정 길이의 sequence에서 만족하면 된다. (길이가 1이라면 safety는 invariant다.)

        safety의 정의는 엄밀하게 

        P가 safety property 
        <->
        b |= P equals true iﬀ s |= P equals true for all preﬁxes s of b .

        b satisﬁes P iﬀ every preﬁx of b satisﬁes P. 이다. 
        b는 behavior로 state들의 infinite sequence이다. 
        P는 어떤 behavior의 predicate이다. 
        b |= P 라고 표시하고, 이게 TRUE라면 b는 P를 만족한다.
        P는 tla에서 fomula로 표현된다. 
        어떤 b에 대해 
        F == (x=1) /\ [][x’=x+1]_x 라면 
        b |= F 는 
            s_1에 x에 1을 assign
            이후 x'에 이전 x보다 x+1 혹은 x assign하는 state들의 sequence가 무한히 반복되는 b라면
            b |= F는 TRUE이다.
    *)

    Liveness == ~[](online = Servers)

    (*
        Liveness는 good things do happen이다. 
        
        A property P is deﬁned to be a liveness property 
        <-> 
        Every finite sequence of states can be extended to a behavior that satisﬁes P .

        Liveness를 깨려면 유한 sequence로는 불가능하고, 무한한 sequence가 필요하다.
        왜냐면 유한 seq에서는 만족 못하지만, 미래에는 만족할 수 있기 때문이다.

        3가지 유형의 counter example이 있다.
            1. 무한한 sequence가 있지만, 계속 만족 못하는 경우 : x = 0; while true {x--;} 일때 P : eventually x = 1
            2. crash, deadlock, running to completion : 더 이상 progress를 만들지 않음 
            3. cycle이 존재해, 특정 상태에 도달 못하고 계속 도는 경우 -> lassos(올가미)라고 부른다. (fairness 필요) 

        2번은 3번의 특수한 경우이다. (self loop)
    
        위의 정의된 liveness property는 
        "항상 모든 server가 온라인이지는 않다. 즉 일부 혹은 모두 오프라인인 상태가 존재할 수 있다." 이다.

        돌리면 error가 뜬다. 
        stutter step이 존재하기 때문이다. 
        - stutter step : 다음 state가 이전 state와 같은 step이다. skip이다. 
        - 기존 invariant만 다룰 때는 stutter step이 문제가 되지 않는다. ( 상태가 변하지 않아, 이전 상태가 깨지지 않았다면, 깨질 이유가 없다. )
        -  So even if the system infinitely stutters all the safety properties will still hold. 
    
        만약 online = Servers 인 상태 이후 stutter step이 무한히 발생하면,
        live property를 만족하지 못한다.

        crash를 stutter step으로 생각한다. (self loop)
    
        fairness가 필요하다.
    *)
end define;

\* process orchestrator = "orchestrator"
fair process orchestrator = "orchestrator"
begin
    Change:
        while TRUE do 
            with s \in Servers do 
                either
                    await s \notin online;
                    online := online \cup {s};
                or
                    await s \in online;
                    await Cardinality(online) > 1;
                    online := online \ {s};
                end either;
            end with;
        end while;
end process;

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "3e62301a" /\ chksum(tla) = "f78a5057")
VARIABLE online

(* define statement *)
    Invariant == \E s \in Servers: s \in online
    Safety == \E s \in Servers: [](s \in online)


































Liveness == ~[](online = Servers)


vars == << online >>

ProcSet == {"orchestrator"}

Init == (* Global variables *)
        /\ online = Servers

orchestrator == \E s \in Servers:
                  \/ /\ s \notin online
                     /\ online' = (online \cup {s})
                  \/ /\ s \in online
                     /\ Cardinality(online) > 1
                     /\ online' = online \ {s}

Next == orchestrator

Spec == /\ Init /\ [][Next]_vars
        /\ WF_vars(orchestrator)

\* END TRANSLATION 

====
