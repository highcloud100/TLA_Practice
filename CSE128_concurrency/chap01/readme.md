## Terminology
state : assignment of values of all possible variables

step : pair of states

behavior : infinite sequence of states

1. state function
    - formula that contains only unprimed variables (like x+1%2)
    - by lamport 
        - non-boolean expression that may contain rigid and flexible variables
        - https://lamport.azurewebsites.net/tla/rhtml/state-function.html

2. state predicate
   - boolean-valued state function (like x = 0)
   - by lamport 
       - boolean expression that may contain rigid, flexible variables.
       - https://lamport.azurewebsites.net/tla/rhtml/state-predicate.html
    
3. action 
   - formula like x' = (x+1)%2 A formula like ' = (z + 1) % 2 that may contain primed and unprimed variables, but no [] 
   - state predicate is a degenerate action that contains no primed variables and is thus an assertion only about the old state

    > state predicate는 action과 달리 primed variables이 없다.   
    > 즉 old state에 대해서만 주장한다. 그렇기에 degenerate action이라 표현한 것이다.

4. temporal formula 
   - formula that contains []
   - temporal formula is an assertion about a behavior (seq of states)
   - action is a degenerate temporal formula
       - is an assertion only about first two states of behavior
   - state function is a degenerate temporal formula
       - is an assertion only about first state of behavior

    > temporal formula는 behavior의 주장이다.  
    > action은 behavior의 맨 앞 두 state의 주장이므로, degenerate temporal formula이다.   
    > state function은 맨 앞 상태 (like init)의 주장이므로, degenerate temporl formula


## Three kind of formulas

1. state functions 
    - state predicate is a boolean valued state function.
    > state function is formula?

    > may be not... it is just term  
    > https://en.wikipedia.org/wiki/Well-formed_formula#:~:text=%E2%88%A7%20%C2%ACs))-,Predicate%20logic,-%5Bedit%5D

1. actions 
    - true or false of a step
2. temporal formula
    - true or false of all behaviors

> Theorem if it is true of all behaviors.

## HOMEWORK

Osc implements random walk. 
- Osc => random walk

Because Osc is special case of random walk that alternating Inc and Dec

```cfg 
//OscImplementsRW.cfg
SPECIFICATION 
    OscSpec

INVARIANTS 
    TypeInv

PROPERTIES 
    RWSpec
```