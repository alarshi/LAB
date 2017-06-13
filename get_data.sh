#!/bin/bash
now=$(date +"%m_%d_%Y")
mkdir $now; cd $now/
wget -P . -m -nd -np -r -A event_* ftp://ftp.iris.washington.edu/pub/userdata/Arushi_Saxena/
for f in event_*
do
  rdseed -df $f 
done;
