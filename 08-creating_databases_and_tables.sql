-- *** DATA TYPES ***
-- Essential to considere the type of data we may need
-- e.g., for storing phone numbers, it may be not optimal
-- to store the data as NUMERIC but rather TEXT due to
-- lack of arithmetic operations on phone numbers, issues
-- such as leading zeros, with'07' beeing different from '7'.

-- Look for bes practice online, and plan for long term storage.

-- other types include, BOOL, CHAR, NUMERIC, e.g.,
-- SMALLINT, INTEGER, DECIMAL, REAL, SERIAl, etc., TEMPORAL,
-- e.g., DATE, TIME, TIMESTAMP and INTERVAL, UUID,
-- ARRAY, JSON, HSTORE key-value pair, and special types
-- such as network address and geometric data.


-- *** PRIMARY (PK) AND FOREIGN KEYS (FK) ***
-- PK is a column or a group of columns used to identify a row uniquely
-- in the table. PK must be INTERGER-based and unique. FK is a field or
-- group of fields that identifies a row in another table. FK references
-- to the PK of the other table. The table that contains the FK is called
-- REFERENCING or CHILD TABLE. The table to which the FK references is
-- called REFERENCED or PARENT TABLE.

-- pgAdmin won't alert to FK, but we can have information via the 'constraints'
-- element from the schema > table , just below the 'columns' element.
-- Otherwise, right-click on the table, and go to 'Properties' > 'Constraints'
-- tab, and select the 'Foreign Keys' sub-tab to see the detailed relationships.
-- Finally, a third way is to look ath the 'Dependents' while selection a
-- particular column in the table.


-- *** CONSTRAINTS ***
-- Rules used to prevent invalid data from being entered into the database.
-- Column Constraints: NOT NULL, UNIQUE, PK, FK, CHECK (conditions), EXCLUSION.
-- Table Constraints: CHECK conditions on multiple columns, REFERENCES, i.e.,
-- the value stored in the column must exist in a column in another table, 
-- UNIQUE (column_list), and PRIMARY KEY (column_list).


-- *** CREATE ***
-- Full general syntax : 
-- CREATE TABLE table_name (
--    column_name TYPE column_constraints,
--    column_name TYPE column_constraints,
--    table_constraints
-- ) INHERITS existing_table_name;

-- SERIAL used for generating sequence of integers, e.g., as the PK.
-- If a row is later removed, the column with the SERIAL data type will NOT
-- adjust, marking the fact that a row was removed from the sequence.
-- Can use SMALLSERIAL, SERIAL, BIGSERIAL.

-- Before creating a new table, create a new database and load the query tool
-- from there. Beware, CREATE can be used only once (see ALTER later).
CREATE TABLE account(
	user_id SERIAL PRIMARY KEY,
	username VARCHAR(50) UNIQUE NOT NULL, -- max length of the varying character
	password VARCHAR(50) NOT NULL,
	email VARCHAR(250) UNIQUE NOT NULL,
	created_on TIMESTAMP NOT NULL,
	last_login TIMESTAMP
);

CREATE TABLE job(
	job_id SERIAL PRIMARY KEY,
	job_name VARCHAR(200) UNIQUE NOT NULL
);

CREATE TABLE account_job(
	user_id INTEGER REFERENCES account(user_id),
	-- a FK cannot be SERIAL even if the PK refered is SERIAL
	-- see also the format of REFERENCES table_name(column_name)
	job_id INTEGER REFERENCES job(job_id),
	hire_date TIMESTAMP
);
-- Look up at the constraints in the tables created.


-- *** INSERT ***
-- Allow to add in rows to a table with the following general syntax:
-- INSERT INTO table_name(column1, column2, ...)
-- VALUES -- must match up for the table, incl. constraints
-- (value1, value2, ...),
-- (value2, value2, ...), ...
-- ;

INSERT INTO account(username, password, email, created_on)
VALUES -- SERIAL (PK) columns do not need to be provided value
('Jose', 'pass', 'jose@mail.com', CURRENT_TIMESTAMP);

insert into job(job_name)
values
('Astronaut'),
('President');

insert into account_job(user_id, job_id, hire_date)
values
(1, 1, CURRENT_TIMESTAMP); -- beware the constraints for FK
-- (10, 10, CURRENT_TIMESTAMP) will generate an error

-- And here is the syntax for inserting values from another table:
-- INSERT INTO table_name(column1, column2, ...)
-- SELECT column1, column2, ...
-- FROM another_table
-- WHERE condition;


-- *** UPDATE ***
-- The UPDATE keyword allow for the changing of values of the columns in a table
UPDATE account
SET last_login = CURRENT_TIMESTAMP
WHERE last_login IS NULL;

-- We can also reset everything without WHERE condition, to all rows,
-- and also set based on another column...
UPDATE account
SET last_login = created_on;

-- ... or from other table's values (UPDATE JOIN)
UPDATE account_job
SET hire_date = account.created_on
FROM account
WHERE account_job.user_id = account.user_id;

-- Returning the <affected> rows
UPDATE account
SET last_login = CURRENT_TIMESTAMP
RETURNING email, created_on, last_login;


-- *** DELETE ***
-- DELETE FROM table_name
-- to remove rows from a table based on conditions ...
delete from job
where job_name in ('cowgirl', 'cowboy')
returning *;

-- ... or on the presence in other tables (DELETE JOIN) using the syntax
-- DELETE FROM table_name WHERE row_id = 1;
-- USING from_item
-- WHERE condition;

-- We can delete all rows from a table
DELETE FROM account_job;


-- *** ALTER TABLE ***
-- The clause allows for changes to an existing table <structure>, e.g.,
-- * ADD, DROP, renaming columns
-- * changing a column's data type
-- * SET/DROP default values for a column
-- * ADD check constraints
-- * renaming table
-- The general syntax is `ALTER TABLE table_name action`
-- See documentation for a comprehensive list of action items.

create table information(
	info_id serial primary key,
	title varchar(500) not null,
	person varchar(50) not null unique
);

alter table information
rename to new_info; -- rename the entire table

alter table new_info
rename column person to people; -- rename one column

insert into new_info(title)
values ('some new title'); -- generates an error as not null constraint

alter table new_info
alter column people drop not null; -- modify constraint
-- so that the previous query would work


-- *** DROP ***
-- Allows for the complete removal of a column in a table.
-- Automatically removes indexes and constraints involving the column,
-- but not the columns used in views, triggers procedures --> CASCADE.

alter table new_info
drop column people;

-- If the column doesn't exist, generate an error. Can use:
alter table new_info
drop column if exists people;  -- show a notice

-- drop multiple tables
DROP TABLE students, teachers;

-- *** CHECK ***
-- Customized constraints that adhere to certain condition.
create table employees(
	emp_id serial primary key,
	first_name varchar(50) not null,
	last_name varchar(50) not null,
	-- specific condition:
	birthdate date check (birthdate > '1900-01-01'),
	-- constraint based on another column:
	hire_date date check (hire_date > birthdate)
);
-- beware, the serial take account of the failure in inserting
-- rows that violated check constraint!