library('here')
library('dplyr')
library('stringr')

# load Rarmon's data
ASV_table <- read.csv(here('asv-output','ASV_table_all_together.csv'))
taxonomy_table <- read.csv(here('asv-output','all.taxonomy.20190130.csv'))

# NA's in ASV_table hash? 
sum(is.na(ASV_table$Hash))
sum(is.na(taxonomy_table$Hash))

# merge ASV table and taxonomy table on hash column
ASV_tax <- inner_join(ASV_table, taxonomy_table)

unique(ASV_tax$sample)

#OYSTERS filter
oysters <- ASV_tax %>%
  #filter(genus %in% c('Ostrea','Crassostrea'))
  filter(genus %in% c('Ostrea'))

oysters_str <- ASV_tax %>%
  filter(str_detect(genus, 'Ostrea')) #these filters do the same thing 

# balanus filter
balanus <- ASV_tax %>%
  filter(str_detect(genus, 'Balanus'))

# STAR FEEESH
 starfeesh <- ASV_tax %>%
   filter(str_detect(family, "Asteriidae"))

# how bout octopus?
 salmon <- ASV_tax %>%
   filter(str_detect(family, "Salmonidae"))

# geoduck
 geoduck <- ASV_tax %>%
   filter(str_detect(family, 	"Hiatellidae"))

# LL filter
LL_oysters <- oysters %>%
  filter(str_detect(sample, "LL")) 

#Sample test filter 
by_sample_test <- ASV_tax %>% 
  filter(str_detect(sample, "LL_201703"))

#taxonomy no.na
tax_nona <- taxonomy_table[!is.na(taxonomy_table$species), ]
  
