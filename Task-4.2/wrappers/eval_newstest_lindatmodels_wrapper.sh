#!/bin/bash
source $HOME/python-virtualenv/fairseq-env/bin/activate

BASEDIR="/home/varis/tspec-workdir/t2t-lindat"

# We evaluate the models either on following testsets:
# - newstest2014 (cs, fr, hi)
# - newstest2020 (pl, de, ru)
# We use aliases for easier evaluation automation (see links for location of the original files)

# Translation
all_jid=
for l in ru; do
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
for l in ru; do
    scripts/multeval_wrapper.sh \
        $l \
        "$BASEDIR/eval/datasets/newstest-${l}en-ref.$l.txt" \
        "$BASEDIR/eval/outputs/newstest.lindat.${l}en.$l.decoded" \
        > "$BASEDIR/eval/results/newstest.lindat.${l}en.$l.scores"
    scripts/multeval_wrapper.sh \
        en \
        "$BASEDIR/eval/datasets/newstest-${l}en-ref.en.txt" \
        "$BASEDIR/eval/outputs/newstest.lindat.${l}en.en.decoded" \
        > "$BASEDIR/eval/results/newstest.lindat.${l}en.en.scores"
done
