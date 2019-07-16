# answer questions with this script

df <- read.csv('../data/ready_data2.csv', stringsAsFactors = F)




library(dplyr)
library(ggplot2)
library(lubridate)


# 1 ####
# seasonal trend in inventory?
# first, convert to date time
df$order_date = as_datetime(df$order_date)
df$ship_date = as_datetime(df$ship_date)
ggplot(df, aes(x=order_date, fill = category))+
  geom_histogram()
# this graph shows there is a seasonal trend.  There are
# more items from furniture than anything else, but the
# buying patterns are all around the same times.




# 2 ####
#How much profit did we lose due to returns each year?

# filter by negative profit and aggregate per year
 # merge returns

returns <- read.csv('../data/returns.csv', stringsAsFactors = F)

View(returns)  

colnames(returns) = tolower(colnames(returns))
colnames(returns) = gsub('\\.', '_', colnames(returns))


df_ret = merge(returns, df, by='order_id', all = TRUE)

df_ret$returned[is.na(df_ret$returned)] = 'No'

# first get the total profit 
loss = df_ret %>% 
  filter(., returned == 'yes') %>% 
  group_by(., year = year(order_date)) %>% 
  summarise(., sum(sales))