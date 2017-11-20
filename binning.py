#!/usr/bin/python

'''
Creates the azimuth depth polar plot after downloading the data.
 Input - Header from the North component of the data downloaded 
 Ouput - Rose diagram of depth and azimuth.
'''

# load useful libraries
import numpy as np
import matplotlib.pyplot as plt
from windrose import WindroseAxes

data = np.genfromtxt('./24_10_2017/baz.txt') # complete data set

ra  = [x/180.0*3.141593 for x in data[:,0]]

u = np.unique(data[:,1]) # to get number of the events
print(len(u))

fig = plt.figure()
ax = fig.add_axes([0.1,0.1,0.8,0.8],polar=True)
ax.set_ylim(min(data[:,1]), max(data[:,1]))
ax.set_yticks(np.arange(0,600,100))
ax.set_xticklabels(['N', '', 'W', '', 'S', '', 'E', ''])
ax.set_yticklabels(['0 km', ' ', ' ', '300 km', ' ', ' 500 km' ])
ax.tick_params(labelsize=20	)

ax.scatter(ra, data[:,1], c ='r', s=60)
plt.show()
