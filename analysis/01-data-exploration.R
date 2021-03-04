library('here')
library('dplyr')
library('stringr')
library('tidyverse')

# load Rarmon's data
ASV_table <- read.csv(here('asv-output','ASV_table_all_together.csv'))
taxonomy_table <- read.csv(here('asv-output','all.taxonomy.20190130.csv'))

# load in the sampling events, these could be useful for combining replicates 
events <- read.csv(here('asv-output','clusters.of.events.csv'))

# NA's in ASV_table hash? 
sum(is.na(ASV_table$Hash))
sum(is.na(taxonomy_table$Hash))

# merge ASV table and taxonomy table on hash column
ASV_tax <- inner_join(ASV_table, taxonomy_table)

unique(ASV_tax$sample)

#just messing around with taxa
#------------------------------------------------------------------------------
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

# how bout octopus
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

#------------------------------------------------------------------------------
# double check: all sample notation strings are 10 characters long 
# by_species_df$samp_len <- str_count(by_species_df$sample)
# unique(by_species_df$samp_len)

# ok lets try to summarize by summing all reads within a taxon and a site/sample.
by_species_df <- ASV_tax %>%
  group_by(sample, species) %>% # group the columns you want to "leave alone"
  summarize(nReads=sum(nReads)) %>% #sum nReads
  separate(col=sample, into=c('sample','tech'), sep='[.]') %>% 
  separate(col=sample, into=c("sample", "bio"), sep = 9)

by_site_species <- by_species_df %>%
  group_by(sample, species) %>%
  summarize(nReads=sum(nReads)) #sum nReads by species+sample - is this correct??

#------------------------------------------------------------------------------
ostrea <- by_site_species %>%
  filter(species %in% c('Ostrea lurida'))

# log transform to make data exploration easier? 
ostrea$nReads <- log(ostrea$nReads)

littorina <- by_site_species %>%
  filter(species %in% c('Littorina plena'))

# or should i leave nReads untouched? 
# littorina$nReads <- log(littorina$nReads)

#lets see if we can match oyster data up with environmental data 
#------------------------------------------------------------------------------
events$event <- str_remove(events$event, "[-]") # find a better way to do this please
events$event <- str_remove(events$event, "[-]")
events <- events %>%
  separate(col=event, into=c("sample", "foo"), sep = 9)

# join environmental/oceanographic variables with nReads of ostrea 
ostrea_env <- inner_join(ostrea, events)

# lets try some scatter plots log(nReads) vs environmental variables
plot(ostrea_env$Temperature, ostrea_env$nReads)

jpeg("./figures/ostrea_pH.jpg", width = 500, height = 500)
plot(ostrea_env$pH_new, ostrea_env$nReads, main="log(Olympia Oyster Reads) vs. pH", xlab="pH",ylab="nReads over all replicates")
dev.off()

plot(ostrea_env$mean.DIC, ostrea_env$nReads)
plot(ostrea_env$Omega.aragonite, ostrea_env$nReads)

# with littorina now - i should really make a function for this 
littorina_env <-inner_join(littorina, events)

# take a look at similar scatter plots without the log transform 
plot(littorina_env$Temperature, littorina_env$nReads)
plot(littorina_env$pH_new, littorina_env$nReads)

# break data down by sampling site to look at time series 
#-------------------------------------------------------------------------------
# should make a function 
LL_littorina <- littorina_env %>%
  filter(str_detect(sample, "LL"))

TR_littorina <- littorina_env %>%
  filter(str_detect(sample, "TR"))

LK_littorina <- littorina_env %>%
  filter(str_detect(sample, "LK"))

# low resolution time series, are these even useful? 
jpeg("./figures/LL_littorina.jpg", width = 500, height = 500)
barplot(LL_littorina$nReads, names.arg = LL_littorina$sample, las=2)
dev.off()

jpeg("./figures/TR_littorina.jpg", width = 500, height = 500)
barplot(TR_littorina$nReads, names.arg = TR_littorina$sample, las=2)
dev.off()

jpeg("./figures/LK_littorina.jpg", width = 500, height = 500)
barplot(LK_littorina$nReads, names.arg = LK_littorina$sample, las=2)
dev.off()

#saving useful CSVs
#---------------------------------------------------------------------
write_csv(by_site_species, "./asv-output/by.site.species.csv")
write_csv(by_species_df, "./asv-output/by.species.csv")
write_csv(littorina_env, "./asv-output/littorina.env.example.csv")
