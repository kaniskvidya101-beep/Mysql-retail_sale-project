# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project is designed to demonstrate SQL skills and techniques typically used by data analysts to explore, clean, and analyze retail sales data. The project involves setting up a retail sales database, performing exploratory data analysis (EDA), and answering specific business questions through SQL queries. This project is ideal for those who are starting their journey in data analysis and want to build a solid foundation in SQL.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1. Database Setup

- **Database Creation**: The project starts by creating a database named `p1_retail_db`.
- **Table Creation**: A table named `retail_sales` is created to store the sales data. The table structure includes columns for transaction ID, sale date, sale time, customer ID, gender, age, product category, quantity sold, price per unit, cost of goods sold (COGS), and total sale amount.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,	
    cogs FLOAT,
    total_sale FLOAT
);
```

### 2. Data Exploration & Cleaning

- **Record Count**: Determine the total number of records in the dataset.
- **Customer Count**: Find out how many unique customers are in the dataset.
- **Category Count**: Identify all unique product categories in the dataset.
- **Null Value Check**: Check for any null values in the dataset and delete records with missing data.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis & Findings

The following SQL queries were developed to answer specific business questions:

1.**Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
   **Business Question**
    **Helps analyze performance on a specific day**
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```
 -- Explanation
    SELECT * retrieves all transaction details.
    WHERE sale_date = '2022-11-05' filters transactions for that specific date.

2.**Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022**
 **Business Question**
   **Identify bulk clothing purchases in November to indicates seasonal demand.**
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
    AND quantiy >= 4;
```
 -- Explaination:
    Filters category = Clothing.
    Extracts year and month from date.
    Filters only large quantity purchases.
    Combines multiple conditions using AND.


3. **Write a SQL query to calculate the total sales (total_sale) for each category.**
    **Business Question**
     **Which product category drives revenue?**
     
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales  
GROUP BY category;
```
 -- Explanation:
    SUM(total_sale) calculates total revenue.
    COUNT(*) counts number of transactions.
    GROUP BY category ensures calculations are done per category.
    
4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**
   **Business Question**
     **Understand customer demographics for Beauty category.**
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```
 -- Explanation:
    Filters Beauty category.
    AVG(age) computes average.
    ROUND(...,2) remove decimal give for readability, Useful for target marketing strategy.


5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**
    **Business Question**
     **Find premium purchases.**
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```
-- Explanation:
   Filters transactions with high monetary value.
   Useful to identify luxury or bulk purchases.

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**
  **Business Question**
    **How do purchasing patterns differ by gender**
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY category, gender
ORDER BY category;
```
 -- Explanation:
    Groups data by both gender and category.
    Measures transaction frequency and Helps in analysing customer behavior differences.

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**
   **Business Question**
    **Which month performs best in each year**
```sql
SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
FROM retail_sales
GROUP BY 1, 2
) as t1
WHERE rank = 1
```
 -- Explanation:
    First calculates monthly average.
    RANK() partitions data by year.
    Picks highest month per year (using window function).

8. **Write a SQL query to find the top 5 customers based on the highest total sales **
   **Business Question**
   **Who are the highest revenue-generating customers**
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5
```
 -- Explanation:
    Aggregates total purchase per customer.
    Orders descending to find highest spenders.
    Helps identify VIP customers.

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**
    **Business Question**
     **How many distinct customers buy from each category**
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```
 -- Explanation:
    COUNT(DISTINCT customer_id) avoids duplicate counting.
    Measures customer reach per category.
    
10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**
    **Business Question**
     **Which time of day generates most orders**
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```
  -- Explanation:
     Creates custom time buckets using CASE.
     Groups by shift and Helps understand customer activity patterns.
     
11. Write a query to find the top-selling category in each year based on total sales.
  **Business Question**
   **Which product category generated the highest total revenue in each year?**
```sql
SELECT year, category, total_sales
FROM (
    SELECT 
        YEAR(sale_date) AS year,
        category,
        SUM(total_sale) AS total_sales,
        RANK() OVER(
            PARTITION BY YEAR(sale_date)
            ORDER BY SUM(total_sale) DESC
        ) AS rnk
    FROM retail_sale
    GROUP BY YEAR(sale_date), category
) t
WHERE rnk = 1;
```
 -- Explanation:
    Aggregates total revenue per category for each year using SUM(total_sale).
    Uses GROUP BY YEAR(sale_date), category to calculate yearly category performance.
    Applies RANK() with PARTITION BY year to rank categories within each year.
    Filters rnk = 1 to select the highest revenue category per year, used of window functions for ranking within grouped data.
    
12 Find the average transaction value per customer and show only customers whose average purchase is above the overall average.

