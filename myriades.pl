:- use_module(library(lists)).
:- use_module(library(random)).
:-dynamic player/2.


%%DEFINITIONS

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


testBoard([[145,0,300,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,0,300,0,0,0,0,0,0,0],
[0,0,0,0,0,123,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0],
[0,125,212,0,0,0,0,0,0,0],
[0,232,0,0,0,0,300,0,0,0],
[0,0,0,0,0,0,0,125,0,0],
[0,0,300,0,0,0,0,0,0,0],
[0,0,0,0,0,0,0,0,0,0]]).


initialPieces([[1,2,3,4,5,6,7,8,9],
              [10,11,12,13,14,15,16,17,18,19],
              [20,21,22,23,24,25,26,27,28,29],
              [30,31,32,33,34,35,36,37,38,39],
              [40,41,42,43,44,45,46,47,48,49]]).


player(1, [[1,2,3,4,5,6,7,8,9,10],
              [10,11,12,13,14,15,16,17,18,19],
              [20,21,22,23,24,25,26,27,28,29],
              [30,31,32,33,34,35,36,37,38,39],
              [40,41,42,43,44,45,46,47,48,49]]).

player(2, [[1,2,3,4,5,6,7,8,9,10],
              [10,11,12,13,14,15,16,17,18,19],
              [20,21,22,23,24,25,26,27,28,29],
              [30,31,32,33,34,35,36,37,38,39],
              [40,41,42,43,44,45,46,47,48,49]]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


/* Start Menu */

intro:-

print('         Myriades').

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


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


%%%%%% Splits values on the board to PlayerNum and Piece Value and Rejoins Both again 

splitValue(Value, User, Pval):-
        Pval is mod(Value, 100),
        User is Value//100.

rejoinValue(Value, User, Pval):-
        User1 is User*100,
        Value is User1+Pval.

checkValue(300, User, Pval):-
        User is 30,
        Pval is 00.

checkValue(Value, User, Pval):-
        splitValue(Value, User, Pval).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%  Print Board and Scenario Predicates

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
        print('   '),
        printLine(Resto).

printLine([P1|Resto]):-
        checkValue(P1, User, Value),
        print(' '),
        print('|'),
        print(User),
        print(Value),
        printLine(Resto).

        
printDownSeq(10):-
        print(10).

printDownSeq(I):-
        print(I),
        print(' ').

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
        print('      1    2    3    4    5    6    7    8    9    10 '),nl,
        printBoard(Board, 1),nl,
        print('Player 1 Pieces: '),
        printPlayerPieces(1),nl,
        print('Player 2 Pieces: '),
        printPlayerPieces(2).        
    
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%% Insertion and Movement Predicates on the Board and Also to the List of Pieces


insertInBoardAux([_|Rest], [NewElem|Rest], 1, NewElem).        
insertInBoardAux([Elem|Rest], [Elem|NewRest], X, NewElem):-
        X > 1,
        NewX is X-1,
        insertInBoardAux(Rest, NewRest, NewX, NewElem).
                
insertInBoard([Line|Rest], [LineOut|Rest], X, 1, Val):-                %% Line Matched Condition
        insertInBoardAux(Line, LineOut, X, Val).                    
insertInBoard([Line|Rest], [Line|NewRest], X, Y, Val):-          %% Searches each line of the Board for until line X
        Y > 1,
        NewY is Y-1,
        insertInBoard(Rest, NewRest, X, NewY, Val).
        

insertPiece(BoardIn, BoardOut, X, Y, Val):-
        insertInBoard(BoardIn, BoardOut, X, Y, Val).  

movePiece(BoardIn, BoardOut, Xi, Yi, Xf, Yf, Val):-
        insertInBoard(BoardIn, Board2, Xi, Yi, 0),
        insertInBoard(Board2, BoardOut, Xf, Yf, Val).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Search X, Y Values on Board and get Piece Value

searchBoardAux([ThatElem|_], 1, ThatElem).        
searchBoardAux([_|Rest], X, ThatElem):-
        X > 1,
        NewX is X-1,
        searchBoardAux(Rest, NewX, ThatElem).
                
searchBoard([Line|_], X, 1, ThatElem):-                %% Line Matched Condition
        searchBoardAux(Line, X, ThatElem).                    
searchBoard([_|Rest], X, Y, ThatElem):-          %% Searches each line of the Board for until line X
        Y > 1,
        NewY is Y-1,
        searchBoard(Rest, X, NewY, ThatElem).

getPieceByPos(Board, X, Y, Value):-
        searchBoard(Board, X, Y, Value). 


%%%%%%%%%%%%%%%%%%%%%tra%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%% Search for X and Y values of Val Piece in the Board and Also in the List of Pieces



searchLine(Val, [Val|_], Y, X, Y, X).
              

searchLine(Val, [_|Rest], Y, X, CY, CX):-
        X < 10,
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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%  8 POSSIBLE MOVEMENTS THAT CAN BE DONE

movePieceByZone(Piece, Board, 1, Value, BoardOut):-           %% UP MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewY is Y-Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, X, NewY, 2),
        movePiece(Board, BoardOut, X, Y, X, NewY, Piece).

