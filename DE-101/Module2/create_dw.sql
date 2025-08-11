-- ************************************** product

drop table dw.product cascade;

--creating table
CREATE TABLE dw.product
(
 prod_id      serial NOT NULL,
 product_id   varchar(15) NOT NULL,
 category     varchar(15) NOT NULL,
 subcategory  varchar(11) NOT NULL,
 product_name varchar(127) NOT NULL,
 CONSTRAINT PK_6 PRIMARY KEY ( prod_id )
);

--deleting rows
truncate table dw.product;

--insert unique values and generate id
insert into dw.product 
select row_number() over (order by product_id asc),
product_id,
category, 
subcategory,
product_name
from (select distinct product_id,
category, 
subcategory,
product_name
from public.orders);

--checking
select *
from dw.product

-- ************************************** customers

drop table dw.customers cascade;

--creating table
CREATE TABLE dw.customers
(
 cust_id       serial NOT NULL,
 customer_id   varchar(8) NOT NULL,
 customer_name varchar(22) NOT NULL,
 segment       varchar(11) NOT NULL,
 CONSTRAINT PK_6_1 PRIMARY KEY ( cust_id )
);

--deleting rows
truncate table dw.customers;

--insert unique values and generate id
insert into dw.customers
select row_number() over (order by customer_name asc),
customer_id,
customer_name,
segment
from (select distinct customer_id,
customer_name,
segment
from public.orders);

--checking
select *
from dw.customers

-- ************************************** shipping

drop table dw.shipping cascade;

--creating table
CREATE TABLE dw.shipping
(
 ship_id   serial NOT NULL,
 ship_mode varchar(14) NOT NULL,
 CONSTRAINT PK_4 PRIMARY KEY ( ship_id )
);

--deleting rows
truncate table dw.shipping;

--insert unique values and generate id
insert into dw.shipping
select 100+row_number() over(),
ship_mode
from (select distinct ship_mode
from public.orders);

--checking
select *
from dw.shipping;

-- ************************************** geo

drop table dw.geo cascade;

--creating table
CREATE TABLE dw.geo
(
 geo_id      serial NOT NULL,
 country     varchar(13) NOT NULL,
 city        varchar(17) NOT NULL,
 state     varchar(20) NOT NULL,
 region      varchar(7) NOT NULL,
 postal_code int4 NOT NULL,
 CONSTRAINT PK_3 PRIMARY KEY ( geo_id )
);

--deleting rows
truncate table dw.geo;

--insert unique values and generate id
insert into dw.geo
select row_number() over(order by state, city asc),
country,
city,
state,
region,
postal_code
from (select distinct country,
city,
state,
region,
postal_code
from public.orders);

/* 
--fill data missing
select * from public.orders where postal_code is null; 
-- Burlington doesn't have postal code
-- update postal code for Burlington, Vermont
update orders  
set postal_code = '05401' where city = 'Burlington' and state = 'Vermont' and postal_code is null;
*/

--checking
select *
from dw.geo

-- ************************************** calendar

drop table dw.calendar cascade;

--creating table
CREATE TABLE dw.calendar
(
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 year       int4 NOT NULL,
 quarter    int4 NOT NULL,
 month      int4 NOT NULL,
 week       int4 NOT NULL,
 week_day   varchar(15) NOT NULL,
 CONSTRAINT PK_2 PRIMARY KEY ( order_date, ship_date )
);

--deleting rows
truncate table dw.calendar;

--insert unique values and generate id
insert into dw.calendar (order_date, ship_date, year, quarter, month, week, week_day)
select distinct 
     order_date,
     ship_date, 
     EXTRACT(YEAR FROM order_date) AS year,
     EXTRACT(QUARTER FROM order_date) AS quarter,
     EXTRACT(MONTH FROM order_date) AS month,
     EXTRACT(WEEK FROM order_date) AS week,
     TO_CHAR(order_date, 'Day') AS week_day
from orders;

--checking
select *
from dw.calendar

-- ************************************** sales

drop table dw.sales cascade;

--creating table
CREATE TABLE dw.sales
(
 row_id     int4 NOT NULL,
 order_id   varchar(14) NOT NULL,
 order_date date NOT NULL,
 ship_date  date NOT NULL,
 ship_id    serial NOT NULL,
 cust_id    serial NOT NULL,
 geo_id     serial NOT NULL,
 prod_id    serial NOT NULL,
 sales      numeric(9, 4) NOT NULL,
 quantity   int4 NOT NULL,
 discount   numeric(4, 2) NOT NULL,
 profit     numeric(21, 16) NOT NULL,
 returned   boolean NOT NULL,
 CONSTRAINT PK_1 PRIMARY KEY ( row_id ),
 CONSTRAINT FK_1 FOREIGN KEY ( ship_id ) REFERENCES shipping ( ship_id ),
 CONSTRAINT FK_2 FOREIGN KEY ( cust_id ) REFERENCES customers ( cust_id ),
 CONSTRAINT FK_3 FOREIGN KEY ( prod_id ) REFERENCES product ( prod_id ),
 CONSTRAINT FK_4 FOREIGN KEY ( geo_id ) REFERENCES geo ( geo_id ),
 CONSTRAINT FK_5 FOREIGN KEY ( order_date, ship_date ) REFERENCES calendar ( order_date, ship_date )
);

--deleting rows
truncate table dw.sales;

--insert unique values
insert into dw.sales
select
	o.row_id,
	o.order_id,
	c.order_date,
	c.ship_date,
	sh.ship_id,
	cus.cust_id,
	g.geo_id,
	p.prod_id,
	o.sales,
	o.quantity,
	o.discount,
	o.profit,
	o.returned
FROM orders o
JOIN product p ON o.product_id = p.product_id AND o.product_name = p.product_name
JOIN calendar c ON o.order_date = c.order_date AND o.ship_date = c.ship_date
JOIN shipping sh ON o.ship_mode = sh.ship_mode
JOIN customers cus ON o.customer_id = cus.customer_id
JOIN geo g ON o.country = g.country
	AND o.city = g.city
	AND o.state = g.state
	AND o.region = g.region
	AND o.postal_code = g.postal_code;

--checking
select *
from dw.sales