import os
import glob
from snakemake.io import expand

configfile: "config.yaml"

SRA = config["sra_number"]
FASTQ = config["fastq_dir"]
ASSEMBLY = config["assembly_dir"]
ANNOTATION = config["annotation_dir"]

rule all:
    input: 
        expand("{annotation_dir}" + "{sra_number}_annotated_genome.gbk",
        annotation_dir = ANNOTATION,
        sra_number = SRA)

rule download_fastq:
    input:
    output:
        expand("{fastq_dir}" + "{sra_number}.fastq.gz", 
        fastq_dir = FASTQ, sra_number = SRA)
    params:
        sra_number = SRA,
        fastq_dir = FASTQ
    shell:
        '''
        fastq-dump {params.sra_number} --outdir {params.fastq_dir} --gzip
        '''

rule assemble:
    input:
        expand("{fastq_dir}" + '{sra_number}' + ".fastq.gz",
        fastq_dir = FASTQ, sra_number = SRA)
    output:
        expand("{assembly_dir}" + '{sra_number}' + "/assembly.fasta",
        assembly_dir = ASSEMBLY, sra_number = SRA)
    shell:
        '''
        flye --nano-raw {input} --out-dir {wildcards.sra_number}
        '''

rule annotate:
    input:
        assembly = expand("{assembly_dir}" + "{sra_number}/assembly.fasta",
        assembly_dir = ASSEMBLY, sra_number = SRA)
    output:
        expand("{annotation_dir}" + '{sra_number}' + "_annotated_genome.gbk",
        annotation_dir = ANNOTATION, sra_number = SRA)
    shell:
        '''
        prokka --outdir {annotation_dir} --prefix {wildcards.sra_number} {input.assembly}
        '''
