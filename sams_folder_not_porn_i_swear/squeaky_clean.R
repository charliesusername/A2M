library(tidyverse)
library(dplyr)
library(ggrepel)
library(PASWR)
library(VIM)
library(stringr)


orders = read.csv("../data/Orders.csv")

#returns = read.csv("../data/Returns.csv")

orders$Profit = str_replace_all(as.character(orders$Profit), "[$, ]", "")


orders$Sales = str_replace_all(as.character(orders$Sales), "[$, ]", "")

orders$Sales = as.numeric(orders$Sales)

orders$Profit = as.numeric(orders$Profit)

colnames(orders) = str_replace_all(colnames(orders), "[.]", "_")

orders$Postal_Code[is.na(orders$Postal_Code)] = -1

write.csv(orders, "sam_clean.csv")
