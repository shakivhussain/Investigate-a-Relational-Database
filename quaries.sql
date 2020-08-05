/*Query1 - the query used for the first insight*/
SELECT
   f.title AS Film_Name,
   COUNT(a.actor_id) AS Number_of_actors
FROM
   film_actor fa
   JOIN
      film f
      ON f.film_id = fa.film_id
   JOIN
      actor a
      ON a.actor_id = fa.actor_id
WHERE
   f.title = 'Academy Dinosaur'
GROUP BY
   f.title;

/*Query2 - the query used for the second insight*/
SELECT
   film_name AS film_name,
   number_of_actors AS number_of_actors
FROM
   (
      SELECT
         f.title AS film_name,
         COUNT(a.actor_id) AS number_of_actors
      FROM
         film_actor fa
         JOIN
            film f
            ON f.film_id = fa.film_id
         JOIN
            actor a
            ON a.actor_id = fa.actor_id
      GROUP BY
         f.title
   )
   sub
GROUP BY
   sub.film_name,
   sub.number_of_actors
ORDER BY
   number_of_actors DESC LIMIT 7;

/*Query3 - the query used for the third insight*/
SELECT
   number_of_stores AS number_of_stores,
   country_name AS country_name
FROM
   (
      SELECT
         co.country country_name AS country_name,
         COUNT(a.address_id) AS number_of_stores
      FROM
         address a
         JOIN
            store s
            ON a.address_id = s.address_id
         JOIN
            city c
            ON a.city_id = c.city_id
         JOIN
            country co
            ON co.country_id = c.country_id
      GROUP BY
         co.country
   )
   sub
WHERE
   sub.number_of_stores >= 1
GROUP BY
   sub.country_name,
   sub.number_of_stores;

/*Query4 - the query used for the fourth insight*/
SELECT
   p.payment_date AS payment_date,
   CONCAT(first_name, ' ', last_name) AS customer_name,
   p.amount AS amount,
   AVG(P.amount) OVER (
ORDER BY
   p.payment_date) AS average_amount_of_payment
FROM
   payment p
   JOIN
      customer c
      ON p.customer_id = c.customer_id
   JOIN
      rental r
      ON p.rental_id = r.rental_id
   JOIN
      inventory i
      ON i.inventory_id = r.inventory_id
   JOIN
      film f
      ON f.film_id = i.inventory_id
WHERE
   f.title = 'Chamber Italian'
GROUP BY
   p.payment_date,
   c.first_name,
   c.last_name,
   p.amount
having
   MIN(amount) > 0.00;
