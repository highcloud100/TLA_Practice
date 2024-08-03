-------------------------- MODULE MCBankingSystem --------------------------- 
(***************************************************************************)
(* This module allows us to use TLC to check a finite model of the         *)
(* specification in the BankingSystem module.                              *)
(***************************************************************************)

EXTENDS IBankingSystem

CONSTANTS MaxBalance, MaxTransaction
  (*************************************************************************)
  (* The finite model contains states in which clients' balances are at    *)
  (* most MaxBalance, and the amt field in a request is at most            *)
  (* MaxTransaction.                                                       *)
  (*************************************************************************)
  
MCConstraint == \A c \in Client : sstate[c] \leq MaxBalance
  (*************************************************************************)
  (* This is the constraint we give to TLC to bound the state space that   *)
  (* it explores.                                                          *)
  (*************************************************************************)

(***************************************************************************)
(* The next-state relation contains quantification over the set Request,   *)
(* and the definition of Response requires TLC to enumerate all elements   *)
(* of Request and State.  Since those are infinite sets, we tell TLC to    *)
(* replace them with the following finite ones.                            *)
(***************************************************************************)
MCState == [Client -> 0..(MaxBalance+MaxTransaction)]

\* sstate를 Max이하로 제한했어도, State는 여전히 무한 공간을 가진다.
\* State를 가지는 Set을 계산하기 위해 무한번 돌아야한다. 고로 제한해준다.
\* 여기서 더 큰 값으로 제약하는 이유는 위배되는 경우의 타입체킹이 위배되지 않게하기 위해서다. (아래 영문 참고)
\* 왜냐면 TLC는 제약을 만족하는 상태에서 한 스텝만으로 도달 가능한 모든 상태를 체크하기 때문이다.

  (*************************************************************************)
  (* TLC checks all states reachable in one step from a state satisfying   *)
  (* the constraint.  To prevent the type checking invariant from being    *)
  (* violated, we therefore have to replace the set State with the set of  *)
  (* states in which each client's balance is at most MaxBalance +         *)
  (* MaxTransaction.                                                       *)
  (*************************************************************************)
  
MCRequest == [type : {"deposit", "withdraw"}, amt : 0..MaxTransaction]
               \cup
             [type : {"transfer"}, dest : Client, amt : 0..MaxTransaction]

\* req도 무한 공간을 가지는데, TLC에서 \E r \in req 같이 quantification은 유한 sets에 대해서만 가능하다. 
\* 고로 제한해준다.

(***************************************************************************)
(* It's a good idea to check that a specification satisfies liveness       *)
(* properties.  Our specification should this one.                         *)
(***************************************************************************)
MCLiveness ==
   \A c \in Client : (cstate[c].ctl = "calling") ~> (cstate[c].ctl = "idle")
=============================================================================
Run on 20 Sep 2002 on laptop with
    MaxBalance = 3
    MaxTransaction = 1  to get:

Model checking completed. No error has been found.
  Estimates of the probability that TLC did not check all reachable states
  because two distinct states had the same fingerprint:
    calculated (optimistic):  4.0796413122712316E-10
    based on the actual fingerprints:  6.603397860911806E-10
200876 states generated, 49820 distinct states found, 0 states left on queue.
The depth of the state graph search is 38.


Run on 20 Sep 2002 on laptop with
    MaxBalance = 3
    MaxTransaction = 2  to get:
Model checking completed. No error has been found.
  Estimates of the probability that TLC did not check all reachable states
  because two distinct states had the same fingerprint:
    calculated (optimistic):  1.9486921937206247E-9
    based on the actual fingerprints:  6.784346802001016E-10
461952 states generated, 99056 distinct states found, 0 states left on queue.
The depth of the state graph search is 26.