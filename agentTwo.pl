:- multifile getaction/2.

getaction(agentTwo,Action) :-	generaterandomaction(Action),log(Action),log('\n').

%, display(Action), display(' ------- Cont?\n'), read(_).


mycolor(red).
mycolor(green).
mycolor(blue).
mycolor(black).
mycolor(white).

generaterandomaction(A) :- aggregatevalidactions(All), length(All,Count), random_between(1,Count,Random), nth1(Random,All,A).


aggregatevalidactions(A) :- findactionone(A1),!, findactiontwo(A2),!, findactionthree(A3),!, findactionfour(A4),!, findactionfive(A5),!, findactionsix(A6),!,
							append([A1],[A2],T1), append([A3],[A4],T2), append([A5],[A6],T3), append(T2,T3,T23), append(T1,T23,TFin), delete(TFin,[],A).

findactionone([takethreediff,Mem1,Mem2]) :- 	
												generatetokenlist(threediff,GTake), givebackpossibleset(GGive), 
												member(Mem1,GTake), member(Mem2,GGive),
												tokenlistify(Mem1,L1), tokenlistify(Mem2,L2),
												validmove(1,L1,L2),!.
																						

												

findactiontwo([taketwosame,Mem1,Mem2]) :- 		generatetokenlist(twosame,GTake), givebackpossibleset(GGive), 
												member(Mem1,GTake), member(Mem2,GGive),
												tokenlistify(Mem1,L1), tokenlistify(Mem2,L2),
												validmove(2,L1,L2),!.												

findactionthree([taketwodiff,Mem1,Mem2]) :- 	
												generatetokenlist(twodiff,GTake), givebackpossibleset(GGive), 
												member(Mem1,GTake), member(Mem2,GGive),
												tokenlistify(Mem1,L1), tokenlistify(Mem2,L2),
												validmove(3,L1,L2),!.												

findactionfour([takeone,Mem1,Mem2]) :- 			generatetokenlist(one,GTake), givebackpossibleset(GGive), 
												member(Mem1,GTake), member(Mem2,GGive),
												tokenlistify(Mem1,L1), tokenlistify(Mem2,L2),
												validmove(4,L1,L2),!.												


findactionfive([buy,tier,TNum,Loc]) :- tiercards(TNum,List), nth1(Loc,List,Card), validmove(5,Card).
findactionfive([buy,res,Loc]) :- whosturn(Player), playerreserves(Player,Reserves), nth1(Loc,Reserves,Card), validmove(5,Card).

findactionsix([reserve,TNum,Loc,Mem]) :- 	getcardfromtier(TNum,Loc,Card), 
												givebackpossibleset(GGive),											
												member(Mem,GGive),
												tokenlistify(Mem,TokenList),
												validmove(6,Card,TokenList). 


findactionone([]).
findactiontwo([]).
findactionthree([]).
findactionfour([]).
findactionfive([]).
findactionsix([]).





generatetokenlist(three,Ss)		:- setof(S,tricolorgenerator(S),Ss).
generatetokenlist(two,Ss)		:- setof(S,bicolorgenerator(S),Ss).
generatetokenlist(one,Ss)		:- setof(S,unicolorgenerator(S),Ss).

generatetokenlist(threediff,Ss) :- setof(S,tridiffcolorgenerator(S),Ss).
generatetokenlist(twosame,Ss) 	:- setof(S,bisamecolorgenerator(S),Ss).
generatetokenlist(twodiff,Ss) 	:- setof(S,bidiffcolorgenerator(S),Ss).
generatetokenlist(one,Ss) 		:- setof(S,unicolorgenerator(S),Ss).



givebackpossibleset(Set) :- generatetokenlist(one,S1),generatetokenlist(two,S2),generatetokenlist(three,S3),append(S1,S2,Temp),append(Temp,S3,Temp2),append([[]],Temp2,Set).


tridiffcolorgenerator(Sorted)	:- mycolor(E1), mycolor(E2), mycolor(E3), E1 \= E2, E2 \= E3, E1 \= E3, sort([E1,E2,E3],Sorted).
bisamecolorgenerator([E1,E2])	:- mycolor(E1), mycolor(E2), E1 == E2.
bidiffcolorgenerator(Sorted)	:- mycolor(E1), mycolor(E2), E1 \= E2, sort([E1,E2],Sorted).
unicolorgenerator([E1])	 		:- mycolor(E1).

tricolorgenerator([E1,E2,E3]) 	:- mycolor(E1), mycolor(E2), mycolor(E3).
bicolorgenerator([E1,E2]) 	:- mycolor(E1), mycolor(E2).



setlist(A,A).


%% generatetokenlist(threediff,List) :- setof([E1,E2,E3],(mycolor(E1), mycolor(E2), mycolor(E3), E1 \= E2, E2 \= E3, E1 \= E3),List).sort([E1,E2,E3],Sorted)



%% generatetokenlist(Length,List) :- length(List,Length), forall(member(X,List),mycolor(X)).


%% doablemoves(buy,tier,List) :- .
%% doablemoves(buy,res,List).
%% doablemoves(res).

%% doablemoves(taketwosame,List) :- 
%% doablemoves(takethreediff,List).
%% doablemoves(taketwodiff,List).
%% doablemoves(takeone,List).


log(Action) :- 	open('log.txt',append,Stream),
				write(Stream,Action), nl(Stream),
				close(Stream).


