#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script
T2T_BIN="$WD/../tensor2tensor-1.6.6/tensor2tensor/bin"

# Default parameter values
GPUS=1
TRAIN_STEPS=6000000
NUM_KEEP_CHECKPOINTS=20
BATCH_SIZE=2900
MAX_LEN=150
LR=0.2
LR_WARMUP=8000
LR_SCHEDULE="rsqrt_decay"
OPTIMIZER="Adafactor"
DROPOUT=0.0

MODEL_ROOT=

PROBLEM="translate_encs_wmt_czeng57m32k"
MODEL="transformer"
HPARAMS_SET="transformer_big_single_gpu"


print_usage () {
    echo ""
    echo "      Usage:"
    echo "          $0 -m MODEL_DIR [OPTION]"
    echo ""
    echo "      -m, --model-dir PATH"
    echo "          model directory (output of prepare_data.sh)"
    echo "      --gpus INT"
    echo "          number of gpus used for training (default=$GPUS)"
    echo "      --steps INT"
    echo "          number of training steps (default=$TRAIN_STEPS)"
    echo "      --max-checkpoints INT"
    echo "          how many checkpoints to keep (default=$NUM_KEEP_CHECKPOINTS)"
    echo "      --batch-size INT"
    echo "          size of a training batch (default=$BATCH_SIZE)"
    echo "      --max-len INT"
    echo "          maximum sentence lenght (default=$MAX_LEN)"
    echo "      --lr NUM"
    echo "          learning rate (default=$LR)"
    echo "      --lr-warmup INT"
    echo "          number of warmup steps (default=$LR_WARMUP)"
    echo "      --lr-schedule STRING"
    echo "          type learning rate schedule (default=$LR_SCHEDULE)"
    echo "      --optimizer STRING"
    echo "          type of optimizer (default=$OPTIMIZER)"
    echo "      --dropout NUM"
    echo "          dropout keep probability (default=$DROPOUT)"
    echo "      -p, --problem STRING"
    echo "          name of the problem (default=$PROBLEM)"
    echo ""
    exit 1
}


# Parsing parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -m|--model-dir)
            MODEL_ROOT="$2"
            shift
        ;;
        --gpus)
            GPUS="$2"
            shift
        ;;
        --steps)
            TRAIN_STEPS="$2"
            shift
        ;;
        --max-checkpoints)
            NUM_KEEP_CHECKPOINTS="$2"
            shift
        ;;
        --batch-size)
            BATCH_SIZE="$2"
            shift
        ;;
        --max-len)
            MAX_LEN="$2"
            shift
        ;;
        --lr)
            LR="$2"
            shift
        ;;
        --lr-warmup)
            LR_WARMUP="$2"
            shift
        ;;
        --lr-schedule)
            LR_SCHEDULE="$2"
            shift
        ;;
        --optimizer)
            OPTIMIZER="$2"
            shift
        ;;
        --dropout)
            DROPOUT="$2"
            shift
        ;;
        -p|--problem)
            PROBLEM="$2"
            shift
        ;;
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done

[[ -n "$MODEL_ROOT" ]] && [[ -d "$MODEL_ROOT" ]] || print_usage
[[ -e "$MODEL_ROOT/finished" ]] && rm $MODEL_ROOT/finished

# Setting up directories
DATA_DIR=$MODEL_ROOT/data
TMP_DIR=$MODEL_ROOT/tmp_dir
USER_DIR=$MODEL_ROOT/user_dir
MODEL_DIR=$MODEL_ROOT/model

# Setting up hparams
HPARAMS="batch_size=$BATCH_SIZE"
HPARAMS="$HPARAMS,learning_rate=$LR"
HPARAMS="$HPARAMS,learning_rate_warmup_steps=$LR_WARMUP"
HPARAMS="$HPARAMS,max_length=$MAX_LEN"
HPARAMS="$HPARAMS,optimizer=$OPTIMIZER"
HPARAMS="$HPARAMS,learning_rate_schedule=$LR_SCHEDULE"
HPARAMS="$HPARAMS,layer_prepostprocess_dropout=$DROPOUT"

# Running training
export PYTHONUNBUFFERED=yes
export PYTHONPATH="$WD/../tensor2tensor-1.6.6":$PYTHONPATH

echo "Running: $T2T_BIN/t2t-trainer --t2t_usr_dir=$USER_DIR --data_dir=$DATA_DIR --problem=$PROBLEM --model=$MODEL --hparams_set=$HPARAMS_SET --hparams=$HPARAMS --output_dir=$MODEL_DIR --train_steps=$TRAIN_STEPS --local_eval_frequency=10000 --schedule=train --keep_checkpoint_max=$NUM_KEEP_CHECKPOINTS --worker_gpu=$GPUS" >&2
$T2T_BIN/t2t-trainer \
    --t2t_usr_dir=$USER_DIR \
    --data_dir=$DATA_DIR \
    --problem=$PROBLEM \
    --model=$MODEL \
    --hparams_set=$HPARAMS_SET \
    --hparams=$HPARAMS \
    --output_dir=$MODEL_DIR \
    --train_steps=$TRAIN_STEPS \
    --local_eval_frequency=10000 \
    --schedule=train \
    --keep_checkpoint_max=$NUM_KEEP_CHECKPOINTS \
    --worker_gpu=$GPUS

echo Finished > $MODEL_DIR/finished
