#getting average life expectancy &  average gdp{ercap per continent & year
get_sum_table <- function(data){
  #getting average life expectancy &  average gdp{ercap per continent & year
  sum.df <- data[,.(avg_lifeExp = mean(lifeExp),
                    avg_gdpPercap = mean(gdpPercap)),
                 by = .(continent, year)]
  return(sum.df)
}
