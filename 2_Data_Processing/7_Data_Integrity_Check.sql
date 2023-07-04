-- Max Character Length Fields in Numerically Discrete & Continuous Features:
SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) AS max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);

-- Number of Max Length Fields in Numerical Feature:
SELECT COUNT(DISTINCT(CONCAT(new_cases_smoothed, '; ', LENGTH(new_cases_smoothed), '; ', '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')'))) AS count_max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset);

-- need no. of digits after decimal, total digits, check if any -ve values with T or F value for UNSIGNED (only +ves) vs. SIGNED choice


-- A) Max Character Length Fields in Numerically Discrete & Continuous Features-- COUNTING digits after DECIMAL POINT:
SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', 
					   LENGTH(new_cases_smoothed), '; ', 
                       '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , 
                       ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) 
                       AS max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset) OR
LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) = (SELECT MAX(LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))) FROM master_dataset);

-- COUNT of A):
SELECT COUNT(DISTINCT(CONCAT(new_cases_smoothed, '; ', 
					   LENGTH(new_cases_smoothed), '; ', 
                       '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , 
                       ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')'))) 
                       AS max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) = (SELECT MAX(LENGTH(new_cases_smoothed)) FROM master_dataset) OR
LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) = (SELECT MAX(LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))) FROM master_dataset);



-- b) Max Character Length Fields in Numerically Discrete & Continuous Features-- COUNTING ONLY digits after DECIMAL POINT BUT LESS THAN TOTAL NO. OF DIGITS:
SELECT DISTINCT(CONCAT(new_cases_smoothed, '; ', 
					   LENGTH(new_cases_smoothed), '; ', 
                       '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , 
                       ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')')) 
                       AS max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) < 11 AND LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) = (SELECT MAX(LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))) FROM master_dataset);

-- COUNT of b):
SELECT COUNT(DISTINCT(CONCAT(new_cases_smoothed, '; ', 
					   LENGTH(new_cases_smoothed), '; ', 
                       '(', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', 1)) , 
                       ', ', LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)), ')'))) 
                       AS max_len_iso_code FROM master_dataset
WHERE LENGTH(new_cases_smoothed) < 11 AND LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) = (SELECT MAX(LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))) FROM master_dataset);

