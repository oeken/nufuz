:- use_module(library(tabular)).
:- use_module(library(autowin)).



%% basepath(cardslow,'./frame-resources/images/allcards_low/').
basepath(cards,'./frame-resources/img_processed/cards/').
basepath(cards_framed,'./frame-resources/img_processed/cards_framed/').
basepath(tokens,'./frame-resources/img_processed/gems/').

concat_threeway(A1,A2,A3,Result) :- atom_concat(A2,A3,Temp), atom_concat(A1,Temp,Result).

tokens(TokenName,Path) :- basepath(tokens,Base), concat_threeway(Base,TokenName,'.jpg',Path).

cards(CardID, Path) :- basepath(cards,Base), concat_threeway(Base,CardID,'.jpg',Path).

cards(framed,CardID, Path) :- basepath(cards_framed,Base), concat_threeway(Base,CardID,'.jpg',Path).

emptyimg(Path) :- basepath(cards,Base), concat_threeway(Base,'empty','.jpg',Path).
closedimg(Path) :- basepath(cards,Base), concat_threeway(Base,'closed','.jpg',Path).

%% cardimglow(CardID, Path) :- basepath(cardimglow,Base), concat_threeway(Base,CardID,'.jpg',Path).


%% whosturn(2).

%% playercount(4).

%% playername(1,a).
%% playername(2,b).
%% playername(3,c).
%% playername(4,d).

%% tokennum(7).

%% noblenum(4).

%% goldnum(3).



%%%% Section One
%nobledialog(NobleIndex,Dialog).

%%%% Section Two
%deckdialog(TierNum,Dialog).

%%%% Section Three
%carddialog(TierNum,CardIndex,Dialog).


%%%% Section Four
%whosturndialog(Dialog);
%playerdialog(PlayerNum,"name",Dialog). 

%playerdialog(PlayerNum,"card",Color,Dialog).  
%playerdialog(PlayerNum,"token",Color,Dialog). 
%playerdialog(PlayerNum,"gold",Dialog).  
%playerdialog(PlayerNum,"total",Dialog).  


%%%% Section Five
%tokensonboarddialog(Color,Dialog).
%golddnumdialog(Dialog).

%%%% Section Six
%reservedialog(PlayerNum,Slot,Dialog).

%%%% Section Seven
%boarddialog(Dialog).




updateGUI :- 	



				forall(between(1,3,X),(
										forall(between(1,4,Y),(
																
																(
																	
																	(tiercards(X,TierCards),
																	nth1(Y,TierCards,CardDetail))
																->	(
																			(whosturn(Player),																	
																			purchasablecards(Player,Purchasables),
																			member(CardDetail,Purchasables))
																		->	(
																				tiercards(X,Cards),
																				getids(Cards,Ids),
																				nth1(Y,Ids,Id),
																				
																				cards(framed,Id,ImgPath),
																				carddialog(X,Y,BM),
																				send(BM,load, ImgPath)
																			)
																			;
																			(
																				tiercards(X,Cards),
																				getids(Cards,Ids),
																				nth1(Y,Ids,Id),
																				
																				cards(Id,ImgPath),
																				carddialog(X,Y,BM),
																				send(BM,load, ImgPath)
																			)
																	)
																	;
																	(
																		emptyimg(EmptyPath),
																		carddialog(X,Y,BM),
																		send(BM,load, EmptyPath)
																	)
																)
																
															)
												)
										)
				),

				

				whosturn(WhosTurn),
				whosturndialog(WhoDialog),
				send(WhoDialog,string(WhosTurn)),


				


				playercount(PC),
				forall(between(1,PC,X),(
										playergolds(X,Golds),
										playerdialog(X,gold,GoldDialog),
										send(GoldDialog,string(Golds)),

										playertotaltokencount(X,TotalToken),
										atom_concat(TotalToken,'/10',Result),
										playerdialog(X,total,TotalDialog),
										send(TotalDialog,string(Result)),

										playerpoints(X,Points),										
										playerdialog(X,point,PointDialog),
										send(PointDialog,string(Points)),														

										playernobleindexes(X,NobleIndexes),										
										playerdialog(X,noble,NobleIndexDialog),
										listtoatom(NobleIndexes,Printable),
										send(NobleIndexDialog,string(Printable)),														

										forall(between(1,5,Y),(
																indexandcolor(Y,CurrentColor),																

																playercardsbyindex(X,Y,CardCount),																															
																playerdialog(X,card,CurrentColor,CardDialog),																
																send(CardDialog,string(CardCount)),														

																playertokensbyindex(X,Y,TokenCount),
																playerdialog(X,token,CurrentColor,TokenDialog),
																send(TokenDialog,string(TokenCount)),														

																playerpower(X,Power),
																nth1(Y,Power,Value),
																playerdialog(X,power,CurrentColor,PowerDialog),
																send(PowerDialog,string(Value))														

																

										)),

										playerreserves(X,Reserves),
										length(Reserves,RNum),
										forall(between(1,RNum,Y),(
																playerreserves(X,Reserves),
																getids(Reserves,RIds),
																nth1(Y,RIds,Id),
																cards(Id,CardImg),

																reservedialog(X,Y,ReserveDialog),
																send(ReserveDialog,load,CardImg)

										)),				

										RNumNew is RNum+1,
										(						
										forall(between(RNumNew,3,Y),(
																	emptyimg(Empty),
																	reservedialog(X,Y,ReserveDialog),
																	send(ReserveDialog,load,Empty)
																	
										))
										
										;
										true
										)										

					)),

					forall(between(1,5,X),(
											tokensonboard(Tokens),
											nth1(X,Tokens,TokenCount),
											indexandcolor(X,Color),
											
											tokensonboarddialog(Color,ColorDialog),
											send(ColorDialog,string(TokenCount))											
											)),

					

					remaininggolds(Golds),
					golddnumdialog(GoldDialog),
					send(GoldDialog,string(Golds)).


					











				
			












