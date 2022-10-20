--basic aggregate function
select min(length), max(rental_rate) from film;

--AVG return a FLOAT with many decimal values
select avg(replacement_cost)
from film
;

--ROUND AVG
select round(avg(replacement_cost), 2)
from film
;

--see more https://www.postgresql.org/docs/current/functions-aggregate.html
select sum(replacement_cost)
from film
;

--the case of COUNT(any)
select count(film_id) --number of input rows in which the input value is not null
from film
;

--and CASE(*)
select count(*) --number of input rows, independent of NULL
from film
;

--same as DISTINCT
select customer_id
from payment
group by customer_id --returns customer_id
order by customer_id
;

--in the SELECT statement, columns must either have
--an aggregate function or be in the GROUP BY call
select customer_id, sum(amount)
from payment
group by customer_id --the GROUP BY clause must appear right after a FROM or WHERE
order by sum(amount) desc
limit 10
;

--WHERE statement combined with GROUP BY
select rating, release_year, --should be in the groupby clause
	avg(length)
from film
where rental_rate > 1.00  --where should not refer to the aggregation results!
group by rating, release_year --order important
order by rating
limit 20
;

--DATE transform of timestamps
select date(payment_date), sum(amount)
from payment
group by date(payment_date)
order by sum(amount) desc
;

--                               **challenge**
--             we have two staff members, with Staff IDs 1 and 2.
--We want to give a bonus to the staff member that handled the most payments
-- (most in terms of number of payments processed, not total dollar amount).
--  How many payments did each staff member handle and who gets the bonus?
select staff_id, count(payment) --to make sure that no NULL payment is counted
from payment
group by staff_id
order by count(*) DESC
;

--                         **challenge**
--We are running a promotion to reward our top 5 customers with coupons.
--   What are the customer ids of the top 5 customers by total spend?
select customer_id,
	sum(amount) as total_amount
from payment
group by customer_id
order by total_amount DESC
limit 5
;

--HAVING clause allows to filter after an aggregation has taken place
--i.e., after the GROUP BY clause
select store_id,
	count(customer_id) AS total_customers
from customer
group by store_id
having count(customer_id) > 300 --refering to alias in SELECT not working in postgreSQL
--only MySQL permits alises in HAVING, it is not standard SQL
--https://dba.stackexchange.com/questions/50391/why-does-mysql-allow-having-to-use-select-aliases
;

--**challenge**
--We are launching a platinum service for our most loyal customers.
--We will assign platinum status to customers that have had 40 or more transaction payments.
--What customer_ids are eligible for platinum status?
select customer_id,
	count(payment_id) AS total_transactions
from payment
group by customer_id
having count(payment_id) >= 40
;

--**challenge**
--What are the customer ids of customers who have spent
--more than $100 in payment transactions with our staff_id member 2?
select customer_id,
	sum(amount) AS total_amount
from payment
where staff_id = 2
group by customer_id
having sum(amount) > 100
;

--**assessment test 1**
--Return the customer IDs of customers who have spent
--at least $110 with the staff member who has an ID of 2.
select customer_id
from payment
where staff_id = 2
group by customer_id
having sum(amount) >= 110
;

--**assessment test 1**
--How many films begin with the letter J?
select count(film_id)
from film
where title like 'J%'
;

--**assessment test 1**
--What customer has the highest customer ID number
--whose name starts with an 'E' and has an address ID lower than 500?
select first_name, last_name
from customer
where first_name like 'E%'
and address_id < 500
order by customer_id DESC --no need to use MAX(customer_id)
limit 1
;