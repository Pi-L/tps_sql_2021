
-- 1
-- PI name (world.country) SIGMA population > 100000000 (world.country)
SELECT name FROM country WHERE population > 100000000;

-- 2
-- PI region (world.country)
SELECT DISTINCT region as nomRegion FROM country; 

-- 3
--
SELECT DISTINCT region as nomRegion FROM country
WHERE continent = 'Europe';