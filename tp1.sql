
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
SELECT countrycode FROM countrylanguage 
	WHERE language = 'French' 
		AND isofficial 
	ORDER BY countrycode ASC;

-- 8
-- RA --
SELECT name, indepyear AS independanceYear FROM country
	WHERE name = 'France';

-- 9
-- RA -- 
SELECT name, coalesce(indepyear, 2042) AS independanceYear FROM country
	WHERE continent = 'Europe'
	ORDER BY independanceYear ASC;

-- 10
-- RA --
SELECT ROW_NUMBER() OVER (ORDER BY population DESC) AS classement,
		name 
	FROM city
	WHERE countrycode = 'FRA' AND population > 100000
	ORDER BY population DESC;

-- 11
-- RA --
SELECT name, 
		ROUND(population / surfacearea::decimal, 2) AS densite, 
		ROUND(gnp * 1000000 / population, 2) AS gdppc,
		lifeexpectancy
	FROM country
	WHERE continent = 'Europe'
	ORDER BY densite DESC;


-- 12
-- RA --
SELECT name, 
		lifeexpectancy,
		(gnp / population)
	FROM country
	WHERE NOT lifeexpectancy < 77
			AND NOT (gnp / population) > 0.01
	ORDER BY lifeexpectancy DESC;


-- 13 
-- RA --
SELECT name, 
		lifeexpectancy,
		(gnp / population)
	FROM country
	WHERE NOT (lifeexpectancy >= 77
				OR (gnp / population) < 0.01
			)
	ORDER BY lifeexpectancy DESC;


-- 14
-- RA --
SELECT c.name as countryName, c.code, COUNT(c.name) AS nblanguage
	FROM countrylanguage AS cl
	JOIN country AS c 
		ON c.code = cl.countrycode
	WHERE isofficial
			AND cl.percentage < 50.0
	GROUP BY c.name, c.code
	ORDER BY nblanguage DESC;

-- 15
-- RA --
SELECT c.name as countryName, COUNT(c.name) AS nbOfficialLanguage
	FROM countrylanguage AS cl
	JOIN country AS c 
		ON c.code = cl.countrycode
	WHERE cl.isofficial
	GROUP BY c.name
	ORDER BY nbOfficialLanguage DESC, c.name ASC;