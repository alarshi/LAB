#!/usr/bin/env bash

# get unique receiver stations latitude and longitude

data=/gaia/home/asaxena/Desktop/LAB/01_05_2018

cd $data

# ls */ReceiverTZero > receiver_coord.txt
awk '$0 ~ /^[A-Z]/' receiver_coord.txt | sort | awk 'BEGIN {FS="."} $1!=prev && NR>1 {print $0}; {prev=$1}' > all_receivers.txt
touch receiv_coordinates.txt # overwrite the file with all receiver names

while IFS="." read -r sta net chl event rf;
do
	event_number=`echo "${event}" | sed s/ev//`
	# echo ${event_number}
	f_name=event_"${event_number}"/ReceiverTZero/"${sta}.${net}.${chl}.${event}.${rf}"
	printf "${sta} `saclst stla stlo f "${f_name}" | awk '{print $2, $3}'` " >> receiv_coordinates.txt
done < all_receivers.txt