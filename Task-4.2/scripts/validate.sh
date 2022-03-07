#!/bin/bash

# Tested with the following virtualenv
#source /net/me/merkur3/varis/tensorflow-virtualenv/tensorflow-1.12-cpu/bin/activate


# Default parameter values
OUTPUT_PATH=""
SRC_DEV_PATH=""
TGT_DEV_PATH=""
ALPHA=0.6
BEAM_SIZE=4
MAX_LEN=150
N_CHECKPOINTS=8

#--decode_hparams=max_input_size=$MAX_LENGTH
#--decode_to_file=$TMP_DIR/translated.txt

# Constants
GPU_MEM=8g
CPU_MEM=8g
CORES=1
T2T_BIN=tensor2tensor-1.6.6/tensor2tensor/bin
WAIT_TIME=10000
SLEEP_TIME="30m"
PROBLEM="translate_encs_wmt_czeng57m32k"
HPARAMS_SET="transformer_big_single_gpu"


print_usage () {
    echo ""
    echo "      Usage:"
    echo "      $0 -o OUTPUT_PATH --dev-src SOURCE_DEVSET --dev-tgt TARGET_DEVSET --[OPTION]"
    echo ""
    echo "      -o, --output-path FILE"
    echo "          model directory (output of prepare_data.sh)"
    echo "      --dev-src FILE"
    echo "          path to the source-side validation corpus"
    echo "      --dev-tgt FILE"
    echo "          path to the target-side validation corpus"
    echo "      -a, --alpha NUM"
    echo "          beamsearch length penalty (default=$ALPHA)"
    echo "      -b, --beam-size INT"
    echo "          beam size (default=$BEAM_SIZE)"
    echo "      --max-len INT"
    echo "          maximum sentence length (default=$MAX_LEN)"
    echo "      --n-checkpoints INT"
    echo "          number of checkpoints to average for evaluation (default=$N_CHECKPOINTS)"
    echo ""
    exit 1
}


# Parsing parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -o|--output-path)
            OUTPUT_PATH="$2"
            shift
        ;;
        --dev-src)
            SRC_DEV_PATH="$2"
            shift
        ;;
        --dev-tgt)
            TGT_DEV_PATH="$2"
            shift
        ;;
        -a|--alpha)
            ALPHA="$2"
            shift
        ;;
        -b|--beam-size)
            BEAM_SIZE="$2"
            shift
        ;;
        --max-len)
            MAX_LEN="$2"
            shift
        ;;
        --n-checkpoints)
            N_CHECKPOINTS="$2"
            shift
        ;;
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done

# Testing (required) parameter values
if [[ ( ! -e "$SRC_DEV_PATH"  || ! -e "$TGT_DEV_PATH" ) ]]; then
    print_usage
fi
[[ -n "$OUTPUT_PATH" ]] && [[ -d "$OUTPUT_PATH" ]] || print_usage

# Setting up directories
DATA_DIR=$OUTPUT_PATH/data
TMP_DIR=$OUTPUT_PATH/tmp_dir
USER_DIR=$OUTPUT_PATH/user_dir
MODEL_DIR=$OUTPUT_PATH/model
EVAL_DIR=$OUTPUT_PATH/eval_dir

LOGS_DIR=$EVAL_DIR/logs
EVENTS_DIR=$EVAL_DIR/output
TRANSLATIONS_DIR=$EVAL_DIR/translations

mkdir -p $EVAL_DIR
mkdir -p $TRANSLATIONS_DIR

# Setting ENV
export PYTHONUNBUFFERED=yes
export PYTHONPATH="`pwd`/tensor2tensor-1.6.6":$PYTHONPATH

