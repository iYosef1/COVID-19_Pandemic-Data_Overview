-- DROP TABLE IF EXISTS working_dataset;

-- CREATE TABLE working_dataset AS
-- SELECT * FROM owid_covid_master_dataset;


SELECT * FROM owid_covid_master_dataset
LIMIT 10;
SELECT * FROM working_dataset
LIMIT 10;

-- QUERIES & COMMANDS BELOW:

-- SET @index = 0;
-- SELECT  (@index := @index + 1) AS index_column, DISTINCT(iso_code) FROM practice_dataset;


-- WITH TABX AS
-- (



SELECT * FROM

(
WITH 

TAB1 AS
(SELECT location AS loc1, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_1 FROM working_dataset
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TAB2 AS 
(SELECT location AS loc2, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_2 FROM working_dataset
WHERE _date_ BETWEEN '2020-01-08' AND '2023-03-29'
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL)

SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 LEFT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB2.total_2 IS NULL
UNION
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 RIGHT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB1.total_1 IS NULL

) AS TABX;



WITH 

TAB1 AS
(SELECT location AS loc1, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_1 FROM working_dataset
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TAB2 AS 
(SELECT location AS loc2, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_2 FROM working_dataset
WHERE _date_ BETWEEN '2020-01-08' AND '2023-03-29'
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TABX AS (
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 LEFT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB2.total_2 IS NULL
UNION
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 RIGHT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB1.total_1 IS NULL)

SELECT * 
FROM TABX;



WITH 

TAB1 AS
(SELECT location AS loc1, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_1 FROM working_dataset
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TAB2 AS 
(SELECT location AS loc2, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_2 FROM working_dataset
WHERE _date_ BETWEEN '2020-01-08' AND '2023-03-29'
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TABX AS (
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 LEFT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB2.total_2 IS NULL
UNION
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 RIGHT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB1.total_1 IS NULL),

TABY AS (
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 LEFT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB2.total_2 IS NULL
UNION
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 RIGHT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB1.total_1 IS NULL)

SELECT * 
FROM TABX;



-- Testing Descriptive Statistics:

DROP TABLE IF EXISTS descriptive_stats_test_table;

CREATE TABLE descriptive_stats_test_table (
	col_A BIGINT,
    col_B BIGINT,
    col_C BIGINT
    );
    
INSERT INTO descriptive_stats_test_table (col_A, col_B, col_C)
VALUES -- Values are added in the form of records:
(35, 324, 324),
(9, 14, 21),
(4, 6, 7),
(238, 85, 767),
(72, 14, 103),
(17, 413, 254),
(381, 31, 843),
(17, NULL, 42003),
(841, 157, 324),
(0, NULL, 91),
(93, 0, 7),
(9, 14, 767),
(13, NULL, 103),
(39, 0, NULL);

-- SET @index = 0;
-- SELECT  (@index := @index + 1) AS index_column,

# AVERAGE TEST:
SELECT * FROM descriptive_stats_test_table;

SELECT AVG(col_A) FROM descriptive_stats_test_table; 

SELECT AVG(col_B) FROM descriptive_stats_test_table; 

SELECT AVG(col_C) FROM descriptive_stats_test_table; 

SELECT col_C, COUNT(col_C) FROM descriptive_stats_test_table
GROUP BY col_C
ORDER BY COUNT(col_C) DESC;

SELECT col_B, COUNT(col_B) FROM descriptive_stats_test_table -- The COUNT of NULL is 0 even though there are 3 NULLs. 
GROUP BY col_B
ORDER BY COUNT(col_B) DESC
LIMIT 1;

SELECT CASE WHEN MAX(COUNT(col_B)) > 1 THEN col_B ELSE NULL END FROM descriptive_stats_test_table;






# MEDIAN & MODE QUERIES - Must account for NULLs and Os in columns:
-- Mode query included TESTING FORMAT finally worked in 4000s (median was not yet included)
-- 0s should or should NOT be included as a part of mode but was included in AVG function
-- NULL represent missing values for any possible reason, 0 may possibly be counted as NULL as well at some locations... 


# MEDIAN TEST:

SELECT COUNT(col_A) FROM descriptive_stats_test_table; -- 14
SELECT col_A FROM descriptive_stats_test_table
ORDER BY col_A ASC;
SELECT col_A FROM descriptive_stats_test_table -- MEDIAN IS 26.
ORDER BY col_A ASC
LIMIT 2
OFFSET 6; -- Subtract 1 from the division output

SELECT COUNT(col_C) FROM descriptive_stats_test_table -- 13
WHERE col_C IS NOT NULL;
SELECT col_C FROM descriptive_stats_test_table
WHERE col_C IS NOT NULL
ORDER BY col_C ASC;
SELECT col_C FROM descriptive_stats_test_table -- MEDIAN IS 254.
WHERE col_C IS NOT NULL
ORDER BY col_C ASC
LIMIT 1
OFFSET 6; -- FLOOR the division output

-- EVEN Column Example:
SELECT AVG(middle_values) AS median FROM 
(SELECT col_A AS middle_values,
        ROW_NUMBER() OVER (ORDER BY col_A) AS row_num,
        COUNT(*) OVER () AS total_count
FROM descriptive_stats_test_table
WHERE col_A IS NOT NULL) AS subquery
WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2));

-- ODD Column Example:
SELECT AVG(middle_values) AS median FROM 
(SELECT col_C AS middle_values,
        ROW_NUMBER() OVER (ORDER BY col_C) AS row_num,
        COUNT(*) OVER () AS total_count
FROM descriptive_stats_test_table
WHERE col_C IS NOT NULL) AS subquery
WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2));





# CONFIRMING MEDIAN WITH LOCATION MEDIANS:

SET @index = 0;

SELECT (@index := @index + 1) AS index_column, location, AVG(middle_values) AS median FROM -- , row_num, total_count

(SELECT location,
	    new_cases AS middle_values,
	    ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases ) AS row_num,
	    COUNT(*) OVER () AS total_count
FROM working_dataset
WHERE new_cases IS NOT NULL AND location = 'Afghanistan') AS subquery

WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY location
-- HAVING row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
;












# A) MEAN:
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, location, AVG(new_cases) FROM working_dataset
GROUP BY location;


# B) MODE:

SET @index = 0;
WITH
Mode_table AS
(SELECT location, COUNT(new_cases) AS count_of_distinct_new_cases, new_cases FROM working_dataset
GROUP BY location, new_cases
ORDER BY location ASC, COUNT(new_cases) DESC)
SELECT (@index := @index + 1) AS location_index, location, 
       MAX(count_of_distinct_new_cases) AS mode_frequency
FROM Mode_table
GROUP BY location;

# MODE and MODE FREQUENCY:
SET @index = 0;
WITH
Mode_table AS

(SELECT location, 
	    COUNT(new_cases) AS count_of_distinct_new_cases, 
        new_cases,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_cases) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_cases
ORDER BY location ASC, COUNT(new_cases) DESC)

SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_cases AS mode_frequency, new_cases AS new_cases_mode
FROM Mode_table
WHERE row_num = 1;


# new_tests: There are NULLs because some locations are completely void of values, i.e., they are completely NULL
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_tests) AS count_of_distinct_new_tests, 
        new_tests,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_tests) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_tests
ORDER BY location ASC, COUNT(new_tests) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_tests AS mode_frequency, new_tests AS new_tests_mode
FROM Mode_table
-- WHERE row_num = 1
;

SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_tests) AS count_of_distinct_new_tests, 
        new_tests,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_tests) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_tests
ORDER BY location ASC, COUNT(new_tests) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_tests AS mode_frequency, new_tests AS new_tests_mode
FROM Mode_table
WHERE row_num = 1
;








# C) MEDIAN:

-- SUBQUERY - WORKING -- GROUPS BY LOCATION AND ORDERS BY new_cases:
SELECT location,
	   new_cases AS middle_values,
	   ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases ) AS row_num,
	   COUNT(*) OVER () AS total_count
FROM working_dataset
WHERE new_cases IS NOT NULL;

SELECT COUNT(new_cases) FROM working_dataset
WHERE new_cases IS NOT NULL;


-- MEDIAN QUERY - WORKING:
SET @index = 0;

SELECT (@index := @index + 1) AS index_column, location, AVG(middle_values) AS median FROM -- , row_num, total_count

