-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema littlelemondb
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `littlelemondb` DEFAULT CHARACTER SET utf8 ;
USE `littlelemondb` ;

-- -----------------------------------------------------
-- Table `littlelemondb`.`menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`menu` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `price` DECIMAL(10,2) NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `littlelemondb`.`customers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`customers` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `contact_number` VARCHAR(20) NOT NULL,
  `member_since` TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `littlelemondb`.`bookings`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`bookings` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `booking_date_time` DATETIME NOT NULL,
  `table_number` INT NOT NULL,
  `customers_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_bookings_customers1_idx` (`customers_id` ASC) VISIBLE,
  CONSTRAINT `fk_bookings_customers1`
    FOREIGN KEY (`customers_id`)
    REFERENCES `littlelemondb`.`customers` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `littlelemondb`.`staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`staff` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `contact_number` VARCHAR(20) NOT NULL,
  `role` ENUM('Cashier', 'Chef', 'Dishwasher', 'Host', 'Manager', 'Waiter') NOT NULL,
  `salary` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`id`));


-- -----------------------------------------------------
-- Table `littlelemondb`.`orders`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`orders` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `order_datetime` DATETIME NOT NULL DEFAULT NOW(),
  `total_cost` DECIMAL(10,2) NOT NULL,
  `status` ENUM('Place', 'Delivered', 'Canceled') NOT NULL,
  `bookings_id` INT NOT NULL,
  `staff_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_orders_bookings1_idx` (`bookings_id` ASC) VISIBLE,
  INDEX `fk_orders_staff1_idx` (`staff_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_bookings1`
    FOREIGN KEY (`bookings_id`)
    REFERENCES `littlelemondb`.`bookings` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_staff1`
    FOREIGN KEY (`staff_id`)
    REFERENCES `littlelemondb`.`staff` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


-- -----------------------------------------------------
-- Table `littlelemondb`.`orders_has_menu`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `littlelemondb`.`orders_has_menu` (
  `orders_id` INT NOT NULL,
  `menu_id` INT NOT NULL,
  `order_quantity` INT NOT NULL,
  PRIMARY KEY (`orders_id`, `menu_id`),
  INDEX `fk_orders_has_menu_menu1_idx` (`menu_id` ASC) VISIBLE,
  INDEX `fk_orders_has_menu_orders1_idx` (`orders_id` ASC) VISIBLE,
  CONSTRAINT `fk_orders_has_menu_orders1`
    FOREIGN KEY (`orders_id`)
    REFERENCES `littlelemondb`.`orders` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_orders_has_menu_menu1`
    FOREIGN KEY (`menu_id`)
    REFERENCES `littlelemondb`.`menu` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;








-----------------------------------------

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


select * from menu;
select * from customers;
select * from staff;


insert into bookings (booking_date_time, table_number, customers_id)
value (now(), 2, 2);

select * from bookings;

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

-- Create the stored procedure
DELIMITER //

CREATE PROCEDURE insert_orders(
    IN items JSON,
    IN bookings_id INT,
    IN staff_id INT,
    IN order_status ENUM('Place', 'Delivered', 'Canceled')
)
BEGIN
    DECLARE item_id INT;
    DECLARE quantity INT;
    DECLARE total_price DECIMAL(10, 2);
    DECLARE i INT DEFAULT 0;
    DECLARE n INT;
    DECLARE order_total DECIMAL(10, 2) DEFAULT 0;
    DECLARE new_order_id INT;

    SET n = JSON_LENGTH(items);

    -- Calculate the total cost of the order
    WHILE i < n DO
            SET item_id = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', i, '].item_id')));
            SET quantity = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', i, '].quantity')));
            SET total_price = quantity * (SELECT price FROM menu WHERE id = item_id);
            SET order_total = order_total + total_price;
            SET i = i + 1;
        END WHILE;

    -- Prepare the insert statement for the orders table
    SET @insert_order_sql = 'INSERT INTO orders (order_datetime, total_cost, status, bookings_id, staff_id) VALUES (NOW(), ?, ?, ?, ?)';
    PREPARE stmt_order FROM @insert_order_sql;
    EXECUTE stmt_order USING @order_total, order_status, bookings_id, staff_id;
    DEALLOCATE PREPARE stmt_order;

    -- Get the last inserted order ID
    SET new_order_id = LAST_INSERT_ID();

    -- Reset the loop counter
    SET i = 0;

    -- Prepare the insert statement for the orders_has_menu table
    SET @insert_order_item_sql = 'INSERT INTO orders_has_menu (orders_id, menu_id, order_quantity) VALUES (?, ?, ?)';
    PREPARE stmt_order_item FROM @insert_order_item_sql;

    -- Insert the items into the orders_has_menu table
    WHILE i < n DO
            SET item_id = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', i, '].item_id')));
            SET quantity = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', i, '].quantity')));
            EXECUTE stmt_order_item USING new_order_id, item_id, quantity;
            SET i = i + 1;
        END WHILE;

    DEALLOCATE PREPARE stmt_order_item;
END //

DELIMITER ;

-- Call the stored procedure
CALL insert_orders('[
    {"item_id": 1, "quantity": 5},
    {"item_id": 2, "quantity": 2},
    {"item_id": 4, "quantity": 2},
    {"item_id": 6, "quantity": 1},
    {"item_id": 7, "quantity": 3}
]', 1, 1, 'Place');

CALL insert_orders('[
  {"item_id": 1, "quantity": 10},
  {"item_id": 2, "quantity": 5},
  {"item_id": 4, "quantity": 5},
  {"item_id": 6, "quantity": 5},
  {"item_id": 7, "quantity": 10}
]', 2, 1, 'Place');


select * from orders;
select * from orders_has_menu;

CREATE VIEW orders_view AS
SELECT
    o.id AS OrderID,
    ohm.order_quantity AS Quantity,
    ohm.order_quantity * m.price AS Cost
FROM
    orders o
        JOIN
    orders_has_menu ohm ON o.id = ohm.orders_id
        JOIN
    menu m ON ohm.menu_id = m.id
WHERE
    ohm.order_quantity > 2;


select * from orders_view;



CREATE VIEW customers_order_view AS
SELECT
    c.id AS customer_id,
    c.name AS customer_name,
    b.id AS booking_id,
    b.booking_date_time,
    b.table_number,
    s.name AS staff_name,
    o.id AS order_id,
    o.order_datetime,
    o.total_cost,
    o.status,
    m.name AS menu_item_name,
    ohm.order_quantity
FROM
    customers c
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


select
    distinct
    customer_id,
    customer_name,
    booking_id,
    booking_date_time,
    table_number,
    staff_name,
    total_cost,
    status
from customers_order_view;


select * from customers_order_view;

select menu_item_name, order_quantity
from customers_order_view
where order_quantity >= 5;