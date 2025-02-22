-- source 03_LittleLemonDB_with_data_sqldump.sql
-- this view is also included in the 
-- 03_LittleLemonDB_with_data_sqldump.sql

-- Create a virtual table to summarize data
CREATE VIEW customers_order_view AS
SELECT c.id   AS customer_id,
       c.name AS customer_name,
       b.id   AS booking_id,
       b.booking_date_time,
       b.table_number,
       s.name AS staff_name,
       o.id   AS order_id,
       o.order_datetime,
       o.total_cost,
       o.status,
       m.name AS menu_item_name,
       ohm.order_quantity
FROM customers c
         JOIN
     bookings b ON c.id = b.customers_id
         JOIN
     orders o ON b.id = o.bookings_id
         JOIN
     staff s ON o.staff_id = s.id
         JOIN
     orders_has_menu ohm ON o.id = ohm.orders_id
         JOIN
     menu m ON ohm.menu_id = m.id;



-- Test the customers_order_view
select distinct customer_id,
                customer_name,
                booking_id,
                booking_date_time,
                table_number,
                staff_name,
                total_cost,
                status
from customers_order_view;


select *
from customers_order_view;

select menu_item_name, order_quantity
from customers_order_view
where order_quantity >= 5;