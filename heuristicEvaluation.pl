%%%%%% Evaluate a list (representing a column, a line or a diagonal). 
% Return value is Final. The heuristic evaluates the list as follows :
% - Alignements of respectively four, three, two, one or zero tokens respectively count for
% 1000, 9, 4, 1, and 0.
% - The evaluation value for the list is the sum of the evaluations of all alignments
% found in the list. 
% Return value is always positive ; run the predicate once for each player to
% evaluate both.
% CountPlayer should always be initialized to 0.
% Sum should always be initialized to 0.
evaluateList([], _, Sum, CountPlayer, Final) :- ( CountPlayer == 4, Final is Sum + 1000);
    Final is Sum.
evaluateList([], _, Sum, 4, Final) :- Sum1 is Sum + 1000, evaluateList([], _, Sum1, 0, Final).
evaluateList([C|Q], Player, Sum, CountPlayer, Final) :-
    nonvar(C), C==Player,
    Count is CountPlayer + 1, !,
    evaluateList(Q,Player, Sum, Count, Final).
evaluateList([C|Q], Player, Sum, CountPlayer, Final) :- 
    nonvar(C), C\==Player, CountPlayer \== 4, !,
    evaluateList(Q, Player, Sum, 0, Final).
evaluateList([C|Q], Player, Sum, CountPlayer, Final) :-
    var(C),
    CountPlayer == 0, evaluateList(Q, Player, Sum, 0, Final);
    CountPlayer == 1, Sum1 is Sum + 1, evaluateList(Q, Player, Sum1, 0, Final);
    CountPlayer == 2, Sum1 is Sum + 4, evaluateList(Q, Player, Sum1, 0, Final);
    CountPlayer == 3, Sum1 is Sum + 9, evaluateList(Q, Player, Sum1, 0, Final);
    CountPlayer == 4, Sum1 is Sum + 1000, evaluateList(Q, Player, Sum1, 0, Final).
	% Cases above 4 are irrelevant as the game would already be over at that point.

% TODO : makeList function to get lists for diagonals and lines