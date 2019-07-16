import numpy as np
import pandas as pd
import csv

###

test_data = pd.read_csv('./data/Orders.csv')

test_subset = test_data.iloc[:,0:7]

### rename with undescores for python compatibility

subset_colnames = ['row_id','order_id','order_date',
                    'ship_date','ship_mode','customer_id','customer_name']

test_subset.columns = subset_colnames

test_subset['order_date'] = pd.to_datetime(test_subset['order_date'])
test_subset['ship_date'] = pd.to_datetime(test_subset['ship_date'])

### change and add dummy names to column name list

dummy_names = pd.get_dummies(test_subset[['ship_mode']]).drop('ship_mode_Standard Class',axis =1).columns.tolist()
dummy_names = ['_'.join(dummy_names[name].lower().split()) for name in range(len(dummy_names))]
subset_colnames.extend(dummy_names)

### deleted dummy column ship_mode_standard_class == base case

test_subset = pd.concat([test_subset,pd.get_dummies(test_subset[['ship_mode']]).drop('ship_mode_Standard Class',
                                                axis=1)],axis=1)

### rename columns with dummies and drop original ship mode columns

test_subset.columns = subset_colnames
test_subset = test_subset.drop('ship_mode',axis=1)

### write cleaned data to csv

with open('mikejr_clean.csv',mode='w') as file:
    data_writer = csv.writer(file,delimiter=',')

    for row in range(len(test_subset)):
        data_writer.writerow(test_subset.iloc[row].tolist())