movePieceByZone(Piece, Board, 2, Value, BoardOut):-           %% DOWN MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewY is Y+Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, X, NewY, 2),
        movePiece(Board, BoardOut, X, Y, X, NewY, Piece).

movePieceByZone(Piece, Board, 3, Value, BoardOut):-           %% LEFT MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewX is X-Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, NewX, Y, 2),
        movePiece(Board, BoardOut, X, Y, NewX, Y, Piece).

movePieceByZone(Piece, Board, 4, Value, BoardOut):-           %% RIGHT MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewX is X+Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, NewX, Y, 2),
        movePiece(Board, BoardOut, X, Y, NewX, Y, Piece).

movePieceByZone(Piece, Board, 5, Value, BoardOut):-           %% UP + LEFT MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewY is Y-Value,
        NewX is X-Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, NewX, NewY, 2),
        movePiece(Board, BoardOut, X, Y, NewX, NewY, Piece).

movePieceByZone(Piece, Board, 6, Value, BoardOut):-           %% UP + RIGHT MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewY is Y-Value,
        NewX is X+Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, NewX, NewY, 2),
        movePiece(Board, BoardOut, X, Y, NewX, NewY, Piece).

movePieceByZone(Piece, Board, 7, Value, BoardOut):-           %% DOWN + LEFT MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewY is Y+Value,
        NewX is X-Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, NewX, NewY, 2),
        movePiece(Board, BoardOut, X, Y, NewX, NewY, Piece).

movePieceByZone(Piece, Board, 8, Value, BoardOut):-           %% DOWN + RIGHT MOVEMENT VALUE STEPS
        getPiecePos(Piece, Board, X, Y),
        NewY is Y+Value,
        NewX is X+Value,
        splitValue(Piece, Player, _),
        isPosEmpty(Board, Player, Piece, NewX, NewY, 2),
        movePiece(Board, BoardOut, X, Y, NewX, NewY, Piece).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Enemy nearby verification
        
isEnemy(Player, Player1, Value, Value1):-
         checkPlayer(Player, Player1),
         compareValues(Value, Value1). 

checkIfEnemy(Player, Player1, Value, Value1, 1):-
        \+isEnemy(Player, Player1, Value, Value1).

checkIfEnemy(Player, Player1, Value, Value1, 0):-
        isEnemy(Player, Player1, Value, Value1).
                

compareValues(Value, Value1):-
        Value > Value1.

checkBool(1, Inc, Count):-
        Count is Inc.

checkBool(0, Inc, Count):-        
        Count  is Inc+1.

checkAllNPos(Board, Player, X, 1, Value, CountOut, 1, FC):-
        checkAllNPos(Board, Player, X, 1, Value, CountOut, 2, FC).                      %%up verification

checkAllNPos(Board, Player, X, 10, Value, CountOut, 2, FC):-                            %%down verification
        checkAllNPos(Board, Player, X, 10, Value, CountOut, 3, FC).

checkAllNPos(Board, Player, 10, Y, Value, CountOut, 3, FC):-                            %%right verification
        checkAllNPos(Board, Player, 10, Y, Value, CountOut, 4, FC).

checkAllNPos(Board, Player, 1, Y, Value, CountOut, 4, FC):-                             %%left verification
        checkAllNPos(Board, Player, 1, Y, Value, CountOut, 5, FC).

checkAllNPos(Board, Player, 1, X, Value, CountOut, 5, FC):-                             %%up-left
        checkAllNPos(Board, Player, 1, X, Value, CountOut, 6, FC).

checkAllNPos(Board, Player, X, 1, Value, CountOut, 6, FC):-                            %%up-right
        checkAllNPos(Board, Player, X, 1, Value, CountOut, 7, FC).

checkAllNPos(Board, Player, X, 10, Value, CountOut, 7, FC):-
        checkAllNPos(Board, Player, X, 10, Value, CountOut, 8, FC).

