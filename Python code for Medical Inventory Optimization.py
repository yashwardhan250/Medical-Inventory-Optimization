import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import seaborn as sns

import scipy.stats as stats
import pylab
data  = pd.read_csv("C:\Data Science\SAMPLEMIODATA.csv")


data.dtypes
data['BillDate'] = pd.to_datetime(data['BillDate'], errors= 'coerce')
data.dtypes
numerical_columns = ['TQty', 'UCPwithoutGST', 'PurGSTPer', 'MRP', 'TotalCost', 'TotalDiscount', 'NetSales', 'ReturnMRP']
mean = data[numerical_columns].mean()
print(mean)
mode = data[numerical_columns].mode()
print(mode)
median = data[numerical_columns].median()
print(median)
stddev = data[numerical_columns].std()
print(stddev)
range_nc = data[numerical_columns].max() - data[numerical_columns].min()
print(range_nc)
variance = data[numerical_columns].var()
print(variance)
skewness = data[numerical_columns].skew()
print(skewness)
kurtosis = data[numerical_columns].kurtosis()
print(kurtosis)
#Boxplot
for column in numerical_columns:
    plt.figure(figsize=(8,6))
    plt.boxplot(data[column])
    plt.title(f'Boxplot of {column}')
    plt.show
    
#Histogram
for column in numerical_columns:
    plt.figure(figsize=(8,6))
    plt.hist(data[column],color='green', edgecolor='black')
    plt.title(f'Boxplot of {column}')
    plt.show()    
    
#Scatter Plot
sns.pairplot(data[numerical_columns])
plt.show()
# Scatter plot of Quantity vs NetSales
plt.scatter(x=data['TQty'], y=data['NetSales'],color="green")
plt.title("Quantity vs NetSales")
plt.xlabel("Quantity")
plt.ylabel("NetSales")

# Scatter plot of Quantity vs TotalCost
plt.scatter(x=data['TQty'], y=data['TotalCost'],color="red")
plt.title("Quantity vs TotalCost")
plt.xlabel("Quantity")
plt.ylabel("TotalCost")

# Scatter plot of TotalCost vs NetSales
plt.scatter(x=data['TotalCost'], y=data['NetSales'],color="blue")
plt.title("TotalCost vs NetSales ")
plt.xlabel("TotalCost")
plt.ylabel("NetSales")
plt.show()

IQR1 = data[numerical_columns].quantile(0.75) - data[numerical_columns].quantile(0.25)
IQR1
lower_limit = data[numerical_columns].quantile(0.25) - (IQR1 * 1.5)
print('lower_limit:',lower_limit)
upper_limit = data[numerical_columns].quantile(0.75) + (IQR1 * 1.5)
print('upper_limit:',upper_limit)

# Replace the outliers by the maximum and minimum limit
data1 = pd.DataFrame(np.where(data[numerical_columns] > upper_limit, upper_limit, np.where(data[numerical_columns]< lower_limit,lower_limit, data[numerical_columns])))
data1.columns = numerical_columns
data1.head
mean = data1[numerical_columns].mean()
print(mean)
mode = data1[numerical_columns].mode()
print(mode)
median = data1[numerical_columns].median()
print(median)
stddev = data1[numerical_columns].std()
print(stddev)
range_nc = data1[numerical_columns].max() - data[numerical_columns].min()
print(range_nc)
variance = data1[numerical_columns].var()
print(variance)
skewness = data1[numerical_columns].skew()
print(skewness)
kurtosis = data1[numerical_columns].kurtosis()
print(kurtosis)
#plotting after removing outliers
#pairplot
sns.pairplot(data1)
#boxplot
for column in data1:
    plt.figure(figsize=(8, 6))
    plt.boxplot(data1[column])
    plt.title(f'Boxplot of {column}')
    plt.show()
#histogram
for column in data1:
    plt.figure(figsize=(8, 6))
    plt.hist(data1[column], color='green', edgecolor='black')
    plt.title(f'Boxplot of {column}')
    plt.show()


# Extracting only the date part from the 'BillDate' column
date = data['BillDate'].dt.date
print(date)

# Extracting month from the 'BillDate' column
data['month'] = pd.to_datetime(data['BillDate'], format='%d/%m/%Y').dt.strftime('%b')
data

month1 = data['BillDate'].dt.month
print(month1)
# quantities sold per month:
quantity_sold_per_month=data.groupby('month')['TQty'].sum()
quantity_sold_per_month=quantity_sold_per_month.sort_values(ascending=False)
print(quantity_sold_per_month)

# chart for month and sales
sns.lineplot(x='month', y='NetSales', data=data, ci=None)
plt.title('Chart for Month and Sales')
plt.xlabel('Month')
plt.ylabel('Total Sales')
plt.show()
#we had more sales in the month of july


# Time Series Plot for NetSales

data_time_series = data.set_index('BillDate')
data_time_series['NetSales'].resample('M').sum().plot()
plt.title('Time Series Plot of NetSales')
plt.xlabel('Date')
plt.ylabel('NetSales')
plt.show()

# Differences in NetSales and different Subcategories

sns.barplot(x='SubCategory', y='NetSales', data=data)
plt.title('Differences in NetSales and different Subcategories')

plt.show()
# Differences in Return MRp and different Subcategories

sns.barplot(x='SubCategory', y='ReturnMRP', data= data,  ci = None)
plt.title('Differences in Return MRp and different Subcategories')

plt.show()


#total sales by drugname

total_sales = data.groupby('GenericName')['NetSales'].sum().reset_index().nlargest(10,'NetSales')
total_sales1 = data.groupby('GenericName')['NetSales'].sum().reset_index().nsmallest(10,'NetSales')
print(total_sales)
print(total_sales1)
# Plot distribution of top 10 sales by DrugName
data.groupby('GenericName')['NetSales'].sum().sort_values(ascending=False).head(10).plot(kind='bar')

plt.title('Top 10 Drugs by Sales')
plt.xlabel('GenericName')
plt.ylabel('NetSales')
plt.xticks(rotation=45, fontsize=8)  
plt.show()

#total cost by drugname

total_cost = data.groupby('GenericName')['TotalCost'].sum().reset_index().nlargest(10,'TotalCost')
total_cost1 = data.groupby('GenericName')['TotalCost'].sum().reset_index().nsmallest(10,'TotalCost')
print(total_cost)
print(total_cost1)
# Plot distribution of top 10 totalcost by DrugName
data.groupby('GenericName')['TotalCost'].sum().sort_values(ascending=False).head(10).plot(kind='bar')
plt.title('Top 10 Drugs by Total Cost')
plt.xlabel('GenericName')
plt.ylabel('NetSales')
plt.show()

pip install sweetviz
import sweetviz as sz
report = sz.analyze(data)
report.show_html('sweetviz_report.html')
