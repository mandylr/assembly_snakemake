# assembly_snakemake
A snakemake pipeline for bacterial genome assembly from ONT reads.

## Requirements

- Snakemake
- SRA Toolkit (for fastq-dump)
- flye (for genome assembly)
- prokka (for genome annotation)

## Usage

1. Update `config.yaml` with your SRA ID.
2. Run the pipeline:

   ```bash
   snakemake --cores 4



