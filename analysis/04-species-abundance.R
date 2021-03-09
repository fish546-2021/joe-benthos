library('here')
library('dplyr')
library('stringr')
library('tidyverse')

# load my species tables
by_site_species <- read.csv(here('all.the.useful.tables','by.site.species.csv'))
events <- read.csv(here('all.the.useful.tables', 'events.joe.format.csv'))

by_site_species$diversity <- 1

# how many species at each sampling event
species_div <- by_site_species %>%
  group_by(sample, diversity) %>%
  summarize(diversity=sum(diversity)) #sum dummy to get species diversity 

# join with oceanographic data 
species_div_env <- inner_join(species_div, events)

# species diversity vs pH new pH?
jpeg("./figures/pH.richness.jpg", width = 500, height = 500)
plot(species_div_env$pH_new, species_div_env$diversity, xlim=c(7.5,8.7),
     main = 'Species Richness vs pH',
     xlab = 'pH',
     ylab = 'species richness')
dev.off()

# function for plotting species diversity over time - barplot
# string as argument


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

jpeg("./figures/LL.series.jpg", width = 500, height = 500)
div_by_site("LL")
dev.off()

jpeg("./figures/LK.series.jpg", width = 500, height = 500)
div_by_site("LK")
dev.off()

jpeg("./figures/SA.series.jpg", width = 500, height = 500)
div_by_site("SA")
dev.off()

jpeg("./figures/CP.series.jpg", width = 500, height = 500)
div_by_site("CP")
dev.off()

jpeg("./figures/PO.series.jpg", width = 500, height = 500)
div_by_site("PO")
dev.off()

jpeg("./figures/TR.series.jpg", width = 500, height = 500)
div_by_site("TR")
dev.off()

jpeg("./figures/TW.series.jpg", width = 500, height = 500)
div_by_site("TW")
dev.off()

# more scatter plots, salinity, temperature  
jpeg("./figures/salinity.richness.jpg", width = 500, height = 500)
plot(species_div_env$Salinity, species_div_env$diversity,
     main = 'Species Richness vs Salinity',
     xlab = 'salinity',
     ylab = 'species richness')
dev.off()

jpeg("./figures/salinity.temp.jpg", width = 500, height = 500)
plot(species_div_env$Temperature, species_div_env$diversity,
     main = 'Species Richness vs Temperature',
     xlab = 'temperature C',
     ylab = 'species richness')
dev.off()

# OKAY now for benthic function groups
# --------------------------------------------------------------------------
# i need a list of species of interest, then weed out the other, then view the data 
# species diversity -> read species richness (oops)

write_csv(species_div, "./all.the.useful.tables/joe.species.div.csv")
write_csv(species_div_env, "./all.the.useful.tables/joe.species.div.env.csv")

