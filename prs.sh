#!/bin/bash

# create record section for all processed events

data=/media/sushi/Storage/LAB/preprocess/24_10_2017
cd $data
for d in event_*
do
  cd $d/temprotate_S
  sac ../../../prs_macro.sac
  cd ../../
done;
