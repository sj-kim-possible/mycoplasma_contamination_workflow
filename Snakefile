

samples = ["SRR7865616","SRR7865617","SRR7865618", \
"SRR7865619","SRR7865620","SRR7865621","SRR7865622", \
"SRR7865623","SRR7865624","SRR7865625","SRR7865626"]

reads = ["1", "2"]

rule all:
    input:
        # expand("fastqc/fastqc_1/results/{sample}_{r}_fastqc.html", sample=samples, r=reads),
        # expand("cutadapt/results/{sample}_{r}.out.fastq", sample=samples, r=reads),
        # expand("cutadapt/results/{sample}_{r}.out.fastq", sample=samples, r=reads),
        # expand("trimmomatic/results/{sample}_{r}.out.trimmed.fastq", sample=samples, r=reads),
        # expand("trimmomatic/results/{sample}_{r}.out.untrimmed.fastq", sample=samples, r=reads),
        # expand("trimmomatic/results/{sample}_{r}.out.trimmed.fastq", sample=samples, r=reads),
        # expand("trimmomatic/results/{sample}_{r}.out.untrimmed.fastq", sample=samples, r=reads),
        # expand("fastqc/fastqc_2/results/{sample}_{r}.out.trimmed_fastqc.html", sample=samples, r=reads),
        # expand("kraken2/results/{sample}_paired_kraken_report", sample=samples), 
        # expand("kraken2/results/{sample}_paired_mpa_report", sample=samples), 
        expand("bracken/results/{sample}_bracken_report", sample=samples),
        # expand("krakentools/results/krona/{sample}_pre_krona.tsv", sample=samples),
        # expand("krakentools/results/bracken_filter/{sample}_bracken_filtered", sample=samples),
        # expand("krona/results/{sample}_krona.html", sample=samples) 


rule fastqc_1:
    priority:10
    input: \
        "raw_data/{sample}.fastq"
    output: \
        "fastqc/fastqc_1/results/{sample}_fastqc.html"
    conda: 
        "envs/fastqc.yml"
    threads:2
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    shell: \
        "fastqc -t {threads} " \
            "--outdir fastqc/fastqc_1/results/ " \
            "{input} "

rule cutadapt:
    priority:8
    input: \
        "raw_data/{sample}_1.fastq", \
        "raw_data/{sample}_2.fastq"
    output: \
        "cutadapt/results/{sample}_1.out.fastq", \
        "cutadapt/results/{sample}_2.out.fastq"
    params: 
        ADAPTER_FWD="AAGCAGTGGTATCAACGCAGAGTACXXXXX",
        ADAPTER_REV="GTACTCTGCGTTGATACCACTGCTT"
    threads:2
    conda:
        "envs/cutadapt.yml"
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    shell: \
        "cutadapt -a {params.ADAPTER_FWD} " \
                "-A {params.ADAPTER_REV} " \
                "--poly-a " \ 
                "-o {output[0]} " \
                "-p {output[1]} " \
                "{input[0]} " \
                "{input[1]} " \
                "-j {threads} " \
                "-x ADAPTERX " \

rule trimmomatic:
    priority:6
    input: \
        "cutadapt/results/{sample}_1.out.fastq", \
        "cutadapt/results/{sample}_2.out.fastq"
    output: \
        "trimmomatic/results/{sample}_1.out.trimmed.fastq", \
        "trimmomatic/results/{sample}_1.out.untrimmed.fastq", \
        "trimmomatic/results/{sample}_2.out.trimmed.fastq", \
        "trimmomatic/results/{sample}_2.out.untrimmed.fastq" 
    threads:2
    params:
        LEADING="3", 
        TRAILING="3",
        SLIDINGWINDOW="5:15",
        MINLEN="35",
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    conda: 
        "envs/trimmomatic.yml"
    shell: \
        "trimmomatic PE -threads {threads} " \
                "{input[0]} " \
                "{input[1]} " \
                "{output[0]} " \
                "{output[2]} " \
                "{output[1]} " \
                "{output[3]} " \
                "LEADING:{params.LEADING} " \
                "TRAILING:{params.TRAILING} " \
                "SLIDINGWINDOW:{params.SLIDINGWINDOW} " \
                "MINLEN:{params.MINLEN} "

