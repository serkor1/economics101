# Clear memory; ####
rm(list = ls()); gc()

# Packages; ####
library(shiny)
library(shinyWidgets)
library(shinydashboard)
library(shinydashboardPlus)
library(tidyverse)
library(plotly)

list.files(
  path = "r/",full.names = TRUE
) %>% map(
  .f = function(x) {
    
    source(x)
    
  }
)


