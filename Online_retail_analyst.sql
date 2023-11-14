select * from online_retail.dbo.[Online Retail];

-- DATA CLEANING --
-- Remove Item with no CustomerID Since we want to analyze sales only
select * from online_retail.dbo.[Online Retail] 
where CustomerID is null
-- Found 135,080 rows with no CustomerID

-- Delete Null CustomerID 
delete from online_retail.dbo.[Online Retail]
where CustomerID is Null;
-- 135,080 rows deleted

select * from online_retail.dbo.[Online Retail];

-- Standardize UnitPrice round to 2 Decimal Places
Update online_retail.dbo.[Online Retail]
Set UnitPrice = ROUND(UnitPrice,2)

select * from online_retail.dbo.[Online Retail]

-- 1. Total quantity sold for each unique Stock.
select StockCode, Description, sum(Quantity) as number_item_sold
from online_retail.dbo.[Online Retail]
group by StockCode, Description
order by number_item_sold desc

-- 2. Sort customer with highest number of purchase from  the retail.
select CustomerID, concat('$',' ',sum(quantity*UnitPrice)) as total_spent
from online_retail.dbo.[Online Retail]
group by CustomerID
order by total_spent desc

-- 3. Countries who opens the retail.
select distinct(Country)
from online_retail.dbo.[Online Retail]

-- 4. How many product sold in year 2010.
select distinct(StockCode), Description, count(*) as number_sold
from online_retail.dbo.[Online Retail]
where YEAR(InvoiceDate) = 2010
group by StockCode, Description
order by number_sold desc

-- 5. Product with the highest price. 
Select StockCode, Description, MAX(UnitPrice) as Price
from online_retail.dbo.[Online Retail]
group by StockCode, Description
order by Price desc;

-- 6. How many purchased made from the first quarter of 2011.
select format(sum(Quantity*UnitPrice),'c') as total_sales_first_quarter_2011
from online_retail.dbo.[Online Retail]
where InvoiceDate between '2011-01-01 00:00:00' and '2011-03-31 23:59:00'


-- 7. Total sales made by United Kingdom.
select Country, format(sum(Quantity*UnitPrice), 'c') as total_sales
from online_retail.dbo.[Online Retail]
where Country in ('United Kingdom')
group by Country

-- 8. Find Stock that their StockCode end with an alphabet.
select distinct(StockCode), Description
from online_retail.dbo.[Online Retail]
where len(StockCode) > 5

-- 9. Check whether there are stock quantity refunded by customers.
select StockCode, Description, Quantity, UnitPrice
from online_retail.dbo.[Online Retail]
where Quantity between -100000 and -1

-- 10. StockCode that are not related to item.
select *
from online_retail.dbo.[Online Retail]
where StockCode like '_'