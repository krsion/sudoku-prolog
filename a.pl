head([X|_], X).
tail([_|Xs], Xs).
firstColumn(Matrix, Head, Tail) :-
    maplist(head, Matrix, Head),
    maplist(tail, Matrix, Tail).

row(_, 0, _,X,X).
row(N, Remaining, PrevRows, Accumulator, Result) :-
    between(1,N,X),
    \+ member(X, Accumulator),
    firstColumn(PrevRows, Col, Rows),
    \+ member(X, Col),
    R is Remaining-1,
    append(Accumulator, [X], Acc),
    row(N, R, Rows, Acc, Result).

latinSquare(Xss, N) :- 
    latinSquare([], N, N, Xss).
latinSquare(Xss, 0, _, Xss).
latinSquare(Xss, N, M, Yss) :-
    row(M, M, Xss, [], Xs),
    N1 is N-1,
    latinSquare([Xs|Xss], N1, M, Yss).


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