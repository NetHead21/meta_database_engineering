import mysql.connector
import secret


def get_connection():
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
