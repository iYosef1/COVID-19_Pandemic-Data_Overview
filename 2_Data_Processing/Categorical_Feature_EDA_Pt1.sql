-- Exploratory Data Analysis (EDA) per Feature - Part 1:


-- The EDA for each feature will be performed on the working_dataset which is a duplicate of the master dataset.
DROP TABLE IF EXISTS working_dataset;

CREATE TABLE working_dataset AS
SELECT * FROM owid_covid_master_dataset;

-- SELECT * FROM owid_covid_master_dataset
-- LIMIT 10;
SELECT * FROM working_dataset
LIMIT 10;



-- 5 Non-numerical Features - EDA:

-- The 4 categorical features of this dataset are: continent, location, iso_code, and tests_units. The _date_ feature will be included in this set of non-numerical features.

-- Continent Feature:
SELECT DISTINCT(continent) FROM working_dataset; -- The blanks identified will have corresponding values at the same records in the location and iso_code features. 
SELECT COUNT(DISTINCT(continent)) AS distinct_continent_count FROM working_dataset; -- There are 7 distinct values in the continent feature, with only one being a blank. 

-- Continent Blanks:
SELECT continent AS all_continent_blanks, _date_, location FROM working_dataset -- Returns ALL blanks in continent feature.
WHERE continent = '';
SELECT COUNT(continent) AS all_continent_blanks_count FROM working_dataset -- There are a total of 14,234 blanks in the continent feature.
WHERE continent = '';
SELECT DISTINCT(continent) AS distinct_continent_blanks, location AS corresponding_location, iso_code FROM working_dataset -- Exclusively returns the "distinct" blanks in the continent feature.
WHERE continent = '';
SELECT COUNT(DISTINCT(location)) AS distinct_continent_blanks_count FROM working_dataset -- There are 12 "distinct" blanks for each of the corresponding values in the location/iso_code feature.
WHERE continent = '' AND location != '';
-- There are follow-up queries to further analyze the continent feature.


-- Location Feature:
SELECT DISTINCT(location) AS distinct_location FROM working_dataset; -- Returns all distinct locations of the location feature.
SELECT COUNT(DISTINCT(location)) AS distinct_location_count FROM working_dataset; -- There are 255 distinct locations within the location feature.
SELECT location FROM working_dataset -- There are NO blanks in the location feature.
WHERE location = ''; 
SELECT COUNT(location) FROM working_dataset -- Returns 299,237 values for the location feature; NO empty fields.
WHERE location != ''; 

-- ISO Code Feature:
SELECT DISTINCT(iso_code) AS distinct_iso_code FROM working_dataset; -- Returns all distinct iso-codes of the iso_code feature.
SELECT COUNT(DISTINCT(iso_code)) AS distinct_iso_code_count FROM working_dataset; -- There are 255 distinct iso-codes within the iso_code feature.
SELECT iso_code FROM working_dataset -- There are NO blanks in the iso_code feature.
WHERE iso_code = ''; 
SELECT COUNT(iso_code) FROM working_dataset -- Returns 299,237 values for the iso_code feature; NO empty fields.
WHERE iso_code != ''; 

-- Test Unit Feature:
SELECT DISTINCT(tests_units) AS distinct_tests_units FROM working_dataset; -- The blanks may or may not have values in its corresponding features. Investigate this feature further.
SELECT COUNT(DISTINCT(tests_units)) AS distinct_tests_units_count FROM working_dataset; -- There are 5 distinct values in this feature, with only one being a blank.
SELECT COUNT(tests_units) AS blank_tests_units_count FROM working_dataset -- There are 192,449 blanks in the tests_units feature.
WHERE tests_units = ''; 
-- There are follow-up queries to further analyze the tests_units feature.

-- Date Feature:
-- Temporal feature reviewed below.
SET @index = 0;
SELECT (@index := @index + 1) AS index_column, location, _date_ FROM working_dataset; -- Returns ALL dates in the _date_ feature. 
SELECT COUNT(_date_) AS number_of_all_dates FROM working_dataset; -- Returns 299,237 values for the _date_ feature; NO empty fields.

SELECT DISTINCT(_date_) AS distinct_dates FROM working_dataset; -- Returns all distinct dates of the _date_ feature.
SELECT COUNT(DISTINCT(_date_)) AS number_of_distinct_dates FROM working_dataset;-- There are 1,189 distinct dates within the _date_ feature.

-- The date feature does NOT need to be broken into its further atomic elements, i.e., year, month, and day. 
-- In MySQL, the following queries are examples of extracting date elements for the ORDER BY command:
SELECT DISTINCT(_date_) FROM working_dataset
ORDER BY YEAR (_date_);
SELECT DISTINCT(_date_) FROM working_dataset
ORDER BY MONTH (_date_), DAY (_date_);
-- There are follow-up queries to further analyze the _date_ feature.



