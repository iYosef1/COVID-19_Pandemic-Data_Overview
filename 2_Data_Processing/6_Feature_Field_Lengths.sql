/* Data-type Conversion - Appropriate MAX Character Length per Feature for Data-type Parameter(s):

The following queries are geared towards returning the field within a feature that has the MAX character length and the respective MAX length in itself.
Depending on the data-type, the MAX character length will be appropriately determined for the specific parameters in use.

Categorical features will return the string output: field_value; MAX_length

Numerically discrete features will return the string output: field_value; MAX_length_whole_digits (exclude decimal and trailing zeroes, if present)

Numerically continuous features will return the string output: a) field_value; MAX_length_all_digits (exclude decimal)
															   b) field_value; MAX_length_decimal_digits_only (exclude decimal)

*/



-- Candidate Data-types for Features:

-- REMINDER: With CHAR data-types, each character takes up a specific number of bytes, usually 3-4 bytes but ultimately depends on the encoding. 
-- For instance, the string "hello" has 5 characters and if each character is 3 bytes, then the total number of bytes will be 15 bytes.
-- The total number of bytes permitted in MySQL within a single column ONLY or within an ENTIRE row of a table is 65,535 bytes.
-- The number of columns, character length, and character byte-size will be have to be allocated according to the 65,535 bytes limit.

-- TEXT data-types: Also referred to as CLOBs (Character Large Objects).
				 -- Unlike VARCHAR, these data-types are not limited by the max row size of 65,535 bytes since the data is stored elsewhere in the backend by MySQL. 
	             -- This data-types is useful for storing preferred columns when VARCHAR has reached its limit of 65,535 bytes.
                 -- This data-type does not allow for any default but NULL when you insert data into a column.

/* CHAR Data-type

The size parameter is the upper limit representing the number of characters allowed in a string. This limit is 255 characters (NOT bytes).
The CHAR data-type is ideal when every string in a column has the same length. 
However, if the character length of a string is less than its argument, there will be a padding of additional empty spaces to reach the argument value.

*/

/* VARCHAR Data-type

This data-type is useful when the character length of each string in a column varies. 
The size parameter is the upper limit representing the number of characters allowed in a string. This limit is 65,535 bytes (NOT characters).
Unlike the CHAR data-type, if the character length of a string is less than its argument, there will be NO padding of additional empty spaces.
However, the caveat is that MySQL will add an additional byte or 2 to each string as it has to keep track of the different lengths of all the different strings in the column.

*/

/* DECIMAL Data-type

This data-type is has 2 parameters, precision and scale. Precision is the total number of digits in the numeric value and scale is the total number of digits after the decimal place.
This data-type may also be referred to as DEC, NUMERIC, and FIXED. This data-type is ideal for precision, e.g., in MATH or if you were working with money.
In contrast, the FLOAT or DOUBLE data-type are both ideal for estimation as their precision is lower.

*/

/* DOUBLE Data-type

This data-type is a floating-point data-type that is used to store estimated values. It is not ideal to use for precision or when making calculations.
It is ideal when exact values are not required since this data-type stores in the format of scientific notation.
For example, -150 would be stored as -1.5 x 10^2; -1.5 is the coefficient, 10 is the base, and 2 is the exponent.
If the exponent is negative, the expanded form is a +/- rational or irrational number. If the exponent is positive, it will be an integer.
In relative terms, the more number of digits that are EXCLUSIVELY trailing zeroes (refer to significant figures) in the expanded form, then the more that number's precision will be assured.
DOUBLE can maintain a higher level of precision than FLOAT (data-type listed below).

*/

/* FLOAT Data-type

FLOAT is identical to the DOUBLE data-type but will maintain a lower level of precision than DOUBLE. It can also return unusual results when doing calculations. 
The DOUBLE data-type is always more preferable even though it can also return unusual results when doing calculations.

*/

/* INT Data-type

This data-type is used for exact numbers, i.e., it will never loose precision, even when doing calculations. 
The UNSIGNED or SIGNED constraint will allow the values to be respectively either exclusively positive OR to be positive and negative.
The argument passed into any INT data-type is referred to as the display width. It is the number of characters available that makes up the width of a number.
For example, when data is stored within INT(5), the the number 49 would be stored as 00049 and the number 150 would be stored as 00150.
It does not dynamically store the number of digits or characters as VARCHAR does. It is more similar to the CHAR data-type but is padded with leading 0s.
The ZEROFILL keyword will unhide the hidden 0s when a field value is less than 5 characters long. The actual size of the column can only be altered via TINYINT, MEDIUMINT, and so forth. 
Note: MySQL 8.0.32 no longer supports a size parameter for the INT data-types. 

*/

/* DATE Data-type

This data-type has its own convention for dates in MySQL; YYYY-MM-DD, e.g., '2022-07-22'.

*/



-- Building Query for Categorical Features:

-- Sample feature being used: iso_code

-- Returns the MAX character length in iso_code feature:
SELECT MAX(LENGTH(iso_code)) AS max_len_of_iso_code FROM data_load;

-- Returns ALL fields in iso_code feature with MAX character length (including duplicates):
SELECT iso_code AS ALL_iso_codes_with_max_len FROM data_load
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM data_load);

-- Returns all distinct fields in iso_code feature with MAX character length, plus the length in itself:
SELECT DISTINCT(iso_code) AS max_len_iso_code, 
	   LENGTH(iso_code) AS len 
FROM data_load
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM data_load);



-- Building Query for Numerically Discrete Features - INT Data-type:

-- Sample feature being used: new_cases
-- Query Objective: Provides the MAX count of the number of whole-number digits from a list of whole numbers for the INT data-types' parameter. 

-- Returns the MAX character length in new_cases feature:
SELECT DISTINCT(new_cases) AS max_len_new_cases, LENGTH(new_cases) AS total_char_len FROM data_load
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM data_load);

-- Confirms if field in new_cases feature is a whole number and returns character length of whole digits:
SELECT DISTINCT(new_cases) AS max_len_new_cases, 
			   LENGTH(new_cases) AS total_char_len, 
			   SUBSTRING_INDEX(new_cases, '.', -1) AS decimal_digits, 
			   CASE WHEN CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS UNSIGNED INT) > 0 THEN "False" ELSE "True" END AS whole_number, 
			   CASE
				   WHEN new_cases LIKE '%.%' THEN (CASE WHEN new_cases LIKE '%.0' THEN LENGTH(SUBSTRING_INDEX(new_cases, '.', 1)) END) 
				   ELSE LENGTH(new_cases) 
				   END AS MAX_length_whole_digits
FROM data_load
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM data_load);    
-- Varying Cases for Consideration - A reusable query with flexibility is always ideal:
-- A value can have more than 1 trailing zero after the decimal pt.
-- A value may not have decimal point.
-- A feature of discrete numerical values can be negative as well as positive. 
-- A feature supposedly of discrete numerical values only may in error consist of decimal values as well. 


-- The subsequent 2 queries below serve as test data with arbitrary but intentional values for comfirming success in varying case scenarios for the appropriate digit-counts for numerical data-types:

CREATE TABLE feature_len_query_testing_table (
	category_col_check VARCHAR(100),
    num_discrete_col_check VARCHAR(100),
    num_continuous_col_check VARCHAR(100)
    );
    
INSERT INTO feature_len_query_testing_table (category_col_check, num_discrete_col_check, num_continuous_col_check)
VALUES -- Values are added in the form of records:
('abc', '324', '324'),
('def0', '2.02', '0.0021'),
('ghi123', '7.0', '7.0'),
('jkl45', '767.006', '767.006'),
('mn', '13', '0000.103'),
('opqr6789', '254.0000', '254.0000'), --
('s', '843.42003', '843.42003'),
('tuvwxyz', '0043.9003', '003.42003'),
('abc', '-324', '-324'),
('def0', '-2.02', '-0.0021'),
('ghi123', '-7.0', '-7.0'),
('jkl45', '-767.006', '-767.006'),
('mn', '-13', '-0000.103'),
('opqr6789', '-254.0000', '-254.0000'), --
('s', '-843.42003', '-843.42003'),
('tuvwxyz', '-0043.9003', '-003.42003');

SELECT * FROM feature_len_query_testing_table;

-- DROP TABLE feature_len_query_testing_table; -- The feature_len_query_testing_table can be discarded.

-- Confirms if varying fields are whole numbers and returns character length of whole digits in field:
SELECT DISTINCT(num_discrete_col_check) AS max_len_num_discrete, 
				LENGTH(num_discrete_col_check) AS total_char_len, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS whole_digits,
				CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT) AS whole_digits_casted, 
                LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) AS char_length_leftside_of_decimal, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS decimal_digits, 
				CASE WHEN CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END AS whole_number, 
				CASE
					WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) END)
					ELSE LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT))
					END AS MAX_length_whole_number
FROM feature_len_query_testing_table
WHERE LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT))) FROM feature_len_query_testing_table);
-- Query Issues:
-- The count also includes the negative sign in front of negative numbers.
-- Whole numbers without a decimal point and trailing zero(es), return the whole number digits in the decimal_digits field.


-- Query Completed Below!
-- The following query returns all field entries with the MAX number of whole digits, along with the character length itself from a feature exclusively of whole numbers, inclusive of whole numbers with a decimal point and trailing 0s. 
-- If the values in the column consist of a decimal, there must be a numerical character before and after the decimal point. 
-- This query is reusable for any numerically discrete feature to determine the size parameter necessary for the INT data-type to be used for data conversion. 
SELECT DISTINCT(num_discrete_col_check) AS max_len_num_discrete, 
				LENGTH(num_discrete_col_check) AS total_char_len, 
				SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS whole_digits,
				CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT) AS whole_digits_casted, 
                LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) AS char_length_leftside_of_decimal, 
				CASE WHEN num_discrete_col_check NOT LIKE "%.%" THEN "N/A" ELSE SUBSTRING_INDEX(num_discrete_col_check, '.', -1) END AS decimal_digits, 
                
				CASE 
					WHEN num_discrete_col_check LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
                    ELSE "True" END AS whole_number,
                    
				CASE
					WHEN num_discrete_col_check LIKE '-%' THEN 
                    (CASE 
						WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE 
						WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
FROM feature_len_query_testing_table

WHERE CASE	
		WHEN num_discrete_col_check LIKE '-%' THEN 
			(CASE 
				WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) - 1) END) 
				ELSE (LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) - 1) END)
					
		ELSE 
			(CASE 
				WHEN num_discrete_col_check LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) END)
				ELSE LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT)) END)
	  
      END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(num_discrete_col_check, '.', 1) AS SIGNED INT))) 
			 FROM feature_len_query_testing_table 
             WHERE num_discrete_col_check NOT LIKE '-%')
         
ORDER BY max_len_num_discrete; 
-- Note: Whole numbers in string format will still be sorted correctly in ASC or DESC numerical order by whole digits first, then decimal digits, if they have the same number of digits. 
 
 
-- Finalizing Completed Query: 
-- Sample feature being used: new_cases    
SELECT DISTINCT(new_cases) AS max_len_num_discrete, 
				CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT) AS whole_digits_casted, 
				CASE WHEN new_cases NOT LIKE "%.%" THEN "N/A" ELSE SUBSTRING_INDEX(new_cases, '.', -1) END AS decimal_digits, 
                
				CASE 
					WHEN new_cases LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
                    ELSE "True" END AS whole_number,
                    
				CASE
					WHEN new_cases LIKE '-%' THEN 
                    (CASE 
						WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE 
						WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
FROM data_load

WHERE CASE	
		WHEN new_cases LIKE '-%' THEN 
			(CASE 
				WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END) 
				ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
		ELSE 
			(CASE 
				WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
				ELSE LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
	  
      END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT))) 
			 FROM data_load 
             WHERE new_cases NOT LIKE '-%')

ORDER BY whole_number ASC; 
-- Ordering whole_number in ASC order will reveal any "False" values at the top of the list.



-- Building Query for Numerically Continuous Features - DECIMAL Data-type:

-- Query Objective: a) Provides the MAX count of the total number of digits from a list of numbers for the precision parameter of the DECIMAL data-type.
				 -- b) Provides the MAX count exclusively of the number of decimal digits from a list of numbers for the scale parameter of the DECIMAL data-type. 
                 
