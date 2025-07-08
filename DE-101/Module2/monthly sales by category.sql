create table monthly_sales_by_category as (select
date(date_trunc('month', order_date)) as month_year,
category,
round(sum(sales)) as sales_per_month
from orders
group by month_year, category
order by month_year, category asc)
