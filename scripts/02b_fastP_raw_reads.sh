#!/usr/bin/env bash

#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=32G
#SBATCH --time=06:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=fastP_analysis
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/fastP/RNAseq_Sha/fastqc_analysis_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/fastP/RNAseq_Sha/fastqc_analysis_error_%j.e

#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input/RNAseq_Sha"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/fastp/RNAseq_Sha"
SIF_PATH="/containers/apptainer/fastp_0.24.1.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

#Run FastP on each FASTQ file in the directory
for FASTQ_FILE in "$READS_DIR"/*.fastq*; do
  if [ -f "$FASTQ_FILE" ]; then
    echo "Processing $FASTQ_FILE..."
    apptainer exec \
    --bind "$READS_DIR":"$READS_DIR" \
    --bind "$RESULTS_DIR":"$RESULTS_DIR" \
    --bind "/data":"/data" \
    "$SIF_PATH" fastp \
      -i "$READS_DIR" \
      -o "$RESULTS_DIR/${filename}_1_trimmed.fastq.gz" \
      --html "$RESULTS_DIR/${filename}_fastp.html" \
      --json "$RESULTS_DIR/${filename}_fastp.json" \
      --thread 4
      --detect_adapter_for_pe
  fi
done