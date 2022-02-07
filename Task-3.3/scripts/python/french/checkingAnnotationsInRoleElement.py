import os,glob,re

__author__ = 'Michael Dahnke'

## Open external file in which respective information shall be stored and erase possible already existing content.
outfile = open('../../_french/theatre17/contentsOfAnnotationsInRoleElement.txt', mode='w', encoding='UTF-8')
outfile.write('')
outfile.close()
c = 0
## Goes to respective directory with xml files inside and assign content to variable ›folder_path‹.
folder_path = '../../_french/theatre17/tei'

for filename in glob.glob(os.path.join(folder_path, '*.xml')):
  with open(filename, 'r') as f:

## Assinging pathname + complete content of first file to var. ›text‹.
    text = f.read()

##    Counter counting consecutively for each entry.
    c += 1

## Replacing some stuff within var. ›filename‹ and re-assisigning.
    filename = str(filename.replace('../../_french/theatre17/tei/', '', re.U))
    filename = str(filename.replace('.xml', '', re.U))

## Seek within' string ›text‹ substring as described and assigning content of that substring to var. ›author‹.
    roleAttributes = str(re.findall('<role \S*>', text, re.U))
    roleAttributes = str(re.sub('</role>\', \'<role', '</role>\'\n\'<role', roleAttributes, re.U))
    roleAttributes = str(re.sub('">\', \'<role', '">\'\n\'<role', roleAttributes, re.U))
    print(filename)
    print(str(roleAttributes))
    outfile = open('../../_french/theatre17/contentsOfAnnotationsInRoleElement.txt', mode='a', encoding='UTF-8')
    outfile.write(str(c) + '.	' + filename + '\n' + roleAttributes + '\n')
    outfile.close()
