GIT:
-pull update from remote repo
-rename project file
-rename metadata extraction file as per Dropbox changes
-create new webpage files for quick viewing
-push changes into remote repo
-create new dir for data processing



Data Processing:

SQL Files: queries followed by respective results for confirmation after running queries.

1) Dataset_Import

2) Dataset_Completeness_Check: (EXCEL: the number of blanks/nulls of each feature)
	-Check missing fields for each feature, aggregate by location/date/continent also
	-Confirm total fields missing in dataset

3) Data_Preparation: (EXCEL: max and min field by character length of each feature)
	-Missing data will be left as is
	-SQL_Datatype_Assignment: datatypes need to be readjusted via character length of each field
	-Compare variance in MetadataReport to derive contexual conclusions.

4) Database_Modeling:
	-Setting primary keys
	-Grouping and connecting tables

5) Exploratory Data Analysis (EDA): 
	-Descriptive stats on numerical features
	-Grouping of categorical features


Database Engineering (Database Modelling/Design): watch course videos.
