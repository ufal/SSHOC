import os,glob,re

__author__ = 'michaeldahnke'

## Open external file in which respective xml code shall be stored and erase possible already existing content.
outfile = open('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/collectingContentsOfBulkOfFiles.txt', mode="w", encoding='UTF-8')
outfile.write(str(''))
outfile.close()

## Goes to respective directory with xml files inside and assign content to variable ›folder_path‹.
folder_path = '/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/txt'

## Read content of each file, 1 after another.
for filename in glob.glob(os.path.join(folder_path, '*.txt')):
  with open(filename, 'r') as f:

## Assigning pathname + complete content of first file to var. ›text‹.
    text = f.read()
    f = str(f)
    f = str(f.replace("<_io.TextIOWrapper name='/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/txt/", '', re.U))
    f = str(f.replace("NumberOfCharacters.txt' mode='r' encoding='UTF-8'>", '', re.U))
    # f = str(re.sub(r'\S+-', '', f, re.U))
    outfile = open ('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/collectingContentsOfBulkOfFiles.txt', mode='a', encoding='UTF-8')
    outfile.write(str(f + text))
    outfile.close()

infile = open ('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/collectingContentsOfBulkOfFiles.txt', encoding='UTF-8')
data = infile.read()
infile.close()

print(type(data))
data = list(data.split('\n'))
# print(type(data))
# print(data)
data.sort()
data = str(data)
# outfile = open ('collectingContentsOfBulkOfFilesA.txt', mode='w', encoding='UTF-8')
# outfile.write(str(data))
# outfile.close()
data = str(re.sub("\['', '", '', data, re.U))
data = str(re.sub("'\]", '', data, re.U))
while "', '" in data:
  data = str(re.sub("', '", '\n', data, re.U))
# data = str(re.sub("', '", '\n', data, re.U))
# data = str(re.sub("', '", '\n', data, re.U))
# data = str(re.sub("', '", '\n', data, re.U))
  outfile = open ('/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/collectingContentsOfBulkOfFiles.txt', mode='w', encoding='UTF-8')
  outfile.write(str(data))
  outfile.close()

# outfile = open('/Users/michaeldahnke/Documents/corpora/software/scriptsForAll/collectingContentsOfBulkOfFiles.txt', mode="r", encoding='UTF-8')
# outfile.close()
  