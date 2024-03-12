


Introduction
You’re a data analyst for ForestQuery, a non-profit organization, on a mission to reduce deforestation around the world and which raises awareness about this important environmental topic.

Your executive director and her leadership team members are looking to understand which countries and regions around the world seem to have forests that have been shrinking in size, and also which countries and regions have the most significant forest area, both in terms of amount and percent of total area. The hope is that these findings can help inform initiatives, communications, and personnel allocation to achieve the largest impact with the precious few resources that the organization has at its disposal.

You’ve been able to find tables of data online dealing with forestation as well as total land area and region groupings, and you’ve brought these tables together into a database that you’d like to query to answer some of the most important questions in preparation for a meeting with the ForestQuery executive team coming up in a few days. Ahead of the meeting, you’d like to prepare and disseminate a report for the leadership team that uses complete sentences to help them understand the global deforestation overview between 1990 and 2016.

Steps to Complete

1 - Create a View called “forestation” by joining all three tables - forest_area, land_area and regions in the workspace.

2 - The forest_area and land_area tables join on both country_code AND year.

3 - The regions table joins these based on only country_code.

4 - In the ‘forestation’ View, include the following:

      - All of the columns of the origin tables
      - A new column that provides the percent of the land area that is designated as forest.

5 - Keep in mind that the column forest_area_sqkm in the forest_area table and the land_area_sqmi in the land_area table are in different units (square kilometers and square miles, respectively), so an adjustment will need to be made in the calculation you write (1 sq mi = 2.59 sq km).


CREATE VIEW forestation
AS
  SELECT r.country_code,
         r.country_name,
         f.year,
         r.income_group,
         r.region,
         l.total_area_sq_mi,
         f.forest_area_sqkm,
         ( ( Sum(forest_area_sqkm) / Sum(total_area_sq_mi * 2.59) ) * 100 )
         forest_percentage
  FROM   forest_area f
         JOIN land_area l
           ON f.country_code = l.country_code
              AND f.year = l.year
         JOIN regions r
           ON r.country_code = f.country_code
  GROUP  BY 1,
            2,
            3,
            4,
            5,
            6,
            7 



============================================================================================================================================

a. What was the total forest area (in sq km) of the world in 1990? Please keep in mind that you can use the country record denoted as “World" in the region table.

SELECT country_name,
       year,
       Sum(forest_area_sqkm) total_forest_area
FROM   forestation
WHERE  year = 1990
       AND country_name = 'World'
GROUP  BY 1,
          2 

RESULT: 
World	1990	41,282,694.9 sqkm


============================================================================================================================================
b. What was the total forest area (in sq km) of the world in 2016? Please keep in mind that you can use the country record in the table is denoted as “World.”

SELECT Sum(forest_area_sqkm) total_forest_area
FROM   forestation
WHERE  country_name = 'World'
       AND year = '2016' 

RESULT: 
World	2016	39,958,245.9 sqkm

============================================================================================================================================
c. What was the change (in sq km) in the forest area of the world from 1990 to 2016?

SELECT (
(SELECT SUM(forest_area_sqkm) total_forest_area
FROM Forestation
WHERE YEAR = 1990
AND country_name = 'World') -
(SELECT SUM(forest_area_sqkm) total_forest_area
FROM forestation
WHERE YEAR = 2016
AND country_name = 'World')) AS forest_area_lost
FROM Forestation
LIMIT 1

FORMATTED:

SELECT ( (SELECT Sum(forest_area_sqkm) total_forest_area
          FROM   forestation
          WHERE  year = 1990
                 AND country_name = 'World') - (SELECT
                Sum(forest_area_sqkm) total_forest_area
                                                FROM   forestation
                                                WHERE  year = 2016
                                                       AND country_name =
                                                           'World') ) AS
       forest_area_lost
FROM   forestation
LIMIT  1 

difference = 1,324,449sqkm

============================================================================================================================================
d. What was the percent change in forest area of the world between 1990 and 2016?

WITH percent_change AS (
SELECT (((
  (SELECT SUM(forest_area_sqkm) total_forest_area
FROM Forestation
WHERE YEAR = 1990
AND country_name = 'World') - (SELECT SUM(forest_area_sqkm) total_forest_area
FROM forestation
WHERE YEAR = 2016
AND country_name = 'World')) / ((SELECT SUM(forest_area_sqkm) total_forest_area
FROM forestation
WHERE YEAR = 1990
AND country_name = 'World'))) *100) AS percent_diff
FROM forestation
LIMIT 1)

