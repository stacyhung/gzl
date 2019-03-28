#!/bin/bash

# This script reads in file (e.g. tumors.txt),
# and for each line (a sample id), generates plots and graphics
# for the sample with cnr and cns data

# How to run this script: from the project folder, ./scripts/visualize.sh samples.txt

# for each sample
# go into cnr/ and cns/
# generate plots

while IFS='' read -r line || [[ -n "$line" ]]; do
    echo "To generate visualizations for sample: $line"
    /Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py scatter --y-min=-4 --y-max=4 cnr/$line.cnr -s cns/$line.cns -o figures/scatter/$line-scatter.png
    #/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py diagram cnr/autobin/$line.cnr -s cns/autobin/$line.cns -o figures/scatter/$line-diagram.png
done < "$1"

