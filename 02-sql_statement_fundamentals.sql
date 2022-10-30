--first query
select * from film;

--select particular columns
select first_name, last_name, email
from customer;

--find unique values in column
select distinct release_year from film;

--another syntax for DISTINCT
select distinct(release_year) from film; --number of rows

--MPAA (PG) rating type available
select distinct rating from film;

--COUNT is a function, need parentheses
select count(title) from film;

--COUNT(*) and COUNT(TITLE) return exact same value
select count(distinct(rating)) from film; --same as COUNT(DISTINCT rating)

--more complex queries
select *
from customer
where first_name = 'Jared';

--
select count(title)
from film
where rental_rate > 4 and replacement_cost >= 19.99
and rating = 'R';

--what is the emal for the customer with name Nancy Thomas?
select email
from customer
where first_name = 'Nancy'
and last_name = 'Thomas'
;

--what's the description for the movie "Outlaw Hanky"?
select description
from film
where title = 'Outlaw Hanky'
;

--what's the phone number for customer who lives at '259 Ipoh Drive'?
select phone
from address -- table address
where address = '259 Ipoh Drive' -- column address
;

--sorting
select * from customer
order by first_name ASC -- ASC is default

--
select store_id, first_name, last_name from customer
order by store_id, last_name DESC --store_id is ordered ASC!

--most recent payments
select * from payment
where amount != 0
order by payment_date DESC
limit 5;

--what are the ids of the first 10 customers who created a payment?
select customer_id
from payment
order by payment_date ASC
limit 10
;

--what are the titles of the 5 shortest movies?
select title
from film
order by length ASC --length is also a SQL kw
limit 5 --beware this doesn't guaranty that they aren't more movies with the same length
;

--if previous customer can watch any movie 50 minutes or less,
--how many option does she have?
select count(distinct title)
from film
where length <= 50
;

--if previous customer can watch any movie 50 minutes or less,
--how many option does she have?
select count(title)
from film
where length <= 50
;

--BETWEEN is inclusive, e.g., BETWEEN 8 AND 10 include 8
--NOT BETWEEN is no inclusive, e.g., NOT BETWEEN 8 AND 10 excludes 8
--date format is ISO 8601, i.e., YYYY-MM-DD
select count(*) from payment
where payment_date between '2007-02-01' and '2007-02-15' --actually 15th 0:00
--so it doesn't include 2007-02-15!

--list
select count(*) from payment
where amount in (.99, 1.98, 1.99)

--pattern matching
--% matches any sequence of characters, can also be zero match/blank
--_ matches any single character
--multiple underscores possible, e.g., 'Version#A4' --> WHERE vlaue LIKE 'Version#__'
--e.g., starts with an 'A' --> WHERE name LIKE 'A%'
--ILIKE is case-insensitive
--more complex pattern, e.g., WHERE name LIKE '_her%' returns ('Cheryl', 'Theresa', 'Sherri')
--regex supported, see more at https://www.postgresql.org/docs/12/functions-matching.html
select *
from customer
where first_name like 'A%'
and last_name not like 'B%'
order by last_name;

--challenge 1
--How many payment transactions were greater than $5.00?
select count(payment_id)
from payment
where amount > 5.00
;

--challenge 2
--How many actors have a first name that starts with the letter P?
select count(actor_id) --or select count(*)
from actor
where first_name like 'P%'
;

--challenge 3
--How many unique districts are our customers from?
select count(distinct(district))
from address
;

--challenge 4
--Retrieve the list of names for those distinct districts from the previous question.
select distinct district
from address
;

--challenge 5
--How many films have a rating of R and a replacement cost between $5 and $15?
select count(film_id)
from film
where rating = 'R'
and replacement_cost between 5 and 15
;

--challenge 6
--How many films have the word Truman somewhere in the title?
select count(film_id)
from film
where title like '%Truman%'
;