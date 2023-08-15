-- Identifying Feature Issues:

DESCRIBE testing_table; -- This command can confirm whether or not the data-type of the features have been altered.

/* Test Table:

The subsequent 2 SQL statements will be used as a back-up table when constructing the SQL commands to permanently alter the data_load table.
If the data_load table is used in this process, the LOAD INFILE commands would have to be repeatedly executed every time from the 2_LDI.sql file whenever 
a different SQL command test is required on the same feature.

*/
-- REFRESH the dataset with the following DROP and CREATE commands below: 
DROP TABLE IF EXISTS testing_table;
CREATE TABLE testing_table AS
SELECT * FROM data_load;



-- ALTER Statement Issue #1:
-- As stated in Analyzing_Feature_Anomaly.sql, both the UPDATE and ALTER statements need to be run a second time for a confirmation of the feature's data-type conversion.
-- There is a warning sign that is indicative of a potential error in the command. Upon hovering over the empty message field in the output tab, numerous errors for code 1366 are displayed. 
-- The "syntax" of the error message is as follows: 1366 Incorrect data_type value: problematic_field_value for column column_name at row # 

-- A sample message of error code 1366 from the subsequent command is as follows: "1366 Incorrect integer value: '' for column 'new_cases' at row 75" 
SET sql_mode = '';
ALTER TABLE testing_table MODIFY new_cases INT UNSIGNED; 
-- UNSIGNED means only positive values will exist in the range of values.
-- As per the confirmation during the data integrity check, all numerically discrete features have exclusively positive values. 
-- The SQL statement above resulted with the error message at numerous rows asides from row 75. 

-- The following query confirms the first empty string at row 75.
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, new_cases
FROM data_load; -- Note: The data_load table has not yet been altered or updated when this query reveals an empty string at row 75.
 
SELECT CAST('' AS SIGNED INT) AS converted_value; -- An empty string will be altered to a 0 without error when data-type conversion is at work.
                                                  -- However, an empty string should NOT exist in a numerical data-type feature.
SELECT CAST(NULL AS SIGNED INT) AS converted_value; -- A NULL value will remain as NULL when data-type conversion is at work. 


/* ALTER Command without Adjustment to sql_mode:

To avoid closing and starting a new session, the sql_mode global default variables have been copied and pasted to equal the SET sql_mode command.
This session does not have to be restarted, however, the testing_table will still have to be REFRESHED. 

*/
SELECT @@GLOBAL.sql_mode;
SET sql_mode = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';
SELECT @@SESSION.sql_mode; -- This query will confirm that the sql_mode of the current session is no longer an empty string.
-- REFRESH testing_table first!
ALTER TABLE testing_table MODIFY new_cases INT UNSIGNED; 
/*IMPORTANT! Adjustment to sql_mode does not resolve error 1366.

Without any adjustment to sql_mode, there is a only a SINGLE INSTANCE of error 1366 displayed at row 75 but the error still exists in 
many of the remaining rows of this feature. However, with an adjustment to sql_mode, the SQL command is still being executed in spite 
of error 1366 still persisting since the adjustment only allows for the initial error message to be bypassed so the command can continue.

*/

/* Solution: Under "Next Steps" in Data_Integrity_Check.sql, addressing b) of step 4 will also likely address error code 1366.

(1) Replace the empty strings in the testing_table's numerical features with NULL.
(2) Execute the ALTER command only when (1) has been completed for all numerical features.

*/



-- ALTER Statement Issue #2:
-- The same error has occurred in the following SQL command but the message is unclear in its meaning. 

ALTER TABLE testing_table MODIFY excess_mortality_cumulative_per_million DECIMAL(20, 8);
-- Error Code: 1366. Incorrect DECIMAL value: '0' for column '' at row -1
-- The excess_mortality_cumulative_per_million feature is not being represented in the error message and it may be safe to assume that '0' is the cause of error 1366. 

-- As confirmed in 3_LDI_Completeness.sql, empty strings and NULLS are not recognized; only 0s are recognized in the following 2 queries. 
-- However, there are no 0s visible in this feature, even though the feature can be filtered using the WHERE keyword with 0 as shown belown.
-- The blanks in this feature are visible but are being treated as 0s. 
-- At this point in time, excess_mortality_cumulative_per_million is the only feature confirmed to behave anomalously with respect to the DECIMAL data-type conversion via the ALTER command.
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, excess_mortality_cumulative_per_million
FROM data_load
WHERE excess_mortality_cumulative_per_million = 0; 

