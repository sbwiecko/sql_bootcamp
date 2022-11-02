/***********************
** ASSESSMENT TEST 3 **
***********************

Create a new database called "School" this database
-> created the new database in pgAdmin using default settings.
Load the query tool from the new database.

should have two tables: teachers and students:
1. The students table should have columns for student_id, first_name,
last_name, homeroom_number, phone, email, and graduation year.
2. The teachers table should have columns for teacher_id, first_name,
last_name, homeroom_number, department, email, and phone.

The constraints are mostly up to you, but your table constraints
do have to consider the following:
1. We must have a phone number to contact students in case of an emergency.
2. We must have ids as the primary key of the tables
3. Phone numbers and emails must be unique to the individual.*/

CREATE TABLE students(
	student_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50), -- better to set NOT NULL
	last_name VARCHAR(50), -- better to set NOT NULL
	homeroom_number INTEGER,
	phone VARCHAR(20) UNIQUE NOT NULL,
	email VARCHAR(50) UNIQUE, -- better VARCHAR(115)
    --check (email like '%_@%_.%_'),
        -- not sure if we can check if email not in teachers
	graduation_year SMALLINT
);

CREATE TABLE teachers(
	teacher_id SERIAL PRIMARY KEY,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	homeroom_number INTEGER,
	department VARCHAR(150),
	phone VARCHAR(20) UNIQUE,
	email VARCHAR(50) UNIQUE --check (
		--email like '_%@_%._%')
);

/*Once you've made the tables, insert a student named Mark Watney
(student_id=1) who has a phone number of 777-555-1234 and doesn't
have an email. He graduates in 2035 and has 5 as a homeroom number.*/
INSERT INTO students(
	first_name,
	last_name,
	phone,
	graduation_year,
	homeroom_number
)
VALUES
('Mark', 'Watney', '777-555-1234', 2035, 5)
;

INSERT INTO teachers(
	first_name,
	last_name,
	homeroom_number,
	email,
	department,
	phone)
VALUES
('Jonas', 'Salk', 5, 'Biology', 'jsalk@school.org', '777-555-4321');

/*Then insert a teacher names Jonas Salk (teacher_id=1) who as a
homeroom number of 5 and is from the Biology department. His contact
info is: jsalk@school.org and a phone number of 777-555-4321.

**Keep in mind that these insert tasks may affect your constraints!**/
