%%%%%%%%
% Heuristic that searches all empty places where if a token was placed would make 4 in a row




%TODO: Define the heuristic
%x is positive, o is negative
value(Board, Value):-
	findall([Row, Column], areInBoard(Row, Column), Coords),
	sumValues(Coords,Board, Value).

sumValues([],Board,0).

sumValues([[Row, Column] | T], Board, Value) :-
	sumValues(T, Board, ValueRest),
	valueRowColumn(Row, Column, Board, ValueThis),
	Value is ValueRest + ValueThis.

areInBoard(Row, Column) :-
	between(0, 6, Column),
	between(0,5, Row).



nextColumnRow(Row, Column, Direction, NewRow, NewColumn) :-
	nth0(0,Direction, AddColumn),
	nth0(1,Direction, AddRow),
	NewRow is Row+AddRow,
	NewColumn is Column+AddColumn.

valueRowColumn( Row, Column, Board, Value) :-
	nth0(Column, Board, ColumnElement),
	nth0(Row, ColumnElement, Element),
	var(Element),
	nextColumnRow(Row, Column, [1,1], NextRow, NextColumn),
	nextColumnRow(Row, Column, [-1, -1], PreviousRow, PreviousColumn),

	%Horizontal
	countTokensDirection(Board, [1,0], TokenRight, Row, NextColumn, NbTokensRight),
	countTokensDirection(Board, [-1,0], TokenLeft, Row, PreviousColumn, NbTokensLeft),

	%vertical
	countTokensDirection(Board, [0,1], TokenUp, NextRow, Column, NbTokensUp),
	countTokensDirection(Board, [0,-1], TokenDown, PreviousRow, Column, NbTokensDown),

	%diagonal up
	countTokensDirection(Board, [1,1], TokenRightUp, NextRow, NextColumn, NbTokensRightUp),
	countTokensDirection(Board, [-1,1], TokenLeftUp, NextRow, PreviousColumn, NbTokensLeftUp),

	%diagonal down
	countTokensDirection(Board, [1,-1], TokenRightDown, PreviousRow, NextColumn, NbTokensRightDown),
	countTokensDirection(Board, [-1,-1], TokenLeftDown, PreviousRow, PreviousColumn, NbTokensLeftDown),

	((has3Conected('x', TokenLeft, TokenRight, NbTokensLeft, NbTokensRight) ;
	has3Conected('x', TokenDown, TokenUp, NbTokensDown, NbTokensUp);
	has3Conected('x', TokenLeftUp, TokenRightUp, NbTokensLeftUp, NbTokensRightUp);
	has3Conected('x', TokenLeftDown, TokenRightDown, NbTokensLeftDown, NbTokensRightDown))->
		XHas3 is 1
		;
		XHas3 is 0
	),
	((has3Conected('o', TokenLeft, TokenRight, NbTokensLeft, NbTokensRight) ;
	has3Conected('o', TokenDown, TokenUp, NbTokensDown, NbTokensUp);
	has3Conected('o', TokenLeftUp, TokenRightUp, NbTokensLeftUp, NbTokensRightUp);
	has3Conected('o', TokenLeftDown, TokenRightDown, NbTokensLeftDown, NbTokensRightDown))->
		OHas3 is 1
		;
		OHas3 is 0
	),
	(OHas3 == XHas3->
		Value is 0
	;
	OHas3 == 1 -> Value is -100
	;
	XHas3 == 1 -> Value is 100
	;
	Value is 0
	)
	.

has3Conected(TokenThatHas3,Token1, Token2, Nb1, Nb2) :-
	TokenThatHas3 == Token1,
	Nb1 > 2;
	TokenThatHas3 = Token2,
	Nb2 > 2;
	TokenThatHas3 == Token1,
	TokenThatHas3 == Token2,
	NewN is Nb1 + Nb2,
	NewN > 2.


countTokensDirection(Board, Direction, Token, Row, Column, NbTokens) :-
	areInBoard(Row, Column),
	nth0(Column, Board, ColumnElement),
	nth0(Row, ColumnElement, Element),
	(var(Token) ->
		(var(Element)->
			NbTokens is 0,
			fail
		;%else
			Token = Element
		)
	;%else
		true
	)
	,
	(Element==Token ->
		nextColumnRow(Row, Column, Direction, NewRow, NewColumn),
		countTokensDirection(Board, Direction, Token, NewRow, NewColumn, NextNbTokens),
		NbTokens is NextNbTokens+1
	;
		NbTokens is 0
	).

countTokensDirection(Board, Direction, Token, Row, Column, 0).

valueRowColumn( Row, Column, Board, Value) :-
	nth0(Column, Board, ColumnElement),
	nth0(Row, ColumnElement, Element),
	valueFullSlot(Row, Column, Element, Board, ValuePosSlot),
	modifier(Element, Modifier),
	Value is ValuePosSlot*Modifier,
	!.

modifier('o', -1).
modifier('x', 1).

valueFullSlot(Row, 0, Element, Board, 0).
valueFullSlot(Row, 1, Element, Board, 1).
valueFullSlot(Row, 2, Element, Board, 2).
valueFullSlot(Row, 3, Element, Board, 3).
valueFullSlot(Row, 4, Element, Board, 2).
valueFullSlot(Row, 5, Element, Board, 1).
valueFullSlot(Row, 6, Element, Board, 0).




