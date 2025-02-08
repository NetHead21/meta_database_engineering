use littlelemondb;


alter table orders_has_menu
add column order_quantity INT NOT NULL;

select * from menu;

insert into menu (name, price)
values ("Rice", 15),
        ("Chicken Adobo", 100),
       ("Lumpia", 15),
       ("Dinuguan", 75),
       ("Kaldereta", 100),
       ("Pinakbet", 50),
       ("Halo-Halo", 150),
       ("Pork Sinigang", 100),
       ("Chicken Sinigang", 100),
       ("Chicken Inasal", 150),
       ("Pork Barbeque", 35);

1, 5
2, 2,
4, 2,
6, 1,
7, 3

select * from menu;
select * from customers;
select * from staff;


insert into bookings (booking_date_time, table_number, customers_id)
value (now(), 1, 1);

5 rice,
2 Chicken Adobe
2 Dinuguan
1 Pinakbet
3 Halo-halo

DELIMITER $$
create function get_item_price(item_id int)
returns decimal(10, 2)
DETERMINISTIC
begin
    declare item_price decimal(10, 2);
    select price into item_price
    from menu
    where id = item_id;
    return item_price;
end$$
DELIMITER ;

select get_item_price(10);

insert into orders (id, order_datetime, total_cost, status, bookings_id, staff_id)
value (NULL, now(), )