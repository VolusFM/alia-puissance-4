% the game will be reprensented by 7 lists of 6 elements
% board(column1, column2, colmun3, column4, column5, column6, column7)
% column1(_,_,_,_,_,_) at the beginning, idem for the other columns
% eg column1(x,_,_,_,_,_) after the first round
% eg column1(x,o,_,_,_,_) after the second round
% until the board is completely instanciated or someone wins

%%%% Test is the game is finished %%%
gameover(Winner, Board) :- winner(Board, Winner), !. % There exists a winning configuration: We cut!
gameover('Draw', Board) :- isBoardFull(Board). % the Board is fully instanciated (no free variable): Draw.

%%%% Recursive predicate that checks if all the elements of the List (a board)
%%%% are instanciated: true e.g. for [x,x,o,o,x,o] false for
%%%% [x,x,o,o,_G125,x]
isColFull([]).
isColFull([H|T]):- nonvar(H), isColFull(T). %%%%%% a changer

isBoardFull(B):-
    nth0(0,B,Col0), isColFull(Col0),
    nth0(1,B,Col1), isColFull(Col1),
    nth0(2,B,Col2), isColFull(Col2),
    nth0(3,B,Col3), isColFull(Col3),
    nth0(4,B,Col4), isColFull(Col4),
    nth0(5,B,Col5), isColFull(Col5),
    nth0(6,B,Col6), isColFull(Col6).

%%%% Winning condition
winner(Board,Winner) :- fourVertical(Board, Winner).
winner(Board,Winner) :- fourHorizontal(Board, Winner).
winner(Board,Winner) :- fourDiagonalUp(Board, Winner).
winner(Board,Winner) :- fourDiagonalDown(Board, Winner).


%%%% Test if there is column with four adjacent tokens of the same color
%P='o'
%Board=[[_ _ _ _],[_ _ _]]
fourVertical(Board, P):-
    append(_, [C|_], Board),
    append(_, [A,B,D,E|_], C),
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
    length(X1, L1), length(X2, L2), length(X3, L3), length(X4, L4), L2 is L1+1, L3 is L1+2, L4 is L1+3.

%%%%% Test if there are four columns with a diagonal of four adjacent tokens of the same color (going up).
fourDiagonalUp(Board, P):- append(_,[C1, C2, C3, C4|_], Board),
    append(_, [A|X1], C1),
    append(_, [B|X2], C2),
    append(_, [D|X3], C3),
    append(_, [E|X4], C4),
    A==P, B==P, D==P, E==P,
length(X1, L1), length(X2, L2), length(X3, L3), length(X4, L4), L2 is L1-1, L3 is L1-2, L4 is L1-3.


%%%% Artificial intelligence: choose in a Board the index to play for Player (_)
%%%% This AI plays randomly and does not care who is playing: it chooses a free position
%%%% in the Board (an element which is an free variable).
ia(Board, Index) :-
	repeat, Index is random(2),
	nth0(Index, Board, Col),
	not(isColFull(Col)),!.

possibleMove(Board, Move) :-
	nth0(Move, Board, Col),
	not(isColFull(Col)).

chooseMove('x', Board, Move) :-
	read(Move).

chooseMove('x', Board, Move) :-
	minimax(2, Board, 'o', -1, Move, Value),
	write(Move).

chooseMove('x', Board, Move) :-
	ia(Board, Move).

chooseMove('o', Board, Move) :-
	minimax(3, Board, 'o', -1, Move, Value),
	write(Move).



%%%% Recursive predicate for playing the game.
% The game is over, we use a cut to stop the proof search, and display the winner/board.
play(Player, Board):- changePlayer(Player,NextPlayer),gameover(NextPlayer, Board), !, write('Game is Over. Winner: '),
	writeln(NextPlayer), displayBoard(Board).
% The game is not over, we play the next turn
play(Player, Board):-  write('New turn for: '), writeln(Player),
		displayBoard(Board), % print it
		chooseMove(Player, Board, Move), % ask the AI for a move, that is, an index for the Player
		playMove(Board,Move,NewBoard,Player), % Play the move and get the result in a new Board
		changePlayer(Player,NextPlayer), % Change the player before next turn
		play(NextPlayer, NewBoard). % next turn!

%No moves possible
play(Player, Board):-
	gameover('Draw', Board).

%%%% Play a Move, the new Board will be the same, but one value will be instanciated with the Move
playMove(Board, Move, NewBoard, Player) :-
	length(NewBoard, 7),
	maplist(length_list(6),NewBoard),
	copyBoard(Board, NewBoard),
	nth0(Move, NewBoard, Column),
	insertToken(Player, Column).

copyBoard([],[]).

copyBoard([C | Board], [NewC | NewBoard]):-
	copyColumn(C, NewC),
	copyBoard(Board, NewBoard).

copyColumn([H|T],[NewH|NewT]):-
	nonvar(H),
	NewH = H,
	copyColumn(T,NewT).

copyBoard([],[]).

copyColumn([H|T],[NewH|NewT]):-
	var(H).

copyColumn([],[]).



%insert token in column
insertToken(Player, [H|_]) :-
	var(H),
	H = Player.

insertToken(Player, [H|T]):-
	nonvar(H),
	insertToken(Player, T).


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
    nth0(IndexColonne,Board,Col0), nth0(IndexFile,Col0,Val),
    write(' '), write('_'), write(' '),
    NewIndexColonne is IndexColonne+1,
    printLine(IndexFile, NewIndexColonne, Board).



printLine(IndexFile, 7, Board).

%%%% Display the board
%TODO: recrire sans coder en dur le 0,1,2...
displayBoard(Board):-
    writeln('*-------------------*'),
    printLine(5, Board), writeln(''),
    printLine(4, Board), writeln(''),
    printLine(3, Board), writeln(''),
    printLine(2, Board), writeln(''),
    printLine(1, Board), writeln(''),
    printLine(0, Board), writeln(''),
    writeln('*-------------------*').


%%%%% Start the game!
init :- length(Board,7),maplist(length_list(6),Board), displayBoard(Board), play('x', Board).

length_list(L, Ls) :- length(Ls, L).


%%%% A FAIRE %%%%
% - rechanger les isColFull
% - changer ia
% - changer playMove
% - trouver moyen d'initialiser le plateau au d�but du jeu
