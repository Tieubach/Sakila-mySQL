USE sakila;

-- QUESTION 1A: You need a list of all the actors who have Display the first and last names
-- of all actors from the table actor. 
SELECT first_name, last_name
FROM actor;

-- --------------------------------------------------------------

-- 1b. Display the first and last name of each actor in a single column in upper case letters. 
-- Name the column Actor Name. 
USE sakila;
SELECT concat(UCASE(first_name), ' ', UCASE(last_name)) AS Actor_Name
FROM actor;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- - 2a. You need to find the ID number, first name, and last name of an actor, of whom you know
-- only the first name, "Joe." What is one query would you use to obtain this information?
USE sakila;
SELECT actor_id, first_name, last_name
FROM actor
WHERE first_name = "Joe";

-- ------------------------------------------------
-- 2b. Find all actors whose last name contain the letters GEN:
USE sakila;
SELECT last_name
FROM actor
WHERE last_name like "%GEN%";

-- ----------------------------------------------
-- 2c. Find all actors whose last names contain the letters LI. 
-- This time, order the rows by last name and first name, in that order:
USE sakila;
SELECT last_name
FROM actor
WHERE last_name like "%LI%"
ORDER BY last_name, first_name;

-- -------------------------------------------------
-- 2d. Using IN, display the country_id and country columns of the following countries: 
-- Afghanistan, Bangladesh, and China:
USE sakila;
SELECT country_id, country
FROM country
WHERE country IN (
'Afghanistan', 'Bangladesh', 'China'
);

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 3a. Add a middle_name column to the table actor. Position it between first_name and last_name. 
-- Hint: you will need to specify the data type.
USE sakila;
ALTER TABLE actor
ADD middle_name VARCHAR (40) AFTER first_name;
SELECT * FROM actor;

-- ------------------------------------

-- 3b. You realize that some of these actors have tremendously long last names. 
-- Change the data type of the middle_name column to blobs.
USE sakila;
ALTER TABLE actor
MODIFY COLUMN middle_name BLob;
DESCRIBE actor;

-- ------------------------------------
-- 3c. Now delete the middle_name column.
USE sakila;
ALTER TABLE actor
DROP COLUMN middle_name;
SELECT * FROM actor

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 4a. List the last names of actors, as well as how many actors have that last name.
USE sakila;
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name;

-- ------------------------------------------------
-- 4b. List last names of actors and the number of actors who have that last name, 
-- but only for names that are shared by at least two actors
USE sakila;
SELECT last_name, COUNT(last_name)
FROM actor
GROUP BY last_name HAVING COUNT(last_name)>1;

-- ----------------------------------------------
-- 4c. The actor HARPO WILLIAMS was accidentally entered in the actor table as GROUCHO WILLIAMS.
-- Write a query to fix the record.
USE sakila;
UPDATE actor
SET first_name = 'HARPO'
WHERE first_name = 'GROUCHO' and last_name = 'WILLIAMS';
SELECT * FROM actor WHERE actor_id = 172;

-- -----------------------------------------------
-- 4d. Perhaps we were too hasty in changing GROUCHO to HARPO. 
-- It turns out that GROUCHO was the correct name after all! In a single query, 
-- if the first name of the actor is currently HARPO, change it to GROUCHO.
USE sakila;
UPDATE actor
SET first_name = 'GROUCHO'
WHERE first_name = 'HARPO' and last_name = 'WILLIAMS';
SELECT * FROM actor WHERE actor_id = 172;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 5a. You cannot locate the schema of the address table. Which query would you use to re-create it?
  -- Hint: https://dev.mysql.com/doc/refman/5.7/en/show-create-table.html
DESCRIBE address;
SHOW CREATE TABLE sakila.address;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  
-- 6a. Use JOIN to display the first and last names, as well as the address, of each staff member. 
-- Use the tables staff and address:
USE sakila;
SELECT s.first_name, s.last_name, a.address
FROM staff s
JOIN address a
ON s.address_id = a.address_id;
-- --------------------------------------------------------------

-- 6b. Use JOIN to display the total amount rung up by each staff member in August of 2005. 
-- Use tables staff and payment.
USE sakila;
SELECT s.staff_id, s.first_name, s.last_name, SUM(p.amount) AS 'Total Amount'
FROM staff s
JOIN payment p
ON s.staff_id = p.staff_id
WHERE p.payment_date BETWEEN '2005-08-01 00:00:00' AND '2005-08-31 23:59:59'
GROUP BY s.staff_id;

-- ----------------------------------------------------------
-- 6c. List each film and the number of actors who are listed for that film. 
-- Use tables film_actor and film. Use inner join.
USE sakila;
SELECT fa.film_id, f.title, COUNT(fa.actor_id) AS 'Number of Actors'
FROM film f
INNER JOIN film_actor fa
ON f.film_id = fa.film_id
GROUP BY fa.film_id;

-- ---------------------------------------------
-- 6d. How many copies of the film Hunchback Impossible exist in the inventory system?
USE sakila;
SELECT f.film_id, f.title, COUNT(i.film_id) AS 'Number of Copies'
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
WHERE f.title = 'Hunchback Impossible'
GROUP by f.film_id;