-- Follow-up Analyses of Features - 1) Continent, 2) Test Unit, and 3) Dates Feature:

-- 1) Ascertaining Filler-values for Blanks ('') in Continent Feature: 
SELECT DISTINCT(continent) AS distinct_continent_blanks, location AS corresponding_location, iso_code, population FROM working_dataset
WHERE continent = ''; -- The corresponding_location and population field values are used in the calculations below.

-- World-population = 7,975,105,024
SELECT 45038860 + 436816679 + 744807803 + 600323657 + 1426736614 + 4721383370 AS ww_pop_by_continent; -- ww_pop_by_continent is 7,975,106,983 >  World-population
-- The preceding calculation confirms that the sum of the continent-associated populations is near the world population but greater than.
SELECT 1250514600 + 2525921300 + 3432097300 + 737604900 AS ww_pop_by_income; -- ww_pop_by_income is 7,946,138,100 <  World-population
-- The preceding calculation confirms that the sum of the income-associated populations is near the world population but less than.

-- Solution: The empty strings identified in the above query will be replaced with filler values. 
-- distinct_continent_blanks, corresponding_location, iso_code   --->   filler_values
-- '', 'Africa', 'OWID_AFR'                --->   Africa
-- '', 'Asia', 'OWID_ASI'                  --->   Asia
-- '', 'Europe', 'OWID_EUR'                --->   Europe
-- '', 'European Union', 'OWID_EUN'        --->   Europe
-- '', 'High income', 'OWID_HIC'           --->   Worldwide income
-- '', 'Low income', 'OWID_LIC'            --->   Worldwide income
-- '', 'Lower middle income', 'OWID_LMC'   --->   Worldwide income
-- '', 'North America', 'OWID_NAM'         --->   North America
-- '', 'Oceania', 'OWID_OCE'               --->   Oceania
-- '', 'South America', 'OWID_SAM'         --->   South America
-- '', 'Upper middle income', 'OWID_UMC'   --->   Worldwide income
-- '', 'World', 'OWID_WRL'                 --->   World
-- To accommodate the new filler-values, the "continent" feature should be renamed to "region".



-- 2) Tests Units - Analysis of Missing Fields:
/* Toggle to view/hide Questions:

a) What are the values of corresponding features where tests_units is blank? Is there a relationship?
b) Which locations are completely blank in the tests_units field?
c) Can the tests_units feature be made into a fixed feature in this dataset? If not, explain why since there are many missing fields within this feature? 

If tests_units feature can be made into a fixed feature, rename this feature to testing_unit. 

*/

-- a) The corresponding new_cases and new_tests features are relevant when analyzing the tests_units feature:
SELECT location, _date_, tests_units, new_cases, new_tests FROM working_dataset
WHERE tests_units <> '';
-- Respective of all tests_units fields that are NOT blank, there are many corresponding instances of NULL in fields of both the new_cases and new_tests feature.

SELECT location, _date_, tests_units, new_cases, new_tests FROM working_dataset
WHERE tests_units = '';
-- Respective of all tests_units fields that are blank, there are many corresponding instances of NULL in the new_cases feature but every instance/field in the new_tests feature is NULL.

SET @index = 0;
SELECT (@index := @index + 1) AS index_column, 
		location, 
        COUNT(*) AS number_of_records, 
        SUM(CASE WHEN tests_units != '' THEN 1 ELSE 0 END) AS number_of_tests_units_values, 
        SUM(new_cases), SUM(new_tests) FROM working_dataset
GROUP BY location;
-- There does not appear to be any strikingly obvious correlation between the tests_units, new_cases, and new_tests features. 
-- The only immediate observation that can be drawn is that a location has no value in the new_tests feature when there is no indication of a testing unit at that very location.


-- b) The following queries return different (sub)sets of locations with respect to their testing unit:
SET @index = 0; -- Lists ALL locations and their respective COUNT of distinct tests_units value.
SELECT (@index := @index + 1) AS index_column, COUNT(DISTINCT(tests_units)) AS distinct_testing_unit_count, location FROM working_dataset
GROUP BY location;
-- The output has been split by the residing 1 and 2 values in the distinct_testing_unit_count column, respectively into the 2 queries below:

SET @index = 0; -- There are 63 locations with 1 distinct tests_units value.
SELECT (@index := @index + 1) AS index_column, COUNT(DISTINCT(tests_units)) AS distinct_testing_unit_count, location FROM working_dataset
GROUP BY location
HAVING COUNT(DISTINCT(tests_units)) = 1; 

SET @index = 0; -- There are 192 locations with 2 distinct tests_units value.
SELECT (@index := @index + 1) AS index_column, COUNT(DISTINCT(tests_units)) AS distinct_testing_unit_count, location FROM working_dataset
GROUP BY location
HAVING COUNT(DISTINCT(tests_units)) = 2; 


