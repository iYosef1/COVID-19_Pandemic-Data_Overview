/* Data-type Conversion - Appropriate MAX Character Length per Feature for Data-type Parameter(s):

The following queries are geared towards returning the field within a feature that has the MAX character length and the respective MAX length in itself.
Depending on the data-type, the MAX character length will be appropriately determined for the specific parameters in use.

Categorical features will return the string output: field_value; MAX_length

Numerically discrete features will return the string output: field_value; MAX_length_whole_digits (exclude decimal and trailing zeroes, if present)

Numerically continuous features will return the string output: a) field_value; MAX_length_all_digits (exclude decimal)
															   b) field_value; MAX_length_decimal_digits_only (exclude decimal)

*/



-- Candidate Data-types for Features:

-- REMINDER: With CHAR data-types, each character takes up a specific number of bytes, usually 3-4 bytes but ultimately depends on the encoding. 
-- For instance, the string "hello" has 5 characters and if each character is 3 bytes, then the total number of bytes will be 15 bytes.
-- The total number of bytes permitted in MySQL within a single column ONLY or within an ENTIRE row of a table is 65,535 bytes.
-- The number of columns, character length, and character byte-size will be have to be allocated according to the 65,535 bytes limit.

-- TEXT data-types: Also referred to as CLOBs (Character Large Objects).
				 -- Unlike VARCHAR, these data-types are not limited by the max row size of 65,535 bytes since the data is stored elsewhere in the backend by MySQL. 
	             -- This data-types is useful for storing preferred columns when VARCHAR has reached its limit of 65,535 bytes.
                 -- This data-type does not allow for any default but NULL when you insert data into a column.

/* CHAR Data-type

The size parameter is the upper limit representing the number of characters allowed in a string. This limit is 255 characters (NOT bytes).
The CHAR data-type is ideal when every string in a column has the same length. 
However, if the character length of a string is less than its argument, there will be a padding of additional empty spaces to reach the argument value.

*/

/* VARCHAR Data-type

This data-type is useful when the character length of each string in a column varies. 
The size parameter is the upper limit representing the number of characters allowed in a string. This limit is 65,535 bytes (NOT characters).
Unlike the CHAR data-type, if the character length of a string is less than its argument, there will be NO padding of additional empty spaces.
However, the caveat is that MySQL will add an additional byte or 2 to each string as it has to keep track of the different lengths of all the different strings in the column.

*/

/* DECIMAL Data-type

This data-type is has 2 parameters, precision and scale. Precision is the total number of digits in the numeric value and scale is the total number of digits after the decimal place.
This data-type may also be referred to as DEC, NUMERIC, and FIXED. This data-type is ideal for precision, e.g., in MATH or if you were working with money.
In contrast, the FLOAT or DOUBLE data-type are both ideal for estimation as their precision is lower.

*/

/* DOUBLE Data-type

This data-type is a floating-point data-type that is used to store estimated values. It is not ideal to use for precision or when making calculations.
It is ideal when exact values are not required since this data-type stores in the format of scientific notation.
For example, -150 would be stored as -1.5 x 10^2; -1.5 is the coefficient, 10 is the base, and 2 is the exponent.
If the exponent is negative, the expanded form is a +/- rational or irrational number. If the exponent is positive, it will be an integer.
In relative terms, the more number of digits that are EXCLUSIVELY trailing zeroes (refer to significant figures) in the expanded form, then the more that number's precision will be assured.
DOUBLE can maintain a higher level of precision than FLOAT (data-type listed below).

*/

/* FLOAT Data-type

FLOAT is identical to the DOUBLE data-type but will maintain a lower level of precision than DOUBLE. It can also return unusual results when doing calculations. 
The DOUBLE data-type is always more preferable even though it can also return unusual results when doing calculations.

*/

/* INT Data-type

This data-type is used for exact numbers, i.e., it will never loose precision, even when doing calculations. 
The UNSIGNED or SIGNED constraint will allow the values to be either exclusively positive OR to be positive and negative.
The argument passed into any INT data-type is referred to as the display width. It is the number of characters available that makes up the width of a number.
For example, when data is stored within INT(5), the the number 49 would be stored as 00049 and the number 150 would be stored as 00150.
It does not dynamically store the number of digits or characters as VARCHAR does. It is more similar to the CHAR data-type but is padded with leading 0s.
The ZEROFILL keyword will unhide the hidden 0s when a field value is less than 5 characters long. The actual size of the column can only be altered via TINYINT, MEDIUMINT, and so forth. 
Note: MySQL 8.0.32 no longer supports a size parameter for the INT data-types. 

*/

/* DATE Data-type

This data-type has its own convention for dates in MySQL; YYYY-MM-DD, e.g., '2022-07-22'.

*/



-- The following queries serve as test data with arbitrary but intentional values for comfirming success in varying case scenarios for the appropriate digit counts:

CREATE TABLE feature_len_query_testing_table (
	category_col_check VARCHAR(100),
    num_discrete_col_check VARCHAR(100),
    num_continuous_col_check VARCHAR(100)
    );
    
