DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
	(
		transactions_id int primary key,	
		sale_date date,	
		sale_time	time,
		customer_id	int,
		gender varchar(10),	
		age	int,
		category varchar(15),	
		quantity int,	
		price_per_unit	int,
		purchasing_cost	float, 
		total_sale int
	);

SELECT * FROM retail_sales;

SELECT COUNT(*) FROM retail_sales;

SELECT COUNT(DISTINCT customer_id) FROM retail_sales;

SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE transactions_id IS NULL
OR sale_date IS NULL
OR sale_time IS NULL
OR customer_id IS NULL
OR gender IS NULL
OR category IS NULL
OR quantity IS NULL
OR price_per_unit IS NULL
OR purchasing_cost IS NULL
OR total_sale IS NULL;

DELETE FROM retail_sales
WHERE quantity IS NULL
AND price_per_unit IS NULL
AND purchasing_cost IS NULL
AND total_sale IS NULL;

WITH duplicatecheck AS
	(
		SELECT *, 
			ROW_NUMBER() OVER(PARTITION BY transactions_id ORDER BY transactions_id) AS row_num
		FROM retail_sales
	)

SELECT * FROM duplicatecheck
WHERE row_num>1;

--BUSINESS KEY PROBLEMS

--WRITE A QUERY TO RETRIEVE COLUMNS FOR ALL SALES MADE ON 2022-11-05
SELECT * 
FROM retail_sales
where sale_date ='2022-11-05';

/*WRITE A QUERY TO RETRIEVE ALL TRANSACTIONS WHERE THE CATEGORY IS CLOTHING AND THE
QUANTITY SOLD IS MORE THAN 10 IN NOV 2020*/
SELECT
	* 
FROM 
	retail_sales
WHERE category ='Clothing'
	AND quantity > 10
	AND to_char(sale_date, 'YYYY-MM') = '2020-11';
	
-- WRITE A QUERY TO CALCULATE THE TOTAL SALES FOR EACH CATEGORY
SELECT
	category,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1;
	
/* WRITE A QUERY TO FIND THE AVERAGE AGE OF CUSTOMERS WHO MADE A PURCHASE 
	FROM THE BEAUTY CATEGORY.*/
SELECT 
	category,
	avg(age) AS avg_age
FROM retail_sales
WHERE category ='Beauty'
group by 1;

-- WRITE A QUERY TO FIND ALL TRANSACTIONS WHERE THE TOTAL SALES IS GREATER THAN 1000
SELECT *
FROM retail_sales
WHERE total_sale > 1000
order by total_sale desc;

/* WRITE A QUERY TO FIND THE TOTAL NUMBER OF TRANSACTIONS MADE BY EACH GENDER IN 
EACH CATEGORY.*/
SELECT 
	gender,
	category,
	count(*) AS total_transactions
FROM retail_sales
GROUP BY 1,2;
	
/* WRITE A QUERY TO CALCULATE THE AVERAGE SALES FOR EACH MONTH. FIND OUT BEST
	SELLING MONTH IN EACH YEAR*/
SELECT 
	EXTRACT(YEAR FROM sale_date) AS year,
	EXTRACT(MONTH FROM sale_date) AS month,
	ROUND(avg(total_sale),2) AS avg_sales
FROM retail_sales
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 2;

--OR

SELECT
		year,
		month,
		avg_sales
FROM 
	(	
	SELECT 
		EXTRACT(YEAR FROM sale_date)AS year,
		EXTRACT(MONTH FROM sale_date)AS month,
		ROUND(avg(total_sale),2) AS avg_sales,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY (ROUND(avg(total_sale),2))DESC) AS ranking
	FROM retail_sales
	GROUP BY 1,2
	)
WHERE ranking = 1;

/* WRITE A QUERY TO FIND THE TOP 5 CUSTOMERS BASED ON THE HIGHEST TOTAL SALES*/
SELECT 
	customer_id,
	SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 desc
LIMIT 5;

-- FIND THE NUMBER OF UNIQUE CUSTOMERS WHO PURCHASED ITEMS FROM EACH CATEGORY.
SELECT 
	category,
	COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;

-- WRITE A QUERY TO CREATE EACH SHIFT AND NUMBER OF ORDERS
SELECT 
		CASE
			WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'evening'
		END AS SHIFTS,
		COUNT(*)
FROM retail_sales
GROUP BY shifts;

-- OR 
WITH shift_sales AS
(
	SELECT *,
		CASE
			WHEN EXTRACT(HOUR FROM sale_time)<12 THEN 'morning'
			WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'afternoon'
		ELSE 'evening'
		END AS shifts
	FROM retail_sales
)
SELECT 
		shifts,
		COUNT(*) AS total_order
FROM shift_sales
GROUP BY shifts;

-- WRITE A QUERY TO FIND THE AVERAGE DAILY SALES AND TOTAL TRANSACTIONS.
SELECT 
	EXTRACT(DAY FROM sale_date) AS days,
	COUNT(*) AS total_transactions,
	round(AVG(total_sale),2) AS avg_sales
FROM retail_sales
GROUP BY 1
ORDER BY 1;

-- WRITE A QUERY TO FIND THE HOURLY SALES AND PEAK PERIOD FOR SALES
SELECT
	EXTRACT(HOUR FROM sale_time) AS hours,
	COUNT(*) AS total_transactions,
	round(AVG(total_sale),2) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 3 desc;
-- END