```sql
   SELECT customer_id,
       AVG(total_sale) AS avg_sale
FROM retail_sale
GROUP BY customer_id
HAVING AVG(total_sale) > (
       SELECT AVG(total_sale)
       FROM retail_sale
);
```
 --Explanation:
   Calculates average transaction value per customer using AVG(total_sale).
   Uses GROUP BY customer_id to evaluate each customer separately.
   Computes company-wide average using a subquery.
   Uses HAVING to compare grouped averages with overall average.
   Demonstrates understanding of aggregate filtering and subqueries.

   
13. Write a query to find the number of repeat customers (customers who made more than 1 purchase).
  **Business Question**
   **How many customers made more than one purchase?**
```sql
SELECT COUNT(*) AS repeat_customers
FROM (
    SELECT customer_id
    FROM retail_sale
    GROUP BY customer_id
    HAVING COUNT(*) > 1
) t;
```
 -- Explanation
    Groups transactions by customer_id to count purchase frequency.
    Uses HAVING COUNT(transactions_id) > 1 to identify repeat buyers.
    Wraps result in outer query to count total repeat customers.
    Demonstrates customer retention analysis using aggregation logic.
    

14 Find the most popular product category for each gender based on number of transactions.
    **Business Question**
     **Which category is most preferred by each gender this is for understanding gender-based purchasing patterns.**

💻 SQL Query**
```sql
SELECT category, gender, total_transaction
FROM (
SELECT category,
       gender,
       COUNT(transactions_id) AS total_transaction,
   RANK() OVER(
   PARTITION BY gender 
   ORDER BY COUNT(transactions_id) DESC
    ) AS rnk
   FROM retail_sale
   GROUP BY category, gender
   ) t
WHERE rnk = 1;
```
 -- Explanation:
    Used window function Counts transactions per gender-category pair.
    Uses GROUP BY category, gender to segment purchase behavior.
    Applies RANK() with PARTITION BY gender to rank categories within each gender.
    Filters rank = 1 to select the most preferred category.
  
15 Write a query to calculate monthly sales growth (%) compared to the previous month.
    **Business Question**
     **How is the business performing month-over-month to measure revenue growth trend.**
```sql
SELECT 
    year,
    month,
    monthly_sale,
    LAG(monthly_sale) OVER (ORDER BY year, month) AS prev_month_sale,
    
    ROUND(
        (monthly_sale - LAG(monthly_sale) OVER (ORDER BY year, month))
        * 100.0
        / LAG(monthly_sale) OVER (ORDER BY year, month),
    2) AS growth_percentage

FROM (
    SELECT 
        YEAR(sale_date) AS year,
        MONTH(sale_date) AS month,
        SUM(total_sale) AS monthly_sale
    FROM retail_sale
    GROUP BY YEAR(sale_date), MONTH(sale_date)
) t

ORDER BY year, month;
```
 -- Explanation:
    Aggregates monthly revenue using SUM(total_sale) grouped by year and month.
    Uses LAG() to retrieve previous month’s sales.
    Applies growth formula: (Current - Previous) / Previous × 100.
    Uses ROUND() to format output to two decimal places. 
    Demonstrates time-series analysis using window functions.
    
## Findings

- **Customer Demographics**: The dataset includes customers from various age groups, with sales distributed across different categories such as Clothing and Beauty.
- **High-Value Transactions**: Several transactions had a total sale amount greater than 1000, indicating premium purchases.
- **Sales Trends**: Monthly analysis shows variations in sales, helping identify peak seasons.
- **Customer Insights**: The analysis identifies the top-spending customers and the most popular product categories.
- **Top-Selling Category by Year**: Each year has a distinct revenue-leading category, showing that customer preferences may shift over time.
- **Shift-Based Sales Pattern**: Order distribution across Morning, Afternoon, and Evening shifts shows when customers are most active.
- **Operational Performance Indicator**: Monthly growth analysis serves as a KPI for measuring business expansion or slowdown.
- **Data Consistency Check**: Removal of null values ensured accurate aggregation and reliable analytical results.

## Reports

- **Sales Summary**: A detailed report summarizing total sales, customer demographics, and category performance.
- **Trend Analysis**: Insights into sales trends across different months and shifts.
- **Customer Insights**: Reports on top customers and unique customer counts per category.

## Key Skills Demonstrated

- Data Cleaning & Validation
- Aggregation & Group-Level Analysis
- Window Functions (RANK, LAG)
- Subqueries & Comparative Analysis
- Time-Series Growth Calculation
- Customer Segmentation Logic
- KPI Development

## Conclusion

This project demonstrates end-to-end SQL-based business analysis, including database setup, data validation, exploratory analysis, and KPI calculation.
Through this project, I applied analytical thinking to solve real-world business problems such as identifying high-value customers, analyzing revenue contribution by category, measuring customer retention, and calculating month-over-month sales growth.
The analysis showcases practical SQL skills required for a Data Analyst role, including aggregation, subqueries, window functions, and time-series performance tracking.

## Author -  Vidya Bharti


- **LinkedIn**: linkedin.com/in/vidya-bharti-034894248 


