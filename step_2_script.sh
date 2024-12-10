#!/bin/bash

# Move installation script and install Kraken2
mv kraken2/kraken2/install_kraken2.sh ./kraken2
cd kraken2/kraken2/
sh install_kraken2.sh .
cd ../..

# Download and extract Kraken2 database
wget https://genome-idx.s3.amazonaws.com/kraken/k2_standard_08gb_20230314.tar.gz
mv k2_standard_08gb_20230314.tar.gz kraken2/dbs/
cd kraken2/dbs/
tar -xvzf k2_standard_08gb_20230314.tar.gz

# Activate Kraken2 environment and build the database
conda activate kraken2
./kraken2/kraken2-build --db kraken2/dbs/k2_standard_08gb_20230314
cd ../..

# Download reference libraries (used for bracken)
kraken2-build --download-library bacteria --db kraken2/dbs
kraken2-build --download-library human --db kraken2/dbs

# Build the Kraken2 database
kraken2-build --build --db kraken2/dbs/
