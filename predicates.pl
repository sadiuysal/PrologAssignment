%        KNOWLEDGE BASE 

team(realmadrid, madrid).
team(juventus, torino).
team(galatasaray, istanbul).
team(kobenhavn, copenhagen).
team(manutd, manchester).
team(realsociedad, sansebastian).
team(shaktard, donetsk).
team(bleverkusen, leverkusen).
team(omarseille, marseille).
team(arsenal, london).
team(fcnapoli, napoli).
team(bdortmund, dortmund).

match(1, galatasaray, 1, realmadrid, 6).
match(1, kobenhavn, 1, juventus, 1).
match(1, manutd, 4, leverkusen, 2).
match(1, realsociedad, 0, shaktard, 2).
match(1, omarseille, 1, arsenal, 2).
match(1, fcnapoli, 2, bdortmund, 1).

match(2, juventus, 2, galatasaray, 2).
match(2, realmadrid, 4, kobenhavn, 0).
match(2, shaktard, 2, manutd, 3).
match(2, bleverkusen, 1, realsociedad, 1).
match(2, bdortmund, 3, omarseille, 0).
match(2, arsenal, 2, fcnapoli, 0).

match(3, galatasaray, 3, kobenhavn, 1).
match(3, realmadrid, 2, juventus, 1).
match(3, manutd, 1, realsociedad, 0).
match(3, bleverkusen, 4, shaktard, 0).
match(3, omarseille, 1, fcnapoli, 2).
match(3, arsenal, 1, bdortmund, 2).

match(4, kobenhavn, 1, galatasaray, 0).
match(4, juventus, 2, realmadrid, 2).
match(4, bleverkusen, 0, manutd, 5).
match(4, shaktard, 4, realsociedad, 0).
match(4, fcnapoli, 4, omarseille, 2).
match(4, bdortmund, 0, arsenal, 1).

match(5, realmadrid, 4, galatasaray, 1).
match(5, juventus, 3, kobenhavn, 1).
match(5, realsociedad, 0, manutd, 0).
match(5, shaktard, 0, bleverkusen, 0).
match(5, bdortmund, 3, fcnapoli, 1).
match(5, arsenal, 2, omarseille, 0).

match(6, galatasaray, 1, juventus, 0).
match(6, kobenhavn, 0, realmadrid, 2).
match(6, manutd, 1, shaktard, 0).
match(6, realsociedad, 2, bleverkusen, 0).
match(6, omarseille, 1, bdortmund, 2).
match(6, fcnapoli, 2, arsenal, 0).



allTeams(L,N):-
findall(X,team(X,_),L0),/* for team list*/
permutation(L0,L),    /* for permutation of lists*/
length(L0,N).  

wins(T,W,L,N):- 
winsW(T,W,L),  /* recursive predicate to find wins*/
length(L,N). /* finds length of wins */

winsW(T,W,L):-
sth(W),
findall(X,someLogic(X,T,W),L1),/*Team is home? */
findall(X,someLogic2(X,T,W),L2),/* Team is away*/
append(L1,L2,L3),/*finds win for that week if it exist */
decr(W,W1), /* decrement week*/
winsW(T,W1,L4),/* look for previous week*/
append(L3,L4,L). /* append recursively week's wins */

winsW(T,0,[]).  /*  breakpoint*/

losses(T,W,L,N):-    /* same structure for losses*/
lossesW(T,W,L),
length(L,N).

lossesW(T,W,L):-
sth(W),
findall(X,someLogic(T,X,W),L1),
findall(X,someLogic2(T,X,W),L2),
append(L1,L2,L3),
decr(W,W1),
lossesW(T,W1,L4),
append(L3,L4,L).

lossesW(T,0,[]).

draws(T,W,L,N):-   /* same structure for draws*/
drawsW(T,W,L),
length(L,N).

drawsW(T,W,L):-
sth(W),
findall(X,someLogic3(X,T,W),L1),
findall(X,someLogic3(T,X,W),L2),
append(L1,L2,L3),
decr(W,W1),
drawsW(T,W1,L4),
append(L3,L4,L).

drawsW(T,0,[]).

someLogic(X,T,W):-   /*  finds home team's wins or losses*/
match(W,T,S1,X,S2),
S1>S2.
someLogic2(X,T,W):-   /* finds away team's wins or losses */
match(W,X,S1,T,S2),
S1<S2.
someLogic3(X,T,W):-   /* finds away or home team's draws */
match(W,X,S1,T,S2),
S1=S2.

scored(T,W,S):-   
scoredW(T,W,S0),  /*recursively finds scored goals */
sum_list(S0,S).    /* sums scores */

conceded(T,W,C):-  
concededW(T,W,C0),   /*same structure to find conceded goals */
sum_list(C0,C).

scoredW(T,W0,S0):-   
sth(W0),    /* condition for week>0*/
findall(X,someLogic4(X,T,W0),S1),  /* team is home?*/
findall(X,someLogic5(X,T,W0),S2),  /* team is away?*/
append(S1,S2,S3),  /* append scores whether team is away or home*/
decr(W0,W1),  /* decrement week*/
scoredW(T,W1,S4),  /*recursively find scores of previous weeks */
append(S3,S4,S0).  /* append scores list*/

scoredW(T,0,[]).   /* breakpoint*/

concededW(T,W0,C0):-     /*same structure to find conceded goals */
sth(W0),
findall(X,someLogic6(X,T,W0),C1),
findall(X,someLogic7(X,T,W0),C2),
append(C1,C2,C3),
decr(W0,W1),
concededW(T,W1,C4),
append(C3,C4,C0).
concededW(T,0,[]).

someLogic4(X,T,W):-    /*get away teams scores */
match(W,_,_,T,X).
someLogic5(X,T,W):-   /*get home teams scores */
match(W,T,X,_,_).
someLogic6(X,T,W):-     /*get away teams conceded scores */
match(W,_,X,T,_).     
someLogic7(X,T,W):-    /*get home teams conceded scores */
match(W,T,_,_,X).
decr(X,NX) :-       /* decrement X*/
    NX is X-1 . 
sth(X):-          /* check X>0 or not*/  
X>0.

average(T,W,A):-   /*  scored goals-conceded goals*/
scored(T,W,S),
conceded(T,W,C),
A is (S-C).

order(L,W):-    
setof([X,Y],someLogic8(X,W,Y),Z),  /*finds some [Team,Average]   */
reverse(Z,Z1),    /* to order list */
findall(X,member([_,X], Z1),L).  /*get ordered list of teams*/

topThree(L,W):-    /* first three element of ordered list*/
order(L0,W),
take(L0,3,L).

take(Src,N,L) :- findall(E, (nth1(I,Src,E), I =< N), L).   /*to take first N element of list*/

someLogic8(X,W,Y):-   /* to gather [Team,Average] lists*/
team(Y,_),
average(Y,W,A),
X is A.



 


	



























