DELIMITER $$
create function get_item_price(item_id int)
    returns decimal(10, 2)
    DETERMINISTIC
begin
    declare item_price decimal(10, 2);
    select price
    into item_price
    from menu
    where id = item_id;
    return item_price;
end$$
DELIMITER ;

select get_item_price(10);