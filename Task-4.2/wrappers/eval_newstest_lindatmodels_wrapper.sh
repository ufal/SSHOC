#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script
BASEDIR="$WD/.."
LANGUAGES="de ru"


# Translation
all_jid=
for l in $LANGUAGES; do
    # en => $l
    cat $BASEDIR/eval/datasets/newstest-${l}en-src.en.txt \
        | ~/scripts/translate-lindat.sh en $l \
        > $BASEDIR/eval/outputs/newstest.lindat.${l}en.$l.decoded

    # $l => en
    cat $BASEDIR/eval/datasets/newstest-${l}en-src.$l.txt \
        | ~/scripts/translate-lindat.sh $l en \
        > $BASEDIR/eval/outputs/newstest.lindat.${l}en.en.decoded
done

# Evaluation
for l in $LANGUAGES; do
    wrappers/multeval_wrapper.sh \
        $l \
        "$BASEDIR/eval/datasets/newstest-${l}en-ref.$l.txt" \
        "$BASEDIR/eval/outputs/newstest.lindat.${l}en.$l.decoded" \
        > "$BASEDIR/eval/results/newstest.lindat.${l}en.$l.scores"
    wrappers/multeval_wrapper.sh \
        en \
        "$BASEDIR/eval/datasets/newstest-${l}en-ref.en.txt" \
        "$BASEDIR/eval/outputs/newstest.lindat.${l}en.en.decoded" \
        > "$BASEDIR/eval/results/newstest.lindat.${l}en.en.scores"
done
