#!/bin/bash
# model tests with thickness between 10 to 40 km

mkdir thickness_models_15
cd thickness_models_15

val=25
i=5
j=5
k=5

for k in `seq 5 5 20`
do
	for j in `seq 5 5 40`
	do
		for i in `seq 5 5 40`
		do
			awk 'BEGIN {OFS="\t"} {if (NR==15) gsub("10.0", "'${i}'",$4); if (NR==17) gsub("20.0", "'${j}'",$4); if (NR==16) gsub("20.0", "'${k}'",$4); print $0 }' ../thickness_test.dat > model_thick_${i}_${j}_${k}.dat
		../../../cshells/runqhask_g 0.1 5.0 5.0 0.0 model_thick_${i}_${j}_${k}.dat gf"${i}"_"${j}"_"${k}" 1 0 1 
		done;
	done;
done;
		     
