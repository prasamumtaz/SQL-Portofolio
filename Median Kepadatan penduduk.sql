-- MENCARI MEDIAN
WITH A AS (
	SELECT  c.city_ID,
			c.city_name,
			RANK() OVER (PARTITION BY city_ID 
						ORDER BY t.value DESC) Rank_CP,
			value
	FROM city c
	JOIN district d ON c.city_ID = d.city_ID
	JOIN village v ON d.district_ID = v.district_ID
	JOIN thematic t ON v.village_ID = t.admin_ID
	WHERE t.year = 2022
	ORDER BY c.city_ID, t.value),
    
    B AS (
	SELECT 	c.city_ID,
			c.city_name,
			CEIL((COUNT(t.value)+1)/2) AS MEDIAN_position_1,
            FLOOR((COUNT(t.value)+1)/2) AS MEDIAN_position_2
	FROM city c
	JOIN district d ON c.city_ID = d.city_ID
	JOIN village v ON d.district_ID = v.district_ID
	JOIN thematic t ON v.village_ID = t.admin_ID
	WHERE t.year = 2022
	GROUP BY c.city_ID)
SELECT 	A.city_ID, 
		A.city_name,  
        ROUND(AVG(A.value), 2) AS MEDIAN
FROM A
JOIN B
	ON A.city_ID = B.city_ID
WHERE Rank_CP = Median_position_1 OR Rank_CP = Median_position_2
GROUP BY A.city_ID
ORDER BY MEDIAN DESC
LIMIT 15;