initializeGUI :- 	createGUI,
					updateGUI.


createGUI :- 	

				new(RedC,colour('Red',62220,16830,13770)),
				new(GreenC,colour('Green',19125,44880,45645)),
				new(BlueC,colour('Blue',8670,38250,61710)),							
				new(BlackC,colour('Black',34935,34935,34935)),
				new(WhiteC,colour('White',65025,64770,59415)),
				new(GoldC,colour('Gold',64770,49470,1785)),
				assert(customcolor(red,RedC)),
				assert(customcolor(green,GreenC)),
				assert(customcolor(blue,BlueC)),
				assert(customcolor(black,BlackC)),
				assert(customcolor(white,WhiteC)),
				assert(customcolor(gold,GoldC)),



				new(T1,dialog()),
				
				new(T21,dialog()),
				new(T22,dialog()),
				new(T23,dialog()),
					
				new(T3,dialog()),
				new(T4,dialog()),
				new(T5,dialog()),
				
				new(T61,dialog()),
				new(T62,dialog()),
				new(T63,dialog()),
				new(T64,dialog()),


				
				new(G1,dialog_group('Deck',box)),
				
				new(G23,dialog_group('Tier 3',box)),
				new(G22,dialog_group('Tier 2',box)),
				new(G21,dialog_group('Tier 1',box)),
				
				new(G3,dialog_group('Nobles',box)),



				new(G4,dialog_group('Players',box)),
				
				new(G5,dialog_group('Tokens',box)),
				
				

				new(G61,dialog_group('P1 Reserves',box)),
				new(G62,dialog_group('P2 Reserves',box)),
				new(G63,dialog_group('P3 Reserves',box)),
				new(G64,dialog_group('P4 Reserves',box)),

				
				send(T1,append,G1),
				
				send(T23,append,G23),
				send(T22,append,G22),
				send(T21,append,G21),
				
				send(T3,append,G3),
				send(T4,append,G4),
				send(T5,append,G5),

				send(T61,append,G61),
				send(T62,append,G62),
				send(T63,append,G63),
				send(T64,append,G64),
				

				send(T23,above,T22),
				send(T22,above,T21),

				send(T1,left,T23),

				send(T3,above,T1),

				send(T4,above,T5),

				send(T61,left,T62),
				send(T62,left,T63),
				send(T63,left,T64),

				send(T1,left,T4),

				send(T1,above,T61),
				

				emptyimg(Empty),
				closedimg(Closed),


				noblenum(NobleNum),								


				forall(between(1,NobleNum,X),(new(Temp1,bitmap(Empty)),send(G3,append,Temp1,right),assert(nobledialog(X,Temp1)))),

				forall(between(1,3,X),(new(Temp2,bitmap(Closed)),send(G1,append,Temp2,below),assert(deckdialog(X,Temp2)))),				


				forall(between(1,4,X),(new(Temp3,bitmap(Empty)),send(G21,append,Temp3,right),assert(carddialog(1,X,Temp3)))),
				forall(between(1,4,X),(new(Temp4,bitmap(Empty)),send(G22,append,Temp4,right),assert(carddialog(2,X,Temp4)))),
				forall(between(1,4,X),(new(Temp5,bitmap(Empty)),send(G23,append,Temp5,right),assert(carddialog(3,X,Temp5)))),

				
				


				forall(between(1,3,X),(new(Temp6,bitmap(Empty)),send(G61,append,Temp6,right),assert(reservedialog(1,X,Temp6)))),
				forall(between(1,3,X),(new(Temp7,bitmap(Empty)),send(G62,append,Temp7,right),assert(reservedialog(2,X,Temp7)))),
				forall(between(1,3,X),(new(Temp8,bitmap(Empty)),send(G63,append,Temp8,right),assert(reservedialog(3,X,Temp8)))),
				forall(between(1,3,X),(new(Temp9,bitmap(Empty)),send(G64,append,Temp9,right),assert(reservedialog(4,X,Temp9)))),


				

				playercount(PlayerCount),
				new(T,tabular),
				send(T, border, 1),
              	send(T, cell_spacing, -1),
              	%% send(T, cell_padding, -1),
              	send(T, rules, all),

              	

              	whosturn(Player),
              	new(Text,text(Player)),              	
      			assert(whosturndialog(Text)),
              	send(T,append,Text,valign := center, rowspan := 2, halign := center),
              	
              	

              	



              	forall(between(1,PlayerCount,X),send(T,append,text(X), colspan := 5)),
              	send(T,next_row),

              	
              	
              	forall(between(1,PlayerCount,X)   ,   (playername(X,Name), new(L,text(Name)),  assert(playerdialog(X,name,L)), send(T,append,L, colspan := 5))),
				
				send(T,next_row),
				send(T,append,text('Cards')),

				forall(between(1,PlayerCount,X)   ,  (
														forall(between(1,5,Y)   ,
														  	(
															indexandcolor(Y,Color),
															customcolor(Color,ColorObject),
															

															playercardsbycolor(X,Color,Count),																																
															new(L,text(Count)),																
															assert(playerdialog(X,card,Color,L)),
															
															send(T,append,L,background := ColorObject)																			
															)
														))
				),

				send(T,next_row),
				send(T,append,text('Tokens')),

				forall(between(1,PlayerCount,X)   ,  (
											forall(between(1,5,Y)   ,  
												(
												indexandcolor(Y,Color),
												customcolor(Color,ColorObject),

												playertokensbycolor(X,Color,Count),																																
												new(L,text(Count)),																
												assert(playerdialog(X,token,Color,L)),
												send(T,append,L,background := ColorObject)																			
												)
											))
				),

				send(T,next_row),
				send(T,append,text('Power')),
				
				forall(between(1,PlayerCount,X)   ,  (
											forall(between(1,5,Y)   ,  
												(
												
												indexandcolor(Y,Color),											
												customcolor(Color,ColorObject),

												playerpower(X,Power),
												nth1(Y,Power,Value),
												new(L,text(Value)),																
												assert(playerdialog(X,power,Color,L)),
												send(T,append,L,background := ColorObject)																			
												)
											))
				),

				send(T,next_row),
				send(T,append,text('Golds')),

				forall(between(1,PlayerCount,X), (										
										playergolds(X,Golds),
										customcolor(gold,ColorObject),

										new(L,text(Golds)),
										assert(playerdialog(X,gold,L)),
										send(T,append,L,colspan := 5, background := ColorObject)
										)),

				
				send(T,next_row),

				send(T,append,text('Token #')),

				forall(between(1,PlayerCount,X), (										
										playertotaltokencount(X,Count),
										atom_concat(Count,'/10',Res),
										new(L,text(Res)),
										assert(playerdialog(X,total,L)),
										send(T,append,L,colspan := 5)
										)),

				send(T,next_row),

				send(T,append,text('Points')),

				forall(between(1,PlayerCount,X), (										
										playerpoints(X,Points),																				
										new(L,text(Points)),
										assert(playerdialog(X,point,L)),
										send(T,append,L,colspan := 5)
										)),

				send(T,next_row),

				send(T,append,text('Nobles')),

				forall(between(1,PlayerCount,X), (										
										playernobleindexes(X,NobleIndexes),
										new(L,text(NobleIndexes)),
										assert(playerdialog(X,noble,L)),
										send(T,append,L,colspan := 5)
										)),


				send(G4,append,T),


				forall(between(1,5,X), (										
										tokensonboard(Tokens),
										nth1(X,Tokens,Count),										
										new(L,text(Count)),
										indexandcolor(X,Color),
										assert(tokensonboarddialog(Color,L)),
										send(G5,append,L,right)
										)),

				remaininggolds(Gold),
				new(L,text(Gold)),
				assert(golddnumdialog(L)),
				send(G5,append,L,right),


				assert(boarddialog(T1)),



				noblenum(NN),
				forall(between(1,NN,X),(
										noblecards(N),
										getids(N,NobleIds),
										nth1(X,NobleIds,Id),
										cards(Id,ImgPath),

										nobledialog(X,BM),
										send(BM,load,ImgPath)
				)),
				

				send(T1,open).


				
				

				

destroyGUI :- 	boarddialog(B),
				free(B).







getids(CardList,IdList) :- findall(Id , (member(X,CardList),nth1(1,X,Id)), IdList).



listtoatom([] , ' ').
listtoatom([H|T],Atom) :- listtoatom(T,InnerAtom), atom_concat(H,',',Temp), atom_concat(Temp,InnerAtom,Atom).


