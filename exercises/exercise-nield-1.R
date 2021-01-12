rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.
cat("\014") # Clear the console

# verify root location
cat("Working directory: ", getwd()) # Must be set to Project Directory
# if the line above DOES NOT generates the project root, re-map by selecting 
# Session --> Set Working Directory --> To Project Directory location
# Project Directory should be the root by default unless overwritten

# ---- load-packages -----------------------------------------------------------
import::from("magrittr", "%>%")
# library(magrittr)  # pipes
# library(dplyr)     # data wrangling
# library(ggplot2)   # graphs
library(janitor)   # tidy data
library(tidyr)     # data wrangling
# library(forcats)   # factors
# library(stringr)   # strings
# library(lubridate) # dates

# ---- load-sources ------------------------------------------------------------

# ---- declare-globals ---------------------------------------------------------
# Note: when printing to Word or PDF use `neat(output_format =  "pandoc")`
# path_db <- "./data-public/textbook/oreilly_getting_started_with_sql/rexon_metals.db" # Now pulled from the exercise-specific yaml file

# ---- load-data ---------------------------------------------------------------
# ds_quiz_template <- readr::read_csv("./quizzes/respondus-csv-column-names.csv")

input   <- yaml::read_yaml("data-public/exercises/exercise-1-input.yml")
output  <- input # Start with the same input, and augment it will the answers.
 

# ---- tweak-data --------------------------------------------------------------

# input[[1]]$requirements %>% 
#   paste0(., collapse = "\n- ") %>% 
#   paste0(input[[1]]$prompt, "\nRequirements:\n- ", .) %>% 
#   cat()

# ---- discover-answers --------------------------------------------------------
# This kinda breaks the convention.  It usually goes in teh `load-data` chunk.

for (i in seq_along(input$items)) {
  y <- input$items[[i]]
  sql_solution <- y$code
  
  cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = input$path_db)
  ds_solution <- DBI::dbGetQuery(cnn, sql_solution)
  DBI::dbDisconnect(cnn); rm(cnn, sql_solution)
  
  output$items[[i]]$answer <- ds_solution[[y$pull_column]][y$pull_row]
}

# input %>% 
#   purrr::map_df(tibble::as_tibble)



# ---- convert-lists-to-rectangle ----------------------------------------------
ds_output <-
  output$items %>% 
  purrr::map_dfr(
    .f = magrittr::extract,
    c(
      "prompt",
      "code",
      "answer"
    )
  ) %>% 
  dplyr::mutate(
    prompt  = gsub("\\n", "\\\\n", prompt), # So the line breaks within the sql are smushed to one line in the csv
    code    = gsub("\\n", "\\\\n", code  ), # So the line breaks within the sql are smushed to one line in the csv
  ) %>% 
  dplyr::rename(
    `Question Wording`  = prompt,
    `Choice 1`          = answer,
    `General Comment`   = code
  ) 

# ---- save-to-disk ------------------------------------------------------------
readr::write_csv(ds_output, "data-public/exercises/exercise-1-output.csv")

# yaml::write_yaml(output, "data-public/exercises/exercise-1-output.yml")
