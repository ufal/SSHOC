Scripts for Task 4.2

**General Directory Structure:**
- **data/** - Directory containing scripts for data download + preprocessing. The datasets are also stored here after download.
- **scripts/** - Scripts for the training, validation and other utilities.
- **wrappers/** - Wrappers for the final evaluation.

**1. Download data + filter + shuffle:**
```
# for langpair in de ru; do ...
1. Download the WMT corpora
    $ data/prepare-wmt.${src}-en.sh
2. Download the MCSQ corpora
    $ data/prepare-mcsq.sh $src
3. Combine the WMT-MCSQ corpora
    $ data/prepare-wmt-mcsq.sh $src
4. Backtranslate the English-sentences in the MCSQ coprora (requires $model)
    $ data/prepare-mcsq-bt.sh $model $src
5. Combine the backtranslated and authentic corpora
    $ data/prepare-mcsq-with-bt.sh $src  # MCSQ + bt
    $ data/prepare-wmt-mcsq-with-bt.sh $src  # WMT + MCSQ + bt
```

**2. Binarize the datasets:**
- **scripts/prepare_data.sh**
```
    Usage:
        $ scripts/prepare_data.sh -s SOURCE_CORPUS -t TARGET_CORPUS -o OUTPUT_PATH [OPTIONS]

    Options:
        -s, --train-src PATH
            path to the source-side training corpus
        -t, --train-tgt PATH
            path to the target-side training corpus
        -o, --output-path PATH
            output path of the data generated for model training
        -u, --user-dir PATH
            directory containing the custom problem definitions
        -p, --problem-name STRING
            name of the problem
        --dev-src PATH
            path to the source-side validation corpus
        --dev-tgt PATH
            path to the target-side validation corpus
```

**3. Train the model:**
- **scripts/train.sh**
```
    Usage:
        $ scripts/train.sh -o OUTPUT_PATH [OPTION]

    Options:
        -o, --output-path PATH
            model directory (output of prepare_data.sh)
        --gpus INT
            number of gpus used for training (default=1)
        --steps INT
            number of training steps (default=6000000)
        --max-checkpoints INT
            how many checkpoints to keep (default=20)
        --batch-size INT
            size of a training batch (default=2900)
        --max-len INT
            maximum sentence lenght (default=150)
        --lr NUM
            learning rate (default=0.2)
        --lr-warmup INT
            number of warmup steps (default=8000)
        --lr-schedule STRING
            type learning rate schedule (default=rsqrt_decay)
        --optimizer STRING
            type of optimizer (default=Adafactor)
        --dropout NUM
            dropout keep probability (default=0.0)
```

**4. (optional) Run validation during training:**
- **scripts/validate.sh**
```
    Usage:
        scripts/validate.sh -o OUTPUT_PATH --dev-src SOURCE_DEVSET --dev-tgt TARGET_DEVSET --[OPTION]

    Options:
        -o, --output-path FILE
            model directory (output of prepare_data.sh)
        --dev-src FILE
            path to the source-side validation corpus
        --dev-tgt FILE
            path to the target-side validation corpus
        -a, --alpha NUM
            beamsearch length penalty (default=0.6)
        -b, --beam-size INT
            beam size (default=4)
        --max-len INT
            maximum sentence length (default=150)
        --n-checkpoints INT
            number of checkpoints to average for evaluation (default=8)
```

**5. Export (using TF Serving)**
- **scripts/export.sh**
```
    Usage:
        $ scripts/export.sh -o OUTPUT_PATH --[OPTION]

    Options:
        -o, --output-path PATH
            model directory (output of prepare_data.sh)
        -a, --alpha NUM
            beamsearch length penalty (default=0.6)
        -b, --beam-size
            beam size (default=4)
        --opts STRING
            additional options
```
