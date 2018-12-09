% The game will be reprensented by 7 lists of 6 elements
% board(column1, column2, colmun3, column4, column5, column6, column7)
% column1(_, _, _, _, _, _) at the beginning, idem for the other columns
% e.g. column1(x, _, _, _, _, _) after the first round
% e.g. column1(x, o, _, _, _, _) after the second round
% until the board is completely instanciated or someone wins

:- dynamic board/1.

applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).

%%%% Test is the game is finished %%%
gameover(Winner, Board) :- winner(Board, Winner), !. % There exists a winning configuration: We cut!
gameover('Draw', Board) :- isBoardFull(Board). % the Board is fully instanciated (no free variable): Draw.

%%%% Recursive predicate that checks if all the elements of the List (a board)
%%%% are instanciated: e.g. true for [x,x,o,o,x,o] false for
%%%% [x, x, o, o, _, x]
isColFull([]).
isColFull([H|T]):- nonvar(H), isColFull(T).

% B needs to have 7 elements
isBoardFull(B):-
    nth0(0, B, Col0), isColFull(Col0),
    nth0(1, B, Col1), isColFull(Col1),
    nth0(2, B, Col2), isColFull(Col2),
    nth0(3, B, Col3), isColFull(Col3),
    nth0(4, B, Col4), isColFull(Col4),
    nth0(5, B, Col5), isColFull(Col5),
    nth0(6, B, Col6), isColFull(Col6).

%%%% Win conditions
winner(Board, Winner) :- fourVertical(Board, Winner).
winner(Board, Winner) :- fourHorizontal(Board, Winner).
winner(Board, Winner) :- fourDiagonalUp(Board, Winner).
winner(Board, Winner) :- fourDiagonalDown(Board, Winner).

%%%% Test if there is column with four adjacent tokens of the same color
% P = 'o'
% Board=[[_ _ _ _], [_ _ _]]
fourVertical(Board, P):-
    append(_, [C|_], Board),
    append(_, [A, B, D, E|_], C),
    A==P, B==P, D==P, E==P.

%%%% Test if there are four columns with a line of four adjacent tokens of the same color.
fourHorizontal(Board, P) :- append(_, [C1, C2, C3, C4|_], Board),
    append(_, [A|X1], C1),
    append(_, [B|X2], C2),
    append(_, [D|X3], C3),
    append(_, [E|X4], C4),
    A==P, B==P, D==P, E==P,
    length(X1, L), length(X2, L), length(X3, L), length(X4, L).

%%%% Test if there are four columns with a diagonal of four adjacent tokens of the same color (going down).
fourDiagonalDown(Board, P):- append(_, [C1, C2, C3, C4|_], Board),
    append(_, [A|X1], C1),
    append(_, [B|X2], C2),
    append(_, [D|X3], C3),
    append(_, [E|X4], C4),
    A==P, B==P, D==P, E==P,
    length(X1, L1), length(X2, L2), length(X3, L3), length(X4, L4), L2 is L1 + 1, L3 is L1 + 2, L4 is L1 + 3.

%%%%% Test if there are four columns with a diagonal of four adjacent tokens of the same color (going up).
fourDiagonalUp(Board, P):- append(_,[C1, C2, C3, C4|_], Board),
    append(_, [A|X1], C1),
    append(_, [B|X2], C2),
    append(_, [D|X3], C3),
    append(_, [E|X4], C4),
    A==P, B==P, D==P, E==P,
length(X1, L1), length(X2, L2), length(X3, L3), length(X4, L4), L2 is L1 - 1, L3 is L1 - 2, L4 is L1 - 3.


%%%% Artificial intelligence: choose in a Board the index to play for Player (_)
%%%% This AI plays randomly and does not care who is playing: it chooses a free position
%%%% in the Board (an element which is an free variable).
ia(Board, Index) :-
	repeat, Index is random(7),
	nth0(Index, Board, Col),
	not(isColFull(Col)), !.

% Check if a move is possible.
possibleMove(Board, Move) :-
	nth0(Move, Board, Col),
	not(isColFull(Col)).

% Chose a move for x as human.
chooseMove('x', _, Move, human) :-
	!, read(Move),
	writeln(Move), writeln('').