-- Testing the following query for a):
SELECT DISTINCT(num_continuous_col_check) AS max_len_num_continuous, 
				CAST(num_continuous_col_check AS DECIMAL(10, 5)) AS decimal_number_casted, -- Note that DECIMAL data-type does not require UNSIGNED or SIGNED keyword.
				LENGTH(num_continuous_col_check) AS total_char_len,
                
				CASE WHEN num_continuous_col_check LIKE "-%.%" THEN (LENGTH(num_continuous_col_check) - 2) 
					 WHEN num_continuous_col_check LIKE "-%" THEN (LENGTH(num_continuous_col_check) - 1)
                     WHEN num_continuous_col_check LIKE "%.%" THEN (LENGTH(num_continuous_col_check) - 1) 
                     ELSE LENGTH(num_continuous_col_check) END AS total_digit_len, 
                     
				CASE 
					WHEN num_continuous_col_check LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(num_continuous_col_check, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
                    ELSE "False" END AS decimal_number

FROM feature_len_query_testing_table

WHERE CASE WHEN num_continuous_col_check LIKE "-%.%" THEN (LENGTH(num_continuous_col_check) - 2) 
		   WHEN num_continuous_col_check LIKE "-%" THEN (LENGTH(num_continuous_col_check) - 1)
		   WHEN num_continuous_col_check LIKE "%.%" THEN (LENGTH(num_continuous_col_check) - 1) 
		   ELSE LENGTH(num_continuous_col_check) 
	  
      END = (SELECT MAX(CASE WHEN num_continuous_col_check LIKE "-%.%" THEN (LENGTH(num_continuous_col_check) - 2) 
					         WHEN num_continuous_col_check LIKE "-%" THEN (LENGTH(num_continuous_col_check) - 1)
		                     WHEN num_continuous_col_check LIKE "%.%" THEN (LENGTH(num_continuous_col_check) - 1) 
		                     ELSE LENGTH(num_continuous_col_check) END)
			 FROM feature_len_query_testing_table)
         
ORDER BY decimal_number ASC; -- Query is ordered in ASC by decimal_number to reveal any False fields in the list at the top.


-- Testing the following query for b):
SELECT DISTINCT(num_continuous_col_check) AS max_len_num_continuous, 

				CASE WHEN num_continuous_col_check NOT LIKE "%.%" THEN "N/A" ELSE SUBSTRING_INDEX(num_continuous_col_check, '.', -1) END AS decimal_digits, 
                CASE WHEN num_continuous_col_check NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(num_continuous_col_check, '.', -1)) END AS decimal_digits_len, 
                
				CASE 
					WHEN num_continuous_col_check LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(num_continuous_col_check, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
                    ELSE "False" END AS decimal_number

FROM feature_len_query_testing_table
    
WHERE CASE WHEN num_continuous_col_check NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(num_continuous_col_check, '.', -1))

      END = (SELECT MAX(CASE WHEN num_continuous_col_check NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(num_continuous_col_check, '.', -1)) END)
			 FROM feature_len_query_testing_table)

ORDER BY decimal_number ASC; -- Query is ordered in ASC by decimal_number to reveal any False fields in the list at the top.



-- Sample feature being used: new_cases_smoothed

-- a) MAX Total Number of Digits in Field:
SELECT DISTINCT(new_cases_smoothed) AS max_len_num_continuous, 
				LENGTH(new_cases_smoothed) AS total_char_len,
                
				CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
					 WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
                     WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
                     ELSE LENGTH(new_cases_smoothed) END AS total_digit_len, 
                     
				CASE 
					WHEN new_cases_smoothed LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
                    ELSE "False" END AS decimal_number

FROM data_load

WHERE CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
		   WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
		   WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
		   ELSE LENGTH(new_cases_smoothed) 
	  
      END = (SELECT MAX(CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
					         WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
		                     WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
		                     ELSE LENGTH(new_cases_smoothed) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC; -- Query is ordered in ASC by decimal_number to reveal any False fields in the list at the top.


-- b) MAX Number of Decimal Digits in Field:
SELECT DISTINCT(new_cases_smoothed) AS max_len_num_continuous, 

				CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "N/A" ELSE SUBSTRING_INDEX(new_cases_smoothed, '.', -1) END AS decimal_digits, 
                CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) END AS decimal_digits_len, 
                
				CASE 
					WHEN new_cases_smoothed LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
                    ELSE "False" END AS decimal_number

FROM data_load
    
WHERE CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))

      END = (SELECT MAX(CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC; -- Query is ordered in ASC by decimal_number to reveal any False fields in the list at the top.



-- To summarize, the following queries will form the basis or columns for extracting the data-type arguments for data-type conversion:

-- Max Character Length Fields in Categorical Features:
SELECT DISTINCT(iso_code) AS max_len_iso_code, 
	   LENGTH(iso_code) AS len 
FROM data_load
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM data_load);

-- Max Character Length Fields in Numerically Discrete Features:
SELECT DISTINCT(new_cases) AS max_len_num_discrete, 
				CASE 
					WHEN new_cases LIKE "%.%" THEN 
                    (CASE WHEN CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
                    ELSE "True" END AS whole_number,
                    
				CASE
					WHEN new_cases LIKE '-%' THEN 
                    (CASE 
						WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE 
						WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
FROM data_load

WHERE CASE	
		WHEN new_cases LIKE '-%' THEN 
			(CASE 
				WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END) 
				ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
		ELSE 
			(CASE 
				WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
				ELSE LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
	  
        END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT))) 
			  FROM data_load 
              WHERE new_cases NOT LIKE '-%')

ORDER BY whole_number ASC; 


