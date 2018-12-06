:-include('connectFour.pl').
:-include('alphaBetaPruning.pl').
:-include('minimax.pl').
:-include('heuristic2.pl').
:-include('heuristicEvaluation.pl').


%Plays a single game using the heuristics specified
%Result becomes 1 if heuristic1 won and 0 if heuristic2 won
playSingleGame(Heuristic1, Heuristic2, Result):-
	length(Board,7), maplist(length_list(6),Board),
	play('x', Board, 0, Heuristic1, Heuristic2, Winner),
	(Winner == 'x'->
		Result is 1
	;Winner == 'o'->
		Result is -1
	;
		Result is 0
	).

%plays two games, the first one with heuristic1 as x and heuristic2 as o
%the second one with heuristic2 as x and heuristic1 as o
%Result nb of wins of Heuristic1 - nb of wins of Heuristic2
playTwoGames(Heuristic1, Heuristic2, Result) :-
	playSingleGame(Heuristic1, Heuristic2, PartialResult),
	playSingleGame(Heuristic2, Heuristic1, PartialResult2),
	Result is PartialResult - PartialResult2.

play2NGames(_, _, 0, 0).

play2NGames(Heuristic1, Heuristic2, N, Result):-
	NewN is N-1,
	play2NGames(Heuristic1, Heuristic2, NewN, PartialResult),
	playTwoGames(Heuristic1, Heuristic2, Result2Games),
	Result is PartialResult+Result2Games.