checkAllNPos(_, _, 1, _, _, CountOut, 8,CountOut).
        
        
checkAllNPos(Board, Player, X, Y, Value, Count, 1, FC):-               %% up
        NewY is Y-1,
        getPieceByPos(Board, X, NewY, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, CountOut),
        checkAllNPos(Board, Player, X, Y, Value, CountOut, 2, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 2, FC):-               %% Down
        NewY is Y+1,
        NewY < 10,
        getPieceByPos(Board, X, NewY, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount),
        checkAllNPos(Board, Player, X, Y, Value, NewCount, 3, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 3, FC):-               %% Right
        NewX is X+1,        
        NewX < 10,
        getPieceByPos(Board, NewX, Y, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount),
        checkAllNPos(Board, Player, X, Y, Value, NewCount, 4, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 4, FC):-               %% Left
        NewX is X-1,
        getPieceByPos(Board, NewX, Y, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount),
        checkAllNPos(Board, Player, X, Y, Value, NewCount, 5, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 5, FC):-               %% Up + Left
        NewY is Y-1,
        NewX is X-1,
        getPieceByPos(Board, NewX, NewY, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount),
        checkAllNPos(Board, Player, X, Y, Value, NewCount, 6, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 6, FC):-               %% Up + Right
        NewY is Y-1,
        NewX is X+1,
        getPieceByPos(Board, NewX, NewY, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount),
        checkAllNPos(Board, Player, X, Y, Value, NewCount, 7, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 7, FC):-               %% Down + Right
        NewY is Y+1,
        NewX is X+1,
        getPieceByPos(Board, NewX, NewY, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount),
        checkAllNPos(Board, Player, X, Y, Value, NewCount, 8, FC).

checkAllNPos(Board, Player, X, Y, Value, Count, 8, NewCount):-               %% Down + Left
        NewY is Y+1,
        NewX is X-1,
        getPieceByPos(Board, NewX, NewY, NewValue),
        splitValue(NewValue, Player1, Val),
        checkIfEnemy(Player, Player1, Value, Val, Bool),
        checkBool(Bool, Count, NewCount).       
        
boardMakeEqual(Board, Board).

checkPieceNearbyForEnemys(_, Board, BoardOut, 0):- 
        boardMakeEqual(Board, BoardOut).                    


checkPieceNearbyForEnemys(Piece, Board, BoardOut, Count):- 
        splitValue(Piece, Player, _),                                              
        Count > 0,
        print('You have placed your piece nearby to '),
        print(Count),
        print(' enemy pieces.'),nl,
        makeChangesForEachEnemyValueLessThan(Count, Player, Board, BoardOut).

makeChangesForEachEnemyValueLessThan(0, _, _, _).
makeChangesForEachEnemyValueLessThan(Count, Player, Board, BoardOut):-
        print('Escolha a peça que deseja retirar: '),
        read(Piece),
        rejoinValue(Value, Player, Piece),
        player(Player, Pieces),
        getPiecePos(Value, Board, X, Y),
        insertPiece(Board, BoardOut, X, Y, 300),   
        getPiecePosInPieces(-1, Pieces, Xpi, Ypi),
        insertPiece(Pieces, PiecesOut, Xpi, Ypi, Piece),
        retract(player(Player, Pieces)),
        assert(player(Player, PiecesOut)),                     
        NewC is Count-1,
        makeChangesForEachEnemyValueLessThan(NewC, Player, Board, BoardOut).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%Check if pos empty

isPosEmpty(Board, Player, Piece, X, Y, 2):- 
        trace,
        getPieceByPos(Board, X, Y, Val),
        \+checkRightPlayer(0, Val),
        print('You cant place a piece there!'),nl,nl,
        checkNextOption(1, Board, Player, Piece).

isPosEmpty(Board, Player, X, Y, 1):- 
        getPieceByPos(Board, X, Y, Val),
        \+checkRightPlayer(0, Val),
        print('You cant place a piece there!'),nl,
        play(1, Board, Player).
                           
isPosEmpty(Board, _, X, Y, _):- 
        getPieceByPos(Board, X, Y, Val),
        checkRightPlayer(0, Val).
        

%%%%%%%%%%% Some Test Predicates

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

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% Game Start


startGame(Board):-
        nl,
        print('Before we start to play, please decide which one of you will be the player with the blank pieces and the black ones.'),nl,  %%Possibly to remove
        print('Please be aware that the player with the blank pieces starts.'),nl,
        nl,
        print('Initial Board: '),nl,nl,
        printScenario(Board),nl,
        aquelaJogada(Board, 1).


getPlayerPoints(Board, Player, _, Points):-
        searchBoardForPlayerPieces(Board, 1, 1, Player, 0, Points).        


getPoints(Board, _, 1):-                                     %%Menu final com pontuações inacabado
        nl,nl,nl,
        getPlayerPoints(Board, 1, _,  Points1),
        getPlayerPoints(Board, 2, _,  Points2),
        print('End Of Game!!!'),nl,
        print('Player 1, you scored : '), print(Points1), print(' points!!'),nl,
        print('Player 2, you scored : '), print(Points2), print(' points!!'),nl,
        nl,
        print('We hope you enjoyed, come back soon!!'),nl,nl.
 
