import os
from tensor2tensor.utils import registry
from tensor2tensor.data_generators import translate, problem, text_encoder, generator_utils

_DATASETS = {
    "train": [["", ("train.src","train.tgt")]],
    "dev": [["", ("dev.src", "dev.tgt")]]}


# NOTE problem name is based on current models on Lindat
@registry.register_problem
class TranslateEncsWmtCzeng57m32k(translate.TranslateProblem):
    """Problem spec for translation."""

    @property
    def targeted_vocab_size(self):
        return 2**15  # 32768

    @property
    def vocab_name(self):
        return "vocab.wp"

    def generator(self, data_dir, tmp_dir, train):
        tag = "train" if train else "dev"
        data_path = translate.compile_data(
            tmp_dir,
            _DATASETS[tag],
            "{}_tok".format(tag))
        symbolizer_vocab = generator_utils.get_or_generate_vocab(
            data_dir, tmp_dir, self.vocab_file, self.targeted_vocab_size,
            _DATASETS[tag])
        return translate.token_generator(
            data_path + ".lang1", data_path + ".lang2",
            symbolizer_vocab, text_encoder.EOS_ID)

    def source_data_files(self, dataset_split):
        train = dataset_split == problem.DatasetSplit.TRAIN
        return _DATASETS["train"] if train else _DATASETS["dev"]
