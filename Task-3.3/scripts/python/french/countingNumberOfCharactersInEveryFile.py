import os, glob, re

__author__ = 'Michael Dahnke'

# With this script:
# 1. content of any number of files in same directory will be read file by file and
# 2. stored in a plain text file as a list.

# Open external file in which respective information shall be stored and erase possible already existing content.
outfile = open('countingNumberOfCharactersInEveryFile.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

# Goes to respective directory with files inside and assign content to variable ›folder_path‹.
folder_path = 'txt'

# Assigning pathname of first file to var. ›filename‹.
for filename in glob.glob(os.path.join(folder_path, '*.txt')):
  with open(filename, 'r') as f:

# Assigning complete content of first file to var. ›text‹.
    text = f.read()

# Replacing some stuff within var. ›filename‹ and re-assisigning.
    filename = str(filename.replace('txt/', '', re.U))
    filename = str(filename.replace('NumberOfCharacters.txt', '', re.U))
    text = str(text.replace(' ', '', re.U))

# Store both—changed filename + content of file—in first line of newly created file and so, afterwards, on and on circling for all files.
    outfile = open('countingNumberOfCharactersInEveryFile.txt', mode='a', encoding='UTF-8')
    outfile.write(filename + ': ' + text)
    outfile.close()