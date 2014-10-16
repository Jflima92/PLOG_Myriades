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
par('J',10).                            %%Para comparar 113 (jogador1 ou peça1 com valor 13) parsing
par('W', white).
par('B', black).
par('G', gray).


splitValue(Value, User, Pval):-
        Pval is mod(Value, 100),
        User is Value//100.

checkValue(Value, User, Pval):-
        splitValue(Value, User, Pval).

printLine([]).

printLine([0|Resto]):-
        print(' '),
        print('|'),
        print(' '),
        printLine(Resto).

printLine([P1|Resto]):-
        checkValue(P1, User, Value),
        print(' '),
        print('|'),
        print(User),
        print(Value),
        printLine(Resto).

        

printDownSeq(I):-
        par(X,I), 
        print(X).

printBoard([],11).
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
searchBoardAux([Elem|Rest], [Elem|NewRest], X, NewElem):-
        X > 1,
        NewX is X-1,
        searchBoardAux(Rest, NewRest, NewX, NewElem).
                
searchBoard([Line|Rest], [LineOut|Rest], X, 1, Val):-                %% Line Matched Condition
        searchBoardAux(Line, LineOut, X, Val).                    
searchBoard([Line|Rest], [Line|NewRest], X, Y, Val):-          %% Searches each line of the Board for until line X
        Y > 1,
        NewY is Y-1,
        searchBoard(Rest, NewRest, X, NewY, Val).
        

insertPiece(BoardIn, BoardOut, X, Y, Val):-
        searchBoard(BoardIn, BoardOut, X, Y, Val).  

movePiece(BoardIn, BoardOut, Xi, Yi, Xf, Yf, Val):-
        searchBoard(BoardIn, Board2, Xi, Yi, 0),
        searchBoard(Board2, BoardOut, Xf, Yf, Val).

doInsertion(BoardIn, BoardOut):-        
        insertPiece(BoardIn, Board1, 4, 5, 112),
        insertPiece(Board1, Board2, 2, 5, 223),
        insertPiece(Board2, Board3, 3, 5, 300),
        insertPiece(Board3,Board4, 10, 10, 124),
        insertPiece(Board4, BoardOut, 3, 7, 142),
        printBoard(BoardOut, 1).
        
        

doStuff:-
        emptyBoard(Cenas),
        doInsertion(Cenas, Board2),
        movePiece(Board2, BoardOut, 3, 7, 3, 6, 142),
        printBoard(BoardOut, 1).

