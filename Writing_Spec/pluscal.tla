---- MODULE pluscal ----
EXTENDS TLC, Integers

(*--algorithm pluscal

variables 
    x = 2;
    y = TRUE;
    bool = TRUE;
begin
    (*
        := 는 존재하는 변수에 대해 업데이트하고 싶을때 사용
        아닌 경우 = 사용
    *)
    A:
        if bool=FALSE then 
            B: x := x + 1;
        else
            y := FALSE;
        end if;
            C: x:= 2;
    D:
        x := x + 1;
        y := FALSE;    
end algorithm; *)

(*
    label은 instant of time 의 atomic한 작업 단위라고 생각하면 된다. 

    1. 모든 statements는 label에 속한다. 
    2. 모든 variable은 label당 한번 업데이트 되어야 한다. 
        -> "||" simultaneous assignment를 이용해서 여러번 업데이트 가능하다. 

Label:  // 틀림
  seq[1] := seq[1] + 1;
  seq[2] := seq[2] - 1;

Label:  // 가능 
  seq[1] := seq[1] + 1 ||
  seq[2] := seq[2] - 1;

A:
  if bool then
    B:
      skip;
  else
    skip;
  end if;
  x := 1; 

에서 x:=1은 A혹은 B에 속하게 된다. 이런 모호함을 막기 위해 
C 라벨을 추가해서 x:=1을 C에 속하게 한다.



*)


====
