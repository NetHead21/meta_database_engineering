
# Exercise: Create SQL queries to check available bookings based on user input

DELIMITER //

CREATE FUNCTION check_booking(booking_date DATE, tb_number INT)
    RETURNS BOOLEAN
    DETERMINISTIC
BEGIN
DECLARE booking_exists BOOLEAN;

-- Check if the booking exists for the given date and table number
SET booking_exists = EXISTS(SELECT 1
                                FROM bookings
                                WHERE DATE(booking_date_time) = booking_date
                                  AND table_number = tb_number);

RETURN booking_exists;
END //

DELIMITER ;

select check_booking('2025-02-11 13:00:00', 3);
