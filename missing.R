library(extracat)
library(tidyverse)

source("clean_cuisines.R")
source("clean_violations.R")
source("extract_latest_inspection.R")
source("quality_score_by_zip.R")

doh <- readr::read_csv("./edav_final/data/DOHMH_New_York_City_Restaurant_Inspection_Results.csv")
ylp <- readr::read_csv("./edav_final/tbl_yelp.csv")

mrg <- dplyr::left_join(doh, ylp, by="CAMIS")

final <- extract_latest_inspection(mrg)

q <- quality_metric(final)
#View(q %>% arrange(desc(score)))
