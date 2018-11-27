% the game will be reprensented by 7 lists of 6 elements
% board(colonne1, colonne2, colonne3, colonne4, colonne5, colonne6,
% colonne7)
% colonne1(_,_,_,_,_,_) at the beginning
% colonne1(x,_,_,_,_,_) after the first round
% colonne1(x,o,_,_,_,_) after the second round
% until the board is completely instanciated or someone wins


:- dynamic board/1

%%%% Test if the game is finished
gameover(Winner) :- board(Board), winner(Board, Winner), !. % There exists a winning configuration: We cut!
gameover('Draw') :- board(Board), isBoardFull(Board). % the Board is fully instanciated (no free variable): Draw.
