% the game will be reprensented by 7 lists of 6 elements
% board(column1, column2, colmun3, column4, column5, column6, column7)
% column1(_,_,_,_,_,_) at the beginning, idem for the other columns
% eg column1(x,_,_,_,_,_) after the first round
% eg column1(x,o,_,_,_,_) after the second round
% until the board is completely instanciated or someone wins

:- dynamic board/1.

%%%% Test is the game is finished %%%
gameover(Winner) :- board(Board), winner(Board, Winner), !. % There exists a winning configuration: We cut!
gameover('Draw') :- board(Board), isBoardFull(Board). % the Board is fully instanciated (no free variable): Draw.

%%%% Recursive predicate that checks if all the elements of the List (a board)
%%%% are instanciated: true e.g. for [x,x,o,o,x,o] false for
%%%% [x,x,o,o,_G125,x]
isColFull([]).
isColFull([H|T]):- nonvar(H), isColFull(T).

isBoardFull(B):-
    nth0(0,B,Col0), isColFull(Col0),
    nth0(1,B,Col1), isColFull(Col1),
    nth0(2,B,Col2), isColFull(Col2),
    nth0(3,B,Col3), isColFull(Col3),
    nth0(4,B,Col4), isColFull(Col4),
    nth0(5,B,Col5), isColFull(Col5),
    nth0(6,B,Col6), isColFull(Col6).

%%%%winning condition
winner(Board, Winner) :- fourVertical(Board, Winner).
winner(Board, Winner) :- fourHorizontal(Board, Winner).
winner(Board, Winner) :- fourDiagonalUp(Board, Winner).
winner(Board, Winner) :- fourDiagonalDown(Board, Winner).

%%%% Test if there is column with four adjacent tokens of the same color.
fourVertical(Board, P):- append(_, [C|_], Board),
    append(_, [P,P,P,P|_], C).

%%%% Test if there are four columns with a line of four adjacent tokens of the same color.
fourHorizontal(Board, P) :- append(_, [C1, C2, C3, C4|_], Board),
    append(_, [P|X1], C1),
    append(_, [P|X2], C2),
    append(_, [P|X3], C3),
    append(_, [P|X4], C4),
    length(X1, L), length(X2, L), length(X3, L), length(X4, L).

%%%% Test if there are four columns with a diagonal of four adjacent tokens of the same color (going down).
fourDiagonalDown(Board, P):- append(_, [C1, C2, C3, C4|_], Board),
    append(_, [P|X1], C1),
    append(_, [P|X2], C2),
    append(_, [P|X3], C3),
    append(_, [P|X4], C4),
    length(X1, L1), length(X2, L2), length(X3, L3), length(X4, L4), L2 is L1+1, L3 is L1+2, L4 is L1+3.

%%%%% Test if there are four columns with a diagonal of four adjacent tokens of the same color (going up).
fourDiagonalUp(Board, P):- append(_,[C1, C2, C3, C4|_], Board),
    append(_, [P|X1], C1),
    append(_, [P|X2], C2),
    append(_, [P|X3], C3),
    append(_, [P|X4], C4),
    length(X1, L1), length(X2, L2), length(X3, L3), length(X4, L4), L2 is L1-1, L3 is L1-2, L4 is L1-3.


%%%% Play a Move, the new Board will be the same, but one value will be instanciated with the Move
playMove(Board,Move,NewBoard,Player) :- Board=NewBoard,  nth0(Move,NewBoard,Player).

%%%% Remove old board/save new on in the knowledge base
applyIt(Board,NewBoard) :- retract(board(Board)), assert(board(NewBoard)).

%%%% Predicate to get the next player
changePlayer('x','o').
changePlayer('o','x').

%%%% Print the value of the colomns at index N:
% if its a variable, print ? and x or o otherwise.
printVal(N) :- board(B), nth0(N,B,Val), var(Val), write('?'), !.
printVal(N) :- board(B), nth0(N,B,Val), write(Val).

%%%% Print the line at index
printLine(Index) :-  board(B),
    write(' '), nth0(0,B,Col0), nth0(Index,Col0,Val),printVal(Val), write(' '),
    write(' '), nth0(1,B,Col1), nth0(Index,Col1,Val),printVal(Val), write(' '),
    write(' '), nth0(2,B,Col2), nth0(Index,Col2,Val),printVal(Val), write(' '),
    write(' '), nth0(3,B,Col3), nth0(Index,Col3,Val),printVal(Val), write(' '),
    write(' '), nth0(4,B,Col4), nth0(Index,Col4,Val),printVal(Val), write(' '),
    write(' '), nth0(5,B,Col5), nth0(Index,Col5,Val),printVal(Val), write(' '),
    write(' '), nth0(6,B,Col6), nth0(Index,Col6,Val),printVal(Val), write(' ').

%%%% Display the board
displayBoard:-
    writeln('*-------------------*'),
    printLine(0), writeln(''),
    printLine(1), writeln(''),
    printLine(2), writeln(''),
    printLine(3), writeln(''),
    printLine(4), writeln(''),
    printLine(5), writeln(''),
    writeln('*-------------------*').

%%%%% Start the game!
init :- length(Board,7), assert(board(Board)).%play('x').
