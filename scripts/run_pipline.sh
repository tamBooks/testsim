# Create directory of genome file
mkdir -p res/genome

#Download genome file and move to directory
wget -O ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz
mv GCF_000005845.2_ASM584v2_genomic.fna.gz res/genome/

#Rename genome to shorter title
mv res/genome/GCF_000005845.2_ASM584v2_genomic.fna.gz res/genome/ecoli.fasta.gz  
gunzip res/genome/ecoli.fasta.gz

# Cut the adapters of the sequences

sampleid=$1
echo cutadapt -m 20 -a AGATCGGAAGAGCACACGTCTGAACTCCAGTCA -A AGATCGGAAGAGCGTCGTGTAGGGAAAGAGTGT -o out/cutadapt/${sampleid}_1.trimmed.fastq.gz -p out/cutadapt/${sampleid}_2.trimmed.fastq.gz data/${sampleid}_1.fastq.gz data/${sampleid}_2.fastq.gz 

# indexing code goes here
echo "Running STAR indexing"
mkdir -p res/genome/star_index
STAR --runThread 4 --runMode genomeGenerate --genomeDir res/genome/star_index/ --genomeFastaFiles res/genome/ecoli.fasta --genomeSAindexNbases 9


for  $sampleid in $(get sample ids)
do
	#call analyze_sample for each sampleid
done


