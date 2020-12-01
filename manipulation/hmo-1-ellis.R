rm(list = ls(all.names = TRUE)) # Clear the memory of variables from previous run. This is not called by knitr, because it's above the first chunk.

# ---- load-sources ------------------------------------------------------------
# Call `base::source()` on any repo file that defines functions needed below. 
# ---- load-packages -----------------------------------------------------------
# Import only certain functions of a package into the search path.
import::from("magrittr", "%>%")

requireNamespace("readr"        )
requireNamespace("tidyr"        )
requireNamespace("dplyr"        ) 
requireNamespace("rlang"        ) # Language constructs, like quosures
requireNamespace("checkmate"    ) # For asserting conditions meet expected patterns
requireNamespace("DBI"          ) # Database-agnostic interface
requireNamespace("RSQLite"      ) # Lightweight database for non-PHI data.
requireNamespace("OuhscMunge"   ) # remotes::install_github(repo="OuhscBbmc/OuhscMunge")
library(dplyr)

# ---- declare-globals ---------------------------------------------------------
# Constant values that won't change.

path_source_xlsx <- "data-public/raw/hmo-1/hmo-1.xlsx"
path_db  <- "data-public/derived/hmo-1-db.sqlite3"

path_patients <- "./data-public/raw/hmo-1/hmo-1-patients.csv"
path_visits <- "./data-public/raw/hmo-1/hmo-1-visits.csv"
# Execute to specify the column types.  
col_types_patients <- 
  readr::cols_only(
    `patient_id` = readr::col_integer(),
    `name_first` = readr::col_character(),
    `name_last`  = readr::col_character(),
    `sex`        = readr::col_character(),
    `dob`        = readr::col_date()
)
col_types_visits <- 
  readr::cols_only(
    `visit_id`     = readr::col_integer(),
    `patient_id`   = readr::col_integer(),
    `visit_date`   = readr::col_date()
)

# ---- load-data ---------------------------------------------------------------
# Read the CSVs
ds_patients <- readr::read_csv(path_patients , col_types=col_types_patients)
ds_visits   <- readr::read_csv(path_visits , col_types=col_types_visits)


rm(col_types_patients,col_types_visits)

# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.
ds <-
  ds %>%
  dplyr::select(    # `dplyr::select()` drops columns not included.
    county_id,
    county_name,
    category,
    time_zone         = `timezone`,
    desired,
  ) %>%
  dplyr::filter(desired) %>%
  dplyr::mutate(

  ) # %>%
  # dplyr::arrange(subject_id) # %>%
  # tibble::rowid_to_column("subject_id") # Add a unique index if necessary

# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds)
checkmate::assert_integer(  ds$county_id   , any.missing=F , lower=51, upper=72 , unique=T)
checkmate::assert_character(ds$county_name , any.missing=F , pattern="^.{5,25}$", unique=T)
checkmate::assert_character(ds$category    , any.missing=F , pattern="^.{5,10}$" )
checkmate::assert_character(ds$time_zone   , any.missing=F , pattern="^.{5,25}$" )
checkmate::assert_logical(  ds$desired     , any.missing=F                       )

# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
#   cat(paste0("    ", colnames(ds), collapse=",\n"))

# Define the subset of columns that will be needed in the analyses.
#   The fewer columns that are exported, the fewer things that can break downstream.

ds_slim <-
  ds %>%
  # dplyr::slice(1:100) %>%
  dplyr::select(
    county_id,
    county_name,
    category,
    time_zone,
    # desired
  )


# ---- save-to-db --------------------------------------------------------------
# If a database already exists, this single function uploads to a SQL Server database.
# OuhscMunge::upload_sqls_odbc(
#   d             = ds_slim,
#   schema_name   = "skeleton",         # Or config$schema_name,
#   table_name    = "dim_county",
#   dsn_name      = "skeleton-example", # Or config$dsn_qqqqq,
#   timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
#   clear_table   = T,
#   create_table  = F
# ) # 0.012 minutes


# If there's no PHI, a local database like SQLite fits a nice niche if
#   * the data is relational and
#   * later, only portions need to be queried/retrieved at a time (b/c everything won't need to be loaded into R's memory)
# cat(dput(colnames(ds)), sep = "\n")
sql_create <- c(
  "
    DROP TABLE IF EXISTS dim_county;
  ",
  "
    CREATE TABLE `dim_county` (
      county_id               int         not null primary key,
      county_name             varchar(25) not null,
      category                varchar(10) not null,
      time_zone               varchar(25) not null
    );
  "
)

# Remove old DB
# if( file.exists(path_db) ) file.remove(path_db)

# Open connection
cnn <- DBI::dbConnect(drv=RSQLite::SQLite(), dbname=path_db)
result <- DBI::dbSendQuery(cnn, "PRAGMA foreign_keys=ON;") #This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
DBI::dbClearResult(result)
DBI::dbListTables(cnn)

# Create tables
sql_create %>%
  purrr::walk(~DBI::dbExecute(cnn, .))
DBI::dbListTables(cnn)

# Write to database
DBI::dbWriteTable(cnn, name='dim_county',            value=ds_slim,        append=TRUE, row.names=FALSE)

# Close connection
DBI::dbDisconnect(cnn)
