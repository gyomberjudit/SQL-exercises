CREATE TABLE pizza (
    pizza_id SERIAL PRIMARY KEY, 
    name VARCHAR(30),
    price INT
);
CREATE TABLE courier (
    courier_id SERIAL PRIMARY KEY, 
    name VARCHAR(30),
    phone_number INT
);
CREATE TABLE customer (
    customer_id SERIAL PRIMARY KEY, 
    name VARCHAR(30),
    address VARCHAR(50)
);
CREATE TABLE orders (
    id SERIAL PRIMARY KEY, 
    courier_id INT,
    customer_id INT,
    pizza_id INT,
    qty INT
);

SELECT * FROM pizza;
SELECT * FROM courier;
SELECT * FROM customer;
SELECT * FROM orders;

ALTER TABLE orders 
ADD 
CONSTRAINT FK_orders_courier
FOREIGN KEY (courier_id)
REFERENCES courier(courier_id);

ALTER TABLE orders 
ADD 
CONSTRAINT FK_orders_pizza
FOREIGN KEY (pizza_id)
REFERENCES pizza(pizza_id);

ALTER TABLE orders 
ADD 
CONSTRAINT FK_orders_customer
FOREIGN KEY (customer_id)
REFERENCES customer(customer_id);

INSERT INTO pizza (name, price) 
VALUES ('Hawai', 3000), ('Songoku', 3500), ('Pacalos', 10000);

INSERT INTO courier (name, phone_number) 
VALUES ('Gyuri', 1234), ('Pisti', 5678), ('Rozi', 1357);

INSERT INTO customer (name, address) 
VALUES ('Sári', 'Budapest'), ('Vivi', 'Miskolc'), ('Tomi', 'Nagykanizsa');

INSERT INTO orders (courier_id, customer_id, pizza_id, qty) VALUES (3, 2, 2, 3);
INSERT INTO orders (courier_id, customer_id, pizza_id, qty) VALUES (1, 2, 1, 4);
INSERT INTO orders (courier_id, customer_id, pizza_id, qty) VALUES (1, 1, 3, 6);
INSERT INTO orders (courier_id, customer_id, pizza_id, qty) VALUES (2, 1, 1, 2);
INSERT INTO orders (courier_id, customer_id, pizza_id, qty) VALUES (3, 2, 3, 1);
INSERT INTO orders (courier_id, customer_id, pizza_id, qty) VALUES (2, 3, 3, 1);

ALTER TABLE  orders ADD date DATE;
ALTER TABLE  orders ADD delivery_date DATE DEFAULT now();
INSERT INTO orders (date) VALUES (now());

DELETE FROM orders WHERE id=9;

UPDATE orders SET date = now();

UPDATE orders SET id=1 WHERE id=3;
UPDATE orders SET id=2 WHERE id=4;
UPDATE orders SET id=3 WHERE id=5;
UPDATE orders SET id=4 WHERE id=6;
UPDATE orders SET id=5 WHERE id=7;
UPDATE orders SET id=6 WHERE id=8;

SELECT * FROM pizza;
SELECT * FROM courier;
SELECT * FROM customer;
SELECT * FROM orders;

--Melyik pizza olcsóbb 3000 Ft-nál?
SELECT * FROM pizza WHERE price <= 3000;

--Ki szállította házhoz az 1. számú rendelést?
SELECT courier.name, orders.id 
FROM courier 
INNER JOIN orders 
ON courier.courier_id = orders.courier_id
WHERE orders.id = 1;

--Milyen pizzát evett Sári?
SELECT pizza.name, customer.name 
FROM orders 
INNER JOIN pizza ON orders.pizza_id = pizza.pizza_id
INNER JOIN customer ON orders.customer_id = customer.customer_id
WHERE customer.name = 'Sári';


SELECT pizza.name, customer.name 
FROM orders 
JOIN pizza ON orders.pizza_id = pizza.pizza_id
JOIN customer ON orders.customer_id = customer.customer_id
WHERE customer.name ILIKE 'sári';

