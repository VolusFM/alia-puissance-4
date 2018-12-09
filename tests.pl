:-include('connectFour.pl').
:-include('AI.pl').
:-include('heuristicEvaluation.pl').

%%%% isColFull ?
isColFullReturnsTrue() :-
    isColFull(['x', 'o', 'x']),
    isColFull(['x', 'x', 'x']),
    isColFull(['o', 'o', 'o']).

isColFullReturnsFalseIfNotFull() :- isColFull(['x', 'o', _]).
isColFullReturnsFalseIfNotFull() :- isColFull([_, _, _]).
isColFullReturnsFalseIfNotFull() :- isColFull([_, 'o' , _]).

%%%% isBoardFull ?
isBoardFullReturnsTrueIfFull() :-
    isBoardFull([['o','x'], ['x','o'], ['o','x'], ['x','x'], ['o','o'], ['o','x'], ['x','o']]).

isBoardFullReturnsFalseIfNotFull() :- isBoardFull([[1, _], [1, 1], [1, 1], [1, 1], [_, 1], [1, 1], [1, _]]).
isBoardFullReturnsFalseIfNotFull() :- isBoardFull([[1, _], [1, 1], [1, 1], [1, 1], [_, 1], [1, 1], [1, _]]).
isBoardFullReturnsFalseIfNotFull() :- isBoardFull([[_, _], [_, _], [_, _], [_, _], [_, _], [_, _], [_, _]]).

%%%% fourVertical ?
fourVerticalReturnsTrue() :-
    fourVertical([['o','o','o','o'], ['o','o',_,_]], 'o'),
    fourVertical([['o','o',_,_], ['o','o','o','o']], 'o'),
    fourVertical([['x','x','x','x'], ['x','x',_,_]], 'x'),
    fourVertical([[_,_,'x','x'], ['x','x','x','x']], 'x').

fourVerticalReturnsFalse() :- fourVertical([[_,_,_], [_,_,_]], 'o').
fourVerticalReturnsFalse() :- fourVertical([['o','o','o', _], [_,_,_]], 'o').
fourVerticalReturnsFalse() :- fourVertical([[_,'o','o', _], [_,'o','o','o']], 'o').

%%%% fourHorizontal ?
fourHorizontalReturnsTrue():-
    fourHorizontal([['o', _], ['o',_], ['o',_], ['o',_]], 'o'),
    fourHorizontal([[_,'o',_], [_,'o',_], [_,'o',_], [_,'o',_]], 'o'),
    fourHorizontal([['x', _], ['x',_], ['x',_], ['x',_]], 'x'),
    fourHorizontal([[_,'x',_], [_,'x',_], [_,'x',_], [_,'x',_]], 'x').

fourHorizontalReturnsFalse():- fourHorizontal([[_, _], ['o',_], ['o',_], ['o',_]], 'o').
fourHorizontalReturnsFalse():- fourHorizontal([[_,_,_], [_,_,_], [_,_,_], [_,_,_]], 'o').
fourHorizontalReturnsFalse():- fourHorizontal([['x', _], ['x',_], [_,_], ['x',_]], 'x').
fourHorizontalReturnsFalse():- fourHorizontal([[_,'x',_], [_,'x',_], [_,'x',_], [_,_,_]], 'x').

%%%% fourDiagonalDown ?
fourDiagonalDownReturnsTrue() :-
    fourDiagonalDown([[_,_,_,'o'], [_,_,'o',_], [_,'o',_,_], ['o',_,_,_]], 'o'),
    fourDiagonalDown([[_,_,_,'x'], [_,_,'x',_], [_,'x',_,_], ['x',_,_,_]], 'x'),
    fourDiagonalDown([['x','x','x','o'], ['x','x','o',_], ['x','o',_,_], ['o',_,_,_]], 'o'),
    fourDiagonalDown([['o','o','o','x'], ['o','o','x',_], ['o','x',_,_], ['x',_,_,_]], 'x').

fourDiagonalDownReturnsFalse() :- fourDiagonalDown([[_,_,_,_], [_,_,_,_], [_,_,_,_], [_,_,_,_]], 'o').
fourDiagonalDownReturnsFalse() :- fourDiagonalDown([['x','x','o','o'], ['o','o','x','x'], ['o',_,'x',_], [_,'x',_,'o']], 'o').

%%%% fourDiagonalUp ?
fourDiagonalUpReturnsTrue() :-
    fourDiagonalUp([['o',_,_,_], [_,'o',_,_], [_,_,'o',_], [_,_,_,'o']], 'o'),
    fourDiagonalUp([['x',_,_,_], [_,'x',_,_], [_,_,'x',_], [_,_,_,'x']], 'x'),
    fourDiagonalUp([['o','x','x','x'], ['x','o','x',_], ['x','x','o',_], ['o',_,_,'o']], 'o'),
    fourDiagonalUp([['x','o','o','o'], ['o','x','x',_], ['o','x','x',_], ['x',_,_,'x']], 'x').

fourDiagonalUpReturnsFalse() :- fourDiagonalUp([[_,_,_,_], [_,_,_,_], [_,_,_,_], [_,_,_,_]], 'o').
fourDiagonalUpReturnsFalse() :- fourDiagonalUp([['x','x','o','o'], ['o','o','x','x'], ['o',_,'x',_], [_,'x',_,'o']], 'o').
