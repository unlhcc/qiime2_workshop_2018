#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=10G
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=QIIME2_taxplot


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime metadata tabulate   --m-input-file soil-taxonomy.qza   --o-visualization soil-taxonomy.qzv


qiime taxa barplot   --i-table soil-table.qza   --i-taxonomy soil-taxonomy.qza   --m-metadata-file soil-metadata.tsv   --o-visualization taxa-bar-plots.qzv

