#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=2
#SBATCH --job-name=QIIME2_alpha


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime diversity alpha-group-significance   --i-alpha-diversity metrics/faith_pd_vector.qza   --m-metadata-file soil-metadata.tsv   --o-visualization metrics/faith-pd-group-significance.qzv

qiime diversity alpha-group-significance   --i-alpha-diversity metrics/evenness_vector.qza   --m-metadata-file soil-metadata.tsv   --o-visualization metrics/evenness-group-significance.qzv

qiime diversity alpha-group-significance   --i-alpha-diversity metrics/shannon_vector.qza   --m-metadata-file soil-metadata.tsv   --o-visualization metrics/shannon-group-significance.qzv

qiime diversity alpha-group-significance   --i-alpha-diversity metrics/observed_otus_vector.qza   --m-metadata-file soil-metadata.tsv   --o-visualization metrics/otu-significance.qzv


