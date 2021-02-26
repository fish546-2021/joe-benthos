#!/bin/bash
## Job Name
#SBATCH --job-name=546-blast
## Allocation Definition
#SBATCH --account=srlab
#SBATCH --partition=srlab
## Resources
## Nodes
#SBATCH --nodes=1
## Walltime (days-hours:minutes:seconds format)
#SBATCH --time=0-12:00:00
## Memory per node
#SBATCH --mem=120G
##turn on e-mail notification
#SBATCH --mail-type=ALL
#SBATCH --mail-user=casowari@uw.edu
## Specify the working directory for this job
#SBATCH --chdir=/gscratch/scrubbed/jdduprey/02262021_546blast



source /gscratch/srlab/programs/scripts/paths.sh



/gscratch/srlab/programs/ncbi-blast-2.8.1+/bin/blastx \
-query /gscratch/srlab/sr320/data/cg/GCF_000297895.1_oyster_v9_cds_from_genomic.fna \
-db /gscratch/srlab/blastdbs/UniProtKB_20190109/uniprot_sprot.fasta  \
-out /gscratch/scrubbed/jdduprey/02262021_546blast/Cg-blastx-sp546.tab \
-evalue 1E-05 \
-num_threads 40 \
-max_target_seqs 1 \
-max_hsps 1 \
-outfmt "6 qaccver saccver evalue"