SET @index = 0;
SELECT (@index := @index + 1) AS index_column, excess_mortality_cumulative_per_million
FROM data_load
WHERE excess_mortality_cumulative_per_million != 0; 



-- IMPORTANT! When type-casting was done, there were no errors but when attempting to use the ALTER command to make permanent changes in a table, error 1366 reoccurs for different reasons.

-- The following table was created to ascertain the causes for error 1366. 
DROP TABLE IF EXISTS error_1366_testing_table;
CREATE TABLE error_1366_testing_table (
	varchar_values VARCHAR(100),
    empty_field_values VARCHAR(100), -- The empty_field_values column is for reaffirming "ALTER Statement Issue #1".
    decimal_values VARCHAR(100) -- The decimal_values column is for reaffirming "ALTER Statement Issue #2".
    );
    
INSERT INTO error_1366_testing_table (varchar_values, empty_field_values, decimal_values)
VALUES -- Values are added in the form of records:
('abc', '324', '324'),
('def0', '2.02', '0.0021'),
('ghi123', '7.0', '0.0'),
('jkl45', '767', '767.006'),
('mn', '13', '0000.103'),
('opqr6789', '254.0000', '254.0000'),
('s', '843.42003', '843.42003'),
('tuvwxyz', '0043.9003', '000.42003'),
('abc', '-324', '-324'),
('def0', '', '-0.000'),  
('ghi123', NULL, '0'),
('jkl45', '-68', '-767.006'),
('mn', '-13', '-0000.103'),
('opqr6789', '-254.0000', '-254.0000'),
('s', '-843.42003', '-843.42003'),
('tuvwxyz', '-0043.9003', '-003.42003');


SELECT CAST(decimal_values AS DECIMAL(20, 8)) AS type_casted_decimal_values FROM error_1366_testing_table;
ALTER TABLE error_1366_testing_table MODIFY decimal_values DECIMAL(20, 8);
SELECT decimal_values FROM error_1366_testing_table;
-- The expected error 1366 does NOT occurs when the ALTER command is run for the decimal_values column.
-- The error message of "ALTER Statement Issue #2" implies that error 1366 is due to the '0' fields of the excess_mortality_cumulative_per_million feature. 
-- However, the '0' at row 11 in the decimal_values column does not appear to affect the data-type conversion in this case. 
-- Furthermore, it is safe to attribute the behaviour of the excess_mortality_cumulative_per_million feature as an anomaly.

SELECT CAST(empty_field_values AS SIGNED INT) AS type_casted_empty_field_values FROM error_1366_testing_table;
ALTER TABLE error_1366_testing_table MODIFY empty_field_values INT SIGNED; 
SELECT empty_field_values FROM error_1366_testing_table;
-- The expected error 1366 occurs when the ALTER command is run for the empty_field_values column. 
-- Error 1366 is also resolved once the empty string in row 10 is replaced by NULL. 

DESCRIBE error_1366_testing_table; -- Run this command to view the columns' current data-types.



-- CONCLUSION: 
-- All features will have to be tested with the ALTER command to identify any other possible errors that need to be resolved prior to creating the "master_dataset".
-- On that note, the aforementioned Step 4 in the Data_Integrity_Check.sql file will only be completed once any additional errors have been identified and resolved. 

-- The following commands will run through every feature to identify any other errors when the ALTER command is in use: 
-- REFRESH testing_table before running commands below.

ALTER TABLE testing_table MODIFY iso_code VARCHAR(10); -- NO Error

ALTER TABLE testing_table MODIFY continent VARCHAR(20); -- NO Error

ALTER TABLE testing_table MODIFY location VARCHAR(40); -- NO Error

ALTER TABLE testing_table MODIFY tests_units VARCHAR(20); -- NO Error

ALTER TABLE testing_table MODIFY _date_ DATE; -- NO Error


/* The following 62 SQL commands cause an error: 

Any new errors, exclusively different from the errors associated with "ALTER Statement Issue #1" and "ALTER Statement Issue #2",
will be listed along with the command.

*/

SET sql_mode = '';

ALTER TABLE testing_table MODIFY population INT UNSIGNED; -- 299237 row(s) affected, 1024 warning(s): 1264 Out of range value for column 'population' at row 14196 

-- ALTER Statement Issue #3
-- The third issue uncovered is found exclusively with the population feature. No other feature appears to have this error.

