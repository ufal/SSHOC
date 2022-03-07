#!/bin/bash
set -e

VENV="/home/varis/python-virtualenv/tensorflow-1.12-cpu"
T2T_BIN="tensor2tensor-1.6.6/tensor2tensor/bin"

INPUT_FILE="/dev/stdin"
OUTPUT_FILE="/dev/stdout"

BEAM_SIZE=4
ALPHA=1.0
N_CHECKPOINTS=8

MODEL_ROOT=

PROBLEM="translate_encs_wmt_czeng57m32k"
MODEL="transformer"
HPARAMS_SET="transformer_big_single_gpu"
HPARAMS=

while [[ $# -gt 0 ]]; do
    key="$1"
    case $key in
        -i|--input)
            INPUT_FILE="$2"
            shift
        ;;
        -o|--output)
            OUTPUT_FILE="$2"
            shift
        ;;
        -m|--model-dir)
            MODEL_ROOT="$2"
            shift
        ;;
        --beam-size)
            BEAM_SIZE="$2"
            shift
        ;;
        --alpha)
            ALPHA="$2"
            shift
        ;;
        --problem)
            PROBLEM="$2"
            shift
        ;;
        --hparams)
            HPARAMS="$2"
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

DATA_DIR=$MODEL_ROOT/data
TMP_DIR=$MODEL_ROOT/tmp_dir
USER_DIR=$MODEL_ROOT/user_dir
MODEL_DIR=$MODEL_ROOT/model

source $VENV/bin/activate
export PYTHONUNBUFFERED=yes
export PYTHONPATH="`pwd`/tensor2tensor-1.6.6":$PYTHONPATH
export LD_LIBRARY_PATH=/opt/cuda/9.0/cudnn/7.0/lib64:/opt/cuda/9.0/cudnn/7.0/lib64:/home/varis/.local/lib:/usr/lib

if [[ $N_CHECKPOINTS -gt 1 ]]; then
    mkdir -p $MODEL_DIR/averaged
    $T2T_BIN/t2t-avg-all \
        --model_dir=$MODEL_DIR \
        --output_dir=$MODEL_DIR/averaged \
        --n=$N_CHECKPOINTS \
        --wait_minutes=1
    pid_avg=$!
    MODEL_DIR=$MODEL_DIR/averaged

    sleep 30s

    # Wait for the averaging to finish
    while true; do ps -p "$pid_avg" > /dev/null 2>&1 || break; sleep 1m; done
fi

echo "Running: tensor2tensor-1.6.6/tensor2tensor/bin/t2t-decoder --t2t_usr_dir=$USER_DIR --data_dir=$DATA_DIR --problem=$PROBLEM --model=$MODEL --hparams_set=$HPARAMS_SET --hparams=$HPARAMS --output_dir=$MODEL_DIR --decode_hparams=\"beam_size=$BEAM_SIZE,alpha=$ALPHA,write_beam_scores=False,return_beams=False\" --decode_from_file=$INPUT_FILE --decode_to_file=$OUTPUT_FILE"
$T2T_BIN/t2t-decoder \
	--t2t_usr_dir=$USER_DIR \
	--data_dir=$DATA_DIR \
    --problem=$PROBLEM \
	--model=$MODEL \
	--hparams_set=$HPARAMS_SET \
    --hparams=$HPARAMS \
	--output_dir=$MODEL_DIR \
	--decode_hparams="beam_size=$BEAM_SIZE,alpha=$ALPHA,write_beam_scores=False,return_beams=False" \
	--decode_from_file=$INPUT_FILE \
    --decode_to_file=$OUTPUT_FILE
