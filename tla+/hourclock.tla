---- MODULE hourclock ----
EXTENDS TLC, Naturals

(*--algorithm hourclock
variable hr = 1;

begin
    A:
        while TRUE do 
            if hr = 12 then 
                hr := 1;
            else 
                hr := hr + 1;
            end if;
        end while;

(*
    tla+ 에서 Spec은 항상 temporal property to run 을 적는다. 

VARIABLE hr

vars == << hr >>

Init == 
        /\ hr = 1

Next == IF hr = 12
           THEN /\ hr' = 1
           ELSE /\ hr' = hr + 1

Spec == Init /\ [][Next]_vars

    여기서 hr' = 1 은 boolean statement 이다.
    Next는 boolean operator이다. 다음에 대해서 Next는 true이다. 
        <<1, 2>>
        <<3, 4>>
        <<12, 1>>
    다음에 대해서는 Next는 false이다.  
        <<1, 1>>
        <<12, 13>>
        <<4, 6>>
        <<9, "corn">>

    이부분에서 우리는 왜 PlusCal에서 = 과 := 이 다른지 알 수 있다. 
    = 은 equality operator이고 := 은 updating에 사용된다. 

    Action : primed variables를 가진 boolean operator이다. 
    It’s the titular action in Temporal Logic of Actions (plus) 
    > The “plus” is for the addition of ZF set theory.
    
    
*)

end algorithm; *)
\* BEGIN TRANSLATION (chksum(pcal) = "2cb5c6e4" /\ chksum(tla) = "f749b589")
VARIABLE hr

vars == << hr >>

Init == (* Global variables *)
        /\ hr = 1

Next == IF hr = 12
           THEN /\ hr' = 1
           ELSE /\ hr' = hr + 1

Spec == Init /\ [][Next]_vars

\* END TRANSLATION 
====
