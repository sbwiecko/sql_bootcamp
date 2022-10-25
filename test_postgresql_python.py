# %%
import db_config

import psycopg2

import pandas as pd


# %%
# setting up a database connection
conn = psycopg2.connect(
    host="localhost",
    database="dvdrental",
    user=db_config.usr,
    password=db_config.pwd,
)

cursor=conn.cursor()


# %%
# getting some data
query="""
select *
from customer
where first_name like 'A%'
and last_name not like 'B%'
order by last_name;
"""


cursor.execute(query)
result = cursor.fetchall()
print(result)



# %%
# save the results in a dataframe
df = pd.read_sql(query, conn)

print(df)


# %%
# close the connection
cursor.close()
conn.close()


# %%