-- Max Character Length Fields in Numerically Continuous Features:
-- a) MAX Total Number of Digits in Field:
SELECT DISTINCT(new_cases_smoothed) AS max_len_num_continuous, 
	   LENGTH(new_cases_smoothed) AS total_char_len,
	   CASE 
	       WHEN new_cases_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

	   CASE 
		   WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
		   WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
		   WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
		   ELSE LENGTH(new_cases_smoothed) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
		   WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
		   WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
		   ELSE LENGTH(new_cases_smoothed) 
	  
      END = (SELECT MAX(CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
					         WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
		                     WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
		                     ELSE LENGTH(new_cases_smoothed) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC; -- Query is ordered in ASC by decimal_number to reveal any False fields in the list at the top.

-- b) MAX Number of Decimal Digits in Field:
SELECT DISTINCT(new_cases_smoothed) AS max_len_num_continuous, 
	   CASE 
	       WHEN new_cases_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
	   CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))

      END = (SELECT MAX(CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC; -- Query is ordered in ASC by decimal_number to reveal any False fields in the list at the top.



/* Toggle to (un)hide this sample query which is capable of gathering each SELECT query's results into a single table.
   This temporary table will not be used because at least one of the columns, apparently the column placed 1st in order, creates duplicates of the same fields in that very column.
   For the purpose of identifying the field with MAX length in each column, this query would still be functional.
   However, for the maintainence of data integrity it is best to take another approach.

SELECT column_1.max_len_new_cases, column_2.max_len_total_deaths FROM

	(SELECT DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases))) AS max_len_new_cases FROM data_load
	WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM data_load)) AS column_1,
    
    (SELECT DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths))) AS max_len_total_deaths FROM data_load
	WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM data_load)) AS column_2;


The queries below will confirm the erred output of the temporary table above, i.e., the outputs from the following queries are correct but the output above is incorrect.

-- Number of Max Length Fields in new_cases:
SELECT COUNT(DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases)))) AS count_max_len_new_cases FROM data_load
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM data_load);

-- Max Length Fields in new_cases:
SELECT DISTINCT(CONCAT(new_cases, '; ', LENGTH(new_cases))) AS count_max_len_new_cases FROM data_load
WHERE LENGTH(new_cases) = (SELECT MAX(LENGTH(new_cases)) FROM data_load);


-- Number of Max Length Fields in total_deaths:
SELECT COUNT(DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths)))) AS count_max_len_total_deaths FROM data_load
WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM data_load);

-- Max Length Fields in total_deaths:
SELECT DISTINCT(CONCAT(total_deaths, '; ', LENGTH(total_deaths))) AS count_max_len_total_deaths FROM data_load
WHERE LENGTH(total_deaths) = (SELECT MAX(LENGTH(total_deaths)) FROM data_load);

*/






/* MAX Character Length of All Features Except Temporal Feature(s):

-- SQL queries for MAX character length of categorical and numerical features were automated via python script and has been pasted below.
-- The _date_ feature is a categorical feature, however, in the context of SQL databases, it is a temporal feature, and the only temporal feature in this dataset. 
-- The following 3 query-sets will return multiple tabs rather than a single temporary table grouping all of the columns together:

*/

-- 1. Categorical Features - MAX Length:
SELECT DISTINCT(iso_code) AS max_len_iso_code,
       LENGTH(iso_code) AS len
FROM data_load
WHERE LENGTH(iso_code) = (SELECT MAX(LENGTH(iso_code)) FROM data_load);


SELECT DISTINCT(continent) AS max_len_continent,
       LENGTH(continent) AS len
FROM data_load
WHERE LENGTH(continent) = (SELECT MAX(LENGTH(continent)) FROM data_load);


SELECT DISTINCT(location) AS max_len_location,
       LENGTH(location) AS len
FROM data_load
WHERE LENGTH(location) = (SELECT MAX(LENGTH(location)) FROM data_load);


SELECT DISTINCT(tests_units) AS max_len_tests_units,
       LENGTH(tests_units) AS len
FROM data_load
WHERE LENGTH(tests_units) = (SELECT MAX(LENGTH(tests_units)) FROM data_load);



-- 2. Numerical Discrete Features - MAX Length:
SELECT DISTINCT(population) AS max_len_num_population,
				CASE
					WHEN population LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(population, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN population LIKE '-%' THEN 
					(CASE
						WHEN population LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(population, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN population LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(population, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN population LIKE '-%' THEN 
					(CASE
						WHEN population LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(population, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
					(CASE 
						WHEN population LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(population, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(population, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE population NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(total_cases) AS max_len_num_total_cases,
	        CASE
				WHEN total_cases LIKE "%.%" THEN
				(CASE WHEN CAST(SUBSTRING_INDEX(total_cases, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
				ELSE "True" END AS whole_number,
                    
			CASE
				WHEN total_cases LIKE '-%' THEN 
				(CASE
					WHEN total_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) - 1) END) 
					ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
				ELSE 
				(CASE
					WHEN total_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) END)
					ELSE LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) END)
			END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE
		       WHEN total_cases LIKE '-%' THEN 
				   (CASE
					   WHEN total_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) - 1) END) 
					   ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
				   (CASE 
					   WHEN total_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) END)
				       ELSE LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT)) END)
	  
                   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(total_cases, '.', 1) AS SIGNED INT))) 
						  FROM data_load 
						  WHERE total_cases NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(new_cases) AS max_len_num_new_cases,
				CASE
					WHEN new_cases LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN new_cases LIKE '-%' THEN 
					(CASE
						WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
			   WHEN new_cases LIKE '-%' THEN 
				   (CASE
					    WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
			       (CASE 
						WHEN new_cases LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_cases, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(new_cases, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE new_cases NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(total_tests) AS max_len_num_total_tests,
				CASE
					WHEN total_tests LIKE "%.%" THEN
                    (CASE WHEN CAST(SUBSTRING_INDEX(total_tests, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
                    ELSE "True" END AS whole_number,
                    
				CASE
					WHEN total_tests LIKE '-%' THEN 
                    (CASE
						WHEN total_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN total_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN total_tests LIKE '-%' THEN 
					(CASE
						WHEN total_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
					(CASE 
						WHEN total_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(total_tests, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE total_tests NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(new_tests) AS max_len_num_new_tests,
				CASE
					WHEN new_tests LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(new_tests, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN new_tests LIKE '-%' THEN 
					(CASE
						WHEN new_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN new_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN new_tests LIKE '-%' THEN 
				   (CASE
						WHEN new_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
					(CASE 
						WHEN new_tests LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_tests, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(new_tests, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE new_tests NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(total_deaths) AS max_len_num_total_deaths,
				CASE
					WHEN total_deaths LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(total_deaths, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN total_deaths LIKE '-%' THEN 
					(CASE
						WHEN total_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN total_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN total_deaths LIKE '-%' THEN 
				   (CASE
					    WHEN total_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
			       (CASE 
						WHEN total_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(total_deaths, '.', 1) AS SIGNED INT))) 
				      FROM data_load 
					  WHERE total_deaths NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(new_deaths) AS max_len_num_new_deaths,
				CASE
					WHEN new_deaths LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(new_deaths, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN new_deaths LIKE '-%' THEN 
					(CASE
						WHEN new_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN new_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN new_deaths LIKE '-%' THEN 
			       (CASE
						WHEN new_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
			       (CASE 
						WHEN new_deaths LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(new_deaths, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(new_deaths, '.', 1) AS SIGNED INT))) 
				      FROM data_load 
					  WHERE new_deaths NOT LIKE '-%')

           ORDER BY whole_number ASC;
           

SELECT DISTINCT(icu_patients) AS max_len_num_icu_patients,
				CASE
					WHEN icu_patients LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(icu_patients, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN icu_patients LIKE '-%' THEN 
					(CASE
						WHEN icu_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(icu_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN icu_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(icu_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
		       WHEN icu_patients LIKE '-%' THEN 
				   (CASE
						WHEN icu_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(icu_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
				   (CASE 
						WHEN icu_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(icu_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(icu_patients, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE icu_patients NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(hosp_patients) AS max_len_num_hosp_patients,
				CASE
					WHEN hosp_patients LIKE "%.%" THEN
                    (CASE WHEN CAST(SUBSTRING_INDEX(hosp_patients, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
                    ELSE "True" END AS whole_number,
                    
				CASE
					WHEN hosp_patients LIKE '-%' THEN 
					(CASE
						WHEN hosp_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(hosp_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN hosp_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(hosp_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN hosp_patients LIKE '-%' THEN 
			       (CASE
						WHEN hosp_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(hosp_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
				   (CASE 
						WHEN hosp_patients LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(hosp_patients, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(hosp_patients, '.', 1) AS SIGNED INT))) 
				      FROM data_load 
					  WHERE hosp_patients NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(weekly_icu_admissions) AS max_len_num_weekly_icu_admissions,
				CASE
					WHEN weekly_icu_admissions LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN weekly_icu_admissions LIKE '-%' THEN 
					(CASE
						WHEN weekly_icu_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN weekly_icu_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN weekly_icu_admissions LIKE '-%' THEN 
			       (CASE
						WHEN weekly_icu_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
			       (CASE 
						WHEN weekly_icu_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(weekly_icu_admissions, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE weekly_icu_admissions NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(weekly_hosp_admissions) AS max_len_num_weekly_hosp_admissions,
				CASE
					WHEN weekly_hosp_admissions LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN weekly_hosp_admissions LIKE '-%' THEN 
					(CASE
						WHEN weekly_hosp_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN weekly_hosp_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN weekly_hosp_admissions LIKE '-%' THEN 
			       (CASE
						WHEN weekly_hosp_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
                       (CASE 
                           WHEN weekly_hosp_admissions LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) END)
                           ELSE LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(weekly_hosp_admissions, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE weekly_hosp_admissions NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(total_vaccinations) AS max_len_num_total_vaccinations,
				CASE
					WHEN total_vaccinations LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(total_vaccinations, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN total_vaccinations LIKE '-%' THEN 
					(CASE
						WHEN total_vaccinations LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_vaccinations, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN total_vaccinations LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_vaccinations, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
		       WHEN total_vaccinations LIKE '-%' THEN 
			       (CASE
						WHEN total_vaccinations LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_vaccinations, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
			       (CASE 
						WHEN total_vaccinations LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_vaccinations, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(total_vaccinations, '.', 1) AS SIGNED INT))) 
		              FROM data_load 
					  WHERE total_vaccinations NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(people_vaccinated) AS max_len_num_people_vaccinated,
				CASE
					WHEN people_vaccinated LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(people_vaccinated, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN people_vaccinated LIKE '-%' THEN 
					(CASE
						WHEN people_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN people_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN people_vaccinated LIKE '-%' THEN 
			       (CASE
						WHEN people_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
				   (CASE 
						WHEN people_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(people_vaccinated, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE people_vaccinated NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(people_fully_vaccinated) AS max_len_num_people_fully_vaccinated,
				CASE
					WHEN people_fully_vaccinated LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN people_fully_vaccinated LIKE '-%' THEN 
					(CASE
						WHEN people_fully_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN people_fully_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN people_fully_vaccinated LIKE '-%' THEN 
			       (CASE
						WHEN people_fully_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
                       (CASE 
                           WHEN people_fully_vaccinated LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) END)
                           ELSE LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(people_fully_vaccinated, '.', 1) AS SIGNED INT))) 
				      FROM data_load 
					  WHERE people_fully_vaccinated NOT LIKE '-%')

           ORDER BY whole_number ASC;


SELECT DISTINCT(total_boosters) AS max_len_num_total_boosters,
				CASE
					WHEN total_boosters LIKE "%.%" THEN
					(CASE WHEN CAST(SUBSTRING_INDEX(total_boosters, '.', -1) AS SIGNED INT) > 0 THEN "False" ELSE "True" END) 
					ELSE "True" END AS whole_number,
                    
				CASE
					WHEN total_boosters LIKE '-%' THEN 
					(CASE
						WHEN total_boosters LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_boosters, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) - 1) END)
					
                    ELSE 
                    (CASE
                        WHEN total_boosters LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_boosters, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) END)
                        ELSE LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) END)
                END AS MAX_length_whole_number
                
           FROM data_load

           WHERE CASE	
	           WHEN total_boosters LIKE '-%' THEN 
			       (CASE
						WHEN total_boosters LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_boosters, '.', -1) AS SIGNED INT) > 0) = 0 THEN (LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) - 1) END) 
						ELSE (LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) - 1) END)
					
	           ELSE
			       (CASE 
						WHEN total_boosters LIKE '%.%' THEN (CASE WHEN (CAST(SUBSTRING_INDEX(total_boosters, '.', -1) AS SIGNED INT) > 0) = 0 THEN LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) END)
						ELSE LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT)) END)
	  
			   END = (SELECT MAX(LENGTH(CAST(SUBSTRING_INDEX(total_boosters, '.', 1) AS SIGNED INT))) 
					  FROM data_load 
					  WHERE total_boosters NOT LIKE '-%')

           ORDER BY whole_number ASC;



-- 3. Numerical Continuous Features - MAX Length:

-- A) Precision - MAX Length:
SELECT DISTINCT(new_cases_smoothed) AS max_len_num_new_cases_smoothed, 
       LENGTH(new_cases_smoothed) AS total_char_len,
       CASE 
           WHEN new_cases_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
           WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
           WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
		   ELSE LENGTH(new_cases_smoothed) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
	   WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
	   WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
	   ELSE LENGTH(new_cases_smoothed) 
	  
      END = (SELECT MAX(CASE WHEN new_cases_smoothed LIKE "-%.%" THEN (LENGTH(new_cases_smoothed) - 2) 
							 WHEN new_cases_smoothed LIKE "-%" THEN (LENGTH(new_cases_smoothed) - 1)
							 WHEN new_cases_smoothed LIKE "%.%" THEN (LENGTH(new_cases_smoothed) - 1) 
							 ELSE LENGTH(new_cases_smoothed) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_deaths_smoothed) AS max_len_num_new_deaths_smoothed, 
       LENGTH(new_deaths_smoothed) AS total_char_len,
       CASE 
           WHEN new_deaths_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_deaths_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_deaths_smoothed LIKE "-%.%" THEN (LENGTH(new_deaths_smoothed) - 2) 
           WHEN new_deaths_smoothed LIKE "-%" THEN (LENGTH(new_deaths_smoothed) - 1)
           WHEN new_deaths_smoothed LIKE "%.%" THEN (LENGTH(new_deaths_smoothed) - 1) 
		   ELSE LENGTH(new_deaths_smoothed) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_deaths_smoothed LIKE "-%.%" THEN (LENGTH(new_deaths_smoothed) - 2) 
		   WHEN new_deaths_smoothed LIKE "-%" THEN (LENGTH(new_deaths_smoothed) - 1)
		   WHEN new_deaths_smoothed LIKE "%.%" THEN (LENGTH(new_deaths_smoothed) - 1) 
		   ELSE LENGTH(new_deaths_smoothed) 
	  
      END = (SELECT MAX(CASE WHEN new_deaths_smoothed LIKE "-%.%" THEN (LENGTH(new_deaths_smoothed) - 2) 
							 WHEN new_deaths_smoothed LIKE "-%" THEN (LENGTH(new_deaths_smoothed) - 1)
							 WHEN new_deaths_smoothed LIKE "%.%" THEN (LENGTH(new_deaths_smoothed) - 1) 
							 ELSE LENGTH(new_deaths_smoothed) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(total_cases_per_million) AS max_len_num_total_cases_per_million, 
       LENGTH(total_cases_per_million) AS total_char_len,
       CASE 
           WHEN total_cases_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_cases_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN total_cases_per_million LIKE "-%.%" THEN (LENGTH(total_cases_per_million) - 2) 
           WHEN total_cases_per_million LIKE "-%" THEN (LENGTH(total_cases_per_million) - 1)
           WHEN total_cases_per_million LIKE "%.%" THEN (LENGTH(total_cases_per_million) - 1) 
		   ELSE LENGTH(total_cases_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN total_cases_per_million LIKE "-%.%" THEN (LENGTH(total_cases_per_million) - 2) 
		   WHEN total_cases_per_million LIKE "-%" THEN (LENGTH(total_cases_per_million) - 1)
		   WHEN total_cases_per_million LIKE "%.%" THEN (LENGTH(total_cases_per_million) - 1) 
		   ELSE LENGTH(total_cases_per_million) 
	  
      END = (SELECT MAX(CASE WHEN total_cases_per_million LIKE "-%.%" THEN (LENGTH(total_cases_per_million) - 2) 
							 WHEN total_cases_per_million LIKE "-%" THEN (LENGTH(total_cases_per_million) - 1)
							 WHEN total_cases_per_million LIKE "%.%" THEN (LENGTH(total_cases_per_million) - 1) 
							 ELSE LENGTH(total_cases_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_cases_per_million) AS max_len_num_new_cases_per_million, 
       LENGTH(new_cases_per_million) AS total_char_len,
       CASE 
           WHEN new_cases_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_cases_per_million LIKE "-%.%" THEN (LENGTH(new_cases_per_million) - 2) 
           WHEN new_cases_per_million LIKE "-%" THEN (LENGTH(new_cases_per_million) - 1)
           WHEN new_cases_per_million LIKE "%.%" THEN (LENGTH(new_cases_per_million) - 1) 
		   ELSE LENGTH(new_cases_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_cases_per_million LIKE "-%.%" THEN (LENGTH(new_cases_per_million) - 2) 
		   WHEN new_cases_per_million LIKE "-%" THEN (LENGTH(new_cases_per_million) - 1)
		   WHEN new_cases_per_million LIKE "%.%" THEN (LENGTH(new_cases_per_million) - 1) 
		   ELSE LENGTH(new_cases_per_million) 
	  
      END = (SELECT MAX(CASE WHEN new_cases_per_million LIKE "-%.%" THEN (LENGTH(new_cases_per_million) - 2) 
						     WHEN new_cases_per_million LIKE "-%" THEN (LENGTH(new_cases_per_million) - 1)
							 WHEN new_cases_per_million LIKE "%.%" THEN (LENGTH(new_cases_per_million) - 1) 
							 ELSE LENGTH(new_cases_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_cases_smoothed_per_million) AS max_len_num_new_cases_smoothed_per_million, 
       LENGTH(new_cases_smoothed_per_million) AS total_char_len,
       CASE 
           WHEN new_cases_smoothed_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_cases_smoothed_per_million LIKE "-%.%" THEN (LENGTH(new_cases_smoothed_per_million) - 2) 
           WHEN new_cases_smoothed_per_million LIKE "-%" THEN (LENGTH(new_cases_smoothed_per_million) - 1)
           WHEN new_cases_smoothed_per_million LIKE "%.%" THEN (LENGTH(new_cases_smoothed_per_million) - 1) 
		   ELSE LENGTH(new_cases_smoothed_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_cases_smoothed_per_million LIKE "-%.%" THEN (LENGTH(new_cases_smoothed_per_million) - 2) 
		   WHEN new_cases_smoothed_per_million LIKE "-%" THEN (LENGTH(new_cases_smoothed_per_million) - 1)
		   WHEN new_cases_smoothed_per_million LIKE "%.%" THEN (LENGTH(new_cases_smoothed_per_million) - 1) 
		   ELSE LENGTH(new_cases_smoothed_per_million) 
	  
      END = (SELECT MAX(CASE WHEN new_cases_smoothed_per_million LIKE "-%.%" THEN (LENGTH(new_cases_smoothed_per_million) - 2) 
							 WHEN new_cases_smoothed_per_million LIKE "-%" THEN (LENGTH(new_cases_smoothed_per_million) - 1)
							 WHEN new_cases_smoothed_per_million LIKE "%.%" THEN (LENGTH(new_cases_smoothed_per_million) - 1) 
							 ELSE LENGTH(new_cases_smoothed_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(total_deaths_per_million) AS max_len_num_total_deaths_per_million, 
       LENGTH(total_deaths_per_million) AS total_char_len,
       CASE 
           WHEN total_deaths_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_deaths_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN total_deaths_per_million LIKE "-%.%" THEN (LENGTH(total_deaths_per_million) - 2) 
           WHEN total_deaths_per_million LIKE "-%" THEN (LENGTH(total_deaths_per_million) - 1)
           WHEN total_deaths_per_million LIKE "%.%" THEN (LENGTH(total_deaths_per_million) - 1) 
		   ELSE LENGTH(total_deaths_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN total_deaths_per_million LIKE "-%.%" THEN (LENGTH(total_deaths_per_million) - 2) 
		   WHEN total_deaths_per_million LIKE "-%" THEN (LENGTH(total_deaths_per_million) - 1)
		   WHEN total_deaths_per_million LIKE "%.%" THEN (LENGTH(total_deaths_per_million) - 1) 
		   ELSE LENGTH(total_deaths_per_million) 
	  
      END = (SELECT MAX(CASE WHEN total_deaths_per_million LIKE "-%.%" THEN (LENGTH(total_deaths_per_million) - 2) 
							 WHEN total_deaths_per_million LIKE "-%" THEN (LENGTH(total_deaths_per_million) - 1)
							 WHEN total_deaths_per_million LIKE "%.%" THEN (LENGTH(total_deaths_per_million) - 1) 
							 ELSE LENGTH(total_deaths_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_deaths_per_million) AS max_len_num_new_deaths_per_million, 
       LENGTH(new_deaths_per_million) AS total_char_len,
       CASE 
           WHEN new_deaths_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_deaths_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_deaths_per_million LIKE "-%.%" THEN (LENGTH(new_deaths_per_million) - 2) 
           WHEN new_deaths_per_million LIKE "-%" THEN (LENGTH(new_deaths_per_million) - 1)
           WHEN new_deaths_per_million LIKE "%.%" THEN (LENGTH(new_deaths_per_million) - 1) 
		   ELSE LENGTH(new_deaths_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_deaths_per_million LIKE "-%.%" THEN (LENGTH(new_deaths_per_million) - 2) 
		   WHEN new_deaths_per_million LIKE "-%" THEN (LENGTH(new_deaths_per_million) - 1)
		   WHEN new_deaths_per_million LIKE "%.%" THEN (LENGTH(new_deaths_per_million) - 1) 
		   ELSE LENGTH(new_deaths_per_million) 
	  
      END = (SELECT MAX(CASE WHEN new_deaths_per_million LIKE "-%.%" THEN (LENGTH(new_deaths_per_million) - 2) 
							 WHEN new_deaths_per_million LIKE "-%" THEN (LENGTH(new_deaths_per_million) - 1)
							 WHEN new_deaths_per_million LIKE "%.%" THEN (LENGTH(new_deaths_per_million) - 1) 
							 ELSE LENGTH(new_deaths_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_deaths_smoothed_per_million) AS max_len_num_new_deaths_smoothed_per_million, 
       LENGTH(new_deaths_smoothed_per_million) AS total_char_len,
       CASE 
           WHEN new_deaths_smoothed_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_deaths_smoothed_per_million LIKE "-%.%" THEN (LENGTH(new_deaths_smoothed_per_million) - 2) 
           WHEN new_deaths_smoothed_per_million LIKE "-%" THEN (LENGTH(new_deaths_smoothed_per_million) - 1)
           WHEN new_deaths_smoothed_per_million LIKE "%.%" THEN (LENGTH(new_deaths_smoothed_per_million) - 1) 
		   ELSE LENGTH(new_deaths_smoothed_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_deaths_smoothed_per_million LIKE "-%.%" THEN (LENGTH(new_deaths_smoothed_per_million) - 2) 
	   WHEN new_deaths_smoothed_per_million LIKE "-%" THEN (LENGTH(new_deaths_smoothed_per_million) - 1)
	   WHEN new_deaths_smoothed_per_million LIKE "%.%" THEN (LENGTH(new_deaths_smoothed_per_million) - 1) 
	   ELSE LENGTH(new_deaths_smoothed_per_million) 
	  
      END = (SELECT MAX(CASE WHEN new_deaths_smoothed_per_million LIKE "-%.%" THEN (LENGTH(new_deaths_smoothed_per_million) - 2) 
						     WHEN new_deaths_smoothed_per_million LIKE "-%" THEN (LENGTH(new_deaths_smoothed_per_million) - 1)
							 WHEN new_deaths_smoothed_per_million LIKE "%.%" THEN (LENGTH(new_deaths_smoothed_per_million) - 1) 
							 ELSE LENGTH(new_deaths_smoothed_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(reproduction_rate) AS max_len_num_reproduction_rate, 
       LENGTH(reproduction_rate) AS total_char_len,
       CASE 
           WHEN reproduction_rate LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(reproduction_rate, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN reproduction_rate LIKE "-%.%" THEN (LENGTH(reproduction_rate) - 2) 
           WHEN reproduction_rate LIKE "-%" THEN (LENGTH(reproduction_rate) - 1)
           WHEN reproduction_rate LIKE "%.%" THEN (LENGTH(reproduction_rate) - 1) 
		   ELSE LENGTH(reproduction_rate) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN reproduction_rate LIKE "-%.%" THEN (LENGTH(reproduction_rate) - 2) 
		   WHEN reproduction_rate LIKE "-%" THEN (LENGTH(reproduction_rate) - 1)
		   WHEN reproduction_rate LIKE "%.%" THEN (LENGTH(reproduction_rate) - 1) 
		   ELSE LENGTH(reproduction_rate) 
	  
      END = (SELECT MAX(CASE WHEN reproduction_rate LIKE "-%.%" THEN (LENGTH(reproduction_rate) - 2) 
							 WHEN reproduction_rate LIKE "-%" THEN (LENGTH(reproduction_rate) - 1)
							 WHEN reproduction_rate LIKE "%.%" THEN (LENGTH(reproduction_rate) - 1) 
							 ELSE LENGTH(reproduction_rate) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(icu_patients_per_million) AS max_len_num_icu_patients_per_million, 
       LENGTH(icu_patients_per_million) AS total_char_len,
       CASE 
           WHEN icu_patients_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(icu_patients_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN icu_patients_per_million LIKE "-%.%" THEN (LENGTH(icu_patients_per_million) - 2) 
           WHEN icu_patients_per_million LIKE "-%" THEN (LENGTH(icu_patients_per_million) - 1)
           WHEN icu_patients_per_million LIKE "%.%" THEN (LENGTH(icu_patients_per_million) - 1) 
		   ELSE LENGTH(icu_patients_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN icu_patients_per_million LIKE "-%.%" THEN (LENGTH(icu_patients_per_million) - 2) 
		   WHEN icu_patients_per_million LIKE "-%" THEN (LENGTH(icu_patients_per_million) - 1)
		   WHEN icu_patients_per_million LIKE "%.%" THEN (LENGTH(icu_patients_per_million) - 1) 
		   ELSE LENGTH(icu_patients_per_million) 
	  
      END = (SELECT MAX(CASE WHEN icu_patients_per_million LIKE "-%.%" THEN (LENGTH(icu_patients_per_million) - 2) 
							 WHEN icu_patients_per_million LIKE "-%" THEN (LENGTH(icu_patients_per_million) - 1)
							 WHEN icu_patients_per_million LIKE "%.%" THEN (LENGTH(icu_patients_per_million) - 1) 
							 ELSE LENGTH(icu_patients_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(hosp_patients_per_million) AS max_len_num_hosp_patients_per_million, 
       LENGTH(hosp_patients_per_million) AS total_char_len,
       CASE 
           WHEN hosp_patients_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(hosp_patients_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN hosp_patients_per_million LIKE "-%.%" THEN (LENGTH(hosp_patients_per_million) - 2) 
           WHEN hosp_patients_per_million LIKE "-%" THEN (LENGTH(hosp_patients_per_million) - 1)
           WHEN hosp_patients_per_million LIKE "%.%" THEN (LENGTH(hosp_patients_per_million) - 1) 
		   ELSE LENGTH(hosp_patients_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN hosp_patients_per_million LIKE "-%.%" THEN (LENGTH(hosp_patients_per_million) - 2) 
		   WHEN hosp_patients_per_million LIKE "-%" THEN (LENGTH(hosp_patients_per_million) - 1)
		   WHEN hosp_patients_per_million LIKE "%.%" THEN (LENGTH(hosp_patients_per_million) - 1) 
		   ELSE LENGTH(hosp_patients_per_million) 
	  
      END = (SELECT MAX(CASE WHEN hosp_patients_per_million LIKE "-%.%" THEN (LENGTH(hosp_patients_per_million) - 2) 
							 WHEN hosp_patients_per_million LIKE "-%" THEN (LENGTH(hosp_patients_per_million) - 1)
							 WHEN hosp_patients_per_million LIKE "%.%" THEN (LENGTH(hosp_patients_per_million) - 1) 
							 ELSE LENGTH(hosp_patients_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(weekly_icu_admissions_per_million) AS max_len_num_weekly_icu_admissions_per_million, 
       LENGTH(weekly_icu_admissions_per_million) AS total_char_len,
       CASE 
           WHEN weekly_icu_admissions_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN weekly_icu_admissions_per_million LIKE "-%.%" THEN (LENGTH(weekly_icu_admissions_per_million) - 2) 
           WHEN weekly_icu_admissions_per_million LIKE "-%" THEN (LENGTH(weekly_icu_admissions_per_million) - 1)
           WHEN weekly_icu_admissions_per_million LIKE "%.%" THEN (LENGTH(weekly_icu_admissions_per_million) - 1) 
		   ELSE LENGTH(weekly_icu_admissions_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN weekly_icu_admissions_per_million LIKE "-%.%" THEN (LENGTH(weekly_icu_admissions_per_million) - 2) 
		   WHEN weekly_icu_admissions_per_million LIKE "-%" THEN (LENGTH(weekly_icu_admissions_per_million) - 1)
		   WHEN weekly_icu_admissions_per_million LIKE "%.%" THEN (LENGTH(weekly_icu_admissions_per_million) - 1) 
		   ELSE LENGTH(weekly_icu_admissions_per_million) 
	  
      END = (SELECT MAX(CASE WHEN weekly_icu_admissions_per_million LIKE "-%.%" THEN (LENGTH(weekly_icu_admissions_per_million) - 2) 
							 WHEN weekly_icu_admissions_per_million LIKE "-%" THEN (LENGTH(weekly_icu_admissions_per_million) - 1)
							 WHEN weekly_icu_admissions_per_million LIKE "%.%" THEN (LENGTH(weekly_icu_admissions_per_million) - 1) 
							 ELSE LENGTH(weekly_icu_admissions_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(weekly_hosp_admissions_per_million) AS max_len_num_weekly_hosp_admissions_per_million, 
       LENGTH(weekly_hosp_admissions_per_million) AS total_char_len,
       CASE 
           WHEN weekly_hosp_admissions_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN weekly_hosp_admissions_per_million LIKE "-%.%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 2) 
           WHEN weekly_hosp_admissions_per_million LIKE "-%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 1)
           WHEN weekly_hosp_admissions_per_million LIKE "%.%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 1) 
		   ELSE LENGTH(weekly_hosp_admissions_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN weekly_hosp_admissions_per_million LIKE "-%.%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 2) 
		   WHEN weekly_hosp_admissions_per_million LIKE "-%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 1)
		   WHEN weekly_hosp_admissions_per_million LIKE "%.%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 1) 
		   ELSE LENGTH(weekly_hosp_admissions_per_million) 
	  
      END = (SELECT MAX(CASE WHEN weekly_hosp_admissions_per_million LIKE "-%.%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 2) 
							 WHEN weekly_hosp_admissions_per_million LIKE "-%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 1)
							 WHEN weekly_hosp_admissions_per_million LIKE "%.%" THEN (LENGTH(weekly_hosp_admissions_per_million) - 1) 
							 ELSE LENGTH(weekly_hosp_admissions_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(total_tests_per_thousand) AS max_len_num_total_tests_per_thousand, 
       LENGTH(total_tests_per_thousand) AS total_char_len,
       CASE 
           WHEN total_tests_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_tests_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN total_tests_per_thousand LIKE "-%.%" THEN (LENGTH(total_tests_per_thousand) - 2) 
           WHEN total_tests_per_thousand LIKE "-%" THEN (LENGTH(total_tests_per_thousand) - 1)
           WHEN total_tests_per_thousand LIKE "%.%" THEN (LENGTH(total_tests_per_thousand) - 1) 
		   ELSE LENGTH(total_tests_per_thousand) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN total_tests_per_thousand LIKE "-%.%" THEN (LENGTH(total_tests_per_thousand) - 2) 
		   WHEN total_tests_per_thousand LIKE "-%" THEN (LENGTH(total_tests_per_thousand) - 1)
		   WHEN total_tests_per_thousand LIKE "%.%" THEN (LENGTH(total_tests_per_thousand) - 1) 
		   ELSE LENGTH(total_tests_per_thousand) 
	  
      END = (SELECT MAX(CASE WHEN total_tests_per_thousand LIKE "-%.%" THEN (LENGTH(total_tests_per_thousand) - 2) 
							 WHEN total_tests_per_thousand LIKE "-%" THEN (LENGTH(total_tests_per_thousand) - 1)
							 WHEN total_tests_per_thousand LIKE "%.%" THEN (LENGTH(total_tests_per_thousand) - 1) 
							 ELSE LENGTH(total_tests_per_thousand) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_tests_per_thousand) AS max_len_num_new_tests_per_thousand, 
       LENGTH(new_tests_per_thousand) AS total_char_len,
       CASE 
           WHEN new_tests_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_tests_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_tests_per_thousand LIKE "-%.%" THEN (LENGTH(new_tests_per_thousand) - 2) 
           WHEN new_tests_per_thousand LIKE "-%" THEN (LENGTH(new_tests_per_thousand) - 1)
           WHEN new_tests_per_thousand LIKE "%.%" THEN (LENGTH(new_tests_per_thousand) - 1) 
		   ELSE LENGTH(new_tests_per_thousand) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_tests_per_thousand LIKE "-%.%" THEN (LENGTH(new_tests_per_thousand) - 2) 
		   WHEN new_tests_per_thousand LIKE "-%" THEN (LENGTH(new_tests_per_thousand) - 1)
		   WHEN new_tests_per_thousand LIKE "%.%" THEN (LENGTH(new_tests_per_thousand) - 1) 
		   ELSE LENGTH(new_tests_per_thousand) 
	  
      END = (SELECT MAX(CASE WHEN new_tests_per_thousand LIKE "-%.%" THEN (LENGTH(new_tests_per_thousand) - 2) 
							 WHEN new_tests_per_thousand LIKE "-%" THEN (LENGTH(new_tests_per_thousand) - 1)
							 WHEN new_tests_per_thousand LIKE "%.%" THEN (LENGTH(new_tests_per_thousand) - 1) 
							 ELSE LENGTH(new_tests_per_thousand) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_tests_smoothed) AS max_len_num_new_tests_smoothed, 
       LENGTH(new_tests_smoothed) AS total_char_len,
       CASE 
           WHEN new_tests_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_tests_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_tests_smoothed LIKE "-%.%" THEN (LENGTH(new_tests_smoothed) - 2) 
           WHEN new_tests_smoothed LIKE "-%" THEN (LENGTH(new_tests_smoothed) - 1)
           WHEN new_tests_smoothed LIKE "%.%" THEN (LENGTH(new_tests_smoothed) - 1) 
		   ELSE LENGTH(new_tests_smoothed) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_tests_smoothed LIKE "-%.%" THEN (LENGTH(new_tests_smoothed) - 2) 
		   WHEN new_tests_smoothed LIKE "-%" THEN (LENGTH(new_tests_smoothed) - 1)
		   WHEN new_tests_smoothed LIKE "%.%" THEN (LENGTH(new_tests_smoothed) - 1) 
		   ELSE LENGTH(new_tests_smoothed) 
	  
      END = (SELECT MAX(CASE WHEN new_tests_smoothed LIKE "-%.%" THEN (LENGTH(new_tests_smoothed) - 2) 
							 WHEN new_tests_smoothed LIKE "-%" THEN (LENGTH(new_tests_smoothed) - 1)
							 WHEN new_tests_smoothed LIKE "%.%" THEN (LENGTH(new_tests_smoothed) - 1) 
							 ELSE LENGTH(new_tests_smoothed) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_tests_smoothed_per_thousand) AS max_len_num_new_tests_smoothed_per_thousand, 
       LENGTH(new_tests_smoothed_per_thousand) AS total_char_len,
       CASE 
           WHEN new_tests_smoothed_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_tests_smoothed_per_thousand LIKE "-%.%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 2) 
           WHEN new_tests_smoothed_per_thousand LIKE "-%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 1)
           WHEN new_tests_smoothed_per_thousand LIKE "%.%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 1) 
		   ELSE LENGTH(new_tests_smoothed_per_thousand) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_tests_smoothed_per_thousand LIKE "-%.%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 2) 
		   WHEN new_tests_smoothed_per_thousand LIKE "-%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 1)
		   WHEN new_tests_smoothed_per_thousand LIKE "%.%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 1) 
		   ELSE LENGTH(new_tests_smoothed_per_thousand) 
	  
      END = (SELECT MAX(CASE WHEN new_tests_smoothed_per_thousand LIKE "-%.%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 2) 
							 WHEN new_tests_smoothed_per_thousand LIKE "-%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 1)
							 WHEN new_tests_smoothed_per_thousand LIKE "%.%" THEN (LENGTH(new_tests_smoothed_per_thousand) - 1) 
							 ELSE LENGTH(new_tests_smoothed_per_thousand) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(positive_rate) AS max_len_num_positive_rate, 
       LENGTH(positive_rate) AS total_char_len,
       CASE 
           WHEN positive_rate LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(positive_rate, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN positive_rate LIKE "-%.%" THEN (LENGTH(positive_rate) - 2) 
           WHEN positive_rate LIKE "-%" THEN (LENGTH(positive_rate) - 1)
           WHEN positive_rate LIKE "%.%" THEN (LENGTH(positive_rate) - 1) 
		   ELSE LENGTH(positive_rate) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN positive_rate LIKE "-%.%" THEN (LENGTH(positive_rate) - 2) 
		   WHEN positive_rate LIKE "-%" THEN (LENGTH(positive_rate) - 1)
		   WHEN positive_rate LIKE "%.%" THEN (LENGTH(positive_rate) - 1) 
		   ELSE LENGTH(positive_rate) 
	  
      END = (SELECT MAX(CASE WHEN positive_rate LIKE "-%.%" THEN (LENGTH(positive_rate) - 2) 
							 WHEN positive_rate LIKE "-%" THEN (LENGTH(positive_rate) - 1)
							 WHEN positive_rate LIKE "%.%" THEN (LENGTH(positive_rate) - 1) 
							 ELSE LENGTH(positive_rate) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(tests_per_case) AS max_len_num_tests_per_case, 
       LENGTH(tests_per_case) AS total_char_len,
       CASE 
           WHEN tests_per_case LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(tests_per_case, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN tests_per_case LIKE "-%.%" THEN (LENGTH(tests_per_case) - 2) 
           WHEN tests_per_case LIKE "-%" THEN (LENGTH(tests_per_case) - 1)
           WHEN tests_per_case LIKE "%.%" THEN (LENGTH(tests_per_case) - 1) 
		   ELSE LENGTH(tests_per_case) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN tests_per_case LIKE "-%.%" THEN (LENGTH(tests_per_case) - 2) 
		   WHEN tests_per_case LIKE "-%" THEN (LENGTH(tests_per_case) - 1)
		   WHEN tests_per_case LIKE "%.%" THEN (LENGTH(tests_per_case) - 1) 
		   ELSE LENGTH(tests_per_case) 
	  
      END = (SELECT MAX(CASE WHEN tests_per_case LIKE "-%.%" THEN (LENGTH(tests_per_case) - 2) 
							 WHEN tests_per_case LIKE "-%" THEN (LENGTH(tests_per_case) - 1)
							 WHEN tests_per_case LIKE "%.%" THEN (LENGTH(tests_per_case) - 1) 
							 ELSE LENGTH(tests_per_case) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(total_vaccinations_per_hundred) AS max_len_num_total_vaccinations_per_hundred, 
       LENGTH(total_vaccinations_per_hundred) AS total_char_len,
       CASE 
           WHEN total_vaccinations_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN total_vaccinations_per_hundred LIKE "-%.%" THEN (LENGTH(total_vaccinations_per_hundred) - 2) 
           WHEN total_vaccinations_per_hundred LIKE "-%" THEN (LENGTH(total_vaccinations_per_hundred) - 1)
           WHEN total_vaccinations_per_hundred LIKE "%.%" THEN (LENGTH(total_vaccinations_per_hundred) - 1) 
		   ELSE LENGTH(total_vaccinations_per_hundred) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN total_vaccinations_per_hundred LIKE "-%.%" THEN (LENGTH(total_vaccinations_per_hundred) - 2) 
		   WHEN total_vaccinations_per_hundred LIKE "-%" THEN (LENGTH(total_vaccinations_per_hundred) - 1)
		   WHEN total_vaccinations_per_hundred LIKE "%.%" THEN (LENGTH(total_vaccinations_per_hundred) - 1) 
		   ELSE LENGTH(total_vaccinations_per_hundred) 
	  
      END = (SELECT MAX(CASE WHEN total_vaccinations_per_hundred LIKE "-%.%" THEN (LENGTH(total_vaccinations_per_hundred) - 2) 
							 WHEN total_vaccinations_per_hundred LIKE "-%" THEN (LENGTH(total_vaccinations_per_hundred) - 1)
							 WHEN total_vaccinations_per_hundred LIKE "%.%" THEN (LENGTH(total_vaccinations_per_hundred) - 1) 
							 ELSE LENGTH(total_vaccinations_per_hundred) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(people_vaccinated_per_hundred) AS max_len_num_people_vaccinated_per_hundred, 
       LENGTH(people_vaccinated_per_hundred) AS total_char_len,
       CASE 
           WHEN people_vaccinated_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN people_vaccinated_per_hundred LIKE "-%.%" THEN (LENGTH(people_vaccinated_per_hundred) - 2) 
           WHEN people_vaccinated_per_hundred LIKE "-%" THEN (LENGTH(people_vaccinated_per_hundred) - 1)
           WHEN people_vaccinated_per_hundred LIKE "%.%" THEN (LENGTH(people_vaccinated_per_hundred) - 1) 
		   ELSE LENGTH(people_vaccinated_per_hundred) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN people_vaccinated_per_hundred LIKE "-%.%" THEN (LENGTH(people_vaccinated_per_hundred) - 2) 
		   WHEN people_vaccinated_per_hundred LIKE "-%" THEN (LENGTH(people_vaccinated_per_hundred) - 1)
		   WHEN people_vaccinated_per_hundred LIKE "%.%" THEN (LENGTH(people_vaccinated_per_hundred) - 1) 
		   ELSE LENGTH(people_vaccinated_per_hundred) 
	  
      END = (SELECT MAX(CASE WHEN people_vaccinated_per_hundred LIKE "-%.%" THEN (LENGTH(people_vaccinated_per_hundred) - 2) 
							 WHEN people_vaccinated_per_hundred LIKE "-%" THEN (LENGTH(people_vaccinated_per_hundred) - 1)
							 WHEN people_vaccinated_per_hundred LIKE "%.%" THEN (LENGTH(people_vaccinated_per_hundred) - 1) 
							 ELSE LENGTH(people_vaccinated_per_hundred) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(people_fully_vaccinated_per_hundred) AS max_len_num_people_fully_vaccinated_per_hundred, 
       LENGTH(people_fully_vaccinated_per_hundred) AS total_char_len,
       CASE 
           WHEN people_fully_vaccinated_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN people_fully_vaccinated_per_hundred LIKE "-%.%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 2) 
           WHEN people_fully_vaccinated_per_hundred LIKE "-%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 1)
           WHEN people_fully_vaccinated_per_hundred LIKE "%.%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 1) 
		   ELSE LENGTH(people_fully_vaccinated_per_hundred) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN people_fully_vaccinated_per_hundred LIKE "-%.%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 2) 
		   WHEN people_fully_vaccinated_per_hundred LIKE "-%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 1)
		   WHEN people_fully_vaccinated_per_hundred LIKE "%.%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 1) 
		   ELSE LENGTH(people_fully_vaccinated_per_hundred) 
	  
      END = (SELECT MAX(CASE WHEN people_fully_vaccinated_per_hundred LIKE "-%.%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 2) 
							 WHEN people_fully_vaccinated_per_hundred LIKE "-%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 1)
							 WHEN people_fully_vaccinated_per_hundred LIKE "%.%" THEN (LENGTH(people_fully_vaccinated_per_hundred) - 1) 
							 ELSE LENGTH(people_fully_vaccinated_per_hundred) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(total_boosters_per_hundred) AS max_len_num_total_boosters_per_hundred, 
       LENGTH(total_boosters_per_hundred) AS total_char_len,
       CASE 
           WHEN total_boosters_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_boosters_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN total_boosters_per_hundred LIKE "-%.%" THEN (LENGTH(total_boosters_per_hundred) - 2) 
           WHEN total_boosters_per_hundred LIKE "-%" THEN (LENGTH(total_boosters_per_hundred) - 1)
           WHEN total_boosters_per_hundred LIKE "%.%" THEN (LENGTH(total_boosters_per_hundred) - 1) 
		   ELSE LENGTH(total_boosters_per_hundred) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN total_boosters_per_hundred LIKE "-%.%" THEN (LENGTH(total_boosters_per_hundred) - 2) 
		   WHEN total_boosters_per_hundred LIKE "-%" THEN (LENGTH(total_boosters_per_hundred) - 1)
		   WHEN total_boosters_per_hundred LIKE "%.%" THEN (LENGTH(total_boosters_per_hundred) - 1) 
		   ELSE LENGTH(total_boosters_per_hundred) 
	  
      END = (SELECT MAX(CASE WHEN total_boosters_per_hundred LIKE "-%.%" THEN (LENGTH(total_boosters_per_hundred) - 2) 
							 WHEN total_boosters_per_hundred LIKE "-%" THEN (LENGTH(total_boosters_per_hundred) - 1)
							 WHEN total_boosters_per_hundred LIKE "%.%" THEN (LENGTH(total_boosters_per_hundred) - 1) 
							 ELSE LENGTH(total_boosters_per_hundred) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(new_people_vaccinated_smoothed_per_hundred) AS max_len_num_new_people_vaccinated_smoothed_per_hundred, 
       LENGTH(new_people_vaccinated_smoothed_per_hundred) AS total_char_len,
       CASE 
           WHEN new_people_vaccinated_smoothed_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN new_people_vaccinated_smoothed_per_hundred LIKE "-%.%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 2) 
           WHEN new_people_vaccinated_smoothed_per_hundred LIKE "-%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 1)
           WHEN new_people_vaccinated_smoothed_per_hundred LIKE "%.%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 1) 
		   ELSE LENGTH(new_people_vaccinated_smoothed_per_hundred) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN new_people_vaccinated_smoothed_per_hundred LIKE "-%.%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 2) 
		   WHEN new_people_vaccinated_smoothed_per_hundred LIKE "-%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 1)
		   WHEN new_people_vaccinated_smoothed_per_hundred LIKE "%.%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 1) 
		   ELSE LENGTH(new_people_vaccinated_smoothed_per_hundred) 
	  
      END = (SELECT MAX(CASE WHEN new_people_vaccinated_smoothed_per_hundred LIKE "-%.%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 2) 
							 WHEN new_people_vaccinated_smoothed_per_hundred LIKE "-%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 1)
							 WHEN new_people_vaccinated_smoothed_per_hundred LIKE "%.%" THEN (LENGTH(new_people_vaccinated_smoothed_per_hundred) - 1) 
							 ELSE LENGTH(new_people_vaccinated_smoothed_per_hundred) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(stringency_index) AS max_len_num_stringency_index, 
       LENGTH(stringency_index) AS total_char_len,
       CASE 
           WHEN stringency_index LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(stringency_index, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN stringency_index LIKE "-%.%" THEN (LENGTH(stringency_index) - 2) 
           WHEN stringency_index LIKE "-%" THEN (LENGTH(stringency_index) - 1)
           WHEN stringency_index LIKE "%.%" THEN (LENGTH(stringency_index) - 1) 
		   ELSE LENGTH(stringency_index) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN stringency_index LIKE "-%.%" THEN (LENGTH(stringency_index) - 2) 
		   WHEN stringency_index LIKE "-%" THEN (LENGTH(stringency_index) - 1)
		   WHEN stringency_index LIKE "%.%" THEN (LENGTH(stringency_index) - 1) 
		   ELSE LENGTH(stringency_index) 
	  
      END = (SELECT MAX(CASE WHEN stringency_index LIKE "-%.%" THEN (LENGTH(stringency_index) - 2) 
							 WHEN stringency_index LIKE "-%" THEN (LENGTH(stringency_index) - 1)
							 WHEN stringency_index LIKE "%.%" THEN (LENGTH(stringency_index) - 1) 
							 ELSE LENGTH(stringency_index) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(population_density) AS max_len_num_population_density, 
       LENGTH(population_density) AS total_char_len,
       CASE 
           WHEN population_density LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(population_density, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN population_density LIKE "-%.%" THEN (LENGTH(population_density) - 2) 
           WHEN population_density LIKE "-%" THEN (LENGTH(population_density) - 1)
           WHEN population_density LIKE "%.%" THEN (LENGTH(population_density) - 1) 
		   ELSE LENGTH(population_density) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN population_density LIKE "-%.%" THEN (LENGTH(population_density) - 2) 
		   WHEN population_density LIKE "-%" THEN (LENGTH(population_density) - 1)
		   WHEN population_density LIKE "%.%" THEN (LENGTH(population_density) - 1) 
		   ELSE LENGTH(population_density) 
	  
      END = (SELECT MAX(CASE WHEN population_density LIKE "-%.%" THEN (LENGTH(population_density) - 2) 
							 WHEN population_density LIKE "-%" THEN (LENGTH(population_density) - 1)
							 WHEN population_density LIKE "%.%" THEN (LENGTH(population_density) - 1) 
							 ELSE LENGTH(population_density) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(median_age) AS max_len_num_median_age, 
       LENGTH(median_age) AS total_char_len,
       CASE 
           WHEN median_age LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(median_age, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN median_age LIKE "-%.%" THEN (LENGTH(median_age) - 2) 
           WHEN median_age LIKE "-%" THEN (LENGTH(median_age) - 1)
           WHEN median_age LIKE "%.%" THEN (LENGTH(median_age) - 1) 
		   ELSE LENGTH(median_age) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN median_age LIKE "-%.%" THEN (LENGTH(median_age) - 2) 
		   WHEN median_age LIKE "-%" THEN (LENGTH(median_age) - 1)
		   WHEN median_age LIKE "%.%" THEN (LENGTH(median_age) - 1) 
		   ELSE LENGTH(median_age) 
	  
      END = (SELECT MAX(CASE WHEN median_age LIKE "-%.%" THEN (LENGTH(median_age) - 2) 
							 WHEN median_age LIKE "-%" THEN (LENGTH(median_age) - 1)
							 WHEN median_age LIKE "%.%" THEN (LENGTH(median_age) - 1) 
							 ELSE LENGTH(median_age) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(aged_65_older) AS max_len_num_aged_65_older, 
       LENGTH(aged_65_older) AS total_char_len,
       CASE 
           WHEN aged_65_older LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(aged_65_older, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN aged_65_older LIKE "-%.%" THEN (LENGTH(aged_65_older) - 2) 
           WHEN aged_65_older LIKE "-%" THEN (LENGTH(aged_65_older) - 1)
           WHEN aged_65_older LIKE "%.%" THEN (LENGTH(aged_65_older) - 1) 
		   ELSE LENGTH(aged_65_older) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN aged_65_older LIKE "-%.%" THEN (LENGTH(aged_65_older) - 2) 
		   WHEN aged_65_older LIKE "-%" THEN (LENGTH(aged_65_older) - 1)
		   WHEN aged_65_older LIKE "%.%" THEN (LENGTH(aged_65_older) - 1) 
		   ELSE LENGTH(aged_65_older) 
	  
      END = (SELECT MAX(CASE WHEN aged_65_older LIKE "-%.%" THEN (LENGTH(aged_65_older) - 2) 
							 WHEN aged_65_older LIKE "-%" THEN (LENGTH(aged_65_older) - 1)
							 WHEN aged_65_older LIKE "%.%" THEN (LENGTH(aged_65_older) - 1) 
							 ELSE LENGTH(aged_65_older) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(aged_70_older) AS max_len_num_aged_70_older, 
       LENGTH(aged_70_older) AS total_char_len,
       CASE 
           WHEN aged_70_older LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(aged_70_older, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN aged_70_older LIKE "-%.%" THEN (LENGTH(aged_70_older) - 2) 
           WHEN aged_70_older LIKE "-%" THEN (LENGTH(aged_70_older) - 1)
           WHEN aged_70_older LIKE "%.%" THEN (LENGTH(aged_70_older) - 1) 
		   ELSE LENGTH(aged_70_older) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN aged_70_older LIKE "-%.%" THEN (LENGTH(aged_70_older) - 2) 
		   WHEN aged_70_older LIKE "-%" THEN (LENGTH(aged_70_older) - 1)
		   WHEN aged_70_older LIKE "%.%" THEN (LENGTH(aged_70_older) - 1) 
		   ELSE LENGTH(aged_70_older) 
	  
      END = (SELECT MAX(CASE WHEN aged_70_older LIKE "-%.%" THEN (LENGTH(aged_70_older) - 2) 
							 WHEN aged_70_older LIKE "-%" THEN (LENGTH(aged_70_older) - 1)
							 WHEN aged_70_older LIKE "%.%" THEN (LENGTH(aged_70_older) - 1) 
							 ELSE LENGTH(aged_70_older) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(gdp_per_capita) AS max_len_num_gdp_per_capita, 
       LENGTH(gdp_per_capita) AS total_char_len,
       CASE 
           WHEN gdp_per_capita LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(gdp_per_capita, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN gdp_per_capita LIKE "-%.%" THEN (LENGTH(gdp_per_capita) - 2) 
           WHEN gdp_per_capita LIKE "-%" THEN (LENGTH(gdp_per_capita) - 1)
           WHEN gdp_per_capita LIKE "%.%" THEN (LENGTH(gdp_per_capita) - 1) 
		   ELSE LENGTH(gdp_per_capita) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN gdp_per_capita LIKE "-%.%" THEN (LENGTH(gdp_per_capita) - 2) 
		   WHEN gdp_per_capita LIKE "-%" THEN (LENGTH(gdp_per_capita) - 1)
		   WHEN gdp_per_capita LIKE "%.%" THEN (LENGTH(gdp_per_capita) - 1) 
		   ELSE LENGTH(gdp_per_capita) 
	  
      END = (SELECT MAX(CASE WHEN gdp_per_capita LIKE "-%.%" THEN (LENGTH(gdp_per_capita) - 2) 
							 WHEN gdp_per_capita LIKE "-%" THEN (LENGTH(gdp_per_capita) - 1)
							 WHEN gdp_per_capita LIKE "%.%" THEN (LENGTH(gdp_per_capita) - 1) 
							 ELSE LENGTH(gdp_per_capita) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(extreme_poverty) AS max_len_num_extreme_poverty, 
       LENGTH(extreme_poverty) AS total_char_len,
       CASE 
           WHEN extreme_poverty LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(extreme_poverty, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN extreme_poverty LIKE "-%.%" THEN (LENGTH(extreme_poverty) - 2) 
           WHEN extreme_poverty LIKE "-%" THEN (LENGTH(extreme_poverty) - 1)
           WHEN extreme_poverty LIKE "%.%" THEN (LENGTH(extreme_poverty) - 1) 
		   ELSE LENGTH(extreme_poverty) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN extreme_poverty LIKE "-%.%" THEN (LENGTH(extreme_poverty) - 2) 
		   WHEN extreme_poverty LIKE "-%" THEN (LENGTH(extreme_poverty) - 1)
		   WHEN extreme_poverty LIKE "%.%" THEN (LENGTH(extreme_poverty) - 1) 
		   ELSE LENGTH(extreme_poverty) 
	  
      END = (SELECT MAX(CASE WHEN extreme_poverty LIKE "-%.%" THEN (LENGTH(extreme_poverty) - 2) 
							 WHEN extreme_poverty LIKE "-%" THEN (LENGTH(extreme_poverty) - 1)
							 WHEN extreme_poverty LIKE "%.%" THEN (LENGTH(extreme_poverty) - 1) 
							 ELSE LENGTH(extreme_poverty) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(cardiovasc_death_rate) AS max_len_num_cardiovasc_death_rate, 
       LENGTH(cardiovasc_death_rate) AS total_char_len,
       CASE 
           WHEN cardiovasc_death_rate LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(cardiovasc_death_rate, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN cardiovasc_death_rate LIKE "-%.%" THEN (LENGTH(cardiovasc_death_rate) - 2) 
           WHEN cardiovasc_death_rate LIKE "-%" THEN (LENGTH(cardiovasc_death_rate) - 1)
           WHEN cardiovasc_death_rate LIKE "%.%" THEN (LENGTH(cardiovasc_death_rate) - 1) 
		   ELSE LENGTH(cardiovasc_death_rate) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN cardiovasc_death_rate LIKE "-%.%" THEN (LENGTH(cardiovasc_death_rate) - 2) 
		   WHEN cardiovasc_death_rate LIKE "-%" THEN (LENGTH(cardiovasc_death_rate) - 1)
		   WHEN cardiovasc_death_rate LIKE "%.%" THEN (LENGTH(cardiovasc_death_rate) - 1) 
		   ELSE LENGTH(cardiovasc_death_rate) 
	  
      END = (SELECT MAX(CASE WHEN cardiovasc_death_rate LIKE "-%.%" THEN (LENGTH(cardiovasc_death_rate) - 2) 
							 WHEN cardiovasc_death_rate LIKE "-%" THEN (LENGTH(cardiovasc_death_rate) - 1)
							 WHEN cardiovasc_death_rate LIKE "%.%" THEN (LENGTH(cardiovasc_death_rate) - 1) 
							 ELSE LENGTH(cardiovasc_death_rate) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(diabetes_prevalence) AS max_len_num_diabetes_prevalence, 
       LENGTH(diabetes_prevalence) AS total_char_len,
       CASE 
           WHEN diabetes_prevalence LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(diabetes_prevalence, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN diabetes_prevalence LIKE "-%.%" THEN (LENGTH(diabetes_prevalence) - 2) 
           WHEN diabetes_prevalence LIKE "-%" THEN (LENGTH(diabetes_prevalence) - 1)
           WHEN diabetes_prevalence LIKE "%.%" THEN (LENGTH(diabetes_prevalence) - 1) 
		   ELSE LENGTH(diabetes_prevalence) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN diabetes_prevalence LIKE "-%.%" THEN (LENGTH(diabetes_prevalence) - 2) 
		   WHEN diabetes_prevalence LIKE "-%" THEN (LENGTH(diabetes_prevalence) - 1)
		   WHEN diabetes_prevalence LIKE "%.%" THEN (LENGTH(diabetes_prevalence) - 1) 
		   ELSE LENGTH(diabetes_prevalence) 
	  
      END = (SELECT MAX(CASE WHEN diabetes_prevalence LIKE "-%.%" THEN (LENGTH(diabetes_prevalence) - 2) 
							 WHEN diabetes_prevalence LIKE "-%" THEN (LENGTH(diabetes_prevalence) - 1)
							 WHEN diabetes_prevalence LIKE "%.%" THEN (LENGTH(diabetes_prevalence) - 1) 
							 ELSE LENGTH(diabetes_prevalence) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(female_smokers) AS max_len_num_female_smokers, 
       LENGTH(female_smokers) AS total_char_len,
       CASE 
           WHEN female_smokers LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(female_smokers, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN female_smokers LIKE "-%.%" THEN (LENGTH(female_smokers) - 2) 
           WHEN female_smokers LIKE "-%" THEN (LENGTH(female_smokers) - 1)
           WHEN female_smokers LIKE "%.%" THEN (LENGTH(female_smokers) - 1) 
		   ELSE LENGTH(female_smokers) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN female_smokers LIKE "-%.%" THEN (LENGTH(female_smokers) - 2) 
		   WHEN female_smokers LIKE "-%" THEN (LENGTH(female_smokers) - 1)
		   WHEN female_smokers LIKE "%.%" THEN (LENGTH(female_smokers) - 1) 
		   ELSE LENGTH(female_smokers) 
	  
      END = (SELECT MAX(CASE WHEN female_smokers LIKE "-%.%" THEN (LENGTH(female_smokers) - 2) 
							 WHEN female_smokers LIKE "-%" THEN (LENGTH(female_smokers) - 1)
							 WHEN female_smokers LIKE "%.%" THEN (LENGTH(female_smokers) - 1) 
							 ELSE LENGTH(female_smokers) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(male_smokers) AS max_len_num_male_smokers, 
       LENGTH(male_smokers) AS total_char_len,
       CASE 
           WHEN male_smokers LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(male_smokers, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN male_smokers LIKE "-%.%" THEN (LENGTH(male_smokers) - 2) 
           WHEN male_smokers LIKE "-%" THEN (LENGTH(male_smokers) - 1)
           WHEN male_smokers LIKE "%.%" THEN (LENGTH(male_smokers) - 1) 
		   ELSE LENGTH(male_smokers) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN male_smokers LIKE "-%.%" THEN (LENGTH(male_smokers) - 2) 
		   WHEN male_smokers LIKE "-%" THEN (LENGTH(male_smokers) - 1)
		   WHEN male_smokers LIKE "%.%" THEN (LENGTH(male_smokers) - 1) 
		   ELSE LENGTH(male_smokers) 
	  
      END = (SELECT MAX(CASE WHEN male_smokers LIKE "-%.%" THEN (LENGTH(male_smokers) - 2) 
							 WHEN male_smokers LIKE "-%" THEN (LENGTH(male_smokers) - 1)
							 WHEN male_smokers LIKE "%.%" THEN (LENGTH(male_smokers) - 1) 
							 ELSE LENGTH(male_smokers) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(handwashing_facilities) AS max_len_num_handwashing_facilities, 
       LENGTH(handwashing_facilities) AS total_char_len,
       CASE 
           WHEN handwashing_facilities LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(handwashing_facilities, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN handwashing_facilities LIKE "-%.%" THEN (LENGTH(handwashing_facilities) - 2) 
           WHEN handwashing_facilities LIKE "-%" THEN (LENGTH(handwashing_facilities) - 1)
           WHEN handwashing_facilities LIKE "%.%" THEN (LENGTH(handwashing_facilities) - 1) 
		   ELSE LENGTH(handwashing_facilities) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN handwashing_facilities LIKE "-%.%" THEN (LENGTH(handwashing_facilities) - 2) 
		   WHEN handwashing_facilities LIKE "-%" THEN (LENGTH(handwashing_facilities) - 1)
		   WHEN handwashing_facilities LIKE "%.%" THEN (LENGTH(handwashing_facilities) - 1) 
		   ELSE LENGTH(handwashing_facilities) 
	  
      END = (SELECT MAX(CASE WHEN handwashing_facilities LIKE "-%.%" THEN (LENGTH(handwashing_facilities) - 2) 
							 WHEN handwashing_facilities LIKE "-%" THEN (LENGTH(handwashing_facilities) - 1)
							 WHEN handwashing_facilities LIKE "%.%" THEN (LENGTH(handwashing_facilities) - 1) 
							 ELSE LENGTH(handwashing_facilities) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(hospital_beds_per_thousand) AS max_len_num_hospital_beds_per_thousand, 
       LENGTH(hospital_beds_per_thousand) AS total_char_len,
       CASE 
           WHEN hospital_beds_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN hospital_beds_per_thousand LIKE "-%.%" THEN (LENGTH(hospital_beds_per_thousand) - 2) 
           WHEN hospital_beds_per_thousand LIKE "-%" THEN (LENGTH(hospital_beds_per_thousand) - 1)
           WHEN hospital_beds_per_thousand LIKE "%.%" THEN (LENGTH(hospital_beds_per_thousand) - 1) 
		   ELSE LENGTH(hospital_beds_per_thousand) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN hospital_beds_per_thousand LIKE "-%.%" THEN (LENGTH(hospital_beds_per_thousand) - 2) 
		   WHEN hospital_beds_per_thousand LIKE "-%" THEN (LENGTH(hospital_beds_per_thousand) - 1)
		   WHEN hospital_beds_per_thousand LIKE "%.%" THEN (LENGTH(hospital_beds_per_thousand) - 1) 
		   ELSE LENGTH(hospital_beds_per_thousand) 
	  
      END = (SELECT MAX(CASE WHEN hospital_beds_per_thousand LIKE "-%.%" THEN (LENGTH(hospital_beds_per_thousand) - 2) 
							 WHEN hospital_beds_per_thousand LIKE "-%" THEN (LENGTH(hospital_beds_per_thousand) - 1)
							 WHEN hospital_beds_per_thousand LIKE "%.%" THEN (LENGTH(hospital_beds_per_thousand) - 1) 
							 ELSE LENGTH(hospital_beds_per_thousand) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(life_expectancy) AS max_len_num_life_expectancy, 
       LENGTH(life_expectancy) AS total_char_len,
       CASE 
           WHEN life_expectancy LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(life_expectancy, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN life_expectancy LIKE "-%.%" THEN (LENGTH(life_expectancy) - 2) 
           WHEN life_expectancy LIKE "-%" THEN (LENGTH(life_expectancy) - 1)
           WHEN life_expectancy LIKE "%.%" THEN (LENGTH(life_expectancy) - 1) 
		   ELSE LENGTH(life_expectancy) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN life_expectancy LIKE "-%.%" THEN (LENGTH(life_expectancy) - 2) 
		   WHEN life_expectancy LIKE "-%" THEN (LENGTH(life_expectancy) - 1)
		   WHEN life_expectancy LIKE "%.%" THEN (LENGTH(life_expectancy) - 1) 
		   ELSE LENGTH(life_expectancy) 
	  
      END = (SELECT MAX(CASE WHEN life_expectancy LIKE "-%.%" THEN (LENGTH(life_expectancy) - 2) 
							 WHEN life_expectancy LIKE "-%" THEN (LENGTH(life_expectancy) - 1)
							 WHEN life_expectancy LIKE "%.%" THEN (LENGTH(life_expectancy) - 1) 
							 ELSE LENGTH(life_expectancy) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(human_development_index) AS max_len_num_human_development_index, 
       LENGTH(human_development_index) AS total_char_len,
       CASE 
           WHEN human_development_index LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(human_development_index, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN human_development_index LIKE "-%.%" THEN (LENGTH(human_development_index) - 2) 
           WHEN human_development_index LIKE "-%" THEN (LENGTH(human_development_index) - 1)
           WHEN human_development_index LIKE "%.%" THEN (LENGTH(human_development_index) - 1) 
		   ELSE LENGTH(human_development_index) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN human_development_index LIKE "-%.%" THEN (LENGTH(human_development_index) - 2) 
		   WHEN human_development_index LIKE "-%" THEN (LENGTH(human_development_index) - 1)
		   WHEN human_development_index LIKE "%.%" THEN (LENGTH(human_development_index) - 1) 
		   ELSE LENGTH(human_development_index) 
	  
      END = (SELECT MAX(CASE WHEN human_development_index LIKE "-%.%" THEN (LENGTH(human_development_index) - 2) 
							 WHEN human_development_index LIKE "-%" THEN (LENGTH(human_development_index) - 1)
							 WHEN human_development_index LIKE "%.%" THEN (LENGTH(human_development_index) - 1) 
							 ELSE LENGTH(human_development_index) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality_cumulative_absolute) AS max_len_num_excess_mortality_cumulative_absolute, 
       LENGTH(excess_mortality_cumulative_absolute) AS total_char_len,
       CASE 
           WHEN excess_mortality_cumulative_absolute LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN excess_mortality_cumulative_absolute LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 2) 
           WHEN excess_mortality_cumulative_absolute LIKE "-%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 1)
           WHEN excess_mortality_cumulative_absolute LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 1) 
		   ELSE LENGTH(excess_mortality_cumulative_absolute) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN excess_mortality_cumulative_absolute LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 2) 
		   WHEN excess_mortality_cumulative_absolute LIKE "-%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 1)
		   WHEN excess_mortality_cumulative_absolute LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 1) 
		   ELSE LENGTH(excess_mortality_cumulative_absolute) 
	  
      END = (SELECT MAX(CASE WHEN excess_mortality_cumulative_absolute LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 2) 
							 WHEN excess_mortality_cumulative_absolute LIKE "-%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 1)
							 WHEN excess_mortality_cumulative_absolute LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative_absolute) - 1) 
							 ELSE LENGTH(excess_mortality_cumulative_absolute) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality_cumulative) AS max_len_num_excess_mortality_cumulative, 
       LENGTH(excess_mortality_cumulative) AS total_char_len,
       CASE 
           WHEN excess_mortality_cumulative LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality_cumulative, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN excess_mortality_cumulative LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative) - 2) 
           WHEN excess_mortality_cumulative LIKE "-%" THEN (LENGTH(excess_mortality_cumulative) - 1)
           WHEN excess_mortality_cumulative LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative) - 1) 
		   ELSE LENGTH(excess_mortality_cumulative) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN excess_mortality_cumulative LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative) - 2) 
		   WHEN excess_mortality_cumulative LIKE "-%" THEN (LENGTH(excess_mortality_cumulative) - 1)
		   WHEN excess_mortality_cumulative LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative) - 1) 
		   ELSE LENGTH(excess_mortality_cumulative) 
	  
      END = (SELECT MAX(CASE WHEN excess_mortality_cumulative LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative) - 2) 
							 WHEN excess_mortality_cumulative LIKE "-%" THEN (LENGTH(excess_mortality_cumulative) - 1)
							 WHEN excess_mortality_cumulative LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative) - 1) 
							 ELSE LENGTH(excess_mortality_cumulative) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality) AS max_len_num_excess_mortality, 
       LENGTH(excess_mortality) AS total_char_len,
       CASE 
           WHEN excess_mortality LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN excess_mortality LIKE "-%.%" THEN (LENGTH(excess_mortality) - 2) 
           WHEN excess_mortality LIKE "-%" THEN (LENGTH(excess_mortality) - 1)
           WHEN excess_mortality LIKE "%.%" THEN (LENGTH(excess_mortality) - 1) 
		   ELSE LENGTH(excess_mortality) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN excess_mortality LIKE "-%.%" THEN (LENGTH(excess_mortality) - 2) 
		   WHEN excess_mortality LIKE "-%" THEN (LENGTH(excess_mortality) - 1)
		   WHEN excess_mortality LIKE "%.%" THEN (LENGTH(excess_mortality) - 1) 
		   ELSE LENGTH(excess_mortality) 
	  
      END = (SELECT MAX(CASE WHEN excess_mortality LIKE "-%.%" THEN (LENGTH(excess_mortality) - 2) 
							 WHEN excess_mortality LIKE "-%" THEN (LENGTH(excess_mortality) - 1)
							 WHEN excess_mortality LIKE "%.%" THEN (LENGTH(excess_mortality) - 1) 
							 ELSE LENGTH(excess_mortality) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality_cumulative_per_million) AS max_len_num_excess_mortality_cumulative_per_million, 
       LENGTH(excess_mortality_cumulative_per_million) AS total_char_len,
       CASE 
           WHEN excess_mortality_cumulative_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,

       CASE
           WHEN excess_mortality_cumulative_per_million LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 2) 
           WHEN excess_mortality_cumulative_per_million LIKE "-%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 1)
           WHEN excess_mortality_cumulative_per_million LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 1) 
		   ELSE LENGTH(excess_mortality_cumulative_per_million) END AS MAX_total_digit_len

FROM data_load

WHERE CASE WHEN excess_mortality_cumulative_per_million LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 2) 
		   WHEN excess_mortality_cumulative_per_million LIKE "-%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 1)
		   WHEN excess_mortality_cumulative_per_million LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 1) 
		   ELSE LENGTH(excess_mortality_cumulative_per_million) 
	  
      END = (SELECT MAX(CASE WHEN excess_mortality_cumulative_per_million LIKE "-%.%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 2) 
							 WHEN excess_mortality_cumulative_per_million LIKE "-%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 1)
							 WHEN excess_mortality_cumulative_per_million LIKE "%.%" THEN (LENGTH(excess_mortality_cumulative_per_million) - 1) 
							 ELSE LENGTH(excess_mortality_cumulative_per_million) END)
			 FROM data_load)
         
ORDER BY decimal_number ASC;



-- B) Scale - MAX Length:
SELECT DISTINCT(new_cases_smoothed) AS max_len_num_new_cases_smoothed, 
       CASE 
           WHEN new_cases_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1))

      END = (SELECT MAX(CASE WHEN new_cases_smoothed NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_deaths_smoothed) AS max_len_num_new_deaths_smoothed, 
       CASE 
           WHEN new_deaths_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_deaths_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_deaths_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_deaths_smoothed, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_deaths_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_deaths_smoothed, '.', -1))

      END = (SELECT MAX(CASE WHEN new_deaths_smoothed NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_deaths_smoothed, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(total_cases_per_million) AS max_len_num_total_cases_per_million, 
       CASE 
           WHEN total_cases_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_cases_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN total_cases_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_cases_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN total_cases_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_cases_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN total_cases_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(total_cases_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_cases_per_million) AS max_len_num_new_cases_per_million, 
       CASE 
           WHEN new_cases_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_cases_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_cases_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN new_cases_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_cases_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_cases_smoothed_per_million) AS max_len_num_new_cases_smoothed_per_million, 
       CASE 
           WHEN new_cases_smoothed_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_cases_smoothed_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_cases_smoothed_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN new_cases_smoothed_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_cases_smoothed_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(total_deaths_per_million) AS max_len_num_total_deaths_per_million, 
       CASE 
           WHEN total_deaths_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_deaths_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN total_deaths_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_deaths_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN total_deaths_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_deaths_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN total_deaths_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(total_deaths_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_deaths_per_million) AS max_len_num_new_deaths_per_million, 
       CASE 
           WHEN new_deaths_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_deaths_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_deaths_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_deaths_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_deaths_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_deaths_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN new_deaths_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_deaths_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_deaths_smoothed_per_million) AS max_len_num_new_deaths_smoothed_per_million, 
       CASE 
           WHEN new_deaths_smoothed_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_deaths_smoothed_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_deaths_smoothed_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN new_deaths_smoothed_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_deaths_smoothed_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(reproduction_rate) AS max_len_num_reproduction_rate, 
       CASE 
           WHEN reproduction_rate LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(reproduction_rate, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN reproduction_rate NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(reproduction_rate, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN reproduction_rate NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(reproduction_rate, '.', -1))

      END = (SELECT MAX(CASE WHEN reproduction_rate NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(reproduction_rate, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(icu_patients_per_million) AS max_len_num_icu_patients_per_million, 
       CASE 
           WHEN icu_patients_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(icu_patients_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN icu_patients_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(icu_patients_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN icu_patients_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(icu_patients_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN icu_patients_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(icu_patients_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(hosp_patients_per_million) AS max_len_num_hosp_patients_per_million, 
       CASE 
           WHEN hosp_patients_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(hosp_patients_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN hosp_patients_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(hosp_patients_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN hosp_patients_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(hosp_patients_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN hosp_patients_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(hosp_patients_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(weekly_icu_admissions_per_million) AS max_len_num_weekly_icu_admissions_per_million, 
       CASE 
           WHEN weekly_icu_admissions_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN weekly_icu_admissions_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN weekly_icu_admissions_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN weekly_icu_admissions_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(weekly_icu_admissions_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(weekly_hosp_admissions_per_million) AS max_len_num_weekly_hosp_admissions_per_million, 
       CASE 
           WHEN weekly_hosp_admissions_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN weekly_hosp_admissions_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN weekly_hosp_admissions_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN weekly_hosp_admissions_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(weekly_hosp_admissions_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(total_tests_per_thousand) AS max_len_num_total_tests_per_thousand, 
       CASE 
           WHEN total_tests_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_tests_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN total_tests_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_tests_per_thousand, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN total_tests_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_tests_per_thousand, '.', -1))

      END = (SELECT MAX(CASE WHEN total_tests_per_thousand NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(total_tests_per_thousand, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_tests_per_thousand) AS max_len_num_new_tests_per_thousand, 
       CASE 
           WHEN new_tests_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_tests_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_tests_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_tests_per_thousand, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_tests_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_tests_per_thousand, '.', -1))

      END = (SELECT MAX(CASE WHEN new_tests_per_thousand NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_tests_per_thousand, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_tests_smoothed) AS max_len_num_new_tests_smoothed, 
       CASE 
           WHEN new_tests_smoothed LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_tests_smoothed, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_tests_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_tests_smoothed, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_tests_smoothed NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_tests_smoothed, '.', -1))

      END = (SELECT MAX(CASE WHEN new_tests_smoothed NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_tests_smoothed, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;
-- Important! The new_tests_smoothed feature was mistakenly assumed to be a numerical continuous feature in the Metadata_Report.xlsm file. 
-- The new_tests_smoothed feature is actually a numerically discrete feature.
-- There is no need to update the query. The query will be left as is.


SELECT DISTINCT(new_tests_smoothed_per_thousand) AS max_len_num_new_tests_smoothed_per_thousand, 
       CASE 
           WHEN new_tests_smoothed_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_tests_smoothed_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_tests_smoothed_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', -1))

      END = (SELECT MAX(CASE WHEN new_tests_smoothed_per_thousand NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_tests_smoothed_per_thousand, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(positive_rate) AS max_len_num_positive_rate, 
       CASE 
           WHEN positive_rate LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(positive_rate, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN positive_rate NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(positive_rate, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN positive_rate NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(positive_rate, '.', -1))

      END = (SELECT MAX(CASE WHEN positive_rate NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(positive_rate, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(tests_per_case) AS max_len_num_tests_per_case, 
       CASE 
           WHEN tests_per_case LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(tests_per_case, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN tests_per_case NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(tests_per_case, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN tests_per_case NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(tests_per_case, '.', -1))

      END = (SELECT MAX(CASE WHEN tests_per_case NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(tests_per_case, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(total_vaccinations_per_hundred) AS max_len_num_total_vaccinations_per_hundred, 
       CASE 
           WHEN total_vaccinations_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN total_vaccinations_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN total_vaccinations_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', -1))

      END = (SELECT MAX(CASE WHEN total_vaccinations_per_hundred NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(total_vaccinations_per_hundred, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(people_vaccinated_per_hundred) AS max_len_num_people_vaccinated_per_hundred, 
       CASE 
           WHEN people_vaccinated_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN people_vaccinated_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN people_vaccinated_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', -1))

      END = (SELECT MAX(CASE WHEN people_vaccinated_per_hundred NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(people_vaccinated_per_hundred, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(people_fully_vaccinated_per_hundred) AS max_len_num_people_fully_vaccinated_per_hundred, 
       CASE 
           WHEN people_fully_vaccinated_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN people_fully_vaccinated_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN people_fully_vaccinated_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', -1))

      END = (SELECT MAX(CASE WHEN people_fully_vaccinated_per_hundred NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(people_fully_vaccinated_per_hundred, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(total_boosters_per_hundred) AS max_len_num_total_boosters_per_hundred, 
       CASE 
           WHEN total_boosters_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(total_boosters_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN total_boosters_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_boosters_per_hundred, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN total_boosters_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(total_boosters_per_hundred, '.', -1))

      END = (SELECT MAX(CASE WHEN total_boosters_per_hundred NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(total_boosters_per_hundred, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(new_people_vaccinated_smoothed_per_hundred) AS max_len_num_new_people_vaccinated_smoothed_per_hundred, 
       CASE 
           WHEN new_people_vaccinated_smoothed_per_hundred LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN new_people_vaccinated_smoothed_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN new_people_vaccinated_smoothed_per_hundred NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', -1))

      END = (SELECT MAX(CASE WHEN new_people_vaccinated_smoothed_per_hundred NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(new_people_vaccinated_smoothed_per_hundred, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(stringency_index) AS max_len_num_stringency_index, 
       CASE 
           WHEN stringency_index LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(stringency_index, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN stringency_index NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(stringency_index, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN stringency_index NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(stringency_index, '.', -1))

      END = (SELECT MAX(CASE WHEN stringency_index NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(stringency_index, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(population_density) AS max_len_num_population_density, 
       CASE 
           WHEN population_density LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(population_density, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN population_density NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(population_density, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN population_density NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(population_density, '.', -1))

      END = (SELECT MAX(CASE WHEN population_density NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(population_density, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(median_age) AS max_len_num_median_age, 
       CASE 
           WHEN median_age LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(median_age, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN median_age NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(median_age, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN median_age NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(median_age, '.', -1))

      END = (SELECT MAX(CASE WHEN median_age NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(median_age, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(aged_65_older) AS max_len_num_aged_65_older, 
       CASE 
           WHEN aged_65_older LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(aged_65_older, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN aged_65_older NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(aged_65_older, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN aged_65_older NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(aged_65_older, '.', -1))

      END = (SELECT MAX(CASE WHEN aged_65_older NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(aged_65_older, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(aged_70_older) AS max_len_num_aged_70_older, 
       CASE 
           WHEN aged_70_older LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(aged_70_older, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN aged_70_older NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(aged_70_older, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN aged_70_older NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(aged_70_older, '.', -1))

      END = (SELECT MAX(CASE WHEN aged_70_older NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(aged_70_older, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(gdp_per_capita) AS max_len_num_gdp_per_capita, 
       CASE 
           WHEN gdp_per_capita LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(gdp_per_capita, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN gdp_per_capita NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(gdp_per_capita, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN gdp_per_capita NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(gdp_per_capita, '.', -1))

      END = (SELECT MAX(CASE WHEN gdp_per_capita NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(gdp_per_capita, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(extreme_poverty) AS max_len_num_extreme_poverty, 
       CASE 
           WHEN extreme_poverty LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(extreme_poverty, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN extreme_poverty NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(extreme_poverty, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN extreme_poverty NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(extreme_poverty, '.', -1))

      END = (SELECT MAX(CASE WHEN extreme_poverty NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(extreme_poverty, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(cardiovasc_death_rate) AS max_len_num_cardiovasc_death_rate, 
       CASE 
           WHEN cardiovasc_death_rate LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(cardiovasc_death_rate, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN cardiovasc_death_rate NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(cardiovasc_death_rate, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN cardiovasc_death_rate NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(cardiovasc_death_rate, '.', -1))

      END = (SELECT MAX(CASE WHEN cardiovasc_death_rate NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(cardiovasc_death_rate, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(diabetes_prevalence) AS max_len_num_diabetes_prevalence, 
       CASE 
           WHEN diabetes_prevalence LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(diabetes_prevalence, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN diabetes_prevalence NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(diabetes_prevalence, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN diabetes_prevalence NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(diabetes_prevalence, '.', -1))

      END = (SELECT MAX(CASE WHEN diabetes_prevalence NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(diabetes_prevalence, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(female_smokers) AS max_len_num_female_smokers, 
       CASE 
           WHEN female_smokers LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(female_smokers, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN female_smokers NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(female_smokers, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN female_smokers NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(female_smokers, '.', -1))

      END = (SELECT MAX(CASE WHEN female_smokers NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(female_smokers, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(male_smokers) AS max_len_num_male_smokers, 
       CASE 
           WHEN male_smokers LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(male_smokers, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN male_smokers NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(male_smokers, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN male_smokers NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(male_smokers, '.', -1))

      END = (SELECT MAX(CASE WHEN male_smokers NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(male_smokers, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(handwashing_facilities) AS max_len_num_handwashing_facilities, 
       CASE 
           WHEN handwashing_facilities LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(handwashing_facilities, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN handwashing_facilities NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(handwashing_facilities, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN handwashing_facilities NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(handwashing_facilities, '.', -1))

      END = (SELECT MAX(CASE WHEN handwashing_facilities NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(handwashing_facilities, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(hospital_beds_per_thousand) AS max_len_num_hospital_beds_per_thousand, 
       CASE 
           WHEN hospital_beds_per_thousand LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN hospital_beds_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN hospital_beds_per_thousand NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', -1))

      END = (SELECT MAX(CASE WHEN hospital_beds_per_thousand NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(hospital_beds_per_thousand, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(life_expectancy) AS max_len_num_life_expectancy, 
       CASE 
           WHEN life_expectancy LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(life_expectancy, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN life_expectancy NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(life_expectancy, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN life_expectancy NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(life_expectancy, '.', -1))

      END = (SELECT MAX(CASE WHEN life_expectancy NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(life_expectancy, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(human_development_index) AS max_len_num_human_development_index, 
       CASE 
           WHEN human_development_index LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(human_development_index, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN human_development_index NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(human_development_index, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN human_development_index NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(human_development_index, '.', -1))

      END = (SELECT MAX(CASE WHEN human_development_index NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(human_development_index, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality_cumulative_absolute) AS max_len_num_excess_mortality_cumulative_absolute, 
       CASE 
           WHEN excess_mortality_cumulative_absolute LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN excess_mortality_cumulative_absolute NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN excess_mortality_cumulative_absolute NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', -1))

      END = (SELECT MAX(CASE WHEN excess_mortality_cumulative_absolute NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_absolute, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality_cumulative) AS max_len_num_excess_mortality_cumulative, 
       CASE 
           WHEN excess_mortality_cumulative LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality_cumulative, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN excess_mortality_cumulative NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN excess_mortality_cumulative NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative, '.', -1))

      END = (SELECT MAX(CASE WHEN excess_mortality_cumulative NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality) AS max_len_num_excess_mortality, 
       CASE 
           WHEN excess_mortality LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN excess_mortality NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN excess_mortality NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality, '.', -1))

      END = (SELECT MAX(CASE WHEN excess_mortality NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(excess_mortality, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;


SELECT DISTINCT(excess_mortality_cumulative_per_million) AS max_len_num_excess_mortality_cumulative_per_million, 
       CASE 
           WHEN excess_mortality_cumulative_per_million LIKE "%.%" THEN 
		   (CASE WHEN CAST(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', -1) AS SIGNED INT) > 0 THEN "True" ELSE "False" END) 
		   ELSE "False" END AS decimal_number,
                    
       CASE WHEN excess_mortality_cumulative_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', -1)) END AS MAX_decimal_digits_len

FROM data_load
    
WHERE CASE WHEN excess_mortality_cumulative_per_million NOT LIKE "%.%" THEN "" ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', -1))

      END = (SELECT MAX(CASE WHEN excess_mortality_cumulative_per_million NOT LIKE "%.%" THEN "" 
                             ELSE LENGTH(SUBSTRING_INDEX(excess_mortality_cumulative_per_million, '.', -1)) END)
			 FROM data_load)

ORDER BY decimal_number ASC;
-- Important! As observed in 3_LDI_Completeness.sql, another anomaly has been observed in the above query geared towards the excess_mortality_cumulative_per_million feature. 
-- The MAX_decimal_digits_len returns 9 but the correct number of decimal digits when counted is actually 8. 



-- Next Step:
-- 3. Confirm the type-casted fields are equivalent to the original VARCHAR fields with a Boolean feature; do not use the ALTER or UPDATE clause in this step.








