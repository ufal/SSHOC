#!/bin/bash
source $HOME/python-virtualenv/fairseq-env/bin/activate
BASEDIR="/home/varis/tspec-workdir/t2t-lindat"
LANGUAGES="cs de fr hi pl ru"

SYS_PREFIX=${1:-"$BASEDIR/output/system_aliases/baseline"}
N_CHECKPOINTS=${2:-8}
BS=${3:-4}
ALPHA=${4:-1.0}

# We evaluate the models either on following testsets:
# - newstest2014 (cs, fr, hi)
# - newstest2020 (pl, de, ru)
# We use aliases for easier evaluation automation (see links for location of the original files)

# Translation
all_jid=
for l in $LANGUAGES; do
    # en => $l
    f_in="$BASEDIR/eval/datasets/newstest-${l}en-src.en.txt"
    f_out="$BASEDIR/eval/outputs/newstest.${l}en.$l.${SYS_PREFIX##*/}.ckpt-$N_CHECKPOINTS.bs-$BS.alpha-$alpha.decoded"

    jid=`qsubmit \
        --logdir=logs \
        --jobname=t2t-lindat-translate \
        --gpus=1 \
        --mem=15g \
        --gpumem=11g "source ~/python-virtualenv/tensorflow-1.12-gpu/bin/activate && $BASEDIR/scripts/translate.sh -i $f_in -o $f_out -m $SYS_PREFIX.en-$l --n-checkpoints $N_CHECKPOINTS --beam-size $BS --alpha $ALPHA"`
    all_jid="`echo $jid | cut -d" " -f3` $all_jid"

    # $l => en
    f_in="$BASEDIR/eval/datasets/newstest-${l}en-src.$l.txt"
    f_out="$BASEDIR/eval/outputs/newstest.${l}en.en.${SYS_PREFIX##*/}.ckpt-$N_CHECKPOINTS.bs-$BS.alpha-$alpha.decoded"

    jid=`qsubmit \
        --logdir=logs \
        --jobname=t2t-lindat-translate \
        --gpus=1 \
        --mem=15g \
        --gpumem=11g "source ~/python-virtualenv/tensorflow-1.12-gpu/bin/activate && $BASEDIR/scripts/translate.sh -i $f_in -o $f_out -m $SYS_PREFIX.${l}-en --n-checkpoints $N_CHECKPOINTS --beam-size $BS --alpha $ALPHA"`
    all_jid="`echo $jid | cut -d" " -f3` $all_jid"
done

# Wait until all translation is finished
while true; do
    sleep 1m
    dont_break=""
    for jid in $all_jid; do
        qstat | grep $jid && dont_break="1" && break
    done
    [[ -z "$dont_break" ]] && break
done
        
# Evaluation
for l in $LANGUAGES; do
    scripts/multeval_wrapper.sh \
        $l \
        "$BASEDIR/eval/datasets/newstest-${l}en-ref.$l.txt" \
        "$BASEDIR/eval/outputs/newstest.${l}en.$l.${SYS_PREFIX##*/}.ckpt-$N_CHECKPOINTS.bs-$BS.alpha-$alpha.decoded" \
        > "$BASEDIR/eval/results/newstest.${l}en.$l.${SYS_PREFIX##*/}.ckpt-$N_CHECKPOINTS.bs-$BS.alpha-$alpha.scores"
    scripts/multeval_wrapper.sh \
        en \
        "$BASEDIR/eval/datasets/newstest-${l}en-ref.en.txt" \
        "$BASEDIR/eval/outputs/newstest.${l}en.en.${SYS_PREFIX##*/}.ckpt-$N_CHECKPOINTS.bs-$BS.alpha-$alpha.decoded" \
        > "$BASEDIR/eval/results/newstest.${l}en.en.${SYS_PREFIX##*/}.ckpt-$N_CHECKPOINTS.bs-$BS.alpha-$alpha.scores"
done
