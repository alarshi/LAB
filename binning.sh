#!/usr/bin/bash

data=/gaia/home/asaxena/Desktop/LAB/01_05_2018/bin_pierce_points
cd $data

num=1

for i in combined*
do
	awk 'BEGIN { FS = "," }; {print $1}' $i | sed s/HHZ/RF/ |  sed s/'\/'/'\/ReceiverTZero\/'/ | sed s/e/'..\/e'/ | sed 's/event_0082/d' > bin${num}.txt

	echo "sss" > bin${num}_stack.macro
	while read line; do # iterate through each line
  		echo "addstack ${line}" >> bin${num}_stack.macro
	done <bin${num}.txt

	printf "timewindow 0 240\nsumstack\n" >> bin${num}_stack.macro
	printf "writestack bin${num}_stack.rf\nq" >> bin${num}_stack.macro
	sac bin${num}_stack.macro

	num=$((num+1))
done;
