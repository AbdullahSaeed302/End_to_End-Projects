-- |>>| Project - Sales Performance and Customer Retention Analysis (Cleaning Data > START <) |<<| --
# ------------------------------------------------------------------------------------------------- #

/*
Steps on which we should be working with this Project, is as following:
	>> 1. Inspect the Data
	>> 2. Identify Data Quality Issues
	>> 3. Standardize Date Formats
	>> 4. Create New Features for Analysis
*/

-- |>>| STEP 0 - Creating an alternate table (Reason: if there anything mistakely happen with the data-set, we should have available the real one!) |<<| --

## Creating a new table for Customers Data
CREATE TABLE raw_customers_data
LIKE customers_data;

INSERT INTO raw_customers_data
SELECT * FROM customers_data;

RENAME TABLE customers_data
TO cleaned_customers_data;

## Creating a new table for Sales Data
CREATE TABLE raw_sales_data
LIKE sales_data;

INSERT INTO raw_sales_data
SELECT * FROM sales_data;

RENAME TABLE sales_data
TO cleaned_sales_data;

-- |>>| STEP 1 - Inspecting the Data |<<| --

## Basic Inspecting about the tables
DESC cleaned_customers_data;
DESC cleaned_sales_data;

## Inspecting the Customers Data
SELECT *
FROM cleaned_customers_data
LIMIT 10;

## Inspecting the Sales Data
SELECT *
FROM cleaned_sales_data
LIMIT 10;

-- |>>| STEP 2 - Identifying Data Quality Issues |<<| --

## Finding Missing Values in our Data:

## Checking for Missing Records in Customers Data
SELECT 'customers_data' AS TableName,
	COUNT(*) AS Missing_Records
FROM cleaned_customers_data
WHERE
	CustomerID IS NULL OR CustomerName IS NULL OR Location IS NULL;

## Checking for Missing Records in Sales Data
SELECT 'sales_data' AS TableName, 
       COUNT(*) AS Missing_Records 
FROM cleaned_sales_data 
WHERE OrderID IS NULL OR CustomerID IS NULL OR Product IS NULL;

## Finding Duplicate Values in our Data:

## Checking for Duplicate Records in Customers Data
SELECT CustomerID, COUNT(*) AS Duplicate_Values
FROM cleaned_customers_data
GROUP BY CustomerID
HAVING COUNT(*) > 1;

## Checking for Duplicate Records in Sales Data
SELECT OrderID, COUNT(*) AS Duplicate_Values
FROM cleaned_sales_data
GROUP BY OrderID
HAVING COUNT(*) > 1;

-- |>>| STEP 3 - Standardizing Date Formats |<<| --

## Checking current Data Types:
DESC cleaned_customers_data;
DESC cleaned_sales_data;

## Converting Text to DATETIME in Customers Table
ALTER TABLE cleaned_customers_data
MODIFY COLUMN FirstPurchaseDate DATE;

ALTER TABLE cleaned_customers_data
MODIFY COLUMN LastPurchaseDate DATE;

## Converting Text to DATETIME in Sales Table
ALTER TABLE cleaned_sales_data
MODIFY COLUMN OrderDate DATE;

-- |>>| STEP 4 - Creating New Features for Analysis  |<<| --

## Defining Churn Criteria (i.e. Adding 'is_churned' Column)
ALTER TABLE cleaned_customers_data
ADD COLUMN is_churned INT;

UPDATE cleaned_customers_data 
SET is_churned = CASE 
    WHEN LastPurchaseDate < DATE_SUB('2024-01-31', INTERVAL 6 MONTH) THEN 1 
    ELSE 0 
END;

# ----------------------------------------------------------------------------------------------- #
-- |>>| Project - Sales Performance and Customer Retention Analysis (Cleaning Data > END <) |<<| --