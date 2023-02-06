"============================================================================="
#reading the news data
read_news <- function(){
  print("READING DATA!")
  #list of file it should read
  file_list <- paste0("data/", c("True.csv", "Fake.csv"))
  #reading the data
  data_list <- lapply(file_list, fread)
  #merging the data sets
  data <- rbindlist(data_list)
  return(data)
}
"============================================================================="
#cleaning the text!
clean_text <- function(data){
  #making into lower cases
  clean_text <- vapply(data$text, tolower, FUN.VALUE = "abc")
  
  #splitting each text into words
  clean_text <- lapply(clean_text, function(x){
    words <- str_split(x, "\\W+") %>% unlist()
    return(words)
  })
  
  #declaring stopwords
  stop_words <- stopwords::data_stopwords_nltk$en
  
  #remove stopwords
  clean_text <-lapply(clean_text, function(text){
    clean <- text[!(text %in% stop_words)]
    return(clean)
  })
  
  return(clean_text)
}
"============================================================================="
#getting the sentiment scores from a list of texts(each text is a vector of words!)
extract_sentiment <- function(data, clean_text_list){
  print("Number of Cores that could be used:")
  print(parallel::detectCores(logical = F))
  
  #declaring the number of cores
  num_cores <- floor(parallel::detectCores(logical = F)*0.66) #at least leave 33% of your cores to run your OS & other programs 
  #create the cluster
  cl <- makeCluster(num_cores)
  
  print("DON'T USE ALL YOUR CORES!")
  print(paste("Currently using", num_cores, "Cores!"))
  
  #creating the final table
  final.df <- data %>%
    select(-text)
  tryCatch(expr = {
    #getting the sentiment score
    final.df[,sentiment_score:=parSapply(cl = cl,
                                         X = clean_text_list,
                                         FUN = get_sentiment_score,
                                         USE.NAMES = F)]
  },
  finally = {
    #stop using the cluster IMPORTANT!
    stopCluster(cl)
  })
  return(final.df)
}
"============================================================================="
#getting the sentiment scores by each text
get_sentiment_score <- function(text){#text should be a vector of words!
  #calling the packages again because when you do parallization packages need to be recalled!
  packages <- c("qs", "dplyr", "stringr", "stringi", "data.table", "parallel", "tidytext", "stopwords")
  lapply(packages, require, character.only = TRUE)
  
  #setting the words related to sentiments
  sentiment_words <- get_sentiments("bing")
  
  #declaring the data frame with words from the text 
  sentiment.df <- data.table(word = text[text %in% sentiment_words$word])
  
  if(nrow(sentiment.df)>0){
    #counting the sentiment words in the text
    sentiment.df <- sentiment.df[,count:=.N, by=.(word)] %>% unique()
    
    #merging with the sentiments
    sentiment.df <- left_join(sentiment.df, sentiment_words,
                              by="word")
    #assigning scores
    sentiment.df[sentiment=="negative",
                 score:=-1]
    sentiment.df[sentiment=="positive",
                 score:=1]
    #getting the whole score
    final_score <- sentiment.df[,sum(count*score)]
    return(final_score)
  }else{
    return(0)
  }
}
"============================================================================="
#getting the sentiment scores from a list of texts(each text is a vector of words!)
extract_sentiment_simple <- function(data, clean_text_list){
  print("Doing simple lapply(for-loop)!")
  #creating the final table
  final.df <- data %>%
    select(-text)
  tryCatch(expr = {
    #getting the sentiment score
    final.df[,sentiment_score:=sapply(X = clean_text_list,
                                      FUN = get_sentiment_score,
                                      USE.NAMES = F)]
  })
  return(final.df)
}