-- ------------------------------------------------
-- 6e. Using the tables payment and customer and the JOIN command, list the total paid by each customer. 
-- List the customers alphabetically by last name:
      --	![Total amount paid](Images/total_payment.png)
USE sakila;
SELECT c.customer_id, c.first_name, c.last_name, SUM(p.amount) AS 'Total Paid, $'
FROM customer c
JOIN payment p
ON c.customer_id = p.customer_id
GROUP BY p.customer_id
ORDER BY c.last_name, c.first_name;

-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 7a. The music of Queen and Kris Kristofferson have seen an unlikely resurgence. 
-- As an unintended consequence, films starting with the letters K and Q have also soared in popularity.
--  Use subqueries to display the titles of movies starting with the letters K and Q
--  whose language is English.
USE sakila;
SELECT title
FROM film
WHERE language_id IN
	(SELECT language_id 
    FROM language
    WHERE name = "English")
AND title LIKE "K%" OR title LIKE "Q%";
    
-- ---------------------------------------------------
-- 7b. Use subqueries to display all actors who appear in the film Alone Trip.
USE sakila;
SELECT first_name, last_name
FROM actor
WHERE actor_id IN
	(SELECT actor_id
    FROM film_actor
    WHERE film_id IN
		(SELECT film_id
        FROM film
        WHERE title = "Alone Trip"));

-- -----------------------------------------------
-- 7c. You want to run an email marketing campaign in Canada, for which you will 
-- need the names and email addresses of all Canadian customers. 
-- Use joins to retrieve this information.
USE sakila;
SELECT c.first_name, c.last_name, c.email
FROM customer c
JOIN address a
ON c.address_id = a.address_id

JOIN city ci
ON a.city_id = ci.city_id

JOIN country co
ON ci.country_id = co.country_id
WHERE co.country = 'Canada';

-- -----------------------------------------------
-- 7d. Sales have been lagging among young families, and you wish to target all 
-- family movies for a promotion. Identify all movies categorized as family films.
USE sakila;
SELECT *
FROM film
WHERE film_id IN
	(SELECT film_id
    FROM film_category
    WHERE category_id IN
		(SELECT category_id
        FROM category
        WHERE name = 'Family'));

-- ------------------------------------------------
-- 7e. Display the most frequently rented movies in descending order.
USE sakila;
SELECT title, COUNT(r.rental_id) AS 'Number of times rented'
FROM film f
JOIN inventory i
ON f.film_id = i.film_id
JOIN rental r
ON i.inventory_id = r.inventory_id
GROUP BY f.title
ORDER BY COUNT(r.rental_id) DESC;

-- -----------------------------------------------------
-- 7f. Write a query to display how much business, in dollars, each store brought in.
USE sakila;
SELECT s.store_id, SUM(p.amount) AS 'Total Revenue'
FROM store s
RIGHT JOIN staff st
ON s.store_id = st.store_id
LEFT JOIN payment p
ON st.staff_id = p.staff_id
GROUP BY s.store_id;

-- -------------------------------------------------
-- 7g. Write a query to display for each store its store ID, city, and country.
SELECT s.store_id, c.city, co.country
FROM store s
JOIN address a
ON s.address_id = a.address_id
JOIN city c
ON a.city_id = c.city_id
JOIN country co
ON c.country_id = co.country_id;

-- --------------------------------------------------
-- 7h. List the top five genres in gross revenue in descending order. 
-- (Hint: you may need to use the following tables: category, film_category, inventory, 
-- payment, and rental.)
SELECT c.name, SUM(p.amount) AS 'Gross Revenue'
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id

JOIN inventory i
ON fc.film_id = i.film_id

JOIN rental r
ON i.inventory_id = r.inventory_id

JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name
ORDER BY SUM(p.amount) DESC LIMIT 5;

-- ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++

-- 8a. In your new role as an executive, you would like to have an easy way of viewing 
-- the Top five genres by gross revenue. Use the solution from the problem above to create a view. 
-- If you haven't solved 7h, you can substitute another query to create a view.
USE sakila;
CREATE VIEW Top_five_genres_by_gross_revenue AS
	
SELECT c.name, SUM(p.amount) AS 'Total Revenue'
FROM category c
JOIN film_category fc
ON c.category_id = fc.category_id

JOIN inventory i
ON fc.film_id = i.film_id
    
JOIN rental r
ON i.inventory_id = r.inventory_id
    
JOIN payment p
ON r.rental_id = p.rental_id
GROUP BY c.name 
ORDER BY SUM(p.amount) DESC LIMIT 5;

SELECT * FROM sakila.top_five_genres_by_gross_revenue;    
    
-- ----------------------------------------------
-- 8b. How would you display the view that you created in 8a?
SELECT * FROM top_five_genres_by_gross_revenue; 

-- -------------------------------------------------
-- 8c. You find that you no longer need the view top_five_genres. Write a query to delete it.
DROP VIEW top_five_genres_by_gross_revenue;

