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
library(dplyr)     # data wrangling
# library(ggplot2)   # graphs
library(janitor)   # tidy data
library(tidyr)     # data wrangling
library(forcats)   # factors
library(stringr)   # strings
library(lubridate) # dates

# ---- load-sources ------------------------------------------------------------

# ---- declare-globals ---------------------------------------------------------
# Note: when printing to Word or PDF use `neat(output_format =  "pandoc")`
# path_db <- "./data-public/textbook/oreilly_getting_started_with_sql/rexon_metals.db" # Now pulled from the exercise-specific yaml file

# ---- load-data ---------------------------------------------------------------
config <- config::get()
ds_quiz_template <- readr::read_csv(config$path_quiz_template)

input   <- yaml::read_yaml("data-public/exercises/homework/homework-3-input.yml")
output  <- input # Start with the same input, and augment it will the answers.
 

# ---- tweak-data --------------------------------------------------------------
quiz_value_total<- 60 
quiz_source <- "synpuf"
quiz_type   <- "homework"
quiz_number <- "03"
item_title_stem <- paste0(quiz_source,"-", quiz_type,"-", quiz_number)

path_stem <-  "data-public/exercises/"
# path_raw <-  "data-public/exercises/nield/nield-exercise-2-output-raw.csv"
path_output_raw <-  paste0(path_stem,quiz_type,"/",quiz_type,"-",quiz_number,"-output-raw.csv")
path_output     <-  paste0(path_stem,quiz_type,"/",quiz_type,"-",quiz_number,"-output.csv")
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
  
  output$items[[i]]$answer <- ds_solution[[y$pull_column]][y$pull_row] %>% as.character()
}

# input %>% 
#   purrr::map_df(tibble::as_tibble)

# for debugging :
# i <- 5
# y <- input$items[[i]]
# sql_solution <- y$code
# cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = input$path_db)
# ds_solution <- DBI::dbGetQuery(cnn, sql_solution)
# DBI::dbDisconnect(cnn); rm(cnn, sql_solution)
# 
# output$items[[i]]$answer <- ds_solution[[y$pull_column]][y$pull_row] %>% as.character()
# 

# ---- convert-lists-to-rectangle ----------------------------------------------
ds_output_raw <-
  output$items %>% 
  purrr::map_dfr(
    .f = magrittr::extract,
    c(
      "prompt",
      "code",
      "answer"
    )
  ) %>% 
  mutate(
    qn = row_number()
    ,qn = dplyr::case_when( (qn <10) ~ paste0("00",qn),
                           (qn >=10 & qn <100) ~ paste0("0",qn))
    ,item_title = paste0(item_title_stem,"-",qn)
  ) %>% 
  dplyr::rename(
    `Question Wording`  = prompt,
    `Choice 1`          = answer,
    `Title/ID`          = item_title
  )%>% 
  select(-code, -qn) # for now, correct code will not be provided


quiz_value_item <- (quiz_value_total/nrow(ds_output_raw)) %>% as.character()
ds_output <- 
  bind_rows(
    ds_quiz_template,
    ds_output_raw %>% 
      mutate(
        Type = "FB"
        ,Points = quiz_value_item
        
      )
  ) %>% 

  mutate_all(replace_na,"")



# ---- save-to-disk ------------------------------------------------------------
ds_output_raw %>% readr::write_csv( path_output_raw)
ds_output %>% readr::write_csv( path_output)
 
# yaml::write_yaml(output, "data-public/exercises/exercise-1-output.yml")
