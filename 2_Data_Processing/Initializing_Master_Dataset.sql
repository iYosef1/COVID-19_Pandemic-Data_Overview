-- COVID-19 Pandemic - Master Dataset

CREATE DATABASE covid19_pandemic_db;


-- DATA IMPORT:

CREATE TABLE original_owid_covid_data (
    iso_code VARCHAR(244),
    continent VARCHAR(244),
    location VARCHAR(244),
    _date_ VARCHAR(244),
    total_cases	VARCHAR(244),
    new_cases VARCHAR(244),
    new_cases_smoothed VARCHAR(244),
    total_deaths VARCHAR(244),
    new_deaths VARCHAR(244),
    new_deaths_smoothed	VARCHAR(244),
    total_cases_per_million VARCHAR(244),
    new_cases_per_million VARCHAR(244),
    new_cases_smoothed_per_million VARCHAR(244),	
    total_deaths_per_million VARCHAR(244),
    new_deaths_per_million VARCHAR(244),	
    new_deaths_smoothed_per_million VARCHAR(244),
    reproduction_rate VARCHAR(244),
    icu_patients VARCHAR(244),
    icu_patients_per_million VARCHAR(244),
    hosp_patients VARCHAR(244),
    hosp_patients_per_million VARCHAR(244),	
    weekly_icu_admissions VARCHAR(244),	
    weekly_icu_admissions_per_million VARCHAR(244),	
    weekly_hosp_admissions VARCHAR(244),	
    weekly_hosp_admissions_per_million VARCHAR(244), 	
    total_tests	VARCHAR(244),
    new_tests VARCHAR(244),	
    total_tests_per_thousand VARCHAR(244),	
    new_tests_per_thousand VARCHAR(244),	 
    new_tests_smoothed VARCHAR(244),	
    new_tests_smoothed_per_thousand VARCHAR(244),	
    positive_rate VARCHAR(244),	
    tests_per_case VARCHAR(244),	
    tests_units	VARCHAR(244),
    total_vaccinations VARCHAR(244),	
    people_vaccinated VARCHAR(244),	
    people_fully_vaccinated VARCHAR(244),	
    total_boosters VARCHAR(244),	
    new_vaccinations VARCHAR(244),	
    new_vaccinations_smoothed VARCHAR(244),	
    total_vaccinations_per_hundred VARCHAR(244),	
    people_vaccinated_per_hundred VARCHAR(244),	
    people_fully_vaccinated_per_hundred VARCHAR(244),	
    total_boosters_per_hundred VARCHAR(244),	
    new_vaccinations_smoothed_per_million VARCHAR(244),	
    new_people_vaccinated_smoothed VARCHAR(244),	
    new_people_vaccinated_smoothed_per_hundred VARCHAR(244),	
    stringency_index VARCHAR(244),	
    population_density VARCHAR(244),	
    median_age VARCHAR(244),	
    aged_65_older VARCHAR(244),	
    aged_70_older VARCHAR(244),	
    gdp_per_capita VARCHAR(244),	
    extreme_poverty VARCHAR(244),	
    cardiovasc_death_rate VARCHAR(244),	
    diabetes_prevalence VARCHAR(244),	
    female_smokers VARCHAR(244),	
    male_smokers VARCHAR(244),	
    handwashing_facilities VARCHAR(244),	
    hospital_beds_per_thousand VARCHAR(244),	
    life_expectancy VARCHAR(244),	
    human_development_index VARCHAR(244),	
    population VARCHAR(244),	
    excess_mortality_cumulative_absolute VARCHAR(244),	
    excess_mortality_cumulative	VARCHAR(244),
    excess_mortality VARCHAR(244),	
    excess_mortality_cumulative_per_million VARCHAR(244)
    );

LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/owid-covid-data.csv' INTO TABLE original_owid_covid_data
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
IGNORE 1 LINES;

-- Confirmation of 67 Columns Created in Table:
SELECT COUNT(*) AS column_count -- Result = 67
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'covid19_pandemic_db' AND TABLE_NAME = 'original_owid_covid_data';

