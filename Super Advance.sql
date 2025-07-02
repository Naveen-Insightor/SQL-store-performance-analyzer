#Which customer made the highest total purchase (by sales)?
select customer_name , sum(sales)Sales from superstore group by 1 order by 2 desc limit 1;

select *  from(
select customer_name , sum(sales)sales, dense_rank() over (order by sum(sales) desc)Rnk    -- Using Subquery
from superstore group by 1)a where Rnk = 1;

With Ranked_Table as (
select customer_name, sum(sales)Sales , dense_rank() over ( order by sum(sales) desc)Rnk   -- Using CTEs
from superstore group by 1)
select * from Ranked_Table where Rnk = 1;

#Find the fastest and slowest average shipping states.
select * from (
select state, Round(avg(Ship_Date - Order_date),0) as Days from superstore group by 1 order by 2  limit 1)Fast
UNION
select * from (
select state, Round(avg(Ship_Date - Order_date),0) as Days from superstore group by 1 order by 2 desc limit 1)SLOW ;


#Identify customers who made repeat purchases on the same day in different years. CUST--DAY
select customer_name, day(order_date)Day, month(order_date)Month 
from superstore group by 1,2,3
having count(distinct year(order_date)) > 1;

#List product-manufacturer pairs with above-average sales and profit.
select product_name, Manufacturer, avg(sales)ASales, avg(profit)AProfit from superstore 
group by 1,2 Having avg(sales) > (select avg(sales) from superstore) and
avg(profit) > (select avg(profit)from superstore);

#Show category-wise YoY growth in sales.

select *,concat(Round((CY-PY)*100/PY,0),"%")`YoY%` from (
select category, year(order_date)Yr, sum(sales)CY,
lag(sum(sales)) over(partition by category order by year(order_date))PY
from superstore group by 1,2)a;

#Find customers whose profit-to-sales ratio exceeds 50%.
select customer_name, SP_Ratio from(
select customer_name, sum(profit)/sum(sales)*100 as SP_Ratio from superstore group by 1)a 
Where Sp_ratio > 50;

select * from superstore;
#Calculate the cumulative sales per customer over time.
select Customer_name,order_date,SALES,
sum(sales) over(partition by customer_name order by order_date)Cumm_Sales  
from superstore group by 1,2,3;

#Identify orders where total quantity exceeds twice the average quantity for that product.
SELECT Product_Name, Quantity,
AVG(Quantity) OVER (PARTITION BY Product_Name) from superstore; -- To find average for each product

Select product_name, Quantity from (
SELECT Product_Name, Quantity,
AVG(Quantity) OVER (PARTITION BY Product_Name)as Avg_Qpp from superstore ) a 
Where Quantity > 2*Avg_Qpp; 