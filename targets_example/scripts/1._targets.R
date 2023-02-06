library(targets)
source("scripts/functions/functions.R")
#source("R/different_code.R")

# # configuring the script it should run(run it one time and it will create an targets.yaml file in the project folder)
# tar_config_set(script = "scripts/1._targets.R")

# Set packages.
tar_option_set(packages = c("dplyr", "stringr", "stringi", "ggplot2", "data.table", "gapminder"))

# End this file with a list of target objects.
list(
  #reading in the gapminder data
  tar_target(data, 
             as.data.table(gapminder::gapminder)),
  #getting average life expectancy &  average gdp{ercap per continent & year
  tar_target(sum_stat,
             get_sum_table(data))
)

