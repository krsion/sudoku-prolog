firstNRows(X, 0, [], X) :- !.
firstNRows([X|Xs], N, [X|Rows], Rest) :-
    N1 is N-1,
    firstNRows(Xs, N1, Rows, Rest).    

% implementation of matrix transpose from lecture 7
% -------------------------------------------------
head([X|_],X).
tail([_|Xs],Xs).
transpose([[]|_],[]):- !.
transpose(Xss,[Xs|Zss]):-
    maplist(head,Xss,Xs),
    maplist(tail,Xss,Yss),
    transpose(Yss,Zss).
% -------------------------------------------------

firstNColumns(Matrix, N, Cols, Rest) :-
    transpose(Matrix, Transposed),
    firstNRows(Transposed, N, Cols, Rest).


good(X, Xs, N) :-
    between(1, N, X),
    \+ member(X, Xs).


% X is number between 1 and N that in no given list.
cell(Xs, Ys, Zs, N, X) :- 
    between(1, N, X), 
    \+ member(X, Xs),
    \+ member(X, Ys),
    \+ member(X, Zs).

row(_,[], 0, Xs, Xs).
row(NumberRange, RemainingCells, PrevRows, RowSoFar, Result) :-
    between(1, NumberRange, X),
    \+ member(X, RowSoFar),
    firstNColumns(PrevRows, 1, Head, Tail),
    flatten(Head, FlatHead),
    \+ member(X, FlatHead),
    R is RemainingCells-1,
    row(NumberRange, R, Tail, [X|RowSoFar], Result).












isPermutation(Xs, N) :-
    N2 is N^2,
    numlist(1, N2, Ys),
    permutation(Xs, Ys).
    
latinSquareRow([], Ys, N) :- 
    isPermutation(Ys, N).
latinSquareRow([Xs|Xss], Ys, N) :- 
    isPermutation(Ys, N),
    maplist(\=, Xs, Ys),
    latinSquareRow(Xss, Ys, N).

latinSquare(Xss, N) :- 
    latinSquare([], N^2, N, Xss).
latinSquare(Xss, 0, _, Xss).
latinSquare(Xss, N, M, Yss) :-
    latinSquareRow(Xss, Xs, M),
    N1 is N-1,
    latinSquare([Xs|Xss], N1, M, Yss).


%latinSquare([Ws,Xs,Ys,Zs], N) :-
%    latinSquareRow([], Ws, N),
%    latinSquareRow([Ws], Xs, N),
%    latinSquareRow([Ws, Xs], Ys, N),
%    latinSquareRow([Ws, Xs, Ys], Zs, N).
    
sudoku(S, S, N) :-
    latinSquare(S, N),
    S = [[A,B,C,D],
         [E,F,G,H],
         [I,J,K,L],
         [M,N2,O,P]],
    isPermutation([A, B, E, F], N),
    isPermutation([C, D, G, H], N),
    isPermutation([I, J, M, N2], N),
    isPermutation([K, L, O, P], N).


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
    latinSquare(S,N),
    blocks(S,N).
