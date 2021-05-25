
-- 1
-- RA -- Π name (world.country) σ population > 100000000 (world.country)
SELECT name FROM country WHERE population > 100000000;

-- 2
-- RA -- Π region (world.country)
SELECT DISTINCT region as nomRegion FROM country; 

-- 3
-- RA -- Π region ρ(nomRegion/region) (world.country) σ continent = Europe (world.country)
SELECT DISTINCT region as nomRegion 
	FROM country 
	WHERE continent = 'Europe';

-- 4
-- RA -- 
SELECT * FROM country WHERE region = 'Southern Europe';

-- 5
-- RA -- 
SELECT capital FROM country 
	WHERE region = 'Western Europe';


-- 5 bis -- my join didn't work :(
-- RA --
SELECT data_type as capitalType FROM information_schema.columns
	WHERE table_name = 'country' AND column_name = 'capital';


-- 6
-- RA --
SELECT DISTINCT language FROM countrylanguage WHERE isofficial ORDER BY language ASC;

-- 7
-- RA --


