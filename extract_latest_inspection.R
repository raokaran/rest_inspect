extract_latest_inspection <- function(rest) {
  inspections <- rest %>%
    filter((`INSPECTION TYPE` %in% 
              c('Cycle Inspection / Re-inspection'
                ,'Pre-permit (Operational) / Re-inspection')
            |(`INSPECTION TYPE` %in%
                c('Cycle Inspection / Initial Inspection'
                  ,'Pre-permit (Operational) / Initial Inspection')) 
            & SCORE <= 13)
           | (`INSPECTION TYPE` %in%  
                c('Pre-permit (Operational) / Reopening Inspection'
                  ,'Cycle Inspection / Reopening Inspection'))
           & GRADE %in% c('A', 'B', 'C', 'P', 'Z')) %>%
    select(CAMIS,`INSPECTION DATE`) %>%
    distinct()
  
  #Select most recent inspection date
  last_inspection <- inspections %>%
    group_by(CAMIS) %>%
    slice(which.max(as.Date(`INSPECTION DATE`,'%m/%d/%Y')))
  
  #Select restaurant inspection data based on most recent inspection date
  last_inspection <- rest %>% 
    inner_join(last_inspection, by = c("CAMIS", "INSPECTION DATE")) %>%
    clean_violations() %>%
    clean_cuisines() %>%
    filter((`INSPECTION TYPE` %in% 
              c('Cycle Inspection / Re-inspection'
                ,'Pre-permit (Operational) / Re-inspection'
                , 'Pre-permit (Operational) / Reopening Inspection' 
                ,'Cycle Inspection / Reopening Inspection')
            |(`INSPECTION TYPE` %in%
                c('Cycle Inspection / Initial Inspection'
                  ,'Pre-permit (Operational) / Initial Inspection')) 
            & SCORE <= 13))
  
  last_inspection
}
