% declare the range possible locations
options(a,b,c,d).

% associate each chest with a claim
claim(a,claima).
claim(b,claimb).
claim(c,claimc).
claim(d,claimd).

% declare content of each claim
sayshasgold(claima,a,true).
sayshasgold(claimd,d,true).
saysdisjhasgold(claimb,a,d).
sayshasgold(claimc,c,false).

% any one of the full range of possible locations is itself a possible location
option(A):-options(A,B,C,D).
option(B):-options(A,B,C,D).
option(C):-options(A,B,C,D).
option(D):-options(A,B,C,D).

% declare semantics for sayshasgold, hasgold, and true
true(Claim) :- sayshasgold(Claim,Place,true),hasgold(Place).
true(Claim) :- sayshasgold(Claim,Place,false),-hasgold(Place).
-true(Claim) :- sayshasgold(Claim,Place,true),-hasgold(Place).
-true(Claim) :- sayshasgold(Claim,Place,false),hasgold(Place).

hasgold(Place) :- sayshasgold(Claim,Place,true),true(Claim).
-hasgold(Place) :- sayshasgold(Claim,Place,false),true(Claim).
-hasgold(Place) :- sayshasgold(Claim,Place,true),-true(Claim).
hasgold(Place) :- sayshasgold(Claim,Place,false),-true(Claim).

% extend semantics to cover saysdisjhasgold
hasgold(Place1);hasgold(Place2) :- saysdisjhasgold(Claim,Place1,Place2),true(Claim).
true(Claim) :- saysdisjhasgold(Claim,Place1,Place2), hasgold(Place1).
saysdisjhasgold(Claim,Place2,Place1) :- saysdisjhasgold(Claim,Place1,Place2).
-true(Claim) :- saysdisjhasgold(Claim,Place1,Place2),-hasgold(Place1),-hasgold(Place2).

%at least one chest has the gold
hasgold(A);hasgold(B);hasgold(C);hasgold(D) :- options(A,B,C,D).

%at least one claim is true
true(A1);true(B1);true(C1),true(D1) :- options(A,B,C,D),claim(A,A1),claim(B,B1),
  claim(C,C1),claim(D,D1).

%at most one claim is true
 -true(B) :- true(A),claim(A1,A),claim(B1,B),A!=B,A1!=B1.

%at most one chest has the gold
-hasgold(B) :- hasgold(A),option(A),option(B),A!=B.
