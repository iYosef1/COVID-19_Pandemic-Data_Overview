-- Maintainence of Data Integrity Post-conversion:

-- The data-types being used within this dataset are: INT for whole numbers, DECIMAL for decimal numbers, DATE for dates, and VARCHAR for strings. 
-- Certain key arguments passed in for data-type conversion have been rounded by ceiling the values.
-- The DECIMAL data-type does not require the UNSIGNED or SIGNED keyword, however, the INT data-type does require one of the 2 keywords depending on the values of the feature. 
-- If an INT data-type is not assigned either UNSIGNED or SIGNED, then its default setting will be SIGNED, i.e., it will allow for postive and negative values to exist within the feature.

/* The queries of 6_Feature_Field_Lengths.sql have been used to ascertain the arguments for VARCHAR and DECIMAL data-types.

VARCHAR:

iso_code VARCHAR(10)
continent VARCHAR(20)
location VARCHAR(40)
tests_units VARCHAR(20)


DECIMAL:

new_cases_smoothed DECIMAL(20, 3)
new_deaths_smoothed DECIMAL(20, 3)
total_cases_per_million DECIMAL(20, 3)
new_cases_per_million DECIMAL(20, 3)
new_cases_smoothed_per_million DECIMAL(20, 3)
total_deaths_per_million DECIMAL(10, 3)
new_deaths_per_million DECIMAL(10, 3)
new_deaths_smoothed_per_million DECIMAL(10, 3)
reproduction_rate DECIMAL(10, 2)
icu_patients_per_million DECIMAL(10, 3)
hosp_patients_per_million DECIMAL(10, 3)
weekly_icu_admissions_per_million DECIMAL(10, 3)
weekly_hosp_admissions_per_million DECIMAL(10, 3)
total_tests_per_thousand DECIMAL(20, 3)
new_tests_per_thousand DECIMAL(10, 3)
new_tests_smoothed_per_thousand DECIMAL(10, 3)
positive_rate DECIMAL(10, 4)
tests_per_case DECIMAL(10, 1)
total_vaccinations_per_hundred DECIMAL(10, 2)
people_vaccinated_per_hundred DECIMAL(10, 2)
people_fully_vaccinated_per_hundred DECIMAL(10, 2)
total_boosters_per_hundred DECIMAL(10, 2)
new_people_vaccinated_smoothed_per_hundred DECIMAL(10, 3)
stringency_index DECIMAL(10, 2)
population_density DECIMAL(20, 3) 
median_age DECIMAL(10, 1)
aged_65_older DECIMAL(10, 3)
aged_70_older DECIMAL(10, 3)
gdp_per_capita DECIMAL(20, 3)
extreme_poverty DECIMAL(10, 1)
cardiovasc_death_rate DECIMAL(10, 3)
diabetes_prevalence DECIMAL(10, 2)
female_smokers DECIMAL(10, 3)
male_smokers DECIMAL(10, 3)
handwashing_facilities DECIMAL(10, 3) 
hospital_beds_per_thousand DECIMAL(10, 3)
life_expectancy DECIMAL(10, 2) 
human_development_index DECIMAL(10, 3)
excess_mortality_cumulative_absolute DECIMAL(20, 8) 
excess_mortality_cumulative DECIMAL(10, 2)
excess_mortality DECIMAL(10, 2)
excess_mortality_cumulative_per_million DECIMAL(20, 8)

Notes:
The DECIMAL data-type's precision argument was determined by summing the MAX total number of digits of a particular feature with the MAX number of decimal digits of the same feature.
The DECIMAL data-type's scale argument was simply the MAX number of decimal digits of the same feature. 

*/



-- The following queries will confirm whether or not data integrity will be maintained when type-casting the 67 features:

