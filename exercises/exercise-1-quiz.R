rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.
cat("\014") # Clear the console

# verify root location
cat("Working directory: ", getwd()) # Must be set to Project Directory
# if the line above DOES NOT generates the project root, re-map by selecting 
# Session --> Set Working Directory --> To Project Directory location
# Project Directory should be the root by default unless overwritten

# ---- load-packages -----------------------------------------------------------
library(magrittr)  # pipes
library(dplyr)     # data wrangling
library(ggplot2)   # graphs
library(janitor)   # tidy data
library(tidyr)     # data wrangling
library(forcats)   # factors
library(stringr)   # strings
library(lubridate) # dates

# ---- load-sources ------------------------------------------------------------

# ---- declare-globals ---------------------------------------------------------
# Note: when printing to Word or PDF use `neat(output_format =  "pandoc")`


# ---- load-data ---------------------------------------------------------------
ds_quiz_template <- readr::read_csv("./quizzes/respondus-csv-column-names.csv")

target_items <- c(
  
)

import::from("magrittr", "%>%")
babynames::babynames %>%
  dplyr::filter(year == 1880L) %>%
  dplyr::pull(name)


# ---- tweak-data --------------------------------------------------------------


# ---- table-1 -----------------------------------------------------------------