% Chose a move for o as human.
chooseMove('o', _, Move, human) :-
	!, read(Move),
	writeln(Move), writeln('').

% Chose a move for x as an AI.
chooseMove('x', Board, Move, Heuristic) :-
	!, alpha_beta(4, Board, 'x', 1, -1000, 1000, Move, _, Heuristic),
	writeln(Move), writeln('').
	
% Chose a move for o as an AI.
chooseMove('o', Board, Move, Heuristic) :-
	!, alpha_beta(4, Board, 'o', -1, -1000, 1000, Move, _, Heuristic),
	writeln(Move), writeln('').

%%%% Recursive predicate to play the game.
% The game is over, we use a cut to stop the proof search, and display the winner / board.
play(Player, 1, _, _, Winner):-  !, board(Board), displayBoard(Board),
    writeln(''),
    write('Game is Over. Winner: '),
    changePlayer(Player, PreviousPlayer),
    Winner = PreviousPlayer,
    writeln(PreviousPlayer).

% The game is not over, we play the next turn
play(Player, 0, Heuristic1, Heuristic2, Winner):-
	!,
	board(Board),
	findall(M, possibleMove(Board, M), PossibleMoves),
	(PossibleMoves==[]->
		true,
		Winner = '_'
	;
		write('New turn for: '), writeln(Player),
		displayBoard(Board), % print it
		chooseHeuristic(Heuristic1, Heuristic2, Player, HeuristicChosen),
		chooseMove(Player, Board, Move, HeuristicChosen), % ask the AI for a move, that is, an index for the Player
		playMove(Board,Move,NewBoard,Player, IsWinnerMove), % Play the move and get the result in a new Board
		applyIt(Board, NewBoard),
		changePlayer(Player,NextPlayer), % Change the player before next turn
		garbage_collect,
		play(NextPlayer, IsWinnerMove, Heuristic1, Heuristic2, Winner) % next turn!
	).

chooseHeuristic(Heuristic1, _, 'x', Heuristic1).
chooseHeuristic(_, Heuristic2, 'o', Heuristic2).

%Counts the number of tokens int the specified direction
countTokensDirection(Board, Direction, Token, Row, Column, NbTokens) :-
	areInBoard(Row, Column),
	nth0(Column, Board, ColumnElement),
	nth0(Row, ColumnElement, Element),

	(
	%Check if we already know the token, if we dont we assign it the value of the element row, column
	var(Token) ->
		(var(Element)->
			NbTokens is 0,
			fail
		; %else
			Token = Element
		)
	; %else
		true
	)
	,
	%Check Token correspond to Element, if no then we have finished
	%if yes then we continue searching in the direction specified
	(Element==Token ->
		nextColumnRow(Row, Column, Direction, NewRow, NewColumn),
		countTokensDirection(Board, Direction, Token, NewRow, NewColumn, NextNbTokens),
		NbTokens is NextNbTokens+1
	;
		NbTokens is 0
	).

%When the last function fails it means that Row column is outside the board, so it sends 0
countTokensDirection(_, _, _, _, _, 0).

%Checks if the row and column are inside the boundaries of the board
areInBoard(Row, Column) :-
	between(0, 6, Column),
	between(0,5, Row).

%Calculates the NewRow and NewColumn from Row and Column in the specified Direction
%Direction is defined by [ColumnAugmentation, RowAugmentation]
nextColumnRow(Row, Column, Direction, NewRow, NewColumn) :-
	nth0(0,Direction, AddColumn),
	nth0(1,Direction, AddRow),
	NewRow is Row+AddRow,
	NewColumn is Column+AddColumn.

%%%% Play a Move, the new Board will be the same, but one value will be instanciated with the Move
playMove(Board, Move, NewBoard, Player, IsWinnerMove) :-
	length(NewBoard, 7),
	maplist(length_list(6),NewBoard),
	copyBoard(Board, NewBoard),
	nth0(Move, NewBoard, Column),
	insertToken(Player, Column),
	getLastRowPlayed(Column, Row),
	isWinner(Move, Row, Player, NewBoard, IsWinnerMove), !.

