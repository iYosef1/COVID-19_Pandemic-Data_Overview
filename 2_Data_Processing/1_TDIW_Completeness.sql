-- Table Data Import Wizard Approach - Completeness Check:

SELECT * FROM wizard_import_data;

-- The dataset is comprised of 67 features and 299,237 records in total.

-- Confirmation of 67 Columns Created in Table:
SELECT COUNT(*) AS column_count -- Result = 67
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'owid_covid_data' AND TABLE_NAME = 'wizard_import_data';

-- Confirmation of 299,237 Records Created in Table:
SELECT COUNT(*) FROM wizard_import_data;


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
FROM wizard_import_data;


-- The following calculation is completed using the record of numbers copied from the previous query:

SELECT 0 + 14234 + 0 + 0 + 35883 + 8633 + 9897 + 56008 + 8551 + 9781 + 35883 + 8633 + 9897 + 56008 + 8551 + 9781 + 114420 + 264641 + 264641 + 264294 + 264294 + 290215 + 290215 + 278071 + 278071 + 219850 + 223834 + 219850 + 223834 + 195272 + 195272 + 203310 + 204889 + 192449 + 226096 + 229211 + 231491 + 257285 + 239042 + 137082 + 226096 + 229211 + 231491 + 257285 + 137082 + 137032 + 137032 + 106043 + 45346 + 63093 + 71350 + 65462 + 67812 + 150181 + 67408 + 55584 + 125314 + 127684 + 185723 + 94581 + 24087 + 74506 + 0 + 288942 + 288942 + 288942 + 288942
AS total; -- This calculation returned 9614540.

-- As per the Metadata_Report, the total number of empty fields is 9,614,540.
-- Success! The dataset was successfully imported into the wizard_import_data table.

