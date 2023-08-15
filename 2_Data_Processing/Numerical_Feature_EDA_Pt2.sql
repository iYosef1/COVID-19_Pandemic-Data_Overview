-- Exploratory Data Analysis (EDA) per Feature - Part 2:


-- The EDA for the remaining features will be performed on the working_dataset once again.

-- DROP TABLE IF EXISTS working_dataset;

-- CREATE TABLE working_dataset AS
-- SELECT * FROM owid_covid_master_dataset;

-- SELECT * FROM working_dataset
-- LIMIT 10;


/* Numerical Features - EDA


The 62 numerical features that remain consist of 15 features with a fixed value within each location, and hence, descriptive statistics will not provide any utility. 

	   15 Fixed Features:
       population, population_density, gdp_per_capita, life_expectancy, human_development_index, 
       extreme_poverty, median_age, aged_65_older, aged_70_older, diabetes_prevalence, 
       female_smokers, male_smokers, cardiovasc_death_rate, handwashing_facilities, 
       hospital_beds_per_thousand
       
       
The remaining 47 features are not fixed values within each location, and hence, descriptive statistics may provide some insights:

       Tests & Positivity - 8 Features:
	   new_tests, new_tests_smoothed, new_tests_per_thousand, new_tests_smoothed_per_thousand,
       total_tests, total_tests_per_thousand, 
       positive_rate, tests_per_case

	   Confirmed Cases - 6 Features:
       new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million,
       total_cases, total_cases_per_million
       
       Hospital & ICU - 8 Features:
       hosp_patients, hosp_patients_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million,
       icu_patients, icu_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million
       
       Confirmed Deaths - 6 Features:
       new_deaths, new_deaths_smoothed, new_deaths_per_million, new_deaths_smoothed_per_million,
       total_deaths, total_deaths_per_million
       
       Vaccinations - 13 Features:
       new_vaccinations, new_vaccinations_smoothed, new_vaccinations_smoothed_per_million,
       people_vaccinated, people_vaccinated_per_hundred, 
       people_fully_vaccinated, people_fully_vaccinated_per_hundred, 
       total_boosters, total_boosters_per_hundred, 
       total_vaccinations, total_vaccinations_per_hundred, 
       new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred
       
       Excess Mortality - 4 Features:
       excess_mortality, excess_mortality_cumulative,
       excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million
       
       Spread & Response - 2 features:
       reproduction_rate,
       stringency_index

*/

/* Descriptive Statistics per Feature - Aggregated by Location:

Note that the dataset can be aggregated by locations or dates when calculating the mean, median, mode, etc. However, there are 
existing records which have already been aggregated by location into regions, e.g., World, Asia, Oceania, and so forth. Hence, 
if the dataset was aggregated temporally by date, week, month, or year, then there would be a redundancy in the temporally 
aggregated value. For example, if day-1 of Canada, USA, China, Russia, etc. was aggregated it would be necessary to aggregate 
these records without aggregating the day-1 record of regional locations such as "World" and "Asia". This is because "World" is 
already an aggregated record within this dataset by the date feature.

The intended purpose at this stage of the project is finalizing the "Master Dataset" and Database Design. In addition to this fact,
the current project objective is only to provide an introductory level analysis or data-overview of the COVID-19 Pandemic. Hence,
aggregating the data exclusively by location will suffice in the following EDA.

*/

/* Important! Confirming Features Exclusively with MODE 0: # new_cases

This dataset is only 52% complete with values and of these values, a substantial number of these values were 0s, i.e., there may be numerous
features within this dataset with a mode of 0 at every location. If so, the redundancy in the mode of each feature would serve no purpose in 
the EDA, and hence, the mode frequency will be included in the EDA, rather than the mode, along with the mode in itself in the header. For 
example, if new_cases has a mode of 23 at every location, then the header would be "mode_23_frequency".

If there are any features with a mode that varies from location to location within the feature, then an additional query will be coupled with
its respective EDA to indicate that the mode is not consistent throughout the different locations of that particular feature. 

*/



