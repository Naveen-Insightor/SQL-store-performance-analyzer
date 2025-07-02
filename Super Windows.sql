-- MASTER WINDOW FUNCTIONS
SELECT * FROM SUPERSTORE;

#ROW NUMBER Assigns a unique number to each row within a partition, ordered by a column.
select row_number() over()Sno ,Manufacturer, sum(sales)sales from superstore group by 2;    -- Add serial no
Select Manufacturer,sum(Sales)Sales, row_number() over(order by sum(sales) desc)SnoX         -- Give row num based on conndition
from superstore Group by 1; 	
-- ROW WITH PARTITION BY 
select category, sub_category, sum(sales)Sales,
row_number() over(partition by category order by sum(sales))Sno_Sales from superstore group by 1,2;


#RANK -- Rank all customer based on sales skips same values  
-- Rank category based on sales 
select Category, Sum(sales)TSales, 
rank() over(order by sum(sales) DESC)Rnk 
from superstore group by 1 ;  											
-- Rank based on each sub category sales
select category, sub_category , sum(sales)Tsales, 
rank() over( partition by category order by sum(sales) desc)Rnk
from superstore group by 1,2 ; 

#DENSERANK -- Ranks all customers without skipping value
select category,sum(sales)Tsale, dense_rank() over(order by sum(sales))Drnk from superstore group by 1;
select category,sub_category, sum(sales)Tsales,
dense_rank() over(partition by category order by sum(sales)desc)Drnk from superstore group by 1,2;

#Ntile -- How do you bucket sales (Quartile 4, Percentile 100)
select Customer_name, sum(sales)Sales , NTILE(4) OVER(ORDER BY SUM(SALES) DESC)Quartile from superstore group by 1;
select Customer_name, sum(sales)Sales , NTILE(10) OVER(ORDER BY SUM(SALES) DESC)Quartile from superstore group by 1;
-- Divide the entire data into parts for future analysis
		
#FIRST VALUE - LAST VALUE   Returns the first/last value in the window
-- What was the first and last product a customer purchased?
select distinct customer_name,
FIRST_VALUE(PRODUCT_NAME) OVER(Partition by customer_name ORDER BY ORDER_DATE)First_Pro,
FIRST_VALUE(Order_date) OVER(Partition by customer_name ORDER BY ORDER_DATE)First_Date,
LAST_VALUE(PRODUCT_NAME) OVER(Partition by customer_name  
ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)Last_pro,  -- RB UP UF
LAST_VALUE(order_date) OVER(Partition by customer_name 
ORDER BY ORDER_DATE ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)Last_Date from superstore ;
            
-- What was the last item a customer bought (till date)?                                            
select Distinct Customer_name,
last_value(product_name) over (partition by customer_name order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)Last_product,
last_value(order_date) over (partition by customer_name order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)Last_Date
from superstore;

-- First order and last order city name with order_id
select first_value(order_id) over(order by order_date)First_Ordr,
first_value(city) over(order by order_date)First_city ,
last_value(order_id) over(order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING)Last_ordr,
last_value(city) over(order by order_date ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED following)Last_city FROM SUPERSTORE LIMIT 1;

#LAG() gets previus rows data or past data  -- Trends analysis , time series analysis , Value increase decrease
-- Show the previous order's profit for each row
select order_id,order_date, profit, lag(profit) over(order by Order_Date)PR from superstore order by order_date; 
-- Compare each customer’s profit with their previous order’s profit
select customer_name,order_date,profit, 
lag(profit) over(partition by customer_name order by order_date)PO_Profit from superstore;

#LEAD() Gets next rows order , future data 
-- Give each customer’s , and compare it with their next order. If no next order, show 0 as default.
select customer_name,order_date,profit,
ifnull(lead(profit) over(partition by customer_name order by order_date),0)Nx_profit from superstore;
