%%%% first try for an heuristic
value(Board, Value) :- append(C1, [C|_], Board),
    append(L1, [P|_], C),
    length(C1, Latitude),
    length(L1, Longitude).
%%%% TODO tous les cas
valueHorizontal(Board, Value, Latitude, Longitude) :- 