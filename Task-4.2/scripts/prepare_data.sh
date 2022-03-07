#!/bin/bash
CUDA=9.0
CUDNN=7.1

set -e

# Tested with the following virtualenv
#source /net/me/merkur3/varis/tensorflow-virtualenv/tensorflow-1.12-gpu/bin/activate


# Default parameter values
GPUS=0
SRC_TRAIN_PATH=""
TGT_TRAIN_PATH=""
SRC_DEV_PATH=""
TGT_DEV_PATH=""
OUTPUT_PATH=""

# Constants
USER_DIR_PATH="/home/varis/tspec-workdir/t2t-lindat/user_dir"
#PROBLEM="translate32k"
PROBLEM="translate_encs_wmt_czeng57m32k"


print_usage () {
    echo ""
    echo "      Usage:"
    echo "      $0 -s SOURCE_CORPUS -t TARGET_CORPUS -o OUTPUT_PATH [OPTIONS]"
    echo ""
    echo "      -s, --train-src PATH"
    echo "          path to the source-side training corpus"
    echo "      -t, --train-tgt PATH"
    echo "          path to the target-side training corpus"
    echo "      -o, --output-path PATH"
    echo "          output path of the data generated for model training"
    echo "      -u, --user-dir PATH"
    echo "          directory containing the custom problem definitions"
    echo "      -p, --problem-name STRING"
    echo "          name of the problem"
    echo "      --dev-src PATH"
    echo "          path to the source-side validation corpus"
    echo "      --dev-tgt PATH"
    echo "          path to the target-side validation corpus"
    echo ""
    exit 1
}


# Parsing parameters
while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -s|--train-src)
            SRC_TRAIN_PATH="$2"
            shift
        ;;
        -t|--train-tgt)
            TGT_TRAIN_PATH="$2"
            shift
        ;;
        -o|--output-path)
            OUTPUT_PATH="$2"
            shift
        ;;
        -u|--user-dir)
            USER_DIR_PATH="$2"
            shift
        ;;
        -p|--problem-name)
            PROBLEM="$2"
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
        --gpus)
            GPUS="$2"
            shift
        ;;
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done

# Source correct virtualenv and (optional) set paths to CUDA libraries
if [[ $GPUS -eq 0 ]]; then
    echo "--gpus 0: Activating virtualenv..."
    source $HOME/python-virtualenv/tensorflow-1.12-cpu/bin/activate
else
    echo "--gpus > 0: Activating virtualenv and setting CUDA variables..."
    source $HOME/python-virtualenv/tensorflow-1.12-gpu/bin/activate
    PATH=/opt/cuda/$CUDA/bin:
    LD_LIBRARY_PATH=/opt/cuda/$CUDA/cudnn/$CUDNN/lib64:$LD_LIBRARY_PATH
    LD_LIBRARY_PATH=/opt/cuda/$CUDA/extras/CUPTI/lib64:$LD_LIBRARY_PATH
    LD_LIBRARY_PATH=/opt/cuda/$CUDA/lib64:$LD_LIBRARY_PATH
fi

# Testing (required) parameter values
if [[ ( ! -e "$SRC_TRAIN_PATH" || ! -e "$TGT_TRAIN_PATH" ) ]]; then
    print_usage
fi
[[ -n "$OUTPUT_PATH" ]] || print_usage
[[ -d "$USER_DIR_PATH" ]] || print_usage


# Setting up directories
echo "Creating directories..."
[[ -d $OUTPUT_PATH ]] && rm -r $OUTPUT_PATH
mkdir -p $OUTPUT_PATH

DATA_DIR=$OUTPUT_PATH/data
TMP_DIR=$OUTPUT_PATH/tmp_dir
USER_DIR=$OUTPUT_PATH/user_dir

mkdir $DATA_DIR
mkdir $TMP_DIR
ln -s $USER_DIR_PATH $OUTPUT_PATH/user_dir

ln -s $SRC_TRAIN_PATH $TMP_DIR/train.src
ln -s $TGT_TRAIN_PATH $TMP_DIR/train.tgt

if [[ ( -e "$SRC_DEV_PATH" && -e "$TGT_DEV_PATH" ) ]]; then
    ln -s $SRC_DEV_PATH $TMP_DIR/dev.src
    ln -s $TGT_DEV_PATH $TMP_DIR/dev.tgt
fi


# Running datagen
export PYTHONUNBUFFERED=yes
export PYTHONPATH="`pwd`/tensor2tensor-1.6.6":$PYTHONPATH

echo "Running: tensor2tensor-1.6.6/tensor2tensor/bin/t2t-datagen --t2t_usr_dir=$USER_DIR --data_dir=$DATA_DIR --tmp_dir=$TMP_DIR --problem=$PROBLEM" >&2
tensor2tensor-1.6.6/tensor2tensor/bin/t2t-datagen \
    --t2t_usr_dir=$USER_DIR \
    --data_dir=$DATA_DIR \
    --tmp_dir=$TMP_DIR \
    --problem=$PROBLEM
