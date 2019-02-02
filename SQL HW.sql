-- # Homework Assignment

-- ## Installation Instructions

-- * Refer to the [installation guide](Installation.md) to install the necessary files.

-- ## Instructions

-- * 1a. Display the first and last names of all actors from the table `actor`.
SELECT first_name, last_name
FROM actor;

-- * 1b. Display the first and last name of each actor in a single column in upper case letters. Name the column `Actor Name`.
SELECT 
concat(first_name, " ", last_name) as 'Actor Name'
FROM actor;

-- * 2a. You need to find the ID number, first name, and last name of an actor, of whom you know only the first name, "Joe." What is one query would you use to obtain this information?
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = 'JOE';

-- alternatively, to keep the same column thing
	-- SELECT actor_id,
	-- concat(first_name, " ", last_name) as 'Actor Name'
	-- FROM actor
	-- WHERE first_name = 'JOE';



-- * 2b. Find all actors whose last name contain the letters `GEN`:
SELECT first_name, last_name
FROM actor
WHERE last_name LIKE '%GEN%';

-- alternatively, to keep the same column thing
	-- SELECT 
	-- concat(first_name, " ", last_name) as 'Actor Name'
	-- FROM actor
	-- WHERE last_name LIKE '%GEN%';

-- * 2c. Find all actors whose last names contain the letters `LI`. This time, order the rows by last name and first name, in that order:
SELECT last_name, first_name
FROM actor
WHERE last_name LIKE '%LI%'
ORDER BY last_name ASC, first_name ASC;


-- * 2d. Using `IN`, display the `country_id` and `country` columns of the following countries: Afghanistan, Bangladesh, and China:
SELECT country_id, country
FROM country
WHERE country IN 
('Afghanistan', 'Bangladesh', 'China');

-- * 3a. You want to keep a description of each actor. You don't think you will be performing queries on a description, so create a column in the table `actor` named `description` and use the data type `BLOB` (Make sure to research the type `BLOB`, as the difference between it and `VARCHAR` are significant).

ALTER TABLE actor
ADD COLUMN description BLOB ;

-- * 3b. Very quickly you realize that entering descriptions for each actor is too much effort. Delete the `description` column.

ALTER TABLE actor
DROP COLUMN description;

-- * 4a. List the last names of actors, as well as how many actors have that last name.

SELECT last_name, COUNT(last_name) as count_last_name
from actor
GROUP BY last_name;

-- * 4b. List last names of actors and the number of actors who have that last name, but only for names that are shared by at least two actors

-- I think you were asking for duplicate last names only?

SELECT last_name, COUNT(last_name) as count_last_name
from actor
GROUP BY last_name
HAVING count_last_name > 1;

-- * 4c. The actor `HARPO WILLIAMS` was accidentally entered in the `actor` table as `GROUCHO WILLIAMS`. Write a query to fix the record.

UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';

SELECT * FROM actor
WHERE last_name = 'WILLIAMS';

-- * 4d. Perhaps we were too hasty in changing `GROUCHO` to `HARPO`. It turns out that `GROUCHO` was the correct name after all! In a single query, if the first name of the actor is currently `HARPO`, change it to `GROUCHO`.

UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO';
SELECT * FROM actor
WHERE first_name = 'HARPO';

-- * 5a. You cannot locate the schema of the `address` table. Which query would you use to re-create it?
SELECT *
FROM INFORMATION_SCHEMA.COLUMNS
WHERE table_name = 'address';

SHOW CREATE TABLE address;

CREATE TABLE address
`address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,
`address` varchar(50) NOT NULL,
`address2` varchar(50) DEFAULT NULL,
`district` varchar(20) NOT NULL,
`city_id` smallint(5) unsigned NOT NULL,
`postal_code` varchar(10) DEFAULT NULL,
`phone` varchar(20) NOT NULL,
`location` geometry NOT NULL,
`last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
PRIMARY KEY (`address_id`),
KEY `idx_fk_city_id` (`city_id`),
SPATIAL KEY `idx_location` (`location`),
CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8;

