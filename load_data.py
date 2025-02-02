import mysql.connector
from faker import Faker
import secret

def insert_record():
    conn = mysql.connector.connect(
        host="localhost",
        user="root",
        password=secret.PASSWORD,,
        database="littlelemondb",