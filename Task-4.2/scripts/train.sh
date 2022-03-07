#!/bin/bash

# TODO:
# -- add early stopping

set -e

# Tested with the following virtualenv
#source /net/me/merkur3/varis/tensorflow-virtualenv/tensorflow-1.12-gpu/bin/activate

# Set CUDA
CUDA=9.0
CUDNN=7.1
export PATH=/opt/cuda/$CUDA/bin:$PATH
export LD_LIBRARY_PATH=/opt/cuda/$CUDA/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/cuda/$CUDA/extras/CUPTI/lib64:$LD_LIBRARY_PATH
export LD_LIBRARY_PATH=/opt/cuda/$CUDA/cudnn/$CUDNN/lib64:$LD_LIBRARY_PATH

# Default parameter values
OUTPUT_PATH=""
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

# Constants
USER_DIR_PATH="/home/varis/tspec-workdir/t2t-lindat/user_dir"
PROBLEM="translate_encs_wmt_czeng57m32k"
MODEL="transformer"
HPARAMS_SET="transformer_big_single_gpu"


print_usage () {
    echo ""
    echo "      Usage:"
    echo "      $0 -o OUTPUT_PATH [OPTION]"
    echo ""
    echo "      -o, --output-path PATH"
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
    echo ""
    exit 1
}


#--eval_early_stopping_metric=loss
#--eval_early_stopping_metric_delta=0.1
#--eval_early_stopping_steps=None
#--eval_early_stopping_metric_minimize=True
#--eval_run_autoregressive=False

#--keep_checkpoint_every_n_hours=12
#--save_checkpoints_secs=3600


# Parsing parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -o|--output-path)
            OUTPUT_PATH="$2"
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
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done

[[ -n "$OUTPUT_PATH" ]] && [[ -d "$OUTPUT_PATH" ]] || print_usage
[[ -e "$OUTPUT_PATH/finished" ]] && rm $OUTPUT_PATH/finished

# Setting up directories
DATA_DIR=$OUTPUT_PATH/data
TMP_DIR=$OUTPUT_PATH/tmp_dir
USER_DIR=$OUTPUT_PATH/user_dir
MODEL_DIR=$OUTPUT_PATH/model

# Setting up hparams
HPARAMS="batch_size=$BATCH_SIZE"
HPARAMS="$HPARAMS,learning_rate=$LR"
HPARAMS="$HPARAMS,learning_rate_warmup_steps=$LR_WARMUP"
HPARAMS="$HPARAMS,max_length=$MAX_LEN"
HPARAMS="$HPARAMS,optimizer=$OPTIMIZER"
HPARAMS="$HPARAMS,learning_rate_schedule=$LR_SCHEDULE"
HPARAMS="$HPARAMS,layer_prepostprocess_dropout=$DROPOUT"

# Running datagen
export PYTHONUNBUFFERED=yes
export PYTHONPATH="`pwd`/tensor2tensor-1.6.6":$PYTHONPATH

echo "Running: tensor2tensor-1.6.6/tensor2tensor/bin/t2t-trainer --t2t_usr_dir=$USER_DIR --data_dir=$DATA_DIR --problem=$PROBLEM --model=$MODEL --hparams_set=$HPARAMS_SET --hparams=$HPARAMS --output_dir=$MODEL_DIR --train_steps=$TRAIN_STEPS --local_eval_frequency=10000 --schedule=train --keep_checkpoint_max=$NUM_KEEP_CHECKPOINTS --worker_gpu=$GPUS" >&2
tensor2tensor-1.6.6/tensor2tensor/bin/t2t-trainer \
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
