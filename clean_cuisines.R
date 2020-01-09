clean_cuisines <- function(rest) {
  #clean cuisines
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Cajun"] <- "Cajun/Creole"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Creole"] <- "Cajun/Creole"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Creole/Cajun"] <- "Cajun/Creole"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Not Listed/Not Applicable"] <- "Other"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Bottled beverages, including water, sodas, juices, etc."] <- "Bottled beverages"
  
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Iranian"] <- "Middle Eastern"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Egyptian"] <- "Middle Eastern"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Californian"] <- "American"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Armenian"] <- "Eastern European"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Czech"] <- "Eastern European"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Polish"] <- "Eastern European"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Moroccan"] <- "African"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Ethiopian"] <- "African"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Soups"] <- "Sandwiches/Salads/Soups/Juice"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Soups & Sandwiches"] <- "Sandwiches/Salads/Soups/Juice"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Sandwiches/Salads/Mixed Buffet" ] <- "Sandwiches/Salads/Soups/Juice"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Sandwiches"] <- "Sandwiches/Salads/Soups/Juice"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Salads"] <- "Sandwiches/Salads/Soups/Juice"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Juice, Smoothies, Fruit Salads"] <- "Sandwiches/Salads/Soups/Juice"
  
  #levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Sandwiches/Salads/Soups/Juice"] <- "Sandwiches etc"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Turkish"] <- "Mediterranean"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Portuguese"] <- "Mediterranean"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Greek"] <- "Mediterranean"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Chinese/Japanese"] <- "Asian"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Indonesian"] <- "Asian"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Afghan"] <- "Asian"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Filipino"] <- "Asian"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Basque"] <- "Spanish"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Latin (Cuban, Dominican, Puerto Rican, South & Central American)"] <- "Latin"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Chilean"] <- "Latin"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Peruvian"] <- "Latin"
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Brazilian"] <- "Latin"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Bagels/Pretzels"] <- "Bakery"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Pizza/Italian"] <- "Pizza"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Chinese/Cuban"] <- "Chinese"
  
  levels(rest$`CUISINE DESCRIPTION`)[levels(rest$`CUISINE DESCRIPTION`)=="Hotdogs/Pretzels"] <- "Hotdogs"
  
  rest
}