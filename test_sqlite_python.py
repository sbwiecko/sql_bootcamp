# %%
import sqlite3

import pandas as pd

# %%
# setting up a database connection
conn = sqlite3.connect('database.db') # it creates the database if doesn't exist

# SQL code inside Python
cursor = conn.cursor()
cursor.execute("CREATE TABLE test (id int, num int);")
conn.commit()


# %%
# continuying with some tasks to save on file
cursor.execute("INSERT INTO test VALUES (1, 100), (2, 200), (3, 500);")
conn.commit()


# %%
# getting the data
cursor.execute("SELECT * FROM test LIMIT 2;")
result = cursor.fetchall()
print(result)

# close the connection
cursor.close()
conn.close()


# %%
# save the results in a dataframe
conn = sqlite3.connect('database.db')
cursor = conn.cursor()

query = "SELECT * FROM test;"

df = pd.read_sql(query, conn)

print(df)

cursor.close()
conn.close()
# %%
