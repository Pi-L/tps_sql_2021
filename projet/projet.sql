
-- 1 - Déterminer le nombre moyen de personnes par lieu de chouille et recuperer l'adresse pour chaque lieu
-- Person, Location, Chouille
WITH NBPERSCHOUILLE (id_chouille, id_location, nb_pers_chouille) AS (
		SELECT c.id_chouille, c.id_location, COUNT(p.id_person) 
			FROM Person AS p
			JOIN Persons_Chouilles AS pc
				ON p.id_person = pc.id_person
			JOIN Chouille AS c
				ON pc.id_chouille = c.id_chouille
			GROUP BY c.id_chouille)

SELECT l.id_location, l.adress, AVG(nb_pers_chouille) as avg_pers_loc
	FROM NBPERSCHOUILLE AS nbpc
	JOIN Location AS l
		ON nbpc.id_location = l.id_location
	GROUP BY l.id_location
	ORDER BY avg_pers_loc DESC;


-- 2 - Déterminer la chouille où le volume (Litre) maximum d’alcool a été consommé
-- Item, Chouille
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
-- Person, Location, Item, Chouille
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
			GROUP BY i.id_person)

SELECT p.id_person, p.name, sb.vol_tot_biere FROM Person AS p
	JOIN SUMBEERVOL AS sb
		ON sb.id_person = p.id_person
	WHERE sb.vol_tot_biere = (SELECT MAX(vol_tot_biere) FROM SUMBEERVOL);


-- 4 - Déterminer le volume total de bière consommée durant l’année passée durant toutes les Chouille
-- Chouille, Item
SELECT SUM(i.measure * i.quantity * i.Percentage_Consumed / 100) AS vol_tot_biere 
	FROM Item AS i
	JOIN Chouille AS c 
		ON c.id_chouille = i.id_chouille
	WHERE (i.type LIKE '%biere%'
			OR i.type LIKE '%bière%')
			AND i.unit = 'L'
			AND DATEDIFF(NOW(), c.date) <= 365 AND DATEDIFF(NOW(), c.date) >= 0;

