#1

SELECT
    customer_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    a.address,
    city.city,
    country.country
FROM
    customer c
JOIN address a ON
    c.address_id = a.address_id
JOIN city ON
    a.city_id = city.city_id
JOIN country ON
    city.country_id = country.country_id

#2

SELECT
    customer_id,
    CONCAT(customer.first_name, ' ', customer.last_name) AS customer_full_name,
    CONCAT(
        staff.first_name,
        ' ',
        staff.last_name
    ) AS manager_full_name
FROM
    customer
JOIN store ON customer.store_id = store.store_id
JOIN staff ON store.manager_staff_id = staff.staff_id

#3

SELECT
    actor.actor_id,
    CONCAT(first_name, ' ', last_name),
    COUNT(film_actor.film_id)
FROM
    actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
GROUP BY
    film_actor.actor_id

#4

SELECT
    actor.actor_id,
    CONCAT(first_name, ' ', last_name) AS full_name,
    category.name,
    COUNT(
        film_actor.actor_id = actor.actor_id
    )
FROM
    actor
JOIN film_actor ON actor.actor_id = film_actor.actor_id
JOIN film ON film_actor.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY
    actor.actor_id,
    category.category_id

#5

SELECT
    title,
    COUNT(rental.rental_id) AS rental_count
FROM
    film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
GROUP BY
    title
ORDER BY
    rental_count
DESC
LIMIT 10

#6

SELECT
    film.film_id,
    film.title,
    category.name,
    COUNT(rental.rental_id) AS rental_count
FROM
    film
JOIN inventory ON film.film_id = inventory.film_id
JOIN rental ON inventory.inventory_id = rental.inventory_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY
    title
ORDER BY
    rental_count
DESC
LIMIT 10

#7

SELECT
    film.film_id,
    film.title,
    SUM(payment.amount) AS total_rental_profit
FROM
    rental
JOIN payment ON rental.rental_id = payment.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY
    (film.title)
ORDER BY
    total_rental_profit
DESC
LIMIT 10

#8

SELECT
    film.film_id,
    film.title,
    category.name,
    SUM(payment.amount) AS total_rental_profit
FROM
    rental
JOIN payment ON rental.rental_id = payment.rental_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY
    film.title
ORDER BY
    total_rental_profit
DESC
LIMIT 10

#9

SELECT
    film.film_id,
    film.title,
    COUNT(rental.rental_id) * film.rental_duration AS total_rental_duration
FROM
    rental
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
GROUP BY
    film.title
ORDER BY
    total_rental_duration
DESC

#11

SELECT
    staff.staff_id,
    staff.first_name,
    COUNT(payment.payment_id) AS number_of_payments,
    SUM(payment.amount) AS sum_of_payments
FROM
    staff
JOIN payment ON staff.staff_id = payment.staff_id
GROUP BY
    staff.staff_id

#12

SELECT
    CONCAT(
        customer.first_name,
        ' ',
        customer.last_name
    ) AS customer_full_name,
    film.title,
    DATEDIFF(
        rental.return_date,
        rental.rental_date
    ) AS date_diff
FROM
    customer
JOIN rental ON customer.customer_id = rental.customer_id
JOIN inventory ON rental.inventory_id = inventory.inventory_id
JOIN film ON inventory.film_id = film.film_id
WHERE
    DATEDIFF(
        rental.return_date,
        rental.rental_date
    ) > 7

#13

SELECT 
    language.name,
    COUNT(film.film_id) AS number_of_films
FROM language
JOIN film ON language.language_id = film.language_id

#14

SELECT
    category.name,
    COUNT(film.film_id) AS film_number
FROM
    film
JOIN film_category ON film.film_id = film_category.film_id
JOIN category ON film_category.category_id = category.category_id
GROUP BY
    category.name

#15

SELECT
    (
    SELECT
        c.name
    FROM
        film_category fc
    JOIN category c ON
        fc.category_id = c.category_id
    GROUP BY
        c.category_id
    ORDER BY
        COUNT(fc.film_id) ASC
    LIMIT 1
) AS "nazov kategorie (MIN)",(
    SELECT
        c.name
    FROM
        film_category fc
    JOIN category c ON
        fc.category_id = c.category_id
    GROUP BY
        c.category_id
    ORDER BY
        COUNT(fc.film_id)
    DESC
LIMIT 1
) AS "nazov kategorie (MAX)"

#17

SELECT
    city.city,
    COUNT(customer.customer_id) AS number_of_customers
FROM
    customer
JOIN address ON customer.address_id = address.address_id
JOIN city ON address.city_id = city.city_id
GROUP BY
    city.city_id

#18

SELECT
    country.country,
    COUNT(customer.customer_id) AS number_of_customers
FROM
    country
JOIN city ON country.country_id = city.country_id
JOIN address ON city.city_id = address.city_id
JOIN customer ON address.address_id = customer.address_id
GROUP BY
    country.country_id

#19

SELECT
    (
    SELECT
        COUNT(customer.customer_id) AS number_of_customers
    FROM
        country
    JOIN city ON country.country_id = city.country_id
    JOIN address ON city.city_id = address.city_id
    JOIN customer ON address.address_id = customer.address_id
    GROUP BY
        country.country_id
    ORDER BY
        number_of_customers
    LIMIT 1
) AS 'Mesto MIN',(
    SELECT
        COUNT(customer.customer_id) AS number_of_customers
    FROM
        country
    JOIN city ON country.country_id = city.country_id
    JOIN address ON city.city_id = address.city_id
    JOIN customer ON address.address_id = customer.address_id
    GROUP BY
        country.country_id
    ORDER BY
        number_of_customers
    DESC
    LIMIT 1
) AS 'Mesto MAX'
