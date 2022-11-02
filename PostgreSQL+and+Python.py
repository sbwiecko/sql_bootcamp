
# # Using PostgreSQL in Python (with Psycopg2)
# 
# ## Psycopg2
# 
# A library that allows Python to connect to an existing PostgreSQL database to utilize SQL functionality.
# 
# ### Documentation
# 
# http://initd.org/psycopg/docs/install.html
# 

# After installing with pip install psycopg2
import psycopg2 as pg2

# %%
# Create a connection with PostgreSQL
# 'password' is whatever password you set, we set password in the install video
import db_config # usr and pass are imported for there

conn = pg2.connect(
    database='dvdrental',
    user=db_config.usr,
    password=db_config.pwd)


# %%
# Establish connection and start cursor to be ready to query
cur = conn.cursor()

# %%
# # Pass in a PostgreSQL query as a string
cur.execute("SELECT * FROM payment")

# %%
# Return a tuple of the first row as Python objects
cur.fetchone()

# %%
# Return N number of rows
cur.fetchmany(10)
# returns a list of tuple items

# %%
# Return All rows at once
cur.fetchall()


# %%
# To save and index results, assign it to a variable
data = cur.fetchmany(10)

# **Inserting Information**
print(data[0][4])

# %%
query1 = '''
CREATE TABLE new_table (
userid integer,
tmstmp timestamp,
type varchar(10)
);
'''

# %%
cur.execute(query1)


# %%
# commit the changes to the database
conn.commit()


# %%
# Don't forget to close the connection!
# killing the kernel or shutting down juptyer will also close it
conn.close()


# %%
# checking for the presence of the new table on the command line
# ```
# psql -U postgres
# \c dvdrental -- connect to the database
# \d -- lists all relations and tables
# select * from new_table;
# drop table new_table;