-- Confirmation of 299,237 Records Created in Table:
SELECT COUNT(*) AS record_count FROM original_owid_covid_data;

-- Returns the Number of Empty Strings (or NULLS) per Feature:
SELECT 
    COUNT(CASE WHEN iso_code = '' THEN 1 END) AS iso_code_NULLS,
    COUNT(CASE WHEN continent = '' THEN 1 END) AS continent_NULLS,
    COUNT(CASE WHEN location = '' THEN 1 END) AS location_NULLS,
    COUNT(CASE WHEN _date_ = '' THEN 1 END) AS _date_NULLS,
    COUNT(CASE WHEN total_cases = '' THEN 1 END) AS total_cases_NULLS,
    COUNT(CASE WHEN new_cases = '' THEN 1 END) AS new_cases_NULLS,
    COUNT(CASE WHEN new_cases_smoothed = '' THEN 1 END) AS new_cases_smoothed_NULLS,
    COUNT(CASE WHEN total_deaths = '' THEN 1 END) AS total_deaths_NULLS,
    COUNT(CASE WHEN new_deaths = '' THEN 1 END) AS new_deaths_NULLS,
    COUNT(CASE WHEN new_deaths_smoothed = '' THEN 1 END) AS new_deaths_smoothed_NULLS,
    COUNT(CASE WHEN total_cases_per_million = '' THEN 1 END) AS total_cases_per_million_NULLS,
    COUNT(CASE WHEN new_cases_per_million = '' THEN 1 END) AS new_cases_per_million_NULLS,
    COUNT(CASE WHEN new_cases_smoothed_per_million = '' THEN 1 END) AS new_cases_smoothed_per_million_NULLS,
    COUNT(CASE WHEN total_deaths_per_million = '' THEN 1 END) AS total_deaths_per_million_NULLS,
    COUNT(CASE WHEN new_deaths_per_million = '' THEN 1 END) AS new_deaths_per_million_NULLS,
    COUNT(CASE WHEN new_deaths_smoothed_per_million = '' THEN 1 END) AS new_deaths_smoothed_per_million_NULLS,
    COUNT(CASE WHEN reproduction_rate = '' THEN 1 END) AS reproduction_rate_NULLS,
    COUNT(CASE WHEN icu_patients = '' THEN 1 END) AS icu_patients_NULLS,
    COUNT(CASE WHEN icu_patients_per_million = '' THEN 1 END) AS icu_patients_per_million_NULLS,
    COUNT(CASE WHEN hosp_patients = '' THEN 1 END) AS hosp_patients_NULLS,
    COUNT(CASE WHEN hosp_patients_per_million = '' THEN 1 END) AS hosp_patients_per_million_NULLS,
    COUNT(CASE WHEN weekly_icu_admissions = '' THEN 1 END) AS weekly_icu_admissions_NULLS,
    COUNT(CASE WHEN weekly_icu_admissions_per_million = '' THEN 1 END) AS weekly_icu_admissions_per_million_NULLS,
    COUNT(CASE WHEN weekly_hosp_admissions = '' THEN 1 END) AS weekly_hosp_admissions_NULLS,
    COUNT(CASE WHEN weekly_hosp_admissions_per_million = '' THEN 1 END) AS weekly_hosp_admissions_per_million_NULLS,
    COUNT(CASE WHEN total_tests = '' THEN 1 END) AS total_tests_NULLS,
    COUNT(CASE WHEN new_tests = '' THEN 1 END) AS new_tests_NULLS,
    COUNT(CASE WHEN total_tests_per_thousand = '' THEN 1 END) AS total_tests_per_thousand_NULLS,
    COUNT(CASE WHEN new_tests_per_thousand = '' THEN 1 END) AS new_tests_per_thousand_NULLS,
    COUNT(CASE WHEN new_tests_smoothed = '' THEN 1 END) AS new_tests_smoothed_NULLS,
    COUNT(CASE WHEN new_tests_smoothed_per_thousand = '' THEN 1 END) AS new_tests_smoothed_per_thousand_NULLS,
    COUNT(CASE WHEN positive_rate = '' THEN 1 END) AS positive_rate_NULLS,
    COUNT(CASE WHEN tests_per_case = '' THEN 1 END) AS tests_per_case_NULLS,
    COUNT(CASE WHEN tests_units = '' THEN 1 END) AS tests_units_NULLS,
    COUNT(CASE WHEN total_vaccinations = '' THEN 1 END) AS total_vaccinations_NULLS,
    COUNT(CASE WHEN people_vaccinated = '' THEN 1 END) AS people_vaccinated_NULLS,
    COUNT(CASE WHEN people_fully_vaccinated = '' THEN 1 END) AS people_fully_vaccinated_NULLS,
    COUNT(CASE WHEN total_boosters = '' THEN 1 END) AS total_boosters_NULLS,
    COUNT(CASE WHEN new_vaccinations = '' THEN 1 END) AS new_vaccinations_NULLS,
    COUNT(CASE WHEN new_vaccinations_smoothed = '' THEN 1 END) AS new_vaccinations_smoothed_NULLS,
    COUNT(CASE WHEN total_vaccinations_per_hundred = '' THEN 1 END) AS total_vaccinations_per_hundred_NULLS,
    COUNT(CASE WHEN people_vaccinated_per_hundred = '' THEN 1 END) AS people_vaccinated_per_hundred_NULLS,
    COUNT(CASE WHEN people_fully_vaccinated_per_hundred = '' THEN 1 END) AS people_fully_vaccinated_per_hundred_NULLS,
    COUNT(CASE WHEN total_boosters_per_hundred = '' THEN 1 END) AS total_boosters_per_hundred_NULLS,
    COUNT(CASE WHEN new_vaccinations_smoothed_per_million = '' THEN 1 END) AS new_vaccinations_smoothed_per_million_NULLS,
    COUNT(CASE WHEN new_people_vaccinated_smoothed = '' THEN 1 END) AS new_people_vaccinated_smoothed_NULLS,
    COUNT(CASE WHEN new_people_vaccinated_smoothed_per_hundred = '' THEN 1 END) AS new_people_vaccinated_smoothed_per_hundred_NULLS,
    COUNT(CASE WHEN stringency_index = '' THEN 1 END) AS stringency_index_NULLS,
    COUNT(CASE WHEN population_density = '' THEN 1 END) AS population_density_NULLS,
    COUNT(CASE WHEN median_age = '' THEN 1 END) AS median_age_NULLS,
    COUNT(CASE WHEN aged_65_older = '' THEN 1 END) AS aged_65_older_NULLS,
    COUNT(CASE WHEN aged_70_older = '' THEN 1 END) AS aged_70_older_NULLS,
    COUNT(CASE WHEN gdp_per_capita = '' THEN 1 END) AS gdp_per_capita_NULLS,
    COUNT(CASE WHEN extreme_poverty = '' THEN 1 END) AS extreme_poverty_NULLS,
    COUNT(CASE WHEN cardiovasc_death_rate = '' THEN 1 END) AS cardiovasc_death_rate_NULLS,
    COUNT(CASE WHEN diabetes_prevalence = '' THEN 1 END) AS diabetes_prevalence_NULLS,
    COUNT(CASE WHEN female_smokers = '' THEN 1 END) AS female_smokers_NULLS,
    COUNT(CASE WHEN male_smokers = '' THEN 1 END) AS male_smokers_NULLS,
    COUNT(CASE WHEN handwashing_facilities = '' THEN 1 END) AS handwashing_facilities_NULLS,
    COUNT(CASE WHEN hospital_beds_per_thousand = '' THEN 1 END) AS hospital_beds_per_thousand_NULLS,
    COUNT(CASE WHEN life_expectancy = '' THEN 1 END) AS life_expectancy_NULLS,
    COUNT(CASE WHEN human_development_index = '' THEN 1 END) AS human_development_index_NULLS,
    COUNT(CASE WHEN population = '' THEN 1 END) AS population_NULLS,
    COUNT(CASE WHEN excess_mortality_cumulative_absolute = '' THEN 1 END) AS excess_mortality_cumulative_absolute_NULLS,
    COUNT(CASE WHEN excess_mortality_cumulative = '' THEN 1 END) AS excess_mortality_cumulative_NULLS,
    COUNT(CASE WHEN excess_mortality = '' THEN 1 END) AS excess_mortality_NULLS,
    COUNT(CASE WHEN excess_mortality_cumulative_per_million = '' THEN 1 END) AS excess_mortality_cumulative_per_million_NULLS
