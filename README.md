# Online Retail Analyst Project

## Table of Contents
- [Project Overview](#project-overview)
- [Data Sources](#Data-Sources)
- [Tools](#Tools)
- [Data Preparation and Exploration](Data-Preparation-and-Exploration)
- [Data Cleaning and Data Analysis](Data-Cleaning-and-Data-Analysis)
- [Dashboard Report and Findings](#Dashboard-Report-and-Findings)
- [Limitations](#Limitations)
- [Reference](#Reference)

## Project Overview

This data analysis project aims to provide insights into the sales performance of an online retail over the year of 2010 and 2011. By analyzing various aspects of the data, 
we seek to identify trends, make data-driven reccomendations, and gain a deeper understanding of the retail performance.


## 📅 Data Sources
- Online Retail : The primary dataset used for this analysis is the Online Retail.csv from [Kaggle.com](https://www.kaggle.com/datasets/rupakroy/online-retail)
- The Online Retail contains transactional informations included with 8 columns showing the InvoiceNo, StockCode, Description, Quantity, UnitPrice, InvoiceDate, CustomerID, and Country. 

## 🔧 Tools
There are some tools are used for this analysis icluding :

- Microsoft Excel - Preparation, Data Exploration and Table Covertion.
- SQL Server - Data Cleaning and Data Analysis
- Power BI - Creating Reports

## Data Preparation and Exploration
In the initial data preparation, Microsoft Excel is used to perform following tasks:
- Convert data to table and use the filter features in order to view every unique value of the data.
- Explore data by observing the format, values, relationships, and data type for further analysis.

Original data consists of 541,910 rows of record. After going through each coloumn, below are the questions that are come into interested for this analysis :

1. What is the total quantity sold for each unique stock? Group them by StockCode and Description and order by the total amount.
2. Sort customers who have the highest amount spent from the retail. Sort it from highest to the lowest.
3. How many countries that operates this online retail?
4. How many product was sold in year 2010?
5. Which product have the highest price in the retail?
6. How much sales made from the first quarter of 2011?
7. Total sales made by United Kingdom.
8. Search stock with their StockCode end with an alphabet.
9. List out all stock with negative quantity.
10. Point out StockCode that are not related to item.

All the answer for the questions are extracted using SQL. the queries can be observe at the Data Analysis section below.


## Data Cleaning and Data Analysis

### Data Cleaning 
The data should be free from any missing values and all the values should be standardize to obtain accurate analysis. The objective here is to make analysis based on customer who already make transaction from the retail. Hence, records with no CutomerID is no longer valid in this situation. Data cleaning was executed by following SQL commands.

```sql
-- DATA CLEANING --

-- Remove Item with no CustomerID since we want to analyze sales only
select * from online_retail.dbo.[Online Retail] 
where CustomerID is null
-- Found 135,080 rows with no CustomerID

-- Delete Null CustomerID 
delete from online_retail.dbo.[Online Retail]
where CustomerID is Null;
-- 135,080 rows deleted
```
After importing the data into SQL Server, noticed that the UnitPrice was not uniformly displayed in the same decimal places. Hence, the data was set and round off to 2 decimal places.

```sql
-- Standardize UnitPrice round to 2 Decimal Places
Update online_retail.dbo.[Online Retail]
Set UnitPrice = ROUND(UnitPrice,2)
```
Note that after all data cleaning process have been executed, the SQL queries is used to export the finalized data to Power BI to generate further reports and analysis.

### Data Analysis and Results
The section will explain on the explotary and analysis within the data. All questions are self-created based on data exploration previously from Excel. SQL is used in this section and result can be observe below as well.

1. What is the total quantity sold for each unique stock? Group them by StockCode and Description and order by the total amount.
```sql
select StockCode, Description, sum(Quantity) as number_item_sold
from online_retail.dbo.[Online Retail]
group by StockCode, Description
order by number_item_sold desc
```
#### Result
*Below are the snippet of the first ten rows of the result*  
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/e6977373-7283-440a-9d69-1b12668d1dec)  
  (3913 rows affected)
Completion time: 2023-11-09T10:42:35.9630436+08:00

2. Sort customers who have the highest amount spent from the retail. Sort it from highest to the lowest.
```sql
select CustomerID, concat('$',' ',sum(quantity*UnitPrice)) as total_spent
from online_retail.dbo.[Online Retail]
group by CustomerID
order by total_spent desc
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/f87d2074-0ba3-4a8f-a1b2-9982f798efde)      
(4372 rows affected)
Completion time: 2023-11-09T11:21:39.4378766+08:00

3. How many countries that operates this online retail?
```sql
select distinct(Country)
from online_retail.dbo.[Online Retail]
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/32a8f5b6-7eed-4e04-bc09-ea1143709dbc)  
(37 rows affected)
Completion time: 2023-11-09T11:25:50.8922069+08:00

4. How many product was sold in year 2010?
```sql
select distinct(StockCode), Description, count(*) as number_sold
from online_retail.dbo.[Online Retail]
where YEAR(InvoiceDate) = 2010
group by StockCode, Description
order by number_sold desc
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/6e86078b-3fbd-4c8e-a1ad-717d9aaa66d9)    
(2438 rows affected)
Completion time: 2023-11-09T11:28:04.3916633+08:00

5. Which product have the highest price in the retail?
```sql
Select StockCode, Description, MAX(UnitPrice) as Price
from online_retail.dbo.[Online Retail]
group by StockCode, Description
order by Price desc;
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/87c96ebd-2812-4dcc-ba36-3560b0fa607a)  
(3913 rows affected)
Completion time: 2023-11-09T11:31:45.1426731+08:00

6. How much sales made from the first quarter of 2011?
```sql
select format(sum(Quantity*UnitPrice),'c') as total_sales_first_quarter_2011
from online_retail.dbo.[Online Retail]
where InvoiceDate between '2011-01-01 00:00:00' and '2011-03-31 23:59:00'
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/831a0289-cc2f-42b1-aca3-659cc33000e0)  
(1 row affected)
Completion time: 2023-11-09T11:34:19.4994907+08:00

7. Total sales made by United Kingdom.
```sql
select Country, format(sum(Quantity*UnitPrice), 'c') as total_sales
from online_retail.dbo.[Online Retail]
where Country in ('United Kingdom')
group by Country
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/848f5f24-6604-4d45-96b6-4175dc42f2e8)  
(1 row affected)
Completion time: 2023-11-09T11:56:54.1521004+08:00

8. Search stock with their StockCode end with an alphabet.
```sql
select distinct(StockCode), Description
from online_retail.dbo.[Online Retail]
where len(StockCode) > 5
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/48621cf5-b5c5-446d-9cd9-30b9e01a9b1a)  
(900 rows affected)
Completion time: 2023-11-09T11:59:02.8769547+08:00

9. List out all stock quantity refunded by customers.
```sql
select StockCode, Description, Quantity, UnitPrice
from online_retail.dbo.[Online Retail]
where Quantity between -100000 and -1
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/320b1db0-f714-4dec-96e0-ee75167ede07)  
(8905 rows affected)
Completion time: 2023-11-09T12:00:25.1593683+08:00

10. Point out StockCode that are not related to item.
```sql
select *
from online_retail.dbo.[Online Retail]
where StockCode like '_'
```
#### Result
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/0a9aa956-1554-4fba-a3cd-dabf964ae492)  
(542 rows affected)
Completion time: 2023-11-09T12:01:40.1714879+08:00

## Dashboard Reports and Findings

The main dashboard file can be download with given name "Online Retail Dashboard.pbix".  
All reports in the dashboard was generated using Microsoft Power BI. The process are referred as below:
1. Extract data using SQL.
2. Create new measure/column to find possible visualization from the data. In this case, column "Total Sales" have been created to simplify the product of UnitPrice and Quantity.
3. Sort all the visualization accordingly to produce a clear and viewable dashboard.

### Dashboard Overview
*Below shows the overview of the whole dashboard*
![image](https://github.com/MohdAfiq98/Online-Retail-Analyst-Project/assets/119799325/3cd9a474-2cb8-423c-9b93-02b73d7f87cf)  

### Findings
1. It shows that there are 4,732 unique customers have purchased from the retail and obtain $ 8.3 million sales from the fourth quarter of 2010 until fourth quarter of 2011
2. The online retail sales increase consistently. It can be seen from the trend line where it shows that the retail store increase their sales from time to time starting the year 2010 until 2011.
3. Most of the customers are from the United Kingdom with total of 3,950 unique customers recorded, followed by Germany with 95 customers and France with 87 Customers.
4. The most popular purchased item by customers from the retail is White Hanging Heart T-Light Holder with 2,070 unit sold from the year 2010 and 2011.

## Limitations
I previously used MySQL to analyze the project but it turns out that MySQL have limits on its data extraction which is 500,000 rows only but the data have more than 500,000 result. Hence I switched to use Microsoft SQL Server instead and it went alright for the whole analysis. There are also some values that are not explained clearly from the source of data where for the quantity, consists of negative value where here I'm assuming to be the refund value. But in the other hand, the value might be an error or it have different meaning to it. 

## Reference 
Here are some reference used for the whole analysis:
- W3School
- StackOverflow
- Kaggle.com