aquelaJogada(Board, Player):-   
        nl,nl,     
        player(Player, _),        
        print('Player '),
        print(Player),
        print(' what would like to do?'),
        nl, nl,
        write('1 - Insert a Piece (Mandatory) '), nl,
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
        insertPiece(Pieces, PiecesOut, Xp, Yp, -1),
        isPosEmpty(Board, Player, X, Y, 1),
        retract(player(Player, Pieces)),
        assert(player(Player, PiecesOut)),
        rejoinValue(InsValue,Player, Val),
        insertPiece(Board, BoardOut, X, Y, InsValue),nl,
        nl,
        print('Current Board: '),nl,nl,              
        printScenario(BoardOut),nl,nl,
        
        print('You have sucessfully placed a Piece.'),nl,
        print('What would you like to do now?:'),nl,
        print('1 - Move a Piece'),nl,
        print('2 - Pass the turn'),nl,
        
        read(Opt),
        checkNextOption(Opt, BoardOut, Player, InsValue),        
        aquelaJogada(BoardOut, Player).

        
play(2, Board, Player, Piece):-
        print('Where do you want to move the piece to: '),nl,
        print('1 - North | '),
        print('2 - South | '),
        print('3 - West | '),
        print('4 - East | '),nl,
        print('5 - North West | '),
        print('6 - North East | '),
        print('7 - South West | '),
        print('8 - South East | '),nl,
        read(Zone),
        print('How many fields do you want to move? '),
        read(MFields),
        movePieceByZone(Piece, Board, Zone, MFields, Board1),
        getPiecePos(Piece, Board1, X, Y),
        splitValue(Piece, Player, Value),
        checkAllNPos(Board1, Player, X, Y, Value, 0, 1, NewCount),
        checkPieceNearbyForEnemys(Piece, Board1, BoardOut, NewCount),nl,nl,
        print('Current Board: '),nl,nl,              
        printScenario(BoardOut),nl, nl,
        %%hasGameEnded(BoardOut, Conf),
        
        print('Your turn has finished.'),
        
        checkPlayer(Player, Next),
        aquelaJogada(BoardOut, Next).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Verify Turns and Change if necessary
checkPlayer(1, Next):-
        Next is 1+1.

checkPlayer(2, Next):-
        Next is 2-1.


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%% Verify user Input and calls wanted predicate

getNewPiece(PrePiece, PieceIn, _, _, PieceOut):-         
        PrePiece =\= PieceIn,
        PieceOut is PieceIn.
        
getNewPiece(PrePiece, PieceIn, BoardOut, Player, _):-         
        PrePiece =:= PieceIn,
        print('You cannot move the Piece you just placed, please use another Piece. '), nl,
        checkNextOption(1, BoardOut, Player, PrePiece).

checkNextOption(1, BoardOut, Player, PrePiece):-
        print('Please insert the value of the piece you wish to move: '),nl,
        read(Val),
        rejoinValue(PieceIn, Player, Val),
        getNewPiece(PrePiece, PieceIn, BoardOut, Player, PieceOut),
        play(2, BoardOut, Player, PieceOut).

checkNextOption(2, BoardOut, Player, _):-
        checkPlayer(Player, Next),
        aquelaJogada(BoardOut, Next).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%% End Game Verification 

searchBoardForEmpty([Line|_], _, Val):-
        member(Val, Line).
        
searchBoardForEmpty([_|Rest], Y, Val):-
        Y < 10,
        NewY is Y+1,
        searchBoardForEmpty(Rest, NewY, Val).

isBoardFull(Board, HasIt):-
        searchBoardForEmpty(Board, 0, 0),
        HasIt is 0.

isBoardFull(Board, HasIt):-
        \+searchBoardForEmpty(Board, 0, 0),
        HasIt is 1.
        
        
hasGameEnded(Board, HasIt):-
        isBoardFull(Board, HasIt).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%% Sum calculation of player points

checkRightPlayer(Player, Player).

searchLine1(_, [_|_], 10, 10, _, _, _).              
 

searchLine1([Val|Rest],  Y, X, Player, AccumPoints, Points):-
        X < 11,
        NewX is X+1,
        splitValue(Val, Player1, Pval),
        checkRightPlayer(Player, Player1),
        Points is AccumPoints+Pval,
        searchLine(Rest, Y, NewX, Player, Points, AccumPoints).  

searchLine1([_|Rest],  Y, X, Player, AccumPoints, Points):-
        X < 11,
        NewX is X+1,
        searchLine(Rest, Y, NewX, Player, Points, AccumPoints).

searchBoardForPlayerPieces([Line|_], X, Y, Player, AccumPoints, Points):-
        searchLine1(Line, Line, Y, X, Player, AccumPoints, Points).
        
searchBoardForPlayerPieces([_|Rest], X, Y, Player, AccumPoints, Points):-
        Y < 10,
        NewY is Y+1,
        searchBoardForPlayerPieces(Rest, X, NewY, Player, AccumPoints, Points).

