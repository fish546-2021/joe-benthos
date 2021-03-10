library(insect)
library(here)
library(tidyverse)
library(reshape2)

# uncomment if file is needed
#download.file("https://www.dropbox.com/s/dvnrhnfmo727774/classifier.rds?dl=1", 
#              destfile = "classifier.rds", mode = "wb")

# insect tutorial 
# https://cran.r-project.org/web/packages/insect/vignettes/insect-vignette.html

## read in the example seqtab.nochim ASV table
data(samoa)
# see what example data looks like 
samoa_df <- as.data.frame(samoa)

ASV_tab <- read.csv(here('./01-demultiplexed','ASV_table.csv'))
hash_key <- read.csv(here('./01-demultiplexed','hash_key.csv'))

seq_tab <- inner_join(ASV_tab, hash_key)
seq_tab <- select(seq_tab, -c(Hash))

seq_tab = seq_tab %>% 
  spread(Sequence, nReads) %>%
  replace(is.na(.), 0) 

seq_tab <- data.frame(seq_tab[,-1], row.names = seq_tab[,1])

## get sequences from table column names
x <- char2dna(colnames(seq_tab))
## name the sequences sequentially
names(x) <- paste0("ASV", seq_along(x))
## optionally remove column names that can flood the console when printed
# colnames(seq_tab) <- NULL 

classifier <- readRDS("classifier.rds")
classifier
names(attributes(classifier))

longDF <- classify(x, classifier, threshold = 0.8)

longDF <- cbind(longDF, t(seq_tab))

write_csv(longDF, './all.the.useful.tables/01subset.taxa.table.csv')

# for a more succinct output we can aggregate the table to only include one row 
# for each unique taxon as follows:

#taxa <- aggregate(longDF[3:12], longDF["taxID"], head, 1)
#counts <- aggregate(longDF[13:ncol(longDF)], longDF["taxID"], sum)
#shortDF <- merge(taxa, counts, by = "taxID")
