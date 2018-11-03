#!/bin/bash

data=/media/warg/Storage/LAB/preprocess/01_11_2018
cd $data
for d in event_00[1-9][0-9][0-9]
do
  f=${d:7}
  echo event_$f
  mv $d event_$f
done;