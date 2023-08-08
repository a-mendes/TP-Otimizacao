set I := {1..3}; # Semanas do projeto
set J := {1..3}; # Áreas de Trabalho
set K := {1..6}; #Turnos
set K1 := {1..6}; #Turnos Regulares (Seg-Sex)
set K2 := {1..2}; #Turnos de Sábado
set L := {1..5}; #Trabalhadores 

param lam {K, J};
param tau {K, J};
param Hmax {L};
param C {L, J};
param Pw;
param bigM;

var X{I, J, K, L}, binary;
var Y{I, J, K, L}, integer, >= 0;
var F_plus{L, I}, integer, >= 0;
var F_min{L, I}, integer, >= 0; 


#maximize lucro: (sum {f in F, c in C} X[f, c] * LC[c]) - (sum{f in F} CF[f] * Y[f]);

minimize z: (sum{l in L} sum{i in I} F_min[l, i] subject to (sum{l in L} sum{i in I} F_plus[l, i] <= epsilon; 