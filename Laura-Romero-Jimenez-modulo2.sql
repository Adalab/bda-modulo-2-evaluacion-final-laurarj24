-- Lo primero que hacemos es abrir el Schema sakila para poder trabajar sobre esta base de datos

USE sakila;

/* Ejercicio 1: Selecciona todos los nombres de las películas sin que aparezcan duplicados. */
 
-- Está pidiendo el nombre (title, segun figura en la tabla film o film_text)
-- Cuando se pide especificamente que no aparezcan duplicados añadimos al select la clausula DISTINCT
-- En este caso concreto, explorando la tabla, no parece que sea necesario añadir DISCTINCT porque no parece haber registros duplicados
-- pero al ser 1000 filas es mejor añadirlo por si acaso, porque no vamos a ir fila por fila comprobando si hay registros duplicados 
 
SELECT DISTINCT title
FROM film; 

-- También podría hacer la consulta sobre la tabla film_text, que contiene informacion del titulo de las peliculas 
 
SELECT DISTINCT title
FROM film_text; 

/* Ejercicio 2: Muestra los nombres de todas las películas que tengan una clasificación de "PG-13"*/
 
-- Está pidiendo el nombre de las peliculas, igual que antes, pero añade una condicion, por lo que tendremos que usar la clausula WHERE
 
SELECT title
FROM film 
WHERE rating = 'PG-13';
 
 
/* Ejercicio 3: Encuentra el título y la descripción de todas las películas que contengan la palabra "amazing" en su descripción. */
 
-- Está pidiendo nombre y descripcion de las peliculas (title, description) y añade una condicion sobre una palabra que debe contener
-- para ello en la clausula WHERE tendremos que añadir operadores especiales de filtro de tipo like o regex
 
SELECT title, description 
FROM film
WHERE description LIKE '%amazing%';

-- también podríamos hacerlo sobre la tabla film_text

SELECT title, description 
FROM film_text
WHERE description LIKE '%amazing%';

/* Ejercicio 4: Encuentra el título de todas las películas que tengan una duración mayor a 120 minutos. */
 
-- Nos está pidiendo el titulo de nuevo con la condicion (WHERE) de que la duracion (length) sea superior a 120 minutos

SELECT title 
FROM film 
WHERE length > 120; 
 
/* Ejercicio 5: Recupera los nombres de todos los actores. */
 
-- Nos está pidiendo los nombres de los actores (first_name), para lo cual tenemos que usar la tabla actor

SELECT first_name
FROM actor; 

-- En este caso vemos registros duplicados, porque hay actores que se llaman igual, si quisieramos evitar estos registros duplicados añadiriamos 
-- la clausula DISTINCT en el SELECT 
 
/* Ejercicio 6: Encuentra el nombre y apellido de los actores que tengan "Gibson" en su apellido.*/
 
 -- Nos pide nombre (first_name) y apellidos (last_name) pero con la condicion de que su apellido contenga la palabra Gibson
 
 SELECT first_name, last_name
 FROM actor
 WHERE last_name LIKE '%gibson%';
 
 -- En este caso usando un = también funcionaria, porque el apellido es gibson exactamente
 
SELECT first_name, last_name
FROM actor
WHERE last_name ='gibson';
 
/* Ejercicio 7: Encuentra los nombres de los actores que tengan un actor_id entre 10 y 20. */
 
-- Nos pide los nombres (first_name) de los actores con actor_id entre 10 y 20, no se muy bien si 
-- quiere que el 10 y el 20 estén también incluidos. 

SELECT first_name
FROM actor 
WHERE actor_id BETWEEN 10 AND 20;

-- Tendriamos exactamente el mismo resultado usando un >= y <=

SELECT first_name
FROM actor 
WHERE actor_id >= 10 AND actor_id <= 20;


/* Ejercicio 8: Encuentra el título de las películas en la tabla film que no sean ni "R" ni "PG-13" en cuanto a su clasificación. */
 
-- Está pidiento el titulo (title) pero que no cumpla (NOT) dos condiciones concretas en la columna rating

SELECT title 
FROM film
WHERE NOT rating = 'PG-13' AND NOT rating = 'R'; 

 
/* Ejercicio 9: Encuentra la cantidad total de películas en cada clasificación de la tabla film y muestra la clasificación 
junto con el recuento. */
 
 -- Está pidiendo que agrupemos (GROUP BY) según la clasificación (rating) y calculemos la cantidad (COUNT) para cada grupo
 
 SELECT COUNT(film_id) AS films_by_rating, rating
 FROM film
 GROUP BY rating;
 
 
