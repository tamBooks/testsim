mkdir -p res/genome
wget -O ftp://ftp.ncbi.nlm.nih.gov/genomes/all/GCF/000/005/845/GCF_000005845.2_ASM584v2/GCF_000005845.2_ASM584v2_genomic.fna.gz

# indexing code goes here

for  $sampleid in $(get sample ids)
do
	#call analyze_sample for each sampleid
done
