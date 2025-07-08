create table sales_per_customer as (
select 
customer_id,
customer_name,
sum(sales) as sum_sales
from orders
where order_id not in (select order_id from returns)
group by customer_id, customer_name
order by sum_sales desc)