-- There are 193 locations with a distinctive tests_units value that is NOT a blank.
SELECT DISTINCT(location), tests_units FROM working_dataset
WHERE tests_units != '';

-- There are 254 locations with a distinctive tests_units value that is a blank. 
SELECT DISTINCT(location), tests_units FROM working_dataset
WHERE tests_units = '';

-- The previous 2 queries have been used in the following JOIN queries:

-- 192 locations distinctively have BOTH a value and a blank in the tests_units feature.
SET @index = 0;
WITH 
Values_tab AS
(SELECT DISTINCT(location) AS location, tests_units AS tests_units_1 FROM working_dataset
WHERE tests_units != ''),
Blanks_tab AS
(SELECT DISTINCT(location) AS location_1, tests_units AS tests_units_2 FROM working_dataset
WHERE tests_units = ''),
Joined_tab AS
(SELECT * 
FROM Values_tab INNER JOIN Blanks_tab
ON Values_tab.location = Blanks_tab.location_1)
SELECT (@index := @index + 1) AS location_index, 
       Joined_tab.location, 
       Joined_tab.tests_units_1, 
       Joined_tab.tests_units_2 
FROM Joined_tab;

-- There is ONLY 1 location (Western Sahara) exclusively with a distinctive value in the tests_units feature, i.e., it does NOT contain a blank.
SET @index = 0;
WITH 
Values_tab AS
(SELECT DISTINCT(location) AS location, tests_units AS tests_units_1 FROM working_dataset
WHERE tests_units != ''),
Blanks_tab AS
(SELECT DISTINCT(location) AS location_1, tests_units AS tests_units_2 FROM working_dataset
WHERE tests_units = ''),
Joined_tab AS
(SELECT * 
FROM Values_tab LEFT JOIN Blanks_tab
ON Values_tab.location = Blanks_tab.location_1
WHERE Blanks_tab.location_1 IS NULL)
SELECT (@index := @index + 1) AS location_index, 
	   Joined_tab.location, 
       Joined_tab.tests_units_1, 
       Joined_tab.tests_units_2 
FROM Joined_tab;

-- There are 62 locations exclusively with a blank in the tests_units feature, i.e., the locations do NOT contain a distinctive value. 
SET @index = 0;
WITH 
Values_tab AS
(SELECT DISTINCT(location) AS location, tests_units AS tests_units_1 FROM working_dataset
WHERE tests_units != ''),
Blanks_tab AS
(SELECT DISTINCT(location) AS location_1, tests_units AS tests_units_2 FROM working_dataset
WHERE tests_units = ''),
Joined_tab AS
(SELECT * 
FROM Values_tab RIGHT JOIN Blanks_tab
ON Values_tab.location = Blanks_tab.location_1
WHERE Values_tab.location IS NULL)
SELECT (@index := @index + 1) AS location_index, 
	   Joined_tab.location_1 AS location,
       Joined_tab.tests_units_1, 
       Joined_tab.tests_units_2 
FROM Joined_tab;


