%:- module(gameModel , [gamestate/1 , initiateGame/1 , updateGameState/1 , gameison]).

:- consult('Deck').
%:- use_module(dependentSettings).


:- dynamic turnnum/1.

:- dynamic playergolds/2.
:- dynamic playerreserves/2.
:- dynamic playertokens/2.
:- dynamic playercards/2.
:- dynamic playernobles/2.

:- dynamic tierdeck/2.
:- dynamic nobledeck/1.
:- dynamic tiercards/2.
:- dynamic noblecards/1.



:- dynamic playercount/1.
:- dynamic playernames/1.




%% updategame(State,Action) :- AnewState,
%% 							updategamestate(AnewState).

%% updategamestate(NewGameStateList) :-	retract(gamestate(_)),
%% 									 	assert(gamestate(NewGameStateList)).

updategame([taketwosame,TokenNames,GiveBacks]) 	:-	tokenlistify(TokenNames,L1), tokenlistify(GiveBacks,L2), taketwosamehelper(L1,L2).
updategame([takethreediff,TokenNames,GiveBacks]):-	tokenlistify(TokenNames,L1), tokenlistify(GiveBacks,L2), takethreediffhelper(L1,L2).
updategame([taketwodiff,TokenNames,GiveBacks]) 	:-	tokenlistify(TokenNames,L1), tokenlistify(GiveBacks,L2), taketwodiffhelper(L1,L2).
updategame([takeone,TokenNames,GiveBacks]) 		:-	tokenlistify(TokenNames,L1), tokenlistify(GiveBacks,L2), takeonehelper(L1,L2).

updategame([buy,tier,TierNum,TierLocation]) :- between(1,3,TierNum), between(1,4,TierLocation), getcardfromtier(TierNum,TierLocation,Card), takecardhelper(Card).
updategame([buy,res,Location]) 				:- between(1,3,Location), getcardfromres(Location,Card), takecardhelper(Card).

updategame([reserve,TierNum,TierLocation,GiveBacks]) 	:- getcardfromtier(TierNum,TierLocation,Card), tokenlistify(GiveBacks,List), reservecardhelper(Card,List).




takethreediffhelper(TokenSelectionList,TokenGiveBackList) 	:-	validmove(1,TokenSelectionList,TokenGiveBackList), tokenwithdrawal(TokenSelectionList) , tokengiveback(TokenGiveBackList), incrementturnnum.
taketwosamehelper(TokenSelectionList,TokenGiveBackList) 	:-	validmove(2,TokenSelectionList,TokenGiveBackList), tokenwithdrawal(TokenSelectionList) , tokengiveback(TokenGiveBackList), incrementturnnum.
taketwodiffhelper(TokenSelectionList,TokenGiveBackList) 	:-	validmove(3,TokenSelectionList,TokenGiveBackList), tokenwithdrawal(TokenSelectionList) , tokengiveback(TokenGiveBackList), incrementturnnum.
takeonehelper(TokenSelectionList,TokenGiveBackList) 		:-	validmove(4,TokenSelectionList,TokenGiveBackList), tokenwithdrawal(TokenSelectionList) , tokengiveback(TokenGiveBackList), incrementturnnum.





getcardfromres(Location,Card) 				:- whosturn(Player), playerreserves(Player,List), nth1(Location,List,Card).
getcardfromtier(TierNum,TierLocation,Card) 	:- tiercards(TierNum,List), nth1(TierLocation,List,Card).

takecardhelper(Card) :- validmove(5,Card), cardpurchase(Card), forall(between(1,3,X) , drawtiercards(X)), takenobleifdeserved ,incrementturnnum.
reservecardhelper(Card,GiveBack) :- validmove(6,Card,GiveBack), cardreservation(Card), tokengiveback(GiveBack), forall(between(1,3,X) , drawtiercards(X)), incrementturnnum.




incrementturnnum :- retract(turnnum(TurnNum)),
					IncrementedTurnNum is TurnNum+1,
					assert(turnnum(IncrementedTurnNum)).



