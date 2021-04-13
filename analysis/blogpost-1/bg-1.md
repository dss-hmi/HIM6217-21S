---
title: "Post 1"
author: "First Last"  
output:
  html_document:
    keep_md: yes
    toc: yes
    toc_float: yes
    code_folding: show
    theme: simplex
    highlight: tango
editor_options: 
  chunk_output_type: console
---


<!--  Set the working directory to the repository's base directory; this assumes the report is nested inside of two directories.-->




# Environment
<!-- Load 'sourced' R files.  Suppress the output when loading packages. --> 

```r
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
```

<!-- Load the sources.  Suppress the output when loading sources. --> 

```r
# source("manipulation/osdh/ellis/common-ellis.R")
# base::source(file="dal/osdh/arch/benchmark-client-program-arch.R") #Load retrieve_benchmark_client_program
```

<!-- Load any Global functions and variables declared in the R file.  Suppress the output. --> 

```r
# Constant values that won't change.
# config      <- config::get()
dsn                   <- "omop_synpuf"
path_db             <- "data-public/exercises/synpuf/synpuf_3.sqlite3"
```


# Data


```r
# See detailed instruction for creating a local DSN:
# https://github.com/OuhscBbmc/BbmcResources/blob/master/instructions/odbc-dsn.md
# dst <- OuhscMunge::execute_sql_file(path_sql_pt, dsn, execute = F)
```




# Analysis 


```r
sql_solution <- "
  SELECT *
  FROM patient
  LIMIT 5;
"
cnn <- DBI::dbConnect(drv = RSQLite::SQLite(), dbname = path_db)
ds_solution <- DBI::dbGetQuery(cnn, sql_solution)
DBI::dbDisconnect(cnn); rm(cnn)

cat(sql_solution)
```

```

  SELECT *
  FROM patient
  LIMIT 5;
```

```r
cat("\n")
```

```r
print(ds_solution)
```

```
  person_id        dob gender  race              ethnicity
1        19 1942-07-01 female white not hispanic or latino
2        30 1959-11-01 female white not hispanic or latino
3        33 1942-06-01 female white not hispanic or latino
4        47 1922-07-01 female white not hispanic or latino
5        72 1933-04-01   male  <NA>     hispanic or latino
```






