#!/bin/bash

# stack seismograms at different stations
data=/gaia/home/asaxena/Desktop/LAB/01_05_2018
cd $data
# name of the station where you want to compute
sta_name=PVMO
component=RF

rm -f ${sta_name}_stack.macro 
rm -f ${sta_name}.txt

#find . -name "${sta_name}*.[BH]H${component}" -exec cp {} stacked/ \;
#rm -f *.*.HHZ *.*.HHR  # to not delete the stacked file

for d in `seq 1 8`
do
	while read -r events;
	# echo $num
	do
		find ${events} -name "${sta_name}*${component}" >> ${sta_name}_${d}.txt
	done<baz_${d}.txt
	
	while read line; do # iterate through each line
 	    printf "r ${line}\nch b 0\nwh\nq\n" | sac
	done <${sta_name}_${d}.txt
	
	echo "sss" > ${sta_name}_${d}stack.macro
	
	while read line; do # iterate through each line
        echo "addstack ${line}" >> ${sta_name}_${d}stack.macro
    done <${sta_name}_${d}.txt
    printf "timewindow 0 240\nsumstack\n" >> ${sta_name}_${d}stack.macro
    printf "writestack ${sta_name}_stack.${component}" >> ${sta_name}_${d}stack.macro
	((d++))
done;

#cd ./stacked # change headers of the all the station components

# while read line; do # iterate through each line
#   printf "r ${line}\nch b 0\nwh\nq\n" | sac
# done <${sta_name}.txt

# echo "sss" > ${sta_name}_stack.macro
# while read line; do # iterate through each line
#   echo "addstack ${line}" >> ${sta_name}_stack.macro
# done <${sta_name}.txt

# printf "timewindow 0 240\nsumstack\n" >> ${sta_name}_stack.macro
# printf "writestack ${sta_name}_stack.${component}" >> ${sta_name}_stack.macro
# sac ${sta_name}_stack.macro
