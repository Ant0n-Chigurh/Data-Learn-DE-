create table monthly_sales_by_segment as (select
date(date_trunc('month', order_date)) as month_year,
segment,
round(sum(sales)) as sales_per_month
from orders
group by month_year, segment
order by month_year, segment asc)