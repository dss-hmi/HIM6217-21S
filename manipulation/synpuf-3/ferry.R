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
path_db_1             <- "data-public/exercises/synpuf/synpuf_3.sqlite3"
# path_db_1             <- "data-public/exercises/synpuf/synpuf_3_small.sqlite3"
path_sql_pt           <- "manipulation/synpuf-3/pt.sql"
path_sql_dx           <- "manipulation/synpuf-3/dx.sql"
path_sql_vt           <- "manipulation/synpuf-3/visit.sql"
path_sql_cs           <- "manipulation/synpuf-3/cs.sql" # care site

# ---- local-functions ---------------------------------------------------------
get_a_sample <- function(
  d,
  varname            # unique of these
  ,sample_size
  ,show_all = FALSE
){
  # d <- ds_pt
  # varname = "person_id"
  # varname = "offense_arrest_cd"
  sample_pool <- d %>% 
    dplyr::distinct_(.dots = varname) %>% 
    na.omit() %>% 
    as.list() %>% unlist() %>% as.vector() 
  if(show_all){ sample_size = length(sample_pool)}
  selected_sample <- sample_pool %>% sample(size = sample_size, replace = FALSE)
  
  return(selected_sample)
}  
# How to use
# ds %>% get_a_sample("person_id",  5)
# ds %>% get_a_sample("offense_arrest_cd",  5, show_all = T) 
# set.seed(42)
# target_sample <- ds %>% 
#   dplyr::filter(n_offenses > 1L) %>% 
#   get_a_sample("person_id", 500)
# ---- load-data ---------------------------------------------------------------
# See detailed instruction for creating a local DSN:
# https://github.com/OuhscBbmc/BbmcResources/blob/master/instructions/odbc-dsn.md
ds_pt <- OuhscMunge::execute_sql_file(path_sql_pt, dsn, execute = F)
ds_dx <- OuhscMunge::execute_sql_file(path_sql_dx, dsn, execute = F)
ds_vt <- OuhscMunge::execute_sql_file(path_sql_vt, dsn, execute = F)
ds_cs <- OuhscMunge::execute_sql_file(path_sql_cs, dsn, execute = F)

checkmate::assert_data_frame(ds_pt, min.rows = 10)
checkmate::assert_data_frame(ds_dx, min.rows = 10)
checkmate::assert_data_frame(ds_vt, min.rows = 10)
checkmate::assert_data_frame(ds_cs, min.rows = 10)
rm(path_sql_pt, path_sql_dx, path_sql_vt, path_sql_cs)


ds_pt %>% glimpse()
ds_dx %>% glimpse()
ds_vt %>% glimpse()
ds_cs %>% glimpse()


us_pop <- read.csv("https://raw.githubusercontent.com/CivilServiceUSA/us-states/master/data/states.csv") %>% as_tibble()
ds_pop <- us_pop %>% 
  select(state, code, population) %>% 
  mutate(
    prop_pop  = population/sum(population)
  )
ds_pop %>% glimpse()

# ---- tweak-data --------------------------------------------------------------
set.seed(TeachingDemos::char2seed(x = "homework56", set = TRUE))

sample_size <- 100
sample_1 <- ds_pt %>% get_a_sample("person_id",sample_size)
sample_1 # has both dx and visit

sample_size <- 20
sample_2 <- ds_pt %>% filter(!person_id %in% sample_1) %>% get_a_sample("person_id",sample_size)
sample_2 # has dx, but not visits

# 
sample_size <- 10
sample_3 <- ds_pt %>% filter(!person_id %in% c(sample_1, sample_2)) %>% get_a_sample("person_id",sample_size)
sample_3 # has visits, but not dx

set.seed(TeachingDemos::char2seed(x = "synpuf-2-4", set = TRUE))
sample_size <- 5
sample_4 <- ds_pt %>% filter(!person_id %in% c(sample_1, sample_2, sample_3)) %>% get_a_sample("person_id",sample_size)
sample_4 # has neither dx nor visit


ds_pt <- 
  ds_pt %>% 
  tibble::as_tibble() %>%
  dplyr::mutate(
    dob                 = strftime(dob, "%Y-%m-%d"), # Convert to string for SQLite
  )%>% 
  # dplyr::filter(person_id %in% c(sample_1, sample_2, sample_3, sample_4))# length(c(sample_1,sample_2, sample_3, sample_4))
  dplyr::filter(person_id %in% c(sample_1))# length(c(sample_1,sample_2, sample_3, sample_4))
ds_pt %>% summarize(n_patient = n_distinct(person_id))

