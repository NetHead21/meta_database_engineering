
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