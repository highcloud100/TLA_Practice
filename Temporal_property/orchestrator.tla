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

    *)
end define;

process orchestrator = "orchestrator"
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
\* BEGIN TRANSLATION (chksum(pcal) = "600bcc02" /\ chksum(tla) = "7335c8cb")
VARIABLE online

(* define statement *)
Invariant == \E s \in Servers: s \in online
Safety == \E s \in Servers: [](s \in online)


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

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 

====
