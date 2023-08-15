-- Resolving Anomaly Feature's Data-type Issue: 

-- Further Analysis of excess_mortality_cumulative_per_million Feature via Type-casting: 

-- Original Data vs. Type-casted Data
SELECT location, _date_, excess_mortality_cumulative_per_million AS original_values FROM data_load; -- Original data
-- Note: The subsequent query has apparently replaced all empty fields with zeroes when being type-casted:
SELECT location, _date_, CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) AS type_casted_values -- This feature has been type-casted into a temporary table.
FROM data_load; 


-- Anomalies with Type-casting the excess_mortality_cumulative_per_million Feature:

-- 1)
SELECT location, _date_, CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) AS char_to_num 
FROM data_load
WHERE excess_mortality_cumulative_per_million = ''; -- There is no output for each feature; there is no option to scroll down.
SELECT COUNT(CASE WHEN CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) = '' THEN 1 END) AS empty_strings_after_type_casting 
FROM data_load; -- As mentioned already, there is no output for each feature, however, the COUNT is of empty strings after type-casting is 288,942 in spite of this.

SELECT location, _date_, CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) AS char_to_num -- This query is congruent with the indicated note above, i.e., all empty fields were replaced with zeroes.
FROM data_load
WHERE excess_mortality_cumulative_per_million = 0;
SELECT COUNT(CASE WHEN CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) = 0 THEN 1 END) AS empty_strings_after_type_casting 
FROM data_load; -- The COUNT of zeroes after type-casting is 288,942.

-- Conclusion: 
-- Number of empty strings = number of zeroes = 288,942; the anomalous queries above serves no purpose except... 
-- 1) that it confirms empty strings are being treated as zeroes, and vice versa, and...
-- 2) the 288,942 empty strings (or zeroes) are only countable (without the use of wildcards) after being type-casted, else the count will be 0 as confirmed earlier.


-- 2) 
SELECT COUNT(CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30))) AS non_zero_values -- No. of values greater than 0 + No. of values less than 0 = 10,295; COUNT-wise, the output is correct.
FROM data_load
WHERE CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) > 0 OR CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) < 0;

SELECT location, _date_, CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) AS non_zero_values -- Returns all values greater than 0, and all values less than 0.
FROM data_load                                                                                       		-- Anomaly! The values greater than and less than 0 are incorrect!
WHERE CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) > 0 OR CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) < 0
ORDER BY location; 

SELECT location, _date_, CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) AS non_zero_values, -- All values are between 1 and -1.
CASE WHEN 1 > CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) > -1 THEN "True" ELSE "False" END AS between_1_and_neg_1
FROM data_load                                                                                       		
WHERE CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) > 0 OR CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30)) < 0
ORDER BY between_1_and_neg_1 ASC; -- Running this query in ASC order will display any False values at the top.
                                  -- However, there are only True values because all values are between 1 and -1.

-- The following query reconfirms the anomaly; excess_mortality_cumulative_per_million correctly consists of values much larger than 1, and values much smaller than -1:
SELECT location, _date_, excess_mortality_cumulative_per_million FROM data_load 
WHERE excess_mortality_cumulative_per_million LIKE '_____.%';

-- Conclusion:
-- Type-casting clearly provides a correct COUNT of NULL and NOT NULL values.
-- However, type-casting the excess_mortality_cumulative_per_million feature is also altering the values of this feature to exist between 1 and -1.
-- IMPORTANT! Be weary when type-casting any features as the cause for this anomaly is unknown at this time.



-- Permanent-alteration Approaches to Resolve Anomaly Feature's Data-type Issue:

SELECT @@GLOBAL.sql_mode; -- Displays the default arguments of the sql_mode variable; 

SET sql_mode = ''; -- Without the GLOBAL variable in this command, this line of code will be active for the current session only, i.e., the change will not persist once the session is closed.
				   -- The current arguments determining the behaviour and strictness have been replaced with an empty string to bypass Error 1366. 
				   -- Without setting sql_mode to '', the UPDATE and ALTER TABLE commands will return the following error response:
				   -- Error Code: 1366. Incorrect DECIMAL value: '0' for column '' at row -1
				   -- According to this error code, the column name is an empty string, the value being modified is invalid, and the error itself is occurring at row -1.
                   -- There is no coherency with the column data and the message associated with this error.
                   
SELECT @@SESSION.sql_mode; -- This query will confirm that the new argument of the current session is an empty string.                   

-- 1) UPDATE Approach:
SELECT location, _date_, excess_mortality_cumulative_per_million FROM data_load;

-- UPDATE Command - Bypassing Error:
-- The following error is displayed when trying to run an UPDATE command.
-- Error Code: 1175. You are using safe update mode and you tried to update a table without a WHERE that uses a KEY column.  
-- To disable safe mode, toggle the option in Preferences -> SQL Editor and reconnect.

-- To enable UPDATE command:
-- Preferences > SQL Editor > "Safe Updates" check box was unchecked > OK. 
-- Query > Reconnect to server

-- IMPORTANT! The following command may have to be run a second time for its execution to be confirmed:
UPDATE data_load SET excess_mortality_cumulative_per_million = CAST(excess_mortality_cumulative_per_million AS DECIMAL(30, 30));

SELECT excess_mortality_cumulative_per_million AS non_zero_values,
CASE WHEN 1 > excess_mortality_cumulative_per_million > -1 THEN "True" ELSE "False" END AS between_1_and_neg_1
FROM data_load                                                                                       		
WHERE (excess_mortality_cumulative_per_million > 0) OR (excess_mortality_cumulative_per_million < 0)
ORDER BY between_1_and_neg_1 ASC; -- To reiterate, running this query in ASC order will result with any False values in the between_1_and_neg_1 column to be at the top.
                                  -- However, there are only True values because all values are between 1 and -1.


-- IMPORTANT! REFRESH! Run all SQL commands from 2_LDI before starting 2):

-- 2) ALTER TABLE Approach:
SET sql_mode = '';
SELECT location, _date_, excess_mortality_cumulative_per_million FROM data_load;

-- IMPORTANT! The following command may have to be run a second time for its execution to be confirmed:
ALTER TABLE data_load MODIFY COLUMN excess_mortality_cumulative_per_million DECIMAL(30, 30);

SELECT excess_mortality_cumulative_per_million AS non_zero_values,
CASE WHEN 1 > excess_mortality_cumulative_per_million > -1 THEN "True" ELSE "False" END AS between_1_and_neg_1
FROM data_load                                                                                       		
WHERE (excess_mortality_cumulative_per_million > 0) OR (excess_mortality_cumulative_per_million < 0)
ORDER BY between_1_and_neg_1 ASC; -- Running this query in ASC order will result with any False values in the between_1_and_neg_1 column to be at the top.
                                  -- However, there are only True values in this column because all values are between 1 and -1.

-- Conclusion:
-- Both the UPDATE and ALTER TABLE approaches yielded the same results as in the case with type-casting the excess_mortality_cumulative_per_million feature.
-- This implies there is likely to be NO issue with the choice of type-casting (CAST function) or the permanently-altering approaches (UPDATE and ALTER TABLE).
-- However, there may be an issue in the data features themselves or the DECIMAL data-type itself. Both routes will be explored to better understand and correct this issue.



