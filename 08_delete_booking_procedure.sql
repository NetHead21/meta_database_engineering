-- source 03_LittleLemonDB_with_data_sqldump.sql
-- this stored procedure is also included in the 
-- 03_LittleLemonDB_with_data_sqldump.sql

DELIMITER //

CREATE PROCEDURE delete_booking(IN v_booking_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Rollback the transaction if an error occurs
        ROLLBACK;
        -- Return the failure message
        SELECT 'Deletion failed' AS message;
    END;

    START TRANSACTION;

    -- Check if the booking exists
    IF EXISTS (SELECT * FROM bookings WHERE id = v_booking_id) THEN
        -- Prepare the update statement for the bookings table
        SET @v_booking_id = v_booking_id;

        SET @delete_booking_sql = 'DELETE FROM bookings WHERE id = ?';
        PREPARE stmt_booking FROM @delete_booking_sql;
        EXECUTE stmt_booking USING @v_booking_id;
        DEALLOCATE PREPARE stmt_booking;

        -- Commit the transaction
        COMMIT;

        -- Return the success message
        SELECT CONCAT('Booking ', @v_booking_id, ' was deleted successfully.') AS message;
    ELSE
        -- Rollback the transaction if the booking does not exist
        ROLLBACK;
        -- Return the failure message
        SELECT CONCAT('Booking with booking id ', v_booking_id, ' not found.') AS message;
    END IF;
END //

DELIMITER ;


-- test delete_booking stored procedure
call delete_booking(14);
