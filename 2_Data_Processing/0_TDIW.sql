-- Importing COVID-19 Pandemic Dataset:

		
-- Data Import via Table Data Import Wizard:

CREATE DATABASE owid_covid_data;

-- The following were attempts made at importing the csv file with the Table Data Import Wizard:

-- 1st Import Attempt: Failed!
-- All features had their data types set according to the "feature_description" sheet from the Metadata_Report.xlsm file.
-- There was no import error, however, none of the records were imported into the MySQL database.



-- 2st Import Attempt: Failed!
-- All features were left at their default data type settings on the Table Data Import Wizard but MySQL Workbench crashed as 
-- it was running for more than 48hrs. The import was not complete and the complete error message was not displayed due to the crash.
-- The total number of records that were apparently successful in its import were 267,403.
-- The following is one instance of the numerous error messages that were repeatedly displayed for different features throughout the importing process:

-- Row import failed with error: ("Data truncated for column 'handwashing_facilities' at row 1", 1265)



-- 3rd Import Attempt: Failed!
-- All features had their data types set to "text" on Table Data Import Wizard, however, the import still failed as the total number of
-- records that were imported was 83,851. The following error messages were displayed at the end of the import:

-- Row import failed with error: ('Unknown prepared statement handler (stmt) given to EXECUTE', 1243)
-- Import finished

-- Traceback (most recent call last):
-- File "C:\Program Files\MySQL\MySQL Workbench 8.0\workbench\wizard_progress_page_widget.py", line 197, in thread_work self.func()
-- File "C:\Program Files\MySQL\MySQL Workbench 8.0\modules\sqlide_power_import_wizard.py", line 131, in start_import retval = self.module.start(self.stop)
-- File "C:\Program Files\MySQL\MySQL Workbench 8.0\modules\sqlide_power_import_export_be.py", line 300, in start ret = self.start_import()
-- File "C:\Program Files\MySQL\MySQL Workbench 8.0\modules\sqlide_power_import_export_be.py", line 495, in start_import self._editor.executeManagementCommand("DEALLOCATE PREPARE stmt", 1)
-- grt.DBError: ('Unknown prepared statement handler (stmt) given to DEALLOCATE PREPARE', 1243)
-- ERROR: Import data file: ('Unknown prepared statement handler (stmt) given to DEALLOCATE PREPARE', 1243)
-- Failed



-- 3rd Import Attempt: Success!
-- Upon creating an empty table with VARCHAR(255) and with no constraints, error 1118 occurred as follows:

-- Error Code: 1118. Row size too large. The maximum row size for the used table type, not counting BLOBs, is 65535. 
-- This includes storage overhead, check the manual. You have to change some columns to TEXT or BLOBs

-- SHOW TABLE STATUS LIKE 'wizard_import_data'; -- 'Data_length' is 16,384 bytes, the maximum bytes per column in this table.

-- The maximum row size in InnoDB for an entire table is 65,535 bytes. 
-- There are 67 features, and hence, each feature can have a row size (or 'Data_length') of no more than 978 bytes.
-- The character type of the table is "utf8mb4" and it can handle up to 4 bytes per character. 
-- Therefore, the VARCHAR datatype must be readjusted to 244 characters.


CREATE TABLE wizard_import_data (
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


-- Confirmation of Maximum Row Size < 65,535 bytes:
/*    
SELECT SUM(CHARACTER_OCTET_LENGTH) AS Max_Row_Size -- Result = 65,392 bytes < Limit = 65,535 bytes -- use '*' to view all default table parameters
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'owid_covid_data' AND TABLE_NAME = 'wizard_import_data';
*/


-- The 'wizard_import_data' table was successfully created. 
-- For future reference, the metadata extraction should always include the MAX and MIN number of characters within a field for every feature of the dataset.
-- This would allow for setting the ideal datatype limits when creating a SQL table.
-- Otherwise, the excess amount of space that is not in use may impact the database's storage efficiency or performance.
-- This aspect of data-types will be revisited at a later step within this stage of the project.

-- Success! The data was imported into the newly created table without any error codes. The duration of this import was 84,671.685 seconds, or approximately 24 hrs.
-- If there is more efficient method for importing large csv files, it should be explored.