/* c) The tests_units feature may be treated as a fixed feature in this dataset.
      
      Respective of the tests_units feature, there are many missing fields within each location but there are some locations that are entirely NULL of a testing unit.
	  As per the Metadata Report's feature_description sheet, a country cannot contain mixed units, and hence, the blanks within a country can be disregarded if it 
      has a testing unit. 
      
      A continent, however, may have mixed units depending on the countries comprising it, and hence, Asia, Europe, Africa, Oceania, North America, and South America
      do not have a testing unit. The European Union, High income, Low income, Lower middle income, Upper middle income, and World "locations" also do not have a testing unit.

      The following list is comprised of the 62 locations, of which 50 are countries, that do not have a testing unit available:
      1, Africa
      2, American Samoa
      3, Asia
      4, Bonaire Sint Eustatius and Saba 
      5, Cook Islands
      6, England
      7, Europe
      8, European Union
      9, Falkland Islands
      10, French Guiana
      11, French Polynesia
      12, Greenland
      13, Guadeloupe
      14, Guernsey
      15, High income
      16, Honduras
      17, Isle of Man
      18, Jersey
      19, Kiribati
      20, Kyrgyzstan
      21, Low income
      22, Lower middle income
      23, Macao
      24, Martinique
      25, Mayotte
      26, Micronesia (country)
      27, Monaco
      28, Montenegro
      29, Montserrat
      30, Nauru
      31, New Caledonia
      32, Niue
      33, North America 
      34, Northern Cyprus 
      35, Northern Ireland 
      36, Oceania 
      37, Pitcairn
      38, Reunion
      39, Saint Barthelemy
      40, Saint Helena
      41, Saint Martin (French part)
      42, Saint Pierre and Miquelon
      43, Samoa
      44, San Marino
      45, Scotland
      46, Seychelles
      47, Sint Maarten (Dutch part)
      48, Solomon Islands
      49, South America
      50, Tajikistan
      51, Tokelau
      52, Tonga
      53, Turkmenistan
      54, Turks and Caicos Islands
      55, Tuvalu
      56, Upper middle income
      57, Uzbekistan
      58, Vatican
      59, Venezuela 
      60, Wales
      61, Wallis and Futuna 
      62, World

*/
-- The 6 continents have been aggregated to view which testing unit is predominantly used by the countries within each continent:
SET @index = 0;
WITH 
Values_tab AS
(SELECT DISTINCT(location) AS location, continent AS continent_1, tests_units AS tests_units_1 FROM working_dataset
WHERE tests_units != ''),
Blanks_tab AS
(SELECT DISTINCT(location) AS location_1, continent AS continent_2, tests_units AS tests_units_2 FROM working_dataset
WHERE tests_units = ''),
Joined_tab AS
(SELECT * 
FROM Values_tab INNER JOIN Blanks_tab
ON Values_tab.location = Blanks_tab.location_1),
Locations_with_testing_unit AS
(SELECT (@index := @index + 1) AS location_index,
	   Joined_tab.continent_1 AS continent,
       Joined_tab.location, 
       Joined_tab.tests_units_1 AS tests_units
FROM Joined_tab
ORDER BY continent ASC)
SELECT continent, tests_units, COUNT(tests_units) AS number_of_countries_using_same_testing_unit FROM Locations_with_testing_unit
GROUP BY continent, tests_units
ORDER BY continent, number_of_countries_using_same_testing_unit DESC;

/* The testing unit predominantly in use by every continent, i.e., by most countries in each continent, is "tests performed".

As shown below, the testing units of each continent is comprised of the aggregated testing units by countries within each continent.

- Africa - Total Countries: 53
Africa, tests performed, 48
Africa, people tested, 3
Africa, samples tested, 2

- Asia - Total Countries: 45
Asia, tests performed, 27
Asia, samples tested, 9
Asia, people tested, 8
Asia, units unclear, 1

- Europe - Total Countries: 44
Europe, tests performed, 38
Europe, people tested, 5
Europe, samples tested, 1

- North America - Total Countries: 30
North America, tests performed, 21
North America, people tested, 6
North America, samples tested, 3

- Oceania - Total Countries: 9
Oceania, tests performed, 7
Oceania, people tested, 2

- South America - Total Countries: 11
South America, tests performed, 9
South America, people tested, 2

*/
-- Important! The continents in the location feature cannot be assigned a testing unit as each continent has been confirmed to have a mix of units. 
-- However, the tests_units feature can still be renamed to "testing_unit" and be treated as a fixed feature since ~76% of the locations have a testing unit assigned. 



-- 3) Analyzing Range of Dates - From Earliest to Latest by Location:
/* Important! The timeline for which the owid_covid_data was downloaded was from Jan 08, 2020 to Mar 29, 2023, inclusive.

   In order to view the earliest and latest date for each location of the dataset, the aggregate functions MIN and MAX 
   will be utilized in the subsequent queries. It has been confirmed in the Metadata Report that only 52% of fields in
   this dataset has values. For this reason, the use of any aggregate function may skew the results as some locations 
   may have more or less records than other locations.
   
   In spite of confirming 299,237 values in the _date_ feature, in the context of this dataset, i.e., 48% of this dataset 
   being comprised of empty fields, it is safe to infer the following as plausible causes for these empty fields:
   
   1) The low rate at which COVID-19 spread at the earlier stages of the pandemic.
   2) The outbreak of COVID-19 had a starting point location from which it spread to other locations at a later time.
   2) Data collection may have been a necessity at some locations but not yet at others due to the varying severity 
      of the virus at different locations.
   3) Varying from location to location, there may have been a lack of vigilance or resources for consistent data collection.
   
   With that being said, exclusively for numerical features, it will be necessary to query the number of records available 
   at each location. However, in the case of the _date_ feature, it will also necessary to query the number of records 
   available at each location. The MIN and MAX values are typically an aspect of Descriptive Statistics which in itself is 
   a branch of EDA that's applied to numerical features. In this case, it will be necessary to identify the number of records 
   per location for the _date_ feature as well because some locations may not have the same number of total dates as other 
   locations, and hence, the earliest and latest start_date (MIN value) of all locations and the earliest and latest end_date 
   (MAX value) of all locations may be skewed.
   
*/

-- Aggregating Records for COUNT:
-- Note: The COUNT function is able to aggregate with "*" as the argument but is also able to aggregate with "_date_" as the argument.
SELECT location, COUNT(*) AS number_of_records FROM working_dataset -- Returns the number of records for each location in ASC order, i.e., from least to greatest. 
GROUP BY location
ORDER BY COUNT(*) ASC;

