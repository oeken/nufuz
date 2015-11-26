

%:- use_module(gameModel).
:- consult('GameModel').
%:- consult('AgentOne').
:- consult('DependentSettings').
:- consult('GUI').


:- dynamic mainFrame:playernames/1.
:- dynamic mainFrame:playermodules/1.

%playernames(PlayerNames).
%playermodules(PlayerModuleNames).

getmodulename(PlayerName,ModuleName) :- playerNames(PlayerNames),
										playerModules(PlayerModuleNames),
										nth1(Index,PlayerNames,PlayerName),
										nth1(Index,PlayerModuleNames,ModuleName).



loadmodules([]).
loadmodules([H|T]) :- consult(H), loadmodules(T).


initializeGame :- 	display('Please enter player names and modules, example: [[onur,emre],[agentOne,agentOne]]\n'),
					read([PlayerNames,PlayerModuleNames]),
					
					assert(playerNames(PlayerNames)),
					assert(playerModules(PlayerModuleNames)),
					
					loadmodules(PlayerModuleNames),

					initiategame(PlayerNames).					


					

run :- 	
		
		initializeGame,
		initializeGUI,
		gameloop.
		



gameloop :- (gameison)
		->	(
				updateGUI,
				whosturnname(PlayerName),				

				log('This is : '),
				log(PlayerName),
 
				whosturn(Player),
				playertokens(Player,Tokens),
				playercardcolorvalues(Player,Cards),
				playergolds(Player,Golds),
				tokensonboard(BoardTokens),

				log('My_Tokens'),
				log(Tokens),
				log('My_Cards'),
				log(Cards),
				log('Golds'),
				log(Golds),
				log('Board Tokens'),
				log(BoardTokens),
							


				
				display('Hey it is my turn : '),
				display(PlayerName),
				display('\n'),
								
				getmodulename(PlayerName,ModuleName),
				queryandapplyaction(ModuleName),				

				
				
				

				gameloop
			)
			;
			(			
				winner(PlayerNum),
				display('Wohooo i won : '),
				display(PlayerNum),
				display('\n')
			).	
			
			
queryandapplyaction(ModuleName) :-	getaction(ModuleName,Action),										
									updategame(Action)
								->	(true)
									;
									display('Invalid action command, re-enter:\n'),
									queryandapplyaction(ModuleName).






log(Action) :- 	open('log.txt',append,Stream),
				write(Stream,Action), nl(Stream),
				close(Stream).









