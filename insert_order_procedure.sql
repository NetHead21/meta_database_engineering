-- Create the stored procedure
DELIMITER //

CREATE PROCEDURE insert_orders(
    IN items JSON,
    IN bookings_id INT,
    IN staff_id INT,
    IN order_status ENUM ('Place', 'Delivered', 'Canceled')
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
    WHILE i < n
    DO
        SET item_id = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', i, '].item_id')));
    SET quantity = JSON_UNQUOTE(JSON_EXTRACT(items, CONCAT('$[', i, '].quantity')));
    SET total_price = quantity * get_item_price(item_id);
    SET order_total = order_total + total_price;
    SET i = i + 1;
    END WHILE;

    -- Prepare the insert statement for the orders table
    SET @insert_order_sql =
            'INSERT INTO orders (order_datetime, total_cost, status, bookings_id, staff_id) VALUES (NOW(), ?, ?, ?, ?)';
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
    WHILE i < n
    DO
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
  {
    "item_id": 1,
    "quantity": 5
  },
  {
    "item_id": 2,
    "quantity": 2
  },
  {
    "item_id": 4,
    "quantity": 2
  },
  {
    "item_id": 6,
    "quantity": 1
  },
  {
    "item_id": 7,
    "quantity": 3
  }
]', 1, 1, 'Place');

    CALL insert_orders('[
  {
    "item_id": 1,
    "quantity": 10
  },
  {
    "item_id": 2,
    "quantity": 5
  },
  {
    "item_id": 4,
    "quantity": 5
  },
  {
    "item_id": 6,
    "quantity": 5
  },
  {
    "item_id": 7,
    "quantity": 10
  }
]', 2, 1, 'Place');
