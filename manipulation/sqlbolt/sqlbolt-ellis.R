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

path_db_movies     <- "data-public/derived/sqlbolt-movies-db.sqlite3"
path_db_buildings  <- "data-public/derived/sqlbolt-buildings-db.sqlite3"

path_movies    <- "./data-public/raw/sqlbolt/movies.csv"
path_boxoffice <- "./data-public/raw/sqlbolt/boxoffice.csv"
path_buildings <- "./data-public/raw/sqlbolt/buildings.csv"
path_employees <- "./data-public/raw/sqlbolt/employees.csv"



# Execute to specify the column types.  
col_types_movies <- 
  readr::cols_only(
    `Id`             = readr::col_integer(),
    `Title`          = readr::col_character(),
    `Director`       = readr::col_character(),
    `Year`           = readr::col_integer(),
    `Length_minutes` = readr::col_integer()

)
col_types_boxoffice <- 
  readr::cols_only(
    `Movie_id`             = readr::col_integer(),
    `Rating`               = readr::col_double(),
    `Domestic_sales`       = readr::col_integer(),
    `International_sales`  = readr::col_integer()
)

col_types_buildings <- 
  readr::cols_only(
    `Building_name` = readr::col_character(),
    `Capacity`      = readr::col_integer()
  )

col_types_employees <- 
  readr::cols_only(
    `Role`             = readr::col_character(),
    `Name`             = readr::col_character(),
    `Building`         = readr::col_character(),
    `Years_employed`   = readr::col_integer()
  )




# ---- load-data ---------------------------------------------------------------
# Read the CSVs
ds_movies <- readr::read_csv(path_movies , col_types=col_types_movies)
ds_boxoffice  <- readr::read_csv(path_boxoffice , col_types=col_types_boxoffice)

ds_buildings <- readr::read_csv(path_buildings , col_types=col_types_buildings)
ds_employees <- readr::read_csv(path_employees , col_types=col_types_employees)


rm(col_types_movies,col_types_boxoffice,col_types_buildings,col_types_employees)

# ---- tweak-data --------------------------------------------------------------
# OuhscMunge::column_rename_headstart(ds) # Help write `dplyr::select()` call.
# OuhscMunge::column_rename_headstart(ds_movies) # Help write `dplyr::select()` call.
# OuhscMunge::column_rename_headstart(ds_boxoffice) # Help write `dplyr::select()` call.
# OuhscMunge::column_rename_headstart(ds_buildings) # Help write `dplyr::select()` call.
# OuhscMunge::column_rename_headstart(ds_employees) # Help write `dplyr::select()` call.
# ds_movies <-
#   ds_movies %>%
#   dplyr::select(    # `dplyr::select()` drops columns not included.
#     id                            = `Id`,
#     title                         = `Title`,
#     director                      = `Director`,
#     year                          = `Year`,
#     length_minutes                = `Length_minutes`,
#   )
# ds_boxoffice <-
#   ds_boxoffice %>%
#   dplyr::select(    # `dplyr::select()` drops columns not included.
#     movie_id                           = `Movie_id`,
#     rating                             = `Rating`,
#     domestic_sales                     = `Domestic_sales`,
#     international_sales                = `International_sales`,
#   )
# ds_buildings <-
#   ds_buildings %>%
#   dplyr::select(    # `dplyr::select()` drops columns not included.
#     building_name                = `Building_name`,
#     capacity                     = `Capacity`,
#   )
# ds_employees <-
#   ds_employees %>%
#   dplyr::select(    # `dplyr::select()` drops columns not included.
#     role                          = `Role`,
#     name                          = `Name`,
#     building                      = `Building`,
#     years_employed                = `Years_employed`,
#   )
# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds_movies)
# OuhscMunge::verify_value_headstart(ds_boxoffice)
# OuhscMunge::verify_value_headstart(ds_buildings)
# OuhscMunge::verify_value_headstart(ds_employees)

# checkmate::assert_integer(  ds_movies$id                 , any.missing=F , lower=1, upper=14      , unique=T)
# checkmate::assert_character(ds_movies$title              , any.missing=F , pattern="^.{2,19}$"    , unique=T)
# checkmate::assert_character(ds_movies$director           , any.missing=F , pattern="^.{9,14}$"    )
# checkmate::assert_integer(  ds_movies$year               , any.missing=F , lower=1995, upper=2013 , unique=T)
# checkmate::assert_integer(  ds_movies$length_minutes     , any.missing=F , lower=81, upper=120    , unique=T)
# 
# checkmate::assert_integer( ds_boxoffice$movie_id            , any.missing=F , lower=1, upper=14                , unique=T)
# checkmate::assert_numeric( ds_boxoffice$rating              , any.missing=F , lower=6, upper=9                 )
# checkmate::assert_integer( ds_boxoffice$domestic_sales      , any.missing=F , lower=162798565, upper=415004880 , unique=T)
# checkmate::assert_integer( ds_boxoffice$international_sales , any.missing=F , lower=170162503, upper=648167031 , unique=T)
# 
# checkmate::assert_character(ds_buildings$building_name      , any.missing=F , pattern="^.{2,2}$" , unique=T)
# checkmate::assert_integer(  ds_buildings$capacity           , any.missing=F , lower=16, upper=32 , unique=T)
# 
# checkmate::assert_character(ds_employees$role               , any.missing=F , pattern="^.{6,8}$"  )
# checkmate::assert_character(ds_employees$name               , any.missing=F , pattern="^.{6,10}$" , unique=T)
# checkmate::assert_character(ds_employees$building           , any.missing=T , pattern="^.{2,2}$"  )
# checkmate::assert_integer(  ds_employees$years_employed     , any.missing=F , lower=0, upper=9    )


