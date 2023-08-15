-- Resolving Feature Issues - UPDATES:

DROP TABLE IF EXISTS testing_table;
CREATE TABLE testing_table AS
SELECT * FROM data_load;

-- ALTER Statement Issue #1:
-- Excluding the population feature, all remaining numerically discrete features result with the following version of error 1366. 
-- Sample Error Message: 1366 Incorrect integer value: '' for column 'new_cases' at row 75
UPDATE testing_table SET new_cases = NULL
WHERE new_cases = '';
ALTER TABLE testing_table MODIFY new_cases INT UNSIGNED; -- Successful ALTER command confirms error is resolved.


-- ALTER Statement Issue #2:
-- All of the numerically continuous features consist of the same anomalous version of error 1366.
-- Error Message: 1366. Incorrect DECIMAL value: '0' for column '' at row -1
-- The excess_mortality_cumulative_per_million feature is a special case within error 1366 due to its anomaly:
UPDATE testing_table SET excess_mortality_cumulative_per_million = NULL
WHERE excess_mortality_cumulative_per_million = 0;
ALTER TABLE testing_table MODIFY excess_mortality_cumulative_per_million DECIMAL(20, 8); -- Successful ALTER command confirms error is resolved.

-- For the remaining numerically continuous features that are not anomalous, the following UPDATE command will be executed:
UPDATE testing_table SET new_cases_smoothed = NULL -- Empty strings exclusively have been replaced with NULL.
WHERE new_cases_smoothed = ''; 
ALTER TABLE testing_table MODIFY new_cases_smoothed DECIMAL(10, 3); -- Successful ALTER command confirms error is resolved.


-- ALTER Statement Issue #3
-- The third issue uncovered is found exclusively with the population feature. No other feature appears to have this error.
ALTER TABLE testing_table MODIFY population INT UNSIGNED; -- 299237 row(s) affected, 1024 warning(s): 1264 Out of range value for column 'population' at row 14196 
ALTER TABLE testing_table MODIFY population BIGINT UNSIGNED; -- Reassigning the data-type with BIGINT UNSIGNED resolved error 1264.



-- REFRESH testing_table.
DROP TABLE IF EXISTS testing_table;
CREATE TABLE testing_table AS
SELECT * FROM data_load;

-- Below are the necessary UPDATE commands for the features that require it.
-- The following UPDATE commands will allow for successful ALTER commands for each feature:

-- NUMERICAL_DISCRETE_FEATURES (population feature does NOT require an UPDATE command)
UPDATE testing_table SET total_cases = NULL
WHERE total_cases = ''; 

UPDATE testing_table SET new_cases = NULL
WHERE new_cases = ''; 

UPDATE testing_table SET total_tests = NULL
WHERE total_tests = ''; 

UPDATE testing_table SET new_tests = NULL
WHERE new_tests = ''; 

UPDATE testing_table SET new_tests_smoothed = NULL
WHERE new_tests_smoothed = ''; 

UPDATE testing_table SET total_deaths = NULL
WHERE total_deaths = ''; 

UPDATE testing_table SET new_deaths = NULL
WHERE new_deaths = ''; 

UPDATE testing_table SET icu_patients = NULL
WHERE icu_patients = ''; 

UPDATE testing_table SET hosp_patients = NULL
WHERE hosp_patients = ''; 

UPDATE testing_table SET weekly_icu_admissions = NULL
WHERE weekly_icu_admissions = ''; 

UPDATE testing_table SET weekly_hosp_admissions = NULL
WHERE weekly_hosp_admissions = ''; 

UPDATE testing_table SET total_vaccinations = NULL
WHERE total_vaccinations = ''; 

UPDATE testing_table SET people_vaccinated = NULL
WHERE people_vaccinated = ''; 

UPDATE testing_table SET people_fully_vaccinated = NULL
WHERE people_fully_vaccinated = ''; 

UPDATE testing_table SET total_boosters = NULL
WHERE total_boosters = ''; 

UPDATE testing_table SET new_vaccinations = NULL
WHERE new_vaccinations = ''; 

UPDATE testing_table SET new_vaccinations_smoothed = NULL
WHERE new_vaccinations_smoothed = ''; 

UPDATE testing_table SET new_vaccinations_smoothed_per_million = NULL
WHERE new_vaccinations_smoothed_per_million = ''; 

UPDATE testing_table SET new_people_vaccinated_smoothed = NULL
WHERE new_people_vaccinated_smoothed = ''; 


-- NUMERICAL_CONTINUOUS_FEATURES:
UPDATE testing_table SET new_cases_smoothed = NULL
WHERE new_cases_smoothed = ''; 

UPDATE testing_table SET new_deaths_smoothed = NULL
WHERE new_deaths_smoothed = ''; 

UPDATE testing_table SET total_cases_per_million = NULL
WHERE total_cases_per_million = ''; 

UPDATE testing_table SET new_cases_per_million = NULL
WHERE new_cases_per_million = ''; 

UPDATE testing_table SET new_cases_smoothed_per_million = NULL
WHERE new_cases_smoothed_per_million = ''; 

UPDATE testing_table SET total_deaths_per_million = NULL
WHERE total_deaths_per_million = ''; 

UPDATE testing_table SET new_deaths_per_million = NULL
WHERE new_deaths_per_million = ''; 

