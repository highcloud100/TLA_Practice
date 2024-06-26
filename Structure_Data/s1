---- MODULE struct ----
EXTENDS TLC, Naturals, Sequences

\* string hash map
struct == [a |-> 1, b |-> {}]

\* sequence의 모든 value를 얻는 방법
RangeSeq(seq) == {seq[i]: i \in 1..Len(seq)}

\* struct의 모든 value를 얻는 방법
RangeStruct(st) == {st[key]: key \in DOMAIN st}

Prod == 
    LET S == 1..10 IN
    [p \in S \X S |-> p[1] * p[2]]

TruthTable == [p, q \in BOOLEAN  |-> p => q]

Zip1(seq1, seq2) ==
    LET Min(a,b) == IF a < b THEN a ELSE b 
        N == Min(Len(seq1), Len(seq2))
    IN 
        [i \in 1..N |-> <<seq1[i], seq2[i]>>]

Zip2(seq1, seq2) == 
    LET N == (DOMAIN  seq1) \intersect (DOMAIN seq2)
    IN 
        [i \in N |-> <<seq1[i], seq2[i]>>]


 
seqs == <<1,2,3>>
test == [DOMAIN seqs -> RangeSeq(seqs)]
====

RangeStruct(<<"a","b","a">>)
\* 잘 작동한다. 이유는 sequence의 domain은 index이다.
\* DOMAIN seq == 1..Len(seq) 
\* struct의 domain은 set of strings 이다. 

\* 사실 tla+는 두가지 collection만 존재한다.
\* 1. sets
\* 2. functions <- sequence, struct 는 이것을 확장한 것이다. 

(*
   Functions

   F == [ x \in S |-> expr ] 
   S is domain of the function 
*)

Prod[<<2,3>>]
Prod[3,4]

TruthTable

(*
(<<FALSE, FALSE>> :> TRUE @@
 <<FALSE, TRUE>> :> TRUE @@
 <<TRUE, FALSE>> :> FALSE @@
 <<TRUE, TRUE>> :> TRUE)

    x :> y 는 single valued function mapping x to y 이다.
    @@는 function을 merge하는 것이다. 
    - 만약 두 function의 domain이 겹치면, 왼쪽에 있는 것이 우선이다.  

*)

\* sequence
1 :> "a" @@ 2 :> "b"

\* struct
"a" :> 1 @@ "b" :> 2

\* zip check
LET 
    S == 1..4 
    Input == (S \X S \X S) \union (S \X S)
IN 
    \A s1, s2 \in Input :
        Zip1(s1, s2) = Zip2(s1, s2)

\* function을 value처럼 사용
\* VARIABLES 
\*     assignments = [t \in Tasks |-> {}]
\* 다음과 같이 task들을 정의한다.

\* assignments["task1"] := assignments["task1"] \cup {cpu1}
\* 이런 식으로 cpu에 assignment를 할당 가능하다.

\* cpu당 task 1개를 invariant로 정의하고 싶다면 다음과 같이 할 수 있다.

\* OnlyOneTaskPerCpu == 
\*     \A t1, t2 \in Tasks, c \in CPU:
\*         /\ (t1 # t2)
\*         /\ c \in assignments[t1] => c \notin assignments[t2]

\* OnlyOneTaskPerCpu2 ==
\*     \A t1, t2 \in Tasks, c \in CPU:
\*         /\ (t1 # t2) 
\*         /\ assignments[t1] \intersect assignments[t2] = {}

\* 여기서 assignments는 function들이고 
\* 이 function set은 [Tasks -> SUBSET CPU] 으로 표현할 수 있다.


(*
IsSorted(seq) ==
  \A i, j \in 1..Len(seq):
    i < j => seq[i] <= seq[j]

위 정의의 문제는 Sort 함수를 빈 seq반환하는 함수로 만들어도 IsSorted를 만족한다는 것이다.

좀더 강한 정의가 필요하다. 

정렬을 다음과 같이 정의할 수 있다. 

Sort (seq) == 
        CHOOSE sorted \in [DOMAIN seq -> Range(seq)]:
            /\ \A i \in DOMAIN seq :
                CountMatching(seq, seq[i]) = countMatching(sorted, seq[i])
            /\ ISorted(sorted)

1. CHOOSE 
seqs == <<1,2,3>>
test == [DOMAIN seqs -> RangeSeq(seqs)]

이런 방식으로 function set을 만들 수 있다. 
이러면 function set의 개수는 3^3 = 27개가 된다. 

각 인덱스가 Range의 값으로 mapping되고, 
이는 결국 Range에서 수를 뽑아 만들 수 있는 Sequence들의 집합이 된다.

2. CountMatching
CountMatching(seq, elem) == 
    CARDINALITY({i \in DOMAIN seq : seq[i] = elem})

어떤 elem이 seq에서 몇번 나오는지를 세는 함수이다.

두번째 조건은 choose로 뽑힌 sorted가 기존 seq와 같은 element를 가지고 있는지 확인하는 것이다. 

3. ISorted
기존 정의와 같다. 
*)
test

(*
function set을 이용하면

seq \in S \X S \X S \X S 을 다음과 같이 바꿀 수 있다.
seq \in [1..5 -> S];

*)