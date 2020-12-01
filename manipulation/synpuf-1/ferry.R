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
requireNamespace("dplyr"                      )
requireNamespace("checkmate"                  )
requireNamespace("testit"                     )
requireNamespace("config"                     )
requireNamespace("OuhscMunge"                 )  # remotes::install_github("OuhscBbmc/OuhscMunge")

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.
# config      <- config::get()
dsn             <- "omop_synpuf"
path_db_1       <- "data-public/exercises/synpuf-1.sqlite3"
path_sql_1      <- "manipulation/synpuf-1/subset.sql"

# ---- load-data ---------------------------------------------------------------

ds <- OuhscMunge::execute_sql_file(path_sql_1, dsn, execute = F)

checkmate::assert_data_frame(ds, min.rows = 10)
rm(path_sql_1)

# ---- tweak-data --------------------------------------------------------------


# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)
checkmate::assert_integer(  ds$person_id , any.missing=F , lower=1, upper=999                           , unique=T)
checkmate::assert_date(     ds$dob       , any.missing=F , lower=as.Date("1919-01-01"), upper=as.Date("1977-01-01"))
checkmate::assert_character(ds$gender    , any.missing=F , pattern="^.{4,50}$"                                    )
checkmate::assert_character(ds$race      , any.missing=T , pattern="^.{4,50}$"                                    )
checkmate::assert_character(ds$ethnicity , any.missing=F , pattern="^.{4,50}$"                                    )

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds_county_month), collapse=",\n"))
#   cat(paste0("    ", colnames(ds_county), collapse=",\n"))

ds_slim <- ds


# ---- save-to-db --------------------------------------------------------------
# If there's *NO* PHI, a local database like SQLite fits a nice niche if
#   * the data is relational and
#   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)

sql_create <- c(
  "
    DROP TABLE IF EXISTS patient;
  ",
  "
    CREATE TABLE `patient` (
      person_id   integer       primary key,
      dob         date          not null,
      gender      varchar(50)       null,
      race        varchar(50)       null,
      ethnicity   varchar(50)       null
    );
  "
)
# Remove old DB
if( file.exists(path_db_1) ) file.remove(path_db_1)

# Open connection
cnn <- DBI::dbConnect(drv=RSQLite::SQLite(), dbname=path_db_1)
# result <- DBI::dbSendQuery(cnn, "PRAGMA foreign_keys=ON;") #This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
# DBI::dbClearResult(result)
DBI::dbListTables(cnn)

# Create tables
sql_create %>%
  purrr::walk(~DBI::dbExecute(cnn, .))
DBI::dbListTables(cnn)

# Write to database
# DBI::dbWriteTable(cnn, name='patient',              value=ds,        append=TRUE, row.names=FALSE)
ds %>%
  dplyr::mutate(
    dob                 = strftime(dob, "%Y-%m-%d"),
  ) %>%
  DBI::dbWriteTable(value=., conn=cnn, name='patient', append=TRUE, row.names=FALSE)

# Close connection
DBI::dbDisconnect(cnn)

