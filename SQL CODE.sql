create database med_inventory;
create table med_inventory(
BillDate date,
TQty int,
UCPwithoutGST float,
PurGSTPer float,
MRP float,
TotalCost float,
TotalDiscount float,
NetSales float,
ReturnMRP float,
GenericName varchar(500),
SubCategory varchar(150),
SubCategoryL3 varchar(150),
AnonymizedBillNo varchar(150),
AnonymizedSpecialisation varchar(50) );
select * from med_inventory;

SELECT
ROUND(AVG(TQty),2) AS mean_TQty,
ROUND(AVG(UCPwithoutGST),2) AS mean_UCPwithoutGST,
ROUND(AVG(PurGSTPer),2) AS mean_PurGSTPer,
ROUND(AVG(MRP),2) AS mean_MRP,
ROUND(AVG(TotalCost),2) AS mean_TotalCost,
ROUND(AVG(TotalDiscount),2) AS 	mean_ToatlDiscount,
ROUND(AVG(NetSales),2) AS mean_NetSales,
Round(AVG(ReturnMRP),2) AS mean_ReturnMRP
FROM med_inventory;

SELECT
ROUND(AVG(TQty),2) AS median_TQty,
ROUND(AVG(UCPwithoutGST),2) AS median_UCPwithoutGST,
ROUND(AVG(PurGSTPer),2) AS median_PurGSTPer,
ROUND(AVG(MRP),2) AS median_MRP,
ROUND(AVG(TotalCost),2) AS median_TotalCost,
ROUND(AVG(TotalDiscount),2) AS median_ToatlDiscount,
ROUND(AVG(NetSales),2) AS median_NetSales,
Round(AVG(ReturnMRP),2) AS median_ReturnMRP
FROM ( 
Select TQty, UCPwithoutGST, PurGSTper, MRP, TotalCost, TotalDiscount, NetSales, ReturnMRP,
ROW_NUMBER() OVER (ORDER BY TQty) AS row_num,
COUNT(*) OVER () AS total_rows FROM med_inventory)
AS subquery
WHERE row_num IN (FLOOR((total_rows +1)/2), CEILING((total_rows +1)/2));
SELECT
  mode_TQty.mode_value AS mode_TQty,
  mode_UCPwithoutGST.mode_value AS mode_UCPwithoutGST,
  mode_PurGSTPer.mode_value AS mode_PurGSTPer,
  mode_MRP.mode_value AS mode_MRP,
  mode_TotalCost.mode_value AS mode_TotalCost,
  mode_TotalDiscount.mode_value AS mode_TotalDiscount,
  mode_NetSales.mode_value AS mode_NetSales,
  mode_ReturnMRP.mode_value AS mode_ReturnMRP