SELECT 
    CONCAT(ROUND(p.percent_diff::numeric,2), '%') AS percent_diff
FROM percent_change p


FORMATTED:

WITH percent_change AS
(
       SELECT (((
              (
                     SELECT Sum(forest_area_sqkm) total_forest_area
                     FROM   forestation
                     WHERE  year = 1990
                     AND    country_name = 'World') -
              (
                     SELECT Sum(forest_area_sqkm) total_forest_area
                     FROM   forestation
                     WHERE  year = 2016
                     AND    country_name = 'World')) / (
              (
                     SELECT Sum(forest_area_sqkm) total_forest_area
                     FROM   forestation
                     WHERE  year = 1990
                     AND    country_name = 'World'))) *100) AS percent_diff
       FROM   forestation LIMIT 1)
SELECT Concat(Round(p.percent_diff::numeric,2), '%') AS percent_diff
FROM   percent_change p


percent_diff = 3.21%


============================================================================================================================================

e. If you compare the amount of forest area lost between 1990 and 2016, to which country's total area in 2016 is it closest to?

WITH country_closest AS (
  SELECT 
    country_name,
    SUM(total_area_sq_mi*2.59) total_land_area
  FROM forestation
  WHERE YEAR = 2016 
  GROUP BY 1
  ORDER BY 2 )

SELECT 
  c.country_name,
	c.total_land_area
FROM country_closest c
WHERE c.total_land_area < '1314449'
ORDER BY 2 DESC
LIMIT 1

FORMATTED:

WITH country_closest AS
(
         SELECT   country_name,
                  Sum(total_area_sq_mi*2.59) total_land_area
         FROM     forestation
         WHERE    year = 2016
         GROUP BY 1
         ORDER BY 2 )
SELECT   c.country_name,
         c.total_land_area
FROM     country_closest c
WHERE    c.total_land_area < '1314449'
ORDER BY 2 DESC limit 1


RESULT: Peru   total_land_area= 1279999.9891  



============================================================================================================================================

2. REGIONAL OUTLOOK

Instructions:

  -  Answering these questions will help you add information into the template.
  -  Use these questions as guides to write SQL queries.
  -  Use the output from the query to answer these questions.
  -  Create a table that shows the Regions and their percent forest area (sum of forest area divided by sum of land area) in 1990 and 2016. (Note that 1 sq mi = 2.59 sq km).
  
  
Based on the table you created, ....

WITH year_1990 AS (
  SELECT 
	  region,
	  SUM(total_area_sq_mi) AS total_area_sq_mi,
    SUM(forest_area_sqkm) AS forest_area_sqkm,
    ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS forest_percentage_1990
  FROM forestation
  WHERE year = '1990'
  GROUP BY 1
  ORDER BY 1),


year_2016 AS (
  SELECT 
	  region,
	  SUM(total_area_sq_mi) AS total_area_sq_mi,
    SUM(forest_area_sqkm) AS forest_area_sqkm,
    ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS forest_percentage_2016
  FROM forestation
  WHERE year = '2016'
  GROUP BY 1
  ORDER BY 1)

SELECT 
  s.region,
	ROUND(s.forest_percentage_1990::numeric, 2) AS forest_percentage_1990,
  ROUND(e.forest_percentage_2016::numeric, 2) AS forest_percentage_2016
FROM year_1990 s
JOIN year_2016 e
	ON e.region = s.region
ORDER BY 2 DESC


FORMATTED:

WITH year_1990
     AS (SELECT region,
                SUM(total_area_sq_mi)
                AS
                   total_area_sq_mi,
                SUM(forest_area_sqkm)
                AS
                   forest_area_sqkm,
                ( ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                ) AS
                forest_percentage_1990
         FROM   forestation
         WHERE  year = '1990'
         GROUP  BY 1
         ORDER  BY 1),
     year_2016
     AS (SELECT region,
                SUM(total_area_sq_mi)
                AS
                   total_area_sq_mi,
                SUM(forest_area_sqkm)
                AS
                   forest_area_sqkm,
                ( ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                ) AS
                forest_percentage_2016
         FROM   forestation
         WHERE  year = '2016'
         GROUP  BY 1
         ORDER  BY 1)
