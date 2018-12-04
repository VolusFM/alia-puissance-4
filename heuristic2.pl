%%%%%%%%
% Heuristic that searches all empty places where if a token was placed would make 4 in a row

value(Board, Value):-
	Value is 0,
	!.



%TODO: Define the heuristic
%x is positive, o is negative
value(Board, Value):-
	valueOfColumn(Column, ValueColumn),
	findall([Row, Column], areInBoard(Row, Column), Coords),
	sumValues(Coords,Board, Value).

areInBoard(Row, Column) :-
	Row >= 0,
	Column >= 0,
	Row < 6,
	Column < 7.



valueElement( Row, Column, Board) :-
	Value is 0.

sumValues([],Board,0).

sumValues([[Row, Column] | T], Board, Value) :-
	sumValues(T, Board, ValueRest),
	valueElement(Row, Column, Board, ValueCase),
	Value is NewValue + ValueCase.

rowColumnValue(Row,Column,Board,Value):-





isEmpty(Row, Column, Board) :-
	nth0(Row, Board, Element),
	nth0(Column, Element, '.').