FROM original_owid_covid_data;

-- The previous query did not return the correct number of NULLS in the excess_mortality_cumulative_per_million feature. 
-- The following query returns the number of NULLS in the excess_mortality_cumulative_per_million feature.
SELECT COUNT(excess_mortality_cumulative_per_million) FROM original_owid_covid_data 
WHERE excess_mortality_cumulative_per_million NOT LIKE '%.%'; -- There are 288,942 NULLS in this feature.

-- The correct number of NULLS (288,942) has been substituted in place of the last value in the calculation below:
SELECT 0 + 14234 + 0 + 0 + 35883 + 8633 + 9897 + 56008 + 8551 + 9781 + 35883 + 8633 + 9897 + 56008 + 8551 + 9781 + 114420 + 264641 + 
       264641 + 264294 + 264294 + 290215 + 290215 + 278071 + 278071 + 219850 + 223834 + 219850 + 223834 + 195272 + 195272 + 203310 + 
       204889 + 192449 + 226096 + 229211 + 231491 + 257285 + 239042 + 137082 + 226096 + 229211 + 231491 + 257285 + 137082 + 137032 + 
       137032 + 106043 + 45346 + 63093 + 71350 + 65462 + 67812 + 150181 + 67408 + 55584 + 125314 + 127684 + 185723 + 94581 + 24087 + 
       74506 + 0 + 288942 + 288942 + 288942 + 288942