takenobleifdeserved :-	whosturn(Player),
						noblecards(Nobles),						
						forall(member(ANobleCard,Nobles),(
															playercardcolorvalues(Player,CardPossessions),
															nobleextract(ANobleCard,Values),
															twolistsubtract(CardPossessions,Values,Remainder),
															(
															not(containsnegativeelement(Remainder))
														->	(
																
																removecardfromitslocation(ANobleCard),
																retract(playernobles(Player,PlayerNobleCards)),
																append([ANobleCard],PlayerNobleCards,NewPlayerNobleCards),
																assert(playernobles(Player,NewPlayerNobleCards))
															)
															;
															(
																true
															))
						)).


						


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	   Move			%%%%%%%%
%%%%%%%%    Validations		%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
validmovehelper(TokenSelectionList,TokenGiveBackList) :- 	whosturn(Player),
															playertokens(Player,Tokens),
															twolistsum(Tokens,TokenSelectionList,Hyphotetical),
															sum_list(Hyphotetical,Aggregate),
															playergolds(Player,GoldNum),
															Total is GoldNum+Aggregate,
															
															(Total > 10)														
														->	(
																ReturnNum is Total - 10,
																not(containsnegativeelement(TokenGiveBackList)),
																sum_list(TokenGiveBackList,Sum),
																Sum == ReturnNum,
																twolistsubtract(Hyphotetical,TokenGiveBackList,Remainder),
																not(containsnegativeelement(Remainder))
															)
															;
															(
																occurrence(0,TokenGiveBackList,5)															
															).



validmove(6,Card,GiveBack) :- 	whosturn(Player),
								playerreserves(Player,Reserves),
								length(Reserves,ReserveCount),
								ReserveCount < 3,

								reservablecards(Cards),
								member(Card,Cards),
								(
								remaininggolds(0)
							->	(
									occurrence(0,GiveBack,5)
								)
								;
								(
									playertotaltokencount(Player,TotalTokens),
									Hypothetical is TotalTokens+1,
									Hypothetical>10
								->	(
										occurrence(0,GiveBack,4),
										occurrence(1,GiveBack,1),
										playertokens(Player,Tokens),
										twolistsubtract(Tokens,GiveBack,Remainder),
										not(containsnegativeelement(Remainder))
									)
									;
									(
										occurrence(0,GiveBack,5)
									)

								)).

								%% (
								%% 	(
								%% 	occurrence(0,GiveBack,5),
								%% 	playertotaltokencount(Player,TotalTokens),
								%% 	TotalTokens < 10
								%% 	)
								%% 	;
								%% 	(
								%% 	occurrence(0,GiveBack,4),
								%% 	occurrence(1,GiveBack,1),
								%% 	playertotaltokencount(Player,10)									
								%% 	)
								%% ).



validmove(1,TokenSelectionList,TokenGiveBackList) :- 	occurrence(0,TokenSelectionList,2),														
														occurrence(1,TokenSelectionList,3),
														
														tokensonboard(TokensOnBoard),
														twolistsubtract(TokensOnBoard,TokenSelectionList,RemainingTokens),
														not(containsnegativeelement(RemainingTokens)),

														validmovehelper(TokenSelectionList,TokenGiveBackList).





validmove(2,TokenSelectionList,TokenGiveBackList) :- 	occurrence(0,TokenSelectionList,4),
														occurrence(2,TokenSelectionList,1),


														tokensonboard(TokensOnBoard),
														twolistsubtract(TokensOnBoard,TokenSelectionList,RemainingTokens),
														nth1(Index,TokenSelectionList,2),
														nth1(Index,RemainingTokens,RemainingFromThatColor),
														RemainingFromThatColor >= 2,

														validmovehelper(TokenSelectionList,TokenGiveBackList).


validmove(3,TokenSelectionList,TokenGiveBackList) :- 	occurrence(0,TokenSelectionList,3),
														occurrence(1,TokenSelectionList,2),

														tokensonboard(TokensOnBoard),
														checkspecialcasefortwodifferent(TokensOnBoard),

														twolistsubtract(TokensOnBoard,TokenSelectionList,RemainingTokens),
														not(containsnegativeelement(RemainingTokens)),

														validmovehelper(TokenSelectionList,TokenGiveBackList).

validmove(4,TokenSelectionList,TokenGiveBackList) :- 	occurrence(0,TokenSelectionList,4),
														occurrence(1,TokenSelectionList,1),

														tokensonboard(TokensOnBoard),
														checkspecialcaseforsingle(TokensOnBoard),
														
														twolistsubtract(TokensOnBoard,TokenSelectionList,RemainingTokens),
														not(containsnegativeelement(RemainingTokens)),

														validmovehelper(TokenSelectionList,TokenGiveBackList).														


