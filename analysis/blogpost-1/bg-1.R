# knitr::stitch_rmd(script="manipulation/mlm-scribe.R", output="stitched-output/manipulation/mlm-scribe.md")
rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

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
requireNamespace("babynames"                  )
requireNamespace("TeachingDemos"              )
requireNamespace("OuhscMunge"                 )  # remotes::install_github("OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
# config      <- config::get()
dsn                   <- "omop_synpuf"
path_db             <- "data-public/exercises/synpuf/synpuf_3.sqlite3"


# ---- local-functions ---------------------------------------------------------

# ---- load-data ---------------------------------------------------------------
# See detailed instruction for creating a local DSN:
# https://github.com/OuhscBbmc/BbmcResources/blob/master/instructions/odbc-dsn.md
# dst <- OuhscMunge::execute_sql_file(path_sql_pt, dsn, execute = F)

# ---- tweak-data --------------------------------------------------------------
# Create tables
sql_create[1:length(sql_create)] %>%
  purrr::walk(~DBI::dbExecute(cnn, .))
DBI::dbListTables(cnn)
# Close connection
DBI::dbDisconnect(cnn) 


# ----- c1 ---------------

sql_solution <- "
SELECT *
FROM patient
LIMIT 5
;
"
cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
ds_solution <- DBI::dbGetQuery(cnn, sql_solution)
DBI::dbDisconnect(cnn); rm(cnn, sql_solution)

cat(sql_solution)
cat("\n")
print(ds_solution)

# ----- c2 ----------------

