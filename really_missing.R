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

extracat::visna(final, sort="r")

# We can visualize patterns of missing data using extracat; this is essential for our dataset
# as so much of the data is categorical.  The most common pattern that we see is for no missing data,
# which comprises just about half of the data; a further quarter of the data is missing all yelp data.
# Furthermore, there doesn't appear to be significant correlation between missing yelp data and missing
# DOH data; this highlights that it is probably more meaningful to split our merged dataset back into its
# individual components for this analysis.

final[match(colnames(doh), colnames(final))] %>% extracat::visna(sort="b")

# Looking at Department of Health Data, we see that the source is mostly complete, with what looks like >95%
# of rows having all data.  Identifying information (restaurant name and address) is fully complete, and the most
# commonly missing data is auxilliary location data, like zipcode and census tract.  The only  other data which
# shows missing data -- and this is very infrequently -- is grade data.  This is reasonable as some restaurants
# will be "ungraded" if they are given a chance a clean up their act, and others still will show no violation.

raw_ylp_cols <- c("price","rating","review_count","longitude","latitude","opens","closes")

final[match(raw_ylp_cols, colnames(final))] %>% extracat::visna(sort="b")

# For the yelp dataset, we restrict down to non-derived columns.  The most common patterns are no missing data
# and all missing data -- the latter being an instance where we were unable to recover a matching yelp restaurant
# for the DOH's inspection, and which therefore doesn't constitute a "true" pattern of missing data in some sense.
# Therefore, almost all the true missing data comes in three patterns: no price information, no hours of 
# operations data, and neither price nor hours of operations data.  Perhaps not suprisingly, yelp is very good
# at knowing longitude and latitute, presumably for showing users nearby, highly rated restaurants.  Since the DOH
# was (infrequently) missing auxilliary information, it would be interesting to know if we could recover
# things like zipcode from the yelp dataset.  Although we don't do this given how small the probability of missing
# zipcode data is, we can quickly verify that in fact no rows in the dataset have both missing latitude and zipcode,
# so better location data is in fact possible with some minor work.

final[c("ZIPCODE", "Census Tract","Latitude")] %>% extracat::visna(sort="b")
