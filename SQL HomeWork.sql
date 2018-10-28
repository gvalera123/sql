Use Sakila;

-- 1a.
SELECT 
	 first_name
    ,last_name
FROM Sakila.Actor;

-- 1b.
SELECT
	concat(first_name,' ',last_name) AS ActorName
FROM Sakila.Actor;

-- 2a.
SELECT 
	 actor_id
    ,first_name
    ,last_name
FROM Sakila.Actor
WHERE first_name = 'Joe';

-- 2b.
SELECT 
	 actor_id
    ,first_name
    ,last_name
FROM Sakila.Actor
WHERE last_name like '%gen%';

-- 2c.
SELECT 
	 actor_id
    ,first_name
    ,last_name
FROM Sakila.Actor
WHERE last_name like '%li%'
ORDER BY last_name, first_name;

-- 2d.
SELECT *
FROM Sakila.Country
WHERE country IN (
	 'Afghanistan'
    ,'Bangladesh'
    ,'China'
	);

-- 3a.
ALTER TABLE Actor
ADD COLUMN Description BLOB;

-- 3b.
ALTER TABLE Actor
DROP COLUMN Description;

-- 4a
SELECT 
	 last_name
    ,count(*)
FROM Sakila.Actor
GROUP BY last_name;

-- 4b
SELECT 
	 last_name
    ,count(*)
FROM Sakila.Actor
GROUP BY last_name
HAVING COUNT(*) > 1;

-- 4c
UPDATE Sakila.Actor
SET first_name = 'Harpo'
WHERE first_name = 'Groucho'
AND last_name = 'Williams';

-- 4d
UPDATE Sakila.Actor
SET first_name = 'Groucho'
WHERE first_name = 'Harpo'
AND last_name = 'Williams';

-- 5a
SHOW CREATE TABLE Sakila.Address;

-- 6a
SELECT 
	 s.first_name
    ,s.last_name
    ,a.address
FROM Sakila.Staff s
INNER JOIN Sakila.Address a
	ON s.address_id = a.address_id;
    
-- 6b
select 
	 s.first_name
    ,s.last_name
    ,a.address
    ,sum(p.amount) as total_amount
from Sakila.Staff s
INNER JOIN Sakila.Address a
	ON s.address_id = a.address_id
INNER JOIN Sakila.Payment p
	ON s.staff_id = p.staff_id
WHERE payment_date like '2005-08%'
GROUP BY 	 
	 s.first_name
    ,s.last_name
    ,a.address;
    
-- 6c
SELECT 
	 title
    ,count(*) count_actors
FROM Sakila.Film f
INNER JOIN Sakila.Film_Actor fa
	ON f.film_id = fa.film_id
GROUP BY title;

-- 6d
SELECT count(*) count_in_inventory
FROM Sakila.Inventory i
INNER JOIN Sakila.Film f
	ON i.film_id = f.film_id
Where f.title = 'Hunchback Impossible';

-- 6e
SELECT 
	 c.first_name
    ,c.last_name
    ,sum(p.amount) total_amount
FROM Sakila.Customer c
INNER JOIN Sakila.Payment p
	ON c.customer_id = p.customer_id
GROUP BY 
	 c.first_name
    ,c.last_name
ORDER BY last_name;

-- 7a
SELECT title
FROM Sakila.Film
WHERE (title like 'K%' OR title like 'Q%')
AND language_id = (
	Select language_id 
	from Sakila.Language
	WHERE name = 'English');
    
-- 7b
SELECT 
	 first_name
    ,last_name
FROM Sakila.Actor
WHERE actor_id in (
	SELECT actor_id
	FROM Sakila.film_actor
	WHERE film_id = (
		SELECT film_id
		FROM Sakila.Film
		WHERE title = 'Alone Trip'));
        
-- 7c
SELECT 	
	 c.first_name
    ,c.last_name
    ,c.email
FROM Sakila.Customer c
INNER JOIN Sakila.Address a
	ON c.address_id = a.address_id
INNER JOIN Sakila.City cty
	ON a.city_id = cty.city_id
INNER JOIN Sakila.Country cntry
	on cty.country_id = cntry.country_id
WHERE cntry.country = 'Canada';

-- 7d
SELECT f.title
FROM Sakila.Film f
INNER JOIN Sakila.film_category fc
	ON f.film_id = fc.film_id
INNER JOIN Sakila.Category c
	ON fc.category_id = fc.category_id
WHERE c.name = 'family';

-- 7e
SELECT 
	f.title
    ,count(*) rental_count
FROM Sakila.Rental r
INNER JOIN Sakila.Inventory i
	ON r.inventory_id = i.inventory_id
INNER JOIN Sakila.Film f
	ON i.film_id = f.film_id
GROUP BY f.title
ORDER BY rental_count DESC;

-- 7f
SELECT 
	 str.store_id
    ,sum(p.amount) total_amount
FROM Sakila.Store str 
INNER JOIN Sakila.Staff stf 
	ON str.store_id = stf.store_id
INNER JOIN Sakila.Payment p
	ON stf.staff_id = p.staff_id
GROUP BY str.store_id;

-- 7g
SELECT 
	 str.store_id
    ,cty.city
    ,cntry.country
FROM Sakila.Store str
INNER JOIN Sakila.Address a
	ON str.address_id = a.address_id
INNER JOIN Sakila.City cty
	ON a.city_id = cty.city_id
INNER JOIN Sakila.Country cntry
	ON cty.country_id = cntry.country_id;

-- 7h
SELECT 
	 cat.name
    ,sum(p.amount) total_amount
FROM Sakila.Payment p
INNER JOIN Sakila.Rental r
	ON r.rental_id = p.rental_id
INNER JOIN Sakila.Inventory i
	ON i.inventory_id = r.inventory_id
INNER JOIN Sakila.Film f
	ON i.film_id = f.film_id
INNER JOIN Sakila.Film_Category fc
	ON f.film_id = fc.film_id	
INNER JOIN Sakila.Category cat
	ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY total_amount DESC
LIMIT 5;

-- 8a
CREATE VIEW vTopFiveRentals

AS

SELECT 
	 cat.name
    ,sum(p.amount) total_amount
FROM Sakila.Payment p
INNER JOIN Sakila.Rental r
	ON r.rental_id = p.rental_id
INNER JOIN Sakila.Inventory i
	ON i.inventory_id = r.inventory_id
INNER JOIN Sakila.Film f
	ON i.film_id = f.film_id
INNER JOIN Sakila.Film_Category fc
	ON f.film_id = fc.film_id	
INNER JOIN Sakila.Category cat
	ON fc.category_id = cat.category_id
GROUP BY cat.name
ORDER BY total_amount DESC
LIMIT 5;

-- 8b
SELECT *
FROM vTopFiveRentals;

-- 8c
DROP VIEW vTopFiveRentals;