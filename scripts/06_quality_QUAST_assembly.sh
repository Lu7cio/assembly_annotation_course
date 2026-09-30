#!/usr/bin/env bash

#SBATCH --cpus-per-task=16
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --partition=pibu_el8
#SBATCH --job-name=quast_assemblies
#SBATCH --output=/data/users/mkummer/assembly_annotation_course/logs/quast_assembly/quast_assemblies_%j.o
#SBATCH --error=/data/users/mkummer/assembly_annotation_course/logs/quast_assembly/quast_assemblies_%j.e

# Define raw data path, container path and output directory
BASE_DIR="/data/users/mkummer/assembly_annotation_course"
OUTPUT_DIR="$BASE_DIR/output"
QUAST_DIR="$OUTPUT_DIR/QUAST"
SIF_PATH="/containers/apptainer/quast_5.2.0.sif"
REF_GENOME="$BASE_DIR/input/references/Arabidopsis_thaliana.TAIR10.dna.toplevel.fa"
REF_FEATURES="$BASE_DIR/input/references/Arabidopsis_thaliana.TAIR10.57.gff3"
PACBIO_READS="$BASE_DIR/input/ERR11437333.fastq.gz"

# Ensure output directories exist
mkdir -p "$QUAST_DIR/with_reference" "$QUAST_DIR/without_reference"

# Define assembly names and corresponding file paths
assembly_names=(
  
  "flye"
  "hifiasm"
  "lja"
)

# Define assembly file paths corresponding to the assembly names
assembly_files=(
  "$OUTPUT_DIR/flye_assembly/Etna-2/assembly.fasta"
  "$OUTPUT_DIR/hifiasm_assembly/Etna-2.bp.p_ctg.fa"
  "$OUTPUT_DIR/lja_assembly/Etna-2/assembly.fasta"
)

# Run QUAST once with the reference and once without it.
for assembly in "${assembly_files[@]}"; do
  if [[ ! -s "$assembly" ]]; then
    echo "ERROR: Assembly not found: $assembly" >&2
    exit 1
  fi
done

if [[ ! -s "$REF_GENOME" ]]; then
  echo "ERROR: Reference genome not found: $REF_GENOME" >&2
  exit 1
fi

if [[ ! -s "$REF_FEATURES" ]]; then
  echo "ERROR: Reference annotation not found: $REF_FEATURES" >&2
  exit 1
fi

if [[ ! -s "$PACBIO_READS" ]]; then
  echo "ERROR: PacBio reads not found: $PACBIO_READS" >&2
  exit 1
fi

QUAST_OPTIONS=(
  --eukaryote
  --large
  --threads 16
  --labels "flye,hifiasm,lja"
  --pacbio "$PACBIO_READS"
  --no-sv
)

apptainer exec \
  --bind "$BASE_DIR":"$BASE_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" quast.py \
  "${QUAST_OPTIONS[@]}" \
  --reference "$REF_GENOME" \
  --features "$REF_FEATURES" \
  --output-dir "$QUAST_DIR/with_reference" \
  "${assembly_files[@]}"

apptainer exec \
  --bind "$BASE_DIR":"$BASE_DIR" \
  --bind "/data":"/data" \
  "$SIF_PATH" quast.py \
  "${QUAST_OPTIONS[@]}" \
  --est-ref-size 135000000 \
  --output-dir "$QUAST_DIR/without_reference" \
  "${assembly_files[@]}"
