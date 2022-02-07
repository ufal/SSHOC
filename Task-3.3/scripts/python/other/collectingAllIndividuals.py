import glob, re
outfile = open("allIndividuals.txt", mode="w", encoding='UTF-8')
outfile.write('')
path = '*IndividualDramas.txt'
files=glob.glob(path)   
for file in files:     
    f=open(file, 'r')
    for line in f:
        line = re.sub('drwxr-xr-x  56 admin  staff    1792 12 May 10:11 .', '', line, re.U)
        line = re.sub('drwxr-xr-x   3 admin  staff      96 12 May 13:39 ..', '', line, re.U)
        line = re.sub('drwxr-xr-x   7 admin  staff     224 12 May 12:04 doublets', '', line, re.U)
        line = re.sub('total 37168', '', line, re.U)
        line = re.sub('total 25520', '', line, re.U)
        line = re.sub('drwxr-xr-x  121 admin  staff    3872 12 May 10:56 .', '', line, re.U)
        line = re.sub('drwxr-xr-x    4 admin  staff     128 12 May 13:39 ..', '', line, re.U)
        line = re.sub('drwxr-xr-x   5 admin  staff     160 12 May 13:39 ..', '', line, re.U)
        line = re.sub('drwxr-xr-x  58 admin  staff    1856 12 May 13:39 .', '', line, re.U)
        line = re.sub('-rwxr-xr-x@'r'\s+''1'r'\s+''admin'r'\s+''staff'r'\s+\d+\s''10 Apr 07:58 ', '', line, re.U)
        line = re.sub('-rwxr-xr-x@'r'\s+''1'r'\s+''admin'r'\s+''staff'r'\s+\d+\s''16 Apr'r'\s\d+'':'r'\d+\s+', '', line, re.U)
        line = re.sub('-rwxr-xr-x'r'\s+''1'r'\s+''admin'r'\s+''staff'r'\s+\d+\s''10 Apr 07:58 ', '', line, re.U)
        if line == '\n':
            continue
        else:
            outfile = open("allIndividuals.txt", mode="a", encoding='UTF-8')
            outfile.write(str(line))
    f.close()
