# tla+의 모듈에 관한 이해
- https://lamport.azurewebsites.net/tla/newmodule.html#Section2


```tla
   ----------- MODULE DirectedGraphs ------------
    body                       
   ----------------------------------------------
    more body
   ==============================================
```

body는 statements의 seq이다. 
statements는  declaration, definition, assumption, or theorem 으로 이루어진다.

```
------------------------------
```
이것은 statements를 구분하기 위한 데코레이션일 뿐이다.

### declaration

```tla
CONSTANT Node, Edge \* 상수 
VARIABLES data \* 변수
```

declaration statements는 위와 같다.
module에 symbol을 추가한다는 의미다. 
declared symbol은 "free parameter"이다. 

### definition

```
NonEdge == (Node \X Node) \ Edge

\* 위의 정의를 아래에 사용할 수 있다.
NonTrivialNonEdge == NonEdge \ {<<n, n>> : n \in Node}

\* NonTrivialNonEdge는 다음과 같이 해석될 수 있다.
NonTrivialNonEdge == ((Node \X Node) \ Edge) \ {<<$n, $n>> : $n \in Node}

```

Symbols는 arguments를 가지는 equal operator로도 정의할 수 있다. 

```
Nbrs(n, m) == <<n, m>> \in Edge
```

> funciton과 다르다.

symbol Nbrs는 any expression인 exp_1과 exp_2를 n과 m에 assign하는 operator로 볼 수 있다.  

이 operator를 다음과 같이 표현할 수 있다.
```
LAMBDA $n, $m : <<$n, $m>> \in \ Edge
```

- We use LAMBDA only to describe the semantics of modules; it is not an operator of TLA+. 
- tla2에 lambda expressions이 추가됨
  - https://lamport.azurewebsites.net/tla/tla2-guide.pdf

> The precise rule for turning a definition statement into a definition is: First replace all defined symbols to the right of the == by their definitions; "beta-reduce" LAMBDA expressions when possible--for example, reduce 
>
>  (LAMBDA \$a : <<\$a, $a>> \in S)(Y+Z)
> 
> to <<Y+Z, Y+Z>> \in S--and finally, replace all bound symbols, including the parameters of the definition (the symbols n and m in the definition of Nbrs) by "untypable" symbols that do not already appear in the expression.

== 오른쪽에는 TLA+의 primitives와 symbols만 올 수 있다. (defined, declared, definition parameters)

재귀적 정의는 허용안된다. 

## Including One Module in Another

EXTENDS는 Foo, Bar의 declarations와 definitions를 현재 module에 body에 넣는 것과 동일하다.
```
EXTENDS Foo, Bar
```

다른 방법은 INSTANCE이다. 

```
   ------------------ MODULE SGraphs ------------------
   CONSTANT S

   Edge == { <<m, n>> \in S \X S : m \in n }

   INSTANCE DirectedGraphs WITH Node <- S, Edge <- Edge
   ====================================================
```

DirectedGraphs의 definitions들을 symbol들이 교체된 상태로 가져온다. 
즉 아래와 같이 변한 상태로 불러오게된다. 

```
NonEdge is defined to equal
   (S \X S) \ { <<$m, $n>> \in S \X S : $m \in $n }
Nbrs is defined to equal
LAMBDA $n, $m : <<$n, $m>> \in 
                  { <<$m, $n>> \in S \X S : $m \in $n }
```

같은 symbol로 subst하는 경우가 많기에, subst를 명시적으로 적지 않으면, 같은 것으로 subst한다고 본다.
(s <- s
여기서 현재 모듈(불러오는)에 s가 정의가 되어 있음을 가정한다. )

같은 module을 여러개 필요로 할 수 있다. 이 경우 name space를 만들어 해결할 수 있다.

```
Foo == INSTANCE DirectedGraphs WITH Node <- S 
```

> variable도 subst 대상이다. 
