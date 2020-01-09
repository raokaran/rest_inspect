# reduce to quality rating by generic key
reduce_rating <- function(rest, key) {
  rest %>% 
    select(!! enquo(key), rating) %>% 
    drop_na() %>% 
    group_by(!! enquo(key)) %>% 
    summarize(mean_score = mean(rating), num=n()) %>%
    mutate(num=(sum(num) / num) ^ 0.5) %>% #used to be 2.
    (function (xx) {
      sum(xx$mean_score * xx$num)
    })
}


quality_metric <- function(rest){
  rest %>%
  group_by(ZIPCODE) %>% 
  group_modify(
    ~ tibble(score=reduce_rating(.x, `CUISINE DESCRIPTION`)
    )
  )
}