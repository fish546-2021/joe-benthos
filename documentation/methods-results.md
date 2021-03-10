Methods and Results
================
Joe Duprey
3/8/2021

## Dependencies

**General**

-   FastQC  
-   MultiQC
-   Insect 1.2

**Demultiplexer\_for\_DADA2**

-   cutadapt  
-   vsearch  
-   swarm  
-   seqtk  
-   blast+  
-   python  
-   pandoc

**R**

-   data.table  
-   devtools  
-   reshape2  
-   vegan  
-   taxize  
-   tidyverse  
-   stringr  
-   dada2  
-   Biostrings  
-   digest

To retrieve Moncho’s custom demultiplexing script:
`git clone https://github.com/ramongallego/demultiplexer_for_DADA2.git <directory>`

## Background

Sequence data comes from eDNA collection by water bottle sampling of 8
sites along the Hood Canal and San Juan Island in Washington State USA.
A 313bp region of the COI region was amplified by PCR. Multiplexed
samples were sequenced using MiSeq v2-500 kits according to manufacturer
protocols.

For detailed methods see [Gallego et al
2020](https://www.biorxiv.org/content/10.1101/2020.10.08.331694v1.full)

## Retrieve Sequence Data

First I retrieve the subset sequence data from where I uploaded it to
Gannet. Replace `paths` and `server name` where appropriate.

``` bash
scp casowari@Gannet.fish.washington.edu:/<path/to/>zipped.fastqs.zip \
../data/directory/zipped.fastqs.zip
```

Alternatively you may retrieve the full fastqs
[here](https://drive.google.com/drive/folders/1XtuDMdlnk9V2acNiPJo5T6O1Tp0KjaCz)

This pipeline runs with the fewest headaches if scripts are place in the
`./code` folder.

``` bash
#should be in the code directory of your project
pwd
```

Make sure your data is in your `./data` folder

``` bash
#what's in the data folder?
ls ../data/directory
```

Find all zips from cloned folder and unzip them to `./data`, then unzip
the `fastq.gz` files

``` bash
#find all zips from cloned folder and unzip them to ../data
find ../data/directory -name "*.zip" | xargs echo | xargs unzip -d ../data \
find ../data/ -name "*.fastq.gz" | xargs gunzip
```

## Quality Control

Now all the sequence data should be in `.fastq`. This makes it easy to
run fastqc, and then compile fastqc results with multiqc. Replace the
fastqc path with the location of your installation.

``` bash
find ../data/ -name "*.fastq" | xargs \
/Applications/bioinformatics/FastQC/fastqc \
-o ../analysis/fastqc-out
```

Make sure the fastqc files are in the right spot.

``` bash
#where are my fastqc files?
ls ../analysis/fastqc-out/
```

For easiest multiqc, navigate to the fastqc folder and run multiqc.

``` bash
cd ../analysis/fastqc-out
pwd
multiqc .
```

## Demultiplexing

The simpler workflow is to run Moncho’s custom script
`demultiplex_both_fastqs.sh` to demultiplex, filter, denoise, and pair
reads. The output of this script is an ASV table and a hash key, along
with various logs and metadata from the dada2 tools used by the script.

I found the best way to run the script was to preserve the directory
structure of `/demultiplexer_for_DADA2/` as cloned. In order to run the
script we need to empty `/demultiplexer_for_DADA2/data/` and move our
data in.

``` bash
find ../../demultiplexer_for_DADA2/data -name "*fastq" | xargs \
rm 
find ../data/ -name "*.fastq" | xargs \
mv -t ../../demultiplexer_for_DADA2/data/
```

In order to run successfully `demultiplex_both_fastqs.sh` needs the
following inputs:

-   One or more pairs of fastq files in the
    `demultiplexer_for_DADA2/data/` directory.
-   A metadata file, containing the names of the paired files, the index
    sequences, and the sample name.
-   See Moncho’s metadata example:

<!-- -->

    # A tibble: 93 x 6
      sample_id Tag    pri_index_name sec_index_seq file1        file2       
      <chr>     <chr>  <chr>          <chr>         <chr>        <chr>       
    1 SA07A.1   Tag_12 Lib_B          GATGAC        Lib-B_S2_L0… Lib-B_S2_L0…
    2 SA07B.1   Tag_12 Lib_D          GATGAC        Lib-D_S4_L0… Lib-D_S4_L0…
    3 SA07C.1   Tag_4  Lib_B          GCGCTC        Lib-B_S2_L0… Lib-B_S2_L0…
    4 TR07A.1   Tag_8  Lib_G          CTCGCA        Lib-G_S7_L0… Lib-G_S7_L0…
    5 TR07B.1   Tag_2  Lib_A          ACAGCA        Lib-A_S1_L0… Lib-A_S1_L0…
    6 TR07C.1   Tag_10 Lib_B          TGTATG        Lib-B_S2_L0… Lib-B_S2_L0…
    7 LL07A.1   Tag_7  Lib_G          ATATCG        Lib-G_S7_L0… Lib-G_S7_L0…
    8 LL07B.1   Tag_1  Lib_A          ACACAC        Lib-A_S1_L0… Lib-A_S1_L0…
    9 LL07C.1   Tag_5  Lib_G          ACATGT        Lib-G_S7_L0… Lib-G_S7_L0…
    10 PO07A.1   Tag_9  Lib_A          TCGCAT        Lib-A_S1_L0… Lib-A_S1_L0…
    # ... with 83 more rows

To set the behavior of `demultiplex_both_fastqs.sh` navigate to
`demultiplexer_for_DADA2/banzai_params_for_DADA2.sh`.

Under `# INPUT` set `SEQUENCING_METADATA="${PARENT_DIR}"/metadata.csv`
to the desired metadata folder.

**WARNING:** Do not change `PARENT_DIR` or `OUTPUT_DIRECTORY` settings.
The output directory is your home directory or `~` which is
inconvenient, but setting the `OUTPUT_DIRECTORY` to either
`/demultiplexer_for_DADA2/fastqs_demultiplexed_for_DADA2` or
`./fastqs_demultiplexed_for_DADA2` resulted in file path errors.

Under `# METADATA DETAILS` make sure the `COLNAME` labels are
appropriate for your metadata file.

Under `# QUALITY FILTERING` set the threshold of expected error rate,
over which `dada2` will filter out a sequence.

Under `# DEMULTIPLEXING` define secondary index sequences.

**Now that the metadata is formatted correctly and the paired fastqs are
in `demultiplexer_for_DADA2/data`, we can run the Moncho’s script.**

If `cutadapt` was installed via `conda -install` make sure the
environment is active.

``` bash
conda activate cutadaptenv
```

**Run `demultiplex_both_fastqs.sh`**

``` bash
bash <path/to/dir>/demultiplex_both_fastqs.sh <path/to/dir>/banzai_params_for_dada2.sh
```

## Assigning Taxa

The output of `demultiplex_both_fastqs.sh` will be placed in a folder in
your home directory
`~/fastqs_demultiplexed_for_dada2/demultiplexed_date_time`. I coped that
subfolder to `./analysis/01-demultiplexed` this can be done via GUI or
as follows:

``` bash
mv ~/fastqs_demultiplexed_for_dada2/demultiplexed_date_time ../analysis/01-demultiplexed
```

**Note:** I ran all the following analysis code from the `./analysis`
directory and the paths are formatted for this.

We will load both the `hash_key.csv` and `ASV_table.csv` into R. We will
join them and convert to the wide format `seq_tab.csv` format that
Insect requires for taxa assignment. Workflow adapted from the (Insect
Tutorial)\[<https://cran.r-project.org/web/packages/insect/vignettes/insect-vignette.html>\].

``` r
data(samoa)
ASV_tab <- read.csv(here('./01-demultiplexed','ASV_table.csv'))
hash_key <- read.csv(here('./01-demultiplexed','hash_key.csv'))

seq_tab <- inner_join(ASV_tab, hash_key)
seq_tab <- select(seq_tab, -c(Hash))

seq_tab <- seq_tab %>% 
  spread(Sequence, nReads) %>%
  replace(is.na(.), 0)
```

Download the classifier.

``` r
download.file("https://www.dropbox.com/s/dvnrhnfmo727774/classifier.rds?dl=1", 
              destfile = "classifier.rds", mode = "wb")
```

Format the ASVs for readability and store the classifier as a variable
in the workspace.

``` r
## get sequences from table column names
x <- char2dna(colnames(seq_tab))
## name the sequences sequentially
names(x) <- paste0("ASV", seq_along(x))
## optionally remove column names that can flood the console when printed
# colnames(seq_tab) <- NULL 

classifier <- readRDS("classifier.rds")
classifier
names(attributes(classifier))
```

Finally, assign reads to taxa and write the output to
`./analysis/all.the.useful.tables/`!

``` r
longDF <- classify(x, classifier, threshold = 0.8)

longDF <- cbind(longDF, t(seq_tab))

write_csv(longDF, './all.the.useful.tables/01subset.taxa.table.csv')
```

## Results

The data reshaping code in this results section uses output from
Moncho’s original run of the pipeline, but should work with subset data
as well.

First we need to read in the sampling events and join the taxonomy\_hash
table with the ASV\_table.

``` r
events <- read.csv(here('all.the.useful.tables','clusters.of.events.csv'))
ASV_table <- read.csv(here('all.the.useful.tables','ASV_table_all_together.csv'))
taxonomy_table <- read.csv(here('all.the.useful.tables','all.taxonomy.20190130.csv'))

# merge ASV table and taxonomy table on hash column
ASV_tax <- inner_join(ASV_table, taxonomy_table)
```

Sample notation is as follows `LL_201703A.1` The capital letter
represents the biological replicate. The .numeral represents the
PCR/technical replicate. Using strings we can sum all reads within a
taxon and within a taxon and sampling event-grouping.

``` r
by_species_df <- ASV_tax %>%
  group_by(sample, species) %>% # group the columns you want to "leave alone"
  summarize(nReads=sum(nReads)) %>% #sum nReads
  separate(col=sample, into=c('sample','tech'), sep='[.]') %>% 
  separate(col=sample, into=c("sample", "bio"), sep = 9)

by_site_species <- by_species_df %>%
  group_by(sample, species) %>%
  summarize(nReads=sum(nReads)) #sum nReads by species+sample - is this correct??
```

In order to match taxa reads to event conditions we need to run this
goofy bit of event-string reformatting code.

``` r
events$event <- str_remove(events$event, "[-]") # find a better way to do this please
events$event <- str_remove(events$event, "[-]")
events <- events %>%
  separate(col=event, into=c("sample", "foo"), sep = 9)
```

Since my main focus is community structure, I want to convert nReads
data into species richness. To do this create a dummy variable on the
table grouped by speces+site, then summarize the dummy variable to get
species richness by site. Lastly, inner join this table to the
oceanographic data on the events table.

``` r
by_site_species$diversity <- 1

# how many species at each sampling event
species_div <- by_site_species %>%
  group_by(sample, diversity) %>%
  summarize(diversity=sum(diversity)) #sum dummy to get species diversity 

# join with oceanographic data 
species_div_env <- inner_join(species_div, events)
```

Data can be explored with scatter plots:

``` r
# species diversity vs pH new pH?
jpeg("./figures/pH.richness.jpg", width = 500, height = 500)
plot(species_div_env$pH_new, species_div_env$diversity, xlim=c(7.5,8.7),
     main = 'Species Richness vs pH',
     xlab = 'pH',
     ylab = 'species richness')
dev.off()
```

Or as time series:

``` r
div_by_site <- function(location){
  samp_div <- species_div_env %>%
    filter(str_detect(sample, location))
  
  barplot(samp_div$diversity, names.arg = samp_div$sample, las=2,
          main = location,
          ylab = 'species richness',
          ylim = c(0,100))
}

# lets use that function!
jpeg("./figures/FH.series.jpg", width = 500, height = 500)
div_by_site("FH")
dev.off()
```

[Example
Figures](https://github.com/fish546-2021/joe-benthos/tree/main/analysis/figures)
