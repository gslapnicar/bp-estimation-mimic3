# bp-estimation-mimic3
Crucial pieces of code for the BP estimation using MIMIC III database. Paper submitted to Sensors journal.

**IMPORTANT**: this code is not production-ready, but experimental and currently in active development. Bugs might be present and robustness was not a top priority. It was written using bash, python 3 and MATLAB 2018a.

### DataMiner.sh
This script is used to continuously download the data of the MIMIC III database, available at https://physionet.org/physiobank/database/mimic3wdb/.

### DataCleaner.sh
This script is used to delete empty and very small files.

### organize_patients.py
This script puts all recording sessions of a given patient into a PATIENT_ID/ directory, for all downloaded files.

### [optional] delete_short_extra.py
This script removes all files with duration under a set threshold.

### cleaning_scripts
MATLAB scripts used for cleaning the data and removing anomalies. Entrypoint is main.m. Modify accordingly (paths, thresholds, etc.).

### models.py
Keras (tensorflow backend) definitions of deep-learning models used in experiments.