# Command for t2t-translate-all
QSUB_CMD="source $HOME/python-virtualenv/tensorflow-1.12-gpu/bin/activate"
QSUB_CMD="$QSUB_CMD && export LD_LIBRARY_PATH=/opt/cuda/9.0/cudnn/7.0/lib64:/opt/cuda/9.0/extras/CUPTI/lib64:/opt/cuda/9.0/lib64:/home/varis/.local/lib:/home/varis/poco/lib:/usr/lib:"
QSUB_CMD="$QSUB_CMD && export PYTHONPATH="`pwd`/tensor2tensor-1.6.6":$PYTHONPATH"
QSUB_CMD="$QSUB_CMD && export PYTHONUNBUFFERED=yes"
QSUB_CMD="$QSUB_CMD && $T2T_BIN/t2t-decoder {params}"

pid_avg=""
pid_bleu=""
# Main loop
# Periodically submits three tasks - averaging, translation and evaluation
# Uses file-based locks for control
#TODO: handle race conditions (if any)
while true; do
    sleep 20

    # Averaging
    ps -p "$pid_avg" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        echo "Running: $T2T_BIN/t2t-avg-all --model_dir=$MODEL_DIR --output_dir=$EVAL_DIR --n=$N_CHECKPOINTS --wait_minutes=$WAIT_TIME &" >&2
        $T2T_BIN/t2t-avg-all \
            --model_dir=$MODEL_DIR \
            --output_dir=$EVAL_DIR \
            --n=$N_CHECKPOINTS \
            --wait_minutes=$WAIT_TIME &
        pid_avg=$!
    fi
    sleep $SLEEP_TIME

    # Wait until the averaging is finished
    while true; do ps -p "$pid_avg" > /dev/null 2>&1 || break; sleep $SLEEP_TIME; done

    # Evaluation
    ps -p "$pid_bleu" > /dev/null 2>&1
    if [[ $? -eq 1 ]]; then
        rm -f $EVENTS_DIR/events*
        echo "Running: $T2T_BIN/t2t-bleu --source=$SRC_DEV_PATH --reference=$TGT_DEV_PATH --wait_minutes=$WAIT_TIME --min_steps=0 --event_dir=$EVENTS_DIR --translation_dir=$TRANSLATIONS_DIR &" >&2
        $T2T_BIN/t2t-bleu \
            --source=$SRC_DEV_PATH \
            --reference=$TGT_DEV_PATH \
            --wait_minutes=$WAIT_TIME \
            --min_steps=0 \
            --event_dir=$EVENTS_DIR \
            --translations_dir=$TRANSLATIONS_DIR &
        pid_bleu=$!
    fi

    echo "Running: $T2T_BIN/t2t-translate-all --t2t_usr_dir=$USER_DIR --data_di=$DATA_DIR --model_dir=$EVAL_DIR --problem=$PROBLEM --source=$SRC_DEV_PATH --wait_minutes=$WAIT_TIME --alpha=$ALPHA --beam_size=$BEAM_SIZE --hparams_set=$HPARAMS_SET --translation_dir=$TRANSLATIONS_DIR --decoder_command=\"qsubmit --gpumem=$GPU_MEM --mem=$CPU_MEM --logdir=$LOGS_DIR --jobname=t2t-lindat-eval \\\"$QSUB_CMD\\\"\"" >&2
    $T2T_BIN/t2t-translate-all \
        --t2t_usr_dir=$USER_DIR \
        --data_dir=$DATA_DIR \
        --model_dir=$EVAL_DIR \
        --problem=$PROBLEM \
        --source=$SRC_DEV_PATH\
        --wait_minutes=$WAIT_TIME \
        --alpha=$ALPHA \
        --beam_size=$BEAM_SIZE \
        --hparams_set=$HPARAMS_SET \
        --translations_dir=$TRANSLATIONS_DIR \
        --decoder_command="qsubmit \
            --gpumem=$GPU_MEM \
            --mem=$CPU_MEM \
            --logdir=$LOGS_DIR \
            --jobname=t2t-lindat-eval \
            --priority=-120 \
            \"$QSUB_CMD\""

    # Check if training still running
    [[ ! -e "$MODEL_DIR/finished" ]] || break
done

# Finishing
wait $pid_bleu
ps -p "$pid_avg" > /dev/null 2>&1 && kill $pid_avg
