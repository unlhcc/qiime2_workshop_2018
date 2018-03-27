#!/bin/bash
#SBATCH --time=2:00:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=template


set -e
cd $WORK/qiime2-tut

module load qiime2 ea-utils fastqc


echo "yoo"

hagelslag
