# 2.3: Подключение к Базам Данных и SQL

### Overview (обзор ключевых метрик)

> + Total Sales
+ Total Profit
+ Profit Ratio
+ Avg. Discount
```
select 
round(sum(sales)) as "Total Sales",
round(sum(o.profit)) as "Total Profit",
round((sum(o.profit)/sum(sales))*100, 2) as "Profit Ratio",
round(avg(discount),2) as "Average Discount"
from orders o 
where o.order_id not in (select order_id from returns)
```
> <img width="713" height="84" alt="Screenshot_1" src="https://github.com/user-attachments/assets/744d535a-9059-492b-938b-2e4c2354357e" />


+ Sales by Product Category all time
```
select category,
round(sum(sales)) as sum_sales
from orders o 
where o.order_id not in (select order_id from returns)
group by category 
order by sum_sales desc
```
<img width="333" height="109" alt="image" src="https://github.com/user-attachments/assets/b749b8b1-efce-43dd-a1bc-e4838b0edb2c" />

---


+ Sales and Profit by Customer
```
select customer_id,
customer_name,
round(sum(sales)) as sum_sales,
round(sum(profit)) as sum_profit
from orders o 
where o.order_id not in (select order_id from returns)
group by customer_id, customer_name
order by sum_profit desc
limit 10
```
<img width="692" height="288" alt="image" src="https://github.com/user-attachments/assets/10aa9916-7643-4158-bd44-bf3231257d56" />

---


+ Sales per region
```
select region,
round(sum(sales)) as sum_sales
from orders o 
where o.order_id not in (select order_id from returns)
group by region
order by sum_sales desc
```
<img width="318" height="137" alt="image" src="https://github.com/user-attachments/assets/2c669df8-9f35-416a-8c10-19cfa69664da" />

___
# 2.4: Модели Данных

### **Концептуальная модель**

<img width="778" height="410" alt="image" src="https://github.com/user-attachments/assets/92cfdaa2-12dc-4529-9308-e6eb472df03d" />

### **Логическая модель**

<img width="965" height="523" alt="image" src="https://github.com/user-attachments/assets/9dc04a4e-de28-4e7f-a5d4-1bcc26d87766" />