ds_dx <- 
  ds_dx %>% 
  tibble::as_tibble() %>%
  dplyr::mutate(
    dx_date             = strftime(dx_date, "%Y-%m-%d"), # Convert to string for SQLite
    icd9_description    = OuhscMunge::deterge_to_ascii(icd9_description)
  )%>% 
  # dplyr::filter(person_id %in% c(sample_1, sample_2 )) # length(c(sample_1,sample_2))
  dplyr::filter(person_id %in% c(sample_1)) # length(c(sample_1,sample_2))
ds_dx %>% summarize(n_patient = n_distinct(person_id))

ds_vt <- 
  ds_vt %>% 
  tibble::as_tibble() %>%
  dplyr::mutate(
    visit_date          = strftime(visit_date, "%Y-%m-%d"), # Convert to string for SQLite
    # pt_visit_index      = 
  )%>% 
  # dplyr::filter(person_id %in% c(sample_1, sample_3 )) # length(c(sample_1,sample_3))
  dplyr::filter(person_id %in% c(sample_1 )) # length(c(sample_1,sample_3))
ds_vt %>% summarize(n_patient = n_distinct(person_id))



# define the universe for the MOS names
v_name <- babynames::babynames %>% distinct(name) %>% pull(name)
v_adjective  <- c("Memorial", "Regional","Veteran", "Medical", "Baptist", "Methodist", "Rehabilitation","Health","Community")
v_noun <- c( "Institute", "Center", "Hospital", "Clinic", "Complex" )

get_mos_name <- function(i_seed){
  set.seed(i_seed)
  i_name <- sample(v_name,1)
  i_adjective <- sample(v_adjective,1)
  i_noun <- sample(v_noun, 1)
  mos_name <- paste(i_name,i_adjective, i_noun,sep = " ")
  return(mos_name)
}
get_mos_name(1)
get_mos_name(2)
get_mos_name(3)

get_state_name <- function(i_seed){
  set.seed(i_seed)
  sample(ds_pop$state,size=1,prob=ds_pop$prop_pop)
}

ds_cs <- 
  ds_cs %>% 
  # slice(1:10) %>%
  tibble::as_tibble() %>%
  group_by(care_site_id) %>% 
  mutate(
    care_site_name = get_mos_name(i_seed = care_site_id)
    ,state = get_state_name(i_seed = care_site_id)
    ,bed_count = (rchisq(dplyr::n(), df = 4) * 30) %>% round(0)
    ,prob = runif(1) # to assist in randomazing In/Out patient place of service
    ,place_of_service = case_when( 
      # .15 because that's an approximate ration of In/Out when remove Office
      ((place_of_service == "Office") &  (prob >.15)) ~ "Outpatient Hospital",
      ((place_of_service == "Office") & (prob <=.15)) ~ "Inpatient Hospital",
      TRUE ~ place_of_service
    )
    ,bed_count = ifelse(place_of_service=="Inpatient Hospital",0, bed_count)
  ) %>% 
  select(-prob)

# inspecting
ds_cs %>% group_by(place_of_service) %>% summarize(n = n())
# the number of hospitals should be proportionate to population
ds_cs %>% group_by(state) %>% summarize(n_distinct(care_site_id)) 
ds_cs %>% TabularManifest::histogram_continuous("bed_count")

# keep only the care sites mentioned in the visit table
ds_cs <- ds_cs %>% 
  filter(care_site_id %in% unique(ds_vt$care_site_id))

# ---- simulate-obs ------------------------------------------------------------
ds_obs_wide <- 
  ds_pt %>% 
  dplyr::select(person_id) %>% 
  dplyr::mutate(
    height_cm_1   = rnorm(dplyr::n(), mean = 150, sd = 30),
    weight_kg_1   = rchisq(dplyr::n(), df = 4) * 15,
    
    height_cm_2   = height_cm_1 + rnorm(dplyr::n(), 0, .1),
    weight_kg_2   = weight_kg_1 + rnorm(dplyr::n(), 0,  2),
    
    height_cm_3   = height_cm_1 + rnorm(dplyr::n(), 0, .1),
    weight_kg_3   = weight_kg_1 + rnorm(dplyr::n(), 0,  2),
    
    bmi_1         = weight_kg_1 / (.01 * height_cm_1) ^2,
    bmi_2         = weight_kg_2 / (.01 * height_cm_2) ^2,
    bmi_3         = weight_kg_3 / (.01 * height_cm_3) ^2,
  ) %>% 
  dplyr::mutate(
    # TODO: add missingness
  )