(SELECT location,
	    new_cases AS middle_values,
	    ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases ) AS row_num,
	    COUNT(*) OVER (PARTITION BY location) AS total_count
FROM working_dataset
WHERE new_cases IS NOT NULL) AS subquery

WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
GROUP BY location
-- HAVING row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
;

-- THE MEDIAN SUBQUERY FOR FINAL FORMAT - GROUP BY & AGGREGATE AVG FUNC NEEDS TO BE ADDED:
SET @index = 0;

SELECT (@index := @index + 1) AS index_column, location, middle_values, row_num, total_count FROM -- , row_num, total_count

(SELECT location,
	    new_cases AS middle_values,
	    ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases ) AS row_num,
	    COUNT(*) OVER (PARTITION BY location) AS total_count
FROM working_dataset
WHERE new_cases IS NOT NULL) AS subquery

WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))
;










-- TESTING TEMPLATE 1:
-- new_cases: 9553.078 sec / 0.312 sec, 255 row(s) returned

/* The following 9 locations/records have 0 in the number_of_values column, i.e., they are absent of values in the new_cases feature. 

65-England
99-Hong Kong
131-Macao
166-Northern Cyprus
167-Northern Ireland
200-Scotland
222-Taiwan
249-Wales
251-Western Sahara

*/

SET @index = 0;
  
WITH

OG_table AS
(SELECT location, new_cases FROM working_dataset),

Median_table AS
(SELECT location_1, middle_values, row_num, total_count 
FROM (SELECT location AS location_1,
	         new_cases AS middle_values,
	         ROW_NUMBER() OVER (PARTITION BY location ORDER BY new_cases) AS row_num,
	         COUNT(*) OVER (PARTITION BY location) AS total_count
	  FROM working_dataset
	  WHERE new_cases IS NOT NULL) AS subquery
WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))),

Mode_table AS
(SELECT location AS location_2, COUNT(new_cases) AS count_of_distinct_new_cases, new_cases AS new_cases_2 FROM working_dataset
GROUP BY location, new_cases
ORDER BY location ASC, COUNT(new_cases) DESC)

SELECT (@index := @index + 1) AS location_index, OG_table.location, 
	   ROUND((SUM(CASE WHEN OG_table.new_cases IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)), 2) * 100 AS feature_completeness_percent, 
       SUM(CASE WHEN OG_table.new_cases IS NOT NULL THEN 1 ELSE 0 END) AS number_of_values, 
       SUM(CASE WHEN OG_table.new_cases IS NULL THEN 1 ELSE 0 END) AS number_of_empty_fields, 
       COUNT(*) AS number_of_records, 
       AVG(OG_table.new_cases) AS mean,
       AVG(Median_table.middle_values) AS median,
       MAX(Mode_table.count_of_distinct_new_cases) AS _mode_,
	   MAX(OG_table.new_cases) AS max,
       MIN(OG_table.new_cases) AS min,
       MAX(OG_table.new_cases) - MIN(OG_table.new_cases) AS _range_
       
FROM OG_table INNER JOIN Mode_table
ON OG_table.location = Mode_table.location_2

LEFT JOIN Median_table
ON Mode_table.location_2 = Median_table.location_1

GROUP BY location; 






# FINAL VERSION--CHECK IF FUNCTIONAL- 20) Total_Tests - Descriptive Statistics: 

SET @index = 0;

WITH total_tests_ds AS

