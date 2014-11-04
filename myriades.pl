:- use_module(library(lists)).
:- use_module(library(random)).
:-dynamic player/2.

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

initialPieces([[1,2,3,4,5,6,7,8,9],
              [10,11,12,13,14,15,16,17,18,19],
              [20,21,22,23,24,25,26,27,28,29],
              [30,31,32,33,34,35,36,37,38,39],
              [40,41,42,43,44,45,46,47,48,49]]).


player(1, [[1,2,3,4,5,6,7,8,9],
              [10,11,12,13,14,15,16,17,18,19],
              [20,21,22,23,24,25,26,27,28,29],
              [30,31,32,33,34,35,36,37,38,39],
              [40,41,42,43,44,45,46,47,48,49]]).

player(2, [[1,2,3,4,5,6,7,8,9],
              [10,11,12,13,14,15,16,17,18,19],
              [20,21,22,23,24,25,26,27,28,29],
              [30,31,32,33,34,35,36,37,38,39],
              [40,41,42,43,44,45,46,47,48,49]]).


/* Start Menu */

intro:-

write('Myriades').

start:-
        
         emptyBoard(Board),
         startmenu(Board).

startmenu(Board) :-
       
set_prolog_flag(fileerrors,off),
nl, intro, nl, nl,
        write('1 - Player vs Player'), nl,
        write('2 - Player vs AI'), nl,
        write('0 - Exit'), nl,
       
        repeat, read(Op), Op >= 0, Op =< 12,!,
        menu(Op, Board), repeat, skip_line, get_code(_), startmenu(Board).

menu(0):- 
abort.

menu(1, Board):-
        startGame(Board),
        startmenu(Board).

menu(2, Board):-
        

        
        startmenu(Board).

menu(3, Board):-
        checkValidBoard(Board, 1, 1),
        startmenu(Board).


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

rejoinValue(Value, User, Pval):-
        User1 is User*100,
        Value is User1+Pval.

checkValue(Value, User, Pval):-
        splitValue(Value, User, Pval).


printPieces([]).

printPieces([0|Resto]):-
        print(' '),
        print('|'),
        print(' '),
        printLine(Resto).

printPieces([P1|Resto]):-
        print(' '),
        print('|'),
        print(P1),
        printPieces(Resto).

printPlayerPieces(Player):-
        player(Player, Pieces),
        printPieces(Pieces).
        

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

printScenario(Board):-
        printBoard(Board, 1),
        print('Player 1 Pieces: '),
        printPlayerPieces(1),nl,
        print('Player 2 Pieces: '),
        printPlayerPieces(2).            


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

searchLine(Val, [Val|_], Y, X, Y, X).
              

searchLine(Val, [_|Rest], Y, X, CY, CX):-
        X < 6,
        NewX is X+1,
        searchLine(Val, Rest, Y, NewX, CY, CX). 

searchPiece([Line|_], X, Y, Val, CX, CY):-
        member(Val, Line),        
        searchLine(Val, Line, Y, X, CY, CX).
        
searchPiece([_|Rest], X, Y, Val, CX, CY):-
        Y < 10,
        NewY is Y+1,
        searchPiece(Rest, X, NewY, Val, CX, CY).  


searchPieceInList([Line|_], X, Y, Val, CX, CY):-
        member(Val, Line),        
        searchLine(Val, Line, Y, X, CY, CX).

searchPieceInList([_|Rest], X, Y, Val, CX, CY):-
        Y < 5,
        NewY is Y+1,
        searchPieceInList(Rest, X, NewY, Val, CX, CY).     

getPiecePos(Val, Board, X, Y):-
        searchPiece(Board, 1, 1, Val, X, Y). 

getPiecePosInPieces(Val, Board, X, Y):-
        searchPieceInList(Board, 1, 1, Val, X, Y). 

       

%%makePlay(Player, BoardIn, BoardOut, 

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
        getPiecePos(142, Board2, X, Y),
        movePiece(Board2, BoardOut, X, Y, 3, 6, 142),
        printBoard(BoardOut, 1).

startGame(Board):-
        print('Before we start to play, please decide which one of you will be the player with the blank pieces and the black ones.'),nl,  %%Possibly to remove
        print('Please be aware that the player with the blank pieces starts.'),nl,
        aquelaJogada(Board, 1).
        

aquelaJogada(Board, Player):-
        player(Player, _),        
        print('Player '),
        print(Player),
        print(' what would like to do?'),
        nl, nl,
        write('1 - Insert a Piece (Mandatory) '), nl,
        write('2 - Move a Piece'), nl,
        write('0 - Exit'), nl,
       
        repeat, read(Op), Op >= 0, Op =< 12,!,
        play(Op, Board, Player), repeat, skip_line, get_code(_), aquelaJogada(Board, Player).

play(0):- 
abort.

play(1, Board, Player):-
        nl,
        print('Please insert the value of the piece you wish to insert: '),nl,
        read(Val), 
        print('Please insert the desired location: '),nl,
        print('X: '),nl,
        read(X),
        print('Y: '),nl,
        read(Y),
        player(Player, Pieces),
        getPiecePosInPieces(Val, Pieces, Xp, Yp),
        insertPiece(Pieces, PiecesOut, Xp, Yp, '-1'),
        retract(player(Player, Pieces)),
        assert(player(Player, PiecesOut)),
        rejoinValue(InsValue,Player, Val),
        insertPiece(Board, BoardOut, X, Y, InsValue),              
        printScenario(BoardOut),nl,nl,
        
        print('You have sucessfully placed a Piece.'),nl,
        print('What would you like to do now?:'),nl,
        print('1 - Move a Piece'),nl,
        print('2 - Pass the turn'),nl,
        read(Opt),
        checkNextOption(Opt, BoardOut, Player),
        
        aquelaJogada(BoardOut, Player).

play(2, Board, Player):-
        print('Please insert the value of the piece you wish to move: '),nl,
        read(Val), 
        print('Please insert the desired location: '),nl,
        print('X: '),nl,
        read(X),
        print('Y: '),nl,
        read(Y),
        rejoinValue(InsValue, Player, Val),
        getPiecePos(InsValue, Board, Xi, Yi),
        movePiece(Board, BoardOut, Xi, Yi, X, Y, InsValue),              
        printBoard(BoardOut, 1),nl, nl,
        print('Your turn has finished.'),nl,
        checkPlayer(Player, Next),
        aquelaJogada(BoardOut, Next).


checkPlayer(1, Next):-
        Next is 1+1.

checkPlayer(2, Next):-
        Next is 2-1.

checkNextOption(1, BoardOut, Player):-
        play(2, BoardOut, Player).

checkNextOption(2, BoardOut, Player):-
        checkPlayer(Player, Next),
        aquelaJogada(BoardOut, Next).