AS total_NULLS;

-- According to the Metadata Report as well, the total number of empty fields (or NULLS) is 9,614,540.
-- The data was imported successfully! 



-- DATA CLEANING:

-- DROP TABLE IF EXISTS in_process_dataset;
CREATE TABLE in_process_dataset AS
SELECT * FROM original_owid_covid_data;


-- Below are the necessary UPDATE commands for the features that require it.
-- The following UPDATE commands will allow for the successful ALTER commands of each feature's data conversion:

-- NOTE: The categorical features, plus the population feature, do NOT require an UPDATE command at their empty-string or NULL fields.

-- Numerical Discrete Features: 
UPDATE in_process_dataset SET total_cases = NULL
WHERE total_cases = ''; 

UPDATE in_process_dataset SET new_cases = NULL
WHERE new_cases = ''; 

UPDATE in_process_dataset SET total_tests = NULL
WHERE total_tests = ''; 

UPDATE in_process_dataset SET new_tests = NULL
WHERE new_tests = ''; 

UPDATE in_process_dataset SET new_tests_smoothed = NULL
WHERE new_tests_smoothed = ''; 

UPDATE in_process_dataset SET total_deaths = NULL
WHERE total_deaths = ''; 

UPDATE in_process_dataset SET new_deaths = NULL
WHERE new_deaths = ''; 

UPDATE in_process_dataset SET icu_patients = NULL
WHERE icu_patients = ''; 

UPDATE in_process_dataset SET hosp_patients = NULL
WHERE hosp_patients = ''; 

UPDATE in_process_dataset SET weekly_icu_admissions = NULL
WHERE weekly_icu_admissions = ''; 

UPDATE in_process_dataset SET weekly_hosp_admissions = NULL
WHERE weekly_hosp_admissions = ''; 

UPDATE in_process_dataset SET total_vaccinations = NULL
WHERE total_vaccinations = ''; 

UPDATE in_process_dataset SET people_vaccinated = NULL
WHERE people_vaccinated = ''; 

UPDATE in_process_dataset SET people_fully_vaccinated = NULL
WHERE people_fully_vaccinated = ''; 

UPDATE in_process_dataset SET total_boosters = NULL
WHERE total_boosters = ''; 

UPDATE in_process_dataset SET new_vaccinations = NULL
WHERE new_vaccinations = ''; 

