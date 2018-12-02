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
% end case, with particular case of 4 in a row and a play to the left of an allignement possible
evaluateList([], _, Sum, 4, PlayToTheLeft, Final) :- Sum1 is Sum + 1000, 
    evaluateList([], _, Sum1, 0, PlayToTheLeft, Final).
evaluateList([], _, Sum, _, 0, Final) :- Final is Sum.
evaluateList([], _, Sum, CountPlayer, 1, Final) :- CountPlayer == 0, Sum1 is Sum, Final is Sum1;
    CountPlayer == 1, Sum1 is Sum + 1, Final is Sum1;
    CountPlayer == 2, Sum1 is Sum + 4, Final is Sum1;
    CountPlayer == 3, Sum1 is Sum + 9, Final is Sum1.
	
% case where the current token is the player's token
evaluateList([C|Q], Player, Sum, CountPlayer, PlayToTheLeft, Final) :-
    nonvar(C), C == Player,
    Count is CountPlayer + 1, !,
    evaluateList(Q, Player, Sum, Count, PlayToTheLeft, Final).
	
% case where the current token is the other player token. If Player can play to the left of the current 
% alignement, we count the alignement.
evaluateList([C|Q], Player, Sum, CountPlayer, 0, Final) :-
    nonvar(C), C \== Player, CountPlayer \== 4, !,
    evaluateList(Q, Player, Sum, 0, 0, Final).
evaluateList([C|Q], Player, Sum, CountPlayer, 1, Final) :-
    nonvar(C), C \== Player, CountPlayer == 0, !, evaluateList(Q, Player, Sum, 0, 0, Final);
    nonvar(C), C \== Player, CountPlayer == 1, Sum1 is Sum + 1, !, evaluateList(Q, Player, Sum1, 0, 0, Final);
    nonvar(C), C \== Player, CountPlayer == 2, Sum1 is Sum + 4, !, evaluateList(Q, Player, Sum1, 0, 0, Final);
    nonvar(C), C \== Player, CountPlayer == 3, Sum1 is Sum + 9, !, evaluateList(Q, Player, Sum1, 0, 0, Final);
    nonvar(C), C \== Player, CountPlayer >= 4, Sum1 is Sum + 1000, !, evaluateList(Q, Player, Sum1, 0, 0, Final).

% case where there is no token.
evaluateList([C|Q], Player, Sum, CountPlayer, _, Final) :-
    var(C),
    CountPlayer == 0, evaluateList(Q, Player, Sum, 0, 1, Final);
    CountPlayer == 1, Sum1 is Sum + 1, evaluateList(Q, Player, Sum1, 0, 1, Final);
    CountPlayer == 2, Sum1 is Sum + 4, evaluateList(Q, Player, Sum1, 0, 1, Final);
    CountPlayer == 3, Sum1 is Sum + 9, evaluateList(Q, Player, Sum1, 0, 1, Final);
    CountPlayer >= 4, Sum1 is Sum + 1000, evaluateList(Q, Player, Sum1, 0, 1, Final).
    % Cases above 4 are irrelevant as the game would already be over at that point.

%%%%%% Create a list corresponding to the reverserd line of the Board at the height Index. 
% The Board is the first parameter. Should be called with List at []. Return Final. 
createListWithLine([], List, _, Final) :- copyterm(List, Final).
createListWithLine([C|Q], List, Index, Final) :- append(, [Head|Stack], C),
    Heigth is 6-Index, length(Stack,Heigth), !,
    createListWithLine(Q, [Head|List], Index, Final).
	
