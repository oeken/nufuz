
makeList(0,_,[]).
makeList(Length,Value,List) :- 	NewLength is Length-1,
								makeList(NewLength,Value,InnerList),
								append([Value],InnerList,List).


third([_,_,Elem|_],Elem).


twolistsum([],[],[]).
twolistsum([H1|T1],[H2|T2],[H3|T3]) :- H3 is H1+H2,
									twolistsum(T1,T2,T3).



listmpy([],_,[]).
listmpy([H|T],Factor, [RH|RT]) :- RH is H*Factor, listmpy(T,Factor,RT).



listsum([H|[]],H) :- !.
listsum([H|T],Result) :-  listsum(T,InnerResult), twolistsum(H,InnerResult, Result).





pair(1,1).
pair(1,2).
pair(2,2).
pair(3,3).
pair(4,4).
pair(5,5).




sublist(Start,Start,List,[Elem]) :- nth1(Start,List,Elem),!.
sublist(Start,End,List,Sublist) :- 	nth1(Start,List,Elem1),
									NewStart is Start+1,
									sublist(NewStart,End,List,InnerSublist),
									append([Elem1],InnerSublist,Sublist).


eliminatenegatives([],[]).
eliminatenegatives([H|T],[HNew|TNew]) :- 	((H < 0)
									->	(HNew is 0);
										HNew is H),
										eliminatenegatives(T,TNew).



containsnegativeelement([]) :- false.
containsnegativeelement([H|T]) :- H < 0 ; containsnegativeelement(T).


occurrence(_,[],0).
occurrence(Value,[Value|T],Count) :- occurrence(Value,T,InnerCount) , Count is InnerCount+1.
occurrence(Value,[H|T],Count) :- Value \= H , occurrence(Value,T,Count).




%% occurrence(Value,[H|T],Count) :-	(H == Value)
%% 								->	(occurrence(Value,T,InnerCount),Count is InnerCount+1);
%% 									(occurrence(Value,T,InnerCount),Count is InnerCount).