UPDATE in_process_dataset SET new_vaccinations_smoothed = NULL
WHERE new_vaccinations_smoothed = ''; 

UPDATE in_process_dataset SET new_vaccinations_smoothed_per_million = NULL
WHERE new_vaccinations_smoothed_per_million = ''; 

UPDATE in_process_dataset SET new_people_vaccinated_smoothed = NULL
WHERE new_people_vaccinated_smoothed = ''; 


-- Numerical Continuous Features:
UPDATE in_process_dataset SET new_cases_smoothed = NULL
WHERE new_cases_smoothed = ''; 

UPDATE in_process_dataset SET new_deaths_smoothed = NULL
WHERE new_deaths_smoothed = ''; 

UPDATE in_process_dataset SET total_cases_per_million = NULL
WHERE total_cases_per_million = ''; 

UPDATE in_process_dataset SET new_cases_per_million = NULL
WHERE new_cases_per_million = ''; 

UPDATE in_process_dataset SET new_cases_smoothed_per_million = NULL
WHERE new_cases_smoothed_per_million = ''; 

UPDATE in_process_dataset SET total_deaths_per_million = NULL
WHERE total_deaths_per_million = ''; 

UPDATE in_process_dataset SET new_deaths_per_million = NULL
WHERE new_deaths_per_million = ''; 

UPDATE in_process_dataset SET new_deaths_smoothed_per_million = NULL
WHERE new_deaths_smoothed_per_million = ''; 

UPDATE in_process_dataset SET reproduction_rate = NULL
WHERE reproduction_rate = ''; 

UPDATE in_process_dataset SET icu_patients_per_million = NULL
WHERE icu_patients_per_million = ''; 

UPDATE in_process_dataset SET hosp_patients_per_million = NULL
WHERE hosp_patients_per_million = ''; 

UPDATE in_process_dataset SET weekly_icu_admissions_per_million = NULL
WHERE weekly_icu_admissions_per_million = ''; 

UPDATE in_process_dataset SET weekly_hosp_admissions_per_million = NULL
WHERE weekly_hosp_admissions_per_million = ''; 

UPDATE in_process_dataset SET total_tests_per_thousand = NULL
WHERE total_tests_per_thousand = ''; 

UPDATE in_process_dataset SET new_tests_per_thousand = NULL
WHERE new_tests_per_thousand = ''; 

UPDATE in_process_dataset SET new_tests_smoothed_per_thousand = NULL
WHERE new_tests_smoothed_per_thousand = ''; 

UPDATE in_process_dataset SET positive_rate = NULL
WHERE positive_rate = ''; 

UPDATE in_process_dataset SET tests_per_case = NULL
WHERE tests_per_case = ''; 

UPDATE in_process_dataset SET total_vaccinations_per_hundred = NULL
WHERE total_vaccinations_per_hundred = ''; 

UPDATE in_process_dataset SET people_vaccinated_per_hundred = NULL
WHERE people_vaccinated_per_hundred = ''; 

UPDATE in_process_dataset SET people_fully_vaccinated_per_hundred = NULL
WHERE people_fully_vaccinated_per_hundred = ''; 

UPDATE in_process_dataset SET total_boosters_per_hundred = NULL
WHERE total_boosters_per_hundred = ''; 

UPDATE in_process_dataset SET new_people_vaccinated_smoothed_per_hundred = NULL
WHERE new_people_vaccinated_smoothed_per_hundred = ''; 

UPDATE in_process_dataset SET stringency_index = NULL
WHERE stringency_index = ''; 

UPDATE in_process_dataset SET population_density = NULL
WHERE population_density = ''; 

UPDATE in_process_dataset SET median_age = NULL
WHERE median_age = ''; 

UPDATE in_process_dataset SET aged_65_older = NULL
WHERE aged_65_older = ''; 

UPDATE in_process_dataset SET aged_70_older = NULL
WHERE aged_70_older = ''; 

UPDATE in_process_dataset SET gdp_per_capita = NULL
WHERE gdp_per_capita = ''; 

UPDATE in_process_dataset SET extreme_poverty = NULL
WHERE extreme_poverty = ''; 

