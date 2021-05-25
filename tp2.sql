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

