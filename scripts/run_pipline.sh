# Create directory of genome file
mkdir -p res/genome

#Download genome file and move to directory
wget ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
mv GCF_000005845.2_ASM584v2_genomic.fna.gz res/genome/

#Rename genome to shorter title
mv res/genome/GCF_000005845.2_ASM584v2_genomic.fna.gz res/genome/ecoli.fasta.gz  
gunzip res/genome/ecoli.fasta.gz

# MultiQC 
echo
echo "Running MultiQC..."
mkdir -p out/multiqc
multiqc -o out/multiqc  data/*.fastq.gz
multiqc -o log/multiqc .
echo

if [ "$#" -eq 1 ]
then
    sampleid=$1
    echo "Running FastQC..."
    mkdir -p out/fastqc
    fastqc -o out/fastqc data/${sampleid}*.fastq.gz
    echo
    echo "Running cutadapt..."
    mkdir -p log/cutadapt
    mkdir -p out/cutadapt
    cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/${sampleid}_1.trimmed.fastq.gz -p out/cutadapt/${sampleid}_2.trimmed.fastq.gz data/${sampleid}_1.fastq.gz data/${sampleid}_2.fastq.gz > log/cutadapt/${sampleid}.log
    echo
    echo "Running STAR index..."
    mkdir -p res/genome/star_index
    STAR --runThreadN 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9
    echo
    echo "Running STAR alignment..."
    mkdir -p out/star/${sampleid}
    STAR --runThreadN 4 --genomeDir res/genome/star_index/ --readFilesIn out/cutadapt/${sampleid}_1.trimmed.fastq.gz out/cutadapt/${sampleid}_2.trimmed.fastq.gz --readFilesCommand zcat --outFileNamePrefix out/star/${sampleid}/
    echo
else
    echo "Usage: $0 <sampleid>"
    exit 1
fi
