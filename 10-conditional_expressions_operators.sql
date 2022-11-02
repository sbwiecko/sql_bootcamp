/*** CASE ***
-------------
use the CASE statement to only execute SQL code when certain conditions are met.
This is very similar to IF/ELSE statements in other programming languages.
There are two main ways to use a CASE statement, either a "general CASE" or a "CASE expression".
General CASE syntax:*/
select customer_id,
case
	-- general CASE more flexible with the conditions tested
	when (customer_id <= 100) then 'Premium'
	when (customer_id between 100 and 200) then 'Plus'
	else 'Normal'
end as customer_class
from customer;

-- CASE expression syntax:
select customer_id,
case customer_id -- first evaluates an expression
-- then compares the result with each value in the WHEN clauses sequentially
	-- CASE expression less flexible, checking only for equality
	when 2 then 'Winner' -- no comma!
	when 5 then 'Second place'
	else 'Normal'
end as raffle_results
from customer;


/*performing operations on the CASE returns
e.g., couting in a given categroy
(could do the same using GROUP BY)*/
select
sum(
case rental_rate
	when .99 then 1
	else 0
end) as number_of_bargains,
-- can continue for other categories (different from GROUP BY)
sum( -- another column
case rental_rate
	when 2.99 then 1
	else 0
end) as regular,
sum( -- another column
case rental_rate
	when 4.99 then 1
	else 0
end) as premium
-- appreciate the column format for each count category
from film;


/*CASE -- Challenge Task
We want to know and compare the various amounts of films
we have per movie rating using CASE and dvdrental database*/
select
sum(
	case rating
		when 'R' then 1 else 0
	end
) as r,
sum(
	case rating
		when 'PG' then 1 else 0
	end
) as pg,
sum(
	case rating
		when 'PG-13' then 1 else 0
	end
) as pg13
from film;


/*** COALESCE ***
-----------------
The COALESCE function accepts an unlimited number of arguments.
It returns the first argument that is not null. If all arguments are null,
the COALESCE function will return null.*/
select coalesce(NULL, 2, 3); -- returns 2

-- The COALESCE function becomes useful when querying a table that
-- contains null values and substituting it with another value. 
select item,
-- if 'discount' is NULL, the operation fails and returns NULL
-- using COALESCE, NULL is substitutes with 0, i.e., ~ <fillna> function
(price - COALESCE(discount, 0)) as final
from table;


/*** CAST ***
-------------
Converts from one data type into another, though not every instance of
a data type can be CAST to another data type but must be reasonable.*/
select cast('5' as integer);

select '5'::integer -- specific operator to PostgreSQL

-- number of digits in the numbers casted as string
select char_length(cast(inventory_id as varchar)) from rental;


/*** NULLIF ***
---------------
The NULLIF function takes in 2 inputs and returns NULL if both are equal,
otherwise it returns the first argument passed. This becomes very useful
in cases where a NULL value would cause an error or unwanted result.*/

select nullif(10, 10); -- returns NULL
select nullif(10, 12); -- returns 10

-- Example of the calculation of a ratio when the denominator equals zero.
-- Connect to the "learning" database and create a new toy table.
create table depts(
	first_name varchar(50),
	department varchar(50)
);

insert into depts(
	first_name,
	department
)
values
('Vinton', 'A'),
('Lauren', 'A'),
('Claire', 'B');

select
sum(case department when 'A' then 1 else 0 end)
/
sum(case department when 'B' then 1 else 0 end)
as department_ratio
from depts;
-- returns 2 for a ratio of 2:1

delete from depts
where department = 'B';
-- now the same division raises a 'division by zero' error

select
sum(case department when 'A' then 1 else 0 end)
/
nullif(sum(case department when 'B' then 1 else 0 end),0)
-- if SUM of CASE equals 0, NULLIF returns NULL
-- so that the division operation returns NULL and not an error
as department_ratio
from depts;


/*** VIEWS ***
--------------
A view is a database object that is of a stored query. A view
can be accessed as a virtual table in PostgreSQL. Notice that
a view does not store data physically, it simply stores the
query. You can also update and alter existing views.*/

-- creating a view, see also the views and its code in pgAdmin
-- under schemas > public > Views
create view custmoer_info as
select first_name, last_name, address
from customer
inner join address
on customer.address_id = address.address_id;

-- renaming the view
alter view custmoer_info rename to customer_info;

-- removing the view
drop view if exists customer_info;

-- updating an existing view
create or replace view customer_info as
select first_name, last_name, address, district
from customer
inner join address
on customer.address_id = address.address_id;


/*** import and export
----------------------
Not every outside data file will work, variations in formatting,
macros, data types, etc. may prevent the Import command from
reading the file, at which point, you must edit your file to be
compatible with SQL. Details of compatible file types: 
postgresql.org/docs/12/sql-copy.html
You MUST provide the 100% correct file path to your outside file.
The Import command DOES NOT create a table for you, it assumes
a table is already created. Currently, there is no automated way
within pgAdmin to create a table directly from a .csv file.
There are some proposed custom functions to create table directly from csv:
- https://stackoverflow.com/questions/21018256/can-i-automatically-create-a-table-in-postgresql-from-a-csv-file-with-headers
*/

-- create a csv file with A, B anc C columns and 3 rows, and
-- save it as simple_table.csv, and copy its full path
create table simple( -- inside `learning` database
	a integer,
	b integer,
	c integer);

/*from the tree structure, click right on the table created
and select `Import/Export Data`. Possible to remove unused
columns, if header, delimiter (could be semi-colon on French computer),
quote and escape value. Similar procedure for exporting*/

select * from simple;