WITH aggregated_data AS -- Returns the location with the lowest number of records, along with its respective COUNT of records.
(SELECT location, COUNT(*) AS number_of_records 
FROM working_dataset
GROUP BY location)
SELECT location, number_of_records AS min_number_of_records FROM aggregated_data
WHERE number_of_records = (SELECT MIN(number_of_records) FROM aggregated_data);

SELECT location, COUNT(*) AS number_of_records FROM working_dataset -- Returns the number of records for each location in DESC order, i.e., from greatest to least. 
GROUP BY location
ORDER BY COUNT(*) DESC;

WITH aggregated_data AS -- Returns the location with the highest number of records, along with its respective COUNT of records.
(SELECT location, COUNT(*) AS number_of_records 
FROM working_dataset
GROUP BY location)
SELECT location, number_of_records AS max_number_of_records FROM aggregated_data
WHERE number_of_records = (SELECT MAX(number_of_records) FROM aggregated_data);


-- Aggregating Locations for Date Range: 
SET @index = 0; -- Returns earliest (MIN) and latest (MAX) date for all locations in alphabetical order. 
SELECT (@index := @index + 1) AS country_index, location, MIN(_date_) AS start_date, MAX(_date_) AS end_date FROM working_dataset 
GROUP BY location;

SET @index = 0; -- Returns start_date of each location, ordered from earliest to latest.
SELECT (@index := @index + 1) AS country_index, location, MIN(_date_) AS start_date FROM working_dataset
GROUP BY location
ORDER BY MIN(_date_) ASC;
-- The earliest start date was NOT on Jan 08, 2020. 
-- The earliest start date returned was Jan 01, 2020 at both Argentina and Mexico.
-- Other Note(s):
-- The latest start date returned within 2020 was Apr 01, 2020 at Wales, however, there were 3 locations that started after 2020 with the latest of these 3 dates being Apr 20, 2022.
-- These 3 locations also happen to have the lowest number of records with Western Sahara at its start date of Apr 20, 2022 occupying only a single record in the entire dataset.

SET @index = 0; -- Returns end_date of each location, ordered from latest to earliest.
SELECT (@index := @index + 1) AS country_index, location, MAX(_date_) AS end_date FROM working_dataset
GROUP BY location
ORDER BY MAX(_date_) DESC;
-- The latest end date was NOT on Mar 29, 2023.
/* The latest end date returned was Apr 03, 2023 for numerous countries. 

The following countries had the same end_date, i.e., Apr 03, 2023:
Aruba, Austria, Bangladesh, Bulgaria, Chile, Croatia, Czechia, Fiji, Germany, Greece, India, Israel, Italy, Kyrgyzstan, Lithuania, Malaysia, Netherlands, 
New Caledonia, Papua New Guinea, Russia, Serbia, South Korea, Sweden, Switzerland, Tonga, Uruguay.

*/
-- Other Note(s):
-- The earliest end date returned within 2023 was Mar 24, 2023, however, there were 2 locations that ended before 2023 with the earliest of these 2 dates being West Sahara on Apr 20, 2022.


/* Confirming Timeline of Original Dataset Downloaded:

   According to the OWID download page of the original owid_covid_data, the timeline covered in the download is from Jan 08, 2020 to Mar 29, 2023, inclusive.
   However, contrary to the 2 previous queries respectively returning Jan 08, 2020 and Mar 29, 2023, unexpectedly both queries instead respectively returned the 
   earliest date as Jan 01, 2020 and the latest date as Apr 03, 2023 instead.
   
   The timeline for this download was from Jan 08, 2020 to Mar 29, 2023. The new_cases feature is foundational to the majority of other features, i.e., it acts
   as an implicit baseline because of its affect on other features, e.g., new cases can lead to new deaths, a higher demand for vaccinations, and so forth. It is
   safe to assume that the values of the new_cases feature will be the earliest indicator of a value in any record in the dataset for any particular location. A 
   comparison with the new_cases feature may provide some insight on the records outside the timeline of Jan 08, 2020 to Mar 29, 2023.

*/

-- Returns the 246 locations with a start_date prior to Jan 08, 2020:
WITH temp_table AS
(SELECT location, (CASE WHEN MIN(_date_) < '2020-01-08' THEN 1 ELSE 0 END) AS before_jan_08 FROM working_dataset
GROUP BY location)
SELECT SUM(before_jan_08) AS count_dates_before_jan08_2020 FROM temp_table;