# 1) New_Tests - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_tests) AS count_of_distinct_new_tests, 
        new_tests,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_tests) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_tests
ORDER BY location ASC, COUNT(new_tests) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_tests AS mode_frequency, new_tests AS new_tests_mode
FROM Mode_table
WHERE row_num = 1;

# 2) New_Tests_Smoothed - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_tests_smoothed) AS count_of_distinct_new_tests_smoothed, 
        new_tests_smoothed,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_tests_smoothed) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_tests_smoothed
ORDER BY location ASC, COUNT(new_tests_smoothed) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_tests_smoothed AS mode_frequency, new_tests_smoothed AS new_tests_smoothed_mode
FROM Mode_table
WHERE row_num = 1;

# 3) New_Tests_Per_Thousand - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_tests_per_thousand) AS count_of_distinct_new_tests_per_thousand, 
        new_tests_per_thousand,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_tests_per_thousand) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_tests_per_thousand
ORDER BY location ASC, COUNT(new_tests_per_thousand) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_tests_per_thousand AS mode_frequency, new_tests_per_thousand AS new_tests_per_thousand_mode
FROM Mode_table
WHERE row_num = 1;

# 4) New_Tests_Smoothed_Per_Thousand - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_tests_smoothed_per_thousand) AS count_of_distinct_new_tests_smoothed_per_thousand, 
        new_tests_smoothed_per_thousand,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_tests_smoothed_per_thousand) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_tests_smoothed_per_thousand
ORDER BY location ASC, COUNT(new_tests_smoothed_per_thousand) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_tests_smoothed_per_thousand AS mode_frequency, new_tests_smoothed_per_thousand AS new_tests_smoothed_per_thousand_mode
FROM Mode_table
WHERE row_num = 1;

# 5) Total_Tests - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_tests) AS count_of_distinct_total_tests, 
        total_tests,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_tests) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_tests
ORDER BY location ASC, COUNT(total_tests) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_tests AS mode_frequency, total_tests AS total_tests_mode
FROM Mode_table
WHERE row_num = 1;

# 6) Total_Tests_Per_Thousand - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_tests_per_thousand) AS count_of_distinct_total_tests_per_thousand, 
        total_tests_per_thousand,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_tests_per_thousand) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_tests_per_thousand
ORDER BY location ASC, COUNT(total_tests_per_thousand) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_tests_per_thousand AS mode_frequency, total_tests_per_thousand AS total_tests_per_thousand_mode
FROM Mode_table
WHERE row_num = 1;

# 7) Positive_Rate - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(positive_rate) AS count_of_distinct_positive_rate, 
        positive_rate,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(positive_rate) DESC) AS row_num
FROM working_dataset
GROUP BY location, positive_rate
ORDER BY location ASC, COUNT(positive_rate) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_positive_rate AS mode_frequency, positive_rate AS positive_rate_mode
FROM Mode_table
WHERE row_num = 1;

# 8) Tests_Per_Case - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(tests_per_case) AS count_of_distinct_tests_per_case, 
        tests_per_case,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(tests_per_case) DESC) AS row_num
FROM working_dataset
GROUP BY location, tests_per_case
ORDER BY location ASC, COUNT(tests_per_case) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_tests_per_case AS mode_frequency, tests_per_case AS tests_per_case_mode
FROM Mode_table
WHERE row_num = 1;

# 9) New_Cases - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_cases) AS count_of_distinct_new_cases, 
        new_cases,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_cases) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_cases
ORDER BY location ASC, COUNT(new_cases) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_cases AS mode_frequency, new_cases AS new_cases_mode
FROM Mode_table
WHERE row_num = 1;

# 10) New_Cases_Smoothed - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_cases_smoothed) AS count_of_distinct_new_cases_smoothed, 
        new_cases_smoothed,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_cases_smoothed) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_cases_smoothed
