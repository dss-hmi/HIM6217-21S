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
# Notes: verify lack of ties
# ---- declare-globals ---------------------------------------------------------
# Note: when printing to Word or PDF use `neat(output_format =  "pandoc")`
path_db <- "./data-public/textbook/oreilly_getting_started_with_sql/rexon_metals.db"

# ---- load-data ---------------------------------------------------------------
ds_quiz_template <- readr::read_csv("./quizzes/respondus-csv-column-names.csv")
ds_quiz_template %>% glimpse()
ds_quiz <- ds_quiz_template


# ---- create-function -------------




sql_question <- c(
  "
  -- 1. How many unique customers does Rexon Metal have?\n
  ---- Requirements:\n
  ---- Must use: SELECT, count()\n
  "
)

sql_solution <- c(
  "
  SELECT  count(distinct(customer_id))\n
  FROM  customer\n
  ;
  "
)
cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
ds_solution <- DBI::dbGetQuery(cnn, sql_solution)
# DBI::dbDisconnect(cnn); rm(cnn, sql_solution)
DBI::dbDisconnect(cnn); rm(cnn )

solution_value <- ds_solution[1,1] %>% as.character()


# ---- test-function -----
question_answer <- function(question, solution, path = path_db){
  cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
  ds_solution <- DBI::dbGetQuery(cnn, s)
  DBI::dbDisconnect(cnn); rm(cnn )

  ls_solution <- list(
    "item_text" = list(
      "Question Wording"= question
      ,"General Feedback" = solution
    ),
    "item_data" = ds_solution 
  )
  return(ls_solution)
}

q <- c(
  "
  -- 1. How many unique customers does Rexon Metal have?\n
  ---- Requirements:\n
  ---- Must use: SELECT, count()\n
  "
)
s <- c(
  "
  SELECT  count(distinct(customer_id))\n
  FROM  customer\n
  ;
  "
)
ls_solution <- question_answer(question = q, solution = s)
ls_solution[["item_text"]][["Choice 1"]] <- ls_solution$item_data[1,1] %>% as.character()
ds_quiz <- ds_quiz %>% 
  bind_rows(ls_solution$item_text)

# ---- q01 -------------------------------------
ls_item <- list(
  "Question Wording"= sql_question
  ,"General Feedback" = sql_solution
  ,"Choice 1" = solution_value
)

ds_quiz <- ds_quiz_template

ds_quiz <- ds_quiz %>% 
  bind_rows(ls_item)


# ----- q02 ------------


# ---- tweak-data --------------------------------------------------------------


# ---- table-1 -----------------------------------------------------------------

