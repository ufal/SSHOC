#!/bin/bash
set -e

WD=`dirname "$(readlink -f "$0")"`  # location of the script
T2T_BIN="$WD/../tensor2tensor-1.6.6/tensor2tensor/bin"

# Default parameter values
SRC_TRAIN_PATH=""
TGT_TRAIN_PATH=""
SRC_DEV_PATH=""
TGT_DEV_PATH=""
OUTPUT_PATH=""

USER_DIR_PATH="$WD/../user_dir"
PROBLEM="translate_encs_wmt_czeng57m32k"


print_usage () {
    echo ""
    echo "      Usage:"
    echo "          $0 -s SOURCE_CORPUS -t TARGET_CORPUS -o OUTPUT_PATH [OPTION]"
    echo ""
    echo "      -s, --train-src PATH"
    echo "          path to the source-side training corpus"
    echo "      -t, --train-tgt PATH"
    echo "          path to the target-side training corpus"
    echo "      -o, --output-path PATH"
    echo "          output path of the data generated for model training"
    echo "      -u, --user-dir PATH"
    echo "          directory containing the custom problem definitions (default=$USER_DIR_PATH)"
    echo "      -p, --problem STRING"
    echo "          name of the problem (default=$PROBLEM)"
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
        -p|--problem)
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
        *)
            echo Unknown option '"'$key'"' >&2
            exit 1
        ;;
    esac
    shift
done


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
export PYTHONPATH="$WD/../tensor2tensor-1.6.6":$PYTHONPATH

echo "Running: $T2T_BIN/t2t-datagen --t2t_usr_dir=$USER_DIR --data_dir=$DATA_DIR --tmp_dir=$TMP_DIR --problem=$PROBLEM" >&2
$T2T_BIN/t2t-datagen \
    --t2t_usr_dir=$USER_DIR \
    --data_dir=$DATA_DIR \
    --tmp_dir=$TMP_DIR \
    --problem=$PROBLEM
