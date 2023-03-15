CREATE TABLE fruits (
    id SERIAL PRIMARY KEY,
    fruit_name VARCHAR(50)
);

CREATE TABLE people (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50)
);

CREATE TABLE jams (
    id SERIAL PRIMARY KEY, 
    fruit_name INT2,
    people_name INT2,
    quantity INT2
);

ALTER TABLE jams 
ADD CONSTRAINT FK_jams_fruits FOREIGN KEY (fruit_name) REFERENCES fruits(id);

ALTER TABLE jams
ADD CONSTRAINT FK_jams_people FOREIGN KEY (people_name) REFERENCES people(id);

DROP TABLE jams;

INSERT INTO fruits (fruit_name) VALUES ('eper'), ('meggy'), ('barack'), ('szeder');
INSERT INTO people (name) VALUES ('nagyi'), ('pap'), ('James');
INSERT INTO jams (INSERTfruit_name, people_name, quantity) VALUES (3, 1, 15), (1, 3, 5), (3, 2, 2), (4, 3, 5), (1, 1, 12);

SELECT * FROM fruits;
SELECT * FROM people;
SELECT * FROM jams;

SELECT * FROM jams JOIN people ON jams.people_name = people.id;

SELECT fruits.fruit_name, jams.quantity, people.name
FROM jams
JOIN people ON jams.people_name = people.id
JOIN fruits ON jams.fruit_name = fruits.id;

SELECT people.name, SUM(jams.quantity) AS total
FROM jams 
JOIN people ON jams.people_name = people.id
WHERE people.name = 'nagyi'
GROUP BY people.name;

SELECT people_name, COUNT(fruit_name)
FROM jams GROUP BY people_name
HAVING people_name = 3;


SELECT jams.people_name, people.name, COUNT(jams.fruit_name)
FROM jams 
JOIN people ON jams.people_name = people.id
GROUP BY jams.people_name, people.name
HAVING people_name = 3;

SELECT people.name, COUNT(jams.fruit_name)
FROM jams 
JOIN people ON jams.people_name = people.id
WHERE people.id = 3
GROUP BY jams.people_name, people.name;


SELECT people.name, SUM(jams.quantity) AS quantity
FROM jams 
JOIN people ON jams.people_name = people.id
GROUP BY people.name
ORDER BY quantity DESC;

SELECT people.name, SUM(jams.quantity) AS quantity
FROM jams 
JOIN people ON jams.people_name = people.id
GROUP BY people.name
ORDER BY people.name ASC, quantity DESC;
