-- Data Import via LOAD DATA INFILE Approach:

-- Importing large csv files can be time-consuming. The following set of queries is a speedy approach for importing large datasets:

DROP TABLE data_load;

CREATE TABLE data_load (
    iso_code VARCHAR(244),
    continent VARCHAR(244),
    location VARCHAR(244),
    date_ VARCHAR(244),
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



-- Note that the backslashes of the output must be replaced by forward slashes when using file paths in SQL.
SHOW VARIABLES LIKE "secure_file_priv";




LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/owid-covid-data.csv' INTO TABLE data_load
FIELDS TERMINATED BY ','
-- Additional arguments to consider when loading data:
-- ENCLOSED BY '"' -- OR... -- OPTIONALLY ENCLOSED BY '"' 
LINES TERMINATED BY '\n' -- If there is an issue in table format, try '\r\n' instead of '\n'.
IGNORE 1 LINES;


-- REVIEW ON DATA LOAD QUERY:

-- The data cannot be previewed immediately after the load as there is apparently a waiting period before it finally becomes accessible in the newly created table.
-- On that note, there is an interruption by Error 2013.
-- Error Code: 2013. Lost connection to MySQL server during query


-- Resolving Error 2013 - Success!:
-- Edit > Preferences > SQL Editor > DBMS connection read timeout interval (in seconds): 600
--                                 > DBMS connection timeout interval (in seconds): 600
--                                 > OK
-- The timeout intervals were both reset to 600, respectively from 30 and 60 in each field. 


-- Note for Future Reference:

-- Error 2013 was resolved. Another approach for resolving this issue would be to reboot the server with the following steps:
-- Press WINDOWS-shortcut + R
-- Type in "Services.msc"
-- Scroll and search for "MySQL80" under "Services (Local)"
-- Right-click on "MySQL80" > Restart or Refresh

-- Success! The LOAD DATA INFILE approach ran without error.






