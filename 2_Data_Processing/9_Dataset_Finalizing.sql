-- Final Steps for New Table - Confirming Successful Data-type Alterations:

-- Categorical Features - Data-type Alteration:
ALTER TABLE testing_table MODIFY iso_code VARCHAR(10);

ALTER TABLE testing_table MODIFY continent VARCHAR(20);

ALTER TABLE testing_table MODIFY location VARCHAR(40);

ALTER TABLE testing_table MODIFY tests_units VARCHAR(20);


-- Temporal Feature - Data-type Alteration:
ALTER TABLE testing_table MODIFY _date_ DATE;


-- Numerically Discrete Features - Data-type Alteration:
ALTER TABLE testing_table MODIFY population BIGINT UNSIGNED; -- population is a unique case

ALTER TABLE testing_table MODIFY total_cases INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_cases INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_tests INT UNSIGNED; -- ERROR! Error Code: 1264. Out of range value for column 'total_tests' at row 52877

ALTER TABLE testing_table MODIFY new_tests INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_tests_smoothed INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_deaths INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_deaths INT UNSIGNED; 

ALTER TABLE testing_table MODIFY icu_patients INT UNSIGNED; 

ALTER TABLE testing_table MODIFY hosp_patients INT UNSIGNED; 

ALTER TABLE testing_table MODIFY weekly_icu_admissions INT UNSIGNED; 

ALTER TABLE testing_table MODIFY weekly_hosp_admissions INT UNSIGNED; 

ALTER TABLE testing_table MODIFY total_vaccinations INT UNSIGNED; -- ERROR! Error Code: 1264. Out of range value for column 'total_vaccinations' at row 14836

ALTER TABLE testing_table MODIFY people_vaccinated INT UNSIGNED; -- ERROR! Error Code: 1264. Out of range value for column 'people_vaccinated' at row 295204

ALTER TABLE testing_table MODIFY people_fully_vaccinated INT UNSIGNED; -- ERROR! Error Code: 1264. Out of range value for column 'people_fully_vaccinated' at row 295282

ALTER TABLE testing_table MODIFY total_boosters INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_vaccinations INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_vaccinations_smoothed INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_vaccinations_smoothed_per_million INT UNSIGNED; 

ALTER TABLE testing_table MODIFY new_people_vaccinated_smoothed INT UNSIGNED; 


-- Numerically Continuous Feature - Data-type Alteration:
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



-- Errors Resolved: Identical to the fix for the population feature, the additional errors indicated above were resolved by changing the data-type from INT UNSIGNED to BIGINT UNSIGNED.

ALTER TABLE testing_table MODIFY total_tests BIGINT UNSIGNED; -- Resolved! Error Code: 1264. Out of range value for column 'total_tests' at row 52877

ALTER TABLE testing_table MODIFY total_vaccinations BIGINT UNSIGNED; -- Resolved! Error Code: 1264. Out of range value for column 'total_vaccinations' at row 14836

ALTER TABLE testing_table MODIFY people_vaccinated BIGINT UNSIGNED; -- Resolved! Error Code: 1264. Out of range value for column 'people_vaccinated' at row 295204

ALTER TABLE testing_table MODIFY people_fully_vaccinated BIGINT UNSIGNED; -- Resolved! Error Code: 1264. Out of range value for column 'people_fully_vaccinated' at row 295282


DESCRIBE testing_table; -- This command confirms that all features now have the correct data-type.

-- The following command needs to be executed only once:
-- CREATE TABLE final_table AS
-- SELECT * FROM testing_table;



-- Final Steps:
-- 5. a) With the CREATE clause create a new database called "covid19_pandemic_db". 
--    b) Use the LOAD INFILE method to import the original csv data file into this newly created database, and name this table "original_owid_covid_dataset".
--    c) Utilize the queries and commands in the preceding sql files as a template to prep and finalize the original_owid_covid_dataset table. 
--    d) With the CREATE clause rearrange the features of the finalized dataset and name this new table "owid_covid_master_dataset". 





/* IMPORTANT!

In the Data_Integrity_Check.sql file, type-casting with the INT data-type did NOT cause any errors, however, errors did occur
when the ALTER command was used on features such as total_tests, total_vaccinations, people_vaccinated, and people_fully_vaccinated.

The indexed queries below confirm that each of the preceding errors were only a mishap due to a lacking of knowledge that 
type-casted features do not take up as much space as the actual data-conversions, and hence, the aforementioned error-associated
features simply required the BIGINT data-type to bypass error code 1264.

*/

-- Error Code: 1264. Out of range value for column 'total_tests' at row 52877
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, total_tests FROM final_table
WHERE (@index := @index + 1) = 52877;

SET @index = 0;
SELECT (@index := @index + 1) AS index_column, CAST(total_tests AS UNSIGNED INT) AS casted_total_tests FROM data_load
WHERE (@index := @index + 1) = 52877;


-- Error Code: 1264. Out of range value for column 'total_vaccinations' at row 14836
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, total_vaccinations FROM final_table
WHERE (@index := @index + 1) = 14836;

SET @index = 0;
SELECT (@index := @index + 1) AS index_column, CAST(total_vaccinations AS UNSIGNED INT) AS casted_total_vaccinations FROM data_load
WHERE (@index := @index + 1) = 14836;


-- Error Code: 1264. Out of range value for column 'people_vaccinated' at row 295204
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, people_vaccinated FROM final_table
WHERE (@index := @index + 1) = 295204;

SET @index = 0;
SELECT (@index := @index + 1) AS index_column, CAST(people_vaccinated AS UNSIGNED INT) AS casted_people_vaccinated FROM data_load
WHERE (@index := @index + 1) = 295204;


-- Error Code: 1264. Out of range value for column 'people_fully_vaccinated' at row 295282
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, people_fully_vaccinated FROM final_table
WHERE (@index := @index + 1) = 295282;

SET @index = 0;
SELECT (@index := @index + 1) AS index_column, CAST(people_fully_vaccinated AS UNSIGNED INT) AS casted_people_fully_vaccinated FROM data_load
WHERE (@index := @index + 1) = 295282;
-- At the indicated row number at which the first error occurred, both the type-casted and converted feature have the same output.
