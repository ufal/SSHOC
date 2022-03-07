#!/bin/bash
# Combine the raw $LANGPAIR WMT and MCSQ data
set -e
WD=`pwd`

SRC=${1:-de}
TGT=en
LANGPAIR=$SRC-$TGT

SEED_FILE=$WD/wmt-mcsq.train.$LANGPAIR.shuf.filter.SEED

TMPDIR=$WD/tmp.d/$LANGPAIR

# TODO: check whether the files from previous steps are existing

# Concatenate and shuffle the English side
cat $WD/wmt.train.$LANGPAIR.shuf.filter.$SRC $WD/mcsq.train.$LANGPAIR.shuf.filter.$SRC > $WD/wmt-mcsq.train.$LANGPAIR.filter.$SRC
cat $WD/wmt.train.$LANGPAIR.shuf.filter.$TGT $WD/mcsq.train.$LANGPAIR.shuf.filter.$TGT > $WD/wmt-mcsq.train.$LANGPAIR.filter.$TGT

echo "Shuffling training corpora..."
cat $WD/wmt-mcsq.train.$LANGPAIR.filter.$SRC | wc -l > $WD/wmt-mcsq.train.$LANGPAIR.filter.lines
N_LINES=`cat $WD/wmt-mcsq.train.$LANGPAIR.filter.lines`

python -c "import numpy as np; [print(k) for k in np.random.RandomState(seed=42).permutation($N_LINES)]" > $SEED_FILE
for l in $SRC $TGT; do
    f_in=$WD/wmt-mcsq.train.$LANGPAIR.filter.$l
    f_out=$WD/wmt-mcsq.train.$LANGPAIR.shuf.filter.$l

    paste -d" " $SEED_FILE $f_in \
        | sort -n -k1,1 \
        | cut -d" " -f2- \
        > $f_out
done
