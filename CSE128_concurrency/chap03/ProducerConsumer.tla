---- MODULE ProducerConsumer ----
EXTENDS PCCallReturn, Sequences, Naturals

CONSTANT N 
ASSUME (N \in Nat) /\ (N > 0)

VARIABLE q 

PCTypeOk == /\ CRTypeOK
            /\ q \in Seq(Input) 
            /\ Len(q) <= N

PCInit == CRInit /\ q = <<>>

PCCall(v) == /\ Len(q) < N 
             /\ Call(v) 
             /\ q' = Append(q, v)

PCReturn == /\ Len(q) > 0 
            /\ Return(RtnVal(Head(q)))
            /\ q' = Tail(q)

PCNext == (\E v \in Input: PCCall(v)) \/ PCReturn 

PCSpec == PCInit /\ [][PCNext]_<<q, iFace>>

NonstopPCSpec == PCSpec /\ WF_<<q, iFace>>(PCNext)

THEOREM PCSpec => []PCTypeOk

====