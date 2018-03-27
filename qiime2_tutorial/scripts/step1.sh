#!/bin/bash
#SBATCH --time=0:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=10G
#SBATCH --ntasks-per-node=2
#SBATCH --job-name=QIIME2


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime tools import --type 'SampleData[PairedEndSequencesWithQuality]' --input-path soil-manifest.csv --output-path soil-paired-end-demux.qza --source-format PairedEndFastqManifestPhred33

qiime tools peek soil-paired-end-demux.qza
 
qiime demux summarize --i-data soil-paired-end-demux.qza --o-visualization soil-paired-end-demux.qzv

