import os
import time
import pandas as pd


# the goal of this code is to group FullFeature_mat.csv files in a single folder for easier transfering of said files

#rootdir = '../data (17gb preprocessed full) (copy)' # the dataset with 16 features (12+4) -> for testing
rootdir = '../data' # the dataset with 58 features (54+4) -> for proper data analysis
featureMat = '_fullFeatureMatrix.csv'
rawMat = '_fullRawMatrix.csv'
subjects = [i for i in os.listdir(rootdir) if os.path.isdir(os.path.join(rootdir, i))]
N = len(subjects)

new_folder = "../full feature data 17gb-54feat"
new_folder_raw = "../full raw data 17gb-54feat"

total_time = 0
start = time.time()
for i in range(0, N):

    mat = os.path.join(os.path.join(rootdir, subjects[i]), (subjects[i] + featureMat))
    df_feat = pd.read_csv(mat, sep=',', header=None)

    if df_feat.shape[0] < 2000:
        print('[ ' + str(i + 1) + ' / ' + str(N) + '] Subject ' + str(subjects[i]) + ' skipped')
        continue

    mat_feat = os.path.join(new_folder, (subjects[i] + featureMat))
    df_feat.to_csv(mat_feat, header=None, index=False)
    print('[ ' + str(i+1) + ' / ' + str(N) + '] Subject ' + str(subjects[i]) + ' copied')

    # mat = os.path.join(os.path.join(rootdir, subjects[i]), (subjects[i] + rawMat))
    # df_raw = pd.read_csv(mat, sep=',', header=None)
    # mat_raw = os.path.join(new_folder_raw, (subjects[i] + rawMat))
    # df_raw.to_csv(mat_raw)