-- Categorical Features:
-- Important! The existing VARCHAR(100) data-type of categorical features cannot be typecasted into another VARCHAR data-type regardless of the argument size passed into it.
SELECT iso_code, CAST(iso_code AS CHAR(10)) AS casted_iso_code,
CASE WHEN iso_code = CAST(iso_code AS CHAR(10)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC; 

SELECT continent, CAST(continent AS CHAR(20)) AS casted_continent,
CASE WHEN continent = CAST(continent AS CHAR(20)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC; 

SELECT location, CAST(location AS CHAR(40)) AS casted_location,
CASE WHEN location = CAST(location AS CHAR(40)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC; 

SELECT tests_units, CAST(tests_units AS CHAR(20)) AS casted_tests_units,
CASE WHEN tests_units = CAST(tests_units AS CHAR(20)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC; 
-- All categorical features have been correctly typecasted as there are no False values listed at the top of any of the T_or_F columns.


-- Temporal Feature:
SELECT _date_, CAST(_date_ AS DATE) AS casted_date,
CASE WHEN _date_ = CAST(_date_ AS DATE) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC; 


-- Numerically Discrete Features:
-- The INT data-type does not accept an argument in this version of MySQL.
SELECT population, CAST(population AS UNSIGNED INT) AS casted_population,
CASE WHEN population = CAST(population AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_cases, CAST(total_cases AS UNSIGNED INT) AS casted_total_cases,
CASE WHEN total_cases = CAST(total_cases AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_cases, CAST(new_cases AS UNSIGNED INT) AS casted_new_cases,
CASE WHEN new_cases = CAST(new_cases AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_tests, CAST(total_tests AS UNSIGNED INT) AS casted_total_tests,
CASE WHEN total_tests = CAST(total_tests AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_tests, CAST(new_tests AS UNSIGNED INT) AS casted_new_tests,
CASE WHEN new_tests = CAST(new_tests AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_tests_smoothed, CAST(new_tests_smoothed AS UNSIGNED INT) AS casted_new_tests_smoothed,
CASE WHEN new_tests_smoothed = CAST(new_tests_smoothed AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_deaths, CAST(total_deaths AS UNSIGNED INT) AS casted_total_deaths,
CASE WHEN total_deaths = CAST(total_deaths AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_deaths, CAST(new_deaths AS UNSIGNED INT) AS casted_new_deaths,
CASE WHEN new_deaths = CAST(new_deaths AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT icu_patients, CAST(icu_patients AS UNSIGNED INT) AS casted_icu_patients,
CASE WHEN icu_patients = CAST(icu_patients AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT hosp_patients, CAST(hosp_patients AS UNSIGNED INT) AS casted_hosp_patients,
CASE WHEN hosp_patients = CAST(hosp_patients AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT weekly_icu_admissions, CAST(weekly_icu_admissions AS UNSIGNED INT) AS casted_weekly_icu_admissions,
CASE WHEN weekly_icu_admissions = CAST(weekly_icu_admissions AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT weekly_hosp_admissions, CAST(weekly_hosp_admissions AS UNSIGNED INT) AS casted_weekly_hosp_admissions,
CASE WHEN weekly_hosp_admissions = CAST(weekly_hosp_admissions AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_vaccinations, CAST(total_vaccinations AS UNSIGNED INT) AS casted_total_vaccinations,
CASE WHEN total_vaccinations = CAST(total_vaccinations AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT people_vaccinated, CAST(people_vaccinated AS UNSIGNED INT) AS casted_people_vaccinated,
CASE WHEN people_vaccinated = CAST(people_vaccinated AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT people_fully_vaccinated, CAST(people_fully_vaccinated AS UNSIGNED INT) AS casted_people_fully_vaccinated,
CASE WHEN people_fully_vaccinated = CAST(people_fully_vaccinated AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_boosters, CAST(total_boosters AS UNSIGNED INT) AS casted_total_boosters,
CASE WHEN total_boosters = CAST(total_boosters AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_vaccinations, CAST(new_vaccinations AS UNSIGNED INT) AS casted_new_vaccinations,
CASE WHEN new_vaccinations = CAST(new_vaccinations AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_vaccinations_smoothed, CAST(new_vaccinations_smoothed AS UNSIGNED INT) AS casted_new_vaccinations_smoothed,
CASE WHEN new_vaccinations_smoothed = CAST(new_vaccinations_smoothed AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_vaccinations_smoothed_per_million, CAST(new_vaccinations_smoothed_per_million AS UNSIGNED INT) AS casted_new_vaccinations_smoothed_per_million,
CASE WHEN new_vaccinations_smoothed_per_million = CAST(new_vaccinations_smoothed_per_million AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_people_vaccinated_smoothed, CAST(new_people_vaccinated_smoothed AS UNSIGNED INT) AS casted_new_people_vaccinated_smoothed,
CASE WHEN new_people_vaccinated_smoothed = CAST(new_people_vaccinated_smoothed AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;
-- All numerically discrete features have been correctly typecasted as there are no False values listed at the top of any of the T_or_F columns.
-- The INT data-type suffices for all of the numerically discrete features of this dataset.
-- The lack of False values with the use of the UNSIGNED keyword implies all of the numerically discrete features have positive values only. 


-- Numerically Continuous Features:
SELECT new_cases_smoothed, CAST(new_cases_smoothed AS DECIMAL(20, 3)) AS casted_new_cases_smoothed,
CASE WHEN new_cases_smoothed = CAST(new_cases_smoothed AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_deaths_smoothed, CAST(new_deaths_smoothed AS DECIMAL(20, 3)) AS casted_new_deaths_smoothed,
CASE WHEN new_deaths_smoothed = CAST(new_deaths_smoothed AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_cases_per_million, CAST(total_cases_per_million AS DECIMAL(20, 3)) AS casted_total_cases_per_million,
CASE WHEN total_cases_per_million = CAST(total_cases_per_million AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_cases_per_million, CAST(new_cases_per_million AS DECIMAL(20, 3)) AS casted_new_cases_per_million,
CASE WHEN new_cases_per_million = CAST(new_cases_per_million AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_cases_smoothed_per_million, CAST(new_cases_smoothed_per_million AS DECIMAL(20, 3)) AS casted_new_cases_smoothed_per_million,
CASE WHEN new_cases_smoothed_per_million = CAST(new_cases_smoothed_per_million AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_deaths_per_million, CAST(total_deaths_per_million AS DECIMAL(10, 3)) AS casted_total_deaths_per_million,
CASE WHEN total_deaths_per_million = CAST(total_deaths_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_deaths_per_million, CAST(new_deaths_per_million AS DECIMAL(10, 3)) AS casted_new_deaths_per_million,
CASE WHEN new_deaths_per_million = CAST(new_deaths_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_deaths_smoothed_per_million, CAST(new_deaths_smoothed_per_million AS DECIMAL(10, 3)) AS casted_new_deaths_smoothed_per_million,
CASE WHEN new_deaths_smoothed_per_million = CAST(new_deaths_smoothed_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT reproduction_rate, CAST(reproduction_rate AS DECIMAL(10, 2)) AS casted_reproduction_rate,
CASE WHEN reproduction_rate = CAST(reproduction_rate AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT icu_patients_per_million, CAST(icu_patients_per_million AS DECIMAL(10, 3)) AS casted_icu_patients_per_million,
CASE WHEN icu_patients_per_million = CAST(icu_patients_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT hosp_patients_per_million, CAST(hosp_patients_per_million AS DECIMAL(10, 3)) AS casted_hosp_patients_per_million,
CASE WHEN hosp_patients_per_million = CAST(hosp_patients_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT weekly_icu_admissions_per_million, CAST(weekly_icu_admissions_per_million AS DECIMAL(10, 3)) AS casted_weekly_icu_admissions_per_million,
CASE WHEN weekly_icu_admissions_per_million = CAST(weekly_icu_admissions_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT weekly_hosp_admissions_per_million, CAST(weekly_hosp_admissions_per_million AS DECIMAL(10, 3)) AS casted_weekly_hosp_admissions_per_million,
CASE WHEN weekly_hosp_admissions_per_million = CAST(weekly_hosp_admissions_per_million AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_tests_per_thousand, CAST(total_tests_per_thousand AS DECIMAL(20, 3)) AS casted_total_tests_per_thousand,
CASE WHEN total_tests_per_thousand = CAST(total_tests_per_thousand AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_tests_per_thousand, CAST(new_tests_per_thousand AS DECIMAL(10, 3)) AS casted_new_tests_per_thousand,
CASE WHEN new_tests_per_thousand = CAST(new_tests_per_thousand AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_tests_smoothed_per_thousand, CAST(new_tests_smoothed_per_thousand AS DECIMAL(10, 3)) AS casted_new_tests_smoothed_per_thousand,
CASE WHEN new_tests_smoothed_per_thousand = CAST(new_tests_smoothed_per_thousand AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT positive_rate, CAST(positive_rate AS DECIMAL(10, 4)) AS casted_positive_rate,
CASE WHEN positive_rate = CAST(positive_rate AS DECIMAL(10, 4)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT tests_per_case, CAST(tests_per_case AS DECIMAL(10, 1)) AS casted_tests_per_case,
CASE WHEN tests_per_case = CAST(tests_per_case AS DECIMAL(10, 1)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_vaccinations_per_hundred, CAST(total_vaccinations_per_hundred AS DECIMAL(10, 2)) AS casted_total_vaccinations_per_hundred,
CASE WHEN total_vaccinations_per_hundred = CAST(total_vaccinations_per_hundred AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT people_vaccinated_per_hundred, CAST(people_vaccinated_per_hundred AS DECIMAL(10, 2)) AS casted_people_vaccinated_per_hundred,
CASE WHEN people_vaccinated_per_hundred = CAST(people_vaccinated_per_hundred AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT people_fully_vaccinated_per_hundred, CAST(people_fully_vaccinated_per_hundred AS DECIMAL(10, 2)) AS casted_people_fully_vaccinated_per_hundred,
CASE WHEN people_fully_vaccinated_per_hundred = CAST(people_fully_vaccinated_per_hundred AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT total_boosters_per_hundred, CAST(total_boosters_per_hundred AS DECIMAL(10, 2)) AS casted_total_boosters_per_hundred,
CASE WHEN total_boosters_per_hundred = CAST(total_boosters_per_hundred AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT new_people_vaccinated_smoothed_per_hundred, CAST(new_people_vaccinated_smoothed_per_hundred AS DECIMAL(10, 3)) AS casted_new_people_vaccinated_smoothed_per_hundred,
CASE WHEN new_people_vaccinated_smoothed_per_hundred = CAST(new_people_vaccinated_smoothed_per_hundred AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT stringency_index, CAST(stringency_index AS DECIMAL(10, 2)) AS casted_stringency_index,
CASE WHEN stringency_index = CAST(stringency_index AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT population_density, CAST(population_density AS DECIMAL(20, 3)) AS casted_population_density,
CASE WHEN population_density = CAST(population_density AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT median_age, CAST(median_age AS DECIMAL(10, 1)) AS casted_median_age,
CASE WHEN median_age = CAST(median_age AS DECIMAL(10, 1)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT aged_65_older, CAST(aged_65_older AS DECIMAL(10, 3)) AS casted_aged_65_older,
CASE WHEN aged_65_older = CAST(aged_65_older AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT aged_70_older, CAST(aged_70_older AS DECIMAL(10, 3)) AS casted_aged_70_older,
CASE WHEN aged_70_older = CAST(aged_70_older AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT gdp_per_capita, CAST(gdp_per_capita AS DECIMAL(20, 3)) AS casted_gdp_per_capita,
CASE WHEN gdp_per_capita = CAST(gdp_per_capita AS DECIMAL(20, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT extreme_poverty, CAST(extreme_poverty AS DECIMAL(10, 1)) AS casted_extreme_poverty,
CASE WHEN extreme_poverty = CAST(extreme_poverty AS DECIMAL(10, 1)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT cardiovasc_death_rate, CAST(cardiovasc_death_rate AS DECIMAL(10, 3)) AS casted_cardiovasc_death_rate,
CASE WHEN cardiovasc_death_rate = CAST(cardiovasc_death_rate AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT diabetes_prevalence, CAST(diabetes_prevalence AS DECIMAL(10, 2)) AS casted_diabetes_prevalence,
CASE WHEN diabetes_prevalence = CAST(diabetes_prevalence AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT female_smokers, CAST(female_smokers AS DECIMAL(10, 3)) AS casted_female_smokers,
CASE WHEN female_smokers = CAST(female_smokers AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT male_smokers, CAST(male_smokers AS DECIMAL(10, 3)) AS casted_male_smokers,
CASE WHEN male_smokers = CAST(male_smokers AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT handwashing_facilities, CAST(handwashing_facilities AS DECIMAL(10, 3)) AS casted_handwashing_facilities,
CASE WHEN handwashing_facilities = CAST(handwashing_facilities AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT hospital_beds_per_thousand, CAST(hospital_beds_per_thousand AS DECIMAL(10, 3)) AS casted_hospital_beds_per_thousand,
CASE WHEN hospital_beds_per_thousand = CAST(hospital_beds_per_thousand AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT life_expectancy, CAST(life_expectancy AS DECIMAL(10, 2)) AS casted_life_expectancy,
CASE WHEN life_expectancy = CAST(life_expectancy AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT human_development_index, CAST(human_development_index AS DECIMAL(10, 3)) AS casted_human_development_index,
CASE WHEN human_development_index = CAST(human_development_index AS DECIMAL(10, 3)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT excess_mortality_cumulative_absolute, CAST(excess_mortality_cumulative_absolute AS DECIMAL(20, 8)) AS casted_excess_mortality_cumulative_absolute,
CASE WHEN excess_mortality_cumulative_absolute = CAST(excess_mortality_cumulative_absolute AS DECIMAL(20, 8)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT excess_mortality_cumulative, CAST(excess_mortality_cumulative AS DECIMAL(10, 2)) AS casted_excess_mortality_cumulative,
CASE WHEN excess_mortality_cumulative = CAST(excess_mortality_cumulative AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT excess_mortality, CAST(excess_mortality AS DECIMAL(10, 2)) AS casted_excess_mortality,
CASE WHEN excess_mortality = CAST(excess_mortality AS DECIMAL(10, 2)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

SELECT excess_mortality_cumulative_per_million, CAST(excess_mortality_cumulative_per_million AS DECIMAL(20, 8)) AS casted_excess_mortality_cumulative_per_million,
CASE WHEN excess_mortality_cumulative_per_million = CAST(excess_mortality_cumulative_per_million AS DECIMAL(20, 8)) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;

-- IMPORTANT!
-- a) To reiterate, the new_tests_smoothed feature was mistakenly assumed to be a numerical continuous feature in the Metadata_Report.xlsm file. 
--    The new_tests_smoothed feature is actually a numerically discrete feature.
-- b) To reiterate, as observed in 3_LDI_Completeness.sql, an anomaly has also been observed in the query counting the number of decimal digits in the excess_mortality_cumulative_per_million feature. 
-- 	  The MAX_decimal_digits_len of excess_mortality_cumulative_per_million returns 9 but the correct number of decimal digits when counted is actually 8. 
-- Note that a) has been rectified only within the .sql files and b) has been corrected as an argument for DECIMAL data-type. 
-- All numerically continuous features have been correctly type-casted as there are no False values listed at the top of any of the T_or_F columns.

-- Next Steps:
-- 4. a) Apply the ALTER TABLE command to update the entire table with the appropriate data-types. 
--    b) When altering the entire table from VARCHAR, ensure that the empty strings are being converted into NULLS, not into 0s as it is the case when type-casting.


