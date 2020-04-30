
import glob, os


inDirs = glob.glob('/project/arjunrajlab/memSeqASEanalysis/repo/WM989/raw/*')

for i in inDirs:
	fileToDelete = glob.glob('{}/*.fastq'.format(i))
	os.remove(fileToDelete[0])

