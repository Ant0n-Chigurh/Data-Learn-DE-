# 2.3: Подключение к Базам Данных и SQL

### Overview (обзор ключевых метрик)
```
select 
round(sum(sales)) as "Total Sales",
round(sum(o.profit)) as "Total Profit",
round((sum(o.profit)/sum(sales))*100, 2) as "Profit Ratio",
round(avg(discount),2) as "Average Discount"
from orders o 
where o.order_id not in (select order_id from returns)
```
<img width="713" height="84" alt="Screenshot_1" src="https://github.com/user-attachments/assets/744d535a-9059-492b-938b-2e4c2354357e" />


___
# 2.4: Модели Данных

### **Концептуальная модель**

<img width="778" height="410" alt="image" src="https://github.com/user-attachments/assets/92cfdaa2-12dc-4529-9308-e6eb472df03d" />

### **Логическая модель**

<img width="965" height="523" alt="image" src="https://github.com/user-attachments/assets/9dc04a4e-de28-4e7f-a5d4-1bcc26d87766" />