-- 'address', 'CREATE TABLE `address` (\n  `address_id` smallint(5) unsigned NOT NULL AUTO_INCREMENT,\n  `address` varchar(50) NOT NULL,\n  `address2` varchar(50) DEFAULT NULL,\n  `district` varchar(20) NOT NULL,\n  `city_id` smallint(5) unsigned NOT NULL,\n  `postal_code` varchar(10) DEFAULT NULL,\n  `phone` varchar(20) NOT NULL,\n  `location` geometry NOT NULL,\n  `last_update` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,\n  PRIMARY KEY (`address_id`),\n  KEY `idx_fk_city_id` (`city_id`),\n  SPATIAL KEY `idx_location` (`location`),\n  CONSTRAINT `fk_address_city` FOREIGN KEY (`city_id`) REFERENCES `city` (`city_id`) ON UPDATE CASCADE\n) ENGINE=InnoDB AUTO_INCREMENT=606 DEFAULT CHARSET=utf8'
--   * Hint: [https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html](https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html)

-- * 6a. Use `JOIN` to display the first and last names, as well as the address, of each staff member. Use the tables `staff` and `address`:

SELECT first_name, last_name, address.address
FROM staff
INNER JOIN address
ON staff.address_id = address.address_id;

		-- there are only 2 names in the staff table as far as I can see....

-- * 6b. Use `JOIN` to display the total amount rung up by each staff member in August of 2005. Use tables `staff` and `payment`.

SELECT staff.staff_id, concat(staff.first_name, ' ', staff.last_name) as staff_name, SUM(amount)
FROM payment
JOIN staff
ON payment.staff_id = staff.staff_id
GROUP BY staff_id;


-- * 6c. List each film and the number of actors who are listed for that film. Use tables `film_actor` and `film`. Use inner join.

SELECT title, COUNT(title) as number_actors
FROM film
JOIN film_actor
ON film.film_id = film_actor.film_id
GROUP BY title;


-- * 6d. How many copies of the film `Hunchback Impossible` exist in the inventory system?

SELECT COUNT(title) as copies
FROM film
JOIN inventory
ON film.film_id = inventory.film_id
WHERE film.title = 'Hunchback Impossible';

-- * 6e. Using the tables `payment` and `customer` and the `JOIN` command, list the total paid by each customer. List the customers alphabetically by last name:

-- added "ANY_VALUE" due to getting error code 1055; I assume there are some blanks.

SELECT ANY_VALUE(first_name) as first_name, ANY_VALUE(last_name) as last_name, SUM(payment.amount) as total_paid
FROM customer
JOIN payment
ON payment.customer_id = customer.customer_id
GROUP BY last_name ASC;



-- * 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters `K` and `Q` have also soared in popularity. 
-- Use subqueries to display the titles of movies starting with the letters `K` and `Q` whose language is English.

SELECT title
FROM film
WHERE title LIKE 'K%' OR title LIKE 'Q%'
AND language_id in
	(
    SELECT language_id
    FROM language
    WHERE name = 'English'
    );

-- * 7b. Use subqueries to display all actors who appear in the film `Alone Trip`.

SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(
	SELECT actor_id
	FROM film_actor
	WHERE film_id IN
		(
		SELECT film_id
		FROM film
		WHERE title = 'Alone Trip'
		)
	);

-- * 7c. You want to run an email marketing campaign in Canada, for which you will need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
-- SELECT first_name, last_name, email
-- FROM customer
-- WHERE address_id IN
-- 	(
-- 	SELECT address_id
-- 	FROM address
-- 	WHERE city_id IN
-- 		(
-- 		SELECT city_id
-- 		FROM city
-- 		WHERE country_id IN
-- 			(
-- 			SELECT country_id
-- 			FROM country
-- 			WHERE country = 'Canada'
-- 			)
-- 		)
-- 	);