-- Returns the 57 locations with an end_date subsequent of Mar 29, 2023.:
WITH temp_table AS
(SELECT location, (CASE WHEN MAX(_date_) > '2023-03-29' THEN 1 ELSE 0 END) AS after_mar_29 FROM working_dataset
GROUP BY location)
SELECT SUM(after_mar_29) AS count_dates_after_mar29_2023 FROM temp_table;
-- The outputs do not concur with the timeline from which the dataset was downloaded from, i.e., all dates should fall within the timeline of the download. 


-- A) Returns the sum of new_cases of all records for all dates, i.e., unrestricted by any particular range, and grouped by location.
SET @index = 0;
SELECT (@index := @index + 1) AS country_index, location, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) FROM working_dataset
GROUP BY location;
/* The output displays 246 locations with a start_date prior to Jan 08, 2020 and 57 locations with an end_date subsequent of Mar 29, 2023.

-- Important! 246 locations had a start_date that was before Jan 08, 2020, on either Jan 01, 2020 or Jan 03, 2020 which does not concur with the timeline of the original download. 
-- NONE of the locations in the dataset had a start_date of Jan 08, 2020.

-- The remaining 9 locations had a start_date that passed Jan 08, 2020:
# country_index, location, start_date, end_date, SUM(new_cases)
-- 222, Taiwan, 2020-01-16, 2023-03-24, NULL
-- 99, Hong Kong, 2020-01-31, 2023-04-02, NULL
-- 167, Northern Ireland, 2020-03-01, 2023-03-29, NULL
-- 200, Scotland, 2020-03-07, 2023-03-27, NULL
-- 65, England, 2020-03-20, 2023-03-29, NULL
-- 249, Wales, 2020-04-01, 2023-03-30, NULL
-- 166, Northern Cyprus, 2021-01-14, 2022-12-06, NULL
-- 131, Macao, 2021-02-08, 2023-03-31, NULL
-- 251, Western Sahara, 2022-04-20, 2022-04-20, NULL


-- Important! There were numerous locations with an end_date up to and including Mar 29, 2023.
-- However, the following 57 locations had an end_date that passed Mar 29, 2023 which does not concur with the timeline of the original download:
# country_index, location, start_date, end_date, SUM(new_cases)
-- 12, Aruba, 2020-01-03, 2023-04-03, 44135
-- 13, Asia, 2020-01-03, 2023-04-03, 295439503
-- 15, Austria, 2020-01-03, 2023-04-03, 6024875
-- 19, Bangladesh, 2020-01-03, 2023-04-03, 2038014
-- 34, Bulgaria, 2020-01-03, 2023-04-03, 1299557
-- 44, Chile, 2020-01-03, 2023-04-03, 5255620
-- 52, Croatia, 2020-01-03, 2023-04-03, 1270513
-- 56, Czechia, 2020-01-03, 2023-04-03, 4631804
-- 71, Europe, 2020-01-03, 2023-04-03, 247649693
-- 72, European Union, 2020-01-03, 2023-04-03, 183150422
-- 75, Fiji, 2020-01-03, 2023-04-03, 68911
-- 83, Germany, 2020-01-03, 2023-04-03, 38338298
-- 86, Greece, 2020-01-03, 2023-04-03, 5951892
-- 97, High income, 2020-01-03, 2023-04-03, 418005152
-- 102, India, 2020-01-03, 2023-04-03, 44708279
-- 108, Israel, 2020-01-03, 2023-04-03, 4812797
-- 109, Italy, 2020-01-03, 2023-04-03, 25673442
-- 119, Kyrgyzstan, 2020-01-03, 2023-04-03, 206805
-- 127, Lithuania, 2020-01-03, 2023-04-03, 1313471
-- 129, Lower middle income, 2020-01-03, 2023-04-03, 96959399
-- 134, Malaysia, 2020-01-03, 2023-04-03, 5047040
-- 156, Netherlands, 2020-01-03, 2023-04-03, 8608123
-- 157, New Caledonia, 2020-01-03, 2023-04-03, 80032
-- 163, North America, 2020-01-03, 2023-04-03, 123272857
-- 170, Oceania, 2020-01-03, 2023-04-03, 13772917
-- 176, Papua New Guinea, 2020-01-03, 2023-04-03, 46835
-- 187, Russia, 2020-01-03, 2023-04-03, 22603646
-- 202, Serbia, 2020-01-03, 2023-04-03, 2515136
-- 212, South America, 2020-01-03, 2023-04-03, 68206001
-- 213, South Korea, 2020-01-03, 2023-04-03, 30773460
-- 219, Sweden, 2020-01-03, 2023-04-03, 2701192
-- 220, Switzerland, 2020-01-03, 2023-04-03, 4396055
-- 229, Tonga, 2020-01-03, 2023-04-03, 16814
-- 242, Upper middle income, 2020-01-03, 2023-04-03, 242952472
-- 243, Uruguay, 2020-01-03, 2023-04-03, 1036188
-- 252, World, 2020-01-03, 2023-04-03, 761416753
-- 10, Argentina, 2020-01-01, 2023-04-02, 10044957
-- 77, France, 2020-01-03, 2023-04-02, 38677413
-- 99, Hong Kong, 2020-01-31, 2023-04-02, NULL
-- 111, Japan, 2020-01-03, 2023-04-02, 33421785
-- 178, Peru, 2020-01-03, 2023-04-02, 4491653
-- 181, Poland, 2020-01-03, 2023-04-02, 6491417
-- 215, Spain, 2020-01-03, 2023-04-02, 13790580
-- 53, Cuba, 2020-01-03, 2023-04-01, 1112789
-- 58, Denmark, 2020-01-03, 2023-04-01, 3407804
-- 106, Ireland, 2020-01-03, 2023-04-01, 1706176
-- 23, Belize, 2020-01-03, 2023-03-31, 70830
-- 62, Ecuador, 2020-01-03, 2023-03-31, 1071261
-- 91, Guatemala, 2020-01-03, 2023-03-31, 1243527
-- 98, Honduras, 2020-01-03, 2023-03-31, 472459
-- 110, Jamaica, 2020-01-03, 2023-03-31, 154538
-- 131, Macao, 2021-02-08, 2023-03-31, NULL
-- 159, Nicaragua, 2020-01-03, 2023-03-31, 15682
-- 177, Paraguay, 2020-01-03, 2023-03-31, 735759
-- 14, Australia, 2020-01-03, 2023-03-30, 11077631
-- 61, Dominican Republic, 2020-01-03, 2023-03-30, 660937
-- 249, Wales, 2020-04-01, 2023-03-30, NULL

*/

