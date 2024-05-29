/** Create Datebase **/
CREATE DATABASE zomato_data;
use zomato_data;

/**Create table  order_details **/
create table order_details(
   order_details_id int,
   order_id int ,
   pizza_id CHAR,
   quantity int
);
/** Create table  orders **/
create table orders(
    order_id int,
    date char(20),
    time char (20)
);
/** Create table pizza  **/

CREATE table pizza(
    pizza_id CHAR(20),
    pizza_type_id CHAR(20),
    size CHAR(1),
    price int
);

/**Create table pizza_types **/
CREATE table pizza_types(
    pizza_type_id CHAR(20),
    name CHAR(50),
    category CHAR(20),
    ingredients CHAR(150)
);

/** Create a path where we past all data and Tables **/
show VARIABLES LIKE 'secure_file_priv';

/**import Data Into order table from orders.csv **/
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/orders.csv'
into table orders
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines TERMINATED by '\n'
ignore 1 rows;

/**import Data Into order_details table from order_details.csv**/
use zomato_data;
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/order_details.csv'
into table order_details
FIELDS TERMINATED by ','
ENCLOSED by '"'
lines TERMINATED by '\n'
ignore 1 rows;

/**import Data Into pizza_types table from /pizza_types.csv'**/

load data INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizza_types.csv'
into table pizza_types
FIELDS TERMINATED BY ','
ENCLOSED by '"'
LINES TERMINATED BY '\n'
IGNORE 1 rows;

/**import Data Into pizza  table from /pizzas.csv'**/
load data infile 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/pizzas.csv'
into table pizza
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
lines TERMINATED by '\n'
IGNORE 1 rows;
alter table pizza 
MODIFY size char(4);


/** Add  a blank Column into orders table and convert string to date format into blank column
 after that drop original  column**/
 
alter table orders
 add COLUMN date_1 DATE;
 alter table orders 
 add COLUMN time_1 time;
 update orders
 set date_1 = STR_TO_DATE(date ,'%d-%m-%Y');

 
alter table orders
drop column date;
ALTER table orders 
CHANGE COLUMN date_1 date date;
alter table orders
MODIFY time TIME;






/**Retrieve the total number of orders placed.**/
select count(order_id) from orders;

/**Calculate the total revenue generated from pizza sales.**/
select * from order_details;
select * from pizza;

select sum( quantity * price)
from order_details
inner join pizza
on  order_details.pizza_id = pizza.pizza_id;

/**Identify the highest-priced pizza.**/

select *  from pizza
order by price desc
LIMIT 1;


/**Identify the most common pizza size ordered.**/

SELECT size, count(size) 
from order_details inner join 
pizza on order_details.pizza_id = pizza.pizza_id
group by size;


/** List the top 5 most ordered pizza types along with their quantities. **/

select pizza_type_id,count(pizza_type_id) from( 
select name,pizza_id,pizza.pizza_type_id
from pizza_types inner join 
pizza
on  pizza_types.pizza_type_id = pizza.pizza_type_id) a 
inner join order_details
on a.pizza_id = order_details.pizza_id
group by pizza_type_id;


/**Find the total quantity of each pizza category ordered (this will help us to
 understand the category which customers prefer the most).**/
 
 select category,count(category) from (
 select pizza_id,pizza_types.pizza_type_id, category from
 pizza_types inner join pizza
 ON pizza_types.pizza_type_id = pizza.pizza_type_id ) a 
 inner join order_details
on a.pizza_id = order_details.pizza_id
group by category;


/**Determine the distribution of orders by hour of the day (at which time the orders are maximum 
(for inventory management and resource allocation)**/

 select HOUR(time ) as hour_num ,count(order_details.order_id ) as order_num from orders 
 inner join order_details
 on orders.order_id = order_details.order_id
 group by hour_num
 order by order_num desc;


/**Determine the top 3 most ordered pizza types based on revenue 
(let's see the revenue wise pizza orders to understand from sales perspective which pizza is the best selling)**/


select name,sum(price) as total_amt from 
(select name,pizza_id,pizza_types.pizza_type_id,price from pizza 
inner join pizza_types
on pizza.pizza_type_id = pizza_types.pizza_type_id) a 
inner join order_details
on a.pizza_id = order_details.pizza_id
group by name
ORDER BY total_amt desc
limit 3;







