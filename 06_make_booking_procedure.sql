-- source 03_LittleLemonDB_with_data_sqldump.sql
-- this stored procedure is also included in the 
-- 03_LittleLemonDB_with_data_sqldump.sql


DELIMITER //

CREATE PROCEDURE make_booking(IN v_booking_date_time DATETIME, IN v_table_number INT, IN v_customer_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR 1062
    BEGIN
        SELECT 'Booking failed: Duplicate entry or constraint violation' AS message;
    END;

    START TRANSACTION;
    -- Prepare the insert statement for the bookings table
    SET @v_booking_date_time = v_booking_date_time;
    SET @v_table_number = v_table_number;
    SET @v_customer_id = v_customer_id;

    SET @insert_booking_sql = 'INSERT INTO bookings (booking_date_time, table_number, customers_id) VALUES (?, ?, ?)';
    PREPARE stmt_booking FROM @insert_booking_sql;
    EXECUTE stmt_booking USING @v_booking_date_time, @v_table_number, @v_customer_id;

    SELECT 'Booking was successful' AS message;

    DEALLOCATE PREPARE stmt_booking;
    COMMIT;

END //

DELIMITER ;


-- test make_booking() procedure
call make_booking('2025-02-17 12:00:00', 6, 6);

