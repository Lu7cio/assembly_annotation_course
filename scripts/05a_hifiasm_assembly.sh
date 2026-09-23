#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=hifiasm_assembly
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/hifiasm_assembly/Etna-2/hifiasm_assembly_quality_check_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/hifiasm_assembly/Etna-2/hifiasm_assembly_error_%j.e


#Define raw data path, container path and output directory
READS_DIR="/data/users/mkummer/assembly_annotation_course/input"
FASTQ_FILE="/data/users/mkummer/assembly_annotation_course/input/ERR11437333.fastq.gz"
RESULTS_DIR="/data/users/mkummer/assembly_annotation_course/output/hifiasm_assembly/Etna-2"
SIF_PATH="/containers/apptainer/hifiasm_0.25.0.sif"

#Ensure output directory exists
mkdir -p "$RESULTS_DIR"

#Run hifiasm assembly on the FASTQ file
apptainer exec \
  --bind "$READS_DIR":"$READS_DIR" \
  --bind "$RESULTS_DIR":"$RESULTS_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" hifiasm -t 16 \
  -o "$RESULTS_DIR" \
  "$FASTQ_FILE"

# Convert the GFA assembly to FASTA
awk '/^S/{print ">" $2; print $3}' "$RESULTS_DIR/etna2.bp.p_ctg.gfa" > "$RESULTS_DIR/etna2.bp.p_ctg.fa"