/* DATABASE MODELLING: 

Also known as Database Design is the process of designing the schema to create structure and tables (sometimes referred to as relations), remove anomalies, and maintain the integrity of the data. 
For the optimum database design, the process of Normalization will be utilized. 

*/

-- IMPORTANT! Include a table representing data collection success.
-- Note: A table and each record in a table may also be referred to as an entity in the context of database design. A column is still referred to as an attribute.


/* Data Integrity

The following aspects must be ascertained:

Entity Integrity: Unique entities or primary keys must exist in each entity/table.

Referential Integrity: Tables need to be connected by their parent-child relationships to ensure updates are continual throughout entire database.

Domain Integrity: The acceptable values within a column or feature, e.g., column constraints can validate the values permitted in a column.

*/



-- Database Entities:

/* Location Entity:

   Table name: location
   
   Primary key: location

   location, iso_code, continent, population, population_density, gdp_per_capita, life_expectancy, human_development_index, extreme_poverty, 
   median_age, aged_65_older, aged_70_older, diabetes_prevalence, female_smokers, male_smokers, cardiovasc_death_rate, 
   handwashing_facilities, hospital_beds_per_thousand
   
   Notes: 
   • The location feature has a one-to-many relationship exclusively with the region (continent) feature. The remaining features have
     a one-to-one relationship with location.
   • Every record in this table behaves as a superkey and every feature that is not the continent feature can be a candidate key, however,
	 the location feature is the ideal candidate key for the primary key of this table.
   
*/

/* Worldwide Pandemic-data Entity:

   Table name: pandemic_data
   
   Primary key: (location, _date_)
   
   
   Grouped by Specialization - Sub-entities:
   
   Tests & Positivity - 9 features:  
   new_tests, new_tests_smoothed, new_tests_per_thousand, new_tests_smoothed_per_thousand,
   tests_units, 
   total_tests, total_tests_per_thousand, 
   positive_rate, tests_per_case

   Confirmed Cases - 6 features:
   new_cases, new_cases_smoothed, new_cases_per_million, new_cases_smoothed_per_million,
   total_cases, total_cases_per_million 

   Hospital & ICU - 8 features:
   hosp_patients, hosp_patients_per_million, weekly_hosp_admissions, weekly_hosp_admissions_per_million,
   icu_patients, icu_patients_per_million, weekly_icu_admissions, weekly_icu_admissions_per_million

   Confirmed Deaths - 6 features:
   new_deaths, new_deaths_smoothed, new_deaths_per_million, new_deaths_smoothed_per_million,
   total_deaths, total_deaths_per_million
       
   Vaccinations - 13 features:
   new_vaccinations, new_vaccinations_smoothed, new_vaccinations_smoothed_per_million, -
   people_vaccinated, people_vaccinated_per_hundred, 
   people_fully_vaccinated, people_fully_vaccinated_per_hundred, 
   total_boosters, total_boosters_per_hundred, 
   total_vaccinations, total_vaccinations_per_hundred, 
   new_people_vaccinated_smoothed, new_people_vaccinated_smoothed_per_hundred
    
   Excess Mortality - 4 features:
   excess_mortality, excess_mortality_cumulative, 
   excess_mortality_cumulative_absolute, excess_mortality_cumulative_per_million
       
   Spread & Response - 2 features:
   reproduction_rate, 
   stringency_index
   
   Notes:
   • The natural key pair, i.e., location and date, is the ideal primary key for this table as it has also has real-world value in the dataset. 
     A record will always be uniquely identifiable by location on any particular date, and hence, a surrogate key would provide no utility in this context.
   • Important! A table can only have 1 primary key, i.e., it should not consist of both a natural key and a surrogate key and ideally only a natural or 
     surrogate key should be consistently used throughout the database in all tables. A natural key is ideal for this dataset, however, if there is even a 
     single mishap of a NULL in either or both the location and date fields, then the designated primary key of this table will no longer function. 
     A NOT NULL constraint is required for the location and date features.
   • Date Feature: There should always be 1 value per field within a column and, where applicable, each value should be logically split into atomic values, 
     which would result with new columns. The date column will be left as is, i.e., it will not be "atomized" into the year, month, and day constituents.
   • New Cases Feature: In the Metadata Report's feature_description sheet, an incorrect assumption may have been made about the new_cases feature, i.e., 
     the potential error of having included false positives and incorrect diagnoses in this feature. According to OWID's GitHub page, these feature were 
     collectively described as "Confirmed Cases", i.e., there may be no errors in this feature that may be due to false positives and incorrect diagnoses.

*/





/* Feature Constraints for Referential Integrity:

Reminder: All primary keys must be unique, NOT NULL, and (typically) immutable. This criteria is not a prerequisite for foreign keys. 

Primary keys: location and (location, _date_)

Foreign keys: All remaining features are foreign keys but they do not reference any primary keys. 

Within the context of historical data, i.e., the pandemic data collected daily from different locations, it can only 
be deleted or updated if/when there was an error in a data entry. There is no reason to delete or update a value otherwise. 
There is a much higher likelihood of error during data entry than a location and/or date becoming nonexistent and in which 
case, i.e., if the latter is true, then the data collected would still have historical value. 

For both deletion and updates, the CASCADE constraint will follow any changes made. 

*/


/* Dataset Deconstruction:

Due to the minimal need for foreign key referencing or ease of referential integrity within the database, the 
pandemic_data table was not further deconstructed into its available sub-entities in the covid19_pandemic_db. 
However, a secondary database (covid19_pandemic_db_ver2) will be created exclusively to implement an 
Enhanced Entity-Relationship (EER) modelled database in addition to the basic ER model.

*/


/*

Entity-Relationship Model - There will only be one entity (pandemic_data) inclusive of all aforementioned sub-entities of the COVID-19 pandemic.

Entity-Relationship Diagram

Enhanced Entity-Relationship

*/






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


-- Dynamic Features per Location AND Date (Grouped):

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