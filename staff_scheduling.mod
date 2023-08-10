#Sets
set I := {1..3}; # Semanas do projeto	
set J := {1..3}; # Áreas de Trabalho
set K := {1..6}; #Turnos
set K1 := {1..6}; #Turnos Regulares (Seg-Sex)
set K2 := {1..2}; #Turnos de Sábado
set L := {1..5}; #Trabalhadores 

#Parametros
param lam {K, J};					#Horas semanais maximas
param tau {K, J};					#Horas semanais minimas
param Hmax {L};						#Carga horaria maxima
param C {L, J};						#Especialidade
param Pw;							#Qtd de semanas
param bigM;
param epsilon; 

#Variaveis de decisão
var X{I, J, K, L}, binary;			#Binaria se o trabalhador for designado
var Y{I, J, K, L}, integer, >= 0;	#Numero de horas 
var F_plus{L, I}, integer, >= 0;	#Numero de horas extras
var F_min{L, I}, integer, >= 0; 	#Numero de horas nao trabalhadas

#Funções Objetivas
minimize FO1: sum{l in L, i in I}  F_min[l, i];

FO2: sum{l in L, i in I} F_plus[l, i] <= epsilon; 


#Conjunto de Restrições
#3
alocacao_trabalhador{i in I, l in L}: sum{j in J, k in K1} X[i, j, k, l] <= 1; 

#4
alocacao_trabalhador_especialidade {i in I, j in J, k in K, l in L}: X[i, j, k, l] <= C[l, j] * bigM;

#5
horas_caso_trabalhe{i in I, j in J, k in K, l in L}: Y[i, j, k, l] <= X[i, j, k, l] * bigM;

#6
carga_horaria_max{i in I, j in J, k in K, l in L}: Y[i, j, k, l] <= (lam[k, j] * X[i, j, k, l]) + F_plus[l, i];

#7
minimo_horas_produtividade{i in I, j in J, k in K}: sum{l in L} Y[i, j, k, l] >= tau[k, j];

#8
horas_contrato{i in I, l in L}: (sum{j in J, k in K} Y[i, j, k, l]) + F_min[l, i] - F_plus[l, i] == Hmax[l];

#9
mesma_area_semana_seguinte{h in I, j in J, l in L: h < Pw}: sum{k in K1} X[h, j, k, l] == sum{k in K1} X[h+1, j, k, l];

#10
maximo_area_turno{l in L, k in {1, 2}, h in I: h < h*h}: sum{j in J}(X[h, j, k, l] + X[h+1, j, k , l]) <= 1;

#11
turno_sabado{l in L, j in J, i in I, m in K2, n in K1}: X[i, j, m, l] <= X[i, j, n, l];

#12
areas_proibidas_sabado{i in I, j in {2, 3, 4}, l in L, m in K2}: X[i, j, m, l] == 0;

#solve;
#data;
