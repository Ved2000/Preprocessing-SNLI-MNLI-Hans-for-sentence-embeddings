 Copyright (c) 2017-present, Facebook, Inc.
# All rights reserved.
#
# This source code is licensed under the license found in the
# LICENSE file in the root directory of this source tree.
#

#
# Download and tokenize data with MOSES tokenizer
#

data_path=.
preprocess_exec=./tokenizer.sed

# Get MOSES
echo 'Cloning Moses github repository (for tokenization scripts)...'
git clone https://github.com/moses-smt/mosesdecoder.git
SCRIPTS=mosesdecoder/scripts
MTOKENIZER=$SCRIPTS/tokenizer/tokenizer.perl
LOWER=$SCRIPTS/tokenizer/lowercase.perl

if [ ! -d "$SCRIPTS" ]; then
    echo "Please set SCRIPTS variable correctly to point to Moses scripts."
    exit
fi

PTBTOKENIZER="sed -f tokenizer.sed"

mkdir $data_path


SNLI='https://nlp.stanford.edu/projects/snli/snli_1.0.zip'
MNLI='https://www.nyu.edu/projects/bowman/multinli/multinli_0.9.zip'



### download MNLI
mkdir $data_path/MNLI
curl -Lo $data_path/MNLI/multinli_1.0.zip $MNLI
unzip $data_path/MNLI/multinli_1.0.zip -d $data_path/MNLI
rm $data_path/MNLI/multinli_1.0.zip
rm -r $data_path/MNLI/__MACOSX

for split in train dev test
do
    fpath=$data_path/MNLI/$split.multinli.txt
    awk '{ if ( $1 != "-" ) { print $0; } }' $data_path/MNLI/multinli_1.0/multinli_1.0_$split.txt | cut -f 1,6,7 | sed '1d' > $fpath
    cut -f1 $fpath > $data_path/SNLI/labels.$split
    cut -f2 $fpath | $PTBTOKENIZER > $data_path/MNLI/s1.$split
    cut -f3 $fpath | $PTBTOKENIZER > $data_path/MNLI/s2.$split
    rm $fpath
done
rm -r $data_path/MNLI/multinli_1.0







# remove moses folder
rm -rf mosesdecoder
