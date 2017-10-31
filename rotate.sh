#!/bin/bash
for d in ./event_00[8-9]*
do
  cd $d/temprotate_S
  # adds event information and performs rotation
#   f=`echo $d | sed 's/.\/event_//' | sed 's/^0*//'`
#   printf "r *.SAC\nch o GMT `awk 'FNR == '''$f''' {print $1, $2, $3, $4, $5, $6}' ../../preprocess.txt` \nwh\nq\n" | sac
# # put the eq. origin time into the SAC header
#   echo $f
#   printf "r *.SAC\nch evla `awk 'FNR == '''$f''' {print $7}' ../../preprocess.txt` \
# evlo `awk 'FNR == '''$f''' {print $8}' ../../preprocess.txt` evdp `awk 'FNR == '''$f''' {print $9}' ../../preprocess.txt`\nwh\nq\n" | sac
# # put the earthquake location information into the SAC header
#   saclst o f *.SAC | awk '{printf "r %s\nch allt %.5f\nwh\n",$1,$2*(-1)} END{print "quit"}' | sac
# # shift the origin time to be at 0 s
#   printf "r *.[BH]HE.SAC\nch cmpaz 90 cmpinc 90\nwh\nq\n" | sac
#   printf "r *.[BH]HN.SAC\nch cmpaz 0 cmpinc 90\nwh\n\q\n" | sac
#   printf "r *.[BH]HZ.SAC\nch cmpaz 0 cmpinc 0\nwh\n\q\n" | sac
# # put the component information into the SAC header
#   saclst e f `awk '{print $1"."$2".[BH]H[EN].SAC"}' ./stn_3c.id` |\
#   paste - - | awk '{if ($2> $4) print $4;else print $2}' > BH_EN_end_time.dat # list the end of the two horizontal component data
#   saclst b f `awk '{print $1"."$2".[BH]H[EN].SAC"}' ./stn_3c.id` |\
#   paste - - | awk '{if ($2< $4) print $4;else print $2}' > BH_EN_start_time.dat # find out the minimum of the end time and save it
#   paste -d" " stn_3c.id BH_EN_start_time.dat BH_EN_end_time.dat |\
#   awk '{print "cut "$3,$4"\ncuterr usebe\nr "$1"."$2".[BH]H[EN].SAC\nrotate to GCP\nw "$1"."$2".HHR.SAC "$1"."$2".HHT.SAC"} END {print "q"}' | sac
  #mkdir ${d}_r
  #mv *.[HB]H[EN].SAC ./${d}_r
  #cp *.[HB]HZ.SAC ./${d}_r
  saclst baz evdp f *.HHR | awk '{print $2, $3}' >> ../../baz.txt
  cd ../../
done;