isWinner(Column, Row, Player, Board, IsWinnerMove):-
	nextColumnRow(Row, Column, [1,1], NextRow, NextColumn),
	nextColumnRow(Row, Column, [-1, -1], PreviousRow, PreviousColumn),

	countTokensDirection(Board, [1,0], Player, Row, NextColumn, NbTokensRight),
	countTokensDirection(Board, [-1,0], Player, Row, PreviousColumn, NbTokensLeft),

	%vertical
	countTokensDirection(Board, [0,1], Player, NextRow, Column, NbTokensUp),
	countTokensDirection(Board, [0,-1], Player, PreviousRow, Column, NbTokensDown),

	%diagonal up
	countTokensDirection(Board, [1,1], Player, NextRow, NextColumn, NbTokensRightUp),
	countTokensDirection(Board, [-1,1], Player, NextRow, PreviousColumn, NbTokensLeftUp),

	%diagonal down
	countTokensDirection(Board, [1,-1], Player, PreviousRow, NextColumn, NbTokensRightDown),
	countTokensDirection(Board, [-1,-1], Player, PreviousRow, PreviousColumn, NbTokensLeftDown),

	((NbTokensRight + NbTokensLeft > 2;
	NbTokensUp + NbTokensDown > 2;
	NbTokensRightUp + NbTokensLeftDown > 2;
	NbTokensRightDown+ NbTokensLeftUp > 2)->
		IsWinnerMove is 1
	;
		IsWinnerMove is 0
	).

	
getLastRowPlayed([], Row):-
	Row is -1,!.

getLastRowPlayed([H | _], Row):-
	var(H),!,
	Row is -1.

getLastRowPlayed([_ | T], Row) :-
	getLastRowPlayed(T, RowTail),
	Row is RowTail+1.

	
copyBoard([],[]).

copyBoard([C | Board], [NewC | NewBoard]):-
	copyColumn(C, NewC),
	copyBoard(Board, NewBoard).

copyColumn([H|T],[NewH|NewT]):-
	nonvar(H),
	NewH = H,
	copyColumn(T,NewT).

copyColumn([H|_],[_|_]):-
	var(H).

copyColumn([],[]).


%insert token in column
insertToken(Player, [H|_]) :-
	var(H),
	!,
	H = Player.

insertToken(Player, [H|T]):-
	nonvar(H),
	!,
	insertToken(Player, T).

insertToken(_, []).

%%%% Predicate to get the next player
changePlayer('x','o').
changePlayer('o','x').


%%%% Print the value of the colomns at index N:
%%%% Print the line at index
% rechanger pour afficher des - au lieu de la valeurs des variables
% libres
printLine(IndexFile, Board) :-
	printLine(IndexFile, 0, Board).

printLine(IndexFile, IndexColonne,  Board) :-
    nth0(IndexColonne,Board,Col0), nth0(IndexFile,Col0,Val),
    nonvar(Val),!,
    write(' '), write(Val), write(' '),
    NewIndexColonne is IndexColonne+1,
    printLine(IndexFile, NewIndexColonne, Board).

printLine(IndexFile, IndexColonne,  Board) :-
    nth0(IndexColonne,Board,Col0), nth0(IndexFile,Col0,_),
    write(' '), write('-'), write(' '),
    NewIndexColonne is IndexColonne+1,
    printLine(IndexFile, NewIndexColonne, Board).

printLine(_, 7, _).

%%%% Display the board
displayBoard(Board):-
	!,
    writeln('  0  1  2  3  4  5  6'),
    writeln('*---------------------*'),
    write('|'), printLine(5, Board), write('|'), writeln(''),
    write('|'), printLine(4, Board), write('|'), writeln(''),
    write('|'), printLine(3, Board), write('|'), writeln(''),
    write('|'), printLine(2, Board), write('|'), writeln(''),
    write('|'), printLine(1, Board), write('|'), writeln(''),
    write('|'), printLine(0, Board), write('|'), writeln(''),
    writeln('*---------------------*'),
    writeln('  0  1  2  3  4  5  6').

	
length_list(L, Ls) :- length(Ls, L).

init_board:-
	board(OldBoard),
	retract(board(OldBoard)),!,
	length(Board,7), maplist(length_list(6),Board),
	assert(board(Board)).

init_board:-
	length(Board,7), maplist(length_list(6),Board),
	assert(board(Board)).

%%%%% Start the game!
init :- init_board, play('x', 0, human, heuristicWinningMoves, _).
