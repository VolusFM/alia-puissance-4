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

%%%%%% Create a list corresponding to the line of the board at the height Index. 
% The board is the first parameter. The second parameter is the return value.
% Index should never be superior to 6. 
createListFromLine([], [], _).
createListFromLine([C|B], [Head|ReturnQ], Index) :- append(_,[Head|Stack],C),
    length(C, BoardHeight), BoardHeight >= Index,
    Height is BoardHeight - Index, length(Stack, Height), !,
    createListFromLine(B, ReturnQ, Index).

%%%%%% Create a list corresponding to the diagonal starting at the column ColumnIndex, line LineIndex, 
% going up, to the right. 
% The board is the first parameter. The second parameter is the return value.
% LineIndex should never be superior to 6. ColumnIndex should never be superior to 7.
createListFromDiagonalUp([], [], _, _).
createListFromDiagonalUp([C|B], ReturnQ, 1, LineIndex) :- length(C, MaxLineIndex),LineIndex>MaxLineIndex
    , !, createListFromDiagonalUp(B, ReturnQ, 1, LineIndex).
createListFromDiagonalUp([C|B], [Head|ReturnQ], 1, LineIndex) :- append(_,[Head|Stack], C),
    length(C, BoardHeight), Height is BoardHeight - LineIndex, length(Stack, Height), !,
    NewLineIndex is LineIndex + 1, createListFromDiagonalUp(B, ReturnQ, 1, NewLineIndex).
createListFromDiagonalUp([_|B], [Head|ReturnQ], ColumnIndex, LineIndex) :- NewColumnIndex is ColumnIndex - 1,
    createListFromDiagonalUp(B, [Head|ReturnQ], NewColumnIndex, LineIndex).

%%%%%% Create a list corresponding to the diagonal starting at the column ColumnIndex, line LineIndex, 
% going down, to the right.
% The board is the first parameter. The second parameter is the return value.
% LineIndex should never be superior to 6. ColumnIndex should never be superior to 7.
createListFromDiagonalDown([], [], _, _).
createListFromDiagonalDown([_|B], ReturnQ, 1, LineIndex) :- 1 > LineIndex, !, 
	createListFromDiagonalDown(B, ReturnQ, 1, LineIndex).
createListFromDiagonalDown([C|B], [Head|ReturnQ], 1, LineIndex) :- append(_,[Head|Stack], C),
    length(C, BoardHeight), Height is BoardHeight - LineIndex, length(Stack, Height), !,
    NewLineIndex is LineIndex - 1, createListFromDiagonalDown(B, ReturnQ, 1, NewLineIndex).
createListFromDiagonalDown([_|B], [Head|ReturnQ], ColumnIndex, LineIndex) :- NewColumnIndex is ColumnIndex - 1,
    createListFromDiagonalDown(B, [Head|ReturnQ], NewColumnIndex, LineIndex).
	
