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
path_db <- "./data-public/textbook/oreilly_getting_started_with_sql/rexon_metals.db"

# ---- load-data ---------------------------------------------------------------
ds_quiz_template <- readr::read_csv("./quizzes/respondus-csv-column-names.csv")

# target_items <- c(
#   
# )
# 
# 
# sql_question <- c(
#   "
#   -- 1. How many unique customers does Rexon Metal have?
#   ---- Requirements:
#   ---- Must use: SELECT, count()
#   "
# )
# 
sql_solution <- c(
  "
  SELECT  count(distinct(customer_id))
  FROM  customer
  ;
  "
)

input <- yaml::read_yaml("data-public/exercises/exercise-1-input.yml")
output <- input # Start with the same input, and augment it wil the answers.
 
for(i in seq_along(input)) {
  sql_solution <- input[[i]]$code
  
  cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
  ds_solution <- DBI::dbGetQuery(cnn, sql_solution)
  DBI::dbDisconnect(cnn); rm(cnn, sql_solution)
  
  output[[i]]$answer <- ds_solution[1,1]
}

yaml::write_yaml(output, "data-public/exercises/exercise-1-output.yml")


# solution_value <- ds_solution[1,1]


# ---- convert-lists-to-rectangle ----------------------------------------------

output %>% 
  purrr::map_dfr(
    magrittr::extract,
    c(
      "prompt",
      "code",
      "answer"
    )
  ) %>% 
  dplyr::rename(
    `Question Wording` = prompt
  )


# # ---- q01 -------------------------------------
# 
# -- 1. How many unique customers does Rexon Metal have?
#   -- Requirements:
#   -- Must use: SELECT, count()
# SELECT  count(distinct(customer_id))
# FROM  customer
# ;
# 
# 
# # ---- tweak-data --------------------------------------------------------------
# 
# 
# # ---- table-1 -----------------------------------------------------------------
# 
