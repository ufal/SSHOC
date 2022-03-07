#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script

echo "Cloning SacreBLEU repository (for newstest data download)"
[[ -d "sacrebleu" ]] || git clone https://github.com/mjpost/sacrebleu.git

SRC=de
TGT=en
LANGPAIR=$SRC-$TGT

SEED_FILE=$WD/wmt.train.$LANGPAIR.shuf.SEED

TMPDIR=$WD/tmp.d/$LANGPAIR

# Download Training corpora
mkdir -p $TMPDIR/wmt.train
cd $TMPDIR/wmt.train

echo "Downloading training corpora..."
wget http://www.statmt.org/europarl/v10/training/europarl-v10.$LANGPAIR.tsv.gz
zcat europarl-v10.$LANGPAIR.tsv.gz | cut -f1 > europarl-v10.$LANGPAIR.$SRC
zcat europarl-v10.$LANGPAIR.tsv.gz | cut -f2 > europarl-v10.$LANGPAIR.$TGT

wget http://statmt.org/wmt13/training-parallel-commoncrawl.tgz
tar xvf training-parallel-commoncrawl.tgz

wget http://data.statmt.org/news-commentary/v16/training/news-commentary-v16.$LANGPAIR.tsv.gz
zcat news-commentary-v16.$LANGPAIR.tsv.gz | cut -f1 > news-commentary-v16.$LANGPAIR.$SRC
zcat news-commentary-v16.$LANGPAIR.tsv.gz | cut -f2 > news-commentary-v16.$LANGPAIR.$TGT

wget http://data.statmt.org/wikititles/v3/wikititles-v3.$LANGPAIR.tsv
cat wikititles-v3.$LANGPAIR.tsv | cut -f1 > wikititles-v3.$LANGPAIR.$SRC
cat wikititles-v3.$LANGPAIR.tsv | cut -f2 > wikititles-v3.$LANGPAIR.$TGT

wget http://data.statmt.org/wmt21/translation-task/WikiMatrix/WikiMatrix.v1.$LANGPAIR.langid.tsv.gz
zcat WikiMatrix.v1.$LANGPAIR.langid.tsv.gz | cut -f2 > WikiMatrix.v1.$LANGPAIR.langid.$SRC
zcat WikiMatrix.v1.$LANGPAIR.langid.tsv.gz | cut -f3 > WikiMatrix.v1.$LANGPAIR.langid.$TGT

cat *$LANGPAIR*.$SRC > $WD/wmt.train.$LANGPAIR.$SRC
cat *$LANGPAIR*.$TGT > $WD/wmt.train.$LANGPAIR.$TGT
cd $WD


# Download Newstest validation corpora
mkdir $TMPDIR/valid
cd $TMPDIR/valid

echo "Downloading valid/test data..."
for y in 13 14 15 16 17 18 19 20; do
    sacrebleu -t wmt$y -l $SRC-$TGT --echo src > newstest$y.$SRC-$TGT.$SRC
    sacrebleu -t wmt$y -l $SRC-$TGT --echo ref > newstest$y.$SRC-$TGT.$TGT
    sacrebleu -t wmt$y -l $TGT-$SRC --echo src > newstest$y.$TGT-$SRC.$TGT
    sacrebleu -t wmt$y -l $TGT-$SRC --echo ref > newstest$y.$TGT-$SRC.$SRC
done

for lpair in $SRC-$TGT $TGT-$SRC; do
    for l in $SRC $TGT; do
        f_out=$WD/newstest.$lpair.valid.$l
        [[ -e $f_out ]] && rm $f_out
        for y in 13 14 15 16; do
            cat newstest$y.$lpair.$l >> $f_out
        done

        f_out=$WD/newstest.$lpair.test.$l
        [[ -e $f_out ]] && rm $f_out
        for y in 17 18 19 20; do
            cat newstest$y.$lpair.$l >> $f_out
        done
    done
done
cd $WD


# Preprocess training data (shuffle, filter)
echo "Shuffling training corpora..."
cat $WD/wmt.train.$LANGPAIR.$SRC | wc -l > $WD/wmt.train.$LANGPAIR.lines
N_LINES=`cat $WD/wmt.train.$LANGPAIR.lines`

python -c "import numpy as np; [print(k) for k in np.random.RandomState(seed=42).permutation($N_LINES)]" > $SEED_FILE
for l in $SRC $TGT; do
    f_in=$WD/wmt.train.$LANGPAIR.$l
    f_out=$WD/wmt.train.$LANGPAIR.shuf.$l

    paste -d" " $SEED_FILE $f_in \
        | sort -n -k1,1 \
        | cut -d" " -f2- \
        > $f_out
done

tab=$'\t'
paste $WD/wmt.train.$LANGPAIR.shuf.$SRC $WD/wmt.train.$LANGPAIR.shuf.$TGT \
    | grep -vE "^(.*)$tab\1$" \
    | grep -vE "^$tab" \
    | grep -vE "$tab$" \
    > $WD/wmt.train.$LANGPAIR.shuf.filter
cut -f1 $WD/wmt.train.$LANGPAIR.shuf.filter > $WD/wmt.train.$LANGPAIR.shuf.filter.$SRC
cut -f2 $WD/wmt.train.$LANGPAIR.shuf.filter > $WD/wmt.train.$LANGPAIR.shuf.filter.$TGT

echo "Removing up $TMPDIR..."
rm -r $WD/wmt.train.$LANGPAIR.shuf.filter $WD/wmt.train.$LANGPAIR.shuf.$SRC $WD/wmt.train.$LANGPAIR.shuf.$TGT
rm -r $TMPDIR
