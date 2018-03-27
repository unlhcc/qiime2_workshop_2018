#!/bin/bash
#SBATCH --time=0:05:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=2G
#SBATCH --ntasks=1
#SBATCH --job-name=QIIME2_Master


set -e
cd $WORK/qiime2-tut

sbatch scripts/step1.sh
sbatch -d singleton scripts/step2.sh


