#!/bin/bash

dir_name=../P_SV_receivers

for i in $dir_name/bin*_stack.macro
do
#    j=${i:0:-9}".txt"
#    echo $j
#    head -n -4 $i | tail -n +2 > $j 
    
    temp=$i"_temp"
    cp $i $temp
    
    head -n -4 $i | tail -n +2 > $temp

    N=`wc -l $temp | awk '{print int( $1*0.2 )}'`
    num=`wc -l $temp | awk '{print $1}'`
    
    # bootstrapping
    for j in {1..20}
    do
       echo $j
    # names of the new files which will be randomly stacked
       name=${i:18:-6}_$j".txt" 
       cp $temp $name
       for k in $( seq 1 $N )
       do
           sed -i $((1+RANDOM%$num))d $name
       done;
       shuf -n $N $temp >> $name
       
    done; 

rm -f $temp
done;