SELECT s.region,
       Round(s.forest_percentage_1990 :: NUMERIC, 2) AS forest_percentage_1990,
       Round(e.forest_percentage_2016 :: NUMERIC, 2) AS forest_percentage_2016
FROM   year_1990 s
       join year_2016 e
         ON e.region = s.region
ORDER  BY 2 DESC 

  RESULT:


      region	                        forest_percentage_1990	              forest_percentage_2016
      Latin America & Caribbean	                51.03	                          46.16
      Europe & Central Asia	                    37.28	                          38.04
      North America	                            35.65	                          36.04
      World	                                    32.42	                          31.38
      Sub-Saharan Africa	                      30.67	                          28.79
      East Asia & Pacific	                      25.78	                          26.36
      South Asia	                              16.51	                          17.51
      Middle East & North Africa	              1.78	                          2.07

============================================================================================================================================

a. What was the percent forest of the entire world in 2016? 

SELECT 
  ROUND(f.forest_percentage::numeric, 2) AS forest_percentage
FROM forestation f
WHERE year = '2016' and country_name = 'World'

FORMATTED:

SELECT Round(f.forest_percentage :: NUMERIC, 2) AS forest_percentage
FROM   forestation f
WHERE  year = '2016'
       AND country_name = 'World' 


RESULT:     31.38%


Which region had the HIGHEST percent forest in 2016, 

RESULT:  Latin America & Caribbean	46.16%


and which had the LOWEST, to 2 decimal places?

RESULT: Middle East & North Africa	2.07%



============================================================================================================================================

b. What was the percent forest of the entire world in 1990? 

SELECT 
  ROUND(f.forest_percentage::numeric, 2) AS forest_percentage
FROM forestation f
WHERE year = '1990' and country_name = 'World'


FORMATTED:

SELECT Round(f.forest_percentage :: NUMERIC, 2) AS forest_percentage
FROM   forestation f
WHERE  year = '1990'
       AND country_name = 'World' 


RESULT:     32.42%

Which region had the HIGHEST percent forest in 1990, 

RESULT: Latin America & Caribbean	 51.03%

and which had the LOWEST, to 2 decimal places?

RESULT: Middle East & North Africa	1.78%



============================================================================================================================================

c. Based on the table you created, which regions of the world DECREASED in forest area from 1990 to 2016?

WITH year_1990 AS (
  SELECT 
    year,
	  region,
	  SUM(total_area_sq_mi) AS total_area_sq_mi,
    SUM(forest_area_sqkm) AS forest_area_sqkm,
    ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS forest_percentage_1990
  FROM forestation
  WHERE year = '1990'
  GROUP BY 1, 2
  ORDER BY 1),

year_2016 AS (
  SELECT 
    year,
	  region,
	  SUM(total_area_sq_mi) AS total_area_sq_mi,
    SUM(forest_area_sqkm) AS forest_area_sqkm,
    ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS forest_percentage_2016
  FROM forestation
  WHERE year = '2016'
  GROUP BY 1, 2
  ORDER BY 1),

forest_decrease As (
  SELECT 
    s.region,
    (e.forest_percentage_2016 - s.forest_percentage_1990) AS percent_diff
  FROM year_1990 s
  JOIN year_2016 e
    ON s.region = e.region
  WHERE  e.forest_percentage_2016 < s.forest_percentage_1990 
  ORDER BY 1)

SELECT 
    f.region,
    CONCAT(ROUND(f.percent_diff::numeric, 2), '%') AS percent_decrease
FROM forest_decrease f


FORMATTED:

WITH year_1990
     AS (SELECT year,
                region,
                SUM(total_area_sq_mi)
                AS
                   total_area_sq_mi,
                SUM(forest_area_sqkm)
                AS
                   forest_area_sqkm,
                ( ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                ) AS
                forest_percentage_1990
         FROM   forestation
         WHERE  year = '1990'
         GROUP  BY 1,
                   2
         ORDER  BY 1),
     year_2016
     AS (SELECT year,
                region,
                SUM(total_area_sq_mi)
                AS
                   total_area_sq_mi,
                SUM(forest_area_sqkm)
                AS
                   forest_area_sqkm,
                ( ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                ) AS
                forest_percentage_2016
         FROM   forestation
         WHERE  year = '2016'
         GROUP  BY 1,
                   2
         ORDER  BY 1),
     forest_decrease
     AS (SELECT s.region,
                ( e.forest_percentage_2016 - s.forest_percentage_1990 ) AS
                percent_diff
         FROM   year_1990 s
                join year_2016 e
                  ON s.region = e.region
         WHERE  e.forest_percentage_2016 < s.forest_percentage_1990
         ORDER  BY 1)
