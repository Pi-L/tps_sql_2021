-- 1 - 1 - 
SELECT c.name AS country_name, COUNT(c.name) AS nb_language
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	GROUP BY c.name
	ORDER BY COUNT(c.name) DESC;

-- 1 - 2
SELECT COUNT(language) AS nb_languages_in_the_world
	FROM countrylanguage
	GROUP BY language;

-- 1 - 3
SELECT c.name AS country_name, COUNT(c.name) AS nb_language
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.isofficial
	GROUP BY c.name
	ORDER BY COUNT(c.name) DESC;

-- 2 - 1
SELECT region AS region_name, SUM(surfacearea)
	FROM country
	GROUP BY region;

-- 2 - 2
SELECT ROUND(sum(c.population * cl.percentage / 100)::decimal, 2) AS nb_franchouillars
	FROM country AS c
	JOIN countrylanguage AS cl
		ON cl.countrycode = c.code
	WHERE cl.language = 'French';

-- 2 - 3
SELECT SUM(ct.population) AS tot_people_in_euro_capt
	FROM country AS c
	JOIN city AS ct
		ON ct.id = c.capital
	WHERE c.continent = 'Europe';

-- 2 - 4
WITH MINICPTPOP (population) AS 
	(SELECT MIN(ct.population) as population
		FROM country AS c
		JOIN city AS ct
			ON ct.id = c.capital
		WHERE c.continent = 'Europe')

SELECT ct.name FROM city AS ct
	JOIN MINICPTPOP as mct
	ON mct.population = ct.population;

-- 2 - 5 
WITH LANGUAGESPEAKERS (language, max_pop_per_lg) AS 
		(SELECT cl.language, SUM(c.population * cl.percentage / 100) AS max_pop_per_lg
			FROM country AS c
			JOIN countrylanguage AS cl
				ON cl.countrycode = c.code
			GROUP BY cl.language),

	MAXSPEAKERS (maxspeakers) AS 
		(SELECT MAX(max_pop_per_lg) AS maxspeakers FROM LANGUAGESPEAKERS)
	
SELECT language, ROUND(max_pop_per_lg) FROM LANGUAGESPEAKERS
	JOIN MAXSPEAKERS ON max_pop_per_lg = maxspeakers;


-- 3 - 1
SELECT continent, SUM(population) FROM country
	GROUP BY continent
	HAVING SUM(population) > 500000000;

-- 3 - 2
SELECT governmentform, COUNT(code) FROM country
	GROUP BY governmentform
	HAVING COUNT(code) > 10;
