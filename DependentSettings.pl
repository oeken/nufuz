%:- module(dependentSettings, [tokencount/2 , noblecount/2]).

% Game rules for different number of players
tokencount(2,4).
tokencount(3,5).
tokencount(4,7).

noblecount(2,3).
noblecount(3,4).
noblecount(4,5).