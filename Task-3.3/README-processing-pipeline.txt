(TODO: replace TODOs in pathnames with correct prefixes)
0. Setup work environment
```
  INPUT_DIR=path/to/input/xml/files
  OUTPUT_DIR=path/to/output/dir
  TEI_DIR=path/to/tei/processing/outputs
```

1. Count the 	number of <person> in <listPerson> 	for each drama and store result in a separate plain text file.
```
  $ cp scripts/xsl/CountingPersonInListPerson.xsl $TEI_DIR/.
```

2. With Oxygen XML Editor run CountingPersonInListPerson.xsl in $TEI_DIR.

3. Move both CountingPersonInListPerson.xsl and CountingPersonInListPerson.txt out of $TEI_DIR.
```
  $ $TEI_DIR
  $ rm CountingPersonInListPerson.xsl
  $ mv CountingPersonInListPerson.txt ../.;
```

4. Extract master's and servant's spoken text resulting in $TEI_DIR for every drama an eponymous subdirectory storing all files for single characters's spoken text into it.
```
  $ for f in $INPUT_DIR/*.xml; do \
    mkdir ${f%%.xml}; \
    name=`echo ${f%%.xml} | sed 's#^.*/##g'`; \
    scripts/python/extract_speech.py --input-file $f --output-prefix $OUTPUT_DIR/$name \
  done
``` 	
 	
5. Count the number of single files in every directory and save it in a file countingNumberOfCharactersInEveryFile.txt
```
  $ for f in *.xml; do \
    echo $f; \
    ls 	${f%%.xml} | wc -l; \
  done > $OUTPUT_DIR/countingNumberOfCharactersInEveryFile.txt
  
```

6. Restructure every entry in countingNumberOfCharactersInEveryFile.txt.
- (TODO: don't use ``hard-wired'' paths)
- (TODO: check whether it still works within the current directory structure)
```
  $ TODO/sortingContentOfPlainTextFileAlphabetically.py
```
 	
7. Remove all occurrences within $TEI_DIR from CountingPersonInListPerson.txt and sort the entries alphabetically.
- (TODO: check whether TEI_DIR is correct here)
- (TODO: don't use ``hard-wired'' paths)
- (TODO: check whether it still works within the current directory structure)
```
	$ TODO/CountingPersonInListPerson.py
```

8. Create a list (TODO: what kind of a list?) with the following structure:
=IDENTISCH(B2; E2)
=IDENTISCH(B3; E3) 	
=IDENTISCH(B4; E4) 
… 
=IDENTISCH(B204; E204)
Results are stored in counted.txt
- (TODO: don't use ``hard-wired'' or relative paths)
- (TODO: check whether it still works within the current directory structure)
```
  $ TODO/countToAnyGivenNumber.py
```
 	
9. Copy the lists.
- (TODO: check whether it still works within the current directory structure)
- (TODO: does this step comply with the original statement ``Both lists from 	countingNumberOfCharactersInEveryFile.txt 	and CountingPersonInListPerson.txt are copied into xls/checkIfPyScriptSelectsAllCharactersCorrectly.xls side by side and values are compared for every drama with 	=IDENTISCH(B2; E2) etc. in column F.''?)
```
  $ cp countingNumberOfCharactersInEveryFile.txt CountingPersonInListPerson.txt $OUTPUT_DIR/xls/.
```

10. Cut the content from ??? (TODO: which file) and store it in checkIfPyScriptSelectsAllCharactersCorrectly.txt
- (TODO: can we do this via one-liners?)
- (TODO: don't use ``hard-wired'' paths)
```
  $ TODO/checkIfPyScriptSelectsAllCharactersCorrectly.py 
```

11. Count the number of ERROR and their indices in TODO/checkIfPyScriptSelectsAllCharactersCorrectly.xls and store the results in TODO/resultsOfCheckIfPyScriptSelectsAllCharactersCorrectly.txt
- (TODO: check the correctness of the pathnames)
```
  $ TODO/checkIfPyScriptSelectsAllCharactersCorrectly.py
```
 	
In 0 cases number of <person> in <listPerson> in English dramas does not match number of files created for each single character in respective drama. The dramas are that on position in list 	›checkIfPyScriptSelectsAllCharactersCorrectlyEnglish.xls‹. The percentage of errors is 0.0 %.
