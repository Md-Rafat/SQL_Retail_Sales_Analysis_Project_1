-- SQL Retail Sales Analysis - project 1

--Create Table
 
CREATE TABLE Retail_Sales
		(
		transactions_id	INT PRIMARY KEY,
		sale_date DATE,
		sale_time TIME,
		customer_id	INT,
		gender VARCHAR(15),
		age	INT,
		category VARCHAR(15),
		quantiy	INT,
		price_per_unit	FLOAT,
		cogs	FLOAT,
		total_sale FLOAT
		);

SELECT * FROM Retail_Sales;

-- Data Cleaning

SELECT * FROM Retail_Sales
WHERE transactions_id IS NULL
	OR
	  sale_date IS NULL
	OR
	  sale_time IS NULL
	OR
	  customer_id IS NULL
	OR
	  gender IS NULL
	OR
	  age IS NULL
	OR
      category IS NULL
	OR
	  quantiy IS NULL
	OR
	  price_per_unit IS NULL
	OR
	  cogs IS NULL
	OR
	  total_sale IS NULL;

	  
DELETE FROM Retail_Sales
WHERE transactions_id IS NULL
	OR
	  sale_date IS NULL
	OR
	  sale_time IS NULL
	OR
	  customer_id IS NULL
	OR
	  gender IS NULL
	OR
	  age IS NULL
	OR
      category IS NULL
	OR
	  quantiy IS NULL
	OR
	  price_per_unit IS NULL
	OR
	  cogs IS NULL
	OR
	  total_sale IS NULL;
	  
SELECT COUNT(*) FROM Retail_Sales


-- Data Exploration

-- How many sales we have?

Select COUNT (transactions_id) AS total_sale FROM Retail_Sales 

-- How many unique customers we have?

Select COUNT (DISTINCT customer_id) FROM Retail_Sales 

-- How many categories we have?

Select DISTINCT category FROM Retail_Sales 


-- Data Analysis & Business Key Problems and Answers 

-- Q.1 write a SQL query to retrieve all columns for sales made on '2022-11-05

SELECT *
FROM Retail_Sales 
WHERE sale_date = '2022-11-05'

-- Q.2 write a SQL query to retrieve all transactions where the category is 'clothing' and the quantity sold is more than 4 in the month of Nov-2022

SELECT *
FROM Retail_Sales 
WHERE category = 'Clothing'
  AND 
	TO_CHAR (sale_date, 'YYYY-MM') = '2022-11'
  AND
    quantiy >= 4

-- Q.3 write a SQL query to calculate the total sales (total_sale) and total number of orders for each category

SELECT 
	category,
	SUM (total_sale) AS net_sale,
    COUNT (transactions_id) AS total_orders
FROM Retail_Sales 
GROUP BY category

-- Q.4 write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT
  ROUND(AVG (age),2)
FROM Retail_Sales 
WHERE category = 'Beauty'

-- Q.5 write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM Retail_Sales 
WHERE total_sale > 1000

-- Q.6 write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category

SELECT 
     category,
	 gender,
	 COUNT (transactions_id) AS number_of_transactions
FROM Retail_Sales
GROUP BY category, gender
ORDER BY category, gender;

-- Q.7 write a SQL query to calculate the average sale for each month, find out best selling month in each year

SELECT
	year,
	month,
	AVG_sale
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) AS year,
		EXTRACT(MONTH FROM sale_date) AS month,
		AVG (total_sale) AS AVG_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG (total_sale) DESC) AS rank
	FROM Retail_Sales
	GROUP BY 1,2
) AS table_1
WHERE rank=1

-- Q.8 write a SQL query to find the top 5 customers based on the highest total sales

SELECT
	customer_id,
	SUM(total_sale) AS total_sales
FROM Retail_Sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q.9 write a SQL query to find the number of unique customers who purchased items from each category

SELECT 
	category,
	COUNT(DISTINCT customer_id) AS unique_customer
FROM Retail_Sales
GROUP BY category;

-- Q.10 write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon between 12 and 17, Evening >17)

WITH shift_sale
AS
(
SELECT *,
	CASE
	WHEN EXTRACT(HOUR FROM sale_time) <12 THEN 'Morning'
	WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 and 17 THEN 'Afternoon'
	ELSE 'Evening'
	END AS Shift
FROM Retail_Sales
) 
SELECT 
	shift,
	COUNT(transactions_id) AS Orders
FROM shift_sale
GROUP BY shift
	

-- End of the project
	