#!/bin/bash
#SBATCH --time=2:30:00
#SBATCH --partition batch,tmp_anvil
#SBATCH --mem=20G
#SBATCH --ntasks-per-node=8
#SBATCH --job-name=QIIME2_Phylo


set -e
cd $WORK/qiime2-tut

module load qiime2

qiime alignment mafft   --i-sequences soil-rep-seqs.qza   --o-alignment soil-aligned-rep-seqs.qza --verbose --p-n-threads $SLURM_TASKS_PER_NODE
qiime alignment mask   --i-alignment soil-aligned-rep-seqs.qza   --o-masked-alignment soil-masked-aligned-rep-seqs.qza --verbose
qiime phylogeny fasttree   --i-alignment soil-masked-aligned-rep-seqs.qza   --o-tree soil-unrooted-tree.qza --verbose --p-n-threads $SLURM_TASKS_PER_NODE
qiime phylogeny midpoint-root   --i-tree soil-unrooted-tree.qza   --o-rooted-tree soil-rooted-tree.qza


