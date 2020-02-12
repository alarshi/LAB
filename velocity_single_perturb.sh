#!/bin/bash
# model tests with thickness between 10 to 40 km

mkdir velocity_models_i
cd velocity_models_i

val=25
m=2

for j in `seq 4.312 -0.044 3.96`
do	
	vpii=$(expr 1.75*${j} | bc)
		
	echo $vpii
	awk 'BEGIN {OFS="\t"} {if (NR==21) gsub("4.25", "'${j}'",$2) gsub("7.4375", "'${vpii}'",$1); print $0 }' ../chen_velocity_models.dat > velocity_model_${m}.dat
		../../../cshells/runqhask_g 0.011 5.0 5.0 0.0 velocity_model_${m}.dat gf_"${m}" 1 0 1 
	m=$(( $m + 1))
done;
		     
