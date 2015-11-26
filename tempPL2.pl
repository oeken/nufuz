parent(demir,onur).
parent(mustafa,demir).
crazy(persik).

male(demir).
male(mustafa).
male(onur).

father(X,Y) :- male(X) , parent(X,Y).

grandfather(X,Y) :- father(X,Z) , parent(Z,Y).

reverse([],[]).
reverse([H|T],Y) :- reverse(T,ReversedT), append(ReversedT,[H],Y).

rule(1,ruleone(a,b,c)).
rule(1,ruletwo(1,2,4)).


