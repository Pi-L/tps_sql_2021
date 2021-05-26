-- 1 - 1 -- South America
SELECT ct.name FROM city AS ct
JOIN country AS c
	ON c.capital = ct.id
WHERE c.continent = 'South America';

-- 1 - 2 French
SELECT c.name FROM country AS c
JOIN countrylanguage AS cl
	ON cl.countrycode = c.code
WHERE cl.language = 'French' AND isofficial;

-- 1 - 3 espagnol federal republic
SELECT c.name FROM country AS c
JOIN countrylanguage AS cl
	ON cl.countrycode = c.code
WHERE isofficial AND cl.language = 'Spanish' AND c.governmentform = 'Federal Republic';


-- 2 - 4 
WITH MONA (region) AS (SELECT DISTINCT region FROM country
			WHERE governmentform LIKE '%Monarchy%')

SELECT DISTINCT region FROM country
EXCEPT
SELECT region FROM MONA
ORDER BY region ASC;

-- 2 - 5
SELECT c.name AS country_name, COUNT(c.name) AS nb_official_language
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial
	GROUP BY c.name
	HAVING COUNT(c.name) >= 2
	ORDER BY nb_official_language DESC;

-- 2 - 6
WITH OFFICIAL (name) AS (SELECT c.name
			FROM country AS c
			JOIN countrylanguage AS cl
				ON cl.countrycode = c.code
			WHERE cl.isofficial
			GROUP BY c.name
			HAVING COUNT(c.name) >= 1)

SELECT c.name FROM country AS c
EXCEPT
SELECT name FROM OFFICIAL;

-- 2 - 7
SELECT c.name AS country_name
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial AND cl.language = 'French'
INTERSECT
SELECT c.name AS country_name
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial
	GROUP BY c.name
	HAVING COUNT(c.name) = 1;

-- 2 - 8
SELECT c.name AS country_name
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code

	WHERE cl.isofficial AND cl.language = 'French'
INTERSECT
SELECT c.name AS country_name
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial
	GROUP BY c.name
	HAVING COUNT(c.name) > 1;

-- 2 - 9
SELECT c.name, COUNT(c.name) as nb_city_over_1m
	FROM country AS c
	JOIN city AS ct
		ON ct.countrycode = c.code
	WHERE ct.population > 1000000
	GROUP BY c.name
	HAVING COUNT(c.name) >= 2
	ORDER BY COUNT(c.name) DESC;

-- 2 - 10
WITH GOVFORMSBYREGION (region) AS (SELECT region FROM country 
			GROUP BY governmentform, region)

SELECT region, COUNT(region) 
	FROM GOVFORMSBYREGION
	GROUP BY region
	HAVING COUNT(region) = 1;

-- 2 - 11
SELECT DISTINCT c.name AS country_name, ct.name AS capital_name, cl.language as country_official_language
	FROM country AS c
	JOIN countrylanguage AS cl
		ON c.code = cl.countrycode
	JOIN city AS ct
		ON ct.id = c.capital
	WHERE ct.population > 5000000 AND cl.isofficial;

-- 2 - 12
SELECT c.name AS country_name, COUNT(cl.language) as nb_languages
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.percentage > 10
	GROUP BY c.name
	HAVING COUNT(c.name) >= 3
	ORDER BY nb_languages DESC;


-- 2 - 13
EXPLAIN
SELECT DISTINCT c.region AS region_name
	FROM country AS c
	JOIN country AS c1
		ON c.region = c1.region
	WHERE c.code != c1.code AND ABS(c.lifeexpectancy - c1.lifeexpectancy) >= 10;

-- 2 - 14
EXPLAIN
SELECT c.name AS country_name, SUM(CASE WHEN cl.language='French' OR cl.language='English' THEN 1
					ELSE 0 END) AS lesum
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial
	GROUP BY c.name
	HAVING  SUM(CASE WHEN cl.language='French' OR cl.language='English' THEN 1
					ELSE 0 END) >= 2;