-- The remaining numerically discrete features below all consist of the same error 1366 that is associated with "ALTER Statement Issue #1".
ALTER TABLE testing_table MODIFY total_cases INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_cases INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_tests INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_tests INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_tests_smoothed INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_deaths INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_deaths INT UNSIGNED; 

ALTER TABLE testing_table MODIFY icu_patients INT UNSIGNED; 

ALTER TABLE testing_table MODIFY hosp_patients INT UNSIGNED; 

ALTER TABLE testing_table MODIFY weekly_icu_admissions INT UNSIGNED; 

ALTER TABLE testing_table MODIFY weekly_hosp_admissions INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_vaccinations INT UNSIGNED; 

ALTER TABLE testing_table MODIFY people_vaccinated INT UNSIGNED; 

ALTER TABLE testing_table MODIFY people_fully_vaccinated INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_boosters INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_vaccinations INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_vaccinations_smoothed INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_vaccinations_smoothed_per_million INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_people_vaccinated_smoothed INT UNSIGNED; 


/* The numerically continuous features below all consist of the same anomalous error 1366 that is associated with "ALTER Statement Issue #2":

Note: Error 1292, i.e., 1292 Truncated incorrect DECIMAL value: '', was also displayed for each of the features below.
However, error 1292 is only a result of sql_mode being set to an empty string, and hence, it can be disregarded, i.e., 
it does not need to be resolved. 

*/
-- Error: 1366 Incorrect DECIMAL value: '0' for column '' at row -1                                          
ALTER TABLE testing_table MODIFY new_cases_smoothed DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY new_deaths_smoothed DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY total_cases_per_million DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY new_cases_per_million DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY new_cases_smoothed_per_million DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY total_deaths_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY new_deaths_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY new_deaths_smoothed_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY reproduction_rate DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY icu_patients_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY hosp_patients_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY weekly_icu_admissions_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY weekly_hosp_admissions_per_million DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY total_tests_per_thousand DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY new_tests_per_thousand DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY new_tests_smoothed_per_thousand DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY positive_rate DECIMAL(10, 4);

ALTER TABLE testing_table MODIFY tests_per_case DECIMAL(10, 1);

ALTER TABLE testing_table MODIFY total_vaccinations_per_hundred DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY people_vaccinated_per_hundred DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY people_fully_vaccinated_per_hundred DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY total_boosters_per_hundred DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY new_people_vaccinated_smoothed_per_hundred DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY stringency_index DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY population_density DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY median_age DECIMAL(10, 1);

ALTER TABLE testing_table MODIFY aged_65_older DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY aged_70_older DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY gdp_per_capita DECIMAL(20, 3);

ALTER TABLE testing_table MODIFY extreme_poverty DECIMAL(10, 1);

ALTER TABLE testing_table MODIFY cardiovasc_death_rate DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY diabetes_prevalence DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY female_smokers DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY male_smokers DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY handwashing_facilities DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY hospital_beds_per_thousand DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY life_expectancy DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY human_development_index DECIMAL(10, 3);

ALTER TABLE testing_table MODIFY excess_mortality_cumulative_absolute DECIMAL(20, 8);

ALTER TABLE testing_table MODIFY excess_mortality_cumulative DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY excess_mortality DECIMAL(10, 2);

ALTER TABLE testing_table MODIFY excess_mortality_cumulative_per_million DECIMAL(20, 8);
-- excess_mortality_cumulative_per_million is the only feature behaving anomalously with respect to 0s being displayed as blanks in its rows. 

-- As confirmed previously on multiple accounts, excess_mortality_cumulative_per_million is an anomalous feature.
-- However, the remaining numerically continuous features are (apparently) not anomalous and yet, they have the same error message as excess_mortality_cumulative_per_million. 
-- This invites the probability of other features of being anomalous in the same manner as excess_mortality_cumulative_per_million but having gone unchecked.

-- The queries below are demonstrative of the previously mentioned anomaly of the excess_mortality_cumulative_per_million feature.
SELECT excess_mortality_cumulative_per_million
FROM data_load
WHERE excess_mortality_cumulative_per_million = ''; -- Returns nothing.

SELECT excess_mortality_cumulative_per_million
FROM data_load
WHERE excess_mortality_cumulative_per_million = 0; -- Returns the blanks within this feature instead of 0s.