-- B) Returns the sum of new_cases of all records on dates between Jan 08, 2020 and Mar 29, 2023, grouped by location.
-- The earliest and latest date of each location is respectively from Jan 08, 2020 to Mar 29, 2023.
SET @index = 0;
SELECT (@index := @index + 1) AS country_index, location, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) FROM working_dataset
WHERE _date_ BETWEEN '2020-01-08' AND '2023-03-29'
GROUP BY location; 
-- Important! With the use of the WHERE keyword, all start dates earlier than Jan 08, 2020 and all end dates later than Mar 29, 2023 were simply readjusted to be Jan 08, 2020 and Mar 29, 2023, respectively.
/* Important! With the use of the WHERE keyword, i.e., query B), there are 9 locations with discrepancies in the SUM(new_cases) column than without the WHERE keyword, i.e., A).

   As per the output of the previous 2 queries, A) and B), the following query lists the 9 discrepancies.

*/


-- Asia, China, Europe, European Union, Finland, Germany, High income, Upper middle income, and World have a discrepancy in the SUM(new_cases) column. 
-- The following query's output consists of start and end dates that were unrestricted as in the case with query A), i.e., the original start and end dates of each location as provided by OWID.
SET @index = 0;
WITH 
TabA AS
(SELECT location AS loc1, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_1 FROM working_dataset
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

TabB AS 
(SELECT location AS loc2, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) AS total_2 FROM working_dataset
WHERE _date_ BETWEEN '2020-01-08' AND '2023-03-29'
GROUP BY location
HAVING SUM(new_cases) IS NOT NULL),

VarianceValuesCopy1 AS 
(SELECT TabA.loc1, TabB.loc2, TabA.start_date, TabA.end_date, TabA.total_1, TabB.total_2 
FROM TabA LEFT JOIN TabB
ON TabA.total_1 = TabB.total_2
WHERE TabB.total_2 IS NULL
UNION
SELECT TabA.loc1, TabB.loc2, TabA.start_date, TabA.end_date, TabA.total_1, TabB.total_2 
FROM TabA RIGHT JOIN TabB
ON TabA.total_1 = TabB.total_2
WHERE TabA.total_1 IS NULL),

VarianceValuesCopy2 AS 
(SELECT TabA.loc1, TabB.loc2, TabA.start_date, TabA.end_date, TabA.total_1, TabB.total_2 
FROM TabA LEFT JOIN TabB
ON TabA.total_1 = TabB.total_2
WHERE TabB.total_2 IS NULL
UNION
SELECT TabA.loc1, TabB.loc2, TabA.start_date, TabA.end_date, TabA.total_1, TabB.total_2 
FROM TabA RIGHT JOIN TabB
ON TabA.total_1 = TabB.total_2
WHERE TabA.total_1 IS NULL)

SELECT (@index := @index + 1) AS country_index, 
	    VarianceValuesCopy1.loc1 AS location, 
        VarianceValuesCopy1.start_date, 
        VarianceValuesCopy1.end_date, 
        VarianceValuesCopy1.total_1 AS total_new_cases_unrestricted_dates, 
        VarianceValuesCopy2.total_2 AS total_new_cases_restricted_dates,
        (VarianceValuesCopy2.total_2 - VarianceValuesCopy1.total_1) AS new_cases_discrepancy_after_restricting_dates
