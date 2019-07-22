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

# this is how much is lost each year due to returns:
View(df_ret %>% 
  filter(., returned == 'Yes', profit < 0 ) %>% 
  group_by(., year = year(order_date)) %>% 
  summarise(., sum(profit)))

#how many customers returned more than 1 and 5 times?
# 1061 returned items at least once
# 80 returned items at least 5 times
df_ret %>% 
  filter(.,returned == 'Yes') %>% 
  group_by(., customer_id) %>% 
  summarise(., total_returns = n()) %>% 
  count(total_returns >= 5)


# which regions are more likely to return orders?

df_ret %>%
  filter(., returned == 'Yes') %>%
  group_by(., region.1) %>%
  summarise(., total_returns = n())

returns_yes = df_ret %>%
  filter(., returned == 'Yes')

ggplot(df_ret %>% filter(., returned == 'Yes'), aes(x=region.1))+
  geom_histogram(stat='count')

# looks like Central America and western europe

# which categories of products are more likely to be returned?

ggplot(df_ret %>% filter(., returned == 'Yes'), aes(x=category))+
  geom_histogram(stat='count')

# office supplies

# create new independent variable process_time_days
df_ret = df_ret %>% 
  mutate(., process_time_days = (ship_date - order_date)/(24*3600))

# create new independent variable for frequency of item returned
df_ret %>% 
  mutate(., times_returned = )
# start by creating table grouped by product_id and summing occurences when returned == Yes

product_return_frequency = df_ret %>% 
  filter(., returned == 'Yes') %>% 
  group_by(., product_id) %>% 
  summarise(., times_returned = n())

# merge on product_id
df_ret = merge(df_ret, product_return_frequency, by='product_id', all = TRUE)
# make NAs 0
df_ret$times_returned[is.na(df_ret$times_returned)] = 0

write.csv(df_ret, 'lab2.csv', row.names = FALSE)