checkspecialcaseforsingle(TokensOnBoard) :- (occurrence(0,TokensOnBoard,4),occurrence(3,TokensOnBoard,1));
											(occurrence(0,TokensOnBoard,4),occurrence(2,TokensOnBoard,1));
											(occurrence(0,TokensOnBoard,4),occurrence(1,TokensOnBoard,1)).


checkspecialcasefortwodifferent(TokensOnBoard) :-	(occurrence(0,TokensOnBoard,3),occurrence(3,TokensOnBoard,2));
													(occurrence(0,TokensOnBoard,3),occurrence(3,TokensOnBoard,1),occurrence(2,TokensOnBoard,1));
													(occurrence(0,TokensOnBoard,3),occurrence(3,TokensOnBoard,1),occurrence(1,TokensOnBoard,1));
													(occurrence(0,TokensOnBoard,3),occurrence(2,TokensOnBoard,2));
													(occurrence(0,TokensOnBoard,3),occurrence(2,TokensOnBoard,1),occurrence(1,TokensOnBoard,1));
													(occurrence(0,TokensOnBoard,3),occurrence(1,TokensOnBoard,2)).



validmove(5,Card) :- 	whosturn(Player),						
						purchasablecards(Player,PurchasableCards),
						member(Card,PurchasableCards).						




								


								


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	  Action #6		%%%%%%%%
%%%%%%%%  Card Reservation	%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

reservablecards(Cards) :- 	tiercards(1,C1),tiercards(2,C2),tiercards(3,C3),
							append(C2,C3,Temp),							
							append(C1,Temp,Cards).


cardreservation(Card) :-	whosturn(Player),
							
							removecardfromitslocation(Card),
							retract(playerreserves(Player,ReservedCards)),
							append([Card],ReservedCards,NewReservedCards),
							assert(playerreserves(Player,NewReservedCards)),

							not(remaininggolds(0))
						->	(
								retract(playergolds(Player,Golds)),
								NewGolds is Golds+1,
								assert(playergolds(Player,NewGolds))
							)
							;
							(
								true
							).
							

							
							



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	  Action #5		%%%%%%%%
%%%%%%%%   Card Purchase	%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
cardpurchase(Card) :-	whosturn(Player),												
						findpayment(Player,Card,TokenPayment,GoldPayment),
						applypayment(Player,TokenPayment,GoldPayment),
						takecard(Player,Card).

						
						
applypayment(Player,TokenPayment,GoldPayment) :-	
													retract(playertokens(Player,Tokens)),
													twolistsubtract(Tokens,TokenPayment,RemainingTokens),
													assert(playertokens(Player,RemainingTokens)),

													retract(playergolds(Player,Golds)),
													NewGolds is Golds - GoldPayment,
													assert(playergolds(Player,NewGolds))
													.
						

removecardfromitslocation(Card) :- 	(
										tiercards(1,TierOneCards),
										member(Card,TierOneCards),
										delete(TierOneCards,Card,NewTierOneCards),
										retract(tiercards(1,TierOneCards)),
										assert(tiercards(1,NewTierOneCards))
									)
									;
									(
										tiercards(2,TierTwoCards),
										member(Card,TierTwoCards),
										delete(TierTwoCards,Card,NewTierTwoCards),
										retract(tiercards(2,TierTwoCards)),
										assert(tiercards(2,NewTierTwoCards))
									)
									;
									(
										tiercards(3,TierThreeCards),
										member(Card,TierThreeCards),
										delete(TierThreeCards,Card,NewTierThreeCards),
										retract(tiercards(3,TierThreeCards)),
										assert(tiercards(3,NewTierThreeCards))
									)
									;
									(
										playerreserves(Player,ReservedCards),
										member(Card,ReservedCards),
										delete(ReservedCards,Card,NewReservedCards),
										retract(playerreserves(Player,ReservedCards)),
										assert(playerreserves(Player,NewReservedCards))
									)
									;
									(
										noblecards(NobleCards),
										member(Card,NobleCards),
										delete(NobleCards,Card,NewNobleCards),
										retract(noblecards(NobleCards)),
										assert(noblecards(NewNobleCards))
									).
									
									

