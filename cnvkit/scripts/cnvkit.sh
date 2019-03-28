#!/bin/bash

# This script is for the GZL exomes project, specifically dealing with copy number calling using cnvkit
# Date: March 11, 2019
# Author: Stacy Hung <shung@bccrc.ca>

cd /Volumes/shung/projects/gzl_exomes/cnvkit

# Step 1. Create BED files for targets and "antitargets"
# -g / --access option removes "inaccessible" regions by examining "accessible" regions (defined in access-5kb-mappable.hg19.bed)
cnvkit target baits.bed --annotate refFlat.txt --split -o targets.bed			# annotate target regions with gene names
cnvkit antitarget targets.bed -g access-5kb-mappable.hg19.bed -o antitargets.bed	# "access" file precomputed for UCSC hg19

# Step 1.1. Calculate sequence-accessible coordinates in chromosomes from the given ref genome, and output as BED file
# -x option specifies other known unmappable or poorly sequenced regions for exclusion
cnvkit access hg19.fa -x excludes.bed -o access-hg19.bed

# Step 2. Estimate reasonable on- and off-target bin sizes - if multiple bams, use the BAM with median size
# from our 116 bam files, the median file size is 6.8 GB (e.g. PA007.bam)
cnvkit autobin bam/176T.bam -t baits.bed -g access-5kb-mappable.hg19.bed --annotate refFlat.txt

# the output of this command generates baits.targets.bed and baits.antitargets.bed 
# (that presumably has average bin size closer to the recommended bin size)
# Based on 176T.bam, recommended bin size: 1,510bp (@66X) [on-target] and 11,306(@9X) [off-target]

# Step 3. Calculate target and antitarget coverage for all samples
# 3A. calculate coverage for tumor samples (for the "fix" step)
./scripts/get_cnvkit_coverage_for_tumor_bams.sh tumors.part1.txt

# 3B. calculate coverage for normal samples (to be used to create a pooled normal)
./scripts/get_cnvkit_coverage_for_normal_bams.sh normals.part1.txt

# Step 4. Create a reference by pooling coverage files for normals (recommended)
# 	  The -f option allows use of a reference genome to calculate GC content 
# 	  and the repeat-masked proportion of each region
# http://cnvkit.readthedocs.io/en/latest/pipeline.html#how-it-works