UPDATE testing_table SET new_deaths_smoothed_per_million = NULL
WHERE new_deaths_smoothed_per_million = ''; 

UPDATE testing_table SET reproduction_rate = NULL
WHERE reproduction_rate = ''; 

UPDATE testing_table SET icu_patients_per_million = NULL
WHERE icu_patients_per_million = ''; 

UPDATE testing_table SET hosp_patients_per_million = NULL
WHERE hosp_patients_per_million = ''; 

UPDATE testing_table SET weekly_icu_admissions_per_million = NULL
WHERE weekly_icu_admissions_per_million = ''; 

UPDATE testing_table SET weekly_hosp_admissions_per_million = NULL
WHERE weekly_hosp_admissions_per_million = ''; 

UPDATE testing_table SET total_tests_per_thousand = NULL
WHERE total_tests_per_thousand = ''; 

UPDATE testing_table SET new_tests_per_thousand = NULL
WHERE new_tests_per_thousand = ''; 

UPDATE testing_table SET new_tests_smoothed_per_thousand = NULL
WHERE new_tests_smoothed_per_thousand = ''; 

UPDATE testing_table SET positive_rate = NULL
WHERE positive_rate = ''; 

UPDATE testing_table SET tests_per_case = NULL
WHERE tests_per_case = ''; 

UPDATE testing_table SET total_vaccinations_per_hundred = NULL
WHERE total_vaccinations_per_hundred = ''; 

UPDATE testing_table SET people_vaccinated_per_hundred = NULL
WHERE people_vaccinated_per_hundred = ''; 

UPDATE testing_table SET people_fully_vaccinated_per_hundred = NULL
WHERE people_fully_vaccinated_per_hundred = ''; 

UPDATE testing_table SET total_boosters_per_hundred = NULL
WHERE total_boosters_per_hundred = ''; 

UPDATE testing_table SET new_people_vaccinated_smoothed_per_hundred = NULL
WHERE new_people_vaccinated_smoothed_per_hundred = ''; 

UPDATE testing_table SET stringency_index = NULL
WHERE stringency_index = ''; 

UPDATE testing_table SET population_density = NULL
WHERE population_density = ''; 

UPDATE testing_table SET median_age = NULL
WHERE median_age = ''; 

UPDATE testing_table SET aged_65_older = NULL
WHERE aged_65_older = ''; 

UPDATE testing_table SET aged_70_older = NULL
WHERE aged_70_older = ''; 

UPDATE testing_table SET gdp_per_capita = NULL
WHERE gdp_per_capita = ''; 

UPDATE testing_table SET extreme_poverty = NULL
WHERE extreme_poverty = ''; 

UPDATE testing_table SET cardiovasc_death_rate = NULL
WHERE cardiovasc_death_rate = ''; 

UPDATE testing_table SET diabetes_prevalence = NULL
WHERE diabetes_prevalence = ''; 

UPDATE testing_table SET female_smokers = NULL
WHERE female_smokers = ''; 

UPDATE testing_table SET male_smokers = NULL
WHERE male_smokers = ''; 

UPDATE testing_table SET handwashing_facilities = NULL
WHERE handwashing_facilities = ''; 

UPDATE testing_table SET hospital_beds_per_thousand = NULL
WHERE hospital_beds_per_thousand = ''; 

UPDATE testing_table SET life_expectancy = NULL
WHERE life_expectancy = ''; 

UPDATE testing_table SET human_development_index = NULL
WHERE human_development_index = ''; 

UPDATE testing_table SET excess_mortality_cumulative_absolute = NULL
WHERE excess_mortality_cumulative_absolute = ''; 

UPDATE testing_table SET excess_mortality_cumulative = NULL
WHERE excess_mortality_cumulative = ''; 

UPDATE testing_table SET excess_mortality = NULL
WHERE excess_mortality = ''; 

-- excess_mortality_cumulative_per_million is a unique case:
UPDATE testing_table SET excess_mortality_cumulative_per_million = NULL
WHERE excess_mortality_cumulative_per_million = 0;

-- The UPDATE commands have respectively resolved each error. 



/* IMPORTANT!

The following queries confirm that 0 values in a feature can be counted, however, NULL values are NOT countable.

*/

SELECT location, _date_, new_cases_smoothed FROM testing_table
WHERE new_cases_smoothed = 0;

SELECT COUNT(new_cases_smoothed) FROM testing_table
WHERE new_cases_smoothed = 0; -- Returns 51,886

SELECT COUNT(new_cases_smoothed) FROM testing_table
WHERE new_cases_smoothed = ''; -- Count of empty strings returned 9,897 BEFORE UPDATE command was executed to replace empty strings with NULL.

SELECT new_cases_smoothed FROM testing_table
WHERE new_cases_smoothed IS NULL; -- Count of NULL should be 9,897 AFTER UPDATE command was executed to replace empty strings with NULL.
								  -- Need to confirm if this is correct.

SELECT COUNT(new_cases_smoothed) FROM testing_table
WHERE new_cases_smoothed IS NULL; -- NULL values are NOT countable, i.e., query returns 0.

SELECT COUNT(new_cases_smoothed) FROM testing_table
WHERE new_cases_smoothed IS NOT NULL; -- Returns 0 for the number of NULL so counted for the number of NOT NULL (289340). 

SELECT 289340 + 9897 AS total_rows;
