/* Ejercicio 10: Encuentra la cantidad total de películas alquiladas por cada cliente y muestra el ID del cliente, su nombre y
 apellido junto con la cantidad de películas alquiladas. */
 
-- Está pidiendo cantidad peliculas (COUNT) alquiladas por cada cliente (GROUP BY customer_id), customer_id, first_name y last_name
-- En customer tengo acceso a los datos de cada cliente, y está relacionada con rental por la columna customer_id 
-- En rental tengo acceso a cada alquiler de pelicula, no tengo el dato del nombre de la pelicula pero para este ejercicio no hace falta
-- Cada rental_id va relacionado con el alquiler de una sola pelicula, porque va a asociado a inventory_id que en la tabla inventory va asociado a film_id

SELECT COUNT(rental_id) AS films_rent_by_customer, customer_id, first_name, last_name
FROM customer
INNER JOIN rental
USING(customer_id)
GROUP BY customer_id; 

 
 /* Ejercicio 11: Encuentra la cantidad total de películas alquiladas por categoría y muestra el nombre de la categoría junto con el
 recuento de alquileres. */
 
-- Está pidiendo cantidad peliculas alquiladas (COUNT rental_id) según la categoria (GROUP BY category_id) mostrando el nombre de la categoria (name)
-- Para el ejercicio necesito tener acceso a los alquileres (rental_id) de la tabla rental, y categorias (rating) de la tabla film
-- Entre rental y film no hay relación directa, así que tendremos que usar la tabla inventory que tiene columnas en comun com ambas tablas 

SELECT COUNT(rental_id) AS films_rent_each_category, name
FROM rental
INNER JOIN inventory
USING (inventory_id)
INNER JOIN film_category
USING (film_id)
INNER JOIN category 
USING (category_id)
GROUP BY category_id;
 
 

/* Ejercicio 12: Encuentra el promedio de duración de las películas para cada clasificación de la tabla film y muestra la
 clasificación junto con el promedio de duración. */
 
-- Está pidiendo el promedio (AVG) de la duracion (length) de las peliculas para cada clasificacion (GROUP BY rating)

SELECT AVG (length) AS average_length, rating
FROM film
GROUP BY rating;


/* Ejercicio 13: Encuentra el nombre y apellido de los actores que aparecen en la película con title "Indian Love". */

-- Está pidiento nombre (first_name) y apellidos (last_name) de los actores con la condicion de que salgan en la pelicula Indian Love (title)
-- Para tener acceso a nombre y apellidos tenemos que usar la tabla actor
-- Para tener acceso al nombre de la pelicula tenemos que usar la tabla film
-- Como estas dos tablas no están directamente relacionados necesitamos una tabla intermedia, en este caso film_actor, que tiene conexion con ambas tablas

SELECT first_name, last_name
FROM actor
INNER JOIN film_actor
USING (actor_id)
INNER JOIN film
USING (film_id)
WHERE title = 'Indian Love';
 
 
/* Ejercicio 14: Muestra el título de todas las películas que contengan la palabra "dog" o "cat" en su descripción. */
 
-- Está pidiendo que busquemos en la tabla film o film_text las peliculas que cumplan la condicion de que cumpla un filtro concreto (que contenga dog o cat en su title)
 
SELECT title
FROM film
WHERE description LIKE '%dog%' OR description LIKE '%cat%';
 
-- Si lo hacemos sobre la tabla film_text tendremos mismo resultado

SELECT title
FROM film_text
WHERE description LIKE '%dog%' OR description LIKE '%cat%';


 
/* Ejercicio 15: Hay algún actor o actriz que no apareca en ninguna película en la tabla film_actor. */
 
-- Nos está pidiendo que verifiquemos si hay registros nulos de actores que no han participado en ninguna pelicula
-- Para ello usaré dos tablas, film_actor donde aparecen los id de los diferentes actores y film donde aparecen los titulos y id de las peliculas
-- Usando una tabla combinada miraré si para algún actor_id no hay registros asociados en film_id
 
SELECT actor_id, fa.film_id
FROM film_actor AS fa
LEFT JOIN film AS f
ON fa.film_id = f.film_id
WHERE fa.film_id IS NULL;

-- En este caso no muestra ningun resultado porque todos los actores salen en alguna pelicula, no hay registros huerfanos en la tabla combinada
 
/* Ejercicio 16: Encuentra el título de todas las películas que fueron lanzadas entre el año 2005 y 2010.*/

-- Está pidiendo el titulo (title) de las peliculas lanzadas entre el año 2005 y 2010 (release_year), no se si quiere que 2005 y 2010 esten incluidos
-- Toda esta informacion la tenemos en la tabla film

