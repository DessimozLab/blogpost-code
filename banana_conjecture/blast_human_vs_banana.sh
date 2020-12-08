#!/bin/bash
#https://help.rc.ufl.edu/doc/Blast_Job_Scripts

#SBATCH --job-name=blast
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8GB
#SBATCH --time=0:20:00
#SBATCH --array=1-100
#SBATCH --error=logs/%x_%j_%a.err
#SBATCH --output=logs/blastp_%x_%j_%a.out

date;hostname;pwd

source /dcsrsoft/spack/bin/setup_dcsrsoft
module load gcc
module load blast-plus/2.9.0

export INPUT_DIR="human_input/"
export OUTPUT_DIR="human_vs_banana_output/"
export LOG_DIR="logs/"
mkdir -p ${OUTPUT_DIR}
mkdir -p ${LOG_DIR}
 
RUN_ID=$(( $SLURM_ARRAY_TASK_ID ))
 
QUERY_FILE=$( command ls -1 ${INPUT_DIR} | sed -n ${RUN_ID}p )
QUERY_NAME="${QUERY_FILE%.*}"
 
QUERY="${INPUT_DIR}/${QUERY_FILE}"
OUTPUT="${OUTPUT_DIR}/${QUERY_NAME}.out"
 
echo -e "Command:\nblastp –query ${QUERY} –db banana_genome.faa –out ${OUTPUT} –evalue 0.001 –outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend qlen sstart send slen evalue bitscore" -max_target_seqs 1 –num_threads 8"
 
blastp -query ${QUERY} -db banana_genome.faa -out ${OUTPUT} -evalue 0.001 -outfmt "6 qseqid sseqid pident length mismatch gapopen qstart qend qlen sstart send slen evalue bitscore" -max_target_seqs 1 -num_threads 8
 
date
