#!/bin/bash
#SBATCH --time=4:00:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=1
#SBATCH --job-name=QIIME2_rare


set -e
cd $WORK/qiime2-tut

module load qiime2

# --p-max-depth should be set the max(depth_sample_i), i.e. the maximum sample frequency. You can find that in soil-table.qzv (sample list)
# we provide the phylogeny here, and by default qiime will calculate rarefaction by the shannon index. See: qiime diversity alpha-rarefaction --help 
qiime diversity alpha-rarefaction   --i-table soil-table.qza   --i-phylogeny soil-rooted-tree.qza   --p-max-depth 1500   --m-metadata-file soil-metadata.tsv   --o-visualization alpha-rarefaction.qzv --p-steps 20  --verbose


