# Course
Genome and Transcriptome Assembly, Autumn Semester 2026


## University
University of Bern


## Author
Mario Kummer


## Species & Accession & Group:
Species:    Arabidopsis thaliana

Accession:  Etna-2

Group:      3


## Description
In this Course/Project the goal was to de novo assemble the genome and trasncriptome form the species Arabidopsis thaliana, accession Etna-2. The genome was sequenced with Pacbio HiFi long reads and the transcriptome with Illumina paired end short reads. For this purpose, we assembled the genome and transcriptome with different approaches/Softwares and to compare the assemblies with each other and with the reference genome of Etna-2. The quality of the assemblies was assessed with different approaches/Softwares. 

## Software & Tool versions
All analyses were performed using fixed software versions. See below for full version details.

|----------------------------|----------|
| Tool / Software            | Version  |
|----------------------------|----------|
| FastQC                     | 0.12.1   |
| fastp                      | 24.1     |
| Jellyfish                  | 2.2.6    |
| flye                       | 2.9.5    |
| hifiasm                    | 0.25.0   |
| LJA                        | 0.2      |
| trinity                    | 2.15.2   |
| busco                      | 5.7.1    |
| merqury                    | 1.3      |
| QUAST                      | 5.2.0    | 
| nucmer/mummer              | 4.0.0rc1 |
|----------------------------|----------|

## Workflow of analysis:

### Workflow steps Summary:
For running the bash scripts on the HPC cluster (With SLURM) the command ```sbatch my_script.sh```  followed by the name of the desired script was used.

1. FastQC quality control on raw reads for genomic data for Etna-2 (Pacbio HiFi long reads) and for transcriptomic data (Illumina paired end short reads)

2. Optional: FastP trimming only for transcriptomic data (Illumina paired end short reads) and not for genomic data for Etna-2 (Pacbio HiFi long reads) 

3. Optional: FastQC on trimmed Reads only for transcriptomic data (Illumina paired end short reads) and not for genomic data for Etna-2 (Pacbio HiFi long reads)

4. Jellyfish K-mers for estimating genome size for genomic data for Etna-2 (Pacbio HiFi long reads)

5. Genome assembly for genomic data for Etna-2 (Pacbio HiFi long reads) with different approaches/Softwares (flye, hifiasm, LJA) and transcriptome assembly with transcriptomic data (Illumina paired end short reads) with Trinity.

6. Quality assessment of the assemblies with different approaches/Softwares: BUSCO, merqury and QUAST.
For BUSCO (Run on flye, hifiasm, LJA and Trinity assemblies). For QUAST  (Run on flye, hifiasm and LJA  assemblies). For merqury  (Run on flye, hifiasm and assemblies).

7. Nucmer and Mummer for comparing the assemblies with each other and with the reference genome of Etna-2.
    


### Detailed Workflow
Since we had two different datasets: Genomic data for Etna-2 (Pacbio HiFi long reads) & transcriptomic data (Illumina paired end short reads) the steps are additionally numerator with a and b to specify on which data the analysis was performed on. 

 - a: Genomic data for Etna-2 (Pacbio HiFi long reads) 
 - b: transcriptomic data (Illumina paired end short reads).
    
The specific parameters used for each analysis are specified in the bash scripts. The workflow steps are as follows:

   
1. a) FastQC quality control on raw reads of genomic data for Etna-2 (Pacbio HiFi long reads):

    The FastQC was run on the *fastq* files of the raw  data.

    - Used container/apptainer: `fastqc-0.12.1.sif` (FastQC version 0.12.1)

    - Used script: `01a_fastQC_raw_reads.sh` 

1. b) FastQC quality control on raw reads of transcriptomic data (Illumina paired end short reads):

    The FastQC was run on the *fastq* files of the raw  data.

    - Used container/apptainer: `fastqc-0.12.1.sif` (FastQC version 0.12.1)

    - Used script: `01b_fastQC_raw_reads.sh` 

2. b) FastP trimming of the raw reads of transcriptomic data (Illumina paired end short reads):

    The FastQC was run on the *fastq* files of the raw  data.
   
    - Used container/apptainer: `fastp_0.24.1.sif` (FastP version 0.24.1)

    - Used script: `2b_fastP_raw_reads.sh` 

3. b) FastQC quality control on the trimmed reads of transcriptomic data (Illumina paired end short reads):

    The FastQC was run on the *fastq* files of the trimmed read.

    - Used container/apptainer: `fastqc-0.12.1.sif` (FastQC version 0.12.1)

    - Used script: `3b_fastQC_trimmed_reads.sh`   

4. a) Jellyfish K-mers for estimating genome size for enomic data for Etna-2 (Pacbio HiFi long reads) :

    The Jellyfish was run on the raw *fastq* files of genomic data for Etna-2 (Pacbio HiFi long reads)

    - Used container/apptainer: `jellyfish-2.2.6--0.sif` (Jellyfish version 2.2.6)

    - Used script: `04a_jellyfish_k-mer.sh` 

5. a) Genome assembly for genomic data for Etna-2 (Pacbio HiFi long reads) with different approaches/softwares: flye, hifiasm and LJA.

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
    

5. b) Transcriptome assembly for transcriptomic data (Illumina paired end short reads) with Trinity.
    
    Trinity:
     - Used container/apptainer: `trinity_2.15.2.sif` (trinity version 2.15.2)

    - Used script: `05b_trinity_assembly.sh ` 

6. Quality assessment of the assemblies with different approaches/softwares: BUSCO, merqury and QUAST.


    BUSCO:
    - Used container/apptainer: `busco-5.7.1.sif` (BUSCO version 5.7.1)

    - Used script: `06_quality_BUSCO_assembly.sh ` 


    QUAST:
    - Used container/apptainer: `quast-5.2.0.sif` (QUAST version 5.2.0)

    - Used script: `06_quality_QUAST_assembly.sh `


    merqury:
    - Used container/apptainer: `merqury-1.3.sif` (merqury version 1.3)

    - Used script: `06_quality_merqury_assembly.sh ` 


7. Nucmer and Mummer for comparing the assemblies with each other and with the reference genome of Etna-2.

    Nucmer:
    - Used container/apptainer: `mummer4_gnuplot.sif` (mummer version 4.0.0rc1)

    - Used script: `07_nucmer_and_mummer.sh `


### Scripts folder structure
```bash
scripts/
├── 01a_fastQC_raw_reads.sh                
├── 01b_fastQC_raw_reads.sh                
├── 02b_fastP_raw_reads.sh                       
├── 03b_fastQC_trimmed_reads.sh            
├── 04a_jellyfish_k-mer.sh                 
├── 05a_flye_assembly.sh                   
├── 05a_hifiasm_assembly.sh                
├── 05a_LJA_assembly.sh                                        
├── 05b_trinity_assembly.sh                
├── 06_quality_BUSCO_assembly.sh           
├── 06_quality_merqury_assembly.sh         
├── 06_quality_QUAST_assembly.sh           
├── 06_quality_merqury_assembly.sh         
├── 07_nucmer_and_mummer.sh                