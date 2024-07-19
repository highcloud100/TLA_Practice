---- MODULE TwoPhase ----
EXTENDS CallReturn, Naturals 
VARIABLE c, r

(*
    기존의 alternation system을 다른 방식으로 구현할 수 있다.
    x 값인 0과 1이 반복되는 spec을 client와 server가 번갈아가며 호출하는 방식으로 구현할 수 있다.

    기존의 CallReturn의 arg와 rtn이라는 변수는 두 component의 연결 wire의 전압을 나타낸다.

    x를 client와 server 양측 모두 업데이트할 수 있게 만드는 것은 어렵다.
    (하나의 wire의 전압을 양쪽에서 조절하도록 만들기는 실제로 어렵다.)
    그래서 새로운 wire 역할의 변수인 c와 r을 추가한다.

    x는 (c+r) mod 2로 구현한다.

    spec의 직관적인 이해는
    순차적으로 call과 return을 번갈아가며 수행된다는 것이다.
    이는 ( c = r, c # r )이라는 조건으로 구현된다.

    이런 방식을 Two-Phase Protocol이라고 한다.
*)

TPInit == /\ CRInit
          /\ c = 0
          /\ r = 0

TPCall == /\ c = r 
          /\ Call 
          /\ c' = (c+1) % 2
          /\ r' = r 

TPReturn == /\ c # r 
            /\ Return 
            /\ r' = (r+1) % 2
            /\ c' = c

TPNext == TPCall \/ TPReturn

TPSpec == TPInit /\ [][TPNext]_<<iFace, c, r>>

CS

TPInvariant == /\ CRInvariant
               /\ c \in {0,1}
               /\ r \in {0,1}

THEOREM TPSpec => []TPInvariant 

Bar == INSTANCE Alternation WITH x <- (c+r) % 2
BarAltSpec == Bar!AltSpec 
THEOREM TPSpec => Bar!AltSpec

(*
    Two-Phase Protocol은 Alternation과 동일한 spec을 구현한다.
    이를 증명하기 위해 Alternation의 INSTANCE를 생성하고 x를 (c+r) % 2로 설정한다.
    - 이는 Alternation의 모든 x가 (c+r) % 2로 바뀐다. 

    이제 TPSpec -> AltSpec을 증명하는 방식은 다음과 같다. 

    1. TPInit => Bar!AltInit
    2. TPNext => Bar!AltNext
        - TPCall => Bar!AltCall
        - TPReturn => Bar!AltReturn

    2-1번의 증명을 하는 것은

    /\ c = r
    /\ c' = (c+1)%2
    /\ r' = r

    ->

    /\ (c+r) % 2 = 0
    /\ (c'+r') % 2 = 1

    을 보이는 것이다. 만약 c와 r이 int라면 증명은 쉬워진다. 
    하지만 TPCall에는 c와 r이 int라는 정보가 없다.

    추가적인 정보를 위해 TypeInvariant를 이용한다. 
    TPInvariant를 통해 c와 r이 0과 1의 값만 가질 수 있다는 것을 알 수 있다.

    고로 증명 과정은 다음과 같다.  
    1. TPSpec => []TPInvariant
    2. TPInit => Bar!AltInit
    3. TPNext /\ TPInvariant => Bar!AltNext
        - TPCall => Bar!AltCall
        - TPReturn => Bar!AltReturn

    이를 직접 증명하는 것이 아닌 TLC를 이용하면 자동으로 증명이 된다. 
    
    ```TwoPhase.cfg 
    SPECIFICATION TPSpec 
    INVARIANT TPInvariant
    PROPERTIES  BarAltSpec
    ```

    > Bar!AltSpec은 사용 못한다.  
    > The current version of TLC allows only a simple identifier as a PROPERTY. So, we must define a simple identifier to equal Bar!AltSpec.
    > This is done in module MCTwoPhase. 

*)

====