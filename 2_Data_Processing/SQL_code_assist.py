features = ('iso_code',
            'continent',
            'location',
            'date_',
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
            
temporal_features = ['date_']

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

numerical_discrete_features = ['population', 'total_cases', 'new_cases', 'total_tests', 'new_tests', 'total_deaths', 'new_deaths', 'icu_patients', 'hosp_patients',
                               'weekly_icu_admissions', 'weekly_hosp_admissions', 'total_vaccinations', 'people_vaccinated', 'people_fully_vaccinated', 'total_boosters',
                               'new_vaccinations', 'new_vaccinations_smoothed', 'new_vaccinations_smoothed_per_million', 'new_people_vaccinated_smoothed']

numerical_continuous_features = ['new_cases_smoothed', 'new_deaths_smoothed', 'total_cases_per_million', 'new_cases_per_million', 'new_cases_smoothed_per_million',
                                 'total_deaths_per_million', 'new_deaths_per_million', 'new_deaths_smoothed_per_million', 'reproduction_rate', 'icu_patients_per_million',
                                 'hosp_patients_per_million', 'weekly_icu_admissions_per_million', 'weekly_hosp_admissions_per_million', 'total_tests_per_thousand',
                                 'new_tests_per_thousand', 'new_tests_smoothed', 'new_tests_smoothed_per_thousand', 'positive_rate', 'tests_per_case', 'total_vaccinations_per_hundred',
                                 'people_vaccinated_per_hundred', 'people_fully_vaccinated_per_hundred', 'total_boosters_per_hundred', 'new_people_vaccinated_smoothed_per_hundred',
                                 'stringency_index', 'population_density', 'median_age', 'aged_65_older', 'aged_70_older', 'gdp_per_capita', 'extreme_poverty', 'cardiovasc_death_rate',
                                 'diabetes_prevalence', 'female_smokers', 'male_smokers', 'handwashing_facilities', 'hospital_beds_per_thousand', 'life_expectancy', 'human_development_index',
                                 'excess_mortality_cumulative_absolute', 'excess_mortality_cumulative', 'excess_mortality', 'excess_mortality_cumulative_per_million']

print('numerical_features:', len(set(numerical_features)))

print('numerical_discrete_features:', len(set(numerical_discrete_features)))

print('numerical_continuous_features:', len(set(numerical_continuous_features)))

print('addition_of_both_numerical_features:', len(set(numerical_discrete_features)) + len(set(numerical_continuous_features)))









'''

print('\n\n')


for feature in categorical_features:
    print(f'SELECT DISTINCT(CONCAT({feature}, \'; \', LENGTH({feature}))) AS max_len_{feature} FROM master_dataset\nWHERE LENGTH({feature}) = (SELECT MAX(LENGTH({feature})) FROM master_dataset);')
    print('\n')
    pass

'SELECT DISTINCT(CONCAT({feature}, \'; \', LENGTH({feature}))) AS max_len_iso_code FROM master_dataset\
WHERE LENGTH({feature}) = (SELECT MAX(LENGTH({feature})) FROM master_dataset);'
print('\n\n')

for feature in numerical_features:
    print(f'SELECT DISTINCT(CONCAT({feature}, \'; \', LENGTH({feature}), \'; \', \'(\', LENGTH(SUBSTRING_INDEX({feature}, \'.\', 1)) , \', \', LENGTH(SUBSTRING_INDEX({feature}, \'.\', -1)), \')\')) AS max_len_{feature} FROM master_dataset\nWHERE LENGTH({feature}) = (SELECT MAX(LENGTH({feature})) FROM master_dataset);')
    print('\n')
    pass


# SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) AS max_len_iso_code FROM master_dataset
# WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);


'''




