SELECT f.region,
       Concat(Round(f.percent_diff :: NUMERIC, 2), '%') AS percent_decrease
FROM   forest_decrease f 


RESULT:

region                      percent_decrease
Latin America & Caribbean	    -4.87%
Sub-Saharan Africa	          -1.89%
World	                        -1.05%


============================================================================================================================================

3. COUNTRY-LEVEL DETAIL

Instructions:

Answering these questions will help you add information to the template.
Use these questions as guides to write SQL queries.
Use the output from the query to answer these questions.


============================================================================================================================================
3. COUNTRY-LEVEL DETAIL
    SUCCESS STORIES

WITH t1 AS (
  SELECT 
	  country_name,
    SUM(forest_area_sqkm) AS forest_area_sqkm_1990
    FROM forestation
  WHERE year = '1990' AND forest_area_sqkm IS NOT NULL
  GROUP BY 1
  ORDER BY 2 DESC),

t2 AS (
  SELECT 
	  country_name,
    SUM(forest_area_sqkm) AS forest_area_sqkm_2016
    FROM forestation
  WHERE year = '2016' AND forest_area_sqkm IS NOT NULL
  GROUP BY 1
  ORDER BY 2 DESC)

SELECT 
  t2.country_name,
	t1.forest_area_sqkm_1990,
  t2.forest_area_sqkm_2016,
  (t2.forest_area_sqkm_2016 - t1.forest_area_sqkm_1990) AS gained_forest_area
FROM t2
JOIN t1
	ON t2.country_name = t1.country_name
WHERE t1.forest_area_sqkm_1990 < t2.forest_area_sqkm_2016 
AND t2.country_name != 'World'
ORDER BY 4 DESC


FORMATTED:

WITH t1
     AS (SELECT country_name,
                Sum(forest_area_sqkm) AS forest_area_sqkm_1990
         FROM   forestation
         WHERE  year = '1990'
                AND forest_area_sqkm IS NOT NULL
         GROUP  BY 1
         ORDER  BY 2 DESC),
     t2
     AS (SELECT country_name,
                Sum(forest_area_sqkm) AS forest_area_sqkm_2016
         FROM   forestation
         WHERE  year = '2016'
                AND forest_area_sqkm IS NOT NULL
         GROUP  BY 1
         ORDER  BY 2 DESC)
SELECT t2.country_name,
       t1.forest_area_sqkm_1990,
       t2.forest_area_sqkm_2016,
       ( t2.forest_area_sqkm_2016 - t1.forest_area_sqkm_1990 ) AS
       gained_forest_area
FROM   t2
       JOIN t1
         ON t2.country_name = t1.country_name
WHERE  t1.forest_area_sqkm_1990 < t2.forest_area_sqkm_2016
       AND t2.country_name != 'World'
ORDER  BY 4 DESC 


RESULT:  

country_name	      forest_area_sqkm_1990	      forest_area_sqkm_2016	      gained_forest_area
China	                    1571405.938	                2098635	                  527229.062
United States	            3024500	                    3103700	                  79200
India	                    639390	                    708603.9844	              69213.9844
Russian Federation	      8089500	                    8148895	                  59395
Vietnam	                  93630	                      149020	                  55390
Spain	                    138094.9023	                184520	                  46425.0977

============================================================================================================================================

 largest percent change in forest area from 1990 to 2016

