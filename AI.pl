%Choose best move from the actual position searching Depth turns
%BestMove is the best move in the form (move, value)
%Record is the best move until now in the form (move, value)
%TODO: Test
evaluate_and_choose([Move|Moves], Player, Board, Depth, MaxMin, Record, BestMove):-
    playMove(Board,Move,NewBoard,Player),
    gameover(Player, NewBoard),
    BestMove = (Move, 1000*MaxMin), !.

evaluate_and_choose([Move|Moves], Player, Board, Depth, MaxMin, Record, BestMove):-
    playMove(Board,Move,NewBoard,Player),
    changePlayer(Player, NewPlayer),
    minimax(Depth, NewBoard, NewPlayer, MaxMin, MoveX, Value),
    update(Move, Value, Record, NewRecord),
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
    MinMax is -MaxMin,
    evaluate_and_choose(Moves, Player, Board, NewDepth, MinMax, (nil, -1000),
                        (Move, Value)).

update(Move, Value, (Move1, Value1), (Move1, Value1)):-
    Value < Value1.

update(Move, Value, (Move1, Value1), (Move, Value)) :-
	Value >= Value1.


value(Board, Value):-
	Value is 0,
	!.

%TODO: Define the heuristic
%x is positive, o is negative
value(Board, Value):-
	set(myBoard,Board),
	findall([Row, Column], isEmpty(Row,Column, Board), EmptyCoords),
	sumValues(EmptyCoords,Board, Value).

sumValues([],Board,0).

sumValues([[Row, Column] | T], Board, Value) :-
	sumValues(T, Board, NewValue),
	rowColumnValue(Row, Column, Board, ValueCase),
	Value is NewValue + ValueCase.

rowColumnValue(Row,Column,Board,2).



isEmpty(Row, Column, Board) :-
	nth0(Row, Board, Element),
	nth0(Column, Element, '.').






