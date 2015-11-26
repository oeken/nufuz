:- use_module(library(tabular)).
:- use_module(library(autowin)).


%% basepath(cardslow,'./frame-resources/images/allcards_low/').
basepath(cards,'./frame-resources/img_processed/cards/').
basepath(tokens,'./frame-resources/img_processed/gems/').

concat_threeway(A1,A2,A3,Result) :- atom_concat(A2,A3,Temp), atom_concat(A1,Temp,Result).

tokens(TokenName,Path) :- basepath(tokens,Base), concat_threeway(Base,TokenName,'.jpg',Path).
cards(CardID, Path) :- basepath(cards,Base), concat_threeway(Base,CardID,'.jpg',Path).
emptyimg(Path) :- basepath(cards,Base), concat_threeway(Base,'empty','.jpg',Path).
closedimg(Path) :- basepath(cards,Base), concat_threeway(Base,'closed','.jpg',Path).

some(here).

tokenlistfy([],[0,0,0,0,0]).
tokenlistfy([H|T],List) :- colorandlist(H,L1), tokenlistfy(T,L2), twolistsum(L1,L2,List).

make_table :-
              new(D,dialog()),

              closedimg(Closed),
              new(Bm,bitmap(Closed)),
              send(Bm,transparent,no),

              send(D,append,Bm),

              send(D,open).







              %% new(BM,bitmap('./frame-resources/img_processed/cards/empty.jpg')),
              %% new(D,dialog()),
              %% new(G,dialog_group()),
              %% send(D,append,G),
              %% send(G,append,BM),
              %% send(D,open).






              %% new(D,dialog()),
              %% new(T,tabular),
              %% some(S),
              %% new(Text,text(S)),
              %% send(T,append, Text, rowspan:=2),
              %% send(D,append,T),
              %% send(D,open).
              %% new(P, auto_sized_picture('Table with merged cells')),
              %% send(P, display, new(T, tabular)),
              %% send(T, border, 1),
              %% send(T, cell_spacing, 5),
              %% send(T, rules, all),
              %% send_list(T,
              %%             [
              %%             append(new(graphical), rowspan := 2),
              %%             append('Length/mm', bold, center, colspan := 3),
              %%             next_row,
              %%             append('body', bold, center),
              %%             append('tail', bold, center),
              %%             append('ears', bold, center),
              %%             next_row,
              %%             append('males', bold),
              %%             append('31.4'),
              %%             append('23.7'),
              %%             append('3.8'),
              %%             next_row,
              %%             append('females', bold),
              %%             append('29.6'),
              %%             append('20.8'),
              %%             append('3.4')
                          
              %%             ]),
              %%             send(T,next_row),
              %%             new(B,box(20,20)),
              %%             send(B,colour(red)),
              %%             append(T,B),
                          

                          
              %% send(P, open).