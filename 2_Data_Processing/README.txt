Data Processing - In-progress:

SQL Files: queries followed by respective results for confirmation after running queries.

1) Dataset_Import

2) Dataset_Completeness_Check: 
	-Check missing fields for each feature, aggregate by location/date/continent also.
	-Confirm total fields missing in dataset - confirm with Metadata_Report.xlsm.

3) Data_Preparation: 
	-Missing data will be left as is to determine if correlation exists, with possible causation, b/c of location attributes, e.g., gdp.
	-SQL_Datatype_Assignment: datatypes need to be readjusted via character length of each field.
	-Compare variance in MetadataReport to derive contexual conclusions.

4) Database_Modeling:
	-Setting primary keys.
	-Grouping and connecting tables by relationships.

5) Exploratory Data Analysis (EDA): 
	-Descriptive stats on numerical features
	-Grouping of categorical features

