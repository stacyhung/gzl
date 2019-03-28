#!/bin/bash

# This script reads in file (e.g. tumors.txt), and reference file (e.g. Reference.cnn)
# For each line of the list of tumors (a sample id), the cnvkit "fix" function is applied
# to the sample using <sample>.targetcoverage.cnn and <sample>.antitargetcoverage.cnn
# along with the pooled normal reference, Reference.cnn
#
# Output: A table of copy number ratios (.cnr)

# How to run this script: from the project folder, ./scripts/cnvkit_fix_samples.sh samples.txt

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "To apply cnvkit fix for sample: $line"
    #/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py fix coverage/tumors/$line.targetcoverage.cnn coverage/tumors/$line.antitargetcoverage.cnn Reference.cnn -o cnr/$line.cnr
    /Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py fix coverage/tumors/$line.targetcoverage.cnn coverage/tumors/$line.antitargetcoverage.cnn $2 -o cnr/$line.cnr
    /Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py segment cnr/$line.cnr -o cns/$line.cns --drop-low-coverage
done < "$1"