WITH t1 AS (
  SELECT country_name,
	(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 percent_forestation_1990
FROM forestation
WHERE YEAR = 1990
GROUP BY country_name,
forest_area_sqkm),
 
t2 AS
(SELECT country_name,
(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS percent_forestation_2016
FROM forestation
WHERE YEAR = 2016
GROUP BY country_name,
forest_area_sqkm)
 
SELECT t1.country_name,
Round((((t2.percent_forestation_2016 - t1.percent_forestation_1990
)/(t1.percent_forestation_1990))*100)::Numeric, 2) percent_change
FROM t1 
JOIN t2  
 ON t1.country_name = t2.country_name
WHERE t1.percent_forestation_1990 IS NOT NULL
AND t2.percent_forestation_2016 IS NOT NULL
AND t1.country_name != 'World'
ORDER BY percent_change DESC


FORMATTED:

WITH t1
     AS (SELECT country_name,
                ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                percent_forestation_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY country_name,
                   forest_area_sqkm),
     t2
     AS (SELECT country_name,
                ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                AS
                percent_forestation_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY country_name,
                   forest_area_sqkm)
SELECT t1.country_name,
       Round(( ( ( t2.percent_forestation_2016 - t1.percent_forestation_1990
) / ( t1.percent_forestation_1990 ) ) * 100 ) :: NUMERIC, 2)
percent_change
FROM   t1
       join t2
         ON t1.country_name = t2.country_name
WHERE  t1.percent_forestation_1990 IS NOT NULL
       AND t2.percent_forestation_2016 IS NOT NULL
       AND t1.country_name != 'World'
ORDER  BY percent_change DESC 


country_name	      percent_change
Iceland	              213.66%
French Polynesia	    181.82%
Bahrain	              145.91%
Uruguay	              134.11%
Dominican Republic	  82.46%
Kuwait	              81.16%

============================================================================================================================================

a. Which 5 countries saw the largest amount decrease in forest area from 1990 to 2016? What was the difference in forest area for each?

WITH t1 AS (
  SELECT 
	  country_name,
    region,
    SUM(forest_area_sqkm) AS forest_area_sqkm_1990
    FROM forestation
  WHERE year = '1990' AND forest_area_sqkm IS NOT NULL
  GROUP BY 1
  ORDER BY 2 DESC),

t2 AS (
  SELECT 
	  country_name,
    SUM(forest_area_sqkm) AS forest_area_sqkm_2016
    FROM forestation
  WHERE year = '2016' AND forest_area_sqkm IS NOT NULL
  GROUP BY 1
  ORDER BY 2 DESC)

SELECT 
  t2.country_name,
	t1.forest_area_sqkm_1990,
  t2.forest_area_sqkm_2016,
  (t1.forest_area_sqkm_1990 - t2.forest_area_sqkm_2016) AS lost_forest_area
FROM t2
JOIN t1
	ON t2.country_name = t1.country_name
WHERE t1.forest_area_sqkm_1990 > t2.forest_area_sqkm_2016 
AND t2.country_name != 'World'
ORDER BY 4 DESC
LIMIT 5


FORMATTED:

WITH t1 AS
(
         SELECT   country_name,
                  region,
                  Sum(forest_area_sqkm) AS forest_area_sqkm_1990
         FROM     forestation
         WHERE    year = '1990'
         AND      forest_area_sqkm IS NOT NULL
         GROUP BY 1
         ORDER BY 2 DESC), t2 AS
(
         SELECT   country_name,
                  Sum(forest_area_sqkm) AS forest_area_sqkm_2016
         FROM     forestation
         WHERE    year = '2016'
         AND      forest_area_sqkm IS NOT NULL
         GROUP BY 1
         ORDER BY 2 DESC)
SELECT   t2.country_name,
         t1.forest_area_sqkm_1990,
         t2.forest_area_sqkm_2016,
         (t1.forest_area_sqkm_1990 - t2.forest_area_sqkm_2016) AS lost_forest_area
FROM     t2
JOIN     t1
ON       t2.country_name = t1.country_name
WHERE    t1.forest_area_sqkm_1990 > t2.forest_area_sqkm_2016
AND      t2.country_name != 'World'
ORDER BY 4 DESC limit 5


country_name	forest_area_sqkm_1990	forest_area_sqkm_2016	lost_forest_area
Brazil	            5467050	                4925540	          -541510.00
Indonesia	          1185450	                903256.0156	      -282193.98
Myanmar	            392180	                284945.9961	      -107234.00
Nigeria	            172340	                65833.99902	      -106506.00
Tanzania	          559200	                456880	          -102320.00


============================================================================================================================================

b. Which 5 countries saw the largest percent decrease in forest area from 1990 to 2016? What was the percent change to 2 decimal places for each?


WITH t1 AS (
  SELECT country_name,
	(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 percent_forestation_1990
FROM forestation
WHERE YEAR = 1990
GROUP BY country_name,
forest_area_sqkm),
 
t2 AS
(SELECT country_name,
(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS percent_forestation_2016
FROM forestation
WHERE YEAR = 2016
GROUP BY country_name,
forest_area_sqkm)
 
SELECT t1.country_name,
Round((((t1.percent_forestation_1990 -
t2.percent_forestation_2016)/(t1.percent_forestation_1990))*100)::Numeric, 2) percent_change
FROM t1 
JOIN t2  
 ON t1.country_name = t2.country_name
WHERE t1.percent_forestation_1990 IS NOT NULL
AND t2.percent_forestation_2016 IS NOT NULL
AND t1.country_name != 'World'
ORDER BY percent_change DESC


FORMATTED:

WITH t1
     AS (SELECT country_name,
                ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                percent_forestation_1990
         FROM   forestation
         WHERE  year = 1990
         GROUP  BY country_name,
                   forest_area_sqkm),
     t2
     AS (SELECT country_name,
                ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                AS
                percent_forestation_2016
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY country_name,
                   forest_area_sqkm)
SELECT t1.country_name,
       Round(
( ( ( t1.percent_forestation_1990 -
t2.percent_forestation_2016 ) / ( t1.percent_forestation_1990 ) ) * 100 ) :: NUMERIC, 2) percent_change
FROM   t1
       join t2
         ON t1.country_name = t2.country_name
WHERE  t1.percent_forestation_1990 IS NOT NULL
       AND t2.percent_forestation_2016 IS NOT NULL
       AND t1.country_name != 'World'
ORDER  BY percent_change DESC 



RESULT:  country_name	percent_change
          Togo	          -75.45
          Nigeria	        -61.80
          Uganda	        -59.27
          Mauritania	    -46.75
          Honduras	      -45.03


============================================================================================================================================

c. If countries were grouped by percent forestation in quartiles, which group had the most countries in it in 2016?

WITH T1 AS (
  SELECT country_name,
	YEAR,
	(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS percent_forestation
FROM forestation
WHERE YEAR = 2016
GROUP BY country_name,
YEAR,
forest_area_sqkm)
     
SELECT Distinct(quartiles),
count(country_name)Over(PARTITION BY quartiles)
FROM
(SELECT country_name,
  CASE
    WHEN percent_forestation<25 THEN '0-25'
    WHEN percent_forestation>=25
    AND percent_forestation<50 THEN '25-50'
    WHEN percent_forestation>=50
    AND percent_forestation<75 THEN '50-75'
    ELSE '75-100'
  END AS quartiles
FROM T1
WHERE percent_forestation IS NOT NULL
AND YEAR = 2016) sub

FORMATTED:

WITH t1
     AS (SELECT country_name,
                year,
                ( Sum(forest_area_sqkm) / Sum(total_area_sq_mi * 2.59) ) * 100
                AS
                percent_forestation
         FROM   forestation
         WHERE  year = 2016
         GROUP  BY country_name,
                   year,
                   forest_area_sqkm)
SELECT DISTINCT( quartiles ),
               Count(country_name)
                 OVER(
                   partition BY quartiles)
FROM   (SELECT country_name,
               CASE
                 WHEN percent_forestation < 25 THEN '0-25'
                 WHEN percent_forestation >= 25
                      AND percent_forestation < 50 THEN '25-50'
                 WHEN percent_forestation >= 50
                      AND percent_forestation < 75 THEN '50-75'
                 ELSE '75-100'
               END AS quartiles
        FROM   t1
        WHERE  percent_forestation IS NOT NULL
               AND year = 2016
               AND country_name != 'World') sub 

RESULT :    quartiles	  count
              0-25	      85
              25-50	      72
              50-75	      38
              75-100	     9



WITH t1 AS (
  SELECT country_name,
	YEAR,
	(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS percent_forest
FROM forestation
WHERE YEAR = '2016'
GROUP BY 1, 2,
forest_area_sqkm),

t2 AS (
SELECT t1.country_name,
     t1.year,
     t1.percent_forest,
     CASE
     WHEN t1.percent_forest < 25 THEN '0-25'
     WHEN t1.percent_forest >= 25 AND t1.percent_forest < 50 THEN '25-50'
     WHEN t1.percent_forest >= 50 AND t1.percent_forest < 75 THEN '50-75'
	 ELSE '75-100'
     END AS quartiles
FROM t1
WHERE t1.percent_forest IS NOT NULL),
     
t3 AS (
SELECT t2.country_name,
     t2.quartiles,
     t2.percent_forest,
     COUNT(t2.country_name) OVER (PARTITION BY t2.quartiles)
FROM t2
GROUP BY 1, 2, 3)
     
SELECT t3.country_name,
     t3.quartiles,
     ROUND((t3.percent_forest::numeric), 2),
     t3.count
FROM t3
WHERE t3.quartiles = '75-100'
ORDER BY 3 DESC

FORMATTED:

WITH t1
     AS (SELECT country_name,
                year,
                ( SUM(forest_area_sqkm) / SUM(total_area_sq_mi * 2.59) ) * 100
                AS
                   percent_forest
         FROM   forestation
         WHERE  year = '2016'
         GROUP  BY 1,
                   2,
                   forest_area_sqkm),
     t2
     AS (SELECT t1.country_name,
                t1.year,
                t1.percent_forest,
                CASE
                  WHEN t1.percent_forest < 25 THEN '0-25'
                  WHEN t1.percent_forest >= 25
                       AND t1.percent_forest < 50 THEN '25-50'
                  WHEN t1.percent_forest >= 50
                       AND t1.percent_forest < 75 THEN '50-75'
                  ELSE '75-100'
                END AS quartiles
         FROM   t1
         WHERE  t1.percent_forest IS NOT NULL),
     t3
     AS (SELECT t2.country_name,
                t2.quartiles,
                t2.percent_forest,
                Count(t2.country_name)
                  over (
                    PARTITION BY t2.quartiles)
         FROM   t2
         GROUP  BY 1,
                   2,
                   3)
SELECT t3.country_name,
       t3.quartiles,
       Round(( t3.percent_forest :: NUMERIC ), 2),
       t3.count
FROM   t3
WHERE  t3.quartiles = '75-100'
ORDER  BY 3 DESC 


RESULT:
          country_name	          quartiles	          percent_forest	        count
          Suriname	                75-100	            98.26	                9
          Micronesia, Fed. Sts.	    75-100	            91.86	                9
          Gabon	                    75-100	            90.04	                9
          Seychelles	              75-100	            88.41	                9
          Palau	                    75-100	            87.61	                9
          American Samoa	          75-100	            87.50	                9
          Guyana	                  75-100	            83.90	                9
          Lao PDR	                  75-100	            82.11	                9
          Solomon Islands	          75-100	            77.86	                9



============================================================================================================================================

d. List all of the countries that were in the 4th quartile (percent forest > 75%) in 2016.


WITH t1 AS (
  SELECT country_name,
	YEAR,
	(SUM(forest_area_sqkm) / SUM(total_area_sq_mi*2.59))*100 AS percent_forest
FROM forestation
WHERE YEAR = '2016'
GROUP BY 1, 2,
forest_area_sqkm),

t2 AS (
SELECT t1.country_name,
     t1.year,
     t1.percent_forest,
     CASE
     WHEN t1.percent_forest < 25 THEN '0-25'
     WHEN t1.percent_forest >= 25 AND t1.percent_forest < 50 THEN '25-50'
     WHEN t1.percent_forest >= 50 AND t1.percent_forest < 75 THEN '50-75'
	 ELSE '75-100'
     END AS quartiles
FROM t1
WHERE t1.percent_forest IS NOT NULL),
     
t3 AS (
SELECT t2.country_name,
     t2.quartiles,
     t2.percent_forest,
     COUNT(t2.country_name) OVER (PARTITION BY t2.quartiles)
FROM t2
GROUP BY 1, 2)
     
SELECT * 
FROM t3
WHERE t3.quartiles = '75-100'
ORDER BY 1

FORMATTED:

WITH t1
     AS (SELECT country_name,
                year,
                ( Sum(forest_area_sqkm) / Sum(total_area_sq_mi * 2.59) ) * 100
                AS
                   percent_forest
         FROM   forestation
         WHERE  year = '2016'
         GROUP  BY 1,
                   2,
                   forest_area_sqkm),
     t2
     AS (SELECT t1.country_name,
                t1.year,
                t1.percent_forest,
                CASE
                  WHEN t1.percent_forest < 25 THEN '0-25'
                  WHEN t1.percent_forest >= 25
                       AND t1.percent_forest < 50 THEN '25-50'
                  WHEN t1.percent_forest >= 50
                       AND t1.percent_forest < 75 THEN '50-75'
                  ELSE '75-100'
                END AS quartiles
         FROM   t1
         WHERE  t1.percent_forest IS NOT NULL),
     t3
     AS (SELECT t2.country_name,
                t2.quartiles,
                t2.percent_forest,
                Count(t2.country_name)
                  OVER (
                    partition BY t2.quartiles)
         FROM   t2
         GROUP  BY 1,
                   2)
SELECT *
FROM   t3
WHERE  t3.quartiles = '75-100'
ORDER  BY 1 



RESULT: country_name	          quartiles	count
        American Samoa	        75-100	  9
        Gabon	                  75-100	9
        Guyana	                75-100	9
        Lao PDR	                75-100	9
        Micronesia, Fed. Sts.	  75-100	9
        Palau	                  75-100	9
        Seychelles	            75-100	9
        Solomon Islands	        75-100	9
        Suriname	              75-100	9



============================================================================================================================================

e. How many countries had a percent forestation higher than the United States in 2016?


WITH t1 AS (
  SELECT 
	  country_name,
    ((Sum(forest_area_sqkm) / Sum(total_area_sq_mi*2.59))*100) AS forest_percentage_2016
  FROM forestation
  WHERE year = '2016'
  GROUP BY 1
  ORDER BY 2 DESC),

final As (
  SELECT 
    t1.country_name,
	  t1.forest_percentage_2016,
    (SELECT 
     	t1.forest_percentage_2016 AS us_forest_percentage_2016
    FROM t1
    WHERE t1.country_name = 'United States') 
  FROM t1),

final1 AS (
SELECT 
  f.*,
  COUNT(*)
FROM final f
GROUP BY 1,2,3
HAVING(f.forest_percentage_2016) > f.us_forest_percentage_2016
ORDER BY 2 DESC)

SELECT 
  CONCAT(SUM(final1.count), ' Countries in 2016 had a percent forestation higher than the United States ')
FROM final1

FORMATTED:

WITH t1
     AS (SELECT country_name,
                ( ( Sum(forest_area_sqkm) / Sum(total_area_sq_mi * 2.59) ) * 100
                ) AS
                forest_percentage_2016
         FROM   forestation
         WHERE  year = '2016'
         GROUP  BY 1
         ORDER  BY 2 DESC),
     final
     AS (SELECT t1.country_name,
                t1.forest_percentage_2016,
                (SELECT t1.forest_percentage_2016 AS us_forest_percentage_2016
                 FROM   t1
                 WHERE  t1.country_name = 'United States')
         FROM   t1),
     final1
     AS (SELECT f.*,
                Count(*)
         FROM   final f
         GROUP  BY 1,
                   2,
                   3
         HAVING( f.forest_percentage_2016 ) > f.us_forest_percentage_2016
         ORDER  BY 2 DESC)
SELECT Concat(Sum(final1.count),
' Countries in 2016 had a percent forestation higher than the United States '
)
FROM   final1 


RESULT  94 Countries




games_played

player_id
league
champions
cup
supercup




 supercup_stats
 supercup_goals
 supercup_minutes

 cup_stats
 cup_goals
 cup_minutes
 cup_yellow

 champions_stats
 champions_goals
 champions_minutes

 league_stats
 league_goals
 league_minutes

df jordi
fw messi
ouig mf

    WITH t1 AS (
    SELECT s.player_id,
        s.first_name || ' ' || s.last_name AS full_name,
        s.position,
        g.cup AS games_played,
        c.cup_yellow AS yellow_card
    FROM squad s
    JOIN games_played g
        ON s.player_id = g.player_id
    JOIN cup_stats c
        ON s.player_id = c.player_id
    WHERE c.cup_yellow >= 1
    ORDER BY 4 DESC ),
    
    fw AS (
    SELECT *
    FROM t1
    WHERE t1.position = 'fw'
    ORDER BY 5 DESC
    LIMIT 1),
    
    df AS (
    SELECT *
    FROM t1
    WHERE t1.position = 'df'
    ORDER BY 5 DESC
    LIMIT 1),
    
    mf AS (
    SELECT *
    FROM t1
    WHERE t1.position = 'mf'
    ORDER BY 4 DESC
    LIMIT 1)
    
    SELECT 
        fw.full_name, 
        fw.position, 
        fw.games_played,
        fw.yellow_card
    From fw
    UNION
    SELECT 
        df.full_name, 
        df.position, 
        df.games_played,
        df.yellow_card
   From df
   UNION
   SELECT 
        mf.full_name, 
        mf.position, 
        mf.games_played,
        mf.yellow_card
   From mf
   ORDER BY 3 DESC
