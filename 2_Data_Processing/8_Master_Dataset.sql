-- Random Notes/code:
--
--
--



-- IMPORTANT NOTES:
-- change master_dataset to wizard_import_data (NOT import_wizard_data)
-- change date_ to _date_ in all SQL queries and comments
-- working tables should be called: original_owid_covid_dataset, and master_dataset
-- 
-- Data Import & Integrity - Preparation Queries dir, 
-- README: This being a large dataset that would likely be broken down into relational tables for database modelling, 
-- it was important to determine the most efficient approach that would also maintain data integrity during the csv import.

-- Data Import
-- Data Integrity

-- copy master_dataset into owid_covid_data db for practicing SQL queries






-- UPDATE command should not be required since NULLS and/or empty strings can exist in any numerical feature as well.
-- Do NOT run code below!!! 
-- First test for change in error from code 1366 to code 1264.

/*

UPDATE data_load
SET excess_mortality_cumulative_per_million = 0 -- Original Setting: 0
WHERE excess_mortality_cumulative_per_million = ''; -- Original Setting: ''

*/




