
TDS Consultancy DATA ANALYICS 

 use house_prices_datasets ;
 
 select * from sample_submission ;
 
 select * from test ;
 
select * from  train ;

------------------


TASK 1 

 ' Data cleaning '  for dataset Train 
 
 Steps for Data Cleaning
 
 -- Check for missing values in the train dataset
 
SELECT * FROM train WHERE LotFrontage IS NULL OR Alley IS NULL;

Identify and Remove Outliers
 

SELECT * FROM train WHERE LotArea > (SELECT AVG(LotArea) + 3 * STDDEV(LotArea) FROM train);

Identify Missing Values

SELECT COUNT(*) AS TotalRows,
       SUM(CASE WHEN LotFrontage IS NULL THEN 1 ELSE 0 END) AS MissingLotFrontage,
       SUM(CASE WHEN Alley IS NULL THEN 1 ELSE 0 END) AS MissingAlley
FROM train;

Identify Duplicates:

SELECT Id, COUNT(*)
FROM train
GROUP BY Id
HAVING COUNT(*) > 1;

Standardize Data Types  

ALTER TABLE train
MODIFY SalePrice INT;

Outliers in Categorical Data:

SELECT DISTINCT Neighborhood FROM train;


" Data Cleaning " for " test " dataset


 Steps for Data Cleaning
 
 -- Check for missing values in the train dataset
 
SELECT * FROM test WHERE LotFrontage IS NULL OR Alley IS NULL;

Identify and Remove Outliers
 

SELECT * FROM test WHERE LotArea > (SELECT AVG(LotArea) + 3 * STDDEV(LotArea) FROM train);

Identify Missing Values

SELECT COUNT(*) AS TotalRows,
       SUM(CASE WHEN LotFrontage IS NULL THEN 1 ELSE 0 END) AS MissingLotFrontage,
       SUM(CASE WHEN Alley IS NULL THEN 1 ELSE 0 END) AS MissingAlley
FROM test;

Identify Duplicates:

SELECT Id, COUNT(*)
FROM test
GROUP BY Id
HAVING COUNT(*) > 1;

Standardize Data Types  

ALTER TABLE test
MODIFY LotArea INT;


" Data Cleaning " for " sample_submission " dataset

Check for Missing Values

SELECT COUNT(*) AS TotalRows,
       SUM(CASE WHEN SalePrice IS NULL THEN 1 ELSE 0 END) AS MissingSalePrice
FROM sample_submission;

Query to Identify Duplicates:

SELECT Id, COUNT(*)
FROM sample_submission
GROUP BY Id
HAVING COUNT(*) > 1;

Query to Find Mismatches:

SELECT s.Id
FROM sample_submission s
LEFT JOIN test t ON s.Id = t.Id
WHERE t.Id IS NULL;


Query to Check for Invalid SalePrice Values:

SELECT * FROM sample_submission
WHERE SalePrice < 0;

 Standardize Data Types

ALTER TABLE sample_submission
MODIFY COLUMN SalePrice DECIMAL(10,2);


select * from final_merged_dataset ;


=========================================================================================================================================================

Summary Statistics for Each Dataset

train Dataset

Goal: Get insights into key features, particularly SalePrice (mean, median, standard deviation, etc.).

-- Calculate basic summary statistics for SalePrice in train dataset

SELECT 
    AVG(SalePrice) AS Mean_SalePrice,
    MIN(SalePrice) AS Min_SalePrice,
    MAX(SalePrice) AS Max_SalePrice,
    STDDEV(SalePrice) AS StdDev_SalePrice 
FROM train;


 test Dataset

Goal: Analyze other key features since SalePrice isn’t available in the test dataset.

-- Calculate summary statistics for key numerical features in test dataset

