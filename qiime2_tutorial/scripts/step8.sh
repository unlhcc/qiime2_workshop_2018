#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=10G
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=QIIME2_series


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime emperor plot   --i-pcoa metrics/unweighted_unifrac_pcoa_results.qza   --m-metadata-file soil-metadata.tsv   --p-custom-axes Time   --o-visualization metrics/unweighted-unifrac-emperor-byTime.qzv

qiime emperor plot   --i-pcoa metrics/bray_curtis_pcoa_results.qza   --m-metadata-file soil-metadata.tsv   --p-custom-axes Time   --o-visualization metrics/bray_curtis-emperor-byTime.qzv



