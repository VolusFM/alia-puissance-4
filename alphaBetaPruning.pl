%Choose best move from the actual position searching Depth turns
%BestMove is the best move in the form (move, value)
%Record is the best move until now in the form (move, value)
%TODO: Test
evaluate_and_choose([Move|_], Player, Board, _, _, _, _, _, BestMove, _):-
    playMove(Board,Move,_,Player, IsWinnerMove),
    IsWinnerMove == 1,
    BestMove = (Move, 999), !.

evaluate_and_choose([Move|Moves], Player, Board, Depth, MaxMin, Alpha, Beta, Record, BestMove, Heuristic):-
    playMove(Board,Move,NewBoard,Player, _),
    changePlayer(Player, NewPlayer),
    MinMax is -MaxMin,
    NewAlpha is -Beta,
    NewBeta is -Alpha,
    alpha_beta(Depth, NewBoard, NewPlayer, MinMax, NewAlpha, NewBeta, _, ValueOpponent, Heuristic),
    MyValue is -ValueOpponent,
    UpdatedAlpha is max(Alpha, MyValue),
    update(Move, MyValue, Record, NewRecord),
    (UpdatedAlpha < Beta->
    	evaluate_and_choose(Moves, Player, Board, Depth, MaxMin, UpdatedAlpha, Beta, NewRecord, BestMove, Heuristic)
    ;
    	BestMove = (Move, UpdatedAlpha)
    ).


%no possible moves to do
evaluate_and_choose([], _, _, _, _, _, _, Record, Record, _).

alpha_beta(0, Board, _, MaxMin, _, _, _, Value, Heuristic):-
	!,value(Board, ValueBoard, Heuristic),
    Value is ValueBoard*MaxMin.





alpha_beta(Depth, Board, Player, MaxMin, Alpha, Beta, Move, Value, Heuristic) :-
    Depth > 0,!,
    %TODO: realation move
    findall(M, possibleMove(Board, M), OrderedMoves),
    random_permutation(OrderedMoves,Moves), %randomnes added to test ai playing with each other
    (Moves==[]-> %draw
    	Value is 0
    ;
    	NewDepth is Depth - 1,
    	evaluate_and_choose(Moves, Player, Board, NewDepth, MaxMin, Alpha, Beta, (nil, -1000),
                        	(Move, Value), Heuristic)
    ).



update(_, Value, (Move1, Value1), (Move1, Value1)):-
    Value =< Value1,!.

update(Move, Value, (_, Value1), (Move, Value)) :-
	Value > Value1.












