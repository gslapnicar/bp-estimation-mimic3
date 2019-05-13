import scipy.io as sio
import os

# minimum time
min_time = 600   #sec
frequency = 125  #HZ

patients = [j for j in os.listdir('../data/')]
for patient in patients:
	files = [i for i in os.listdir('../data/'+patient+'/') if '.mat' == i[-4:]]
	print(len(files))
	for filename in files:
	    mat = sio.loadmat('../data/'+patient+'/' + filename)['val']
	    #Check if its shorter than min time
	    if mat.shape[1] < min_time*frequency:
	    	print('Deleted: ' + filename)
	    	os.remove('../data/'+patient+'/' + filename)
	    	os.remove('../data/'+patient+'/' + filename[:-4]+'.hea')
	    	os.remove('../data/'+patient+'/' + filename[:-5]+'.info')