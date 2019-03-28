#!/bin/bash

# This script reads in file (e.g. normals.txt),
# and for each line (a sample id), calculates the coverage
# for the sample in bam/<sample_id>.bam.

# How to run this script: from the project folder, ./scripts/get_coverage_for_bams.sh samples.txt

# for each sample
# go into bam/
# calculate coverage

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "To calculate cnvkit coverage for sample: $line"
    /Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py coverage bam/normals/$line.bam baits.target.bed -o coverage/normals/$line.targetcoverage.cnn
    /Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py coverage bam/normals/$line.bam baits.antitarget.bed -o coverage/normals/$line.antitargetcoverage.cnn
done < "$1"