ORDER BY location ASC, COUNT(new_cases_smoothed) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_cases_smoothed AS mode_frequency, new_cases_smoothed AS new_cases_smoothed_mode
FROM Mode_table
WHERE row_num = 1;

# 11) New_Cases_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_cases_per_million) AS count_of_distinct_new_cases_per_million, 
        new_cases_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_cases_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_cases_per_million
ORDER BY location ASC, COUNT(new_cases_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_cases_per_million AS mode_frequency, new_cases_per_million AS new_cases_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 12) New_Cases_Smoothed_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_cases_smoothed_per_million) AS count_of_distinct_new_cases_smoothed_per_million, 
        new_cases_smoothed_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_cases_smoothed_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_cases_smoothed_per_million
ORDER BY location ASC, COUNT(new_cases_smoothed_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_cases_smoothed_per_million AS mode_frequency, new_cases_smoothed_per_million AS new_cases_smoothed_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 13) Total_Cases - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_cases) AS count_of_distinct_total_cases, 
        total_cases,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_cases) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_cases
ORDER BY location ASC, COUNT(total_cases) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_cases AS mode_frequency, total_cases AS total_cases_mode
FROM Mode_table
WHERE row_num = 1;

# 14) Total_Cases_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_cases_per_million) AS count_of_distinct_total_cases_per_million, 
        total_cases_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_cases_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_cases_per_million
ORDER BY location ASC, COUNT(total_cases_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_cases_per_million AS mode_frequency, total_cases_per_million AS total_cases_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 15) Hosp_Patients - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(hosp_patients) AS count_of_distinct_hosp_patients, 
        hosp_patients,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(hosp_patients) DESC) AS row_num
FROM working_dataset
GROUP BY location, hosp_patients
ORDER BY location ASC, COUNT(hosp_patients) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_hosp_patients AS mode_frequency, hosp_patients AS hosp_patients_mode
FROM Mode_table
WHERE row_num = 1;

# 16) Hosp_Patients_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(hosp_patients_per_million) AS count_of_distinct_hosp_patients_per_million, 
        hosp_patients_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(hosp_patients_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, hosp_patients_per_million
ORDER BY location ASC, COUNT(hosp_patients_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_hosp_patients_per_million AS mode_frequency, hosp_patients_per_million AS hosp_patients_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 17) Weekly_Hosp_Admissions - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(weekly_hosp_admissions) AS count_of_distinct_weekly_hosp_admissions, 
        weekly_hosp_admissions,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(weekly_hosp_admissions) DESC) AS row_num
FROM working_dataset
GROUP BY location, weekly_hosp_admissions
ORDER BY location ASC, COUNT(weekly_hosp_admissions) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_weekly_hosp_admissions AS mode_frequency, weekly_hosp_admissions AS weekly_hosp_admissions_mode
FROM Mode_table
WHERE row_num = 1;

# 18) Weekly_Hosp_Admissions_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(weekly_hosp_admissions_per_million) AS count_of_distinct_weekly_hosp_admissions_per_million, 
        weekly_hosp_admissions_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(weekly_hosp_admissions_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, weekly_hosp_admissions_per_million
ORDER BY location ASC, COUNT(weekly_hosp_admissions_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_weekly_hosp_admissions_per_million AS mode_frequency, weekly_hosp_admissions_per_million AS weekly_hosp_admissions_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 19) Icu_Patients - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(icu_patients) AS count_of_distinct_icu_patients, 
        icu_patients,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(icu_patients) DESC) AS row_num
FROM working_dataset
GROUP BY location, icu_patients
ORDER BY location ASC, COUNT(icu_patients) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_icu_patients AS mode_frequency, icu_patients AS icu_patients_mode
FROM Mode_table
WHERE row_num = 1;

