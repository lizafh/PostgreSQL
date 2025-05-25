
CREATE TABLE rangers(
ranger_id SERIAL PRIMARY KEY,
name VARCHAR(60) NOT NULL,
region VARCHAR(50) NOT NULL
);

INSERT INTO rangers(name,region) VALUES
( 'Alice Green','Northern Hills'),
('Bob White','River Delta '),
('Carol King','Mountain Range');

SELECT * FROM rangers;

CREATE TABLE species(

 species_id SERIAL PRIMARY KEY,
 common_name VARCHAR(50) NOT NULL,
 scientific_name VARCHAR(60) NOT NULL,
 discovery_date DATE NOT NULL,
 conservation_status VARCHAR(50) NOT NULL
);

INSERT INTO species(common_name,scientific_name,discovery_date,conservation_status) VALUES
('Snow Leopard','Panthera uncia','1775-01-01','Endangered'),
('Bengal Tiger','Panthera tigris tigris','1758-01-01','Endangered'),
('Red Panda','Ailurus fulgens',' 1825-01-01','Vulnerable'),
('Asiatic Elephant','Elephas maximus indicus','1758-01-01','Endangered');

SELECT * FROM species;

CREATE TABLE sightings(
sighting_id SERIAL PRIMARY KEY,
species_id INT REFERENCES species(species_id),
ranger_id INT REFERENCES rangers(ranger_id),

sighting_time TIMESTAMP without time zone NOT NULL,
location VARCHAR(50) NOT NULL,
notes TEXT DEFAULT NULL

);
SELECT * from sightings;
INSERT INTO sightings(species_id,ranger_id,location,sighting_time,notes) VALUES
(1,1,'Peak Ridge','2024-05-10 07:45:00','Camera trap image captured'),
(2,2,'Bankwood Area','2024-05-12 16:20:00','Juvenile seen '),
(3,3,'Bamboo Grove East','2024-05-15 09:10:00','Feeding observed');

INSERT INTO sightings(species_id,ranger_id,location,sighting_time) VALUES(1,2,'Snowfall Pass','2024-05-18 18:30:00');

SELECT * FROM sightings;
-- problem 1-----------------------------
drop TABLE sightings;
INSERT INTO rangers(ranger_id,name,region) VALUES
(4,'Derek Fox','Coastal Plains');

-- problem 2-------------------

SELECT count(DISTINCT species_id) as unique_species_count FROM sightings;

-- problem 3--------------------------

SELECT * from sightings;
SELECT * from sightings
WHERE location LIKE '%Pass%';

-- problem 4-----------------------

SELECT name, count(*) as total_sightings FROM rangers
join sightings USING(ranger_id)
GROUP BY ranger_id ORDER BY name;

-- problem 5-----------------------------
-- SELECT species_id FROM sightings;

 SELECT common_name from species
 where species_id NOT IN(SELECT species_id FROM sightings);

-- problem 6---------------

SELECT  common_name,sighting_time,name FROM sightings 
JOIN species USING (species_id)
JOIN rangers USING (ranger_id)
ORDER BY sighting_time desc
LIMIT 2;  

-- problem 7----------------

UPDATE species
set conservation_status = 'Historic'
WHERE EXTRACT(YEAR FROM discovery_date) < 1800;

-- problem 8--------------------

SELECT sighting_id,
CASE 
    WHEN EXTRACT(HOUR from sighting_time) <12 THEN 'Morning'
    WHEN EXTRACT(HOUR from sighting_time) >= 12 AND EXTRACT(HOUR from sighting_time) <= 17 THEN 'Afternoon'
    ELSE 'Evening'  
END AS time_of_day  FROM sightings;

-- problem 9------------------

-- SELECT DISTINCT ranger_id FROM sightings
--  WHERE ranger_id IS NOT NULL;

DELETE FROM rangers
WHERE ranger_id NOT IN(SELECT DISTINCT ranger_id FROM sightings
WHERE ranger_id IS NOT NULL);