INSERT INTO feature_len_query_testing_table (category_col_check, num_discrete_col_check, num_continuous_col_check)
VALUES -- Values are added in the form of records:
('abc', '324', '324'),
('def0', '2.02', '0.0021'),
('ghi123', '7.0', '7.0'),
('jkl45', '767.006', '767.006'),
('mn', '13', '0000.103'),
('opqr6789', '254.0000', '254.0000'), --
('s', '843.42003', '843.42003'),
('tuvwxyz', '0043.9003', '003.42003'),
('abc', '-324', '-324'),
('def0', '-2.02', '-0.0021'),
('ghi123', '-7.0', '-7.0'),
('jkl45', '-767.006', '-767.006'),
('mn', '-13', '-0000.103'),
('opqr6789', '-254.0000', '-254.0000'), --
('s', '-843.42003', '-843.42003'),
('tuvwxyz', '-0043.9003', '-003.42003');

SELECT * FROM feature_len_query_testing_table;

-- DROP TABLE feature_len_query_testing_table; -- The feature_len_query_testing_table can be discarded.

-- Queries all whole numbers, inclusive of whole numbers with trailing 0s following a decimal point, to return the fields with max number character length along with the character length as well. 
-- If the values in the column consist of a decimal, there must be a numerical character before and after the decimal point. 
SELECT DISTINCT(num_discrete_col_check) AS max_len_num_discrete, 
				LENGTH(num_discrete_col_check) AS total_len, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS whole_digits,
				CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT) AS whole_digits_casted, 
                LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) AS Length_whole_digits_casted, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS dec_digits, -- whole numbers with no decimal digits (even trailing zeroes) return the whole number
				CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0 AS dec_digits_greater_than_0, 
CASE
	WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) END) -- A value can have more than 1 trailing zero, check if string of decimal digits = 0
    ELSE LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) -- remove this line?? Need condition for when decimal DNE in string??
    END AS MAX_length_whole_digits
FROM feature_len_query_testing_table
WHERE LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT))) FROM feature_len_query_testing_table);
-- ORDER BY max_len_num_discrete; -- Whole numbers in string format will still be sorted correctly in ASC or DESC numerical order by whole digits first, then decimal digits, if they have the same number of digits. 
-- Note: The -ve values added to the sample data altering the results of the query. Try SIGNED INT instead of UNSIGNED INT!!! -- This worked but the -ve signs are being counted as a character!!!
    
    
    
    
    
    
    
    
    
    

    
-- COPY!!!
  SELECT DISTINCT(num_discrete_col_check) AS max_len_num_discrete, 
				LENGTH(num_discrete_col_check) AS total_len, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS whole_digits,
				CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS UNSIGNED INT) AS whole_digits_casted, 
                LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS UNSIGNED INT)) AS Length_whole_digits_casted, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS dec_digits, -- whole numbers with no decimal digits (even trailing zeroes) return the whole number
				CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS UNSIGNED INT) > 0 AS dec_digits_greater_than_0, 
CASE
	WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN num_discrete_col_check LIKE '%.0' THEN LENGTH(SUBSTRING_INDEX(num_discrete_col_check, '.', 1)) END) -- A value can have more than 1 trailing zero, check for sum of decimal digits < 0
    ELSE LENGTH(num_discrete_col_check) -- remove this line?? Need condition for when decimal DNE in string??
    END AS MAX_length_whole_digits
FROM feature_len_query_testing_table;
-- WHERE LENGTH(num_discrete_col_check) = (SELECT MAX(LENGTH(num_discrete_col_check)) FROM feature_len_query_testing_table)
-- ORDER BY whole_number; -- Whole numbers in string format will still be sorted correctly in ASC or DESC order.   
    
    
    
    
    
    
    
    
    
    
    
    
    
    





-- Building Query for Categorical Features:

-- Sample feature being used: iso_code

-- Returns the MAX character length in iso_code feature:
SELECT MAX(LENGTH(iso_code)) AS max_len_of_iso_code FROM master_dataset;

-- Returns ALL fields in iso_code feature with MAX character length (including duplicates):
SELECT iso_code AS ALL_iso_codes_with_max_len FROM master_dataset
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM master_dataset);

-- Returns all distinct fields in iso_code feature with MAX character length, plus the length in itself:
SELECT DISTINCT(iso_code) AS max_len_iso_code, LENGTH(iso_code) AS len FROM master_dataset
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM master_dataset);



-- Building Query for Numerically Discrete Features:

-- Sample feature being used: new_cases

-- Returns the MAX character length in new_cases feature:
SELECT DISTINCT(new_cases) AS max_len_new_cases, LENGTH(new_cases) AS len FROM master_dataset
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset);

