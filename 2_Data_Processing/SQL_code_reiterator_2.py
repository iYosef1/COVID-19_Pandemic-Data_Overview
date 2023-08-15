print('\nEDA - 62 NUMERICAL FEATURES: \n\n')

numerical_fixed_features = ['population', 'population_density', 'gdp_per_capita', 'life_expectancy', 'human_development_index', 'extreme_poverty',
                            'median_age', 'aged_65_older', 'aged_70_older', 'diabetes_prevalence', 'female_smokers', 'male_smokers', 'cardiovasc_death_rate',
                            'handwashing_facilities', 'hospital_beds_per_thousand']

numerical_features = ['new_tests', 'new_tests_smoothed', 'new_tests_per_thousand',
                      'new_tests_smoothed_per_thousand', 'total_tests', 'total_tests_per_thousand', 'positive_rate', 'tests_per_case', 'new_cases',
                      'new_cases_smoothed', 'new_cases_per_million', 'new_cases_smoothed_per_million', 'total_cases', 'total_cases_per_million',
                      'hosp_patients', 'hosp_patients_per_million', 'weekly_hosp_admissions', 'weekly_hosp_admissions_per_million','icu_patients',
                      'icu_patients_per_million', 'weekly_icu_admissions', 'weekly_icu_admissions_per_million', 'new_deaths', 'new_deaths_smoothed',
                      'new_deaths_per_million', 'new_deaths_smoothed_per_million', 'total_deaths', 'total_deaths_per_million', 'new_vaccinations',
                      'new_vaccinations_smoothed', 'new_vaccinations_smoothed_per_million', 'people_vaccinated', 'people_vaccinated_per_hundred',
                      'people_fully_vaccinated', 'people_fully_vaccinated_per_hundred', 'total_boosters', 'total_boosters_per_hundred', 'total_vaccinations',
                      'total_vaccinations_per_hundred', 'new_people_vaccinated_smoothed', 'new_people_vaccinated_smoothed_per_hundred', 'excess_mortality',
                      'excess_mortality_cumulative', 'excess_mortality_cumulative_absolute', 'excess_mortality_cumulative_per_million', 'reproduction_rate',
                      'stringency_index']   



# MODE OF EACH FEATURE:
counter = 0
for feature in numerical_features:
    counter += 1
    print(f'\n\n# {counter}) {feature} - Mode: '.title())
    print(f'''SET @index = 0;
WITH
Mode_table AS
(SELECT location, 
	COUNT({feature}) AS count_of_distinct_{feature}, 
        {feature},
        ROW_NUMBER() OVER (PARTITION BY location ORDER BY COUNT({feature}) DESC) AS row_num
FROM working_dataset
GROUP BY location, {feature}
ORDER BY location ASC, COUNT({feature}) DESC)
SELECT (@index := @index + 1) AS location_index, location, count_of_distinct_{feature} AS mode_frequency, {feature} AS {feature}_mode
FROM Mode_table
WHERE row_num = 1;
''')


print('\n\n\n------------------------------\n\n\n')


# EDA OF EACH FEATURE:
counter = 0
for feature in numerical_features:
    counter += 1
    print(f'# {counter}) {feature} - Descriptive Statistics: '.title())
    print(f'''
SET @index = 0;
  
WITH

OG_table AS
(SELECT location, {feature} FROM working_dataset),

Median_table AS
(SELECT location_1, middle_values, row_num, total_count 
FROM (SELECT location AS location_1,
	     {feature} AS middle_values,
	     ROW_NUMBER() OVER (PARTITION BY location ORDER BY {feature}) AS row_num,
	     COUNT(*) OVER (PARTITION BY location) AS total_count
      FROM working_dataset
      WHERE {feature} IS NOT NULL) AS subquery
WHERE row_num IN (FLOOR((total_count + 1) / 2), CEIL((total_count + 1) / 2))),

Mode_table AS
(SELECT location AS location_2, COUNT({feature}) AS count_of_distinct_{feature}, {feature} AS {feature}_2 FROM working_dataset
GROUP BY location, {feature}
ORDER BY location ASC, COUNT({feature}) DESC)

SELECT (@index := @index + 1) AS location_index, OG_table.location, 
       ROUND((SUM(CASE WHEN OG_table.{feature} IS NOT NULL THEN 1 ELSE 0 END) / COUNT(*)), 2) * 100 AS feature_completeness_percent, 
       SUM(CASE WHEN OG_table.{feature} IS NOT NULL THEN 1 ELSE 0 END) AS number_of_values, 
       SUM(CASE WHEN OG_table.{feature} IS NULL THEN 1 ELSE 0 END) AS number_of_empty_fields, 
       COUNT(*) AS number_of_records, 
       AVG(OG_table.{feature}) AS mean,
       AVG(Median_table.middle_values) AS median,
       MAX(Mode_table.count_of_distinct_{feature}) AS _mode_,
       MAX(OG_table.{feature}) AS max,
       MIN(OG_table.{feature}) AS min,
       MAX(OG_table.{feature}) - MIN(OG_table.{feature}) AS _range_
       
FROM OG_table INNER JOIN Mode_table
ON OG_table.location = Mode_table.location_2

LEFT JOIN Median_table
ON Mode_table.location_2 = Median_table.location_1

GROUP BY location;
''')




