-- |>>| Project - Sales Performance and Customer Retention Analysis (Exploratory Data Analysis > START <) |<<| --
# ------------------------------------------------------------------------------------------------------------- #

## Inspecting the Cleaned Data:
SELECT *
FROM cleaned_customers_data;

SELECT *
FROM cleaned_sales_data;


/*
Steps on which we should be working with this Project, is as following:
	>> 1. Understanding the Data
	>> 2. Sales Performance Analysis
	>> 3. Customer Behavior Analysis
    >> 4. Churn Analysis (Retention Insights)
*/


-- |>>| STEP 1 - Understanding the Data |<<| --

## 1. Calculating total customers and total orders!
SELECT
	COUNT(DISTINCT CustomerID) AS Total_Customers,
    COUNT(DISTINCT OrderID) AS Total_Orders
FROM cleaned_sales_data;


## 2. Calculating the timeframe covered in the Dataset!
WITH CTE AS (
	SELECT
		MIN(OrderDate) AS First_Order,
		MAX(OrderDate) AS Last_Order
	FROM cleaned_sales_data
)
	SELECT *, DATEDIFF(Last_Order, First_Order) AS Days_Difference
	FROM CTE;

-- |>>| STEP 2 - Sales Performance Analysis |<<| --

## 1. Calculating the Total Revenue & Profit - (Understanding overall sales performance is crucial for business insights)
WITH CTE AS (
SELECT
	ROUND(SUM(Revenue), 2) AS Total_Revenue,
    ROUND(SUM(Profit), 2) AS Total_Profit
FROM cleaned_sales_data
)
	SELECT
		*,
		ROUND((Total_Revenue - Total_Profit), 2) AS `Cost/Difference`
	FROM CTE;


## 2. Calculating the monthly Sales Trend - (This helps us Analyze seasonal trends in sales)
SELECT
	DATE_FORMAT(OrderDate, '%Y-%m') AS `Month`,
    ROUND(SUM(Revenue), 2) AS Monthly_Revenue
FROM cleaned_sales_data
GROUP BY `Month`
ORDER BY `Month`;


## 3. Calculating the top 5 Products - (Identifies which products are the most in demand)
SELECT
	Product,
    SUM(Quantity) AS Quantity_Sold
FROM cleaned_sales_data
GROUP BY Product
ORDER BY Quantity_Sold DESC
LIMIT 5;


## 4. Calculating the top 3 Categorys - (This helps us identify which Products Categorys are most in demand)
WITH CTE AS (
SELECT
	Category,
    SUM(Quantity) AS Quantity_Sold
FROM cleaned_sales_data
GROUP BY Category
ORDER BY Quantity_Sold DESC
LIMIT 3
)
	SELECT
		*,
		DENSE_RANK() OVER(ORDER BY Quantity_Sold DESC) AS Ranking
	FROM CTE;


## 5. Calculating the top 5 Most Profitable Products - (Shows which products generate the most profit)
SELECT
	Product,
    ROUND(SUM(Profit), 2) AS Profit
FROM cleaned_sales_data
GROUP BY Product
ORDER BY Profit DESC
LIMIT 5;

-- |>>| STEP 3 - Customer Behavior Analysis |<<| --

## 1. Looking for Top Spending Customers - (Helps us find the customers who generate the most revenue)
SELECT
	C.CustomerID,
    C.CustomerName,
	ROUND(SUM(S.Revenue), 2) AS Total_Spent
FROM cleaned_sales_data S
JOIN cleaned_customers_data C
	ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY Total_Spent DESC
LIMIT 5;


## 2. Looking for Customers with the Most Orders - (This shows the most loyal customers)
SELECT
	C.CustomerID,
    C.CustomerName,
	COUNT(S.OrderID) AS Total_Orders
FROM cleaned_sales_data S
JOIN cleaned_customers_data C
	ON S.CustomerID = C.CustomerID
GROUP BY C.CustomerID, C.CustomerName
ORDER BY Total_Orders DESC
LIMIT 5;

-- |>>| STEP 4 - Churn Analysis (Retention Insights) |<<| --

## 1. Looking for Total Churned vs. Active Customers - (Helps us see how many customers are active vs. churned)
SELECT
	CASE
		WHEN is_churned = 0 THEN 'Active'
        ELSE 'Churned'
    END AS `Case`,
    COUNT(*) AS Customer_Count
FROM cleaned_customers_data
GROUP BY is_churned
ORDER BY COUNT(*) DESC;	


## 2. Calculating the Churned Customers Revenue Loss - (Shows how much revenue is lost due to churned customers)
WITH CTE AS (
SELECT
	C.is_churned,
    ROUND(SUM(S.Revenue), 2) AS Revenue_Lost
FROM cleaned_sales_data S
JOIN cleaned_customers_data C
	ON S.CustomerID = C.CustomerID
WHERE C.is_churned = 1
GROUP BY C.is_churned
)
	SELECT
		'Churned Customers' AS `Case`,
        Revenue_Lost
    FROM CTE;

# ----------------------------------------------------------------------------------------------------------- #
-- |>>| Project - Sales Performance and Customer Retention Analysis (Exploratory Data Analysis > END <) |<<| --