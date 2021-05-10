head([X|_], X).
tail([_|Xs], Xs).

firstColumn(Matrix, Head, Tail) :-
    maplist(head, Matrix, Head),
    maplist(tail, Matrix, Tail).

nthColumn(Matrix, N, NthColumn) :-
    length(Matrix, Len),
    length(ListOfNs, Len),
    maplist(=(N), ListOfNs),
    maplist(nth0, ListOfNs, Matrix, NthColumn).

row(Size, RowIndex, PrevRows, Result) :- row(Size, RowIndex, 0, PrevRows, [], Result).
row(Size, _, Size, _, Result, Result).
row(Size, RowIndex, ColIndex, PrevRows, Accumulator, Result) :-
    between(1, Size, X),
    \+ member(X, Accumulator),
    nthColumn(PrevRows, ColIndex, Col),
    \+ member(X, Col),
    NewColIndex is ColIndex+1,
    append(Accumulator, [X], Acc),
    row(Size, RowIndex, NewColIndex, PrevRows, Acc, Result).



ltn([X,Y, Z]) :-
    row(3, 0, [], X),
    row(3, 1, [X], Y),
    row(3, 2, [X,Y], Z).

latinSquare(Xss, Size) :- 
    latinSquare(Size, 0, [], Xss).
latinSquare(Size, Size, Result, Result).
latinSquare(Size, RowIndex, Accumulator, Result) :-
    row(Size, RowIndex, Accumulator, Xs),
    NewRowIndex is RowIndex+1,
    latinSquare(Size, NewRowIndex, [Xs|Accumulator], Result).


firstNRows(X, 0, [], X) :- !.
firstNRows([X|Xs], N, [X|Rows], Rest) :-
    N1 is N-1,
    firstNRows(Xs, N1, Rows, Rest).    

% implementation of matrix transpose from lecture 7
% -------------------------------------------------
transpose([[]|_],[]):- !.
transpose(Xss,[Xs|Zss]):-
    maplist(head,Xss,Xs),
    maplist(tail,Xss,Yss),
    transpose(Yss,Zss).
% -------------------------------------------------

firstNColumns(Matrix, N, Cols, Rest) :-
    transpose(Matrix, Transposed),
    firstNRows(Transposed, N, Cols, Rest).


isPermutation(Xs, N) :-
    permutation(Xs, Ys),
    numlist(1, N, Ys).
    
    


blocksInRow([], _).
blocksInRow(Matrix, N) :-
    firstNColumns(Matrix, N, Head, Tail),
    flatten(Head, FlatHead),
    isPermutation(FlatHead, N),
    blocksInRow(Tail, N), 
    !.

blocks([], _).
blocks(Matrix, N) :-
    firstNRows(Matrix, N, Head, Tail),
    blocksInRow(Head, N),
    blocks(Tail, N),
    !.

s(S,S,N) :-
    N2 is N^2,
    latinSquare(S,N2),
    blocks(S,N).