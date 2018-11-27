% the game will be reprensented by 7 lists of 6 elements
% board(colonne1, colonne2, colonne3, colonne4, colonne5, colonne6,
% colonne7)
% colonne1(_,_,_,_,_,_) at the beginning
% colonne1(x,_,_,_,_,_) after the first round
% colonne1(x,o,_,_,_,_) after the second round
% until the board is completely instanciated or someone wins


:- dynamic board/1.

%%%% Test if the game is finished
gameover(Winner) :- board(Board), winner(Board, Winner), !. % There exists a winning configuration: We cut!
gameover('Draw') :- board(Board), isBoardFull(Board). % the Board is fully instanciated (no free variable): Draw.

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

    
init :- assert(board([[0,0,0,0,0,0],
                       [0,0,0,0,0,0],
                       [0,0,0,0,0,0],
                       [0,0,0,0,0,0],
                       [0,0,0,0,0,0],
                       [0,0,0,0,0,0],
                       [0,0,0,0,0,0]])).