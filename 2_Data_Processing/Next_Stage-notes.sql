SELECT DISTINCT(CONCAT(iso_code, '; ', LENGTH(iso_code))) AS max_len_iso_code FROM master_dataset
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases, '.', -1)), ')')) AS max_len_new_cases FROM master_dataset
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM master_dataset);


SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) AS max_len_new_cases_smoothed FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);




-- RESULTS:
-- The following are the appropriate data-types for all 67 features, inclusive of the only temporal feature, date, renamed as _date_:

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