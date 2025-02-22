
-- Task 3 Query with table JOIN
select
    c.name,
    c.contact_number,
    o.total_cost
from customers c
         join bookings b on c.id = b.customers_id
         join orders o on b.id = o.bookings_id
where total_cost >= 60;