:- use_module(library(lists)).
:- use_module(library(random)).


emptyBoard([[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0]]).

par(' ', 0).
par('A',1).
par('B',2).
par('C',3).
par('D',4).
par('E',5).
par('F',6).
par('G',7).
par('H',8).
par('I',9).
par('J',10).                            %%Pa
par('W', white).
par('B', black).
par('G', gray).

printLine([]).

printLine([P1|Resto]):-
        par(X,P1),
        print(' '),
        print('|'),
        print(X),
        printLine(Resto).
        

printDownSeq(I):-
        par(X,I),  %%erro aqui par (X;w)
        print(X).

printBoard([],9).
printBoard([L1|Resto],I) :-     
        printDownSeq(I),
        print(' '),
        printLine(L1),
        nl,
        I2 is I+1,
        printBoard(Resto, I2).

printInitialBoard:-
        emptyBoard(Cenas),
        print('  1  2  3  4  5  6  7  8  9  10 '),
        nl,
        printBoard(Cenas,1).


searchBoardAux([_|Rest], [NewElem|Rest], 1, NewElem).        
searchBoardAux([Elem|Rest], [Elem|NewRest], Y, NewElem):-
        Y > 1,
        NewY is Y-1,
        searchBoardAux(Rest, NewRest, NewY, NewElem).
                
searchBoard([Line|Rest], [LineOut|Rest], 1, Y, Sym):-                %% Line Matched Condition
        searchBoardAux(Line, LineOut, Y, Sym).                    
searchBoard([Line|Rest], [Line|NewRest], X, Y, Sym):-          %% Searches each line of the Board for until line X
        X > 1,
        NewX is X-1,
        searchBoard(Rest, NewRest, NewX, Y, Sym).
        

insertPiece(BoardIn, BoardOut, X, Y, Sym):-
        searchBoard(BoardIn, BoardOut, X, Y, Sym).  

doInsertion:-
        emptyBoard(Cenas),
        insertPiece(Cenas, Board1, 4, 5, white),
        insertPiece(Board1, Board2, 2, 5, white),
        insertPiece(Board2, Board3, 3, 5, black),
        insertPiece(Board3, BoardOut, 3, 7, black),
        
        printBoard(BoardOut, 1).