UPDATE in_process_dataset SET cardiovasc_death_rate = NULL
WHERE cardiovasc_death_rate = ''; 

UPDATE in_process_dataset SET diabetes_prevalence = NULL
WHERE diabetes_prevalence = ''; 

UPDATE in_process_dataset SET female_smokers = NULL
WHERE female_smokers = ''; 

UPDATE in_process_dataset SET male_smokers = NULL
WHERE male_smokers = ''; 

UPDATE in_process_dataset SET handwashing_facilities = NULL
WHERE handwashing_facilities = ''; 

UPDATE in_process_dataset SET hospital_beds_per_thousand = NULL
WHERE hospital_beds_per_thousand = ''; 

UPDATE in_process_dataset SET life_expectancy = NULL
WHERE life_expectancy = ''; 

UPDATE in_process_dataset SET human_development_index = NULL
WHERE human_development_index = ''; 

UPDATE in_process_dataset SET excess_mortality_cumulative_absolute = NULL
WHERE excess_mortality_cumulative_absolute = ''; 

UPDATE in_process_dataset SET excess_mortality_cumulative = NULL
WHERE excess_mortality_cumulative = ''; 

UPDATE in_process_dataset SET excess_mortality = NULL
WHERE excess_mortality = ''; 

-- excess_mortality_cumulative_per_million is a unique case:
UPDATE in_process_dataset SET excess_mortality_cumulative_per_million = NULL
WHERE excess_mortality_cumulative_per_million = 0;

-- The features have been updated as needed for the ALTER commands to be run without error.



-- DATA-TYPE CONVERSION:

-- NOTE: The data-type arguments below were queried and confirmed in the 6_Feature_Field_Lengths.sql file and 7_Data_Integrity_Check.sql file, respectively. 

-- Categorical Features - Data-type Alteration:
ALTER TABLE in_process_dataset MODIFY iso_code VARCHAR(10);

ALTER TABLE in_process_dataset MODIFY continent VARCHAR(20);

ALTER TABLE in_process_dataset MODIFY location VARCHAR(40);

ALTER TABLE in_process_dataset MODIFY tests_units VARCHAR(20);


-- Temporal Feature - Data-type Alteration:
ALTER TABLE in_process_dataset MODIFY _date_ DATE;


-- Numerically Discrete Features - Data-type Alteration:
ALTER TABLE in_process_dataset MODIFY population BIGINT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY total_cases INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_cases INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY total_tests BIGINT UNSIGNED;

ALTER TABLE in_process_dataset MODIFY new_tests INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_tests_smoothed INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY total_deaths INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_deaths INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY icu_patients INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY hosp_patients INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY weekly_icu_admissions INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY weekly_hosp_admissions INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY total_vaccinations BIGINT UNSIGNED;

ALTER TABLE in_process_dataset MODIFY people_vaccinated BIGINT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY people_fully_vaccinated BIGINT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY total_boosters INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_vaccinations INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_vaccinations_smoothed INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_vaccinations_smoothed_per_million INT UNSIGNED; 

ALTER TABLE in_process_dataset MODIFY new_people_vaccinated_smoothed INT UNSIGNED; 


-- Numerically Continuous Feature - Data-type Alteration:
ALTER TABLE in_process_dataset MODIFY new_cases_smoothed DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY new_deaths_smoothed DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY total_cases_per_million DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY new_cases_per_million DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY new_cases_smoothed_per_million DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY total_deaths_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY new_deaths_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY new_deaths_smoothed_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY reproduction_rate DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY icu_patients_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY hosp_patients_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY weekly_icu_admissions_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY weekly_hosp_admissions_per_million DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY total_tests_per_thousand DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY new_tests_per_thousand DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY new_tests_smoothed_per_thousand DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY positive_rate DECIMAL(10, 4);

ALTER TABLE in_process_dataset MODIFY tests_per_case DECIMAL(10, 1);

