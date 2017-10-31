#!/bin/bash

# writes the matlab function for preprocessing used for net event from Chuck

printf 'function events_11to15\n\n' > events_11to15.m

# print information for each event
NUM=1
data=/media/sushi/Storage/LAB/preprocess/24_10_2017
cd $data
for d in event_*
do
    cd $d
    cp /media/sushi/Storage/LAB/net_event/cshells/create_directory.csh ./
    ./create_directory.csh
    printf "\tcd $d\n" >> ../../events_11to15.m
    f=`echo $d | sed 's/event_/ev/'`
    event=`sed "$((NUM))q;d" /media/sushi/Storage/LAB/preprocess/preprocess.txt`
    printf "\tprocess_event('$f', '$data/$d', 'S', -300, 60, [$event],'HH?', 'ALL')\n" >> ../../events_11to15.m
    printf "\tcd ..\n" >> ../../events_11to15.m
    NUM=$(($NUM+1))
    cd ..
done;
echo "end" >> ../events_11to15.m