# 20) Icu_Patients_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(icu_patients_per_million) AS count_of_distinct_icu_patients_per_million, 
        icu_patients_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(icu_patients_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, icu_patients_per_million
ORDER BY location ASC, COUNT(icu_patients_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_icu_patients_per_million AS mode_frequency, icu_patients_per_million AS icu_patients_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 21) Weekly_Icu_Admissions - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(weekly_icu_admissions) AS count_of_distinct_weekly_icu_admissions, 
        weekly_icu_admissions,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(weekly_icu_admissions) DESC) AS row_num
FROM working_dataset
GROUP BY location, weekly_icu_admissions
ORDER BY location ASC, COUNT(weekly_icu_admissions) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_weekly_icu_admissions AS mode_frequency, weekly_icu_admissions AS weekly_icu_admissions_mode
FROM Mode_table
WHERE row_num = 1;

# 22) Weekly_Icu_Admissions_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(weekly_icu_admissions_per_million) AS count_of_distinct_weekly_icu_admissions_per_million, 
        weekly_icu_admissions_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(weekly_icu_admissions_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, weekly_icu_admissions_per_million
ORDER BY location ASC, COUNT(weekly_icu_admissions_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_weekly_icu_admissions_per_million AS mode_frequency, weekly_icu_admissions_per_million AS weekly_icu_admissions_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 23) New_Deaths - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_deaths) AS count_of_distinct_new_deaths, 
        new_deaths,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_deaths) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_deaths
ORDER BY location ASC, COUNT(new_deaths) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_deaths AS mode_frequency, new_deaths AS new_deaths_mode
FROM Mode_table
WHERE row_num = 1;

# 24) New_Deaths_Smoothed - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_deaths_smoothed) AS count_of_distinct_new_deaths_smoothed, 
        new_deaths_smoothed,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_deaths_smoothed) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_deaths_smoothed
ORDER BY location ASC, COUNT(new_deaths_smoothed) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_deaths_smoothed AS mode_frequency, new_deaths_smoothed AS new_deaths_smoothed_mode
FROM Mode_table
WHERE row_num = 1;

# 25) New_Deaths_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_deaths_per_million) AS count_of_distinct_new_deaths_per_million, 
        new_deaths_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_deaths_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_deaths_per_million
ORDER BY location ASC, COUNT(new_deaths_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_deaths_per_million AS mode_frequency, new_deaths_per_million AS new_deaths_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 26) New_Deaths_Smoothed_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_deaths_smoothed_per_million) AS count_of_distinct_new_deaths_smoothed_per_million, 
        new_deaths_smoothed_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_deaths_smoothed_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_deaths_smoothed_per_million
ORDER BY location ASC, COUNT(new_deaths_smoothed_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_deaths_smoothed_per_million AS mode_frequency, new_deaths_smoothed_per_million AS new_deaths_smoothed_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 27) Total_Deaths - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_deaths) AS count_of_distinct_total_deaths, 
        total_deaths,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_deaths) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_deaths
ORDER BY location ASC, COUNT(total_deaths) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_deaths AS mode_frequency, total_deaths AS total_deaths_mode
FROM Mode_table
WHERE row_num = 1;

# 28) Total_Deaths_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_deaths_per_million) AS count_of_distinct_total_deaths_per_million, 
        total_deaths_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_deaths_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_deaths_per_million
ORDER BY location ASC, COUNT(total_deaths_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_deaths_per_million AS mode_frequency, total_deaths_per_million AS total_deaths_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 29) New_Vaccinations - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_vaccinations) AS count_of_distinct_new_vaccinations, 
        new_vaccinations,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_vaccinations) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_vaccinations
ORDER BY location ASC, COUNT(new_vaccinations) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_vaccinations AS mode_frequency, new_vaccinations AS new_vaccinations_mode
FROM Mode_table
WHERE row_num = 1;

# 30) New_Vaccinations_Smoothed - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_vaccinations_smoothed) AS count_of_distinct_new_vaccinations_smoothed, 
        new_vaccinations_smoothed,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_vaccinations_smoothed) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_vaccinations_smoothed
