-- SQL Retail Sales Analysis - P1

-- Create Table
DROP TABLE IF EXISTS retail_sales;
Create Table retail_sales 
             	(
		             transactions_id INT PRIMARY KEY,
					 sale_date DATE,
					 sale_time  Time,
					 customer_id INT,
					 gender VARCHAR(15),
					 age INT,
					 category VARCHAR(15),
					 quantiy INT,
					 price_per_unit FLOAT,
					 cogs FLOAT,
					 total_sale FLOAT
            );

SELECT *
FROM retail_sales
LIMIT 100;


SELECT COUNT(*)
FROM retail_sales;

SELECT COUNT(customer_id)
FROM retail_sales;


SELECT *
FROM retail_sales
WHERE transactions_id IS NOT NULL;

SELECT *
FROM retail_sales
WHERE sale_date IS NULL;

SELECT *
FROM retail_sales
WHERE sale_time IS NULL;

SELECT *
FROM retail_sales
WHERE customer_id IS NULL;


-- Data Cleaning

SELECT *
FROM retail_sales
WHERE 
      transactions_id IS NULL 
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

DELETE FROM retail_sales
WHERE 
      transactions_id IS NULL 
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


-- DATA EXPLORATION

-- How many sales we have? (1987 sales)

SELECT COUNT(*) AS total_sale
FROM retail_sales;

-- How many unique customers we have? (155 customers)

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

-- How many catogry we have? 3 ("Electronics", "Clothing", "Beauty")

SELECT DISTINCT category AS category_name
FROM retail_sales;

-- Data Analysis & Business Key Problems & Answer


-- Q1 Write a SQL query to retrieve all coulms for sales made on '2022-11-05'

SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- Q2 Write a SQL query to retrieve all transactions where the category is 'clothing' AND the quanitiy sold is more than 3 in the month of Nov-2022

SELECT *
FROM retail_sales
WHERE category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantiy > 3;

-- Q3 Write a SQL query to calculate the total sales for each category

SELECT category, 
		SUM(total_sale) AS net_sale,
		COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- Q4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category

SELECT category, ROUND(AVG(age), 1) AS avg_age
FROM retail_sales
WHERE category = 'Beauty'
GROUP BY category;

-- Q5 Write a SQL query to find all transactions where the total_sale is greater than 1000

SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- Q6 Write a SQL query to find the total number of transactions (transactions_id) made by each gender in each category

SELECT category, 
		gender, 
		COUNT(*) AS total_trans
FROM retail_sales
GROUP BY gender, category
ORDER BY 1;

-- Q7 Write a SQL query to calculate the average sale for each month, Find out best selling month in each year
-- BULIDING SUBQULIERIES & WINDOW FUNCTION

SELECT year, 
		month, 
		avg_sale
FROM (
	SELECT 
			EXTRACT (YEAR FROM sale_date) AS year,
			EXTRACT (MONTH FROM sale_date) AS month,
			AVG(total_sale) AS avg_sale,
			RANK () OVER(PARTITION BY EXTRACT (YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2

   ) as t1
WHERE rank = 1;


-- Q8 Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id,
		SUM(total_sale) AS total_sale
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;

-- Q9 Write a SQL query to find the number of unique customers who purchased items from each category

SELECT category,
		COUNT(DISTINCT customer_id)	AS cnt_of_unique_customer 
FROM retail_sales
GROUP BY category;

-- Q10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
-- BULIDING CASE STATEMENT & CTE


WITH hourly_sale
AS
(
SELECT *,
	CASE 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
		ELSE 'Evening'
	END AS shift
FROM retail_sales
)

SELECT 	shift,
		COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- END OF PROJECT