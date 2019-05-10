#!/bin/bash

perl ~/Downloads/mskcc-vcf2maf-5453f80/maf2vcf.pl --input-maf /Volumes/shung/projects/gzl_exomes/snv_analysis-20181127/signature_analysis/input/snvs_indels.30_minus_GZ222_and_GZ229.default_and_optimized.incl_silent_and_UTR.for_vcf_conversion.maf \
	--output-dir /Volumes/shung/projects/gzl_exomes/snv_analysis-20181127/signature_analysis/vcf \
	--ref-fasta ~/Downloads/mskcc-vcf2maf-5453f80/data/Homo_sapiens.GRCh37.75.dna.primary_assembly.fa \
	--per-tn-vcfs 1 \
	--tum-depth-col t_depth \
	--tum-rad-col t_ref_depth \
	--tum-vad-col t_var_depth \
	--nrm-depth-col n_depth \
	--nrm-rad-col n_ref_depth \
	--nrm-vad-col n_var_depth
