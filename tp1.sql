
-- 1- 1
-- RA -- Π name (world.country) σ population > 100000000 (world.country)
SELECT name FROM country WHERE population > 100000000;

-- 1- 2
-- RA -- Π region (world.country)
SELECT DISTINCT region as nomRegion FROM country; 

-- 1- 3
-- RA -- Π region ρ(nomRegion/region) (world.country) σ continent = Europe (world.country)
SELECT DISTINCT region as nomRegion 
	FROM country 
	WHERE continent = 'Europe';

-- 1- 4
-- RA -- 
SELECT * FROM country WHERE region = 'Southern Europe';

-- 1- 5
-- RA -- 
SELECT capital AS capitalId, data_type AS capitalType FROM country, information_schema.columns
	WHERE region = 'Western Europe' 
		AND table_name = 'country' 
		AND column_name = 'capital';


-- 1- 6
-- RA --
SELECT DISTINCT language FROM countrylanguage WHERE isofficial ORDER BY language ASC;

-- 1- 7
-- RA --
SELECT countrycode FROM countrylanguage 
	WHERE language = 'French' 
		AND isofficial 
	ORDER BY countrycode ASC;

-- 1- 8
-- RA --
SELECT name, indepyear AS independanceYear FROM country
	WHERE name = 'France';

-- 1- 9
-- RA -- 
SELECT name, coalesce(indepyear, 2042) AS independanceYear FROM country
	WHERE continent = 'Europe'
	ORDER BY independanceYear ASC;

-- 1- 10
-- RA --
SELECT ROW_NUMBER() OVER (ORDER BY population DESC) AS classement,
		name 
	FROM city
	WHERE countrycode = 'FRA' AND population > 100000
	ORDER BY population DESC;

-- 1- 11
-- RA --
SELECT name, 
		ROUND(population / surfacearea::decimal, 2) AS densite, 
		ROUND(gnp * 1000000 / population, 2) AS gdppc,
		lifeexpectancy
	FROM country
	WHERE continent = 'Europe' AND population != 0;
	ORDER BY densite DESC;


-- 1- 12
-- RA --
SELECT name, 
		lifeexpectancy,
		(gnp / population)
	FROM country
	WHERE population != 0 
			AND NOT lifeexpectancy < 77
			AND NOT (gnp / population) > 0.01
	ORDER BY lifeexpectancy DESC;


-- 1- 13 
-- RA --
SELECT name, 
		lifeexpectancy,
		(gnp / population)
	FROM country
	WHERE NOT (lifeexpectancy >= 77
				OR (gnp / population) < 0.01
			)
	ORDER BY lifeexpectancy DESC;


-- 1- 14
-- RA --
SELECT c.name as countryName, c.code, COUNT(c.name) AS nblanguage
	FROM countrylanguage AS cl
	JOIN country AS c 
		ON c.code = cl.countrycode
	WHERE isofficial
			AND cl.percentage < 50.0
	GROUP BY c.name, c.code
	ORDER BY nblanguage DESC;

-- 1- 15
-- RA --
SELECT c.name as countryName, COUNT(c.name) AS nbOfficialLanguage
	FROM countrylanguage AS cl
	JOIN country AS c 
		ON c.code = cl.countrycode
	WHERE cl.isofficial
	GROUP BY c.name
	ORDER BY nbOfficialLanguage DESC, c.name ASC;


-- 2 - 1
SELECT c.name AS country_name, ct.name AS city_name, region
	FROM city AS ct
	JOIN country AS c 
		ON ct.id = c.capital
	WHERE region = 'South America'
	ORDER BY c.name ASC;

-- 2 - 2
SELECT c.name AS country_name
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial AND cl.language = 'French'
	ORDER BY c.name ASC;

-- 2 - 3
SELECT c.name AS country_name, c.governmentform
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial AND cl.language = 'Spanish' AND c.governmentform = 'Federal Republic'
	ORDER BY c.name ASC;

-- 2 - 4
SELECT c.name AS country_name, COUNT(c.name) AS nb_official_language
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial
	GROUP BY c.name
	HAVING COUNT(c.name) > 2
	ORDER BY nb_official_language DESC;

-- 2 - 5
SELECT c.name FROM country AS c
	WHERE c.name NOT IN (
		SELECT c.name
			FROM country AS c
			JOIN countrylanguage AS cl
				ON cl.countrycode = c.code
			WHERE cl.isofficial
			GROUP BY c.name
			HAVING COUNT(c.name) >= 1
	);

-- 2 - 6
SELECT c.name, COUNT(c.name) as nb_city_over_1m
	FROM country AS c
	JOIN city AS ct
		ON ct.countrycode = c.code
	WHERE ct.population > 1000000
	GROUP BY c.name
	HAVING COUNT(c.name) >= 2
	ORDER BY COUNT(c.name) DESC;

-- 2 - 7
SELECT region, COUNT(region) 
	FROM (
		SELECT region FROM country 
			GROUP BY governmentform, region
		) AS sub
	GROUP BY region
	HAVING COUNT(region) = 1;

-- 2 - 8
-- Monarchy
SELECT DISTINCT region FROM country 
	WHERE region NOT IN (
		SELECT DISTINCT region FROM country
			WHERE governmentform LIKE '%Monarchy%'
	)
	ORDER BY region ASC;





