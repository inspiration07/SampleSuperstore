create database superstore

use superstore

if exists (select * from tbl_superstore)
drop table tbl_superstore;

create table tbl_superstore
(Ship_mode char(100) not null ,Segment char(100) not null, Country char(100) not null, 
City char(100) not null,State char(100) not null, Postal_Code int not null,
Region char(10) not null, Category char(100) not null, Sub_Category char(100) not null, 
Sales numeric not null, Quantity smallint not null, Discount numeric not null, Profit numeric not null)

--Loading data using bulk insert

bulk insert tbl_superstore
from 'C:\Users\user\Downloads\SampleSuperstore.csv'
with(
datafiletype='char',
firstrow=2,
rowterminator='0x0a',
fieldterminator=',',
errorfile='C:\Users\user\Downloads\Temp.Error_txt.txt'
)

select * from tbl_superstore

--Overview
--Average profit per order customer and per order and see the max money loss
--Total profits made Done
--Profit Ratio Done
--Quantity sold till date Done
--States making max profits and losses (Map)
--By region total profits Tableau
--Manufacturer with highest profit ratio Done
--Avg time to ship an order(Order_Date - Ship_Date) Done
--By Segment total profits Done

--Profit and sales 
--Total sales made
--Total profit made
--Where were the most sales made
--Most sales but less or more profits in terms of manufacturer (Correlation) Done
--Sales by segment and category or sub-category Done
--Sales monthly Tabelau

--Discount and Quantity
--Is giving discount beneficial or not wrt sub-category(Have we sold more with discount or no discount) Done but check
--Total discount given on each category and segment Done
--Total discount given Done
--Average discount on every number of records
--Total Quantity sold
--Quantity sold per month Tableau
--Quantity sold per segment
--Quantity sold in cities and countries (Map)
--Qauntity sold by sub-catrgory(Heat map)
--Most bought by which manufacturer


select distinct Manufacturer, 
sum(convert(float,Sales))over(Partition by Manufacturer)as Total_Sales,
sum(convert(float,Profit))
over(partition by Manufacturer) as Total_Profits from tbl_superstore


--Average order by Sale of product

select avg(convert(float,Profit)) from tbl_superstore


--Sum of profits made

select sum(convert(float,Profit))as Total_Profits from tbl_superstore

--Profit ratio

select sum(convert(float,Profit))/sum(convert(float,Sales))*100 as Profit_Ratio 
from tbl_superstore

--Quantity sold till date

select sum(convert(float,Quantity))as Total_Units_Sold 
from tbl_superstore

--Total profits by region

select sum(convert(float,Profit)) as Regionwise_Total_Profits,Region 
from tbl_superstore 
group by Region

--Manufacturer with highest profit ratio desc

select top 5 sum(convert(float,Profit))/sum(convert(float,Sales))*100 as Profit_Ratio_WRT_Manufacturers, 
Manufacturer 
from tbl_superstore
group by Manufacturer 
order by Profit_Ratio_WRT_Manufacturers desc

--Manufacturer with lowest profit ratio asc

select top 5 sum(convert(float,Profit))/sum(convert(float,Sales))*100 as Profit_Ratio_WRT_Manufacturers, 
Manufacturer 
from tbl_superstore
group by Manufacturer 
order by Profit_Ratio_WRT_Manufacturers asc

--Avg time to ship an order(Order_Date - Ship_Date) Done


select avg(datediff(day,Order_Date,Ship_Date))as days_for_shipment, Segment 
from tbl_superstore
group by Segment

--By Segment total profits


select sum(convert(float,Profit))as profits_by_segment,Segment 
from tbl_superstore
group by Segment

--Most sales but less or more profits in terms of manufacturer (Correlation)

select distinct Manufacturer, sum(convert(float,Sales))over(Partition by Manufacturer)as Total_Sales,
sum(convert(float,Profit))
over(partition by Manufacturer) as Total_Profits 
from tbl_superstore

--Sales by segment and category or sub-category

select sum(convert(float,sales)),Segment 
from tbl_superstore
group by Segment

--Is giving discount beneficial or not wrt sub-category(Have we sold more with discount or no discount)

select sum(convert(float,sales)),Sub_Category 
from tbl_superstore
where convert(float,Discount)=0
group by Sub_Category

select sum(convert(float,sales)),Sub_Category from tbl_superstore
where convert(float,Discount)!=0
group by Sub_Category

--Total discount given on each category and segment

select sum(convert(float,discount)),Category 
from tbl_superstore
group by Category

--Total discount given

select sum(convert(float,Discount))as Total_Discount 
from tbl_superstore

--Average discount on every number of records

select avg(convert(float,Discount))as Avg_Discount 
from tbl_superstore
where convert(float,Discount) != 0

--Total Quantity sold

select sum(convert(float,Quantity))as Total_Quantity 
from tbl_superstore

--Quantity sold per segment

select Segment, sum(convert(float,Quantity))as Quantity_By_Segment 
from tbl_superstore
group by Segment

--Most bought by which manufacturer

select Manufacturer, sum(convert(float,Quantity))as Quantity_By_Segment 
from tbl_superstore
group by Manufacturer