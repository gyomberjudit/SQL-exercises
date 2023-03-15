CREATE TABLE breads(
    id SERIAL PRIMARY KEY,
    type VARCHAR(30)
);

CREATE TABLE dogs(
    id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    age INT,
    bread_id INT,
    CONSTRAINT FK_dogsbreads
    FOREIGN KEY (bread_id) REFERENCES breads(id)
);

CREATE TABLE tricks(
    id SERIAL PRIMARY KEY,
    name VARCHAR(20),
    difficulty INT
);

CREATE TABLE people(
    id SERIAL PRIMARY KEY,
    name VARCHAR(30),
    phone_nr INT
);

CREATE TABLE shows(
    id SERIAL PRIMARY KEY,
    tricks_id INT,
    dog_id INT,
    teacher_id INT,
    CONSTRAINT FK_tcicksshows
    FOREIGN KEY (tricks_id) REFERENCES tricks(id),
    CONSTRAINT FK_dogsshows
    FOREIGN KEY (dog_id) REFERENCES dogs(id),
    CONSTRAINT FK_peopleshows
    FOREIGN KEY (teacher_id) REFERENCES people(id)
);

INSERT INTO breads (type) VALUES
('Vizskla'),('Beagle'),('Akita'),('Havanese');

INSERT INTO dogs (name,age,bread_id) VALUES
('Dio',9,4),('Ropi',5,1),('Ubul',4,2),('Kiwi',1,3),('Furge',10,1);

INSERT INTO tricks (name,difficulty) VALUES
('Sit',1),('Hi5',3),('Hurka',5),('Spanyol',10);

INSERT INTO people (name,phone_nr) VALUES
('Tamás',123),('Judit',321),('Gyongyver',456),('Andi',666);

INSERT INTO shows (tricks_id,dog_id,teacher_id) VALUES
(1,1,2),(2,3,1),(3,1,4),(3,4,1),(1,1,1);

SELECT * FROM breads;
SELECT * FROM dogs;
SELECT * FROM tricks;
SELECT * FROM people;
SELECT * FROM shows;

UPDATE breads SET type='Vizsla' WHERE id=1;

--4. Módosítsd a dogs táblát és add hozzá az owner_id mezőt! + constraint people_i
ALTER TABLE dogs ADD owner_id INT;

ALTER TABLE dogs 
ADD CONSTRAINT FK_dogsowner
FOREIGN KEY (owner_id)
REFERENCES people(id);

--5. Töltsd fel az owner_id mezőt!
UPDATE dogs SET owner_id = 1 WHERE dogs.id = 1;  
UPDATE dogs SET owner_id = 2 WHERE dogs.id = 2;  
UPDATE dogs SET owner_id = 3 WHERE dogs.id = 3;  
UPDATE dogs SET owner_id = 4 WHERE dogs.id = 4;  
UPDATE dogs SET owner_id = 4 WHERE dogs.id = 5;  

--6. Töröld ki a phone_nr oszlopot
ALTER TABLE people DROP COLUMN phone_nr;

--7. Melyik kutyának ki a gazdája? Rendezd a kutyák neve alapján abc
--sorrendbe, másodlagosan a gazdik neve alapján
SELECT dogs.name, people.name
FROM dogs
INNER JOIN people
ON dogs.owner_id = people.id
ORDER BY dogs.name, people.name;

--8. Melyik kutya melyik trükköket tudja?
SELECT dogs.name, tricks.name
FROM shows
INNER JOIN dogs ON shows.dog_id=dogs.id
INNER JOIN tricks ON shows.tricks_id=tricks.id;

--9. Melyik kutya tudja a legtöbb trükköt?
SELECT dogs.name, COUNT(tricks.id) AS trick_no
FROM shows
INNER JOIN dogs ON shows.dog_id=dogs.id
INNER JOIN tricks ON shows.tricks_id=tricks.id
GROUP BY dogs.name
ORDER BY COUNT(DISTINCT tricks.name) DESC --DISTINCT-TEL SEM JÓ
LIMIT 1;

--10. Melyik kutya milyen fajtájú?
SELECT dogs.name, breads.type
FROM dogs 
INNER JOIN breads ON dogs.bread_id = breads.id;

--11.Melyik gazdi tanította az 1 id-jú kutyát leülni?
SELECT people.name
FROM people
INNER JOIN shows ON people.id = shows.teacher_id
WHERE shows.dog_id = 1 AND shows.tricks_id = 1;

SELECT people.name
FROM shows
INNER JOIN people ON people.id = shows.teacher_id
INNER JOIN dogs ON dogs.id = shows.dog_id
INNER JOIN tricks ON tricks.id = shows.tricks_id
WHERE dogs.id = 1 AND tricks.id=1;

--12. Melyik a legnehezebb/legkönnyebb trükk?
--legnehezebb:
SELECT name, difficulty
FROM tricks
ORDER BY difficulty DESC
LIMIT 1;

--legkönnyebb:
SELECT name, difficulty
FROM tricks
ORDER BY difficulty 
LIMIT 1;

--13. Hány különböző fajta kutya van?
SELECT COUNT(id)
FROM breads;

SELECT COUNT(type)
FROM breads;

--14. Átlagosan milyen nehéz trükköket tud a (3) 1 id-jú kutyus?
SELECT dogs.name, AVG(tricks.difficulty)
FROM shows
INNER JOIN dogs ON dogs.id = shows.dog_id
INNER JOIN tricks ON tricks.id = shows.tricks_id
WHERE dogs.id = 3
GROUP BY dogs.name;

SELECT dogs.name, AVG(DISTINCT tricks.difficulty)
FROM shows
INNER JOIN dogs ON dogs.id = shows.dog_id
INNER JOIN tricks ON tricks.id = shows.tricks_id
WHERE dogs.id = 1
GROUP BY dogs.name;

SELECT dogs.name, AVG(tricks.difficulty)
FROM shows
INNER JOIN dogs ON dogs.id = shows.dog_id
INNER JOIN tricks ON tricks.id = shows.tricks_id
WHERE dogs.id = 1
GROUP BY dogs.name;


--15. Melyik a legnehezebb trükk, amit (a 3-as) az 1-es id kutyus megtanult?
--(legyen benne a kutya neve és a trükk nehézsége)
SELECT dogs.name, tricks.difficulty
FROM shows
INNER JOIN dogs ON dogs.id = shows.dog_id
INNER JOIN tricks ON tricks.id = shows.tricks_id
WHERE dogs.id = 3
ORDER BY tricks.difficulty DESC
LIMIT 1;

SELECT dogs.name, tricks.difficulty
FROM shows
INNER JOIN dogs ON dogs.id = shows.dog_id
INNER JOIN tricks ON tricks.id = shows.tricks_id
WHERE dogs.id = 1
ORDER BY tricks.difficulty DESC
LIMIT 1;