SELECT customer.first_name, customer.last_name, customer.email
FROM customer
INNER JOIN address
	ON customer.address_id = address.address_id
INNER JOIN city
	ON address.city_id = city.city_id
INNER JOIN country
	ON city.country_id = country.country_id
WHERE country.country = 'Canada';

-- * 7d. Sales have been lagging among young families, and you wish to target all family movies for a promotion. Identify all movies categorized as _family_ films.

SELECT * from category;

SELECT title
FROM film
WHERE film_id IN
	(
	SELECT film_id
	FROM film_category
	WHERE category_id IN
		(
		SELECT category_id
		FROM category
		WHERE name = 'Family'
		)
	);

-- * 7e. Display the most frequently rented movies in descending order.


SELECT title, COUNT(rental.inventory_id) AS frequency
FROM film
JOIN inventory
	ON inventory.film_id = film.film_id
JOIN rental
	ON inventory.inventory_id = rental.inventory_id
GROUP BY title
ORDER BY COUNT(rental.inventory_id) DESC;

-- * 7f. Write a query to display how much business, in dollars, each store brought in.


SELECT customer.store_id, SUM(payment.amount) as 'Business in Dollars'
FROM customer
JOIN payment
	ON payment.customer_id=customer.customer_id
GROUP BY store_id
ORDER BY SUM(payment.amount) DESC;



-- * 7g. Write a query to display for each store its store ID, city, and country.
SELECT store_id, city.city, country.country
FROM store
JOIN address
	ON store.address_id = address.address_id
JOIN city
	ON address.city_id = city.city_id
JOIN country
	on country.country_id = city.country_id;


-- * 7h. List the top five genres in gross revenue in descending order. (**Hint**: you may need to use the following tables: category, film_category, inventory, payment, and rental.)
SELECT category.name, SUM(payment.amount) as gross_revenue
from category
JOIN film_category
	ON category.category_id = film_category.category_id 
JOIN inventory
	ON film_category.film_id = inventory.film_id
JOIN rental
	ON inventory.inventory_id = rental.inventory_id
JOIN payment
	ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- * 8a. In your new role as an executive, you would like to have an easy way of viewing the Top five genres by gross revenue. Use the solution from the problem above to create a view. If you haven't solved 7h, you can substitute another query to create a view.
CREATE VIEW top_five_by_genre AS
SELECT category.name, SUM(payment.amount) as gross_revenue
from category
JOIN film_category
	ON category.category_id = film_category.category_id 
JOIN inventory
	ON film_category.film_id = inventory.film_id
JOIN rental
	ON inventory.inventory_id = rental.inventory_id
JOIN payment
	ON rental.rental_id = payment.rental_id
GROUP BY category.name
ORDER BY SUM(payment.amount) DESC
LIMIT 5;

-- * 8b. How would you display the view that you created in 8a?

SELECT * FROM top_five_by_genre;

-- * 8c. You find that you no longer need the view `top_five_genres`. Write a query to delete it.
DROP VIEW top_five_by_genre;

-- ## Appendix: List of Tables in the Sakila DB

-- * A schema is also available as `sakila_schema.svg`. Open it with a browser to view.

-- ```sql
-- 'actor'
-- 'actor_info'
-- 'address'
-- 'category'
-- 'city'
-- 'country'
-- 'customer'
-- 'customer_list'
-- 'film'
-- 'film_actor'
-- 'film_category'
-- 'film_list'
-- 'film_text'
-- 'inventory'
-- 'language'
-- 'nicer_but_slower_film_list'
-- 'payment'
-- 'rental'
-- 'sales_by_film_category'
-- 'sales_by_store'
-- 'staff'
-- 'staff_list'
-- 'store'
-- ```

-- ## Uploading Homework

-- * To submit this homework using BootCampSpot:

--   * Create a GitHub repository.
--   * Upload your .sql file with the completed queries.
--   * Submit a link to your GitHub repo through BootCampSpot.