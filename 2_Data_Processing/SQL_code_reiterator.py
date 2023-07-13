features = ('iso_code',
            'continent',
            'location',
            '_date_',
            'total_cases',
            'new_cases',
            'new_cases_smoothed',
            'total_deaths',
            'new_deaths',
            'new_deaths_smoothed',
            'total_cases_per_million',
            'new_cases_per_million',
            'new_cases_smoothed_per_million',
            'total_deaths_per_million',
            'new_deaths_per_million',
            'new_deaths_smoothed_per_million',
            'reproduction_rate',
            'icu_patients',
            'icu_patients_per_million',
            'hosp_patients',
            'hosp_patients_per_million',
            'weekly_icu_admissions',
            'weekly_icu_admissions_per_million',
            'weekly_hosp_admissions',
            'weekly_hosp_admissions_per_million',
            'total_tests',
            'new_tests',
            'total_tests_per_thousand',
            'new_tests_per_thousand',
            'new_tests_smoothed',
            'new_tests_smoothed_per_thousand',
            'positive_rate',
            'tests_per_case',
            'tests_units',
            'total_vaccinations',
            'people_vaccinated',
            'people_fully_vaccinated',
            'total_boosters',
            'new_vaccinations',
            'new_vaccinations_smoothed',
            'total_vaccinations_per_hundred',
            'people_vaccinated_per_hundred',
            'people_fully_vaccinated_per_hundred',
            'total_boosters_per_hundred',
            'new_vaccinations_smoothed_per_million',
            'new_people_vaccinated_smoothed',
            'new_people_vaccinated_smoothed_per_hundred',
            'stringency_index',
            'population_density',
            'median_age',
            'aged_65_older',
            'aged_70_older',
            'gdp_per_capita',
            'extreme_poverty',
            'cardiovasc_death_rate',
            'diabetes_prevalence',
            'female_smokers',
            'male_smokers',
            'handwashing_facilities',
            'hospital_beds_per_thousand',
            'life_expectancy',
            'human_development_index',
            'population',
            'excess_mortality_cumulative_absolute',
            'excess_mortality_cumulative',
            'excess_mortality',
            'excess_mortality_cumulative_per_million')

# Confirms all 67 Features are in the list.
#print(len(features))
print('\n')



# Returns SQL query for total number of NULLS in each Column:
for feature in features:
    # print(f'    COUNT(CASE WHEN {feature} = \'\' THEN 1 END) AS {feature}_NULLS,')
    pass





nulls_per_feature = [0, 14234, 0, 0, 35883, 8633, 9897, 56008, 8551, 9781, 35883, 8633, 9897, 56008, 8551, 9781,
                     114420, 264641, 264641, 264294, 264294, 290215, 290215, 278071, 278071, 219850, 223834, 219850,
                     223834, 195272, 195272, 203310, 204889, 192449, 226096, 229211, 231491, 257285, 239042, 137082,
                     226096, 229211, 231491, 257285, 137082, 137032, 137032, 106043, 45346, 63093, 71350, 65462, 67812,
                     150181, 67408, 55584, 125314, 127684, 185723, 94581, 24087, 74506, 0, 288942, 288942, 288942, 288942]

#print(len(nulls_per_feature))

# Returns calculation for total number of NULLS
sql_add = ''
for null in nulls_per_feature:
    sql_add = sql_add + ' + ' + str(null)
#print(sql_add)








categorical_features = ['iso_code', 'continent', 'location', 'tests_units']
            
temporal_features = ['_date_']

