import mysql.connector
from faker import Faker
import random
import secret

roles: list[tuple[str, int]] = [
    ("Cashier", 18_000),
    ("Chef", 30_000),
    ("Diswasher", 10_000),
    ("Manager", 35_000),
    ("Waiter", 15_000),
]


def insert_record(data: tuple) -> None:
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password=secret.PASSWORD,
        database="littlelemondb",
    )

    cursor = conn.cursor()
    query = (
        "INSERT INTO staff (name, contact_number, role, salary) VALUES (%s, %s, %s, %s)"
    )
    try:
        cursor.execute(query, data)
        conn.commit()
    except mysql.connector.Error as e:
        print(e)
        conn.rollback()
    finally:
        cursor.close()
        conn.close()


def generate_fake_data(fake: object, roles: list) -> tuple[str, ...]:
    name = fake.name()
    phone = fake.phone_number()
    random_role = random.choice(roles)
    role = random_role[0]
    salary = random_role[1]
    return name, phone, role, salary


if __name__ == "__main__":
    for _ in range(20):
        fake = Faker()
        insert_record(generate_fake_data(fake, roles))
