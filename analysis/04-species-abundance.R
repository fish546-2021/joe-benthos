library('here')
library('dplyr')
library('stringr')
library('tidyverse')

# load my species tables
by_site_species <- read.csv(here('asv-output','by.site.species.csv'))
events <- read.csv(here('asv-output', 'events.joe.format.csv'))

by_site_species$diversity <- 1

# how many species at each sampling event
species_div <- by_site_species %>%
  group_by(sample, diversity) %>%
  summarize(diversity=sum(diversity)) #sum dummy to get species diversity 

# join with oceanographic data 
species_div_env <- inner_join(species_div, events)

# species diversity vs pH new pH?
plot(species_div_env$pH_new, species_div_env$diversity, xlim=c(7.5,8.7))


# function for plotting species diversity over time - barplot
# string as argument


div_by_site <- function(location){
  samp_div <- species_div_env %>%
    filter(str_detect(sample, location))
  
  barplot(samp_div$diversity, names.arg = samp_div$sample, las=2)
}

# lets use that function!
div_by_site("FH")
div_by_site("LL")
div_by_site("LK")
div_by_site("SA")
div_by_site("CP")
div_by_site("PO")
div_by_site("TR")
div_by_site("TW")

# more scatter plots, salinity, temperature  
plot(species_div_env$Salinity, species_div_env$diversity)
plot(species_div_env$Temperature, species_div_env$diversity)

# OKAY now for benthic function groups
# --------------------------------------------------------------------------
# i need a list of species of interest, then weed out the other, then view the data 
# species diversity -> read species richness (oops)
