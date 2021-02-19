library('here')
library('dplyr')
library('stringr')
library('data.table')
library('treemap')
library('d3treeR')

library(phyloseq); packageVersion("phyloseq")
library(Biostrings); packageVersion("Biostrings")
library(ggplot2); packageVersion("ggplot2")

#higher taxa table
higher_tax <- read.csv(here('asv-output','higher_taxonomy.csv'))

#table of class and order sums
class_order_table <- table(higher_tax$class, higher_tax$order)
class_table <- (table(higher_tax$class))

#convert to dataframe, sort by descending freq
class_order_df <- class_order_table %>%
  as.data.frame() %>%
  arrange(desc(Freq)) %>%
  top_n(20) 

#rename cols
class_order_df <- rename(class_order_df, Var1 = "class", Var2 = "order")

#sanity check for class totals with class table   
class_df <- class_table %>%
  as.data.frame() %>%
  arrange(desc(Freq)) %>%
  top_n(100)

#treemap code (could make this interactive weidget for less clutter?)
jpeg("rough_treemap.jpeg", width = 700, height = 700)

rough_treemap <- treemap(class_order_df,
             index=c("class","order"),
             vSize="Freq",
             type="index",
             palette = "Set1",
             bg.labels=c("white"),
             align.labels=list(
               c("center", "center"), 
               c("right", "bottom")
             ),
             title="Class and Order Presence in Dataset"
)            
dev.off()
