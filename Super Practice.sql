#Superstore Super practice
use may_25;
select * from superstore;

#What is the total profit for each product category?
select sub_category, sum(profit)Profit from superstore group by 1;

#Find the top 5 products by total sales.
select Product_name , sum(sales)Sales from superstore group by 1 order by 2 desc limit 5;

#List all orders with negative profit.
select Order_ID, profit from superstore where profit <0 order by 2 ;  -- Order ID is row level data so no need aggregation


#Find the average shipping time in days by Ship Mode.
select Ship_mode, round(avg(ship_date-order_date),0) as Days from superstore group by 1;   -- Directly we can - in the function without subquery

#Which sub-category has the highest average sales per order?
select sub_category , avg(sales)Avg_sales from superstore group by 1 order by 2 desc limit 1;

#List the number of unique customers per country
select * from superstore;
select Country, count(distinct customer_name)No_Customers from superstore group by 1 order by 2 desc;

#Which manufacturer has the highest average profit per product?
select Manufacturer,avg(profit)Avg_pro from superstore group by 1 order by 2 desc limit 1;

#Calculate total sales and profit by year.
select year(order_date)Year, sum(sales)Sales , Sum(Profit) Profit from superstore group by 1 order by 1 ;

#Which region has the highest sales-to-profit ratio?
select region, sum(sales)/sum(profit)*100 as SP_Ratio from superstore group by 1 order by 2 desc limit 1;

#Find customers who ordered more than 3 distinct sub-categories.
select customer_name, count(distinct sub_category)No_subcat from superstore
group by 1 Having count(distinct sub_category) > 3 order by 2 desc limit 1;

#Rank the sub-categories by total sales within each category.
select category,sub_category,sum(sales)Sales,
dense_rank() over(partition by category order by sum(sales)desc)Rnk 
from superstore group by 1,2 order by 1;

#Which month has the highest average order quantity?
select year(order_date)Yr,Monthname(order_date)Mname, avg(Quantity)Avg_Qty from superstore group by 1,2 order by 1,3 desc limit 1;

