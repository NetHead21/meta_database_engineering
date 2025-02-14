
-- -----------------------------------------------------
-- Task 1 - get_max_order stored procedure
DELIMITER //

CREATE PROCEDURE get_max_order()
BEGIN
    select max(order_quantity) as "Max Quantity in Order" from orders_has_menu;
END //

DELIMITER ;

CALL get_max_order();