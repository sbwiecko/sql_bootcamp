/*timestamps
TIME contains only time
DATE contains only date
TIMESTAMP contains date and time
TIMESTAMPTZ contains date, time and timezone*/
show all -- displays current settings, see https://www.postgresql.org/docs/current/sql-show.html
;

show TIMEZONE
;

select NOW() -- current TIMESTAMPTZ
;

select TIMEOFDAY() -- STR format
;

select CURRENT_TIME
;

select CURRENT_DATE
;

-- EXTRACT() allows to obtain sub-component of a date value
SELECT EXTRACT(YEAR FROM payment_date) AS year
FROM payment
;

-- AGE() calculates and returns the current age given a timestamp
SELECT AGE(payment_date) AS age
FROM payment
;

-- TO_CHAR() general function convert datat types, e.g., timestamps,
-- to text, with formatting pattern (see documentation https://www.postgresql.org/docs/12/functions-formatting.html)
SELECT TO_CHAR(payment_date, 'mon/dd/YYYY')
FROM payment
LIMIT 5
;

SELECT TO_CHAR(payment_date, 'mon_-=-_dd_-=-_YYYY')
FROM payment
LIMIT 5
;

-- CHALLENGE
-- during which months did payments occur ? Format to return back the full month name
select distinct(to_char(payment_date, 'Month'))
from payment
;

-- CHALLENGE
-- how many payments occurred on a Monday?
select count(payment_id)
from payment
where extract(DOW from payment_date) = 1
-- dow as Sunday (0) to Saturday (6)
;

-- mathematical functions and operators
-- see https://www.postgresql.org/docs/9.5/functions-math.html
select round(100 * rental_rate / replacement_cost, 2) as percent_cost
from film
;

-- string functions and operators
-- see https://www.postgresql.org/docs/9.5/functions-strings.html
select length(first_name)
from customer
;

select first_name || last_name -- concatenation, no space in between
from customer
;

select first_name || ' ' || last_name as full_name -- concatenation
from customer
;

select upper(first_name || ' ' || last_name) as full_name -- concatenation
from customer
;

select first_name || last_name || '@gmail.com' -- creating e-mail addresses
from customer
;

select lower(left(first_name, 1) || last_name || '@gmail.com') as custom_email -- first char from first name
-- concatenated with the last_name, @gmail.com suffix, all lowercase
from customer
;

/*subquery
allow to construct complex queries, i.e., queries on the results of another query
subquery is performed first (inside parenthesis)*/
select title, rental_rate
from film
where rental_rate > -- works only if returns a single value
(
	select avg(rental_rate)
	from film
)
;

/*subquery
allow to construct complex queries, i.e., queries on the results of another query
subquery is performed first (inside parenthesis)
example - titles from films returned at a certain date ~ join*/
select film_id, title
from film
where film_id in -- subquery returns multiple results
(
	select inventory.film_id
	from rental
	inner join inventory
	on inventory.inventory_id = rental.inventory_id
	where return_date between '2005-05-29' and '2005-05-30'
)
order by title
;

-- exists operator used to test for existance of rows in a subquery
-- example, find customer names with at least one payment > 11
select first_name, last_name
from customer as c
where exists
(
	select *
	from payment as p
	where p.customer_id = c.customer_id
	and amount > 11
)
;

/*self-join is a query in which a table is joined to itself
self-joins are useful for comparing values in a column or rows
within the same table ~ join of two copies to the same table
no special keyword, uses standard JOIN, but assign an two alias
for the table otherwise the table name would be ambiguous
example: each employee sends reports to another employee
another example is films matching other films from same length*/
select f1.title, f2.title, f1.length
from film as f1
inner join film as f2
on f1.film_id != f2.film_id -- should not match with itself
and f1.length = f2.length -- only length from other film should match
;