import os, glob, re

__author__ = 'Michael Dahnke'

# With this script
# 	1. content of a text file is read line by line,
# 	2. certain content is deleted,
# 	3. remaining is sorted alphabetically and
# 	4. stored in a same plain text file as a list, in the end.

# Open external file that contains content and store it as a list in var ›lists‹.
infile = open('numberOfCharactersPerDrama.txt', encoding='UTF-8')
lists = infile.readlines()
infile.close()

# Erase content within external file, changed will be stored within in the end.
outfile = open('numberOfCharactersPerDrama.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

# INTERMEDIATE STEP: Content deletion and re-storing in external file.
for list in lists:
    list = str(list.replace('file:/Users/michaeldahnke/Documents/corpora/data/workInProgress/french/tei/', '', re.U))
    outfile = open('numberOfCharactersPerDrama.txt', mode='a', encoding='UTF-8')
    outfile.write(list)
    outfile.close()

# Open external file with changed content and store it anew as a list in var ›lists‹.
infile = open('numberOfCharactersPerDrama.txt', encoding='UTF-8')
lists = infile.readlines()
infile.close()

# Also, again, content of external file is erased.
outfile = open('numberOfCharactersPerDrama.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()

# Content of the list is sorted alphabetically.
lists.sort()

# The list is written into file line by line. Learning why list is not immediately saved to the external file as a whole, try procedure below.
for list in lists:
    outfile = open('numberOfCharactersPerDrama.txt', mode='a', encoding='UTF-8')
    outfile.write(list)
    outfile.close()

# # This way you store additional code in output file, which you then have to delete manually, additionally.
# outfile = open('numberOfCharactersPerDrama.txt', mode='a', encoding='UTF-8')
# outfile.write(lists)
# outfile.close()