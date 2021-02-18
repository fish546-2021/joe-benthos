library('here')
library('dplyr')

# load Rarmon's data
ASV_table <- read.csv(here('data','ASV_table_all_together.csv'))
taxonomy_table <- read.csv(here('data','all.taxonomy.20190130.csv'))

# NA's in ASV_table hash? 
sum(is.na(ASV_table$Hash))
sum(is.na(taxonomy_table$Hash))

# merge ASV table and taxonomy table on hash column
ASV_tax <- inner_join(ASV_table, taxonomy_table)

unique(ASV_tax$sample)
sum(unique(ASV_tax$sample))

#OYSTERS filter
oysters <- ASV_tax %>%
  filter(genus %in% c('Ostrea','Crassostrea'))
