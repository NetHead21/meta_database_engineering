
DELIMITER //

CREATE PROCEDURE update_booking(IN v_booking_id INT, IN v_booking_date_time DATETIME)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction if an error occurs
        ROLLBACK;
        -- Return the failure message
        SELECT 'Booking update failed' AS message;
    END;

    START TRANSACTION;

    -- Check if the booking exists
    IF EXISTS (SELECT * FROM bookings WHERE id = v_booking_id) THEN
        -- Prepare the update statement for the bookings table
        SET @v_booking_id = v_booking_id;
        SET @v_booking_date_time = v_booking_date_time;

        SET @update_booking_sql = 'UPDATE bookings SET booking_date_time = ? WHERE id = ?';
        PREPARE stmt_booking FROM @update_booking_sql;
        EXECUTE stmt_booking USING @v_booking_date_time, @v_booking_id;
        DEALLOCATE PREPARE stmt_booking;

        -- Commit the transaction
        COMMIT;

        -- Return the success message
        SELECT 'Booking update was successful' AS message;
    ELSE
        -- Rollback the transaction if the booking does not exist
        ROLLBACK;
        -- Return the failure message
        SELECT CONCAT('Booking with booking id ', v_booking_id, ' not found.') AS message;
    END IF;
END //

DELIMITER ;

call update_booking(25, '2025-02-20 12:00:00');

