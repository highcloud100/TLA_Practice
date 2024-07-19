---- MODULE BothTLA+AndPlusCal ----
EXTENDS TLC

\* use assume 
\* 주로 constant의 값을 제한하기 위해 사용
CONSTANT Threads, NULL 
ASSUME Threads # {} 
ASSUME NULL \notin Threads

\* TLC는 set of integers, string을 가지지 않는다. 
\* 이를 사용하고 싶다면, struct를 만들고, type, val field로 느낌을 낼 수 있다.

{
    [type |-> "int", val |-> 1],
    [type |-> "str", val |-> "1"]
}

\* Decompose function of structs 
\* variable을 한 step에 한개만 수정가능하다. 사람들은 구조체의 함수들로 변수를 만드는데
\* 고로 변수를 쪼개 사용하길 추천한다.

VARIABLE state
WorkerState == [queue: Seq(Msg), online: BOOLEAN]
Types ==
  state \in [Worker -> WorkerState]

\* 이 방법보다 아래의 방식으로 

VARIABLES worker_queue, worker_online

Types ==
  /\ worker_queue \in [Worker -> Seq(Msg)]
  /\ worker_online \in [Worker -> BOOLEAN]

\* Safety와 Liveness models
\* 보통 liveness는 check하는데 오래걸려서, 나누어둠

\* THEOREM
\* spec의 properties를 나타내기 위해 사용된다.
\* model checker는 관련해 아무 일도 안한다. 즉 document용
THEOREM Spec => []TypeInvariant

\* TypeInvariant 
\* type invariant는 정말 가능한 bound check만 한다. 
\* 예로 두 set이 int 인지만 확인한다. 
\* 만약 시스템 상 두 set이 disjoint 해야한다면, 따로 invariant를 만든다. 

\* while은 iter마다 새로운 state를 만든다.

Double:
  while i <= Len(seq) do
    seq[i] := seq[i] * 2;
    i := i + 1;
  end while;

\* 대신 아래처럼 하자.
Double:
  seq := [i \in 1..Len(seq) |-> seq[i] * 2];


====