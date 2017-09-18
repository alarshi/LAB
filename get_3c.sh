#!/bin/bash

for d in ./event_*
do
  cd $d
  # find the station name which has three seismograms (three components)
  ls *.SAC | awk -F"." '{print $7,$8}' | sort | uniq -c | awk '{if ($1 % 3 = 0 ) print $2,$3}' | sort | uniq > stn_3c.id
  # change the names of the files 
  ls `awk '{print "*"$1"."$2".*SAC"}' stn_3c.id` | awk -F"." '{print "mv "$0,$7"."$8"."$10"."$12}' | sh
  cd ..
done;
