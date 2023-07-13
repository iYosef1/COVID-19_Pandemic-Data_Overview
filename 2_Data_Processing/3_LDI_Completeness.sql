-- LOAD DATA INFILE Approach - Completeness Check:

SELECT * FROM data_load;

-- The dataset is comprised of 67 features and 299,237 records in total.

-- Confirmation of 67 Columns Created in Table:
SELECT COUNT(*) AS column_count -- Result = 67
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'owid_covid_data' AND TABLE_NAME = 'data_load';

-- Confirmation of 299,237 Records Created in Table:
SELECT COUNT(*) FROM data_load;


-- Note: The nulls in this dataset are empty strings; NULLS and empty strings may be used synonymously in the SQL comments.
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
FROM data_load;


-- iso_code, location, date, population, and excess_mortality_cumulative_per_million are the only features that have a NULL COUNT of 0.
-- The remaining features had the correct COUNT of NULLS, congruent with the wizard_import_data's COUNTS.

-- According to the excerpt query below, the COUNT of excess_mortality_cumulative_per_million_NULLS = 0
SELECT COUNT(CASE WHEN excess_mortality_cumulative_per_million = '' THEN 1 END) as excess_mortality_cumulative_per_million_NULLS
FROM data_load;
-- The LOAD DATA INFILE approach to importing the csv file's data has resulted with 0 NULLS in the excess_mortality_cumulative_per_million feature.
-- A COUNT of 0 NULLS implies the feature has no missing fields.
-- This is contrary to the number of NULLS counted with the 'Table Data Import Wizard' approach which resulted with 288,942 NULLS in the excess_mortality_cumulative_per_million feature. 
-- To understand this discrepancy, the owid-covid-data.csv file's excess_mortality_cumulative_per_million feature was reviewed. 
-- In the owid-covid-data.csv file, this feature consists of many empty fields or NULLS, and hence, the number of NULLS cannot be 0 as per the count associated with the LOAD DATA INFILE approach.
-- Each of the 67 features has a VARCHAR data type, however, excess_mortality_cumulative_per_million is the only feature that is incorrectly returning a NULL COUNT of 0.

SELECT location, _date_, excess_mortality_cumulative_per_million FROM data_load -- Query_Anomaly_A: This query does NOT exclusively return the values that are NOT NULL, i.e., it returns all values.
WHERE excess_mortality_cumulative_per_million IS NOT NULL;

SELECT location, _date_, excess_mortality_cumulative_per_million FROM data_load -- Query_Anomaly_B: This query also does NOT exclusively return the values that are NOT NULL, i.e., it returns all values.
WHERE excess_mortality_cumulative_per_million != '';

-- According to Query_Anomaly_A, Query_Anomaly_B, and the COUNT of excess_mortality_cumulative_per_million_NULLS being 0, the following can be concluded:
-- It is within reason to assume that every field in this feature is being treated as NOT NULL.


-- Success! This query exclusively returns all values that are NOT NULL.
SELECT location, _date_, excess_mortality_cumulative_per_million FROM data_load 
WHERE excess_mortality_cumulative_per_million LIKE '%.%'; -- As per the Metadata_Report, this feature consists of continuous values, i.e., each value has a decimal point.                     

SELECT COUNT(excess_mortality_cumulative_per_million) FROM data_load -- The output of this query is the number of values that are NOT NULL which is 10,295.
WHERE excess_mortality_cumulative_per_million LIKE '%.%';

SELECT 288942 + 10295 AS total_number_of_fields; -- This calculation query concurs with 10,295 being the number of values that are NOT NULL because the result is 299,237.


-- Success! The dataset was in fact successfully imported into the data_load table.
-- However, the excess_mortality_cumulative_per_million feature still behaves differently from the other features in the dataset.


