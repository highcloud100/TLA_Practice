---- MODULE nond ----
EXTENDS TLC
(*--algorithm nond

begin
    
\* set local variable
with x \in BOOLEAN, \* nondeterministic assignment
     y \in 1..10,
     z = TRUE
    do
        ~~~ 
end with;

\* either-or : nondeterministic control flow
\* TLC will make three branches -> it will be useuseful for implementing state machine
either
    block1
or
    block2
or 
    block3
end either;

\* nondeterministic은 specification과 programming language 사이 중요한 gap이다. 
\* 또한 추상화의 수준을 높이는 요소이다.

\* 예를 들어 고객이 request 요청을 한 상황을 보자. 
\* 성공한 경우도 있지만, 실패하는 경우도 많다. 이때 모든 실패하는 경우를 다 고려하기 어렵다.
\* 이에 detail을 날리고 abstraction을 높여 spec을 작성할 수 있다.

macro request_resource(r) begin
    either
        reserved := reserved \union {r};
    or 
        \* for recovery logic
        with reason \in {"no resource", "no permission", "no connection"} do 
            failure_reason := reson;
        end with;
    or
        \* Request failed
        skip;
    end either;
end macro;

\* nondeterministic을 outside action을 표시하는데 사용할 수 있다.
\* 예로 system으로 들어오는 request를 다룬다면, 구체적인 request를 뽑아 다룰 필요가 없다. 
\* 대신 request type을 만들어, 모든 inbound request를 다룰 수 있다.

RequestType == [from: Client, type: {"GET", "POST", "PUT", "DELETE"}, param: ParamType]

with request \in RequestType do
    if request.type = "GET" then
        \* do something
    elsif request.type = "POST" then
        \* do something
    else 
        \* something's wrong with our spec!
        assert FALSE;
    end if;
end with;




skip;
end algorithm; *)
====