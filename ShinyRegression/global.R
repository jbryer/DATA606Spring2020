library(shiny)
library(tidyverse)

sat <- read.csv('../course_data/SAT_scores.csv', stringsAsFactors=FALSE)
names(sat) <- c('Verbal','Math','Sex')
sat$Verbal <- as.integer(sat$Verbal)
sat$Math <- as.integer(sat$Math)
sat <- sat[complete.cases(sat),]

df <- data.frame(x = sat$Verbal, y = sat$Math)
