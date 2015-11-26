

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
		initlog,
		initializeGame,
		initializeGUI,
		gameloop.
		



gameloop :- (gameison)
		->	(
				updateGUI,
				whosturnname(PlayerName),				

				log('\n'),
				log('This is : '),
				log(PlayerName),
				log('\n'),
 
				whosturn(Player),
				playertokens(Player,Tokens),
				playercardcolorvalues(Player,Cards),
				playergolds(Player,Golds),
				tokensonboard(BoardTokens),

				log('My_Tokens : '),
				log(Tokens),
				log('\n'),
				log('My_Cards : '),
				log(Cards),
				log('\n'),
				log('Golds : '),
				log(Golds),
				log('\n'),
				log('Board Tokens : '),
				log(BoardTokens),
				log('\n'),
							


				
				
								
				getmodulename(PlayerName,ModuleName),
				queryandapplyaction(ModuleName),				

				
				
				

				gameloop
			)
			;
			(			
				updateGUI,
				winner(PlayerNum),
				log('Wohooo i won : '),
				log(PlayerNum),
				log('\n')
			).	
			
			
queryandapplyaction(ModuleName) :-	getaction(ModuleName,Action),										
									updategame(Action)
								->	(true)
									;
									log('Invalid action command, re-enter:\n'),
									queryandapplyaction(ModuleName).




initlog:- 	open('log.txt',write,Stream),
			write(Stream,'Log FILE\n\n\n'),
			close(Stream).

log(Action) :- 	open('log.txt',append,Stream),
				write(Stream,Action),
				close(Stream),

				display(Action).









