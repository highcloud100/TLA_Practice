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

    Action : primed variables(')를 가진 boolean operator이다. 
    It’s the titular action in Temporal Logic of Actions (plus) 
    > The “plus” is for the addition of ZF set theory.
    
    next action은 모든 변수를 완전히 설명해야 한다. ( 안쓰는 변수가 있더라도 )
    The next action must fully describe all variables


    pluscal에서의 with은 tla+에서의 LET으로 번역된다. 
    with x = 1 do
        hr := hr + x;
    end with;

    -> 

    LET x == 1 IN 
        hr' = hr + 1

    만약 quantifier안에 hr' assign이 있으면,  

    with x \in 1..2 do
        hr := hr + x;
    end with;

    ->

    \/ hr' = hr + 1  
    \/ hr' = hr + 2 

    로 번역된다. 
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

(* 
    EXCEPT

    VARIABLE s
    Init == s = <<TRUE, FALSE>>
    Next == s[1]' = FALSE
    Spec == Init /\ [][Next]_s

    위의 spec은 틀렸다. 
    "In evaluation, the identifier s is either undefined or not an operator."

    하지만 위에 defined되었다. 무슨 상황인건가?
    이는 s의 상태가 애매하기 때문이다. Next에서 s[2]에 대해서 아무런 언급이 없기에 그렇다. 

    <<FALSE, FALSE>>
    <<FALSE, TRUE>>
    <<FALSE, 186>>
    <<FALSE>>
    0 :> 🌽 @@ 1 :> FALSE @@ 🌽 :> 🌽🌽🌽

    이 모든 경우의 s가 Next를 만족한다. 
    그렇기에 s'에 완전한 정보를 제시해야 한다. 
    이를 위해서 EXCEPT 키워드가 존재한다. 

    Next == s' = [s EXCEPT ![1] = FALSE]

    !은 selector이다. [1]은 element이다. 
    이는 s의 1번째 element를 FALSE로 바꾸고, 나머지는 그대로 유지한다.

    이에대한 여러 예시가 있다. 

    1. Next == s' = [s EXCEPT ![1] = FALSE, ![2] = 17] 
        
        여러 값을 지정할 수 있다. 

    2. IncCounter(c) ==
            counter' = [counter EXCEPT ![c] = @ + 1]
        
        특정 key의 original value를 '@'로 지정할 수 있다. 여기서는 기존 counter[c]를 @가 의미한다. 

    3. Init == s = <<[x |-> TRUE], FALSE>>
       Next == s' = [s EXCEPT ![1].x = ~@]

        nested하게 접근할 수 있다. ( 여기서 @는 무엇을 의미하는가 ? )

    pluscal에서도 @을 사용할 수 있다. 
    counter[i] := @ + 1;
*)