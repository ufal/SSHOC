#!/bin/bash
# Translate English part of the other language pairs to create
# additional $TGT-en synthetic parallel data
set -e
WD=`pwd`

MODEL_DIR=$1
T2T_LOCATION=$WD/../tensor2tensor-1.6.6

SRC=${2:-de}
TGT=en
LANGPAIR=$SRC-$TGT

SEED_FILE=$WD/mcsq.bt.train.$LANGPAIR.shuf.filter.SEED

TMPDIR=$WD/tmp.d/$LANGPAIR

[[ -e ${T2T_LOCATION##*/} ]] || ln -s $T2T_LOCATION 

# Do not download the corpora if it is still available from previous steps
if [[ ! -d $TMPDIR/mcsq.all/alignments ]]; then
    mkdir -p $TMPDIR/mcsq.all
    cd $TMPDIR/mcsq.all

    echo "Downloading MCSQ corpora..."
    wget https://repo.clarino.uib.no/xmlui/bitstream/handle/11509/142/mcsq_v3.zip
    unzip mcsq_v3.zip
else
    cd $TMPDIR/mcsq.all
fi

# Prepare the English side (and filter out empty lines)
[[ -e $WD/mcsq.bt.train.$LANGPAIR.filter.$TGT ]] && rm $WD/mcsq.bt.train.$LANGPAIR.filter.$TGT
for f in alignments/*; do
    tail -n+2 $f \
        | cut -f8 \
        | grep -vE "^$" \
        >> $WD/mcsq.bt.train.$LANGPAIR.filter.$TGT
done

cd $WD

# Shuffle the English side
echo "Shuffling training corpora..."
cat $WD/mcsq.bt.train.$LANGPAIR.filter.$TGT | wc -l > $WD/mcsq.bt.train.$LANGPAIR.filter.lines
N_LINES=`cat $WD/mcsq.bt.train.$LANGPAIR.filter.lines`

python -c "import numpy as np; [print(k) for k in np.random.RandomState(seed=42).permutation($N_LINES)]" > $SEED_FILE
f_in=$WD/mcsq.bt.train.$LANGPAIR.filter.$TGT
f_out=$WD/mcsq.bt.train.$LANGPAIR.shuf.filter.$TGT

paste -d" " $SEED_FILE $f_in \
    | sort -n -k1,1 \
    | cut -d" " -f2- \
    > $f_out

# Translate English into $SRC (just using greedy decoding)
f_in=$WD/mcsq.bt.train.$LANGPAIR.shuf.filter.$TGT
f_out=$WD/mcsq.bt.train.$LANGPAIR.shuf.filter.$SRC
$WD/../scripts/translate.sh \
    -m $MODEL_DIR \
    -i $f_in \
    -o $f_out \
    --beam-size 1
