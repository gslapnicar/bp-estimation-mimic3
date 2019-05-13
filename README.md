# bp-estimation-mimic3
Crucial pieces of code for the BP estimation using MIMIC III database. Paper submitted to Sensors journal.

### DataMiner.sh
This script is used to continuously download the data of the MIMIC III database, available at https://physionet.org/physiobank/database/mimic3wdb/.

### DataCleaner.sh
This script is used to delete empty and very small files.

### organize_patients.py
This script puts all recording sessions of a given patient into a PATIENT_ID/ directory, for all downloaded files.
