#!/bin/bash

for d in ./event_00*
do
  cd $d
  # find the station name which has three seismograms (three components)
  ls *.SAC | awk -F"." '{print $7,$8}' | sort | uniq -c | awk '{if ($1 / 3 != 1 ) print $2,$3}' > stn_3c.id
  # change the names of the files 
  awk '{print "*"$1"."$2".*SAC"}' stn_3c.id | awk '{print "mv " $0 " history"}' | sh 
  cd ..
done;
