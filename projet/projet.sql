

-- 1 - Déterminer le nombre moyen de personnes par lieu de chouille et recuperer l'adresse pour chaque lieu
WITH NBPERSCHOUILLE (id_chouille, id_location, nb_pers_chouille) AS (
		SELECT c.id_chouille, c.id_location, COUNT(p.id_person) 
			FROM Person AS p
			JOIN Persons_Chouilles AS pc
				ON p.id_person = pc.id_person
			JOIN Chouille AS c
				ON pc.id_chouille = c.id_chouille
			GROUP BY c.id_chouille)

SELECT l.adress, AVG(nb_pers_chouille) 
	FROM NBPERSCHOUILLE AS nbpc
	JOIN Location AS l
		ON nbpc.id_location = l.id_location
	GROUP BY l.id_location;



-- 2 - Déterminer la chouille où le volume maximum d’alcool a été consommé
WITH SUMALCOOL (id_chouille, date, sum_alcool) AS (
		SELECT c.id_chouille, c.date, SUM(i.measure * i.quantity * i.Percentage_Consumed / 100) as sum_alcool 
			FROM Chouille AS c
			JOIN Item AS i
				ON c.id_chouille = i.id_chouille
			WHERE i.type LIKE '%biere%'
					OR i.type LIKE '%bière%'
					OR i.type LIKE '%rhum%'
					AND i.unit = 'L'
			GROUP BY c.id_chouille)
	

SELECT sa.id_chouille, sa.date, sa.sum_alcool
	FROM SUMALCOOL AS sa
	WHERE sa.sum_alcool = (SELECT MAX(sum_alcool) FROM SUMALCOOL);

-- 3 - Déterminer la personne qui amène le plus de bière en étant hôte(sse) de soirée
WITH HOST (id_person, id_chouille) AS (
		SELECT p.id_person, c.id_chouille
		FROM Person AS p
		JOIN Location AS l ON l.id_person_host = p.id_person
		JOIN Chouille AS c ON c.id_location = l.id_location),

	SUMBEERVOL(id_person, vol_tot_biere) AS (
		SELECT i.id_person, SUM(i.measure * i.quantity * i.Percentage_Consumed / 100) AS vol_tot_biere 
			FROM Item AS i
			JOIN HOST AS h 
				ON h.id_person = i.id_person AND h.id_chouille = i.id_chouille
			WHERE i.type LIKE '%biere%'
					OR i.type LIKE '%bière%'
					AND i.unit = 'L'
			GROUP BY i.id_person),

	MAXBEER (id_person, max_vol_tot_biere) AS (
		SELECT id_person, MAX(vol_tot_biere) AS max_vol_tot_biere 
			FROM SUMBEERVOL
			GROUP BY id_person
	)

SELECT p.name, mb.max_vol_tot_biere FROM Person AS p
	JOIN MAXBEER AS mb
		ON mb.id_person = p.id_person;


-- 4 - Déterminer le volume total de bière consommée durant l’année passée durant toutes les Chouille
SELECT SUM(i.measure * i.quantity * i.Percentage_Consumed / 100) AS vol_tot_biere FROM Item AS i
	JOIN Chouille AS c 
		ON c.id_chouille = i.id_chouille
	WHERE (i.type LIKE '%biere%'
			OR i.type LIKE '%bière%')
			AND i.unit = 'L'
			AND DATEDIFF(NOW(), c.date) <= 365;

