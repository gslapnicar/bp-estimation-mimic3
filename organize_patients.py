import os
import subprocess

INPUT_FOLDER = 'data'
OUTPUT_FOLDER = 'out'

def print_progress(i, n):
	a = int(20 * i/n)
	print('\r[' + '='*a + '>' + ' '*(20-a) + '] {:.1f}% '.format(100*i/n), end='')

print('Started')
files = os.listdir(INPUT_FOLDER)
print('{:d} files to move.'.format(len(files)))

os.makedirs(OUTPUT_FOLDER, exist_ok=True)

patients = set(i[:7] for i in files)
n = len(patients)
print('{:d} patients in total'.format(n))

for i, patient in enumerate(patients):
	try:
		os.makedirs(os.path.join('out', patient), exist_ok=True)
		command = 'cp {0}/{2}* {1}/{2}/'.format(INPUT_FOLDER, OUTPUT_FOLDER, patient)
		os.popen(command)
	except KeyboardInterrupt:
		print('\nInterrupted by user')
		break
	print_progress(i, n)

print('Finished')