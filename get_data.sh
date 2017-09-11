#!/bin/bash
now=$(date +"%d_%m_%Y")
mkdir $now; cd $now/
wget -P . -m -nd -np -r -A event_* ftp://ftp.iris.washington.edu/pub/userdata/Arushi_Saxena/
for f in event_*
do
  mkdir "${f%%.*}";
  if [ "${f##*.}" == "seed" ]; then
    mv $f "${f%%.*}"/
    cd "${f%%.*}"/
    rdseed -df $f
    cd ..
  else 
    mv $f "${f%%.*}"/
    cd "${f%%.*}"/
    openssl enc -d -des-cbc -salt -in  $f -out "${f%%.*}.seed" -pass pass:Ihn3nLAg
    rdseed -df "${f%%.*}.seed"
    cd ..
  fi
done;
rm -rf *.seed *.ssl

