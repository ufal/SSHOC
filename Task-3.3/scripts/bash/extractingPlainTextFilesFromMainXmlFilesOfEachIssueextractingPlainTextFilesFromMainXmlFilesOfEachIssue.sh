#!/bin/bash
#Extracting plain text files from main xml files of each issue, separately
for f in `find DigiZeitFOLR -name "*.xml" -maxdepth 2`; do python3.7 ./xml2txt.py --file-prefix ${f%%.xml} > ${f%%.xml}.txt; done


extractingPlainTextFilesFromMainXmlFilesOfEachIssue,Separately