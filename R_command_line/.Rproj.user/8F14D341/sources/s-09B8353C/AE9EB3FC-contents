library(RSQLite)
library(DBI)
library(dplyr)
library(tidyverse)


con <- dbConnect(RSQLite::SQLite(), "DB/tempDB.db")

dbListTables(con)

tbl(con, "irisPrediction") %>% collect() %>% tail(10) 





#DBI::dbWriteTable(con, "irisPrediction", testResult)



dbDisconnect(con)