% Play a single game using the specified heuristics
% Result becomes 1 if heuristic1 won and 0 if heuristic2 won
playSingleGame(Heuristic1, Heuristic2, Result) :-
	init_board,
	play('x', 0, Heuristic1, Heuristic2, Winner),
	(Winner == 'x'->
		Result is 1
	;Winner == 'o'->
		Result is -1
	;
		Result is 0
	).

% Play two games, the first one with heuristic1 as x and heuristic2 as o
% the second one with heuristic2 as x and heuristic1 as o
% Result nb of wins of Heuristic1 - nb of wins of Heuristic2
playTwoGames(Heuristic1, Heuristic2, Result) :-
	playSingleGame(Heuristic1, Heuristic2, PartialResult),
	garbage_collect,
	playSingleGame(Heuristic2, Heuristic1, PartialResult2),
	garbage_collect,
	Result is PartialResult - PartialResult2.

% Play two games N times. 
play2NGames(_, _, 0, 0).

play2NGames(Heuristic1, Heuristic2, N, Result) :-
	NewN is N - 1,
	play2NGames(Heuristic1, Heuristic2, NewN, PartialResult),
	playTwoGames(Heuristic1, Heuristic2, Result2Games),
	Result is PartialResult + Result2Games.


