/*INNER JOIN
when selecting all the columns during a join,
JOIN is the default clause for INNER JOIN*/
select
	payment_id,
	payment.customer_id, --beware always in columns from different tables having same name
	first_name
from payment --implies customers who have made a payment
inner join customer --symetric joining
on payment.customer_id = customer.customer_id --the columns used for matching will be duplicated
;

/*OUTER JOIN
values only present in one of the tables being joined
FULL OUTER JOIN returns everything in both tables
at the interesction (in common) or not of the table
if not at the intersection, gives a NULL to the columns of the joined result
unless using the WHERE IS null clause --> unique rows --> opposite of INNER JOIN*/
select *
from customer
full outer join payment --symetric Venn diagram
on payment.customer_id = customer.customer_id --could inverse joining order
where customer.customer_id is null
or payment.payment_id is null
;

/*OUTER JOIN
LEFT OUTER JOIN or LEFT JOIN
rows exclusive to the right table not returned*/
select film.film_id, title, inventory_id, store_id
from film
left outer join inventory --asymetric Venn diagram
on inventory.film_id = film.film_id --joining order matters!
;

/*OUTER JOIN
LEFT OUTER JOIN or LEFT JOIN
rows exclusive to the right table not returned*/
select film.film_id, title, inventory_id, store_id
from film
left outer join inventory --asymetric Venn diagram
on inventory.film_id = film.film_id --joining order matters!
where inventory.film_id is null --exclusive to film table
;

/*OUTER JOIN
RIGHT OUTER JOIN or LEFT JOIN
rows exclusive to the left table not returned*/
select film.film_id, title, inventory_id, store_id
from film
right outer join inventory --asymetric Venn diagram
on inventory.film_id = film.film_id --joining order matters!
;

/*UNION
~concatenate two results together, essentially "pasting" them together
one of top of another, or pooled results, using the syntax
select * from DB1
union
select * from DB2
order by name;
*/


/**challenge**
California sales tax laws have changed and we need to alert our customers to this through email.
What are the emails of the customers who live in California?*/
select email
from customer
join address -- default clause for INNER JOIN
on address.address_id = customer.address_id
where district = 'California' -- uniqe identifier in both tables
;

/**challenge**
A customer walks in and is a huge fan of the actor "Nick Wahlberg" and wants to know which movies he is in.
Get a list of all the movies "Nick Wahlberg" has been in.*/
select title
from film
join film_actor
on film.film_id = film_actor.film_id
join actor
on actor.actor_id = film_actor.actor_id
where first_name = 'Nick'
and last_name = 'Wahlberg'
;