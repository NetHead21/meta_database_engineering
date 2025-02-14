
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


select *
from orders_view;