-- As demonstrated below for the feature, new_cases_smoothed, there is no anomaly compared to the anomaly observed in excess_mortality_cumulative_per_million. 
-- However, this needs to be confirmed for every other feature that is not the excess_mortality_cumulative_per_million feature. 
SELECT location, _date_, new_cases_smoothed FROM testing_table
WHERE new_cases_smoothed = ''; -- Returns exclusively ALL empty strings.

SELECT location, _date_, new_cases_smoothed FROM testing_table
WHERE new_cases_smoothed = 0; -- Returns All empty strings and 0s.


-- The REMAINING numerically continuous features have been confirmed to not be an anomaly: 
SELECT new_cases_smoothed
FROM testing_table
WHERE new_cases_smoothed = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_deaths_smoothed
FROM testing_table
WHERE new_deaths_smoothed = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT total_cases_per_million
FROM testing_table
WHERE total_cases_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_cases_per_million
FROM testing_table
WHERE new_cases_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_cases_smoothed_per_million
FROM testing_table
WHERE new_cases_smoothed_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT total_deaths_per_million
FROM testing_table
WHERE total_deaths_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_deaths_per_million
FROM testing_table
WHERE new_deaths_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_deaths_smoothed_per_million
FROM testing_table
WHERE new_deaths_smoothed_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT reproduction_rate
FROM testing_table
WHERE reproduction_rate = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT icu_patients_per_million
FROM testing_table
WHERE icu_patients_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT hosp_patients_per_million
FROM testing_table
WHERE hosp_patients_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT weekly_icu_admissions_per_million
FROM testing_table
WHERE weekly_icu_admissions_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT weekly_hosp_admissions_per_million
FROM testing_table
WHERE weekly_hosp_admissions_per_million = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT total_tests_per_thousand
FROM testing_table
WHERE total_tests_per_thousand = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_tests_per_thousand
FROM testing_table
WHERE new_tests_per_thousand = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_tests_smoothed_per_thousand
FROM testing_table
WHERE new_tests_smoothed_per_thousand = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT positive_rate
FROM testing_table
WHERE positive_rate = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT tests_per_case
FROM testing_table
WHERE tests_per_case = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT total_vaccinations_per_hundred
FROM testing_table
WHERE total_vaccinations_per_hundred = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT people_vaccinated_per_hundred
FROM testing_table
WHERE people_vaccinated_per_hundred = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT people_fully_vaccinated_per_hundred
FROM testing_table
WHERE people_fully_vaccinated_per_hundred = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT total_boosters_per_hundred
FROM testing_table
WHERE total_boosters_per_hundred = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT new_people_vaccinated_smoothed_per_hundred
FROM testing_table
WHERE new_people_vaccinated_smoothed_per_hundred = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT stringency_index
FROM testing_table
WHERE stringency_index = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT population_density
FROM testing_table
WHERE population_density = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT median_age
FROM testing_table
WHERE median_age = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT aged_65_older
FROM testing_table
WHERE aged_65_older = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT aged_70_older
FROM testing_table
WHERE aged_70_older = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT gdp_per_capita
FROM testing_table
WHERE gdp_per_capita = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT extreme_poverty
FROM testing_table
WHERE extreme_poverty = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT cardiovasc_death_rate
FROM testing_table
WHERE cardiovasc_death_rate = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT diabetes_prevalence
FROM testing_table
WHERE diabetes_prevalence = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT female_smokers
FROM testing_table
WHERE female_smokers = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT male_smokers
FROM testing_table
WHERE male_smokers = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT handwashing_facilities
FROM testing_table
WHERE handwashing_facilities = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT hospital_beds_per_thousand
FROM testing_table
WHERE hospital_beds_per_thousand = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT life_expectancy
FROM testing_table
WHERE life_expectancy = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT human_development_index
FROM testing_table
WHERE human_development_index = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT excess_mortality_cumulative_absolute
FROM testing_table
WHERE excess_mortality_cumulative_absolute = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT excess_mortality_cumulative
FROM testing_table
WHERE excess_mortality_cumulative = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT excess_mortality
FROM testing_table
WHERE excess_mortality = '';
-- Confirmed. Query returns exclusively empty strings unlike excess_mortality_cumulative_per_million which returns nothing.

SELECT excess_mortality_cumulative_per_million
FROM testing_table
WHERE excess_mortality_cumulative_per_million = '';
-- This query returns nothing for this feature.

-- Note: In this case, i.e., for all numerically continuous features but the excess_mortality_cumulative_per_million feature, the UPDATE command will be used to replace the empty strings with NULL.


-- The errors that have been identified in this script will be resolved in 8B_Table_Preparation.sql. 