numerical_features = ['total_cases', 'new_cases', 'new_cases_smoothed', 'total_deaths', 'new_deaths', 'new_deaths_smoothed', 'total_cases_per_million',
                      'new_cases_per_million', 'new_cases_smoothed_per_million', 'total_deaths_per_million', 'new_deaths_per_million',
                      'new_deaths_smoothed_per_million', 'reproduction_rate', 'icu_patients', 'icu_patients_per_million', 'hosp_patients',
                      'hosp_patients_per_million', 'weekly_icu_admissions', 'weekly_icu_admissions_per_million', 'weekly_hosp_admissions',
                      'weekly_hosp_admissions_per_million', 'total_tests', 'new_tests', 'total_tests_per_thousand', 'new_tests_per_thousand', 'new_tests_smoothed',
                      'new_tests_smoothed_per_thousand', 'positive_rate', 'tests_per_case', 'total_vaccinations', 'people_vaccinated', 'people_fully_vaccinated',
                      'total_boosters', 'new_vaccinations', 'new_vaccinations_smoothed', 'total_vaccinations_per_hundred', 'people_vaccinated_per_hundred',
                      'people_fully_vaccinated_per_hundred', 'total_boosters_per_hundred', 'new_vaccinations_smoothed_per_million', 'new_people_vaccinated_smoothed',
                      'new_people_vaccinated_smoothed_per_hundred', 'stringency_index', 'population_density', 'median_age', 'aged_65_older', 'aged_70_older',
                      'gdp_per_capita', 'extreme_poverty', 'cardiovasc_death_rate', 'diabetes_prevalence', 'female_smokers', 'male_smokers',
                      'handwashing_facilities', 'hospital_beds_per_thousand', 'life_expectancy', 'human_development_index', 'population',
                      'excess_mortality_cumulative_absolute', 'excess_mortality_cumulative', 'excess_mortality', 'excess_mortality_cumulative_per_million']

numerical_discrete_features = ['population', 'total_cases', 'new_cases', 'total_tests', 'new_tests', 'new_tests_smoothed', 'total_deaths', 'new_deaths', 'icu_patients', 'hosp_patients',
                               'weekly_icu_admissions', 'weekly_hosp_admissions', 'total_vaccinations', 'people_vaccinated', 'people_fully_vaccinated', 'total_boosters',
                               'new_vaccinations', 'new_vaccinations_smoothed', 'new_vaccinations_smoothed_per_million', 'new_people_vaccinated_smoothed']

numerical_continuous_features = ['new_cases_smoothed', 'new_deaths_smoothed', 'total_cases_per_million', 'new_cases_per_million', 'new_cases_smoothed_per_million',
                                 'total_deaths_per_million', 'new_deaths_per_million', 'new_deaths_smoothed_per_million', 'reproduction_rate', 'icu_patients_per_million',
                                 'hosp_patients_per_million', 'weekly_icu_admissions_per_million', 'weekly_hosp_admissions_per_million', 'total_tests_per_thousand',
                                 'new_tests_per_thousand', 'new_tests_smoothed_per_thousand', 'positive_rate', 'tests_per_case', 'total_vaccinations_per_hundred',
                                 'people_vaccinated_per_hundred', 'people_fully_vaccinated_per_hundred', 'total_boosters_per_hundred', 'new_people_vaccinated_smoothed_per_hundred',
                                 'stringency_index', 'population_density', 'median_age', 'aged_65_older', 'aged_70_older', 'gdp_per_capita', 'extreme_poverty', 'cardiovasc_death_rate',
                                 'diabetes_prevalence', 'female_smokers', 'male_smokers', 'handwashing_facilities', 'hospital_beds_per_thousand', 'life_expectancy', 'human_development_index',
                                 'excess_mortality_cumulative_absolute', 'excess_mortality_cumulative', 'excess_mortality', 'excess_mortality_cumulative_per_million']


print('numerical_features:', len(set(numerical_features)))

print('numerical_discrete_features:', len(set(numerical_discrete_features)))

print('numerical_continuous_features:', len(set(numerical_continuous_features)))

print('addition_of_both_numerical_features:', len(set(numerical_discrete_features)) + len(set(numerical_continuous_features)))





# MAX Lengths for Data-type Parameters:

print('\n1. Categorical Features - MAX Length:\n')
for feature in categorical_features:
    
    print(f'''
SELECT DISTINCT({feature}) AS max_len_{feature},
       LENGTH({feature}) AS len
FROM data_load
WHERE LENGTH({feature}) = (SELECT MAX(LENGTH({feature})) FROM data_load);
''')
    
    print('\n')
    pass



print('\n\n\n\n\n')