SELECT title 
FROM film
WHERE release_year BETWEEN 2005 AND 2010;

-- En este caso muestra todas las peliculas porque todas fueron lanzadas en el año 2006

 
 /* Ejercicio 17: Encuentra el título de todas las películas que son de la misma categoría que "Family". */
 
 -- Está pidiendo el titulo (title) de la tabla film o film_text, con la condicion de que sean de la categoria (name en la tabla category) Family
 -- Para ello tenemos que acceder a todas las tablas que necesitamos, en este caso film, category, y film_category
 -- Se podría hacer con JOIN usando las diferentes tablas necesarias, también con CTE's, en este caso lo voy a hacer con una subquery
 
 SELECT title 
 FROM film
 WHERE film_id IN (
	 SELECT film_id
     FROM film_category
     INNER JOIN category
     USING (category_id)
     WHERE name = 'family');
     

 /* Ejercicio 18: Muestra el nombre y apellido de los actores que aparecen en más de 10 películas.*/
 
 -- Está pidiendo informacion de la tabla actor, donde tenemos nombre y apellidos de los actores y la tabla film_actor, donde podemos acceder al film_id
 -- de las peliculas donde han trabajado. En este caso no tendríamos que usar la tabla film, porque no se nos pide el título de la película. 
 -- se podría hacer con una subquery, o usando un JOIN que junte las dos tablas, pero en este caso lo voy a hacer usando CTE's
 -- Se nos pide una condicion, que es que el recuento de peliculas en la que han aparecido sea mayor a 10
 
 WITH actor_film AS (SELECT first_name, last_name, film_id, actor_id   
 -- en la tabla actor_film selecciono lo que voy a necesitar para la consulta, en este caso first_name y last_name de los actores 
 -- porque los voy a tener que mostrar, film_id porque voy a necesitar hacer un recuento del numero de peliculas y actor_id porque voy a agruparlas por el actor_id
 FROM actor 
 INNER JOIN film_actor
 USING (actor_id))
 SELECT first_name, last_name
 FROM actor_film
 GROUP BY actor_id
 HAVING COUNT(film_id) > 10;

 
 /* Ejercicio 19: Encuentra el título de todas las películas que son "R" y tienen una duración mayor a 2 horas en la tabla film. */

-- Está pidiendo una doble condicion, en este caso que tenga una clasificacion (rating) R y ademas que tenga una duracion mayor a 2 horas (length > 120)
-- Se nos pide que mostremos solo el titulo (title)
-- En este caso tenemos todos los datos en una sola tabla (film)

SELECT title
FROM film
WHERE rating = 'R' AND length > 120;



/* Ejercicio 20: Encuentra las categorías de películas que tienen un promedio de duración superior a 120 minutos y muestra el
 nombre de la categoría junto con el promedio de duración. */
 
 -- Se nos pide calcular un promedio de duracion (AVG) por las peliculas agrupadas (GROUP BY) segun su categoria, y mostrar solo aquellas con una 
 -- duracion mayor a 120 minutos, mostrando también el nombre de la categoria (name)
 -- Para ello necesitamos usar tres tablas, film, donde tengo acceso a la duracion, film_category como tabla intermedia que me sirve de conexion entre
 -- film y category, y la ultima tabla es category, donde tengo acceso a las diferentes categorias según su name
 
 SELECT AVG (length), name
 FROM film
 INNER JOIN film_category
 USING (film_id)
 INNER JOIN category
 USING (category_id)
 GROUP BY name
 HAVING AVG(length) > 120;


/* Ejercicio 21: Encuentra los actores que han actuado en al menos 5 películas y muestra el nombre del actor junto con la
 cantidad de películas en las que han actuado. */
 
 -- Pide que mostremos nombre de actor (first_name) y el recuento de peliculas (COUNT film_id) de aquellos actores que hayan actuado en 5 o más peliculas
 -- Por como esta el enunciado, entiendo que el 5 en este caso sí estaría incluido en la consulta. 
 -- Para el ejercicio necesito usar la tabla actor, que tiene informacion del nombre del actor, y la tabla film_actor, que relaciona los actores con los 
 -- film_id de las peliculas en las que han actuado
 
 SELECT  first_name, COUNT(film_id) AS number_film_by_actor
 FROM film_actor
 INNER JOIN actor
 USING (actor_id)
 GROUP BY actor_id
 HAVING COUNT(film_id) >= 5;
 
 -- en este caso la consulta muestra a todos los actores, porque todos han participado en al menos 5 películas. 


