sudoku(Xss, Size) :- 
    sudoku(Size, 0, [], Xss).
sudoku(Size, Size, Result, Result).
sudoku(Size, RowIndex, Accumulator, Result) :-
    row(Size, RowIndex, Accumulator, Xs),
    NewRowIndex is RowIndex+1,
    sudoku(Size, NewRowIndex, [Xs|Accumulator], Result).


row(Size, RowIndex, PrevRows, Result) :- row(Size, RowIndex, 0, PrevRows, [], Result).
row(Size, _, Size, _, Result, Result).
row(Size, RowIndex, ColIndex, PrevRows, Accumulator, Result) :-
    between(1, Size, X),
    block(PrevRows, ColIndex, RowIndex, 3, Block),
    \+ member(X, Block),
    \+ member(X, Accumulator),
    nthColumn(PrevRows, ColIndex, Col),
    \+ member(X, Col),
    NewColIndex is ColIndex+1,
    append(Accumulator, [X], Acc),
    row(Size, RowIndex, NewColIndex, PrevRows, Acc, Result).


nthColumn(Matrix, N, NthColumn) :-
    length(Matrix, Len),
    length(ListOfNs, Len),
    maplist(=(N), ListOfNs),
    maplist(nth0, ListOfNs, Matrix, NthColumn).


block(PrevRows, ColumnIndex, RowIndex, BlockSideLength, Result) :-
    N is RowIndex mod BlockSideLength,
    lastNRows(PrevRows, N, LastNRows),
    A is ColumnIndex - (ColumnIndex mod BlockSideLength),
    B is A + BlockSideLength,
    columnRange(LastNRows, A, B, Result).
    
firstNRows(_, 0, []) :- !.
firstNRows([Xs|Xss], N, [Xs|Rows]) :-
    N1 is N-1,
    firstNRows(Xss, N1, Rows).  

lastNRows(Xss, N, Result) :- 
    reverse(Xss, RXss),
    firstNRows(RXss, N, Result).

columnRange(_, To, To, []) :- !.
columnRange(Xss, From, To, Result) :-
    nthColumn(Xss, From, Col),
    F1 is From + 1,
    columnRange(Xss, F1, To, RecursiveResult),
    append(Col, RecursiveResult, Result).