print('2. Numerically Discrete Features - MAX Length:\n')
for feature in numerical_discrete_features:

    print(f'''
SELECT DISTINCT({feature}) AS max_len_num_{feature},
	        CASE
		    WHEN {feature} LIKE "%.%" THEN
                    (CASE WHEN CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
                    ELSE "True" END AS whole_number,
                    
		CASE
		    WHEN {feature} LIKE '-%' THEN 
                    (CASE
			WHEN {feature} LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) - 1) END) 
			ELSE (LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN {feature} LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN {feature} LIKE '-%' THEN 
                       (CASE
                           WHEN {feature} LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) - 1) END) 
                           ELSE (LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
                       (CASE 
                           WHEN {feature} LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) END)
                           ELSE LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT)) END)
	  
                   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX({feature}, '.', 1) AS SIGNED INT))) 
		       FROM data_load 
                       WHERE {feature} NOT LIKE '-%')

           ORDER BY whole_number ASC;
           ''')
    
    print('\n')
    pass

print('\n\n\n\n\n')



print('3. Numerically Continuous Features - MAX Length:\n')

print('A) Precision - MAX Length:\n')
for feature in numerical_continuous_features:

    print(f'''
SELECT DISTINCT({feature}) AS max_len_num_{feature}, 
       LENGTH({feature}) AS total_char_len,
       CASE 
           WHEN {feature} LIKE "%.%" THEN 
	   (CASE WHEN CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
	   ELSE "False" END AS decimal_number,

       CASE
           WHEN {feature} LIKE "-%.%" THEN (LENGTH({feature}) - 2) 
           WHEN {feature} LIKE "-%" THEN (LENGTH({feature}) - 1)
           WHEN {feature} LIKE "%.%" THEN (LENGTH({feature}) - 1) 
	   ELSE LENGTH({feature}) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN {feature} LIKE "-%.%" THEN (LENGTH({feature}) - 2) 
	   WHEN {feature} LIKE "-%" THEN (LENGTH({feature}) - 1)
	   WHEN {feature} LIKE "%.%" THEN (LENGTH({feature}) - 1) 
	   ELSE LENGTH({feature}) 
	  
      END = (SELECT MAX(CASE WHEN {feature} LIKE "-%.%" THEN (LENGTH({feature}) - 2) 
			     WHEN {feature} LIKE "-%" THEN (LENGTH({feature}) - 1)
		             WHEN {feature} LIKE "%.%" THEN (LENGTH({feature}) - 1) 
		             ELSE LENGTH({feature}) END)
	     FROM data_load)
         
ORDER BY decimal_number ASC;
''')

print('\n\n')

print('B) Scale - MAX Length:\n')
for feature in numerical_continuous_features:
    print(f'''
SELECT DISTINCT({feature}) AS max_len_num_{feature}, 
       CASE 
           WHEN {feature} LIKE "%.%" THEN 
	   (CASE WHEN CAST(SUBSTRING_INDEX({feature}, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
	   ELSE "False" END AS decimal_number,
                    
       CASE WHEN {feature} NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX({feature}, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN {feature} NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX({feature}, '.', -1))

      END = (SELECT MAX(CASE WHEN {feature} NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX({feature}, '.', -1)) END)
	     FROM data_load)

ORDER BY decimal_number ASC;
''')





# Data-type Assignment:

'''
categorical_features
temporal_features
numerical_discrete_features
numerical_continuous_features
'''


print('ALL FEATURES:\n')
for feature in categorical_features:
    print(feature)
print('\n')
for feature in temporal_features:
    print(feature)
print('\n')
for feature in numerical_discrete_features:
    print(feature)
print('\n')
for feature in numerical_continuous_features:
    print(feature)
print('\n\n\n')



categorical_datatype_assignment = [('iso_code', 'CHAR(10)'),
                                   ('continent', 'CHAR(20)'),
                                   ('location', 'CHAR(40)'),
                                   ('tests_units', 'CHAR(20)')]

for assignment in categorical_datatype_assignment:
    print(f'''
SELECT {assignment[0]}, CAST({assignment[0]} AS {assignment[1]}) AS casted_{assignment[0]},
CASE WHEN {assignment[0]} = CAST({assignment[0]} AS {assignment[1]}) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;
''')

print('\n\n\n')



