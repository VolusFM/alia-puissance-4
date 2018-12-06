%Choose best move from the actual position searching Depth turns
%BestMove is the best move in the form (move, value)
%Record is the best move until now in the form (move, value)
%TODO: Test
evaluate_and_choose([Move|Moves], Player, Board, Depth, MaxMin, Record, BestMove):-
    playMove(Board,Move,NewBoard,Player, IsWinnerMove),
    IsWinnerMove == 1,
    BestMove = (Move, 999), !.

evaluate_and_choose([Move|Moves], Player, Board, Depth, MaxMin, Record, BestMove):-
    playMove(Board,Move,NewBoard,Player),
    changePlayer(Player, NewPlayer),
    MinMax is -MaxMin,
    minimax(Depth, NewBoard, NewPlayer, MinMax, MoveX, ValueOpponent),
    MyValue is -ValueOpponent,
    update(Move, MyValue, Record, NewRecord),
    evaluate_and_choose(Moves, Player, Board, Depth, MaxMin, NewRecord, BestMove).

%no possible moves to do
%TODO: implement draw win or lose when no moves
evaluate_and_choose([], Board, Player, Depth, MaxMin, Record, Record).

minimax(0, Board, Player, MaxMin, Move, Value):-
	value(Board, ValueBoard),
    Value is ValueBoard*MaxMin.



minimax(Depth, Board, Player, MaxMin, Move, Value) :-
    Depth > 0,
    %TODO: realation move
    setof(M, possibleMove(Board, M), Moves),
    NewDepth is Depth - 1,
    evaluate_and_choose(Moves, Player, Board, NewDepth, MaxMin, (nil, -1000),
                        (Move, Value)).

update(Move, Value, (Move1, Value1), (Move1, Value1)):-
    Value =< Value1.

update(Move, Value, (Move1, Value1), (Move, Value)) :-
	Value > Value1.