--Melyik pizza ára van 2500 és 6000 Ft között?
SELECT name, price FROM pizza 
WHERE price BETWEEN 2500 AND 6000;

SELECT name AS pizza, price FROM pizza 
WHERE price BETWEEN 2500 AND 6000;

--Hány pizzát evett Vivi?
SELECT customer.name, SUM(orders.qty)
FROM customer
INNER JOIN orders 
ON customer.customer_id = orders.customer_id
WHERE customer.name = 'Vivi'
GROUP BY customer.name;

--Ki szállított házhoz Vivinek?
SELECT courier.name, customer.name
FROM orders
INNER JOIN courier ON orders.courier_id = courier.courier_id
INNER JOIN customer ON orders.customer_id = customer.customer_id
WHERE customer.name = 'Vivi'
GROUP BY courier.name, customer.name ;


--Az egyes rendelések során ki kinek szállított házhoz?
SELECT courier.name, customer.name
FROM orders
INNER JOIN courier ON orders.courier_id = courier.courier_id
INNER JOIN customer ON orders.customer_id = customer.customer_id
GROUP BY courier.name, customer.name;

--Mennyit költött pizzára Vivi?   !!!!!!!!!!!!!!!!!!!!!!!!!!!
SELECT customer.name, SUM(pizza.price)
FROM orders
INNER JOIN pizza ON orders.pizza_id = pizza.pizza_id
INNER JOIN customer ON orders.customer_id = customer.customer_id
WHERE customer.name = 'Vivi'
GROUP BY customer.name;


--Hány alkalommal rendeltek Hawai pizzát?
SELECT pizza.name, COUNT(orders.pizza_id)
FROM orders
INNER JOIN pizza ON orders.pizza_id = pizza.pizza_id
WHERE pizza.name = 'Hawai'
GROUP BY pizza.name;

--Hány db pacalos pizza fogyott összesen?
SELECT pizza.name, SUM(orders.qty)
FROM orders
INNER JOIN pizza ON orders.pizza_id = pizza.pizza_id
WHERE pizza.name = 'Pacalos'
GROUP BY pizza.name;


--Mennyit költöttek pizzára az egyes vevők?  !!!!!!!!!!!!!!!!!!!!
SELECT customer.name, SUM(pizza.price)
FROM orders
INNER JOIN pizza ON orders.pizza_id = pizza.pizza_id
INNER JOIN customer ON orders.customer_id = customer.customer_id
GROUP BY customer.name;
 
--Ki hány pizzát szállított házhoz összesen?
SELECT courier.name, SUM(orders.qty)
FROM courier
INNER JOIN orders ON orders.courier_id = courier.courier_id
GROUP BY courier.name;

--A fogyasztás alapján mi a pizzák népszerűségi sorrendje?
SELECT pizza.name, SUM(orders.qty)
FROM pizza
INNER JOIN orders ON orders.pizza_id = pizza.pizza_id
GROUP BY pizza.name
ORDER BY SUM(orders.qty) DESC;

--A rendelések összértéke alapján mi a vevők sorrendje?
SELECT customer.name, SUM(pizza.price)
FROM orders
INNER JOIN pizza ON orders.pizza_id = pizza.pizza_id
INNER JOIN customer ON orders.customer_id = customer.customer_id
GROUP BY customer.name
ORDER BY SUM(pizza.price) DESC;

--Melyik a legdrágább pizza?
SELECT name, price FROM pizza
ORDER BY price DESC
LIMIT 1;

--Ki szállította házhoz a legtöbb pizzát?
SELECT courier.name, SUM(orders.qty)
FROM courier
INNER JOIN orders
ON orders.courier_id = courier.courier_id
GROUP BY courier.name
ORDER BY SUM(orders.qty) DESC
LIMIT 1;

--Ki ette a legtöbb pizzát?
SELECT customer.name, SUM(orders.qty) 
FROM customer
INNER JOIN orders
ON orders.customer_id = customer.customer_id
GROUP BY customer.name
ORDER BY SUM(orders.qty) DESC
Limit 1;