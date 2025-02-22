import mysql.connector
import secret


def get_connection():
    """
    Establishes and returns a connection to the LittleLemonDB database.

    This function uses the mysql.connector library to connect to the MySQL database
    using the credentials and database information provided in the secret module.

    Note: create secrets.py file in the same directory as this file and add the following line:
    PASSWORD = "your_mysql_password"

    Returns:
        mysql.connector.connection.MySQLConnection: A MySQL connection object.

    Raises:
        mysql.connector.Error: If there is an error connecting to the database.
    """
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password=secret.PASSWORD,
        database="littlelemondb",
    )

    return conn


if __name__ == "__main__":
    conn = get_connection()
    cursor = conn.cursor()

    # Task 2 - Query to show all tables in the LittleLemonDB
    print("Tables in LittleLemonDB:")
    show_tables_query = "SHOW TABLES;"
    cursor.execute(show_tables_query)
    for record in cursor.fetchall():
        print(record)
    print()

    # Task 3 - Query with table JOIN
    print("Customers who have spent more than $60 on orders:")
    customer_total_order_query = """
    select
        c.name,
        c.contact_number,
        o.total_cost
    from customers c
    join bookings b on c.id = b.customers_id
    join orders o on b.id = o.bookings_id
    where total_cost >= 60;"""
    cursor.execute(customer_total_order_query)
    for record in cursor.fetchall():
        print(record)
    cursor.close()
