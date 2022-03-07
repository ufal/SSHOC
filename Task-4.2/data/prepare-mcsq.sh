#!/bin/bash
set -e
WD=`pwd`

URL=https://repo.clarino.uib.no/xmlui/bitstream/handle/11509/142/mcsq_v3.zip

echo "Cloning SacreBLEU repository (for newstest data download)"
[[ -d "sacrebleu" ]] || git clone https://github.com/mjpost/sacrebleu.git

SRC=${1:-de}
TGT=en
LANGPAIR=$SRC-$TGT

SEED_FILE=$WD/mcsq.all.$LANGPAIR.shuf.SEED

TMPDIR=$WD/tmp.d/$LANGPAIR

# Download Training corpora
mkdir -p $TMPDIR/mcsq.all
cd $TMPDIR/mcsq.all

echo "Downloading MCSQ corpora..."
wget https://repo.clarino.uib.no/xmlui/bitstream/handle/11509/142/mcsq_v3.zip
unzip mcsq_v3.zip 

ls alignments/* \
    | grep -i _${SRC}_ \
    | xargs tail -n+2 \
    | grep -v '==>' \
    | cut -f9 \
    > $WD/mcsq.all.$LANGPAIR.$SRC
ls alignments/* \
    | grep -i _${SRC}_ \
    | xargs tail -n+2 \
    | grep -v '==>' \
    | cut -f8 \
    > $WD/mcsq.all.$LANGPAIR.$TGT

cd $WD


# Preprocess training data (shuffle, filter, split)
echo "Shuffling training corpora..."
cat $WD/mcsq.all.$LANGPAIR.$SRC | wc -l > $WD/mcsq.all.$LANGPAIR.lines
N_LINES=`cat $WD/mcsq.all.$LANGPAIR.lines`

python -c "import numpy as np; [print(k) for k in np.random.RandomState(seed=42).permutation($N_LINES)]" > $SEED_FILE
for l in $SRC $TGT; do
    f_in=$WD/mcsq.all.$LANGPAIR.$l
    f_out=$WD/mcsq.all.$LANGPAIR.shuf.$l

    paste -d" " $SEED_FILE $f_in \
        | sort -n -k1,1 \
        | cut -d" " -f2- \
        > $f_out
done

tab=$'\t'
paste $WD/mcsq.all.$LANGPAIR.shuf.$SRC $WD/mcsq.all.$LANGPAIR.shuf.$TGT \
    | grep -vE "^(.*)$tab\1$" \
    | grep -vE "^$tab" \
    | grep -vE "$tab$" \
    > $WD/mcsq.all.$LANGPAIR.shuf.filter
cut -f1 $WD/mcsq.all.$LANGPAIR.shuf.filter > $WD/mcsq.all.$LANGPAIR.shuf.filter.$SRC
cut -f2 $WD/mcsq.all.$LANGPAIR.shuf.filter > $WD/mcsq.all.$LANGPAIR.shuf.filter.$TGT

for l in $SRC $TGT; do
    head -n 1000 $WD/mcsq.all.$LANGPAIR.shuf.filter.$l > $WD/mcsq.$LANGPAIR.valid.$l
    head -n 2000 $WD/mcsq.all.$LANGPAIR.shuf.filter.$l | tail -n 1000 > $WD/mcsq.$LANGPAIR.test.$l
    tail -n+2001 $WD/mcsq.all.$LANGPAIR.shuf.filter.$l > $WD/mcsq.train.$LANGPAIR.shuf.filter.$l
done

echo "Removing up $TMPDIR..."
rm -r $WD/mcsq.all.$LANGPAIR.shuf.filter $WD/mcsq.all.$LANGPAIR.shuf.$SRC $WD/mcsq.all.$LANGPAIR.shuf.$TGT
rm -r $TMPDIR