/* Ejercicio 22: Encuentra el título de todas las películas que fueron alquiladas por más de 5 días. Utiliza una subconsulta para
 encontrar los rental_ids con una duración superior a 5 días y luego selecciona las películas correspondientes. */

-- Está pidiendo que calculemos el numero de días que la pelicula estuvo alquilada, para lo cual tenemos que calcular la diferencia (DATEDIFF) entre la fecha 
-- en que se alquiló y la fecha en la que se devolvió la pelicula, y que si cumple la condicion de que esta diferencia es > a 5 días se muestre el titulo de la pelicula
-- para el ejercicio se necesita usar la tabla rental, inventory y film, pues rental tiene informacion de fecha de alquiler y devolucion, 
-- inventory es nexo de rental y film, y film tiene los titulos de las peliculas

SELECT title
FROM film
WHERE film_id IN (
	SELECT film_id
    FROM inventory
    INNER JOIN rental
    USING(inventory_id)
    WHERE DATEDIFF(return_date, rental_date) > 5); -- En datediff debemos poner primero la fecha final, y despues la fecha inicial
    
-- Automaticamente, al usar la clausula IN en la consulta no se me devuelven titulos duplicados. 

 
 /* Ejercicio 23: Encuentra el nombre y apellido de los actores que no han actuado en ninguna película de la categoría "Horror".
Utiliza una subconsulta para encontrar los actores que han actuado en películas de la categoría "Horror" y luego
exclúyelos de la lista de actores. */
 
-- El ejercicio nos pide primero mediante una subconsulta filtrar los actores que han aparecido en peliculas de horror para finalmente descartarlos
-- para el ejercicio tenemos que usar la tabla actor (para obtener nombre y apellido de los actores), film_id (que muestra cada id de las peliculas
-- en las que ha actuado cada actor), film_category (que sirve de tabla intermedia para relacionar los film_id con los nombres de las categorias) y 
-- category (para filtrar por el nombre de la categoria que se nos pide, en este caso Horror). 

SELECT first_name, last_name 
FROM actor
WHERE actor_id NOT IN (
	SELECT actor_id
    FROM film_actor
    INNER JOIN film_category
    USING (film_id)
    INNER JOIN category
    USING(category_id)
    WHERE name = 'Horror');
 
 
 -- BONUS
 
/* Ejercicio 24:Encuentra el título de las películas que son comedias y tienen una duración mayor a 180 minutos en la
 tabla film. */
 
 -- Para el ejercicio necesito usar tabla category (donde tengo el id_categorias y su nombre), film_category (que relaciona el film_id con el category_id)
 -- y film (que relaciona film_id con el titulo de las peliculas)
 -- Como no especifica como hacerlo lo voy a usar utilizando una subconsulta.
 
SELECT title 
FROM film
WHERE film_id IN (
	SELECT film_id FROM sakila.film_category 
	INNER JOIN film
	USING (film_id)
    INNER JOIN (category)
    USING(category_id)
	WHERE name = 'Comedy' AND length > 180);
 
  
/* Ejercicio 25: Encuentra todos los actores que han actuado juntos en al menos una película. La consulta debe
 mostrar el nombre y apellido de los actores y el número de películas en las que han actuado juntos. */
 
 -- Necesito utilizar la tabla actor (que tiene info de actor_id y nombre y apellidos de cada actor), la tabla 
 -- film_actor (que relaciona los actor_id con los film_id de las peliculas en las que ha participado cada actor
 -- En este caso la tabla film no sería necesario utilizarla porque no se nos pide el titulo de las peliculas, por lo que 
 -- con film_id es suficiente. 
 
 -- Lo primero que hago es una tabla para esta consulta mediante CTE's, para poder despues hacer un 
 -- self join con esta tabla, donde realizo un recuento del numero de peliculas en comun (COUNT film_id) entre diferentes actor_id
 -- para hacer el self join es necesario el uso de alias
 
WITH actor_same_film AS (SELECT actor_id, first_name, last_name, film_id FROM actor INNER JOIN film_actor USING (actor_id))
SELECT DISTINCT CONCAT (asf1.first_name, ' ', asf1.last_name) AS actor1, CONCAT(asf2.first_name, ' ', asf2.last_name)AS actor2, COUNT(asf1.film_id) AS common_films
FROM actor_same_film AS asf1, actor_same_film AS asf2
WHERE asf1.actor_id <> asf2.actor_id
AND asf1.film_id = asf2.film_id
GROUP BY asf1.actor_id, asf2.actor_id


 
 
 