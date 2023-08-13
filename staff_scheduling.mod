#Sets
set I := {1..15}; # Semanas do projeto	
set J := {1..4}; # Áreas de Trabalho
set K := {1..3}; #Turnos
set K1 := {1..2}; #Turnos Regulares (Seg-Sex)
set K2 := {3}; #Turnos de Sábado
set L := {1..20}; #Trabalhadores 

#Parametros
param lam {K, J};					#Horas semanais maximas
param tau {K, J};					#Horas semanais minimas
param Hmax {L};						#Carga horaria maxima
param C {L, J};						#Especialidade
param Pw;							#Qtd de semanas
param bigM;

#Variaveis de decisão
var X{I, J, K, L}, binary;			#Binaria se o trabalhador for designado
var Y{I, J, K, L}, integer, >= 0;	#Numero de horas 
var F_plus{L, I}, integer, >= 0;	#Numero de horas extras
var F_min{L, I}, integer, >= 0; 	#Numero de horas nao trabalhadas

#Funções Objetivas
minimize FO: 0.47 * (sum{l in L, i in I}  F_min[l, i]) + 0.53 * (sum{l in L, i in I} F_plus[l, i]); 


#Conjunto de Restrições
#3
alocacao_trabalhador{i in I, l in L}: sum{j in J, k in K1} X[i, j, k, l] <= 1; 

#4
alocacao_trabalhador_especialidade {i in I, j in J, k in K, l in L}: X[i, j, k, l] <= C[l, j];

#5
horas_caso_trabalhe{i in I, j in J, k in K, l in L}: Y[i, j, k, l] <= X[i, j, k, l] * bigM;

#6
carga_horaria_max{i in I, j in J, k in K, l in L}: Y[i, j, k, l] <= (lam[k, j] * X[i, j, k, l]) + F_plus[l, i];

#7
minimo_horas_produtividade{i in I, j in J, k in K}: sum{l in L} Y[i, j, k, l] >= tau[k, j];

#8
horas_contrato{i in I, l in L}: (sum{j in J, k in K} Y[i, j, k, l]) + F_min[l, i] - F_plus[l, i] == Hmax[l];

#9
mesma_area_semana_seguinte{h in I, j in J, l in L: h < Pw and h mod 2 == 1}: sum{k in K1} X[h, j, k, l] == sum{k in K1} X[h+1, j, k, l];

#10 problemas aqui!!
maximo_area_turno{l in L, k in {1, 2}, h in I: h < Pw and h mod 2 == 1}: sum{j in J}(X[h, j, k, l] + X[h+1, j, k , l]) <= 1;

#11
turno_sabado{l in L, j in J, i in I, m in K2, n in K1}: X[i, j, m, l] <= X[i, j, n, l];

#12
areas_proibidas_sabado{i in I, j in {2, 3, 4}, l in L, m in K2}: X[i, j, m, l] == 0;

solve;
data;

param lam:		1	2	3	4 :=
			1	30	30	30	30
			2	40	40	40	40
			3	30	0	0	0;

param tau:		1	2	3	4 :=
			1	20	20	20	20
			2	30	30	30	30
			3	20	0	0	0;

#25% - 30hrs semanais
#75% - 40hrs semanais
param Hmax := 	1 30
				2 30
				3 30
				4 30
				5 30
				6 30
				7 40
				8 40
				9 40
				10 40
				11 40
				12 40
				13 40
				14 40
				15 40
				16 40
				17 40
				18 40
				19 40
				20 40;

param C: 	1	2	3	4 :=
		1	0	0	0	1
		2	0	0	1	0
		3	0	0	1	1
		4	0	1	0	0
		5	0	1	0	1
		6	0	1	1	0
		7	0	1	1	1
		8	1	0	0	0
		9	1	0	0	1
		10	1	0	1	0
		11	1	0	1	1
		12	1	1	0	0
		13	1	1	0	1
		14	1	1	1	0
		15	1	1	1	1
		16	0	1	1	1
		17	0	0	1	0
		18	1	0	1	0
		19	0	1	1	0
		20	1	0	0	1;

param Pw := 15;

param bigM := 999999;

end;