rule fastqc_2:
    input: \
        "trimmomatic/results/{sample}.out.trimmed.fastq"
    output: \
        "fastqc/fastqc_2/results/{sample}.out.trimmed_fastqc.html"
    conda: 
        "envs/fastqc.yml"
    params: 
        FILETYPE="fastq"
    threads:2
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    shell: \
        "fastqc -t {threads} " \
        "-f {params.FILETYPE} " \
        "--outdir fastqc/fastqc_2/results/ " \
        "{input} "

rule kraken2:
    input: \
        "trimmomatic/results/{sample}_1.out.trimmed.fastq",  \
        "trimmomatic/results/{sample}_2.out.trimmed.fastq"
    output: \
        "kraken2/results/{sample}_paired_kraken_report"
    threads:2
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    conda:
        "envs/kraken2.yml"    
    shell: \
        "kraken2 --paired " \
                "--classified-out c#.out.trimmed.fastq " \
                "{input[0]} "  \
                "{input[1]} " \
                "--threads {threads} " \
                "--output - " \
                "--db kraken2/dbs " \
                "--report {output} " \

rule mpa_style_reports:
    input: \
        "trimmomatic/results/{sample}_1.out.trimmed.fastq",  \
        "trimmomatic/results/{sample}_2.out.trimmed.fastq"
    output: \
        "kraken2/results/mpa_style/{sample}_paired_mpa_report"
    threads:2
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    conda:
        "envs/kraken2.yml"    
    shell: \
        "kraken2 --paired " \
                "--classified-out c#.out.trimmed.fastq " \
                "{input[0]} "  \
                "{input[1]} " \
                "--threads {threads} " \
                "--output - " \
                "--db kraken2/dbs " \
                "--report {output} " \
                "--use-mpa-style " \

rule bracken: 
    input: \
        "kraken2/results/{sample}_paired_kraken_report"
    output: \
        "bracken/results/{sample}_bracken_report"
    params:
        READ_LEN="100",
        CLASSIFICATION_LEVEL="S",
        THRESHOLD="1",
    conda:
        "envs/bracken.yml"
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    shell:
        "bracken/bracken/bracken -d kraken2/dbs/ " \
                "-i {input} "  \
                "-o {output} " \
                "-r {params.READ_LEN} " \
                "-l {params.CLASSIFICATION_LEVEL} " \
                "-t {params.THRESHOLD} "

rule kreport2krona: 
    input: \
        "kraken2/results/{sample}_paired_kraken_report"
    output: \
        "krakentools/results/krona/{sample}_pre_krona.tsv"
    conda:
        "envs/krakentools.yml"
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    shell:
        "krakentools/KrakenTools/kreport2krona.py " \
                "-r {input} "  \
                "-o {output} " 

rule bracken_filter:
    input: \
        "bracken/results/{sample}_bracken_report"
    output: \
        "krakentools/results/bracken_filter/{sample}_bracken_filtered"
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>
    conda:
        "envs/krakentools.yml"
    params:
        EX="", 
        IN="544448 2085 2092 2093 2683645 2683967 353851 2801918 \
        2742195 640330 2725994 2967301 754514 1749074 2810348 2967302 \
        2963128 2963127 2967300 2967299 656088 2102 40477 44100 862259 436113 \
        2103 44101 272632 865867 2095 40479 340047 40480 927701 1124992 1179777 \
        2105 866629 880447 519450 29501 941640 353852 136241 1111676 57372 768700 \
        708248 2123 1292033 743965 50052 512564 1612150 141391 1212765 754515 171632 \
        1415773 2726117 65123 1197325 547987 754517 51364 754516 292461 538220 51365 743967 \
        984991 1403316 1665628 142651 2905920 75590 280702"
    shell: \
         "krakentools/KrakenTools/filter_bracken.out.py " \
                "-i {input} " \  
                "--include {params.IN} " \  
                "--exclude {params.EX} " \  
                "-o {output} "   

rule krona:
    input: \
        "krakentools/results/krona/{sample}_pre_krona.tsv"
    output: \
        "krona/results/{sample}_krona.html"
    params:
        n="all"
    conda:
        "envs/krona.yml"
    # resources: \
    #     runtime=<maximum_runtime_in_minutes>, \
    #     mem=<memory_in_megabytes>, \
    #     slurm_partition="<desired_partition>", \
    #     tasks=<number_of_tasks>    
    shell: \
        "ktImportText -n {params.n} " \
                          "-o {output} " \
                          "{input} " \

                          
