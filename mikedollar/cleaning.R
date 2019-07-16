orders <- read.csv('../data/orders.csv', stringsAsFactors = F)
returns <- read.csv('../data/returns.csv')

# clean columns 13 - 18

sapply(orders, sd)[is.na(sapply(orders,sd))] # just Postal.Code shows for NA ater sd

str(orders)

# get a slice, call it slice_mike. include Row.ID, and columns 13 to 18.
slice_mike = orders[c(1,13:18)]

View(slice_mike)

str(slice_mike)

# look at number of unique entries in each column..
unique_items = as.data.frame(sapply(slice_mike, unique))

# rename columns with underscores instead of dots and change to lowercase
colnames(slice_mike) = tolower(colnames(slice_mike))
colnames(slice_mike) = gsub('\\.', '_', colnames(slice_mike))

# write csv..

write.csv(slice_mike, '../data/slice_mikeD.csv', row.names = FALSE)

