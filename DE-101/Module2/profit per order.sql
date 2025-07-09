CREATE TABLE public.profit_per_order as (select
distinct order_id,
avg(profit) as profit
from orders
where order_id not in (select order_id from returns)
group by order_id)