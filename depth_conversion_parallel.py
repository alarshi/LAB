
# coding: utf-8

# In[6]:


#!/usr/bin/python
from obspy.taup import TauPyModel
import obspy
import numpy as np
from obspy.taup.tau_model import TauModel
from multiprocessing import Pool
import time


# In[2]:


# first coordinate distance and second event depth
source_info = np.loadtxt("receiv_source_coordinates.txt", usecols=(1, 2, 3, 4, 5));
file_info = np.loadtxt("receiv_source_coordinates.txt", usecols=(0,), dtype='str') #,dtype='str') 
# obspy.taup.taup_create.build_taup_model('synthetic.tvel', output_folder='.')
# model = TauPyModel(model="iasp91") # using iasp as in cecilias


# In[3]:


model = TauPyModel(model="iasp91") 


# In[15]:


workers = 24
chunk = 500
file_name = []
time_diff = []
f = len(source_info[:,0])
discon= range(11, 301)

def calculate_depths(i):
#start = time.time()
     
    lhs = np.ones(( len(discon),))
    model = TauPyModel(model="iasp91") 
#for i in range(f):
    for j in range(len(discon)):
        phase = 'S'+ str(discon[j]) + 'p'
        arrivals = model.get_ray_paths(source_depth_in_km=source_info[i,1],                                    distance_in_degree=source_info[i,0] ,                                    phase_list=[phase])

        piercing_points = model.get_pierce_points(source_depth_in_km=source_info[i,1],                                    distance_in_degree=source_info[i,0] ,                                    phase_list=[phase])

        piercing_points_S = model.get_pierce_points(source_depth_in_km=source_info[i,1],                                    distance_in_degree=source_info[i,0] ,                                    phase_list=['S'])

        if piercing_points:  
            t_sp = piercing_points[0].pierce[-1][1]
            t_s = piercing_points_S[0].pierce[-1][1]
            lhs[j] = t_s - t_sp  
            file_name = file_info[i]
    return (lhs, file_name)

#end = time.time()

files = [x for x in range(1, f)]

start = time.time()

with Pool(workers) as p:
    time_diff = ((p.map(calculate_depths, files, chunksize=500)))

end = time.time()

np.savetxt("depth_points.txt", np.column_stack((time_diff)), fmt="%s" )            
#             print (piercing_points_S[0].pierce)
# piercing_points is from Arrival class, with  data values 
# as dtype([('p', '<f8'), ('time', '<f8'), ('dist', '<f8'), ('depth', '<f8')]
# p is in seconds/radians, time is in seconds, dist: purist distance in radians


# In[16]:


