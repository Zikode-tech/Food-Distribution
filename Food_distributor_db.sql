-- DATABASE FOR FOOD DISTRIBUTOR --

create database if not exists food_distributor_db;
use food_distributor_db;

DROP TABLE IF EXISTS order_items;
DROP TABLE IF EXISTS orders;
DROP TABLE IF EXISTS products;
DROP TABLE IF EXISTS customers;
DROP TABLE IF EXISTS suppliers;
DROP TABLE IF EXISTS inventory;

create table inventory (
inventory_station_id int primary key,
warehouse_stock text,
expiry_date date,
region text,
has_cold_storage text
);

INSERT INTO inventory (inventory_station_id, warehouse_stock, region, has_cold_storage) VALUES
(1, 'Chicken Breast, Tomatoes, Rice 25kg, Frozen Fries', 'South', 'Yes');

create table suppliers (
supplier_id int primary key auto_increment,
supplier_name varchar(50),
supplier_type text,
payment_terms_days int
);

INSERT INTO suppliers (supplier_name, supplier_type, payment_terms_days) VALUES
('Cape Farms', 'Fresh Produce', 7),
('FrozenCo', 'Frozen Foods', 14),
('BulkGrains Ltd', 'Dry Goods', 14);

create table products (
product_id int auto_increment primary key,
product_name varchar(50),
category text,
shelf_life_days int,
cost_price decimal,
selling_price decimal,
inventory_station_id int,
foreign key (inventory_station_id) references inventory (inventory_station_id)
);

INSERT INTO products (inventory_station_id, product_name, category, shelf_life_days, cost_price, selling_price) VALUES
(1,'Chicken Breast', 'Frozen', 180, 45.00, 65.00),
(1,'Tomatoes', 'Fresh', 7, 6.00, 10.00),
(1,'Rice 25kg', 'Dry', 365, 320.00, 400.00),
(1,'Frozen Fries', 'Frozen', 240, 55.00, 80.00);

create table customers (
customer_id int auto_increment primary key,
customer_name varchar(50),
customer_type text,
region text,
payment_terms_days int
);

INSERT INTO customers (customer_name, customer_type, region, payment_terms_days) VALUES
('Ocean Grill', 'Restaurant', 'North', 30),
('Green Basket', 'Grocery', 'South', 15),
('Urban Dine', 'Restaurant', 'East', 30),
('FreshMart', 'Grocery', 'West', 15);

create table orders (
order_id int auto_increment primary key,
order_date date,
delivery_date date,
region text,
inventory_station_id int,
customer_id int,
foreign key (customer_id) references customers (customer_id),
foreign key (inventory_station_id) references inventory (inventory_station_id)
);

INSERT INTO orders (order_date, delivery_date, inventory_station_id, customer_id) VALUES
('2026-02-01', '2026-02-02', 1, 1),
('2026-02-03', '2026-02-04', 1, 2),
('2026-02-04', '2026-02-05', 1, 3);

create table order_items (
order_item_id int auto_increment primary key,
quantity int,
order_id int,
product_id int,
foreign key (order_id) references orders(order_id),
foreign key (product_id) references products(product_id)
);

INSERT INTO order_items (quantity, order_id, product_id) VALUES
(50, 1, 1),
(30, 2, 2),
(20, 3, 3);

select customer_id, customer_name, customer_type, region
from customers;

select product_name, sum(selling_price - cost_price) as price_difference
from products
group by product_name;

select sum(p.selling_price * o.quantity) as total_price
from products p
join order_items o on p.product_id = o.product_id;

SELECT 
    p.product_id,
    o.order_id,
    p.product_name
FROM products p
LEFT JOIN order_items oi 
    ON p.product_id = oi.product_id
LEFT JOIN orders o 
    ON oi.order_id = o.order_id
LEFT JOIN inventory i 
    ON p.inventory_station_id = i.inventory_station_id;

select product_id, product_name, shelf_life_days
from products;

select sum(delivery_date - order_date) as days_of_delivery
from orders;

select *,
case
when payment_terms_days > 15 and customer_type = 'Grocery' then 'Interest rate increase'
when payment_terms_days >= 30 and customer_type = 'Grocery' then 'No supply provide'
else 'Still in debt'
end as Grocery_result
from customers;

select *,
case
when payment_terms_days > 30 and customer_type = 'Restaurant' then 'Interest rate increase'
when payment_terms_days >= 40 and customer_type = 'Restaurant' then 'No supply provide'
else 'Still in debt'
end as Restaurant_result
from customers;