ALTER TABLE in_process_dataset MODIFY total_vaccinations_per_hundred DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY people_vaccinated_per_hundred DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY people_fully_vaccinated_per_hundred DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY total_boosters_per_hundred DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY new_people_vaccinated_smoothed_per_hundred DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY stringency_index DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY population_density DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY median_age DECIMAL(10, 1);

ALTER TABLE in_process_dataset MODIFY aged_65_older DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY aged_70_older DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY gdp_per_capita DECIMAL(20, 3);

ALTER TABLE in_process_dataset MODIFY extreme_poverty DECIMAL(10, 1);

ALTER TABLE in_process_dataset MODIFY cardiovasc_death_rate DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY diabetes_prevalence DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY female_smokers DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY male_smokers DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY handwashing_facilities DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY hospital_beds_per_thousand DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY life_expectancy DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY human_development_index DECIMAL(10, 3);

ALTER TABLE in_process_dataset MODIFY excess_mortality_cumulative_absolute DECIMAL(20, 8);

ALTER TABLE in_process_dataset MODIFY excess_mortality_cumulative DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY excess_mortality DECIMAL(10, 2);

ALTER TABLE in_process_dataset MODIFY excess_mortality_cumulative_per_million DECIMAL(20, 8);


DESCRIBE in_process_dataset; -- Run this command to confirm all features now have the correct data-type.

-- IMPORTANT!!! Do NOT delete the in_process_dataset table. If any further data-processing is required, it will stem from the currently processed in_process_dataset table. 
-- This iteration of data-processing is followed by the DROP command below in order to reiterate the CREATE command for the master dataset:
-- DROP TABLE IF EXISTS owid_covid_master_dataset;



/* Master Dataset:

   The features were grouped as they were in the Metadata Report, then reordered within their respective groups by relationship 
   and/or relevance to one another for ease of following across all 67 features of the dataset.

*/

-- The following command needs to be executed only once:
CREATE TABLE owid_covid_master_dataset AS
SELECT continent, iso_code, location, _date_, -- 4 features

       population, population_density, gdp_per_capita, life_expectancy, human_development_index, -- 15 features
       extreme_poverty, median_age, aged_65_older, aged_70_older, diabetes_prevalence, 
       female_smokers, male_smokers, cardiovasc_death_rate, handwashing_facilities, 
       hospital_beds_per_thousand, 
       

       new_tests, new_tests_smoothed, new_tests_per_thousand, new_tests_smoothed_per_thousand, -- 9 features
       tests_units, 
       total_tests, total_tests_per_thousand, 
       positive_rate, tests_per_case, 
       
       new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million,  -- 6 features
       total_cases, total_cases_per_million, 
       
       hosp_patients, hosp_patients_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million, -- 8 features
       icu_patients, icu_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million, 
       
       new_deaths, new_deaths_smoothed, new_deaths_per_million, new_deaths_smoothed_per_million,  -- 6 features
       total_deaths, total_deaths_per_million, 
       
       new_vaccinations, new_vaccinations_smoothed, new_vaccinations_smoothed_per_million, -- 13 features
       people_vaccinated, people_vaccinated_per_hundred, 
       people_fully_vaccinated, people_fully_vaccinated_per_hundred, 
       total_boosters, total_boosters_per_hundred, 
       total_vaccinations, total_vaccinations_per_hundred, 
       new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred,
       
       excess_mortality, excess_mortality_cumulative, -- 4 features
       excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million, 
       
       reproduction_rate, -- 2 features
       stringency_index
       
FROM in_process_dataset;



/* RENAMED Feature Title:

As per the Metadata Report, the excess_mortality_cumulative_per_million being a calculable feature from the excess_mortality_cumulative_absolute, 
it was renamed to excess_mortality_cumulative_absolute_per_million with following ALTER command:

*/
ALTER TABLE owid_covid_master_dataset RENAME COLUMN excess_mortality_cumulative_per_million TO excess_mortality_cumulative_absolute_per_million;


-- Master Dataset Preview:
SELECT * FROM owid_covid_master_dataset
LIMIT 10;

-- IMPORTANT! The master dataset will be the primary reference and starting point moving forward for EDA and database modelling.

