#!/usr/bin/python
'''
 make_breqfast - construct a series of text files that can be copied and
 pasted into email for IRIS breqfast requests.
  Input:
       csvfile = .csv file downloaded from earthquake search at
                  http://earthquake.usgs.gov/earthquakes/search/
  Output 
       textfile for request from Breq fast
       STA NN YYYY MM DD HH MM SS.TTTT YYYY MM DD HH MM SS.TTTT #_CH CH1 CH2 CHn LI
       STA is the station NN is the network code or "virtual network"
       YYYY is the year - 2 digit entries will be rejected!
       MM is the month DD is the day HH is the hour
       SS.TTTT is the second and ten-thousandths of seconds
       _CH is the number of channel designators in the immediately following list
       CHn is a channel designator that can contain wildcards
'''
# load some libraries
import os
import datetime
from obspy.taup import TauPyModel
from obspy.geodetics import locations2degrees
model = TauPyModel(model="iasp91")

#  Time before the P, Pdiff, or PKP arrival wanted to start traces (sec)
P_before=300.0;
#  Time after the P, Pdiff, or PKP arrival wanted (sec)
P_after=1800.0;    # 30 minutes of data

# awk to use only the required fields in the request file, here query file is in pwd and all fields are separated by space
os.system(''' awk 'BEGIN { FS = "," }/^2/{print $1 $2, $3, $4}' query.csv | sed 's/[TZ]/ /g' | \
          sed 's/:/ /g' |  awk '{gsub(/\-/," ",$1); print}' > events_info.txt ''')

#  cooridnates for the center of the region area
stalat=37.;
stalon=-90.;

f = open('events_info.txt','r')
line = f.readline()
k = 0
while line:
    event = line.split(' ')  # each event as string    
    if not event : break
    dist = locations2degrees(stalat, stalon, float(event[6]), float(event[7]))
    if dist < 85. and dist > 55.:
      k = k+1
      arrivals = model.get_travel_times(source_depth_in_km = float(event[8]), distance_in_degree=dist, phase_list=["P" , "Pdiff" , "PKP"])
      tt = arrivals[0].time  # travel time,
      evor = datetime.datetime(int(event[0]), int(event[1]), int(event[2]), int(event[3]), int(event[4]), int(float(event[5]))) # origin time
      evrec1 = evor + datetime.timedelta(0, (tt - P_before))
      evrec2 = evrec1 + datetime.timedelta(0, P_after)
      evrec1_str = evrec1.strftime("%Y %m %d %H %M %S") 
      evrec2_str = evrec2.strftime("%Y %m %d %H %M %S")
      label="event_00%s" %k  # name of the individual files
      fi = open('preprocess.txt', "a") # create file with all the relevant events
      fi.write(line)
      fi.close()
      with open(label, "w") as Event:
         Event.write('.NAME Arushi Saxena\n.INST University of Memphis\n.ADDRESS 3525 Clayphil Avenue\n.EMAIL asaxena@memphis.edu\n.PHONE 9015303960\n\
.FAX YOUR_FAX\n.MEDIA: FTP\n.ALTERNATE MEDIA: DAT\n.ALTERNATE MEDIA: DLT3\n.LABEL %s\n.QUALITY E\n.END\n' %label)  # header
         nm_string = "* NM %s.000 %s.000 1 HH?" %(evrec1_str, evrec2_str) # NM network
         zl_string = "* ZL %s.000 %s.000 1 HH?" %(evrec1_str, evrec2_str) # ZL network
         xo_string = "* XO %s.000 %s.000 1 HH?" %(evrec1_str, evrec2_str) # XO network
         ta_string1 = "[P-Q]38A TA %s.000 %s.000 1 BH?" %(evrec1_str, evrec2_str) #  TA network
         ta_string2 = "[P-W]39A TA %s.000 %s.000 1 BH?" %(evrec1_str, evrec2_str) #  TA network    
         ta_string3 = "[P-X]4[0-9]A TA %s.000 %s.000 1 BH?" %(evrec1_str, evrec2_str) #  TA network
         ta_string4 = "Y40A TA %s.000 %s.000 1 BH?" %(evrec1_str, evrec2_str) #  TA network
         Event.write("%s\n%s\n%s\n%s\n%s\n%s\n%s\n" %(nm_string, zl_string, xo_string, ta_string1, ta_string2, ta_string3, ta_string4))
      Event.close()
    line = f.readline()
