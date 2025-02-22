-- source 03_LittleLemonDB_with_data_sqldump.sql
-- this view is also included in the 
-- 03_LittleLemonDB_with_data_sqldump.sql

-- Create a virtual table to summarize data
-- or orders_view
CREATE VIEW orders_view AS
SELECT o.id                         AS OrderID,
       ohm.order_quantity           AS Quantity,
       ohm.order_quantity * m.price AS Cost
FROM orders o
         JOIN
     orders_has_menu ohm ON o.id = ohm.orders_id
         JOIN
     menu m ON ohm.menu_id = m.id
WHERE ohm.order_quantity > 2;


-- Test orders_view
select *
from orders_view;