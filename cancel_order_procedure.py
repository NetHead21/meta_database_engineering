
-- Task 3 - CancelOrder procedure
DELIMITER //

CREATE PROCEDURE cancel_order(IN order_id INT)
BEGIN
    DECLARE order_status ENUM ('Place', 'Delivered', 'Canceled');

    -- Get the current status of the order
    SELECT status
    INTO order_status
    FROM orders
    WHERE id = order_id;

    -- Check if the order is in the "Placed" status
    IF order_status = 'Place' THEN
        -- Update the order status to "Canceled"
        UPDATE orders
        SET status = 'Canceled'
        WHERE id = order_id;
    ELSEIF order_status = 'Delivered' THEN
        -- Raise an error if the order has already been delivered
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order cannot be canceled as it has already been delivered';
    ELSE
        -- Raise an error if the order is not found or already canceled
        SIGNAL SQLSTATE '45000'
            SET MESSAGE_TEXT = 'Order not found or already canceled';
    END IF;
END //

DELIMITER ;

CALL cancel_order(1);