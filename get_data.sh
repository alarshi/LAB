#!/bin/bash
now=$(date +"%m_%d_%Y")
mkdir $now; cd $now/
wget -P . -m -nd -np -r -A event_* ftp://ftp.iris.washington.edu/pub/userdata/Arushi_Saxena/
for f in event_*
do
  if [ "${f##*.}" == "seed" ]; then
    rdseed -df $f
  else 
    openssl enc -d -des-cbc -salt -in  $f -out "${f%%.*}.seed" -pass pass:Ihn3nLAg
    rdseed -df "${f%%.*}.seed"
  fi
done;
