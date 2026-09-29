# Course
473637-HS2026-0: Genome and Transcriptome Assembly, Autumn Semester 2025

## University
University of Bern

## Author
Mario Kummer

## Species & Group:
Species Etna-2 & Group 3 

## Description
In this Course/Project the goal was

## Software & Tool versions
All analyses were performed using fixed software versions. See below for full version details.

| Tool / Software            | Version |
|----------------------------|---------|
| FastQC                     | 0.12.1  |
| fastp                      | 24.1    |
| Jellyfish                  | 2.2.6   |
| flye                       | 2.9.5   |
| hifiasm                    | 0.25.0  |
| LJA                        | 0.2     |
| trinity                    | 2.15.2  |
| busco                      | 5.7.1   |
| merqury                    | 1.3     |
| QUAST                      | 5.2.0   |
| nucmer                     |         |
| mummer                     |         |
## Workflow of analysis:

### Workflow steps Summary:
For running the bash scripts on the HPC cluster (With SLURM) the command ```bash sbatch my_script.sh```  followed by the name of the desired script was used.

1. FastQC quality control on raw reads for genomic data for Etna-2 (Pacbio HiFi long reads) and for transcriptomic data (Illumina paired end short reads)

2. Optional: FastP trimming only for transcriptomic data (Illumina paired end short reads) and not for genomic data for Etna-2 (Pacbio HiFi long reads) 

3. Optional: FastQC on trimmed Reads only for transcriptomic data (Illumina paired end short reads) and not for genomic data for Etna-2 (Pacbio HiFi long reads)

4. Jellyfish K-mers for estimating genome size for genomic data for Etna-2 (Pacbio HiFi long reads)

5. Genome assembly for genomic data for Etna-2 (Pacbio HiFi long reads) with different approaches/Softwares: flye, hifiasm, LJA and trinity.
    

### Detailed Workflow
Since we had two different datasets: Genomic data for Etna-2 (Pacbio HiFi long reads) & transcriptomic data (Illumina paired end short reads) the steps are additionally numerator with a and b to specify on which data the analysis was performed on. a: Genomic data for Etna-2 (Pacbio HiFi long reads)  & b: transcriptomic data (Illumina paired end short reads).

1a. FastQC quality control on raw reads of genomic data for Etna-2 (Pacbio HiFi long reads):

    The FastQC was run on the *fastq* files of the raw  data.

    - Used container/apptainer: `fastqc-0.12.1.sif` (FastQC version 0.12.1)

    - Used script: `01a_fastQC_raw_reads.sh` 

1b. FastQC quality control on raw reads of transcriptomic data (Illumina paired end short reads):

    The FastQC was run on the *fastq* files of the raw  data.

    - Used container/apptainer: `fastqc-0.12.1.sif` (FastQC version 0.12.1)

    - Used script: `01b_fastQC_raw_reads.sh` 

2b. FastP trimming of the raw reads of transcriptomic data (Illumina paired end short reads):

    The FastQC was run on the *fastq* files of the raw  data.
   
    - Used container/apptainer: `fastp_0.24.1.sif` (FastP version 0.24.1)

    - Used script: 2b_fastP_raw_reads.sh 

3b. FastQC quality control on the trimmed reads of transcriptomic data (Illumina paired end short reads):

    The FastQC was run on the *fastq* files of the trimmed read.

    - Used container/apptainer: `fastqc-0.12.1.sif` (FastQC version 0.12.1)

    - Used script: 3b_fastQC_trimmed_reads.sh   

4a. Jellyfish K-mers for estimating genome size for enomic data for Etna-2 (Pacbio HiFi long reads) :

    The Jellyfish was run on the raw *fastq* files of genomic data for Etna-2 (Pacbio HiFi long reads)

    - Used container/apptainer: `jellyfish-2.2.6--0.sif` (Jellyfish version 2.2.6)

    - Used script: `04a_jellyfish_k-mer.sh` 

5a. Genome assembly for genomic data for Etna-2 (Pacbio HiFi long reads) with different approaches/softwares: flye, hifiasm, LJA and trinity.

    Every approach was run on the raw *fastq* files of genomic data for Etna-2 (Pacbio HiFi long reads)

    Flye:
    - Used container/apptainer: `flye_2.9.5.sif` (flye version 2.9.5)

    - Used script: `05a_flye_assembly.sh ` 

    Hifiasm:
    - Used container/apptainer: `hifiasm_0.25.0.sif` (hifiasm version 0.25.0)

    - Used script: `05a_hifiasm_assembly.sh` 
    
    LJA:
    - Used container/apptainer: `lja-0.2.sif` (LJA version 0.2)

    - Used script: `05a_LJA_assembly.sh ` 
    
    Trinity:
     - Used container/apptainer: `trinity_2.15.2.sif` (trinity version 2.15.2)

    - Used script: `05b_trinity_assembly.sh ` 

### Scripts folder structure
```bash
scripts/
├── 01a_fastQC_raw_reads.sh                # Script for
├── 01b_fastQC_raw_reads.sh                # Script for
├── 02b_fastP_raw_reads.sh                 # Script for       
├── 03b_fastQC_trimmed_reads.sh            # Script for
├── 04a_jellyfish_k-mer.sh                 # Script for
├── 05a_flye_assembly.sh                   # Script for
├── 05a_hifiasm_assembly.sh                # Script for
├── 05a_LJA_assembly.sh                    # Script for                     
├── 05b_trinity_assembly.sh                # Script for
├── 06_quality_BUSCO_assembly.sh           # Script for
├── 06_quality_merqury_assembly.sh         # Script for
├── 06_quality_QUAST_assembly.sh           # Script for
├── 06_quality_merqury_assembly.sh         # Script for
├── 07_nucmer_and_mummer.sh                # Script for