# joe-benthos

## Summary
Initial attempt to reproduce and expand on analysis of Hood Canal and San Juan Islands eDNA data. Raw data and original bioinformatic pipeline available on [Ramon Gallego's github](https://github.com/ramongallego/Harmful.Algae.eDNA) The related Ocean Acidification project and pipeline is available [here](https://github.com/ramongallego/eDNA.and.Ocean.Acidification.Gallego.et.al.2020).

## Workflow 
The subset fastq file is run through FastQC [here](https://github.com/fish546-2021/joe-benthos/blob/main/code/03-blast-hcdata.ipynb). As a further sanity and quality check I converted the fastq -> fasta using seqtk, then I ran blast on the fasta file against the uniprot database. The output is available in [analysis](https://github.com/fish546-2021/joe-benthos/tree/main/analysis). Blast matches CO1 protiens as expected.

The next step with the Hood Canal data will be to demultiplex it either with [this custom pipeline](https://github.com/ramongallego/demultiplexer_for_dada2), a subset of the Stax package, or with bcl2fastq.

To get "end data" the demultiplexed fastq files will be denoised and assigned taxa using dada2. Since my data is not yet formated, I ran through the dada2 tutorial with their mouse gut data and created this [taxa table output](https://github.com/fish546-2021/joe-benthos/blob/main/analysis/mouse-gut-tutorial-taxa.csv). 

## TODO
*To connect both ends of the pipeline I need to demultiplex my data and get it into the correct format to run through dada2. 
*I would like to further familiarize myself with blast and blast params as an alternative for exploring the raw reads. 
*I also need to to read up/watch more on read quality, and PCR artifacts so I can make informed decisions about qa/qc and discarding data. 
*Once I get my taxa tables by sample site, technical replicates and biological replicates I need to find creative ways to visualize presence/absense and relative abundance in order to draw insights from the data. 
