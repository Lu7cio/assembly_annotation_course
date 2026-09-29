#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=1-00:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=nucmer_mummer
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/nucmer_mummer/nucmer_mummer_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/nucmer_mummer/nucmer_mummer_%j.e

# Define paths and output directory
BASE_DIR="/data/users/mkummer/assembly_annotation_course"
OUTPUT_DIR="$BASE_DIR/output"
NUCMER_MUMMER_DIR="$OUTPUT_DIR/nucmer_mummer"
SIF_PATH="/containers/apptainer/mummer4_gnuplot.sif"
REFERENCE="/data/courses/assembly-annotation-course/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"

FLYE="$OUTPUT_DIR/flye_assembly/Etna-2/assembly.fasta"
HIFIASM="$OUTPUT_DIR/hifiasm_assembly/Etna-2.bp.p_ctg.fa"
LJA="$OUTPUT_DIR/lja_assembly/Etna-2/assembly.fasta"

# Ensure output directory exists
mkdir -p "$NUCMER_MUMMER_DIR"

run_comparison() {
	local reference_fasta="$1"
	local query_fasta="$2"
	local comparison_name="$3"
	local prefix="$NUCMER_MUMMER_DIR/$comparison_name"

	echo "Running nucmer for $comparison_name"
	apptainer exec \
		--bind "/data:/data" \
		"$SIF_PATH" nucmer \
		--prefix "$prefix" \
		--breaklen 1000 \
		--mincluster 1000 \
		"$reference_fasta" "$query_fasta"

	echo "Running mummerplot for $comparison_name"
	apptainer exec \
		--bind "/data:/data" \
		"$SIF_PATH" mummerplot \
		-R "$reference_fasta" \
		-Q "$query_fasta" \
		--filter \
		-t png \
		--large \
		--layout \
		--fat \
		-p "$prefix" \
		"${prefix}.delta"
}

# Compare each assembly against the Arabidopsis thaliana reference.
run_comparison "$REFERENCE" "$FLYE" "reference_vs_flye"
run_comparison "$REFERENCE" "$HIFIASM" "reference_vs_hifiasm"
run_comparison "$REFERENCE" "$LJA" "reference_vs_lja"

# Compare each assembly against the other two assemblies.
run_comparison "$FLYE" "$HIFIASM" "flye_vs_hifiasm"
run_comparison "$FLYE" "$LJA" "flye_vs_lja"
run_comparison "$HIFIASM" "$LJA" "hifiasm_vs_lja"
