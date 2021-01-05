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
dsn                   <- "omop_synpuf"
path_db_1             <- "data-public/exercises/synpuf-1.sqlite3"
path_sql_pt           <- "manipulation/synpuf-1/pt.sql"
path_sql_dx           <- "manipulation/synpuf-1/dx.sql"

# ---- load-data ---------------------------------------------------------------
ds_pt <- OuhscMunge::execute_sql_file(path_sql_pt, dsn, execute = F)
ds_dx <- OuhscMunge::execute_sql_file(path_sql_dx, dsn, execute = F)

checkmate::assert_data_frame(ds_pt, min.rows = 10)
checkmate::assert_data_frame(ds_dx, min.rows = 10)
rm(path_sql_pt, path_sql_dx)

# ---- tweak-data --------------------------------------------------------------
ds_pt <- 
  ds_pt %>% 
  tibble::as_tibble() %>%
  dplyr::mutate(
    dob                 = strftime(dob, "%Y-%m-%d"),
  ) #%>% 
  # dplyr::filter(person_id %in% 1:36)

ds_dx <- 
  ds_dx %>% 
  tibble::as_tibble() %>%
  dplyr::mutate(
    dx_date             = strftime(dx_date, "%Y-%m-%d"),
    icd9_description    = OuhscMunge::deterge_to_ascii(icd9_description)
  )

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds_dx)
checkmate::assert_integer(  ds_pt$person_id , any.missing=F , lower=1, upper=999                           , unique=T)
checkmate::assert_character(ds_pt$dob       , any.missing=F , pattern = "^\\d{4}-\\d{2}-\\d{2}$")
checkmate::assert_character(ds_pt$gender    , any.missing=F , pattern="^.{4,50}$"                                    )
checkmate::assert_character(ds_pt$race      , any.missing=T , pattern="^.{4,50}$"                                    )
checkmate::assert_character(ds_pt$ethnicity , any.missing=F , pattern="^.{4,50}$"                                    )

checkmate::assert_integer(  ds_dx$dx_id            , any.missing=F , lower=1, upper=6342  , unique=T)
checkmate::assert_integer(  ds_dx$person_id        , any.missing=F , lower=1, upper=48    )
checkmate::assert_character(ds_dx$dx_date          , any.missing=F , pattern = "^\\d{4}-\\d{2}-\\d{2}$")
checkmate::assert_character(ds_dx$icd9_code        , any.missing=F , pattern="^.{5,6}$"   )
checkmate::assert_character(ds_dx$icd9_description , any.missing=F , pattern="^.{2,255}$" )
checkmate::assert_logical(  ds_dx$inpatient_visit  , any.missing=F                        )

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
  ",
  "
    DROP TABLE IF EXISTS dx;
  ",
  "
    CREATE TABLE `dx` (
      dx_id            integer       primary key,
      person_id        integer       not null,
      dx_date          date          not null,
      icd9_code        varchar(10)   not null,
      icd9_description varchar(10)   not null,
      inpatient_visit  varchar(255)  not null
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
sql_create[1:4] %>%
  purrr::walk(~DBI::dbExecute(cnn, .))

DBI::dbListTables(cnn)

# Write to database
# DBI::dbWriteTable(cnn, name='patient',              value=ds,        append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_pt, conn=cnn, name='patient', append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_dx, conn=cnn, name='dx', append=TRUE, row.names=FALSE)

# Close connection
DBI::dbDisconnect(cnn)