ORDER BY location ASC, COUNT(new_vaccinations_smoothed) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_vaccinations_smoothed AS mode_frequency, new_vaccinations_smoothed AS new_vaccinations_smoothed_mode
FROM Mode_table
WHERE row_num = 1;

# 31) New_Vaccinations_Smoothed_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_vaccinations_smoothed_per_million) AS count_of_distinct_new_vaccinations_smoothed_per_million, 
        new_vaccinations_smoothed_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_vaccinations_smoothed_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_vaccinations_smoothed_per_million
ORDER BY location ASC, COUNT(new_vaccinations_smoothed_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_vaccinations_smoothed_per_million AS mode_frequency, new_vaccinations_smoothed_per_million AS new_vaccinations_smoothed_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 32) People_Vaccinated - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(people_vaccinated) AS count_of_distinct_people_vaccinated, 
        people_vaccinated,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(people_vaccinated) DESC) AS row_num
FROM working_dataset
GROUP BY location, people_vaccinated
ORDER BY location ASC, COUNT(people_vaccinated) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_people_vaccinated AS mode_frequency, people_vaccinated AS people_vaccinated_mode
FROM Mode_table
WHERE row_num = 1;

# 33) People_Vaccinated_Per_Hundred - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(people_vaccinated_per_hundred) AS count_of_distinct_people_vaccinated_per_hundred, 
        people_vaccinated_per_hundred,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(people_vaccinated_per_hundred) DESC) AS row_num
FROM working_dataset
GROUP BY location, people_vaccinated_per_hundred
ORDER BY location ASC, COUNT(people_vaccinated_per_hundred) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_people_vaccinated_per_hundred AS mode_frequency, people_vaccinated_per_hundred AS people_vaccinated_per_hundred_mode
FROM Mode_table
WHERE row_num = 1;

# 34) People_Fully_Vaccinated - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(people_fully_vaccinated) AS count_of_distinct_people_fully_vaccinated, 
        people_fully_vaccinated,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(people_fully_vaccinated) DESC) AS row_num
FROM working_dataset
GROUP BY location, people_fully_vaccinated
ORDER BY location ASC, COUNT(people_fully_vaccinated) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_people_fully_vaccinated AS mode_frequency, people_fully_vaccinated AS people_fully_vaccinated_mode
FROM Mode_table
WHERE row_num = 1;

# 35) People_Fully_Vaccinated_Per_Hundred - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(people_fully_vaccinated_per_hundred) AS count_of_distinct_people_fully_vaccinated_per_hundred, 
        people_fully_vaccinated_per_hundred,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(people_fully_vaccinated_per_hundred) DESC) AS row_num
FROM working_dataset
GROUP BY location, people_fully_vaccinated_per_hundred
ORDER BY location ASC, COUNT(people_fully_vaccinated_per_hundred) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_people_fully_vaccinated_per_hundred AS mode_frequency, people_fully_vaccinated_per_hundred AS people_fully_vaccinated_per_hundred_mode
FROM Mode_table
WHERE row_num = 1;

# 36) Total_Boosters - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_boosters) AS count_of_distinct_total_boosters, 
        total_boosters,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_boosters) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_boosters
ORDER BY location ASC, COUNT(total_boosters) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_boosters AS mode_frequency, total_boosters AS total_boosters_mode
FROM Mode_table
WHERE row_num = 1;

# 37) Total_Boosters_Per_Hundred - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_boosters_per_hundred) AS count_of_distinct_total_boosters_per_hundred, 
        total_boosters_per_hundred,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_boosters_per_hundred) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_boosters_per_hundred
ORDER BY location ASC, COUNT(total_boosters_per_hundred) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_boosters_per_hundred AS mode_frequency, total_boosters_per_hundred AS total_boosters_per_hundred_mode
FROM Mode_table
WHERE row_num = 1;