Session Information {#session-info}
===========================================================================

For the sake of documentation and reproducibility, the current report was rendered in the following environment.  Click the line below to expand.

<details>
  <summary>Environment <span class="glyphicon glyphicon-plus-sign"></span></summary>

```
- Session info -----------------------------------------------------------------------------------
 setting  value                                      
 version  R version 4.0.4 Patched (2021-02-17 r80031)
 os       Windows >= 8 x64                           
 system   x86_64, mingw32                            
 ui       RTerm                                      
 language (EN)                                       
 collate  English_United States.1252                 
 ctype    English_United States.1252                 
 tz       America/Chicago                            
 date     2021-04-13                                 

- Packages ---------------------------------------------------------------------------------------
 package     * version    date       lib source                               
 assertthat    0.2.1      2019-03-21 [1] CRAN (R 4.0.0)                       
 backports     1.2.1      2020-12-09 [1] CRAN (R 4.0.3)                       
 bit           4.0.4      2020-08-04 [1] CRAN (R 4.0.2)                       
 bit64         4.0.5      2020-08-30 [1] CRAN (R 4.0.2)                       
 blob          1.2.1      2020-01-20 [1] CRAN (R 4.0.0)                       
 bslib         0.2.4      2021-01-25 [1] CRAN (R 4.0.3)                       
 cachem        1.0.4      2021-02-13 [1] CRAN (R 4.0.4)                       
 callr         3.6.0      2021-03-28 [1] CRAN (R 4.0.4)                       
 checkmate     2.0.0      2020-02-06 [1] CRAN (R 4.0.0)                       
 cli           2.4.0      2021-04-05 [1] CRAN (R 4.0.4)                       
 colorspace    2.0-0      2020-11-11 [1] CRAN (R 4.0.2)                       
 config        0.3.1      2020-12-17 [1] CRAN (R 4.0.3)                       
 crayon        1.4.1      2021-02-08 [1] CRAN (R 4.0.3)                       
 DBI           1.1.1      2021-01-15 [1] CRAN (R 4.0.3)                       
 desc          1.3.0      2021-03-05 [1] CRAN (R 4.0.4)                       
 devtools      2.4.0      2021-04-07 [1] CRAN (R 4.0.4)                       
 digest        0.6.27     2020-10-24 [1] CRAN (R 4.0.3)                       
 dplyr       * 1.0.5      2021-03-05 [1] CRAN (R 4.0.4)                       
 ellipsis      0.3.1      2020-05-15 [1] CRAN (R 4.0.0)                       
 evaluate      0.14       2019-05-28 [1] CRAN (R 4.0.0)                       
 fansi         0.4.2      2021-01-15 [1] CRAN (R 4.0.3)                       
 fastmap       1.1.0      2021-01-25 [1] CRAN (R 4.0.3)                       
 fs            1.5.0      2020-07-31 [1] CRAN (R 4.0.2)                       
 generics      0.1.0      2020-10-31 [1] CRAN (R 4.0.2)                       
 ggplot2       3.3.3      2020-12-30 [1] CRAN (R 4.0.3)                       
 glue          1.4.2      2020-08-27 [1] CRAN (R 4.0.2)                       
 gtable        0.3.0      2019-03-25 [1] CRAN (R 4.0.0)                       
 hms           1.0.0      2021-01-13 [1] CRAN (R 4.0.3)                       
 htmltools     0.5.1.1    2021-01-22 [1] CRAN (R 4.0.3)                       
 import        1.2.0      2020-09-24 [1] CRAN (R 4.0.2)                       
 jquerylib     0.1.3      2020-12-17 [1] CRAN (R 4.0.3)                       
 jsonlite      1.7.2      2020-12-09 [1] CRAN (R 4.0.3)                       
 knitr       * 1.31       2021-01-27 [1] CRAN (R 4.0.3)                       
 lifecycle     1.0.0      2021-02-15 [1] CRAN (R 4.0.4)                       
 magrittr      2.0.1      2020-11-17 [1] CRAN (R 4.0.3)                       
 memoise       2.0.0      2021-01-26 [1] CRAN (R 4.0.3)                       
 munsell       0.5.0      2018-06-12 [1] CRAN (R 4.0.0)                       
 odbc          1.3.2      2021-04-03 [1] CRAN (R 4.0.5)                       
 OuhscMunge    0.1.9.9013 2020-08-25 [1] Github (OuhscBbmc/OuhscMunge@b8a3663)
 pillar        1.6.0      2021-04-13 [1] CRAN (R 4.0.4)                       
 pkgbuild      1.2.0      2020-12-15 [1] CRAN (R 4.0.3)                       
 pkgconfig     2.0.3      2019-09-22 [1] CRAN (R 4.0.0)                       
 pkgload       1.2.1      2021-04-06 [1] CRAN (R 4.0.4)                       
 prettyunits   1.1.1      2020-01-24 [1] CRAN (R 4.0.0)                       
 processx      3.5.1      2021-04-04 [1] CRAN (R 4.0.5)                       
 ps            1.6.0      2021-02-28 [1] CRAN (R 4.0.4)                       
 purrr         0.3.4      2020-04-17 [1] CRAN (R 4.0.0)                       
 R6            2.5.0      2020-10-28 [1] CRAN (R 4.0.2)                       
 Rcpp          1.0.6      2021-01-15 [1] CRAN (R 4.0.3)                       
 readr         1.4.0      2020-10-05 [1] CRAN (R 4.0.3)                       
 remotes       2.3.0      2021-04-01 [1] CRAN (R 4.0.5)                       
 rlang         0.4.10     2020-12-30 [1] CRAN (R 4.0.3)                       
 rmarkdown     2.7        2021-02-19 [1] CRAN (R 4.0.4)                       
 rprojroot     2.0.2      2020-11-15 [1] CRAN (R 4.0.2)                       
 RSQLite       2.2.6      2021-04-11 [1] CRAN (R 4.0.4)                       
 sass          0.3.1      2021-01-24 [1] CRAN (R 4.0.3)                       
 scales        1.1.1      2020-05-11 [1] CRAN (R 4.0.0)                       
 sessioninfo   1.1.1      2018-11-05 [1] CRAN (R 4.0.0)                       
 stringi       1.5.3      2020-09-09 [1] CRAN (R 4.0.2)                       
 stringr       1.4.0      2019-02-10 [1] CRAN (R 4.0.0)                       
 testit        0.12       2020-09-25 [1] CRAN (R 4.0.2)                       
 testthat      3.0.2      2021-02-14 [1] CRAN (R 4.0.4)                       
 tibble        3.1.0      2021-02-25 [1] CRAN (R 4.0.4)                       
 tidyselect    1.1.0      2020-05-11 [1] CRAN (R 4.0.0)                       
 usethis       2.0.1      2021-02-10 [1] CRAN (R 4.0.3)                       
 utf8          1.2.1      2021-03-12 [1] CRAN (R 4.0.4)                       
 vctrs         0.3.7      2021-03-29 [1] CRAN (R 4.0.4)                       
 withr         2.4.1      2021-01-26 [1] CRAN (R 4.0.3)                       
 xfun          0.22       2021-03-11 [1] CRAN (R 4.0.4)                       
 yaml          2.2.1      2020-02-01 [1] CRAN (R 4.0.0)                       

[1] D:/Projects/RLibraries
[2] D:/Users/Will/Documents/R/win-library/4.0
[3] C:/Program Files/R/R-4.0.4patched/library
```
</details>



Report rendered by Will at 2021-04-13, 10:09 -0500 in 3 seconds.