takecard(Player,Card) :- 	removecardfromitslocation(Card),
							retract(playercards(Player,Cards)),
							append([Card],Cards,NewCards),
							assert(playercards(Player,NewCards)).






					

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%   Action #1 & #2	%%%%%%%%
%%%%%%%%   Token Withdrawal	%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tokenwithdrawal(TokenSelectionList) :-	whosturn(Player),
												playertokens(Player,HisTokens),
												twolistsum(HisTokens,TokenSelectionList,NewTokens),
												retract(playertokens(Player,HisTokens)),
												assert(playertokens(Player,NewTokens)).

												
tokengiveback(TokenGiveBackList) :- whosturn(Player),
									playertokens(Player,HisTokens),
									twolistsubtract(HisTokens,TokenGiveBackList,NewTokens),
									retract(playertokens(Player,HisTokens)),
									assert(playertokens(Player,NewTokens)).


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%   		Game 		%%%%%%%%
%%%%%%%%   	 Initiation		%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
initiategame(PlayerNames) :- 	setupstaticvariables(PlayerNames),
								setupdynamicvariables.


setupstaticvariables(PlayerNames) :-	length(PlayerNames,PlayerCount),
										
										retract(playercount(_)),
										assert(playercount(PlayerCount)),

										retract(playernames(_)),
										assert(playernames(PlayerNames)),

			
										deck1(Deck1Cards),
										deck2(Deck2Cards),
										deck3(Deck3Cards),
										nobles(NobleCards),

										random_permutation(Deck1Cards,Deck1CardsShuffled),
										random_permutation(Deck2Cards,Deck2CardsShuffled),
										random_permutation(Deck3Cards,Deck3CardsShuffled),
										random_permutation(NobleCards,NobleCardsShuffled),

										assert(tierdeck(1,Deck1CardsShuffled)),
										assert(tierdeck(2,Deck2CardsShuffled)),
										assert(tierdeck(3,Deck3CardsShuffled)),
										assert(nobledeck(NobleCardsShuffled))
					 					.
									
setupdynamicvariables :- 	playercount(PlayerCount),								
							forall(between(1,PlayerCount,X) , initiateplayer(X)),
							
							selectnoblecards,
							noblecards(Cards),
							assert(copynoblecards(Cards)),

							forall(between(1,3,X) , drawtiercards(X)).

							%% drawtiercards(1),
		 				%% 	drawtiercards(2),
		 				%% 	drawtiercards(3).


initiateplayer(Player) :- 	makeList(5,0,ZeroList),

							assert(playercards(Player,[])),
							assert(playergolds(Player,0)),
							assert(playertokens(Player,ZeroList)),
							assert(playernobles(Player,[])),
							assert(playerreserves(Player,[])).


	
selectnoblecards :-	noblecards(NC),
					length(NC,Length),
					noblenum(ExpectedNum),
					(
						Length == ExpectedNum
					 ->	true
					 ;	(
					 		nobledeck([H|T]),
					 		noblecards(OldList),
					 		append([H] , OldList , NewList),

					 		retract(nobledeck(_)),
					 		assert(nobledeck(T)),

					 		retract(noblecards(_)),
					 		assert(noblecards(NewList)),

					 		selectnoblecards
					 		

					 	)

					).

					
drawtiercards(TierIndex) :-		tiercards(TierIndex,CardList),
								length(CardList,Length),								
								(
									Length == 4
								 ->	true
								 ;	(
								 		tierdeck(TierIndex,[H|T]),
								 		tiercards(TierIndex,OldList),
								 		append([H] , OldList , NewList),

								 		retract(tierdeck(TierIndex,_)),
								 		assert(tierdeck(TierIndex,T)),

								 		retract(tiercards(TierIndex,_)),
								 		assert(tiercards(TierIndex,NewList)),

								 		(drawtiercards(TierIndex);true)

								 	)

								).
										



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	  Static		%%%%%%%%
%%%%%%%%   State-Variables	%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
playercount(1). % WILL BE REPLACED IN INITIALIZATION
playername(Player,Name) :- playernames(List), nth1(Player, List,Name).
playernames([]). % WILL BE REPLACED IN INITIALIZATION

tokennum(N) :- playercount(C) , tokencount(C,N).
noblenum(N) :- playercount(C) , noblecount(C,N).
goldnum(3).



