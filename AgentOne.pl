:- multifile getaction/2.

getaction(agentOne,Action) :-	display('what do we do?\n'),
								read(Action),
								log(Action),
								log('\n').


log(Action) :- 	open('log.txt',append,Stream),
				write(Stream,Action), nl(Stream),
				close(Stream).


