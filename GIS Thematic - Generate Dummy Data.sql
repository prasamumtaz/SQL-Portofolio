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

-- PIVOT JUMLAH PENDUDUK KOTA X TAHUN 2010 - 2023 AS column name MANUAL
SELECT C.city_name,
		SUM(CASE WHEN T.year = 2010 THEN T.value END) AS '2010',
        SUM(CASE WHEN T.year = 2011 THEN T.value END) AS '2011',
        SUM(CASE WHEN T.year = 2012 THEN T.value END) AS '2012',
        SUM(CASE WHEN T.year = 2013 THEN T.value END) AS '2013',
        SUM(CASE WHEN T.year = 2014 THEN T.value END) AS '2014',
        SUM(CASE WHEN T.year = 2015 THEN T.value END) AS '2015',
        SUM(CASE WHEN T.year = 2016 THEN T.value END) AS '2016',
        SUM(CASE WHEN T.year = 2017 THEN T.value END) AS '2017',
        SUM(CASE WHEN T.year = 2018 THEN T.value END) AS '2018',
        SUM(CASE WHEN T.year = 2019 THEN T.value END) AS '2019',
        SUM(CASE WHEN T.year = 2020 THEN T.value END) AS '2020',
        SUM(CASE WHEN T.year = 2021 THEN T.value END) AS '2021',
        SUM(CASE WHEN T.year = 2022 THEN T.value END) AS '2022',
        SUM(CASE WHEN T.year = 2023 THEN T.value END) AS '2023'
FROM city C
JOIN district D ON c.city_ID = d.city_ID
JOIN village V ON d.district_ID = v.district_ID
JOIN thematic T ON v.village_ID = t.admin_ID
WHERE C.city_name = 'C 14';

-- Dynamic PIVOT
SET @sql = NULL;
SELECT
  GROUP_CONCAT(
    DISTINCT
    CONCAT(
      'SUM(CASE WHEN t.year = ', year, ' THEN t.value END) AS `', year, '`'
    )
  )
INTO @sql
FROM
  thematic t
JOIN village v ON t.admin_ID = v.village_ID
JOIN district d ON v.district_ID = d.district_ID
JOIN city c ON d.city_ID = c.city_ID
WHERE c.city_name = 'C 14';

SET @sql = CONCAT(
  'SELECT c.city_name, ', @sql, '
   FROM city c
   JOIN district d ON c.city_ID = d.city_ID
   JOIN village v ON d.district_ID = v.district_ID
   JOIN thematic t ON v.village_ID = t.admin_ID
   WHERE c.city_name = ''C 14''
   GROUP BY c.city_name'
);

PREPARE stmt FROM @sql;
EXECUTE stmt;
DEALLOCATE PREPARE stmt;