-- Comprehensive summary for SalePrice, LotArea, GrLivArea, and OverallQual in train dataset
SELECT 
    AVG(SalePrice) AS Mean_SalePrice,
    MIN(SalePrice) AS Min_SalePrice,
    MAX(SalePrice) AS Max_SalePrice,
    STDDEV(SalePrice) AS StdDev_SalePrice,
    
    AVG(LotArea) AS Mean_LotArea,
    STDDEV(LotArea) AS StdDev_LotArea,
    
    AVG(GrLivArea) AS Mean_GrLivArea,
    STDDEV(GrLivArea) AS StdDev_GrLivArea,
    
    AVG(OverallQual) AS Mean_OverallQual,
    STDDEV(OverallQual) AS StdDev_OverallQual
FROM train;


sample_submission Dataset

Goal: Analyze the distribution of predicted prices in PredictedSalePrice.

-- Summary statistics for predicted SalePrice in sample_submission
-- Expanded summary for PredictedSalePrice in sample_submission
SELECT 
    AVG(SalePrice) AS Mean_PredictedSalePrice,
    MIN(SalePrice) AS Min_PredictedSalePrice,
    MAX(SalePrice) AS Max_PredictedSalePrice,
    STDDEV(SalePrice) AS StdDev_PredictedSalePrice
FROM sample_submission;


==========================================================================================================================================

PIVOT TABLES 

creating pivot tables 

Average SalePrice by Neighborhood

This can help reveal which neighborhoods tend to have higher or lower house prices.

SELECT Neighborhood, AVG(SalePrice) AS Avg_SalePrice
FROM train
GROUP BY Neighborhood
ORDER BY Avg_SalePrice DESC;

Average SalePrice by HouseStyle and Overall Quality

This shows how house style and quality affect sale prices.

SELECT HouseStyle, OverallQual, AVG(SalePrice) AS Avg_SalePrice
FROM train
GROUP BY HouseStyle, OverallQual
ORDER BY Avg_SalePrice DESC;

Total Count of Houses Sold per Year

Analyzing the volume of sales per year to identify any trends over time.

SELECT YrSold, COUNT(*) AS Total_Houses_Sold
FROM train
GROUP BY YrSold
ORDER BY YrSold;

Count of Houses by CentralAir and Heating Type

Helps understand how common central air conditioning and various heating types are in the dataset.

SELECT CentralAir, Heating, COUNT(*) AS Total_Houses
FROM train
GROUP BY CentralAir, Heating
ORDER BY Total_Houses DESC;


Pivot Tables for test Dataset

Average LotArea and GrLivArea by Neighborhood

Helps compare average lot and living area sizes across neighborhoods.

SELECT Neighborhood, 
       AVG(LotArea) AS Avg_LotArea, 
       AVG(GrLivArea) AS Avg_GrLivArea
FROM test
GROUP BY Neighborhood
ORDER BY Avg_LotArea DESC;

Count of Houses by YearBuilt

See the number of houses built each year, useful for analyzing construction trends.

SELECT YearBuilt, COUNT(*) AS Total_Houses
FROM test
GROUP BY YearBuilt
ORDER BY YearBuilt;

Average OverallQual by HouseStyle

Analyze how overall quality varies with house style.

SELECT HouseStyle, AVG(OverallQual) AS Avg_OverallQual
FROM test
GROUP BY HouseStyle
ORDER BY Avg_OverallQual DESC;


Count of Houses with CentralAir by YearBuilt

Identify how common central air is among houses built in different years.

SELECT YearBuilt, CentralAir, COUNT(*) AS Total_Houses
FROM test
GROUP BY YearBuilt, CentralAir
ORDER BY YearBuilt;

Pivot Table for sample_submission Dataset

SELECT CASE 
           WHEN SalePrice < 100000 THEN 'Under 100K'
           WHEN SalePrice BETWEEN 100000 AND 200000 THEN '100K-200K'
           WHEN SalePrice BETWEEN 200000 AND 300000 THEN '200K-300K'
           ELSE 'Above 300K'
       END AS Price_Range,
       COUNT(*) AS Total_Houses
FROM sample_submission
GROUP BY Price_Range
ORDER BY Price_Range;

---------------------------------------------------------------------------------------------------