# create reference for all LMD samples (except GZ180) using only LMD normals
cnvkit reference coverage/normals/*coverage.cnn -f ucsc.hg19.fa -o Reference.LMD.cnn
# create separate reference for GZ180 (since tumor is FFPE, not LMD)
cnvkit reference coverage/normals/constitutional/GZ180*coverage.cnn -f ucsc.hg19.fa -o Reference.GZ180.cnn
# also try reference for GZ180, but pooling all constitutional normals
cnvkit reference coverage/normals/constitutional/*coverage.cnn -f ucsc.hg19.fa -o Reference.const.cnn

# Step 5. "Fix" - combine the uncorrected target and antitarget coverage tables (.cnn) and
# 	  correct for biases in regional coverage and GC content, according to the given reference.
# 	  Output: table of copy number ratios (.cnr)
# For each tumor sample...
./scripts/cnvkit_fix_and_segment_tumor_samples.sh tumors.LMD.txt Reference.LMD.cnn
./scripts/cnvkit_fix_and_segment_tumor_samples.sh tumors.GZ180.txt Reference.GZ180.cnn
./scripts/cnvkit_fix_and_segment_tumor_samples.sh tumors.GZ180.txt Reference.const.cnn

# Step 6. Call copy number.

./scripts/cnvkit_call_with_tumor_content-raw_values.sh

# Note that "-y" does not necessarily mean a male gender -- cnvkit performs automatic gender adjustment based on sample

# Call absolute (integer) copy number (default thresholds: -1.1 => 0, -0.25 => 1, 0.2 => 2, 0.7 => 3)
cnvkit.py call Sample.cns -o Sample.call.cns
# Call with user-specified thresholds
cnvkit.py call Sample.cns -y -m threshold -t=-1.1,-0.4,0.3,0.7 -o Sample.call.cns
# Call with a given known tumor cell fraction and normal ploidy
cnvkit.py call Sample.cns -y -m clonal --purity 0.65 -o Sample.call.cns
# Call with a given known tumor cell fraction and normal ploidy, and estimate b-allele frequencies using snps from a vcf file
cnvkit.py call Sample.cns -y -v Sample.vcf -m clonal --purity 0.7 -o Sample.call.cns

# Step 6. List targeted genes in which a segmentation breakpoint occurs
cnvkit.py breaks Sample.cnr Sample.cns

# Step 7. (optional) Metrics to see if any samples are "noisy": (http://cnvkit.readthedocs.io/en/latest/reports.html#metrics)
# A good qc metric: [number of segments] x [biweight midvariance] ~ higher in unreliable samples
#cnvkit metrics cnr/autobin/*cnr -s cns/autobin/*cns
cnvkit metrics cnr/*.cnr -s cns/*.cns > metrics/cnvkit_metrics.txt

# Step 8. Visualize (scatter and diagram plots)
./scripts/visualize.sh tumors.LMD.txt

# specific genes of interest
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -g REL -o figures/scatter/HRS.REL.scatter.pdf

# specific chr with GOI highlighted
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr2 -g REL -o figures/scatter/HRS.chr2.REL.scatter.pdf # REL (chr2)
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr14 -g NFKBIA -o figures/scatter/HRS.chr14.NFKBIA.scatter.pdf # NFKBIA (chr14)
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr6 -g NFKBIE,TNFAIP3 -o figures/scatter/HRS.chr6.NFKBIE.scatter.pdf # NFKBIE, TNPAIP3 (chr 6)
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr19 -g BCL3 -o figures/scatter/HRS.chr19.BCL3.scatter.pdf # BCL3 (chr 19)
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr9 -g JAK2,CDKN2 -o figures/scatter/HRS.chr9.JAK2.scatter.pdf # JAK2,CDKN2 (chr 9)
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr12 -g MDM2 -o figures/scatter/HRS.chr13.MDM2.scatter.pdf # MDM2 (chr 13)
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content/HRS.cns -c chr10 -g FAS -o figures/scatter/HRS.chr10.FAS.scatter.pdf # FAS (chr 10)

# chr 2 and chr 9 for all samples
cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content_est_recurrent_genes/HRS.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/HRS.chr2.scatter.png
cnvkit scatter cnr/cHLsort22HRS.cnr -s call/with_tumor_content_est_recurrent_genes/cHLsort22HRS.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/cHLsort22HRS.chr2.scatter.png
cnvkit scatter cnr/cHLsort06HRS.cnr -s call/with_tumor_content_est_recurrent_genes/cHLsort06HRS.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/cHLsort06HRS.chr2.scatter.png
cnvkit scatter cnr/cHLsort19HRS.cnr -s call/with_tumor_content_est_recurrent_genes/cHLsort19HRS.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/cHLsort19HRS.chr2.scatter.png
cnvkit scatter cnr/cHL-SORT15-HRS3.cnr -s call/with_tumor_content_est_recurrent_genes/cHL-SORT15-HRS3.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/cHL-SORT15-HRS3.chr2.scatter.png
cnvkit scatter cnr/cHL-SORT-06HRSc-DNA.cnr -s call/with_tumor_content_est_recurrent_genes/cHL-SORT-06HRSc-DNA.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/cHL-SORT-06HRSc-DNA.chr2.scatter.png
cnvkit scatter cnr/cHL-SORT-19HRSb-DNA.cnr -s call/with_tumor_content_est_recurrent_genes/cHL-SORT-19HRSb-DNA.cns -c chr2 -g REL -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr2/cHL-SORT-19HRSb-DNA.chr2.scatter.png

cnvkit scatter cnr/HRS.cnr -s call/with_tumor_content_est_recurrent_genes/HRS.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/HRS.chr9.scatter.png
cnvkit scatter cnr/cHLsort22HRS.cnr -s call/with_tumor_content_est_recurrent_genes/cHLsort22HRS.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/cHLsort22HRS.chr9.scatter.png
cnvkit scatter cnr/cHLsort06HRS.cnr -s call/with_tumor_content_est_recurrent_genes/cHLsort06HRS.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/cHLsort06HRS.chr9.scatter.png
cnvkit scatter cnr/cHLsort19HRS.cnr -s call/with_tumor_content_est_recurrent_genes/cHLsort19HRS.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/cHLsort19HRS.chr9.scatter.png
cnvkit scatter cnr/cHL-SORT15-HRS3.cnr -s call/with_tumor_content_est_recurrent_genes/cHL-SORT15-HRS3.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/cHL-SORT15-HRS3.chr9.scatter.png
cnvkit scatter cnr/cHL-SORT-06HRSc-DNA.cnr -s call/with_tumor_content_est_recurrent_genes/cHL-SORT-06HRSc-DNA.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/cHL-SORT-06HRSc-DNA.chr9.scatter.png
cnvkit scatter cnr/cHL-SORT-19HRSb-DNA.cnr -s call/with_tumor_content_est_recurrent_genes/cHL-SORT-19HRSb-DNA.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity_est_recurrent_genes/chr9/cHL-SORT-19HRSb-DNA.chr9.scatter.pngyy

# ZYX (chr7); CTGF (chr6); TNFRSF14 / PRKCZ / TP73 (chr1); JAK2 (chr9) in 4 samples (from sort06 and sort19 - hyper and non-hyper versions, and based on cnvkit results where tumor purity is estimated from allele frequency)
cnvkit scatter cnr/cHL-SORT-06HRSc-DNA.cnr -s call/with_tumor_content/cHL-SORT-06HRSc-DNA.cns -c chr1 -g TNFRSF14,PRKCZ,TP73 -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-06HRSc-DNA.chr1.scatter.png
cnvkit scatter cnr/cHL-SORT-19HRSb-DNA.cnr -s call/with_tumor_content/cHL-SORT-19HRSb-DNA.cns -c chr1 -g TNFRSF14,PRKCZ,TP73 -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-19HRSb-DNA.chr1.scatter.png
cnvkit scatter cnr/cHLsort06HRS.cnr -s call/with_tumor_content/cHLsort06HRS.cns -c chr1 -g TNFRSF14,PRKCZ,TP73 -o figures/scatter/rescaled_for_tumor_purity/cHLsort06HRS.chr1.scatter.png
cnvkit scatter cnr/cHLsort19HRS.cnr -s call/with_tumor_content/cHLsort19HRS.cns -c chr1 -g TNFRSF14,PRKCZ,TP73 -o figures/scatter/rescaled_for_tumor_purity/cHLsort19HRS.chr1.scatter.png

cnvkit scatter cnr/cHL-SORT-06HRSc-DNA.cnr -s call/with_tumor_content/cHL-SORT-06HRSc-DNA.cns -c chr6 -g CTGF -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-06HRSc-DNA.chr6.scatter.png
cnvkit scatter cnr/cHL-SORT-19HRSb-DNA.cnr -s call/with_tumor_content/cHL-SORT-19HRSb-DNA.cns -c chr6 -g CTGF -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-19HRSb-DNA.chr6.scatter.png
cnvkit scatter cnr/cHLsort06HRS.cnr -s call/with_tumor_content/cHLsort06HRS.cns -c chr6 -g CTGF -o figures/scatter/rescaled_for_tumor_purity/cHLsort06HRS.chr6.scatter.png
cnvkit scatter cnr/cHLsort19HRS.cnr -s call/with_tumor_content/cHLsort19HRS.cns -c chr6 -g CTGF -o figures/scatter/rescaled_for_tumor_purity/cHLsort19HRS.chr6.scatter.png

cnvkit scatter cnr/cHL-SORT-06HRSc-DNA.cnr -s call/with_tumor_content/cHL-SORT-06HRSc-DNA.cns -c chr7 -g ZYX -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-06HRSc-DNA.chr7.scatter.png
cnvkit scatter cnr/cHL-SORT-19HRSb-DNA.cnr -s call/with_tumor_content/cHL-SORT-19HRSb-DNA.cns -c chr7 -g ZYX -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-19HRSb-DNA.chr7.scatter.png
cnvkit scatter cnr/cHLsort06HRS.cnr -s call/with_tumor_content/cHLsort06HRS.cns -c chr7 -g ZYX -o figures/scatter/rescaled_for_tumor_purity/cHLsort06HRS.chr7.scatter.png
cnvkit scatter cnr/cHLsort19HRS.cnr -s call/with_tumor_content/cHLsort19HRS.cns -c chr7 -g ZYX -o figures/scatter/rescaled_for_tumor_purity/cHLsort19HRS.chr7.scatter.png

cnvkit scatter cnr/cHL-SORT-06HRSc-DNA.cnr -s call/with_tumor_content/cHL-SORT-06HRSc-DNA.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-06HRSc-DNA.chr9.scatter.png
cnvkit scatter cnr/cHL-SORT-19HRSb-DNA.cnr -s call/with_tumor_content/cHL-SORT-19HRSb-DNA.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity/cHL-SORT-19HRSb-DNA.chr9.scatter.png
cnvkit scatter cnr/cHLsort06HRS.cnr -s call/with_tumor_content/cHLsort06HRS.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity/cHLsort06HRS.chr9.scatter.png
cnvkit scatter cnr/cHLsort19HRS.cnr -s call/with_tumor_content/cHLsort19HRS.cns -c chr9 -g JAK2 -o figures/scatter/rescaled_for_tumor_purity/cHLsort19HRS.chr9.scatter.png

# other examples for scatter plot

cnvkit scatter cnr/PA003.cnr -s cns/autobin/PA003.cns -c chr9:-10000000 -g JAK2,CDKN2A
cnvkit scatter cnr/PA013.cnr -s cns/autobin/PA013.cns -c chr9 -g JAK2
cnvkit scatter cnr/PA013.cnr -s cns/autobin/PA008.cns -c chr16 -g SOCS1

# Step 9. Visualize as heatmap 
cnvkit heatmap cns/*cns
# draw re-scaled heatmap to de-emphasize low-amplitude segments, likely to be spurious CNAs
cnvkit heatmap cns/*cns -d

# Step 10. Export into file formats that can be used by other programs
cnvkit export seg call/cnvkit_default_thresholds_drop_low_coverage_cns/*cns -o igv/all_samples.seg
cnvkit export seg call/with_tumor_content/*cns -o igv/all_samples.tumor_purity.calls.seg
cnvkit export seg call/with_tumor_content_est_recurrent_genes/*cns -o igv/all_samples.tumor_purity.est_recurrent_genes.calls.seg


