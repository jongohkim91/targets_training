"============================================================================="
#creating plotting graphs
gen_graph <- function(data){
  #extracting the continent
  continent <- unique(data$continent)
  
  #plotting the graph(dot*line)
  plot <- ggplot()+
    geom_point(data = data, aes(x = year, y = lifeExp, color = country)) + 
    geom_line(data = data, aes(x = year, y = lifeExp, color = country))
  
  #creating a separate dataframe for text
  text.df <- data[order(country, year, lifeExp)]
  best <- text.df[year==2007][order(-lifeExp), country[1]]
  worst <- text.df[year==2007][order(-lifeExp), country[.N]]
  text.df <- data[country %in% c(best, worst)]
  
  #adding the text labels to the graph(country, life expectancy)
  final_plot <- plot +
    geom_text(data = text.df, aes(x=year, y = lifeExp, color = country, label = lifeExp), vjust=-0.1, show.legend = F) + 
    geom_text(data = text.df[year==1952 | year==2007], aes(x=year, y = lifeExp, color = country, label = country), vjust=1, show.legend = F)
  final_plot
  
  ggsave(filename = paste0("figures/", continent, "_lifeExp_graph.jpg"),
         plot = final_plot,
         width = 40,
         height = 30, 
         units = "cm")
  return(final_plot)
}