# 38) Total_Vaccinations - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_vaccinations) AS count_of_distinct_total_vaccinations, 
        total_vaccinations,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_vaccinations) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_vaccinations
ORDER BY location ASC, COUNT(total_vaccinations) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_vaccinations AS mode_frequency, total_vaccinations AS total_vaccinations_mode
FROM Mode_table
WHERE row_num = 1;

# 39) Total_Vaccinations_Per_Hundred - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(total_vaccinations_per_hundred) AS count_of_distinct_total_vaccinations_per_hundred, 
        total_vaccinations_per_hundred,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(total_vaccinations_per_hundred) DESC) AS row_num
FROM working_dataset
GROUP BY location, total_vaccinations_per_hundred
ORDER BY location ASC, COUNT(total_vaccinations_per_hundred) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_total_vaccinations_per_hundred AS mode_frequency, total_vaccinations_per_hundred AS total_vaccinations_per_hundred_mode
FROM Mode_table
WHERE row_num = 1;

# 40) New_People_Vaccinated_Smoothed - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_people_vaccinated_smoothed) AS count_of_distinct_new_people_vaccinated_smoothed, 
        new_people_vaccinated_smoothed,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_people_vaccinated_smoothed) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_people_vaccinated_smoothed
ORDER BY location ASC, COUNT(new_people_vaccinated_smoothed) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_people_vaccinated_smoothed AS mode_frequency, new_people_vaccinated_smoothed AS new_people_vaccinated_smoothed_mode
FROM Mode_table
WHERE row_num = 1;

# 41) New_People_Vaccinated_Smoothed_Per_Hundred - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(new_people_vaccinated_smoothed_per_hundred) AS count_of_distinct_new_people_vaccinated_smoothed_per_hundred, 
        new_people_vaccinated_smoothed_per_hundred,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(new_people_vaccinated_smoothed_per_hundred) DESC) AS row_num
FROM working_dataset
GROUP BY location, new_people_vaccinated_smoothed_per_hundred
ORDER BY location ASC, COUNT(new_people_vaccinated_smoothed_per_hundred) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_new_people_vaccinated_smoothed_per_hundred AS mode_frequency, new_people_vaccinated_smoothed_per_hundred AS new_people_vaccinated_smoothed_per_hundred_mode
FROM Mode_table
WHERE row_num = 1;

# 42) Excess_Mortality - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(excess_mortality) AS count_of_distinct_excess_mortality, 
        excess_mortality,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(excess_mortality) DESC) AS row_num
FROM working_dataset
GROUP BY location, excess_mortality
ORDER BY location ASC, COUNT(excess_mortality) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_excess_mortality AS mode_frequency, excess_mortality AS excess_mortality_mode
FROM Mode_table
WHERE row_num = 1;

# 43) Excess_Mortality_Cumulative - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(excess_mortality_cumulative) AS count_of_distinct_excess_mortality_cumulative, 
        excess_mortality_cumulative,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(excess_mortality_cumulative) DESC) AS row_num
FROM working_dataset
GROUP BY location, excess_mortality_cumulative
ORDER BY location ASC, COUNT(excess_mortality_cumulative) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_excess_mortality_cumulative AS mode_frequency, excess_mortality_cumulative AS excess_mortality_cumulative_mode
FROM Mode_table
WHERE row_num = 1;

# 44) Excess_Mortality_Cumulative_Absolute - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(excess_mortality_cumulative_absolute) AS count_of_distinct_excess_mortality_cumulative_absolute, 
        excess_mortality_cumulative_absolute,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(excess_mortality_cumulative_absolute) DESC) AS row_num
FROM working_dataset
GROUP BY location, excess_mortality_cumulative_absolute
ORDER BY location ASC, COUNT(excess_mortality_cumulative_absolute) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_excess_mortality_cumulative_absolute AS mode_frequency, excess_mortality_cumulative_absolute AS excess_mortality_cumulative_absolute_mode
FROM Mode_table
WHERE row_num = 1;

