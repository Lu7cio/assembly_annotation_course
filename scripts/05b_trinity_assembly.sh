#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=trinity_assembly
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/trinity_assembly/Etna-2/trinity_assembly_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/trinity_assembly/Etna-2/trinity_assembly_error_%j.e


#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input"
FASTQ_DIR="/data/users/mkummer/assembly_annotation_course/input/RNAseq_Sha"
FASTQ_R1="$FASTQ_DIR/ERR754081_1.fastq.gz"
FASTQ_R2="$FASTQ_DIR/ERR754081_2.fastq.gz"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/trinity/"
SIF_PATH="/containers/apptainer/trinity_2.15.2.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"
module load Trinity/2.15.1-foss-2021a

#Run trinity assembly on the FASTQ file
Trinity \
    --seqType fq \
    --left "$FASTQ_R1" \
    --right "$FASTQ_R2" \
    --max_memory 64G \
    --CPU 16 \
    --output "$RESULTS_DIR"