SELECT DISTINCT(new_cases) AS max_len_new_cases, LENGTH(new_cases) AS total_len, SUBSTRING_INDEX(new_cases, '.', -1), CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS UNSIGNED INT) > 0 AS whole_number, 
CASE
	WHEN new_cases LIKE '%.%' THEN (CASE WHEN new_cases LIKE '%.0' THEN LENGTH(SUBSTRING_INDEX(new_cases, '.', 1)) END) -- A value can have more than 1 trailing zero, check for sum of decimal digits < 0
    ELSE LENGTH(new_cases) -- remove this line?? Need condition for when decimal DNE in string
    END AS MAX_length_whole_digits
FROM master_dataset
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset)
ORDER BY whole_number; -- Whole numbers in string format will still be sorted correctly in ASC or DESC order. 






-- The following queries will form the basis or columns for extracting data-type arguments for data-type conversion:

-- Max Character Length Fields in Categorical Feature:
SELECT DISTINCT(CONCAT(iso_code, '; ', LENGTH(iso_code))) AS max_len_iso_code FROM master_dataset
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM master_dataset);

-- Max Character Length Fields in Numerically Discrete & Continuous Features:
SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) AS max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);


-- The following queries will  provide a respective COUNT of the two preceding queries:

-- Number of Max Length Fields in Categorical Feature:
SELECT COUNT(DISTINCT(CONCAT(iso_code, '; ', LENGTH(iso_code)))) AS count_max_len_iso_code FROM master_dataset
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM master_dataset);

-- Number of Max Length Fields in Numerical Feature:
SELECT COUNT(DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')'))) AS count_max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);



/* Toggle to (un)hide the sample query capable of gathering each SELECT query's results into a single table.
   This temporary table will not be used because at least one of the columns, apparently the column placed 1st in order, creates duplicates of the same field in that column.
   For the purpose of identifying the field with MAX length in each column, this query would still be functional.
   However, for the maintainence of data integrity it is best to take another approach.

SELECT column_1.max_len_new_cases, column_2.max_len_total_deaths FROM

	(SELECT DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases))) AS max_len_new_cases FROM master_dataset
	WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset)) AS column_1,
    
    (SELECT DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths))) AS max_len_total_deaths FROM master_dataset
	WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM master_dataset)) AS column_2;


The queries below will confirm the erred output of the temporary table above, i.e., the outputs from the following queries are correct but the output above is incorrect.

-- Number of Max Length Fields in new_cases:
SELECT COUNT(DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases)))) AS count_max_len_new_cases FROM master_dataset
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset);

-- Max Length Fields in new_cases:
SELECT DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases))) AS count_max_len_new_cases FROM master_dataset
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset);


-- Number of Max Length Fields in total_deaths:
SELECT COUNT(DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths)))) AS count_max_len_total_deaths FROM master_dataset
WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM master_dataset);

-- Max Length Fields in total_deaths:
SELECT DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths))) AS count_max_len_total_deaths FROM master_dataset
WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM master_dataset);

*/



/* MAX Character Length of All Features Except Temporal Feature(s):

-- SQL queries for MAX character length of numerical and categorical features were automated via python script and has been pasted below.
-- The _date_ feature is a categorical feature, however, in the context of SQL databases, it is a temporal feature, and the only temporal feature in this dataset. 
-- The following 2 query-sets will return multiple tabs rather than a single temporary table grouping all columns together:

*/

-- Categorical Features - MAX Length:

SELECT DISTINCT(CONCAT(iso_code, '; ', LENGTH(iso_code))) AS max_len_iso_code FROM master_dataset
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM master_dataset);


SELECT DISTINCT(CONCAT(continent, '; ', LENGTH(continent))) AS max_len_continent FROM master_dataset
WHERE LENGTH(continent) = (SELECT MAX(LENGTH(continent)) FROM master_dataset);


SELECT DISTINCT(CONCAT(location, '; ', LENGTH(location))) AS max_len_location FROM master_dataset
WHERE LENGTH(location) = (SELECT MAX(LENGTH(location)) FROM master_dataset);


SELECT DISTINCT(CONCAT(tests_units, '; ', LENGTH(tests_units))) AS max_len_tests_units FROM master_dataset
WHERE LENGTH(tests_units) = (SELECT MAX(LENGTH(tests_units)) FROM master_dataset);



-- Numerical Features - MAX Length:

-- IMPORTANT: The 3rd value of each query's output is a tuple consisting of the number of digits before and after the decimal. It is NOT a direct arguement for decimal-value data-types.

