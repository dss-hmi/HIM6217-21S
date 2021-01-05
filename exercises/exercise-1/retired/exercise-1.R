#' ---
#' title: Exercise 1
#' author: Andriy Koval
#' date: Spring 2021
#' output:
#'   html_document:
#'   keep_md: yes
#' toc: yes
#' toc_float: yes
#' code_folding: show
#' theme: simplex
#' highlight: tango
#' ---

# rmarkdown::render('exercises/exercise-1/exercise-1.R')
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- knitr-opts --------------------------------------------------------------
#+ include = FALSE
knitr::opts_chunk$set(warning = FALSE, message = FALSE)
knitr::opts_knit$set(root.dir = "../../")

#' # Environment
# ---- load-sources ------------------------------------------------------------
# source("manipulation/osdh/ellis/common-ellis.R")
# base::source(file="dal/osdh/arch/benchmark-client-program-arch.R") #Load retrieve_benchmark_client_program

# ---- load-packages -----------------------------------------------------------
import::from("magrittr", "%>%")
requireNamespace("DBI")
requireNamespace("odbc")
requireNamespace("tibble")
requireNamespace("readr"                      )  # remotes::install_github("tidyverse/readr")
library("dplyr"                      )
requireNamespace("checkmate"                  )
requireNamespace("testit"                     )
requireNamespace("config"                     )
requireNamespace("OuhscMunge"                 )  # remotes::install_github("OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
# config      <- config::get()
# path_db       <- "../../data-public/exercises/synpuf-1.sqlite3"
path_db       <- "data-public/exercises/synpuf-1.sqlite3"
sql_patient   <- "SELECT * FROM patient"
sql_diagnosis <- "SELECT * FROM dx"

# ---- load-data ---------------------------------------------------------------
cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
ds_pt <- DBI::dbGetQuery(cnn, sql_patient)
ds_dx <- DBI::dbGetQuery(cnn, sql_diagnosis)
DBI::dbDisconnect(cnn); rm(cnn, sql_patient, sql_diagnosis)

#' # Data 

# ---- tweak-data --------------------------------------------------------------
ds_pt <- ds_pt %>% 
  mutate_at("dob", as.Date) %>% 
  mutate_at(c("gender","race","ethnicity"), factor) %>% 
  tibble::as_tibble()

ds_dx <- ds_dx %>% 
  mutate_at("dx_date", as.Date) %>% 
  mutate_at("inpatient_visit", as.logical) %>% 
  tibble::as_tibble()

# ---- inspect-data --------------------------------------------------------------
ds_pt %>% glimpse(70)
ds_dx %>% glimpse(70)

# ----- questions ----------------
#' # Questions 


#' ## Q1 - Sex ratio
# ----- q1 ---------------
#+ warning = FALSE, message = FALSE

#' What is the percent of men and women?
d <- ds_pt %>% 
  group_by(gender) %>% 
  summarize(
    n_patients = n_distinct(person_id)
    ,.groups = "drop"
  ) %>% 
  ungroup() %>%
  mutate(
    pct_patients = scales::percent(n_patients/sum(n_patients))
  ) %>% 
  print()

#' What is the ratio of men to women?  
(d %>% filter(gender=="male") %>% pull(n_patients))/
(d %>% filter(gender=="female") %>% pull(n_patients))
  

#' ## Q2 - Most prevalent DX
# ----- q2 ---------------
#+ warning = FALSE, message = FALSE
#' What is the second most prevalent diagnosis? (occurs in most people?)
d <- ds_dx %>% 
  group_by(icd9_description, icd9_code) %>% 
  summarize(
    n_patients_diagnosed = n_distinct(person_id)
  ) %>% 
  ungroup() %>% 
  arrange(desc(n_patients_diagnosed)) %>% 
  print()
d %>% slice(2) %>% pull(icd9_description)


#' ## Q3 - Days between Dx
# ----- q3 ---------------
#+ warning = FALSE, message = FALSE
#' What is the average number of days between patient's first and the last diagnosis? 
d <- ds_dx %>% 
  group_by(person_id) %>% 
  summarize(
    dx_first = min(dx_date, na.rm =T)
    ,dx_last  = max(dx_date, na.rm =T)
    ,dx_span = dx_last - dx_first
  ) %>% 
  ungroup() %>% 
  print()

d %>% 
  summarize(
    mean_days_btw_first_and_last_dx = mean(dx_span)
    ,median_days_btw_first_and_last_dx = median(dx_span)
  )  

#' ## Q4 - Most diagnosed group
# ----- q4 ---------------
#+ warning = FALSE, message = FALSE
#' What demographic group (gender +race) has the highest number of unique diagnoses?
d <- ds_dx %>% 
  group_by(person_id) %>% 
  summarize(
    n_dx = n_distinct(dx_id)
  ) %>% 
  arrange(desc(n_dx)) %>% 
  ungroup() %>% 
  print()

d <- d %>% 
  right_join(ds_pt, by = "person_id") %>% 
  print()

d <- d %>% 
  group_by(gender, race) %>% 
  summarize(
    median_n_dx = median(n_dx, na.rm = TRUE)
    ,mean_n_dx = mean(n_dx, na.rm = TRUE)
  ) %>% 
  ungroup() %>% 
  arrange(desc(median_n_dx))
d %>% slice(1) %>% select(gender,race)


# ---- verify-values -----------------------------------------------------------
# rmarkdown::render('exercises/exercise-1/exercise-1.R')
