library(targets)
source("scripts/functions/pattern_functions.R")
#source("R/different_code.R")

# # configuring the script it should run(run it one time and it will create an targets.yaml file in the project folder)
# tar_config_set(script = "scripts/2._targets_pattern.R")

# Set packages.
tar_option_set(packages = c("qs", "dplyr", "stringr", "stringi", "ggplot2", "data.table", "gapminder"),
               format = "qs")

# End this file with a list of target objects.
list(
  #reading in the gapminder data
  tar_target(data, 
             as.data.table(gapminder::gapminder)),
  
  #getting the continents in the gapminder data
  tar_target(continents, 
             sort(unique(data$continent))),
  
  #slicing the gapminder data by continents
  tar_target(continents_data, 
             data[continent %in% continents],
             pattern = map(continents)),
  
  #generating a graph of showing temporal changes of life expectancy of each country in each continent!
  tar_target(get_graph,
             gen_graph(continents_data),
             pattern = map(continents_data))
)

