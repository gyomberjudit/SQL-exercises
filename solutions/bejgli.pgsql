CREATE TABLE bejgli(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    price INT
);

CREATE TABLE department(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    phone_number INT
);

CREATE TABLE people(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    department_id INT,
    CONSTRAINT FK_department_people FOREIGN KEY (department_id) 
    REFERENCES department(id)
);

CREATE TABLE orders2(
    id SERIAL PRIMARY KEY,
    people_id INT,
    bejgli_id INT,
    qty INT,
    CONSTRAINT FK_people_orders FOREIGN KEY (people_id)
    REFERENCES people(id),
    CONSTRAINT FK_bejgli_orders FOREIGN KEY (bejgli_id)
    REFERENCES bejgli(id)
);

INSERT INTO bejgli (name,price) VALUES ('makos',400),('dios',600),('fahejas',200);
INSERT INTO department (name,phone_number) VALUES ('pekseg',12345),('edesseg',54321);
INSERT INTO people (name,department_id) VALUES ('Kati',2),('Beni',1),('Panni',1),('Feri',2);
INSERT INTO orders2 (people_id,bejgli_id,qty) VALUES (1,2,4),(2,1,5),(3,3,3),(4,2,2),(2,2,3);


SELECT * FROM bejgli;
SELECT * FROM department;
SELECT * FROM people;
SELECT * FROM orders2;

--új mezőt adunk hozzá a táblázathoz, default értéke a mai dátum
ALTER TABLE orders2 ADD date DATE DEFAULT now();

--Kik rendeltek a bejgliből?
SELECT people.name, COUNT(orders2.id)
FROM people
INNER JOIN orders2
ON people.id=orders2.people_id
GROUP BY people.name;

--Milyen bejglik közül lehet rendelni, és mennyibe kerülnek?
SELECT name,price FROM bejgli;

--Melyik bejgli olcsóbb, mint x Ft-nál?
SELECT name,price FROM bejgli 
WHERE price<500;

SELECT name,price FROM bejgli 
WHERE price<300;

SELECT name,price FROM bejgli 
WHERE price>200;


--Melyik osztályról kérték a legtöbb bejglit? Rakd sorba az osztályokat a bejglik száma alapján!
SELECT department.name, SUM(orders2.qty)
FROM people
INNER JOIN department ON department.id=people.department_id 
INNER JOIN orders2 ON orders2.people_id=people.id
GROUP BY department.name
ORDER BY SUM(orders2.qty) DESC
LIMIT 1;


--Melyik bejgli ára van xFt és xFt között?
SELECT name,price FROM bejgli
WHERE 300<price AND price<800;

SELECT name,price FROM bejgli
WHERE price BETWEEN 300 AND 800;

--Milyen bejgliket rendelt Kati?
SELECT people.name, bejgli.name
FROM orders2
INNER JOIN people ON orders2.people_id=people.id
INNER JOIN bejgli ON orders2.bejgli_id=bejgli.id
WHERE people.name='Kati';

--Melyik osztályon dolgozik Kati?
SELECT people.name, department.name
From people 
INNER JOIN department
ON people.department_id=department.id
WHERE people.name='Kati';

--Mennyit költött bejglire Kati?
SELECT people.name, bejgli.price*orders2.qty AS payment
FROM orders2
INNER JOIN people ON orders2.people_id=people.id
INNER JOIN bejgli ON orders2.bejgli_id=bejgli.id
WHERE people.name='Kati';

SELECT people.name, SUM(bejgli.price*orders2.qty) AS payment
FROM orders2
INNER JOIN people ON orders2.people_id=people.id
INNER JOIN bejgli ON orders2.bejgli_id=bejgli.id
WHERE people.name='Beni'
GROUP BY people.name;

--Hány alkalommal rendelt valaki mákosbejglit?
SELECT COUNT(orders2.id) AS How_many_times, bejgli.name
FROM orders2
INNER JOIN bejgli
ON orders2.bejgli_id=bejgli.id
WHERE bejgli.name='makos'
GROUP BY bejgli.name;

SELECT COUNT(orders2.id) AS How_many_times, bejgli.name
FROM orders2
INNER JOIN bejgli
ON orders2.bejgli_id=bejgli.id
WHERE bejgli.name='dios'
GROUP BY bejgli.name;

--Hány bejglit rendelt Beni?
SELECT people.name, SUM(orders2.qty)
FROM people
INNER JOIN orders2
ON people.id=orders2.people_id
WHERE people.name='Beni'
GROUP BY people.name;

--Hány darab diós bejgli fogyott összesen?
SELECT bejgli.name, SUM(orders2.qty)
FROM bejgli
INNER JOIN orders2
ON bejgli.id=orders2.bejgli_id
WHERE bejgli.name='dios'
GROUP BY bejgli.name;

--Mennyit költöttek bejglire az egyes vevők?
SELECT people.name, SUM(bejgli.price*orders2.qty) AS payment
FROM orders2
INNER JOIN bejgli ON orders2.bejgli_id=bejgli.id
INNER JOIN people ON orders2.people_id=people.id
GROUP BY people.name;


--Melyik osztály mennyi bejglit rendelt összesen??
SELECT department.name, SUM(orders2.qty)
FROM people
INNER JOIN department ON people.department_id=department.id
INNER JOIN orders2 ON people.id=orders2.people_id
GROUP BY department.name;

--A fogyasztás alapján mi a bejglik népszerűségi sorrendje?
SELECT SUM(orders2.qty), bejgli.name
FROM orders2
INNER JOIN bejgli
ON orders2.bejgli_id=bejgli.id
GROUP BY bejgli.name 
ORDER BY SUM(orders2.qty) DESC;

--Melyik a legdrágább bejgli?
SELECT name, price FROM bejgli 
ORDER BY price DESC
LIMIT 1;

--Ki ette a legtöbb bejglit
SELECT people.name, SUM(orders2.qty)
FROM people
INNER JOIN orders2
ON people.id=orders2.people_id
GROUP BY people.name
ORDER BY SUM(orders2.qty) DESC
LIMIT 1;