FROM VarianceValuesCopy1 JOIN VarianceValuesCopy2
ON VarianceValuesCopy1.loc1 = VarianceValuesCopy2.loc2;

-- China and Finland are ascertained to be the only 2 locations of the 9 that have a start date before Jan 01, 2020.
SET @index = 0;
SELECT (@index := @index + 1) AS country_index, location, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) FROM working_dataset
GROUP BY location
HAVING MIN(_date_) < '2020-01-08'; 

-- Asia, Europe, European Union, Germany, High Income, Upper middle income, and World are ascertained to be the remaining 7 locations that have both a start and end date outside the timeline range. 
SET @index = 0;
SELECT (@index := @index + 1) AS country_index, location, MIN(_date_) AS start_date, MAX(_date_) AS end_date, SUM(new_cases) FROM working_dataset
GROUP BY location
HAVING MAX(_date_) > '2023-03-29'; 


/* Identifying 9 Location Discrepancies by Record - Unaggregating Location Feature:

To reiterate, when the dates were restricted within the (Jan 08, 2020 to Mar 29, 2023) downloaded timeline, there was a 
discrepancy in the SUM(new_cases) column for 9 different locations. The queries below provide a breakdown of SUM(new_cases) 
at each of these 9 locations by the individual constituent fields of the new_cases feature. 

*/

-- Notes:
-- Both Finland and Germany are both part of the European Union. 
-- The commented values adjacent to the 2 sets of queries below are indicative of the new_cases values overlapping one another by location. 

-- China and Finland:
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'China' AND _date_ < '2020-01-08' AND new_cases IS NOT NULL; -- China --> 2020-01-04: 1 new case, 2020-01-06: 3 new cases
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'Finland' AND _date_ < '2020-01-08' AND new_cases IS NOT NULL; -- Finland --> 2020-01-04: 1 new case

-- Asia, Europe, European Union, Germany, High Income, Upper middle income, and World:
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'Asia' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- Asia --> 2020-01-04: 1 new case, 2020-01-06: 3 new cases
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'Europe' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- Europe --> 2020-01-04: 2 new cases 
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'European Union' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- European Union -->  2020-01-04: 2 new cases 
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'Germany' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- Germany --> 2020-01-04: 1 new case 
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'High Income' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- High Income --> 2020-01-04: 2 new cases  
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'Upper middle income' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- Upper middle income --> 2020-01-04: 1 new case, 2020-01-06: 3 new cases  
SELECT _date_, location, new_cases FROM working_dataset
WHERE location = 'World' AND _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29' AND new_cases IS NOT NULL; -- World --> 2020-01-04: 3 new cases, 2020-01-06: 3 new cases
-- According exclusively to the new_cases feature, there are values prior to Jan 08, 2023, however, there are no values subsequent of Mar 29, 2023. 
-- This is not conclusive for assuming that ALL features go back prior to Jan 08, 2023 for values but enough to conclude that the timeline indicated at during the download was erroneous. 
-- This is also not conclusive for assuming that the remaining do not have values subsequent of Mar 29, 2023.

-- The following SELECT query returns the base features (refer to the Metadata Report) outside the scope of the downloaded timeline and is ordered by the _date_ feature. 
SELECT location, _date_,
       new_tests, tests_units, new_cases, 
       hosp_patients, weekly_hosp_admissions, icu_patients, weekly_icu_admissions, 
       new_deaths, 
       new_vaccinations, people_vaccinated, people_fully_vaccinated, total_boosters, 
       excess_mortality, excess_mortality_cumulative, reproduction_rate, stringency_index
FROM working_dataset
WHERE _date_ NOT BETWEEN '2020-01-08' AND '2023-03-29'
ORDER BY _date_	ASC;  -- Change ORDER BY to DESC order to view latest values. 
-- Upon reviewing the output, the new_tests feature has the earliest values in this dataset and the vaccination features have the latest values in this dataset.

-- The new_tests and people_vaccinated features have been queried for NOT NULL values in order of date. 
SELECT location, _date_, new_tests FROM working_dataset
WHERE new_tests IS NOT NULL
ORDER BY _date_ ASC;

SELECT location, _date_, people_vaccinated FROM working_dataset
WHERE people_vaccinated IS NOT NULL
ORDER BY _date_ DESC;
-- The earliest date with a value in the new_tests feature is 2020-01-01.
-- The latest date with a value in the people_vaccinated feature is 2023-04-03.
-- IMPORTANT! The CHANGELOG will be updated to include the correct timeframe of this dataset, i.e., Jan 01, 2020 to Apr 03, 2023. 



-- EDA - Summary: 