for feature in numerical_discrete_features:
    print(f'''
SELECT {feature}, CAST({feature} AS UNSIGNED INT) AS casted_{feature},
CASE WHEN {feature} = CAST({feature} AS UNSIGNED INT) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;
''')

print('\n\n\n')

continuous_datatype_assignment = [('new_cases_smoothed', 'DECIMAL(20, 3)'),
                                  ('new_deaths_smoothed', 'DECIMAL(20, 3)'),
                                  ('total_cases_per_million', 'DECIMAL(20, 3)'),
                                  ('new_cases_per_million', 'DECIMAL(20, 3)'),
                                  ('new_cases_smoothed_per_million', 'DECIMAL(20, 3)'),
                                  ('total_deaths_per_million', 'DECIMAL(10, 3)'),
                                  ('new_deaths_per_million', 'DECIMAL(10, 3)'),
                                  ('new_deaths_smoothed_per_million', 'DECIMAL(10, 3)'),
                                  ('reproduction_rate', 'DECIMAL(10, 2)'),
                                  ('icu_patients_per_million', 'DECIMAL(10, 3)'),
                                  ('hosp_patients_per_million', 'DECIMAL(10, 3)'),
                                  ('weekly_icu_admissions_per_million', 'DECIMAL(10, 3)'),
                                  ('weekly_hosp_admissions_per_million', 'DECIMAL(10, 3)'),
                                  ('total_tests_per_thousand', 'DECIMAL(20, 3)'),
                                  ('new_tests_per_thousand', 'DECIMAL(10, 3)'),
                                  ('new_tests_smoothed_per_thousand', 'DECIMAL(10, 3)'),
                                  ('positive_rate', 'DECIMAL(10, 4)'),
                                  ('tests_per_case', 'DECIMAL(10, 1)'),
                                  ('total_vaccinations_per_hundred', 'DECIMAL(10, 2)'),
                                  ('people_vaccinated_per_hundred', 'DECIMAL(10, 2)'),
                                  ('people_fully_vaccinated_per_hundred', 'DECIMAL(10, 2)'),
                                  ('total_boosters_per_hundred', 'DECIMAL(10, 2)'),
                                  ('new_people_vaccinated_smoothed_per_hundred', 'DECIMAL(10, 3)'),
                                  ('stringency_index', 'DECIMAL(10, 2)'),
                                  ('population_density', 'DECIMAL(20, 3)'),
                                  ('median_age', 'DECIMAL(10, 1)'),
                                  ('aged_65_older', 'DECIMAL(10, 3)'),
                                  ('aged_70_older', 'DECIMAL(10, 3)'),
                                  ('gdp_per_capita', 'DECIMAL(20, 3)'),
                                  ('extreme_poverty', 'DECIMAL(10, 1)'),
                                  ('cardiovasc_death_rate', 'DECIMAL(10, 3)'),
                                  ('diabetes_prevalence', 'DECIMAL(10, 2)'),
                                  ('female_smokers', 'DECIMAL(10, 3)'),
                                  ('male_smokers', 'DECIMAL(10, 3)'),
                                  ('handwashing_facilities', 'DECIMAL(10, 3)'),
                                  ('hospital_beds_per_thousand', 'DECIMAL(10, 3)'),
                                  ('life_expectancy', 'DECIMAL(10, 2)'),
                                  ('human_development_index', 'DECIMAL(10, 3)'),
                                  ('excess_mortality_cumulative_absolute', 'DECIMAL(20, 8)'),
                                  ('excess_mortality_cumulative', 'DECIMAL(10, 2)'),
                                  ('excess_mortality', 'DECIMAL(10, 2)'),
                                  ('excess_mortality_cumulative_per_million', 'DECIMAL(20, 8)')]

for assignment in continuous_datatype_assignment:
    print(f'''
SELECT {assignment[0]}, CAST({assignment[0]} AS {assignment[1]}) AS casted_{assignment[0]},
CASE WHEN {assignment[0]} = CAST({assignment[0]} AS {assignment[1]}) THEN "True" ELSE "False" END AS T_or_F
FROM data_load
ORDER BY T_or_F ASC;
''')





