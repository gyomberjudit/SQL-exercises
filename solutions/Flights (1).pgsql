DROP TABLE IF EXISTS flight;
DROP TABLE IF EXISTS person;
DROP TABLE IF EXISTS city;

-- adatbázis létrehozása:

CREATE DATABASE flights;

-- táblák ltérehozása:
-- FlightID-t lehetett volna SERIAL típussal és nem INT-tel

CREATE TABLE Flight(
    FlightID int primary key,
    CityFrom int,
    FlightNo varchar(6)
);

CREATE TABLE Person(
    PersonID int primary key,
    Name varchar(30),
    Phone varchar(12),
    FlightID int,
    Seat varchar(4),
    CONSTRAINT FK_flightID foreign KEY (FlightID) REFERENCES Flight(FlightID)
);

CREATE TABLE City(
    CityID int primary key,
    Name varchar(50)
);

-- első táblánál még nem tudtuk létrehozni a foreign keyt, mert még nem létezett akkor még a második tábla, 
-- úgyhogy most hozzuk létre:

ALTER TABLE Flight
ADD CONSTRAINT FK_Flight_CityFrom
FOREIGN KEY (CityFrom) REFERENCES City(CityID);

-- táblák feltöltése adatokkal:

INSERT INTO City (CityID, Name)
VALUES (1, 'London'), (2, 'Budapest');


INSERT INTO Flight (FlightID, CityFrom, FlightNo)
VALUES (1, 1, 'LON123'), (2, 2, 'BUD456');

--lekérdezés:

SELECT * FROM City;
SELECT * FROM Flight;
SELECT * FROM Person;

-- Flight tábla kiegészítése egy új oszloppal (CityTo):

ALTER TABLE Flight
    ADD CityTo int,
    ADD CONSTRAINT FK_CityID FOREIGN KEY (CityTo) REFERENCES City(CityID);

-- Flight tábla CityTo új oszlopának adatokkal való feltöltése:

UPDATE Flight SET CityTo = 2 WHERE FlighTID = 1;
UPDATE Flight SET CityTo = 1 WHERE FlighTID = 2;

-- JOIN-os SELECT
-- EGYEDI NÉV MEGADÁSA
-- összekötjük a táblákat, megjelenik minden, a város neveit kiiratjuk 
-- (ronda forma, minden összerendelt tábla oszlopa látszik):

SELECT *
FROM Flight
INNER JOIN city T0
ON Flight.CityFrom = T0.CityID
INNER JOIN city T1
ON FLight.CityTo = T1.CityID;

-- JOIN-os SELECT
-- EGYEDI NÉV MEGADÁSA
-- összekötjük a táblákat, megjelenik minden, a város neveit kiiratjuk (szép forma):

SELECT Flight.FlightNo, T0.Name AS Departure, T1.Name AS Arrival
FROM Flight
INNER JOIN city T0
ON Flight.CityFrom = T0.CityID
INNER JOIN city T1
ON FLight.CityTo = T1.CityID;


-- Flight táblához date adattípusú új oszlop (DateFrom) hozzáadása

ALTER TABLE flight
ADD DateFrom date;

-- adatokkal való feltöltése (minden sornak ugyanazt a dátumot adjuk):

UPDATE flight
SET DateFrom = '2022-11-01';


-- default érték megadása a mostani dátummal:

ALTER TABLE flight
ADD DateTo date Default now();


-- adatokkal való feltöltés:
INSERT INTO person
VALUES (1, 'Janos', '06301234', 1, '55'),
(2, 'Lilla', '0618767', 2, '11');


-- 3 db JOIN:
SELECT Flight.FlightNo, T0.Name AS Departure, T1.Name AS Arrival,
Person.Name, Person.Seat
FROM Flight
INNER JOIN city T0
ON Flight.CityFrom = T0.CityID
INNER JOIN city T1
ON FLight.CityTo = T1.CityID
INNER JOIN Person ON Flight.FlightID = Person.FlightID;


-- meglévő táblából (Person) kitöröljük a Telefonszám mezőt
-- a DROP a tábla egy elemét törli ki (oszlopot) és nem rekordot!! A tábla struktúráját változtatja meg a drop.

ALTER TABLE Person drop Phone;


-- rekord törlése (DELETE):

DELETE FROM Person WHERE Name = 'Lilla';


-- Flightok közül mindegyik látszódjon, az is amelyiken nem utazik személy:
-- LEFT JOIN
SELECT Flight.FlightNo, T0.Name AS Departure, T1.Name AS Arrival,
Person.Name, Person.Seat
FROM Flight
INNER JOIN city T0
ON Flight.CityFrom = T0.CityID
INNER JOIN city T1
ON FLight.CityTo = T1.CityID
LEFT JOIN Person ON Flight.FlightID = Person.FlightID;


-- a fenti rendezve:
SELECT Flight.FlightNo, T0.Name AS Departure, T1.Name AS Arrival,
Person.Name, Person.Seat
FROM Flight
INNER JOIN city T0
ON Flight.CityFrom = T0.CityID
INNER JOIN city T1
ON FLight.CityTo = T1.CityID
LEFT JOIN Person ON Flight.FlightID = Person.FlightID
ORDER BY T0.Name Desc;


--azon járatok kilistázása, amelyik járatszámában benne van hogy '12':

SELECT Flight.FlightNo 
FROM Flight
WHERE FlightNo LIKE '%12%';

-- számoljuk meg hány járatunk van:

SELECT count(Flight.FlightID) AS total FROM Flight;

-- járatszámonként adjuk meg, hogy hány darab járat van:

SELECT Flight.FlightNo, count(Flight.FlightID) as járatok_száma
FROM flight
GROUP BY Flight.FlightNo;


-- FILTER: azokat listázza ki, ahol a COUNT kisebb, egyenlő mint 1:

SELECT Flight.FlightNo, count(Flight.FlightID) as járatok_száma
FROM flight
GROUP BY Flight.FlightNo
HAVING count(Flight.FlightID) <= 1;
