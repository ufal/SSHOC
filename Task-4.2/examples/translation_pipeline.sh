#!/bin/bash
# Example of the LANG=>English translation pipeline using Lindat online translation service
# and DropBox shared directory
# When run, the scripts checks for a new version of a survey file to be translated,
# downloads it, translates it and then stores it back to the DropBox shared directory.
set -e

INPUT=
CLEANUP=0
SLEEP=300
SENT_SPLITTER="split-sentences.pl"
DROPBOX_DIR="/SSHOC-T3.3-shared"  # Project-specific DropBox dir

# Get input document and extract sentences
echo "Directory contents:" >&2
dbxcli ls -l $DROPBOX_DIR >&2

# Look for a project-specific survey file to be translated (.*corona_alltime.*.xlsx)
INPUT_FILE=`dbxcli ls -l $DROPBOX_DIR | grep corona_alltime | grep -v translated | tr -s " " | cut -d" " -f7`
echo "Fetching latest input file: $INPUT_FILE" >&2

dbxcli get $INPUT_FILE
INPUT_FILE=`echo $INPUT_FILE | sed s#.*/##g`
echo "(DEBUG) $INPUT_FILE" >&2

# Convert .xlsx to .csv
xlsx2csv -d$'\t' -e $INPUT_FILE | awk -f join_lines_in_cell.awk > corona_alltime.csv

# Find the index of the column to be tranlated
head -1 corona_alltime.csv | tr "\t" "\n" > header.tmp
[[ `grep -n LANGUAGE header.tmp | wc -l` -eq 1 ]] || exit 1
[[ `grep -n TEXTBOX_END4 header.tmp | wc -l` -eq 1 ]] || exit 1

LANG_COL=`grep -n LANGUAGE header.tmp | cut -d: -f1`
INPUT_COL=`grep -n TEXTBOX_END4 header.tmp | cut -d: -f1`
OUTPUT_COL=`expr $INPUT_COL + 1`
cut -f$LANG_COL,$INPUT_COL corona_alltime.csv | sed 's/_.*\t/\t/' > translation_input.txt

# Translate
echo TEXTBOX_END4_TRANSLATED > translation_output.txt

IFS=''
tail -n+2 translation_input.txt | while read -r line; do
    lang=`echo $line | cut -f1`
    sent=`echo $line | cut -f2 | sed 's/"/\\\"/g;' | sed "s/'/\\\\\\\'/g"` 
    if [[ -z "${sent// }" ]]; then
        # Empty input line => skip
        echo $sent >> translation_output.txt
    elif [[ "-99" == "$sent" ]]; then
        # Empty input => skip
        echo $sent >> translation_output.txt
    elif [[ "en" == "$lang" ]]; then
        echo "(Skipping - already in English)" >&2
        echo $sent >> translation_output.txt
    elif [[ "cs,fr,de,ru" == *"$lang"* ]]; then
        curl \
            -X POST "https://lindat.mff.cuni.cz/services/translation/api/v2/models/$lang-en?src=$lang&tgt=en" \
            -H "accept: text/plain" \
            -H "Content-Type: application/x-www-form-urlencoded" \
            -d "input_text=${sent}" >> translation_output.txt
    else
        echo "Unsupported source language" >&2
    fi
done

OUTPUT_FILE=`echo $INPUT_FILE | sed s/.xlsx/_translated.xlsx/`
echo "Uploading translated file to: $DROPBOX_DIR/$OUTPUT_FILE" >&2

# Reconstruct the output document
paste \
    <(cut -f-${INPUT_COL} corona_alltime.csv) \
    translation_output.txt \
    <(cut -f${OUTPUT_COL}- corona_alltime.csv) > corona_alltime_translated.csv
cat corona_alltime_translated.csv | \
    csv2xlsx -d$'\t' utf-8 Sheet1 > $OUTPUT_FILE
dbxcli ls $DROPBOX_DIR/$OUTPUT_FILE && dbxcli rm $DROPBOX_DIR/$OUTPUT_FILE
dbxcli put $OUTPUT_FILE $DROPBOX_DIR/$OUTPUT_FILE

if [[ $CLEANUP -eq 0 ]]; then
    rm *.csv
    rm *.txt
    rm *.xlsx
fi