ds_obs <-
  ds_obs_wide %>% 
  tidyr::pivot_longer(
    cols          = -person_id,
    names_to      = c("measure", "visit_within_pt_index"),
    names_pattern = "(.*)_(.*)"
  ) %>% 
  dplyr::mutate(
    visit_within_pt_index   = as.integer(visit_within_pt_index),
  ) %>% 
  dplyr::inner_join(
    ds_vt %>% 
      dplyr::select(visit_id, person_id, visit_within_pt_index),
    by = c("person_id", "visit_within_pt_index")
  ) %>% 
  dplyr::select(-visit_within_pt_index) %>% 
  dplyr::arrange(person_id, measure, visit_id, value) %>% 
  tibble::rowid_to_column("observation_id") %>% 
  select(observation_id, person_id, visit_id, everything())

ds_obs %>% summarize(person_count = n_distinct(person_id))

ds_vt <- ds_vt %>% select(-visit_within_pt_index)
# ---- verify-values -----------------------------------------------------------
# OuhscMunge::verify_value_headstart(ds_pt)
checkmate::assert_integer(  ds_pt$person_id , any.missing=F , lower=1, upper=9999 , unique=T)
checkmate::assert_character(ds_pt$dob       , any.missing=F , pattern="^.{10,10}$"  )
checkmate::assert_character(ds_pt$gender    , any.missing=F , pattern="^.{4,10}$"    )
checkmate::assert_character(ds_pt$race      , any.missing=T , pattern="^.{5,25}$"   )
checkmate::assert_character(ds_pt$ethnicity , any.missing=F , pattern="^.{1,25}$"  )

# OuhscMunge::verify_value_headstart(ds_dx)
checkmate::assert_integer(  ds_dx$dx_id            , any.missing=F , lower=1, upper=999999 , unique=T)
checkmate::assert_integer(  ds_dx$person_id        , any.missing=F , lower=1, upper=9999     )
checkmate::assert_character(ds_dx$dx_date          , any.missing=F , pattern="^.{10,10}$"      )
checkmate::assert_character(ds_dx$icd9_code        , any.missing=F , pattern="^.{1,8}$"        )
checkmate::assert_character(ds_dx$icd9_description , any.missing=F , pattern="^.{1,255}$"      )
checkmate::assert_integer(  ds_dx$visit_id         , any.missing=F , lower=1, upper=99999  )

# OuhscMunge::verify_value_headstart(ds_vt)
checkmate::assert_integer(  ds_vt$visit_id              , any.missing=F , lower=1, upper=99999 , unique=T)
checkmate::assert_integer(  ds_vt$person_id             , any.missing=F , lower=1, upper=9999    )
checkmate::assert_character(ds_vt$visit_date            , any.missing=F , pattern="^.{10,10}$"     )
checkmate::assert_integer(  ds_vt$provider_id           , any.missing=T , lower=1, upper=99999    )
checkmate::assert_integer(  ds_vt$care_site_id          , any.missing=T , lower=1, upper=99999    )

# OuhscMunge::verify_value_headstart(ds_cs)
checkmate::assert_integer(  ds_cs$care_site_id     , any.missing=F , lower=1, upper=99999 , unique=T)
checkmate::assert_character(ds_cs$place_of_service , any.missing=F , pattern="^.{1,50}$"  )
checkmate::assert_character(ds_cs$care_site_name   , any.missing=F , pattern="^.{1,50}$"  , unique=F)
checkmate::assert_character(ds_cs$state            , any.missing=F , pattern="^.{1,25}$"   )
checkmate::assert_numeric(  ds_cs$bed_count        , any.missing=F , lower=1, upper=999    )