colororder([white,blue,green,red,black]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	  Dynamic		%%%%%%%%
%%%%%%%%   State-Variables	%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%tierdeck(1,L) :- permutated deck1(L).  WILL BE ASSERTED
%tierdeck(2,L) :- permutated deck2(L).  WILL BE ASSERTED
%tierdeck(3,L) :- permutated deck3(L).  WILL BE ASSERTED
%nobledeck(L)  :- permutated nobles(L). WILL BE ASSERTED

turnnum(1).

tiercards(1,[]).
tiercards(2,[]).
tiercards(3,[]).
noblecards([]).

%playercards(1,AList).		WILL BE ASSERTED
%playergolds(1,ANum).		WILL BE ASSERTED
%playertokens(1,Alist).		WILL BE ASSERTED
%playernobles(1,Alist).		WILL BE ASSERTED
%playerreserves(1,Alist).	WILL BE ASSERTED

						



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	Deductables		%%%%%%%%
%%%%%%%%   					%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
indexandcolor(Index,Color) :- colororder(List) ,nth1(Index,List,Color).

gamestate([]).

%% gamestate([Status,Who,PStates,[Cards1,Cards2,Cards3,CardsNoble] , L1, L2, L3 ]) :- 	status(Status) , 
%% 																					whosturn(Who) , 
%% 																					playerstates(PStates), 
																					
%% 																					tiercards(1,Cards1),
%% 																					tiercards(2,Cards2),
%% 																					tiercards(3,Cards3),
%% 																					noblecards(CardsNoble),

%% 																					tierdeck(1,Deck1),
%% 																					tierdeck(2,Deck2),
%% 																					tierdeck(3,Deck3),
%% 																					length(Deck1,L1),
%% 																					length(Deck2,L2),
%% 																					length(Deck3,L3).





whosturnname(PlayerName) :- whosturn(Player), playernames(Names), nth1(Player,Names,PlayerName).

whosturn(Player) :- turnnum(TurnNum),
					playercount(PlayerCount),
					TempValue is TurnNum - 1,
					TempValue2 is TempValue mod PlayerCount,
					Player is TempValue2 + 1.


tokensonboard(List) :- 	tokennum(TokenNum), 
						makeList(5,TokenNum,TotalList),
						findall(Tokens , playertokens(_,Tokens) , TokensOfAllPlayers),
						listsum(TokensOfAllPlayers,TotalPossessedByPlayers),
						twolistsubtract(TotalList,TotalPossessedByPlayers,List),!.


playercardcount(Player,Color,Quantity) :- 	playercards(Player,CardsOwned),
											findall(Id , member([Id,_,Color|_],CardsOwned) , Ids ),
											length(Ids,Quantity).


playercardcolorvalues(Player,[White,Blue,Green,Red,Black]) :- 	playercardcount(Player,white,White),
																playercardcount(Player,blue,Blue),
																playercardcount(Player,green,Green),
																playercardcount(Player,red,Red),
																playercardcount(Player,black,Black).



playerpower(Player,List) :- playercardcolorvalues(Player,CardPower) ,playertokens(Player,TokenPower), twolistsum(CardPower,TokenPower,List).

%%%%%TEST
playertotaltokencount(Player,Count) 	:- playerregulartokencount(Player,C1),playergolds(Player,C2), Count is C1+C2 .
playerregulartokencount(Player,Count)	:- playertokens(Player,Tokens), sum_list(Tokens,Count).	
playertokensbycolor(Player,Color,Count) :- playertokens(Player,Tokens), indexandcolor(Index,Color) , nth1(Index,Tokens,Count),!.
playertokensbyindex(Player,Index,Count) :- playertokens(Player,Tokens), nth1(Index,Tokens,Count),!.
											
%%%%%TEST

%% playercardsbyindex(Player,Index,Count) :- 	playercardcolorvalues(Player,Cards), nth1(Index,Cards,Count).

playertotalcardcount(Player,Count) :- playercardcolorvalues(Player,List), sum_list(List,Count).
playercardsbyindex(Player,Index,Count) :- 	indexandcolor(Index,Color), playercardcount(Player,Color,Count),!.
playercardsbycolor(Player,Color,Count) :- 	playercardcount(Player,Color,Count),!.
%% playercardsbycolor(Player,Color,Count) :- 	playercardcolorvalues(Player,Cards), indexandcolor(Index,Color), nth1(Index,Cards,Count).

%% playercardsbycolor(Player,Color,Count) :- 	playercards(Player,CardsOwned),
%% 											findall(Id , member([Id,_,Color|_],CardsOwned) , Ids ),
%% 											length(Ids,Count).


											







playerpoints(Player,Points) :- 	playernobles(Player,Nobles),
								length(Nobles,NobleCount),
								NoblePoints is 3*NobleCount,

								playercards(Player,Cards),
								findall(Pts1,(member(Card,Cards),cardextract(Card,pts,Pts1)),PtsSet1),								
								sumlist(PtsSet1,CardPoints),
								Points is NoblePoints+CardPoints.


gameisnoton :- winner(_),whosturn(1).
gameison :- not(gameisnoton).

winner(Player) :- 	bagof(Pla,(playerpoints(Pla,Po),Po>=15),EligiblePlayers),
					bagof(Po,(playerpoints(Pla,Po),Po>=15),TheirPoints),
					max_member(MaxPoint,TheirPoints),
					findall(Index,(nth1(Index,TheirPoints,MaxPoint)),MaxIndexes),
					(
					length(MaxIndexes,1)
				->	(
						nth1(1,MaxIndexes,WinnerIndex),
						nth1(WinnerIndex,EligiblePlayers,Player)
					)
					;
					(
						bagof(Count,(member(Index,MaxIndexes), nth1(Index,EligiblePlayers,Player), playertotalcardcount(Player,Count)),Cs),
						min_member(MinCardCount,Cs),
						findall(MinIndex,(nth1(MinIndex,Count,MinCardCount)),MinIndexes),
						length(MinIndexes,1)
					->	(
							nth1(1,MinIndexes,WinnerIndex),
							nth1(WinnerIndex,EligiblePlayers,Player)
						)
						;
						(
							Player = friendship
						)											
					)).
					



purchasablecards(Player,PurchasableCards) :- 			tiercards(1,TierOneCards),
														tiercards(2,TierTwoCards),
														tiercards(3,TierThreeCards),
														playerreserves(Player,ReservedCards),
														
														append(TierOneCards,TierTwoCards,Temp1),
														append(Temp1,TierThreeCards,Temp2),
														append(Temp2,ReservedCards,Alltogether),

														setof( ACard, (member(ACard,Alltogether),findpayment(Player,ACard,_,_)), PurchasableCards).



%% findpayment(Player,Card,TokenPayment,GoldPayment) :- 	playercardcolorvalues(Player,ColorValues),
%% 														playertokens(Player,Tokens),														
%% 														cardextract(Card,price,CardPrice),

%% 														twolistsubtract(CardPrice,ColorValues,Temp1),
%% 														eliminatenegatives(Temp1,RemainingPrice),																										

%% 														twolistsubtract(RemainingPrice,Tokens,Temp2), 
%% 														eliminatenegatives(Temp2,RemainingPrice2),

														

%% 														(sum_list(RemainingPrice2,SumValue),SumValue == 0)
%% 													->	(GoldPayment is 0)
%% 														;
%% 														(
%% 															playergolds(Player,GoldNum),																													
%% 															(GoldNum >= SumValue)
%% 														->	(GoldPayment is SumValue)
%% 															;
%% 															(
%% 																false
%% 															)
														%% ).												

paymentcaseone(RemainingPrice1,[0,0,0,0,0],0) :- sum_list(RemainingPrice1,0).

paymentcasetwo(RemainingPrice2,RemainingPrice1,RemainingPrice1,0) :- sum_list(RemainingPrice2,0).

paymentcasethree(RemainingPrice2,RemainingPrice1,Gold,TokenPayment,Sum) :- sum_list(RemainingPrice2,Sum), Gold >= Sum, twolistsubtract(RemainingPrice1,RemainingPrice2,TokenPayment).
						
															




	
	
findpayment(Player,Card,TokenPayment,GoldPayment) :- 	playercardcolorvalues(Player,PowerColors),
														playertokens(Player,Tokens),														
														playergolds(Player,Golds),
														cardextract(Card,price,CardPrice),

														twolistsubtract(CardPrice,PowerColors,Temp1),
														eliminatenegatives(Temp1,RemainingPrice1),																										

														twolistsubtract(RemainingPrice1,Tokens,Temp2), 
														eliminatenegatives(Temp2,RemainingPrice2)
														,														
														(
															paymentcaseone(RemainingPrice1,TokenPayment,GoldPayment);
															paymentcasetwo(RemainingPrice2,RemainingPrice1,TokenPayment,GoldPayment);
															paymentcasethree(RemainingPrice2,RemainingPrice1,Golds,TokenPayment,GoldPayment)														
														).



remaininggolds(Number) :- 	goldnum(TotalNum),
							findall(HisGolds,playergolds(_,HisGolds),GoldsList),
							sum_list(GoldsList,CollectedNum),
							Number is TotalNum - CollectedNum.




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	  Accessors		%%%%%%%%
%%%%%%%%   					%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%getStatus(Status) :- gamestate(List), nth1(1,List,Status).
%getCurrentTurnNum(Turn) :- gamestate(List), nth1(2,List,Turn).
%getCurrentTurnPlayer(Player) :- gamestate(List), nth1(3,List,Player).
%getPlayerCount :- gamestate(List), nth1(4,List,PlayerCount).
%getPlayerNames(PlayerNames) :-  gamestate(List), nth1(5,List,PlayerNames).
%getPlayerStates(PlayerStates) :-  gamestate(List), nth1(6,List,PlayerStates).
%getPlayerName(PlayerNum,PlayerName) :- getPlayerNames(List) , nth1(PlayerNum,List).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%	Helper		%%%%%%%%
%%%%%%%%	Functions	%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
makeList(0,_,[]).
makeList(Length,Value,List) :- 	NewLength is Length-1,
								makeList(NewLength,Value,InnerList),
								append([Value],InnerList,List).


listmpy([],_,[]).
listmpy([H|T],Factor, [RH|RT]) :- RH is H*Factor, listmpy(T,Factor,RT).


twolistsum([],[],[]).
twolistsum([H1|T1],[H2|T2],[H3|T3]) :- H3 is H1+H2,
									twolistsum(T1,T2,T3).

twolistsubtract(L1,L2,L3) :- 	listmpy(L2,-1,L2Inverted),
								twolistsum(L1,L2Inverted,L3).

listsum([H|[]],H) :- !.
listsum([H|T],Result) :-  listsum(T,InnerResult), twolistsum(H,InnerResult, Result).


sublist(Start,Start,List,[Elem]) :- nth1(Start,List,Elem),!.
sublist(Start,End,List,Sublist) :- 	nth1(Start,List,Elem1),
									NewStart is Start+1,
									sublist(NewStart,End,List,InnerSublist),
									append([Elem1],InnerSublist,Sublist).


occurrence(_,[],0).
occurrence(Value,[Value|T],Count) :- occurrence(Value,T,InnerCount) , Count is InnerCount+1.
occurrence(Value,[H|T],Count) :- Value \= H , occurrence(Value,T,Count).



eliminatenegatives([],[]).
eliminatenegatives([H|T],[HNew|TNew]) :- 	((H < 0)
									->	(HNew is 0);
										HNew is H),
										eliminatenegatives(T,TNew).

containsnegativeelement([]) :- false.
containsnegativeelement([H|T]) :- H < 0 ; containsnegativeelement(T).


cardextract(Card,id,Result) :- nth1(1,Card,Result).
cardextract(Card,pts,Result) :- nth1(2,Card,Result).
cardextract(Card,color,Result) :- nth1(3,Card,Result).
cardextract(Card,price,Result) :- sublist(4,8,Card,Result).

nobleextract(NobleCard,List) :- sublist(2,6,NobleCard,List).

tokenlistify([],[0,0,0,0,0]).
tokenlistify([H|T],List) :- colorandlist(H,L1), tokenlistify(T,L2), twolistsum(L1,L2,List).

colorandlist(white,[1,0,0,0,0]).
colorandlist(blue,[0,1,0,0,0]).
colorandlist(green,[0,0,1,0,0]).
colorandlist(red,[0,0,0,1,0]).
colorandlist(black,[0,0,0,0,1]).


playernobleindexes(Player,List) :- playernobles(Player,Nobles), copynoblecards(WholeNobles), findall(Index,(member(ACard,Nobles),nth1(Index,WholeNobles,ACard)), List) .




