#!/bin/bash

# Function to download and process a single file
process_file() {
  url=$1
  file_name=$(basename "$url")
  unzip_name="${file_name%.*}"
  temp_file="${unzip_name}_.fastq"

  # Download file and unzip
  wget "$url"
 gunzip "$file_name"

 # Extract first 1,000,000 lines and zip
 head -n 3000000 "$unzip_name" > "$temp_file"
 gzip "$temp_file"

 # Remove original unzipped file
 rm "$unzip_name"
}

# List of URLs to download and process
urls=(
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/006/SRR7865616/SRR7865616_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/006/SRR7865616/SRR7865616_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/002/SRR7865622/SRR7865622_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/002/SRR7865622/SRR7865622_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/007/SRR7865617/SRR7865617_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/007/SRR7865617/SRR7865617_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/000/SRR7865620/SRR7865620_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/000/SRR7865620/SRR7865620_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/001/SRR7865621/SRR7865621_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/001/SRR7865621/SRR7865621_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/008/SRR7865618/SRR7865618_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/008/SRR7865618/SRR7865618_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/009/SRR7865619/SRR7865619_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/009/SRR7865619/SRR7865619_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/003/SRR7865623/SRR7865623_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/003/SRR7865623/SRR7865623_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/004/SRR7865624/SRR7865624_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/004/SRR7865624/SRR7865624_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/005/SRR7865625/SRR7865625_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/005/SRR7865625/SRR7865625_2.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/006/SRR7865626/SRR7865626_1.fastq.gz
ftp://ftp.sra.ebi.ac.uk/vol1/fastq/SRR786/006/SRR7865626/SRR7865626_2.fastq.gz


)

# Loop through URLs and process each file
for url in "${urls[@]}"; do
  process_file "$url"
done



