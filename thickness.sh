#!/bin/bash
# model tests with thickness between 10 to 40 km

mkdir thickness_tests
cd thickness_tests

val=25
i=5
j=5

for i in `seq 5 2 35`
do
	for j in `seq 5 2 35`
	do
		awk 'BEGIN {OFS="\t"} {if (NR==22) gsub("4.0", "'${i}'",$4); if (NR==26) gsub("4.0", "'${j}'",$4); print $0 }' ../thickness_test.dat > model_thick.dat
		../../../cshells/runqhask_g 0.1 1.0 5.0 0.0 model_thick.dat gf"${i}""${j}" 1 0 1 
	done;
done;
		     
