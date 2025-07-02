#YOY MOM WOW-- %%
-- Cal all for this sales data contain 2022 23 24 DD
select * from sales;

-- Yoy% yearly
Select * , Year,sales,PY_Sales,
sales - PY_sales as Diff,
concat(round((sales-PY_Sales)/Py_sales*100,0),"%") as `Yoy%`
 from (
select year(sales_date)year,sum(sales)Sales,-- Without using month it is overall year comparision
Lag(sum(sales)) over(order by year(sales_date))PY_Sales            -- With month it distibute and show jan this year jan last year
from sales
group by 1)a;

-- cal MoM%  
Select * ,
concat(round((sales-PY_Sales)/Py_sales*100,0),"%") as `mom%`
 from (
select year(sales_date)year, monthname(sales_date),sum(sales)Sales,  -- With month it becomes mom%
Lag(sum(sales)) over(order by year(sales_date))PY_Sales            
from sales
group by 1,2)a;

-- cal wow%        -- group sales by  week
select *, 
concat(Round((sales-Pweek)/Pweek*100,0),"%") as `WoW%` from(
select week(sales_date)Weekno,sum(sales)sales,
lag(sum(sales)) over(order by week(sales_date))PWeek from sales group by 1)a ; 

-- cal 	QoQ% 
select *, concat(Round((sales-PQtr)/PQtr*100,0),"%") as `QoQ%` from (
select year(sales_date)Year,quarter(sales_date)Qtr,sum(sales)sales,
lag(sum(sales)) over(order by quarter(sales_date))as PQtr
from sales group by 1,2 order by year)a;


-- Cummulative sales / Running Total // Yearly//Monthly//Quarterly
select *, 
sum(sales) over ( order by  year)as Cumm_Sales from (                          -- ORDER BY YEAR 
select year(sales_date)Year, sum(sales)Sales   
from sales group by 1)a; -- Cum Sales for year,

-- Monthly Cumm sales
select year,month,Sales,sum(sales) over (partition by year order by sales)as CummSalesM from(     -- PART BY YEAR ORDER BY MONTH
select year(sales_date)Year,monthname(sales_date)Month,sum(sales)Sales from sales
group by 1,2 order by 1)a;

-- Quarterly Cumm Sales
select *,sum(sales) over(partition by Yr order by Qtr)as CummQtr from (               -- PART BY YEAR ORDER BY QTR
select Year(sales_date)Yr,quarter(sales_date)Qtr, sum(sales)sales 
from sales group by 1,2 order by 1)a order by 1;

-- Cumm% of total 
Select Year,sum(sales) over ( order by  year)as Cumm_Sales,
sum(sales) over ( order by  year)*100 /sum(sales) over()as `Cumm%` from (                          -- ORDER BY YEAR 
select year(sales_date)Year, sum(sales)Sales   
from sales group by 1)a; -- Cum Sales for year

#Various date formats											  
select DATE_FORMAT(sales_date, '%Y-%m')as Yr_Monthno,             -- FullYearno = %Y 2025 ShortYearno = %y  25
	   DATE_FORMAT(sales_date, '%y-%M')as Yr_MonthFullname, 	  -- Monthno = %m 05  MonthFullname = %M January Srtmoname = %b Jan
       DATE_FORMAT(sales_date, '%y-%b')as Yr_Monthname,			  -- Numbering 1st = %D dayno = %d 01
       DATE_FORMAT(sales_date, '%d-%m-%Y')as Date_Std			  -- Standard date = %d-%m-%Y
		from sales;

#CAL MA for all years
select *,avg(sales) over(order by year)as MA_sales from(
select year(sales_date)year,sum(sales)Sales from sales group by 1)a;
#CAL MA for all months in 2024

select * , avg(sales) over(order by mont)MAvg_Sales from (
select year(sales_date)Year,monthname(sales_date)Mont,sum(sales)Sales from sales
where year(sales_date) = 2024 Group by 1,2) a;

# CAL Moving/Rolling average for 3 months (Avg of sales within a specific period) RB 2 PACR
select *,avg(sales) over(order by sales_date ROWS between 2 preceding and current row)WAvg_sales from sales;
