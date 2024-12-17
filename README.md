
# Mycoplasma Contamination Workflow

***

### Welcome


Welcome to the GitHub repository for the Mycoplasma Contamination Workflow! This repository contains an end-to-end workflow developed using Snakemake to assess mycoplasma contamination in NGS data. The purpose of this workflow is to analyze publicly available data from both normal and tumor tissue and tissue-derived organoid cultures and report on potential differences in contamination levels, specifically within the scope of Mycoplasma.



# Getting Started 

1. Make sure you have an updated version of [conda](https://docs.conda.io/en/latest/). The new libmamba solver is capable of solving dependencies at lightning speed, [see here](https://www.anaconda.com/blog/a-faster-conda-for-a-growing-community) for more.
2. Clone this repository into your working directory. Most commands will be ran from the top of the directory where you deployed this repository. 
3. Use the following commands to create 2 conda environments that we will use to manually install the kraken2 database, reference libraries and run our workflow: 

    ``` conda env create -f envs/snakemake.yml ```

    ```conda env create -f envs/kraken2.yml```

4. If you're new to snakemake, feel free to check out [their website](https://snakemake.readthedocs.io/en/stable/) for good information on how to install or run the program. 
6. Move your raw data into the `raw_data` folder and decompress the files, ensuring they end in a ```.fastq``` file extension. 
7. Run the `step_1_script.sh` script to clone the necessary GitHub repositories  
8. execute: ```conda activate kraken2```
9. Run the `step_2_script.sh` script to move install files to the correct directories and download ```k2_standard_08gb_20230314```, the most recent 8gb kraken2 classification database, which is appropriate for our needs currently. memory-intensive step** 
10. Edit the Snakefile with information corresponding to each rule and specific parameters, including generating a list of input files, as strings, for the ```samples``` list. ```resources``` arguments have been parameterized for user convenience.

***

MacOS users, to run this workflow locally you will need to install [homebrew](https://brew.sh) as well as the C compiler via a quick ```brew install gcc@9``` with a quick sudo symlink:
```sudo ln -s /usr/local/bin/gcc-9 /usr/local/bin/gcc```

***

### Running the pipeline

1. Activate your conda environment
``` conda activate snakemake```

2. Perform a dry run 
```snakemake -n``` 

3. Real run on the first rule ```fastqc_1```
simply leave only the first line of the ```rule all``` rule uncommented

4. Identify sources of poor sequencing quality etc. and included those in the ```cutadapt``` and ```trimmomatic``` rules 

5. Run the whole pipeline:
```snakemake  --use-conda --cores <cores> -j <jobs> ```

5. 
### Overview of each Rule 

- Rule: fastqc_1
  - Performs FastQC analysis on the raw data files.

- Rule: cutadapt
  - Removes adapter sequences from the raw data files using Cutadapt.

- Rule: trimmomatic
  - Performs quality trimming on the data using Trimmomatic.

- Rule: fastqc_2
  - Performs FastQC analysis on the trimmed data files as a sanity check.

- Rule: kraken2
  - Performs taxonomic classification using Kraken2.

- Rule: bracken
  - Performs Bayesian abundance estimation using Bracken.

- Rule: mpa_style_reports
  - Generates MPA-style reports using Kraken2 that we can use downstream for different concatenation and visualization features. See the interactive shiny app [Pavian](https://github.com/fbreitwieser/pavian).

- Rule: kreport2krona
  - Converts the Kraken2 report to Krona format using the kreport2krona script.
  
- Rule: krona
  - Converts the kreport2krona report to interactive Krona html files using KronaTools.


### Helpful Links and scripts 

```raw_data/truncate.sh``` is a script that can aid in automated download and overall size reduction of data files to troubleshoot this workflow quickly before full deployment of resources.

[Kraken2 and Bracken databases](https://benlangmead.github.io/aws-indexes/k2)

[FastQC](https://github.com/s-andrews/FastQC)

[Cutadapt](https://github.com/marcelm/cutadapt)

[Trimmomatic](https://github.com/usadellab/Trimmomatic)

[FastQC](https://github.com/s-andrews/FastQC)

[Kraken2](https://github.com/DerrickWood/kraken2)

[Bracken](https://github.com/jenniferlu717/Bracken)

[Pavian](https://github.com/fbreitwieser/pavian)

[KrakenTools](https://github.com/jenniferlu717/KrakenTools)

[KronaTools](https://github.com/marbl/Krona)


