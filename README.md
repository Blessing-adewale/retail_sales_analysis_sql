
# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `project1_db`

This project is part of my portfolio, showcasing my SQL skills as a data analyst to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is done as a beginner in SQL when I started my journey to building a solid foundation in data analysis using SQL.

## Objectives

1. **Set up a retail sales database**: Created and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: checked for duplicates and null values. Identified and removed records with missing or null values that are not needed for the analysis.
3. **Exploratory Data Analysis (EDA)**: Performed basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Used SQL to answer specific business questions and derived insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: I started the project by creating a database named project1_db.
- **Table Creation**: A table named `retail_sales` was created to store the sales data. The table structure includes columns for transactions_ID, sale_date, sale_time, customer_ID, gender, age, product_category, quantity_sold, price_per_unit, cost_of_goods_sold, and total_sale.

```sql
CREATE DATABASE project1_db;

DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales
(
transactions_id int primary key,	
sale_date date,	
sale_time time,
customer_id int,
gender varchar(10),	
age int,
category varchar(15),	
quantity int,	
price_per_unit int,
purchasing_cost	float, 
total_sale int
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Checked to confirm the total number of records in the dataset.
- **Customer Count**: Checked the number of unique customers in the dataset.
- **Category Count**: Identified all unique product categories in the dataset.
- **Null Value Check**: Checked for any null values in the dataset and deleted records with missing data.

```sql
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

```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
where sale_date ='2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT * 
FROM retail_sales
WHERE category ='Clothing'
AND quantity > 10
AND to_char(sale_date, 'YYYY-MM') = '2020-11';	
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT
category,
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1;
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT 
category,
avg(age) AS avg_age
FROM retail_sales
WHERE category ='Beauty'
group by 1;
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT *
FROM retail_sales
WHERE total_sale > 1000
order by total_sale desc;
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
gender,
category,
count(*) AS total_transactions
FROM retail_sales
GROUP BY 1,2;
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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

```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
customer_id,
SUM(total_sale) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 desc
LIMIT 5;
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
category,
COUNT(DISTINCT customer_id)
FROM retail_sales
GROUP BY 1;
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
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
```
11. **WRITE A QUERY TO FIND THE AVERAGE DAILY SALES AND TOTAL TRANSACTIONS**
```sql
SELECT 
EXTRACT(DAY FROM sale_date) AS days,
COUNT(*) AS total_transactions,
round(AVG(total_sale),2) AS avg_sales
FROM retail_sales
GROUP BY 1
ORDER BY 1;
```

12. **WRITE A QUERY TO FIND THE HOURLY SALES AND PEAK PERIOD FOR SALES**
```sql
SELECT
EXTRACT(HOUR FROM sale_time) AS hours,
COUNT(*) AS total_transactions,
round(AVG(total_sale),2) AS total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 3 desc;
```

## Findings

- **Customer Demographics**: The dataset include customers from various age groups, with sales distributed across different categories.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly and hourly sales analysis shows variations in sales, and peak periods were identified.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months, shifts and hours.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Conclusion

This project covers database setup, data cleaning, exploratory data analysis, and business-driven SQL queries. The findings from this project can help drive business decisions by understanding sales patterns, customer behavior, and product performance and also helps improve operational efficiency.