(WITH mean_median_table AS

(
WITH OG_table AS
(SELECT location, total_tests FROM working_dataset),

Median_table AS
(SELECT location_1, middle_values, row_num, total_count 
FROM (SELECT location AS location_1,
			 total_tests AS middle_values,
			 ROW_NUMBER() OVER (PARTITION BY location ORDER BY total_tests) AS row_num,
			 COUNT(*) OVER (PARTITION BY location) AS total_count
      FROM working_dataset
      WHERE total_tests IS NOT NULL) AS subquery
WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2)))

SELECT OG_table.location, 
       ROUND((SUM(CASE WHEN OG_table.total_tests IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)), 2) * 100 AS feature_completeness_percent, 
       SUM(CASE WHEN OG_table.total_tests IS NOT NULL THEN 1 ELSE 0 END) AS number_of_values, 
       SUM(CASE WHEN OG_table.total_tests IS NULL THEN 1 ELSE 0 END) AS number_of_empty_fields, 
       COUNT(*) AS number_of_records, 
       AVG(OG_table.total_tests) AS mean,
       AVG(Median_table.middle_values) AS median,
       MAX(OG_table.total_tests) AS max,
       MIN(OG_table.total_tests) AS min,
       MAX(OG_table.total_tests) - MIN(OG_table.total_tests) AS _range_
       
FROM OG_table LEFT JOIN Median_table
ON OG_table.location = Median_table.location_1

GROUP BY location
),

mode_only_table AS

(
WITH Mode_table AS

(SELECT location AS location_2, 
		COUNT(total_tests) AS count_of_distinct_total_tests, 
        total_tests,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_tests) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_tests
ORDER BY location ASC, COUNT(total_tests) DESC)

SELECT location_2, count_of_distinct_total_tests AS mode_frequency, total_tests AS _mode_
FROM Mode_table
WHERE row_num = 1
)


SELECT (@index := @index + 1) AS location_index, 
		mean_median_table.location AS locations_of_total_tests_feature,
		mean_median_table.feature_completeness_percent,
		mean_median_table.number_of_values,
		mean_median_table.number_of_empty_fields,
		mean_median_table.number_of_records,
		mean_median_table.mean,
		mean_median_table.median,
		mode_only_table._mode_,
		mode_only_table.mode_frequency,
		mean_median_table.max,
		mean_median_table.min,
		mean_median_table._range_
FROM mean_median_table LEFT JOIN mode_only_table
ON mean_median_table.location = mode_only_table.location_2)

SELECT * FROM total_tests_ds;










-- EXAMPLE JOIN QUERY!
WITH 

TAB1 AS
(SELECT location AS loc1, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_1 FROM working_dataset
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TAB2 AS 
(SELECT location AS loc2, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_2 FROM working_dataset
WHERE _date_ BETWEEN '2020-01-08' AND '2023-03-29'
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TABX AS (
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 LEFT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB2.total_2 IS NULL
UNION
SELECT TAB1.loc1, TAB2.loc2, TAB1.total_1, TAB2.total_2 
FROM TAB1 RIGHT JOIN TAB2
ON TAB1.total_1 = TAB2.total_2
WHERE TAB1.total_1 IS NULL)

SELECT * 
FROM TABX;

























-- FINAL QUERY - FORMAT / TEMPLATE:
SELECT location, 
	   ROUND((SUM(CASE WHEN new_cases IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)), 2) * 100 AS feature_completeness_percent, 
       SUM(CASE WHEN new_cases IS NOT NULL THEN 1 ELSE 0 END) AS number_of_values, 
       SUM(CASE WHEN new_cases IS NULL THEN 1 ELSE 0 END) AS number_of_empty_fields, 
       COUNT(*) AS number_of_records, 
       AVG(new_cases) AS mean,
       MAX(new_cases) AS max,
       MIN(new_cases) AS min,
       MAX(new_cases) - MIN(new_cases) AS _range_
FROM working_dataset
GROUP BY location; 





















