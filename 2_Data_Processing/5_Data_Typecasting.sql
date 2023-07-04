/* Type-casting Features with Different Data-types:

As per the previous analysis, there may be an issue with data features, the data-types being used, and possibly even the table itself.
The queries that follow will delve into each of these to discover the root cause.
*/

-- Type-casting the excess_mortality_cumulative_per_million from the master_dataset: 
SELECT location, date_, CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) AS same_feature_different_table
FROM master_dataset
ORDER BY excess_mortality_cumulative_per_million DESC;
-- This issue persists in the master_dataset table as well, narrowing down the issue to most likely be residing in the data features or the data-types being casted.


/* Features with continuous numerical values:

These are a few of the features with continuous numerical values:
• positive_rate
• reproduction_rate (this feature is also not ideal for sorting because there needs to be multiple whole digits with variances between the number of whole digits)
• new_cases_smoothed
• excess_mortality

*/

/* Important! The positive_rate feature is not ideal for confirming incorrect sorting of numerical values in a string data-type.
There needs to be multiple whole digits with variances between the number of whole digits to ascertain that the numerical values are being incorrectly sorted.
For confirmation, running the query below will show that the positive_rate values are being correctly sorted in spite of being string values.
*/
SELECT location, date_, positive_rate, CAST(positive_rate AS DECIMAL(5, 5)) AS casted_positive_rate, 
CASE WHEN positive_rate = CAST(positive_rate AS DECIMAL(5, 5)) THEN "True" ELSE "False" END AS "T_or_F"
FROM master_dataset
ORDER BY positive_rate ASC; -- Substitute the "positive_rate", following the ORDER BY clause, with "T_or_F"  to confirm there is only 1 False value in the T_or_F column.
-- Note that the query above is being sorted in DESC order by positive_rate and NOT by casted_positive_rate and yet the sorted order is numerically correct.

/* Important! Type-casting did not alter the values of the positive_rate feature. 
The only instance of False in the T_or_F column belongs to the following record: 'Curacao', '2021-12-08', '1.0', '0.99999', 'False'.
The penultimate item in this list, i.e., 0.99999, is the one value that was altered to be less than 1.
Based on previous queries as well, it is reasonable to assume that casting the DECIMAL data-type is altering the casted values to be restricted within (-1, 1).
*/


-- Upon researching MySQL data-types, it became clear that the arguments were incorrectly passed into the data-type parameter.
-- The following 2 queries demonstrate the correct output once the data-type arguments were readjusted:

-- 1)
SELECT location, date_, excess_mortality_cumulative_per_million, CAST(excess_mortality_cumulative_per_million AS DECIMAL(60, 30)) AS casted_excess_mortality_cumulative_per_million,
CASE WHEN excess_mortality_cumulative_per_million = CAST(excess_mortality_cumulative_per_million AS DECIMAL(60, 30)) THEN "True" ELSE "False" END AS "T_or_F"
FROM master_dataset
ORDER BY T_or_F ASC; -- There are no False values in the T_or_F column; the excess_mortality_cumulative_per_million feature was correctly type-casted.

-- 2)
SELECT location, date_, positive_rate, CAST(positive_rate AS DECIMAL(10, 5)) AS casted_positive_rate, 
CASE WHEN positive_rate = CAST(positive_rate AS DECIMAL(10, 5)) THEN "True" ELSE "False" END AS "T_or_F"
FROM master_dataset
ORDER BY T_or_F ASC; -- There are no False values in the T_or_F column; the positive_rate feature was correctly type-casted.

-- IMPORTANT! The DECIMAL data-type has 2 parameters but the arguments were not implemented correctly. 
-- The 1st parameter is size or precision which represents the total number of digits. The 2nd parameter, d or scale, represents the number of digits after the decimal point.
-- The previous queries were erred because (30, 30) will type-cast or restrict any numbers larger than 0 to be less than 1 since size = d.
-- This issue occurred due to the erred assumption that each argument respectively represents the number of digits to the left and right side of the decimal point. 



-- IMPORTANT! For future reference, it is always best practice to review the relevant documentation when there is a reoccurring error in the query.
-- Test-running your queries on a smaller sample data is the ideal approach as it can be overwhelming to repeatedly review the results of large datasets being queried. 


-- The following was ascertained about data-types in the current 8.0.32 version of MySQL:

/* Data-type Syntax - Update for MySQL 8.0.32:

In MySQL 8.0.32, the following data types support a size parameter:

BINARY
CHAR
DECIMAL
VARBINARY
VARCHAR


In MySQL 8.0.32, the following data types do NOT support a size parameter:

BIT
BLOB
BOOLEAN
DATE
DATETIME
DOUBLE
ENUM
FLOAT
GEOMETRY
JSON
MEDIUMBLOB
SMALLINT
MEDIUMINT
INT
BIGINT
TEXT
MEDIUMTEXT
LONGTEXT
POINT
SET
TIME
TIMESTAMP
*/



-- Type-casting Features with Discrete Numerical-values:

/* Features with discrete numerical values:

These are a few of the features with discrete numerical values:
• new_cases
• new_tests
• new_deaths

*/

-- In the following query of type-casting, there are no False values, i.e., INT is an appropriate data-type for the new_cases feature.
SELECT location, date_, new_cases, CAST(new_cases AS UNSIGNED INT) AS casted_new_cases,
CASE WHEN new_cases = CAST(new_cases AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM master_dataset
ORDER BY T_or_F ASC; 


-- The new_cases feature consists of 8,633 NULLS or empty strings 
SELECT COUNT(new_cases)
FROM master_dataset
WHERE new_cases = '';
 
-- The zeroes are being correctly type-casted as zeroes.
SELECT location, date_, new_cases, CAST(new_cases AS UNSIGNED INT) AS casted_new_cases,
CASE WHEN new_cases = CAST(new_cases AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM master_dataset
ORDER BY casted_new_cases ASC; 

-- In spite of T_or_F consisting entirely of True values, the NULLS have been type-casted as 0s. This needs to accounted for when altering the features.
SELECT location, date_, new_cases, CAST(new_cases AS UNSIGNED INT) AS casted_new_cases,
CASE WHEN new_cases = CAST(new_cases AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM master_dataset
WHERE new_cases = ''
ORDER BY casted_new_cases ASC; 



-- Next Steps:
-- 1) The MAX field length of every feature in the dataset will be queried before determining the appropriate data-type conversion for each feature.
-- 2) Automate via python the SQL queries for typecasting with data-types determined from 1) and confirm the type-casted fields are equivalent to the original VARCHAR fields with a Boolean feature.
-- 3) Apply the ALTER TABLE query to update the entire table with the appropriate data-types. Reorder the features according to the feature categorization completed in the Metadata Report.
--    Note: When altering the entire table from VARCHAR, the empty strings need to be converted into NULLS, not into 0s as it is the case when type-casting.

