#!/bin/bash

# How to run this script: from the project folder, ./scripts/cnvkit_call_with_tumor_content.sh

# Tumor content is based on peak VAF X 2

# LMD tumor samples vs. pooled LMD normal
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ092_TLMD_2.cns -y -m clonal --purity 0.2042 -o call/GZ092_TLMD_2.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ149TLMD.cns -y -m clonal --purity 0.1963 -o call/GZ149TLMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ184TLMD.cns -y -m clonal --purity 0.1606 -o call/GZ184TLMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ235T.cns -y -m clonal --purity 0.0925 -o call/GZ235T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ267T-merged.cns -y -m clonal --purity 0.0939 -o call/GZ267T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ32TLMD.cns -y -m clonal --purity 0.102 -o call/GZ32TLMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ86TLMD.cns -y -m clonal --purity 0.1482 -o call/GZ86TLMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/176T.cns -y -m clonal --purity 0.1553 -o call/176T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/99T.cns -y -m clonal --purity 0.3341 -o call/99T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ_BCC_08_T_LMD.cns -y -m clonal --purity 0.1867 -o call/GZ_BCC_08_T_LMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ_BCC_13_T_LMD.cns -y -m clonal --purity 0.1826 -o call/GZ_BCC_13_T_LMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ_BCC_20_T_LMD.cns -y -m clonal --purity 0.1256 -o call/GZ_BCC_20_T_LMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ_BCC_54_T_LMD.cns -y -m clonal --purity 0.2637 -o call/GZ_BCC_54_T_LMD.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ044T-merged.cns -y -m clonal --purity 0.0718 -o call/GZ044T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ046T-merged.cns -y -m clonal --purity 0.0946 -o call/GZ046T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ048T-merged.cns -y -m clonal --purity 0.3723 -o call/GZ048T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ062T-merged.cns -y -m clonal --purity 0.1913 -o call/GZ062T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ064T.cns -y -m clonal --purity 0.1164 -o call/GZ064T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ068T-merged.cns -y -m clonal --purity 0.1785 -o call/GZ068T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ095_TLMD_2.cns -y -m clonal --purity 0.2216 -o call/GZ095_TLMD_2.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ116T.cns -y -m clonal --purity 0.1234 -o call/GZ116T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ152T-merged.cns -y -m clonal --purity 0.2345 -o call/GZ152T-merged.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ178T.cns -y -m clonal --purity 0.1946 -o call/GZ178T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ222T.cns -y -m clonal --purity 0.2962 -o call/GZ222T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ229T.cns -y -m clonal --purity 0.0703 -o call/GZ229T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ230T.cns -y -m clonal --purity 0.1131 -o call/GZ230T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ294T.cns -y -m clonal --purity 0.3326 -o call/GZ294T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ301T.cns -y -m clonal --purity 0.4217 -o call/GZ301T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ310T.cns -y -m clonal --purity 0.2787 -o call/GZ310T.call.cns
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ197_TLMD.cns -y -m clonal --purity 0.121 -o call/GZ197_TLMD.call.cns

# GZ180 vs. matched blood normal
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ180_v_matched_C_normal/GZ180_FFPE.cns -y -m clonal --purity 0.0655 -o call/GZ180_v_matched_C_normal/GZ180_FFPE.call.cns

# GZ180 vs. pooled blood normal
/Users/shung/Downloads/cnvkit-0.9.1/cnvkit.py call cns/GZ180_v_pooled_C_normal/GZ180_FFPE.cns -y -m clonal --purity 0.0655 -o call/GZ180_v_pooled_C_normal/GZ180_FFPE.call.cns
