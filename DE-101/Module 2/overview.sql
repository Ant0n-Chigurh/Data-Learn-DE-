-- Overview (обзор ключевых метрик)

--Total Sales
--Total Profit
--Profit Ratio
--Average Discount

select 
round(sum(sales)) as "Total Sales",
round(sum(o.profit)) as "Total Profit",
round((sum(o.profit)/sum(sales))*100, 2) as "Profit Ratio",
round(avg(discount),2) as "Average Discount"
from orders o 
where o.order_id not in (select order_id from returns)

--Average Profit per Order

select round(avg(profit), 1) as "Profit per Order"
from profit_per_order p 

--Average Sales per Customer

select round(avg(sum_sales)) as "Average Sales per Customer"
from sales_per_customer s 

--Sales by Product Category all time

select category,
round(sum(sales)) as sum_sales
from orders o 
where o.order_id not in (select order_id from returns)
group by category 
order by sum_sales desc

--Sales and Profit by Customer

select customer_id,
customer_name,
round(sum(sales)) as sum_sales,
round(sum(profit)) as sum_profit
from orders o 
where o.order_id not in (select order_id from returns)
group by customer_id, customer_name
order by sum_profit desc

--Sales per region

select region,
round(sum(sales)) as sum_sales
from orders o 
where o.order_id not in (select order_id from returns)
group by region
order by sum_sales desc