
# Map script
rm(list=ls(all=TRUE))

setwd("/Users/anderssundell/Dropbox/Jupyter/stathelp/shiny")

library(tidyverse)
library(shiny)

func.dicegood <- function(){
  dicepair_1 <- sample(1:6, 2, replace=TRUE)
  return(dicepair_1)
}

func.dicebad <- function(){
  dicepair_2 <- sample(1:9, 2, replace=TRUE)
  
  if (dicepair_2[1] <= 4) {
    dicebad.1 <- dicepair_2[1]
  } else if (dicepair_2[1] == 4 | dicepair_2[1]==5) {
    dicebad.1 <- 4
  } else if (dicepair_2[1] == 6 | dicepair_2[1]==7) {
    dicebad.1 <- 5
  } else if (dicepair_2[1] == 8 | dicepair_2[1]==9) {
    dicebad.1 <- 6
  }
  
  if (dicepair_2[2] <= 4) {
    dicebad.2 <- dicepair_2[2]
  } else if (dicepair_2[2] == 4 | dicepair_2[2]==5) {
    dicebad.2 <- 4
  } else if (dicepair_2[2] == 6 | dicepair_2[2]==7) {
    dicebad.2 <- 5
  } else if (dicepair_2[2] == 8 | dicepair_2[2]==9) {
    dicebad.2 <- 6
  }
  
  dicepair_2 <- c(dicebad.1, dicebad.2)
  return(dicepair_2)
}

func.dicegood()
func.dicebad()


# EMPTY DATASET
dicedata <- data.frame(nr=as.integer(), good=as.integer(), bad=as.integer())
nr_rolls <- 0

# ASSIGN NEW ROLL TO DATASET
for (nr in 1:1000){
nr_rolls <- nr_rolls+1
dicerolls <- c(nr_rolls, sum(func.dicegood()), sum(func.dicebad()))
dicedata[nrow(dicedata)+1,] <- dicerolls
}

ggplot(dicedata) +
  geom_histogram(aes(x=good), fill="green", alpha=0.5, bins=11) +
  geom_histogram(aes(x=bad), fill="red", alpha=0.5, bins=11)
  


runExample("03_reactivity") # a reactive expression
runExample("04_mpg")        # global variables

runExample("07_widgets")    # help text and submit buttons
