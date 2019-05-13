import scipy.io as sio
import os
import matplotlib.pyplot as plt

patient = str(3000393)

files = [i for i in os.listdir('../data/'+patient+'/') if '.mat' == i[-4:]]

print(len(files))
for filename in files:
    print(filename)
    mat = sio.loadmat('../data/'+patient+'/' + filename)['val']

    f, ax = plt.subplots(2, sharex=True)

    ax[0].plot(mat[0][:])
    ax[0].set_ylabel('PLETH')
    ax[1].plot(mat[1][:])
    ax[1].set_ylabel('ABP')

    plt.show()