SELECT DISTINCT(CONCAT(total_cases, '; ', LENGTH(total_cases), '; ', '(', LENGTH(SUBSTRING_INDEX(total_cases, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_cases, '.', -1)), ')')) AS max_len_total_cases FROM master_dataset
WHERE LENGTH(total_cases) = (SELECT MAX(LENGTH(total_cases)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases, '.', -1)), ')')) AS max_len_new_cases FROM master_dataset
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) AS max_len_new_cases_smoothed FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths), '; ', '(', LENGTH(SUBSTRING_INDEX(total_deaths, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_deaths, '.', -1)), ')')) AS max_len_total_deaths FROM master_dataset
WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_deaths, '; ', LENGTH(new_deaths), '; ', '(', LENGTH(SUBSTRING_INDEX(new_deaths, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_deaths, '.', -1)), ')')) AS max_len_new_deaths FROM master_dataset
WHERE LENGTH(new_deaths) = (SELECT MAX(LENGTH(new_deaths)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_deaths_smoothed, '; ', LENGTH(new_deaths_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_deaths_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_deaths_smoothed, '.', -1)), ')')) AS max_len_new_deaths_smoothed FROM master_dataset
WHERE LENGTH(new_deaths_smoothed) = (SELECT MAX(LENGTH(new_deaths_smoothed)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_cases_per_million, '; ', LENGTH(total_cases_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(total_cases_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_cases_per_million, '.', -1)), ')')) AS max_len_total_cases_per_million FROM master_dataset
WHERE LENGTH(total_cases_per_million) = (SELECT MAX(LENGTH(total_cases_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_cases_per_million, '; ', LENGTH(new_cases_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_per_million, '.', -1)), ')')) AS max_len_new_cases_per_million FROM master_dataset
WHERE LENGTH(new_cases_per_million) = (SELECT MAX(LENGTH(new_cases_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_cases_smoothed_per_million, '; ', LENGTH(new_cases_smoothed_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', -1)), ')')) AS max_len_new_cases_smoothed_per_million FROM master_dataset
WHERE LENGTH(new_cases_smoothed_per_million) = (SELECT MAX(LENGTH(new_cases_smoothed_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_deaths_per_million, '; ', LENGTH(total_deaths_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(total_deaths_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_deaths_per_million, '.', -1)), ')')) AS max_len_total_deaths_per_million FROM master_dataset
WHERE LENGTH(total_deaths_per_million) = (SELECT MAX(LENGTH(total_deaths_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_deaths_per_million, '; ', LENGTH(new_deaths_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(new_deaths_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_deaths_per_million, '.', -1)), ')')) AS max_len_new_deaths_per_million FROM master_dataset
WHERE LENGTH(new_deaths_per_million) = (SELECT MAX(LENGTH(new_deaths_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_deaths_smoothed_per_million, '; ', LENGTH(new_deaths_smoothed_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', -1)), ')')) AS max_len_new_deaths_smoothed_per_million FROM master_dataset
WHERE LENGTH(new_deaths_smoothed_per_million) = (SELECT MAX(LENGTH(new_deaths_smoothed_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(reproduction_rate, '; ', LENGTH(reproduction_rate), '; ', '(', LENGTH(SUBSTRING_INDEX(reproduction_rate, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(reproduction_rate, '.', -1)), ')')) AS max_len_reproduction_rate FROM master_dataset
WHERE LENGTH(reproduction_rate) = (SELECT MAX(LENGTH(reproduction_rate)) FROM master_dataset);


SELECT DISTINCT(CONCAT(icu_patients, '; ', LENGTH(icu_patients), '; ', '(', LENGTH(SUBSTRING_INDEX(icu_patients, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(icu_patients, '.', -1)), ')')) AS max_len_icu_patients FROM master_dataset
WHERE LENGTH(icu_patients) = (SELECT MAX(LENGTH(icu_patients)) FROM master_dataset);


SELECT DISTINCT(CONCAT(icu_patients_per_million, '; ', LENGTH(icu_patients_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(icu_patients_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(icu_patients_per_million, '.', -1)), ')')) AS max_len_icu_patients_per_million FROM master_dataset
WHERE LENGTH(icu_patients_per_million) = (SELECT MAX(LENGTH(icu_patients_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(hosp_patients, '; ', LENGTH(hosp_patients), '; ', '(', LENGTH(SUBSTRING_INDEX(hosp_patients, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(hosp_patients, '.', -1)), ')')) AS max_len_hosp_patients FROM master_dataset
WHERE LENGTH(hosp_patients) = (SELECT MAX(LENGTH(hosp_patients)) FROM master_dataset);


SELECT DISTINCT(CONCAT(hosp_patients_per_million, '; ', LENGTH(hosp_patients_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(hosp_patients_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(hosp_patients_per_million, '.', -1)), ')')) AS max_len_hosp_patients_per_million FROM master_dataset
WHERE LENGTH(hosp_patients_per_million) = (SELECT MAX(LENGTH(hosp_patients_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(weekly_icu_admissions, '; ', LENGTH(weekly_icu_admissions), '; ', '(', LENGTH(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(weekly_icu_admissions, '.', -1)), ')')) AS max_len_weekly_icu_admissions FROM master_dataset
WHERE LENGTH(weekly_icu_admissions) = (SELECT MAX(LENGTH(weekly_icu_admissions)) FROM master_dataset);


SELECT DISTINCT(CONCAT(weekly_icu_admissions_per_million, '; ', LENGTH(weekly_icu_admissions_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', -1)), ')')) AS max_len_weekly_icu_admissions_per_million FROM master_dataset
WHERE LENGTH(weekly_icu_admissions_per_million) = (SELECT MAX(LENGTH(weekly_icu_admissions_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(weekly_hosp_admissions, '; ', LENGTH(weekly_hosp_admissions), '; ', '(', LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions, '.', -1)), ')')) AS max_len_weekly_hosp_admissions FROM master_dataset
WHERE LENGTH(weekly_hosp_admissions) = (SELECT MAX(LENGTH(weekly_hosp_admissions)) FROM master_dataset);


SELECT DISTINCT(CONCAT(weekly_hosp_admissions_per_million, '; ', LENGTH(weekly_hosp_admissions_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', -1)), ')')) AS max_len_weekly_hosp_admissions_per_million FROM master_dataset
WHERE LENGTH(weekly_hosp_admissions_per_million) = (SELECT MAX(LENGTH(weekly_hosp_admissions_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_tests, '; ', LENGTH(total_tests), '; ', '(', LENGTH(SUBSTRING_INDEX(total_tests, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_tests, '.', -1)), ')')) AS max_len_total_tests FROM master_dataset
WHERE LENGTH(total_tests) = (SELECT MAX(LENGTH(total_tests)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_tests, '; ', LENGTH(new_tests), '; ', '(', LENGTH(SUBSTRING_INDEX(new_tests, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_tests, '.', -1)), ')')) AS max_len_new_tests FROM master_dataset
WHERE LENGTH(new_tests) = (SELECT MAX(LENGTH(new_tests)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_tests_per_thousand, '; ', LENGTH(total_tests_per_thousand), '; ', '(', LENGTH(SUBSTRING_INDEX(total_tests_per_thousand, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_tests_per_thousand, '.', -1)), ')')) AS max_len_total_tests_per_thousand FROM master_dataset
WHERE LENGTH(total_tests_per_thousand) = (SELECT MAX(LENGTH(total_tests_per_thousand)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_tests_per_thousand, '; ', LENGTH(new_tests_per_thousand), '; ', '(', LENGTH(SUBSTRING_INDEX(new_tests_per_thousand, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_tests_per_thousand, '.', -1)), ')')) AS max_len_new_tests_per_thousand FROM master_dataset
WHERE LENGTH(new_tests_per_thousand) = (SELECT MAX(LENGTH(new_tests_per_thousand)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_tests_smoothed, '; ', LENGTH(new_tests_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_tests_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_tests_smoothed, '.', -1)), ')')) AS max_len_new_tests_smoothed FROM master_dataset
WHERE LENGTH(new_tests_smoothed) = (SELECT MAX(LENGTH(new_tests_smoothed)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_tests_smoothed_per_thousand, '; ', LENGTH(new_tests_smoothed_per_thousand), '; ', '(', LENGTH(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', -1)), ')')) AS max_len_new_tests_smoothed_per_thousand FROM master_dataset
WHERE LENGTH(new_tests_smoothed_per_thousand) = (SELECT MAX(LENGTH(new_tests_smoothed_per_thousand)) FROM master_dataset);


SELECT DISTINCT(CONCAT(positive_rate, '; ', LENGTH(positive_rate), '; ', '(', LENGTH(SUBSTRING_INDEX(positive_rate, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(positive_rate, '.', -1)), ')')) AS max_len_positive_rate FROM master_dataset
WHERE LENGTH(positive_rate) = (SELECT MAX(LENGTH(positive_rate)) FROM master_dataset);


SELECT DISTINCT(CONCAT(tests_per_case, '; ', LENGTH(tests_per_case), '; ', '(', LENGTH(SUBSTRING_INDEX(tests_per_case, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(tests_per_case, '.', -1)), ')')) AS max_len_tests_per_case FROM master_dataset
WHERE LENGTH(tests_per_case) = (SELECT MAX(LENGTH(tests_per_case)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_vaccinations, '; ', LENGTH(total_vaccinations), '; ', '(', LENGTH(SUBSTRING_INDEX(total_vaccinations, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_vaccinations, '.', -1)), ')')) AS max_len_total_vaccinations FROM master_dataset
WHERE LENGTH(total_vaccinations) = (SELECT MAX(LENGTH(total_vaccinations)) FROM master_dataset);


SELECT DISTINCT(CONCAT(people_vaccinated, '; ', LENGTH(people_vaccinated), '; ', '(', LENGTH(SUBSTRING_INDEX(people_vaccinated, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(people_vaccinated, '.', -1)), ')')) AS max_len_people_vaccinated FROM master_dataset
WHERE LENGTH(people_vaccinated) = (SELECT MAX(LENGTH(people_vaccinated)) FROM master_dataset);


SELECT DISTINCT(CONCAT(people_fully_vaccinated, '; ', LENGTH(people_fully_vaccinated), '; ', '(', LENGTH(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(people_fully_vaccinated, '.', -1)), ')')) AS max_len_people_fully_vaccinated FROM master_dataset
WHERE LENGTH(people_fully_vaccinated) = (SELECT MAX(LENGTH(people_fully_vaccinated)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_boosters, '; ', LENGTH(total_boosters), '; ', '(', LENGTH(SUBSTRING_INDEX(total_boosters, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_boosters, '.', -1)), ')')) AS max_len_total_boosters FROM master_dataset
WHERE LENGTH(total_boosters) = (SELECT MAX(LENGTH(total_boosters)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_vaccinations, '; ', LENGTH(new_vaccinations), '; ', '(', LENGTH(SUBSTRING_INDEX(new_vaccinations, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_vaccinations, '.', -1)), ')')) AS max_len_new_vaccinations FROM master_dataset
WHERE LENGTH(new_vaccinations) = (SELECT MAX(LENGTH(new_vaccinations)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_vaccinations_smoothed, '; ', LENGTH(new_vaccinations_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_vaccinations_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_vaccinations_smoothed, '.', -1)), ')')) AS max_len_new_vaccinations_smoothed FROM master_dataset
WHERE LENGTH(new_vaccinations_smoothed) = (SELECT MAX(LENGTH(new_vaccinations_smoothed)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_vaccinations_per_hundred, '; ', LENGTH(total_vaccinations_per_hundred), '; ', '(', LENGTH(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', -1)), ')')) AS max_len_total_vaccinations_per_hundred FROM master_dataset
WHERE LENGTH(total_vaccinations_per_hundred) = (SELECT MAX(LENGTH(total_vaccinations_per_hundred)) FROM master_dataset);


SELECT DISTINCT(CONCAT(people_vaccinated_per_hundred, '; ', LENGTH(people_vaccinated_per_hundred), '; ', '(', LENGTH(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', -1)), ')')) AS max_len_people_vaccinated_per_hundred FROM master_dataset
WHERE LENGTH(people_vaccinated_per_hundred) = (SELECT MAX(LENGTH(people_vaccinated_per_hundred)) FROM master_dataset);


SELECT DISTINCT(CONCAT(people_fully_vaccinated_per_hundred, '; ', LENGTH(people_fully_vaccinated_per_hundred), '; ', '(', LENGTH(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', -1)), ')')) AS max_len_people_fully_vaccinated_per_hundred FROM master_dataset
WHERE LENGTH(people_fully_vaccinated_per_hundred) = (SELECT MAX(LENGTH(people_fully_vaccinated_per_hundred)) FROM master_dataset);


SELECT DISTINCT(CONCAT(total_boosters_per_hundred, '; ', LENGTH(total_boosters_per_hundred), '; ', '(', LENGTH(SUBSTRING_INDEX(total_boosters_per_hundred, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(total_boosters_per_hundred, '.', -1)), ')')) AS max_len_total_boosters_per_hundred FROM master_dataset
WHERE LENGTH(total_boosters_per_hundred) = (SELECT MAX(LENGTH(total_boosters_per_hundred)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_vaccinations_smoothed_per_million, '; ', LENGTH(new_vaccinations_smoothed_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(new_vaccinations_smoothed_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_vaccinations_smoothed_per_million, '.', -1)), ')')) AS max_len_new_vaccinations_smoothed_per_million FROM master_dataset
WHERE LENGTH(new_vaccinations_smoothed_per_million) = (SELECT MAX(LENGTH(new_vaccinations_smoothed_per_million)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_people_vaccinated_smoothed, '; ', LENGTH(new_people_vaccinated_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed, '.', -1)), ')')) AS max_len_new_people_vaccinated_smoothed FROM master_dataset
WHERE LENGTH(new_people_vaccinated_smoothed) = (SELECT MAX(LENGTH(new_people_vaccinated_smoothed)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_people_vaccinated_smoothed_per_hundred, '; ', LENGTH(new_people_vaccinated_smoothed_per_hundred), '; ', '(', LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', -1)), ')')) AS max_len_new_people_vaccinated_smoothed_per_hundred FROM master_dataset
WHERE LENGTH(new_people_vaccinated_smoothed_per_hundred) = (SELECT MAX(LENGTH(new_people_vaccinated_smoothed_per_hundred)) FROM master_dataset);


SELECT DISTINCT(CONCAT(stringency_index, '; ', LENGTH(stringency_index), '; ', '(', LENGTH(SUBSTRING_INDEX(stringency_index, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(stringency_index, '.', -1)), ')')) AS max_len_stringency_index FROM master_dataset
WHERE LENGTH(stringency_index) = (SELECT MAX(LENGTH(stringency_index)) FROM master_dataset);


SELECT DISTINCT(CONCAT(population_density, '; ', LENGTH(population_density), '; ', '(', LENGTH(SUBSTRING_INDEX(population_density, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(population_density, '.', -1)), ')')) AS max_len_population_density FROM master_dataset
WHERE LENGTH(population_density) = (SELECT MAX(LENGTH(population_density)) FROM master_dataset);


SELECT DISTINCT(CONCAT(median_age, '; ', LENGTH(median_age), '; ', '(', LENGTH(SUBSTRING_INDEX(median_age, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(median_age, '.', -1)), ')')) AS max_len_median_age FROM master_dataset
WHERE LENGTH(median_age) = (SELECT MAX(LENGTH(median_age)) FROM master_dataset);


SELECT DISTINCT(CONCAT(aged_65_older, '; ', LENGTH(aged_65_older), '; ', '(', LENGTH(SUBSTRING_INDEX(aged_65_older, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(aged_65_older, '.', -1)), ')')) AS max_len_aged_65_older FROM master_dataset
WHERE LENGTH(aged_65_older) = (SELECT MAX(LENGTH(aged_65_older)) FROM master_dataset);


SELECT DISTINCT(CONCAT(aged_70_older, '; ', LENGTH(aged_70_older), '; ', '(', LENGTH(SUBSTRING_INDEX(aged_70_older, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(aged_70_older, '.', -1)), ')')) AS max_len_aged_70_older FROM master_dataset
WHERE LENGTH(aged_70_older) = (SELECT MAX(LENGTH(aged_70_older)) FROM master_dataset);


SELECT DISTINCT(CONCAT(gdp_per_capita, '; ', LENGTH(gdp_per_capita), '; ', '(', LENGTH(SUBSTRING_INDEX(gdp_per_capita, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(gdp_per_capita, '.', -1)), ')')) AS max_len_gdp_per_capita FROM master_dataset
WHERE LENGTH(gdp_per_capita) = (SELECT MAX(LENGTH(gdp_per_capita)) FROM master_dataset);


SELECT DISTINCT(CONCAT(extreme_poverty, '; ', LENGTH(extreme_poverty), '; ', '(', LENGTH(SUBSTRING_INDEX(extreme_poverty, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(extreme_poverty, '.', -1)), ')')) AS max_len_extreme_poverty FROM master_dataset
WHERE LENGTH(extreme_poverty) = (SELECT MAX(LENGTH(extreme_poverty)) FROM master_dataset);


SELECT DISTINCT(CONCAT(cardiovasc_death_rate, '; ', LENGTH(cardiovasc_death_rate), '; ', '(', LENGTH(SUBSTRING_INDEX(cardiovasc_death_rate, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(cardiovasc_death_rate, '.', -1)), ')')) AS max_len_cardiovasc_death_rate FROM master_dataset
WHERE LENGTH(cardiovasc_death_rate) = (SELECT MAX(LENGTH(cardiovasc_death_rate)) FROM master_dataset);


SELECT DISTINCT(CONCAT(diabetes_prevalence, '; ', LENGTH(diabetes_prevalence), '; ', '(', LENGTH(SUBSTRING_INDEX(diabetes_prevalence, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(diabetes_prevalence, '.', -1)), ')')) AS max_len_diabetes_prevalence FROM master_dataset
WHERE LENGTH(diabetes_prevalence) = (SELECT MAX(LENGTH(diabetes_prevalence)) FROM master_dataset);


SELECT DISTINCT(CONCAT(female_smokers, '; ', LENGTH(female_smokers), '; ', '(', LENGTH(SUBSTRING_INDEX(female_smokers, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(female_smokers, '.', -1)), ')')) AS max_len_female_smokers FROM master_dataset
WHERE LENGTH(female_smokers) = (SELECT MAX(LENGTH(female_smokers)) FROM master_dataset);


SELECT DISTINCT(CONCAT(male_smokers, '; ', LENGTH(male_smokers), '; ', '(', LENGTH(SUBSTRING_INDEX(male_smokers, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(male_smokers, '.', -1)), ')')) AS max_len_male_smokers FROM master_dataset
WHERE LENGTH(male_smokers) = (SELECT MAX(LENGTH(male_smokers)) FROM master_dataset);


SELECT DISTINCT(CONCAT(handwashing_facilities, '; ', LENGTH(handwashing_facilities), '; ', '(', LENGTH(SUBSTRING_INDEX(handwashing_facilities, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(handwashing_facilities, '.', -1)), ')')) AS max_len_handwashing_facilities FROM master_dataset
WHERE LENGTH(handwashing_facilities) = (SELECT MAX(LENGTH(handwashing_facilities)) FROM master_dataset);


SELECT DISTINCT(CONCAT(hospital_beds_per_thousand, '; ', LENGTH(hospital_beds_per_thousand), '; ', '(', LENGTH(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', -1)), ')')) AS max_len_hospital_beds_per_thousand FROM master_dataset
WHERE LENGTH(hospital_beds_per_thousand) = (SELECT MAX(LENGTH(hospital_beds_per_thousand)) FROM master_dataset);


SELECT DISTINCT(CONCAT(life_expectancy, '; ', LENGTH(life_expectancy), '; ', '(', LENGTH(SUBSTRING_INDEX(life_expectancy, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(life_expectancy, '.', -1)), ')')) AS max_len_life_expectancy FROM master_dataset
WHERE LENGTH(life_expectancy) = (SELECT MAX(LENGTH(life_expectancy)) FROM master_dataset);


SELECT DISTINCT(CONCAT(human_development_index, '; ', LENGTH(human_development_index), '; ', '(', LENGTH(SUBSTRING_INDEX(human_development_index, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(human_development_index, '.', -1)), ')')) AS max_len_human_development_index FROM master_dataset
WHERE LENGTH(human_development_index) = (SELECT MAX(LENGTH(human_development_index)) FROM master_dataset);


SELECT DISTINCT(CONCAT(population, '; ', LENGTH(population), '; ', '(', LENGTH(SUBSTRING_INDEX(population, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(population, '.', -1)), ')')) AS max_len_population FROM master_dataset
WHERE LENGTH(population) = (SELECT MAX(LENGTH(population)) FROM master_dataset);


SELECT DISTINCT(CONCAT(excess_mortality_cumulative_absolute, '; ', LENGTH(excess_mortality_cumulative_absolute), '; ', '(', LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', -1)), ')')) AS max_len_excess_mortality_cumulative_absolute FROM master_dataset
WHERE LENGTH(excess_mortality_cumulative_absolute) = (SELECT MAX(LENGTH(excess_mortality_cumulative_absolute)) FROM master_dataset);


SELECT DISTINCT(CONCAT(excess_mortality_cumulative, '; ', LENGTH(excess_mortality_cumulative), '; ', '(', LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative, '.', -1)), ')')) AS max_len_excess_mortality_cumulative FROM master_dataset
WHERE LENGTH(excess_mortality_cumulative) = (SELECT MAX(LENGTH(excess_mortality_cumulative)) FROM master_dataset);


SELECT DISTINCT(CONCAT(excess_mortality, '; ', LENGTH(excess_mortality), '; ', '(', LENGTH(SUBSTRING_INDEX(excess_mortality, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(excess_mortality, '.', -1)), ')')) AS max_len_excess_mortality FROM master_dataset
WHERE LENGTH(excess_mortality) = (SELECT MAX(LENGTH(excess_mortality)) FROM master_dataset);


SELECT DISTINCT(CONCAT(excess_mortality_cumulative_per_million, '; ', LENGTH(excess_mortality_cumulative_per_million), '; ', '(', LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', -1)), ')')) AS max_len_excess_mortality_cumulative_per_million FROM master_dataset
WHERE LENGTH(excess_mortality_cumulative_per_million) = (SELECT MAX(LENGTH(excess_mortality_cumulative_per_million)) FROM master_dataset);



-- RESULTS:
-- The following are the appropriate data-types for all 67 features, inclusive of the only temporal feature, date:


/* Hierarchically-subsetting Features (desc order)	
	
-- continent AS
-- location AS
-- _date_ AS

*/

/* Fixed Features per Location		

-- iso_code	AS	
-- population AS	
-- population_density AS	
-- median_age AS
-- aged_65_older AS		
-- aged_70_older AS		
-- gdp_per_capita AS		
-- extreme_poverty AS		
-- cardiovasc_death_rate AS		
-- diabetes_prevalence AS		
-- female_smokers AS		
-- male_smokers	AS	
-- handwashing_facilities AS		
-- hospital_beds_per_thousand AS		
-- life_expectancy AS		
-- human_development_index AS	

*/	


-- Dynamic Features per Date (Grouped):

/* Tests & Positivity:

-- new_tests AS
-- tests_units AS
-- total_tests AS
-- total_tests_per_thousand AS
-- new_tests_per_thousand AS
-- new_tests_smoothed AS
-- new_tests_smoothed_per_thousand AS
-- positive_rate AS
-- tests_per_case AS

*/

/* Confirmed Cases:

-- new_cases AS
-- total_cases AS
-- total_cases_per_million AS
-- new_cases_smoothed AS
-- new_cases_per_million AS
-- new_cases_smoothed_per_million AS

*/

/* Hospital & ICU:

-- hosp_patients AS
-- icu_patients AS
-- weekly_hosp_admissions AS
-- weekly_icu_admissions AS
-- hosp_patients_per_million AS
-- icu_patients_per_million AS
-- weekly_hosp_admissions_per_million AS
-- weekly_icu_admissions_per_million AS

*/

/* Confirmed Deaths:

-- new_deaths AS
-- total_deaths AS
-- new_deaths_smoothed AS
-- total_deaths_per_million AS
-- new_deaths_per_million AS
-- new_deaths_smoothed_per_million AS

*/

/* Vaccinations:

-- new_vaccinations AS
-- people_vaccinated AS
-- people_fully_vaccinated AS
-- total_boosters AS
-- total_vaccinations AS
-- new_vaccinations_smoothed AS
-- total_vaccinations_per_hundred AS
-- people_vaccinated_per_hundred AS
-- people_fully_vaccinated_per_hundred AS
-- total_boosters_per_hundred AS
-- new_vaccinations_smoothed_per_million AS
-- new_people_vaccinated_smoothed AS
-- new_people_vaccinated_smoothed_per_hundred AS

*/

/* Excess Mortality:

-- excess_mortality AS
-- excess_mortality_cumulative AS
-- excess_mortality_cumulative_absolute AS
-- excess_mortality_cumulative_per_million AS

*/




-- whole numbers: 
-- decimal numbers
-- dates
-- strings