# 45) Excess_Mortality_Cumulative_Per_Million - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
	COUNT(excess_mortality_cumulative_per_million) AS count_of_distinct_excess_mortality_cumulative_per_million, 
        excess_mortality_cumulative_per_million,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(excess_mortality_cumulative_per_million) DESC) AS row_num
FROM working_dataset
GROUP BY location, excess_mortality_cumulative_per_million
ORDER BY location ASC, COUNT(excess_mortality_cumulative_per_million) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_excess_mortality_cumulative_per_million AS mode_frequency, excess_mortality_cumulative_per_million AS excess_mortality_cumulative_per_million_mode
FROM Mode_table
WHERE row_num = 1;

# 46) Reproduction_Rate - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(reproduction_rate) AS count_of_distinct_reproduction_rate, 
        reproduction_rate,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(reproduction_rate) DESC) AS row_num
FROM working_dataset
GROUP BY location, reproduction_rate
ORDER BY location ASC, COUNT(reproduction_rate) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_reproduction_rate AS mode_frequency, reproduction_rate AS reproduction_rate_mode
FROM Mode_table
WHERE row_num = 1;

# 47) Stringency_Index - Mode: 
SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
		COUNT(stringency_index) AS count_of_distinct_stringency_index, 
        stringency_index,
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT(stringency_index) DESC) AS row_num
FROM working_dataset
GROUP BY location, stringency_index
ORDER BY location ASC, COUNT(stringency_index) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_stringency_index AS mode_frequency, stringency_index AS stringency_index_mode
FROM Mode_table
WHERE row_num = 1;





/* Important! The 47 queries below take over ___ hours to execute. The output of each query has already been downloaded and saved as a CSV file in the "Numerical_Features-EDA" directory of the cwd.

To bypass error-code 2013, the following parameters were readjusted as shown below:

DBMS connection keep-alive interval (in seconds): 50

DBMS connection read timeout interval (in seconds): 30000

DBMS connection timeout interval (in seconds): 50

*/

SELECT location AS population_by_location, 
	   ROUND((SUM(CASE WHEN population IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)), 2) * 100 AS feature_completeness_percent, 
       SUM(CASE WHEN population IS NOT NULL THEN 1 ELSE 0 END) AS number_of_values, 
       COUNT(*) AS number_of_records, 
       AVG(population) AS mean,
       MAX(population) AS max,
       MIN(population) AS min,
       MAX(population) - MIN(new_cases) AS _range_
FROM working_dataset
GROUP BY location; 

SELECT location AS new_cases_by_location, 
	   ROUND((SUM(CASE WHEN new_cases IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)), 2) * 100 AS feature_completeness_percent, 
       SUM(CASE WHEN new_cases IS NOT NULL THEN 1 ELSE 0 END) AS number_of_values, 
       COUNT(*) AS number_of_records, 
       AVG(new_cases) AS mean,
       MAX(new_cases) AS max,
       MIN(new_cases) AS min,
       MAX(new_cases) - MIN(new_cases) AS _range_
FROM working_dataset
GROUP BY location; 


-- EDA - Summary: 

/* Important! Descriptive Statistics' Inclusion of Numerical Features' 0s and Exclusion of Numerical Features' NULLs

 If there are many fields of 0 at each location in the early states of the pandemic, i.e., prior to the COVID-oriented features' 
 initial values in the dataset, it may be safe to assume that the NULLs and 0s in this early stage of the pandemic may be excluded 
 from the calculations for descriptive statistics. 

 However, for this introductory level project of data-overviewing all numerical values will be left as is until further advanced 
 analysis can confirm whether or not the NULLs and 0s in the early stage pandemic can be treated synonymously. 

 Note: AVG function includes 0 values in its mean calculation but excludes all NULLs as expected. The Median and Mode queries have also
 included 0 values but have excluded NULLs. 

*/