# ---- specify-columns-to-upload -----------------------------------------------
# Print colnames that `dplyr::select()`  should contain below:
  # cat(paste0("    ", colnames(ds_movies), collapse=",\n"))
  # cat(paste0("    ", colnames(ds_boxoffice), collapse=",\n"))
  # cat(paste0("    ", colnames(ds_buildings), collapse=",\n"))
  # cat(paste0("    ", colnames(ds_employees), collapse=",\n"))

# Define the subset of columns that will be needed in the analyses.
#   The fewer columns that are exported, the fewer things that can break downstream.

ds_movies_slim    <- ds_movies
ds_boxoffice_slim <- ds_boxoffice
ds_buildings_slim <- ds_buildings
ds_employees_slim <- ds_employees


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
# cat(dput(colnames(ds_movies)), sep = "\n")
# cat(dput(colnames(ds_boxoffice)), sep = "\n")
# cat(dput(colnames(ds_buildings)), sep = "\n")
# cat(dput(colnames(ds_employees)), sep = "\n")
sql_create_movies <- c(
  "
    DROP TABLE IF EXISTS Movies;
  ",
  "
    CREATE TABLE `Movies` (
      Id               int           primary key  ,
      Title            varchar(64),
      Director         varchar(64),
      Year             int,
      Length_minutes   int                                 
    );
  "
  ,
  "
    DROP TABLE IF EXISTS Boxoffice;
  ",
  "
    CREATE TABLE `Boxoffice` (
      Movie_id              int       primary key,            
      Rating                int,          
      Domestic_sales        int,                  
      International_sales   int                                                   
    );
  "
)
sql_create_buildings <- c(  
  "
    DROP TABLE IF EXISTS Employees;
  ",
  "
    CREATE TABLE `Employees` (
      Role                  varchar(64),
      Name                  varchar(64)   primary key,
      Building              varchar(2),
      Years_employed        int
    );
  "
  ,"
    DROP TABLE IF EXISTS buildings;
  ",
  "
    CREATE TABLE `Buildings` (
      Building_name         varchar(2)  primary key,
      Capacity              int         not null
    );
  "

)

# Remove old DB
# if( file.exists(path_db) ) file.remove(path_db)

# Write movies
# Open connection
cnn <- DBI::dbConnect(drv=RSQLite::SQLite(), dbname=path_db_movies)
result <- DBI::dbSendQuery(cnn, "PRAGMA foreign_keys=ON;") #This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
DBI::dbClearResult(result)
DBI::dbListTables(cnn)

# Create tables
sql_create_movies %>%
  purrr::walk(~DBI::dbExecute(cnn, .))
DBI::dbListTables(cnn)

# Write to database
DBI::dbWriteTable(cnn, name='Movies',     value=ds_movies_slim,    append=TRUE, row.names=FALSE)
DBI::dbWriteTable(cnn, name='Boxoffice',  value=ds_boxoffice_slim, append=TRUE, row.names=FALSE)

# Close connection
DBI::dbDisconnect(cnn)

# Write buildings
# Open connection
cnn <- DBI::dbConnect(drv=RSQLite::SQLite(), dbname=path_db_buildings)
result <- DBI::dbSendQuery(cnn, "PRAGMA foreign_keys=ON;") #This needs to be activated each time a connection is made. #http://stackoverflow.com/questions/15301643/sqlite3-forgets-to-use-foreign-keys
DBI::dbClearResult(result)
DBI::dbListTables(cnn)

# Create tables
sql_create_buildings %>%
  purrr::walk(~DBI::dbExecute(cnn, .))
DBI::dbListTables(cnn)

# Write to database
DBI::dbWriteTable(cnn, name='Buildings',            value=ds_buildings_slim,        append=TRUE, row.names=FALSE)
DBI::dbWriteTable(cnn, name='Employees',            value=ds_employees_slim,        append=TRUE, row.names=FALSE)

# Close connection
DBI::dbDisconnect(cnn)
