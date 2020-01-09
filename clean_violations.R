clean_violations <- function(rest) {
  violation_map <- read_csv("edav_final/violation_mapping.csv") %>%
    mutate(VIOLATION_TYPE = as.factor(VIOLATION_TYPE))
  
  rest %>% left_join((violation_map %>% select(`VIOLATION CODE`, VIOLATION_TYPE)))
}