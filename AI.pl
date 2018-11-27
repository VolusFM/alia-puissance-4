%Choose best move from the actual position searching Depth turns
%BestMove is the best move in the form (move, value)
%Record is the best move until now in the form (move, value)
evaluate_and_choose([Move|Moves], Player, Board, Depth, MaxMin, Record, BestMove):-
    playMove(Board,Move,NewBoard,Player),
    changePlayer(Player, NewPlayer),
    minimax(Depth, NewBoard, NewPlayer, MaxMin, MoveX, Value),
    update(Move, Value, Record, NewRecord),
    evaluate_and_choose(Moves, Board, Player, Depth, MaxMin, NewRecord, BestMove).

evaluate_and_choose([], Board, Player, Depth, MaxMin, Record, Record).

minimax(0, Board, Player, MaxMin, Move, Value):-
    value(Board, ValueBoard),
    Value is ValueBoard*MaxMin.

minimax(Depth, Board, Player, MaxMin, Move, Value) :-
    Depth > 0,
    %TODO: realation move
    set_of(M, possible_move(Board, M), Moves),
    NewDepth is Depth - 1,
    MinMax is -MaxMin,
    evaluate_and_choose(Moves, Board, NewDepth, MinMax, (nil, -1000),
                        (Move, Value)).
update(Move, Value, (Move1, Value1), (Move1, Value1)):-
    Value <= Value1.

update(Move, Value, (Move1, Value1), (Move, Value)) :-
    Value > Value1.

%Define the heuristic
value(Board, 1).