# OuhscMunge::verify_value_headstart(ds_obs)
checkmate::assert_integer(  ds_obs$observation_id , any.missing=F , lower=1, upper=999        , unique=T)
checkmate::assert_integer(  ds_obs$person_id      , any.missing=F , lower=1, upper=9999    )
checkmate::assert_character(ds_obs$key            , any.missing=F , pattern="^.{1,15}$"       )
checkmate::assert_numeric(  ds_obs$value          , any.missing=F , lower=1, upper=999       , unique=F)
checkmate::assert_integer(  ds_obs$visit_id       , any.missing=F , lower=1, upper=99999 )

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
      gender      varchar(10)   not null,
      race        varchar(25)       null,
      ethnicity   varchar(25)   not null
    );
  ",
  "
    DROP TABLE IF EXISTS dx;
  ",
  "
    CREATE TABLE `dx` (
      dx_id            integer       primary key,
      person_id        integer       not null,
      visit_id         integer       not null,
      dx_date          date          not null,
      icd9_code        varchar(8)    not null,
      icd9_description varchar(255)  not null
    );
  ",
  "
    DROP TABLE IF EXISTS visit;
  ",
  "
    CREATE TABLE `visit` (
      visit_id            integer       primary key,
      person_id           integer       not null,
      visit_date          date          not null,
      provider_id         integer           null,
      care_site_id        integer           null
    );
  ",
  "
    DROP TABLE IF EXISTS care_site;
  ",
  "
    CREATE TABLE `care_site` (
      care_site_id       integer            primary key,
      care_site_name     varchar(50)        not null,
      place_of_service   varchar(50)        not null,
      state              varchar(25)        not null,
      bed_count          integer            not null
    );
  ",
  "
    DROP TABLE IF EXISTS observation;
  ",
  "
    CREATE TABLE `observation` (
      observation_id     integer        primary key,
      person_id          integer        not null,
      visit_id           integer        not null,
      measure                varchar(15)    not null,
      value              double         not null
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
sql_create[1:length(sql_create)] %>%
  purrr::walk(~DBI::dbExecute(cnn, .))

DBI::dbListTables(cnn)

# Write to database
# DBI::dbWriteTable(cnn, name='patient',              value=ds,        append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_pt, conn=cnn, name='patient', append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_dx, conn=cnn, name='dx', append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_vt, conn=cnn, name='visit', append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_cs, conn=cnn, name='care_site', append=TRUE, row.names=FALSE)
DBI::dbWriteTable(value=ds_obs, conn=cnn, name='observation', append=TRUE, row.names=FALSE)

# Close connection
DBI::dbDisconnect(cnn) 

# Save for exploration in R
path_rds_1 <- stringr::str_replace(path_db_1, ".sqlite3$", ".rds")
dto <- list(
  "ds_pt" = ds_pt # patient
  ,"ds_dx" = ds_dx # diagnosis
  ,"ds_vt" = ds_vt # visit
  ,"ds_cs" = ds_cs # care site
  ,"ds_obs" = ds_obs # observation
)

# ---- save-to-sqlserver-db -------------
# make sure all options from  (below) are enabled
# https://ouhscbbmc.github.io/data-science-practices-1/workstation.html#workstation-ssms
# If a database already exists, this single function uploads to a SQL Server database.
OuhscMunge::upload_sqls_odbc(
  d             = ds_pt,
  schema_name   = "dbo",         # Or config$schema_name,
  table_name    = "patient",
  dsn_name      = "omop_synpuf_3", # Or config$dsn_qqqqq,
  # timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
  clear_table   = T,
  create_table  = T # after initial T and tweaking columns properties in SQLServer, keep it as F, because it will overwrite
) # 0.012 minutes
OuhscMunge::upload_sqls_odbc(
  d             = ds_dx,
  schema_name   = "dbo",         # Or config$schema_name,
  table_name    = "dx",
  dsn_name      = "omop_synpuf_3", # Or config$dsn_qqqqq,
  # timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
  clear_table   = T,
  create_table  = T # after initial T and tweaking columns properties in SQLServer, keep it as F, because it will overwrite
) # 0.012 minutes
OuhscMunge::upload_sqls_odbc(
  d             = ds_vt,
  schema_name   = "dbo",         # Or config$schema_name,
  table_name    = "visit",
  dsn_name      = "omop_synpuf_3", # Or config$dsn_qqqqq,
  # timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
  clear_table   = T,
  create_table  = T # after initial T and tweaking columns properties in SQLServer, keep it as F, because it will overwrite
) # 0.012 minutes
OuhscMunge::upload_sqls_odbc(
  d             = ds_cs,
  schema_name   = "dbo",         # Or config$schema_name,
  table_name    = "care_site",
  dsn_name      = "omop_synpuf_3", # Or config$dsn_qqqqq,
  # timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
  clear_table   = T,
  create_table  = T # after initial T and tweaking columns properties in SQLServer, keep it as F, because it will overwrite
) # 0.012 minutes
OuhscMunge::upload_sqls_odbc(
  d             = ds_obs,
  schema_name   = "dbo",         # Or config$schema_name,
  table_name    = "observation",
  dsn_name      = "omop_synpuf_3", # Or config$dsn_qqqqq,
  # timezone      = config$time_zone_local, # Uncomment if uploading non-UTC datetimes
  clear_table   = T,
  create_table  = T # after initial T and tweaking columns properties in SQLServer, keep it as F, because it will overwrite
) # 0.012 minutes

