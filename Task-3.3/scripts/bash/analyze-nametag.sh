#!/bin/bash
LANG=${1:-"english"}

# Supported languages:
# czech
# dutch
# english
# german
# spanish

cat /dev/stdin | while read -r line; do
    line=`echo $line | sed "s/'/\\\\\'/g"`
    curl \
        -F "data=$line" \
        -F "model=$LANG" \
        http://lindat.mff.cuni.cz/services/nametag/api/recognize | \
    PYTHONIOENCODING=utf-8 python -c "import sys,json; sys.stdout.write(json.load(sys.stdin)['result'])" | \
    sed 's/<.\?token>//g;s/<.\?sentence>//g'
done