FROM (
  SELECT TQty AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY TQty
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_TQty,
(
  SELECT UCPwithoutGST AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY UCPwithoutGST
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_UCPwithoutGST,
(
  SELECT PurGSTPer AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY PurGSTPer
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_PurGSTPer,
(
  SELECT MRP AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY MRP
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_MRP,
(
  SELECT TotalCost AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY TotalCost
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_TotalCost,
(
  SELECT TotalDiscount AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY TotalDiscount
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_TotalDiscount,
(
  SELECT NetSales AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY NetSales
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_NetSales,
(
  SELECT ReturnMRP AS mode_value, COUNT(*) AS mode_count
  FROM med_inventory
  GROUP BY ReturnMRP
  ORDER BY COUNT(*) DESC
  LIMIT 1
) AS mode_ReturnMRP;
SELECT VARIANCE(TQty) AS TQty_variance -- 10.35768
FROM med_inventory;

SELECT VARIANCE(UCPwithoutGST) AS UCPwithoutGST_variance -- 1125888.55739
FROM med_inventory;

SELECT VARIANCE(PurGSTPer) AS PurGSTPer_variance -- 2.651144
FROM med_inventory;

SELECT VARIANCE(MRP) AS MRP_variance -- 3168001.50431
FROM med_inventory;

SELECT VARIANCE(TotalCost) AS TotalCost_variance -- 4531490.75040
FROM med_inventory;

SELECT VARIANCE(NetSales) AS NetSales_variance -- 10255590.63843
FROM med_inventory;

SELECT VARIANCE(ReturnMRP) AS ReturnMRP_variance -- 1211851.23294
FROM med_inventory;
SELECT STDDEV(TQty) AS TQty_stddev -- 3.218336
FROM med_inventory;

SELECT STDDEV(UCPwithoutGST) AS UCPwithoutGST_stddev -- 1061;
FROM med_inventory;
SELECT STDDEV(PurGSTPer) AS PurGSTPer_stddev -- 1.6282333
FROM med_inventory;

SELECT STDDEV(MRP) AS MRP_stddev -- 1779.888059
FROM med_inventory;

SELECT STDDEV(TotalCost) AS TotalCost_stddev -- 2128.729844
FROM med_inventory;

SELECT STDDEV(NetSales) AS NetSales_stddev -- 3202.43511
FROM med_inventory;

SELECT STDDEV(ReturnMRP) AS ReturnMRP_stddev -- 1100.84114
FROM med_inventory;

-- Range
SELECT MAX(TQty) - MIN(TQty) AS TQty_range -- 498
FROM med_inventory;

SELECT MAX(UCPwithoutGST) - MIN(UCPwithoutGST) AS UCPwithoutGST_range -- 36982.5
FROM med_inventory;

SELECT MAX(PurGSTPer) - MIN(PurGSTPer) AS PurGSTPer_range -- 36
FROM med_inventory;

SELECT MAX(MRP) - MIN(MRP) AS MRP_range -- 56399.1000
FROM med_inventory;

SELECT MAX(TotalCost) - MIN(TotalCost) AS TotalCost_range -- 121054.5
FROM med_inventory;

SELECT MAX(NetSales) - MIN(NetSales) AS NetSales_range -- 100620
FROM med_inventory;

SELECT MAX(ReturnMRP) - MIN(ReturnMRP) AS ReturnMRP_range -- 160801.20312
FROM med_inventory;

--  Third and Fourth Moment Business Decision
-- skewness and kurkosis 
SELECT
    (
        SUM(POWER(TQty - (SELECT AVG(TQty) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TQty) FROM med_inventory), 3))
    ) AS skewness, -- -15.8368666
    (
        (SUM(POWER(TQty - (SELECT AVG(TQty) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TQty) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 2357.3532
FROM med_inventory;

SELECT
    (
        SUM(POWER(UCPwithoutGST - (SELECT AVG(UCPwithoutGST) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(UCPwithoutGST) FROM med_inventory), 3))
    ) AS skewness, -- 8.688700
    (
        (SUM(POWER(UCPwithoutGST - (SELECT AVG(UCPwithoutGST) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(UCPwithoutGST) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 138.09349
FROM med_inventory;

SELECT
    (
        SUM(POWER(PurGSTPer - (SELECT AVG(PurGSTPer) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(PurGSTPer) FROM med_inventory), 3))
    ) AS skewness, -- 8.5536788
    (
        (SUM(POWER(PurGSTPer - (SELECT AVG(PurGSTPer) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(PurGSTPer) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 80.579033
FROM med_inventory;

SELECT
    (
        SUM(POWER(MRP - (SELECT AVG(MRP) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(MRP) FROM med_inventory), 3))
    ) AS skewness, -- 7.0694671
    (
        (SUM(POWER(MRP - (SELECT AVG(MRP) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(MRP) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 98.157233
FROM med_inventory;

SELECT
    (
        SUM(POWER(TotalCost - (SELECT AVG(TotalCost) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TotalCost) FROM med_inventory), 3))
    ) AS skewness, -- 14.1809983
    (
        (SUM(POWER(TotalCost - (SELECT AVG(TotalCost) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TotalCost) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 376.742373
FROM med_inventory;

SELECT
    (
        SUM(POWER(NetSales - (SELECT AVG(NetSales) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(NetSales) FROM med_inventory), 3))
    ) AS skewness, -- 8.983511
    (
        (SUM(POWER(NetSales - (SELECT AVG(NetSales) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(NetSales) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 145.639667
FROM med_inventory;

SELECT
    (
        SUM(POWER(ReturnMRP - (SELECT AVG(ReturnMRP) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(ReturnMRP) FROM med_inventory), 3))
    ) AS skewness, -- 48.250410
    (
        (SUM(POWER(ReturnMRP - (SELECT AVG(ReturnMRP) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(ReturnMRP) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 5617.072837
FROM med_inventory;

-- Total  quantity sold
select count(TQty) from med_inventory where TQty > 0;
-- 73983 number of quantity sold

-- return total quantity 
select count(TQty) from med_inventory where TQty < 0;
-- 11017 number of quantity return



-- sum of return of total quantity 
select sum(TQty) from med_inventory where TQty < 0;
-- 24524 number of quantity return

-- sum of Total  quantity sold
select sum(TQty) from med_inventory where TQty > 0;
-- 170279 number of quantity sold

-- Total Quantity sold per each month
select month(BillDate) as month, sum(TQty) as total_QTY_Sold_Month
from med_inventory
group by month(BillDate) Order by total_QTY_Sold_Month desc;  -- 9th month (September) has more quantity sold 16750

select Year(BillDate) as month, sum(TQty) as total_QTY_Sold_year
from med_inventory
group by Year(BillDate) Order by total_QTY_Sold_year;

-- Total Quantity sold per each week
select week(BillDate) as week, sum(TQty) as total_QTY_Sold_week
from med_inventory 
group by week(BillDate) Order by total_QTY_Sold_week desc;  -- 37th week as more quality sold 4217



WITH WeeklyData AS (
    SELECT
        YEAR(BillDate) AS Year,
        MONTH(BillDate) AS Month,
        WEEK(BillDate, 1) AS Week,
        genericName,
        SUM(TQty) AS TotalTQty
    FROM med_inventory
    GROUP BY
        YEAR(BillDate), MONTH(BillDate), WEEK(BillDate, 1), genericName
)
SELECT
    Year, Month, Week, genericName,
    SUM(TotalTQty) AS TotalTQtyPerWeek
FROM WeeklyData
GROUP BY
    Year, Month, Week, genericName
ORDER BY
    TotalTQtyPerWeek desc; -- 2021 year 9th month 38th week as more quantity sold that is sodium chloride 0.9% with number of 332

WITH MonthlyData AS (
    SELECT
        YEAR(BillDate) AS Year,
        MONTH(BillDate) AS Month,
        genericName,
        SUM(TQty) AS TotalTQty
    FROM med_inventory
    GROUP BY
        YEAR(BillDate), MONTH(BillDate), genericName
)
SELECT
    Year, Month,genericName,
    SUM(TotalTQty) AS TotalTQtyPerMonth
FROM MonthlyData
GROUP BY
    Year, Month,genericName
ORDER BY
    TotalTQty desc;

-- TOTAL NUMBER OF QUANTITY RETURN FOR EACH MONTH
select month(BillDate) as month,sum(TQty) as total_quantity_return_month 
from med_inventory where TQty<0
group by month(BillDate)
order by total_quantity_return_month asc;  -- 2580 quantity return is the most on 5th month

select month(BillDate) , GenericName, SubCategory, SubCategoryL3 as month,sum(TQty) as total_quantity_return_month 
from med_inventory where TQty<0
group by month(BillDate) , GenericName, SubCategory, SubCategoryL3
order by total_quantity_return_month desc; 

-- Drug with the highest total quantity sold
select GenericName ,sum(TQty) as total_quantity_sold
from med_inventory
group by GenericName
order by total_quantity_sold desc;  -- sodium chloride 0.9% is the most sold quantity with number of 19412

-- Drug,subcat,subcat1 with the highest total sales quantity
select GenericName ,SubCategory, SubCategoryL3,sum(TQty) as total_quantity_sold
from med_inventory
group by GenericName ,SubCategory, SubCategoryL3
order by total_quantity_sold desc;
-- most quantity sold by overall category SODIUM CHLORIDE 0.9%	IV FLUIDS, ELECTROLYTES, TPN	INTRAVENOUS & OTHER STERILE SOLUTIONS	19412

select  SubCategoryL3,sum(TQty) as total_quantity_sold
from med_inventory
group by SubCategoryL3
order by total_quantity_sold desc;

select SubCategory, sum(TQty) as total_quantity_sold
from med_inventory
group by SubCategory
order by total_quantity_sold desc;

-- total sales per month 
select month(BillDate)as month,sum(NetSales) as total_Sales 
from med_inventory
group by month(BillDate) 
order by  total_Sales desc;  -- most of the sales are done on september month with 8682139.78145
 
-- total sales per week
select week(BillDate)as month,sum(NetSales) as total_Sales 
from med_inventory
group by week(BillDate) 
order by total_Sales desc; -- 36th week as more sales with 2498988.63090

-- total sales for each drugname in each month from the medical_dataset table
select month(BillDate) as month, GenericName, sum(NetSales) as total_sales
from med_inventory
group by month(BillDate), GenericName
order by total_sales desc; -- Meropenem 1GM Injection  has the most sales on sept with 1461725.000488

-- total sales for each drugname in each week from the medical_dataset table
select week(BillDate) as week, GenericName, sum(NetSales) as total_sales
from med_inventory
group by week(BillDate), GenericName
order by total_sales desc;
  
-- Total NetSales by drugname
SELECT GenericName, SUM(NetSales) as TotalNetSales
FROM med_inventory
GROUP BY GenericName ORDER BY TotalNetSales desc;

-- MEROPENEM 1GM INJ as more sales with 11053954.934570312

-- Top 10 SubCategoryL3 by NetSales
SELECT SubCategoryL3, SUM(NetSales) as NetSales
FROM med_inventory
GROUP BY SubCategoryL3
ORDER BY NetSales desc;

SELECT SubCategory, SUM(NetSales) as NetSales
FROM med_inventory
GROUP BY SubCategory
ORDER BY NetSales desc;

-- ANTI-INFECTIVES as highest sales with 47870754.340233326

-- Top 10 SubCategoryL3 by Quantity
SELECT SubCategoryL3, SUM(TQty) as Quantity
FROM med_inventory
GROUP BY SubCategoryL3
ORDER BY Quantity desc;

-- INTRAVENOUS & OTHER STERILE SOLUTIONS as highest quantity with 48685;

SELECT STDDEV(UCPwithoutGST) AS UCPwithoutGST_stddev -- 1061.0789
FROM med_inventory;

SELECT STDDEV(PurGSTPer) AS PurGSTPer_stddev -- 1.6282333
FROM med_inventory;

SELECT STDDEV(MRP) AS MRP_stddev -- 1779.888059
FROM med_inventory;

SELECT STDDEV(TotalCost) AS TotalCost_stddev -- 2128.729844
FROM med_inventory;

SELECT STDDEV(NetSales) AS NetSales_stddev -- 3202.43511
FROM med_inventory;

SELECT STDDEV(ReturnMRP) AS ReturnMRP_stddev -- 1100.84114
FROM med_inventory;

-- Range
SELECT MAX(TQty) - MIN(TQty) AS TQty_range -- 498
FROM med_inventory;

SELECT MAX(UCPwithoutGST) - MIN(UCPwithoutGST) AS UCPwithoutGST_range -- 36982.5
FROM med_inventory;

SELECT MAX(PurGSTPer) - MIN(PurGSTPer) AS PurGSTPer_range -- 36
FROM med_inventory;

SELECT MAX(MRP) - MIN(MRP) AS MRP_range -- 56399.1000
FROM med_inventory;

SELECT MAX(TotalCost) - MIN(TotalCost) AS TotalCost_range -- 121054.5
FROM med_inventory;

SELECT MAX(NetSales) - MIN(NetSales) AS NetSales_range -- 100620
FROM med_inventory;

SELECT MAX(ReturnMRP) - MIN(ReturnMRP) AS ReturnMRP_range -- 160801.20312
FROM med_inventory;

--  Third and Fourth Moment Business Decision
-- skewness and kurkosis 
SELECT
    (
        SUM(POWER(TQty - (SELECT AVG(TQty) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TQty) FROM med_inventory), 3))
    ) AS skewness, -- -15.8368666
    (
        (SUM(POWER(TQty - (SELECT AVG(TQty) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TQty) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 2357.3532
FROM med_inventory;

SELECT
    (
        SUM(POWER(UCPwithoutGST - (SELECT AVG(UCPwithoutGST) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(UCPwithoutGST) FROM med_inventory), 3))
    ) AS skewness, -- 8.688700
    (
        (SUM(POWER(UCPwithoutGST - (SELECT AVG(UCPwithoutGST) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(UCPwithoutGST) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 138.09349
FROM med_inventory;

SELECT
    (
        SUM(POWER(PurGSTPer - (SELECT AVG(PurGSTPer) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(PurGSTPer) FROM med_inventory), 3))
    ) AS skewness, -- 8.5536788
    (
        (SUM(POWER(PurGSTPer - (SELECT AVG(PurGSTPer) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(PurGSTPer) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 80.579033
FROM med_inventory;

SELECT
    (
        SUM(POWER(MRP - (SELECT AVG(MRP) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(MRP) FROM med_inventory), 3))
    ) AS skewness, -- 7.0694671
    (
        (SUM(POWER(MRP - (SELECT AVG(MRP) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(MRP) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 98.157233
FROM med_inventory;

SELECT
    (
        SUM(POWER(TotalCost - (SELECT AVG(TotalCost) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TotalCost) FROM med_inventory), 3))
    ) AS skewness, -- 14.1809983
    (
        (SUM(POWER(TotalCost - (SELECT AVG(TotalCost) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(TotalCost) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 376.742373
FROM med_inventory;

SELECT
    (
        SUM(POWER(NetSales - (SELECT AVG(NetSales) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(NetSales) FROM med_inventory), 3))
    ) AS skewness, -- 8.983511
    (
        (SUM(POWER(NetSales - (SELECT AVG(NetSales) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(NetSales) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 145.639667
FROM med_inventory;

SELECT
    (
        SUM(POWER(ReturnMRP - (SELECT AVG(ReturnMRP) FROM med_inventory), 3)) / 
        (COUNT(*) * POWER((SELECT STDDEV(ReturnMRP) FROM med_inventory), 3))
    ) AS skewness, -- 48.250410
    (
        (SUM(POWER(ReturnMRP - (SELECT AVG(ReturnMRP) FROM med_inventory), 4)) / 
        (COUNT(*) * POWER((SELECT STDDEV(ReturnMRP) FROM med_inventory), 4))) - 3
    ) AS kurtosis -- 5617.072837
FROM med_inventory;

-- Total  quantity sold
select count(TQty) from med_inventory where TQty > 0;
-- 73983 number of quantity sold

-- return total quantity 
select count(TQty) from med_inventory where TQty < 0;
-- 11017 number of quantity return



-- sum of return of total quantity 
select sum(TQty) from med_inventory where TQty < 0;
-- 24524 number of quantity return

-- sum of Total  quantity sold
select sum(TQty) from med_inventory where TQty > 0;
-- 170279 number of quantity sold

-- Total Quantity sold per each month
select month(BillDate) as month, sum(TQty) as total_QTY_Sold_Month
from med_inventory
group by month(BillDate) Order by total_QTY_Sold_Month desc;  -- 9th month (September) has more quantity sold 16750

select Year(BillDate) as month, sum(TQty) as total_QTY_Sold_year
from med_inventory 
group by Year(BillDate) Order by total_QTY_Sold_year;

-- Total Quantity sold per each week
select week(BillDate) as week, sum(TQty) as total_QTY_Sold_week
from med_inventory
group by week(BillDate) Order by total_QTY_Sold_week desc;  -- 37th week as more quality sold 4217



WITH WeeklyData AS (
    SELECT
        YEAR(BillDate) AS Year,
        MONTH(BillDate) AS Month,
        WEEK(BillDate, 1) AS Week,
        genericName,
        SUM(TQty) AS TotalTQty
    FROM med_inventory
    GROUP BY
        YEAR(BillDate), MONTH(BillDate), WEEK(BillDate, 1), genericName
)
SELECT
    Year, Month, Week, genericName,
    SUM(TotalTQty) AS TotalTQtyPerWeek
FROM WeeklyData
GROUP BY
    Year, Month, Week, genericName
ORDER BY
    TotalTQtyPerWeek desc; -- 2021 year 9th month 38th week as more quantity sold that is sodium chloride 0.9% with number of 332

WITH MonthlyData AS (
    SELECT
        YEAR(BillDate) AS Year,
        MONTH(BillDate) AS Month,
        genericName,
        SUM(TQty) AS TotalTQty
    FROM med_inventory
    GROUP BY
        YEAR(BillDate), MONTH(BillDate), genericName
)
SELECT
    Year, Month,genericName,
    SUM(TotalTQty) AS TotalTQtyPerMonth
FROM MonthlyData
GROUP BY
    Year, Month,genericName
ORDER BY
    TotalTQty desc;

-- TOTAL NUMBER OF QUANTITY RETURN FOR EACH MONTH
select month(BillDate) as month,sum(TQty) as total_quantity_return_month 
from med_inventory where TQty<0
group by month(BillDate)
order by total_quantity_return_month asc;  -- 2580 quantity return is the most on 5th month

select month(BillDate) , GenericName, SubCategory, SubCategoryL3 as month,sum(TQty) as total_quantity_return_month 
from med_inventory where TQty<0
group by month(BillDate) , GenericName, SubCategory, SubCategoryL3
order by total_quantity_return_month desc; 

-- Drug with the highest total quantity sold
select GenericName ,sum(TQty) as total_quantity_sold
from med_inventory
group by GenericName
order by total_quantity_sold desc;  -- sodium chloride 0.9% is the most sold quantity with number of 19412

-- Drug,subcat,subcat1 with the highest total sales quantity
select GenericName ,SubCategory, SubCategoryL3,sum(TQty) as total_quantity_sold
from med_inventory
group by GenericName ,SubCategory, SubCategoryL3
order by total_quantity_sold desc;
-- most quantity sold by overall category SODIUM CHLORIDE 0.9%	IV FLUIDS, ELECTROLYTES, TPN	INTRAVENOUS & OTHER STERILE SOLUTIONS	19412

select  SubCategoryL3,sum(TQty) as total_quantity_sold
from med_inventory
group by SubCategoryL3
order by total_quantity_sold desc;

select SubCategory, sum(TQty) as total_quantity_sold
from med_inventory
group by SubCategory
order by total_quantity_sold desc;

-- total sales per month 
select month(BillDate)as month,sum(NetSales) as total_Sales 
from med_inventory
group by month(BillDate) 
order by  total_Sales desc;  -- most of the sales are done on september month with 8682139.78145
 
-- total sales per week
select week(BillDate)as month,sum(NetSales) as total_Sales 
from med_inventory
group by week(BillDate) 
order by total_Sales desc; -- 36th week as more sales with 2498988.63090

-- total sales for each drugname in each month from the medical_dataset table
select month(BillDate) as month, GenericName, sum(NetSales) as total_sales
from med_inventory
group by month(BillDate), GenericName
order by total_sales desc; -- Meropenem 1GM Injection  has the most sales on sept with 1461725.000488

-- total sales for each drugname in each week from the medical_dataset table
select week(BillDate) as week, GenericName, sum(NetSales) as total_sales
from med_inventory
group by week(BillDate), GenericName
order by total_sales desc;
  
-- Total NetSales by drugname
SELECT GenericName, SUM(NetSales) as TotalNetSales
FROM med_inventory
GROUP BY GenericName ORDER BY TotalNetSales desc;

-- MEROPENEM 1GM INJ as more sales with 11053954.934570312

-- Top 10 SubCategoryL3 by NetSales
SELECT SubCategoryL3, SUM(NetSales) as NetSales
FROM med_inventory
GROUP BY SubCategoryL3
ORDER BY NetSales desc;

SELECT SubCategory, SUM(NetSales) as NetSales
FROM med_inventory
GROUP BY SubCategory
ORDER BY NetSales desc;

-- ANTI-INFECTIVES as highest sales with 47870754.340233326

-- Top 10 SubCategoryL3 by Quantity
SELECT SubCategoryL3, SUM(TQty) as Quantity
FROM med_inventory
GROUP BY SubCategoryL3
ORDER BY Quantity desc;

-- INTRAVENOUS & OTHER STERILE SOLUTIONS as highest quantity with 48685



