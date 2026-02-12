CREATE DATABASE Sql_project1;
CREATE TABLE Retail_sale 
             (
               transactions_id INT PRIMARY KEY,
               sale_date DATE,
               sale_time TIME,
               customer_id INT,
               gender VARCHAR (10),
               age INT,
               category VARCHAR (20),
               quantiy INT,
               price_per_unit FLOAT,
               cogs FLOAT,
               total_sale FLOAT
			 ) ;
             
select * from retail_sale;

select * from retail_sale
where quantiy is null;

-- Data exploration
-- how many sales we have
SELECT COUNT(*) Total_sales FROM retail_sale;
-- How many unique customer we have
SELECT COUNT(DISTINCT customer_id) FROM retail_sale;
SELECT DISTINCT category FROM retail_sale;

select * from retail_sale;
-- Business Key Problems or Data Analysis
-- 1. Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM retail_sale
WHERE sale_date = '2022-11-05';
-- 2.Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than or equal to 4 in the month of Nov-2022:
SELECT * 
FROM retail_sale
WHERE category = 'clothing'
AND sale_date BETWEEN '2022-11-01' AND '2022-11-30'
AND quantiy >= 4;
-- 3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, 
SUM(total_sale) AS Total_sale,  
COUNT(*) AS Total_order
FROM retail_sale
GROUP BY category
ORDER BY Total_sale;
-- 4.Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT category, ROUND(AVG(age),0) AS avg_age
FROM retail_sale
WHERE category = 'Beauty';
-- 5.Write a SQL query to find all transactions where the total_sale is greater than 1000:
 SELECT * 
 FROM retail_sale
 WHERE total_sale > 1000;
 -- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
SELECT 
COUNT(*) AS total_trans,
category, 
gender
FROM retail_sale
GROUP BY category, gender
ORDER BY total_trans;
-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:
SELECT *
FROM (
       SELECT 
       YEAR(sale_date) AS year,
       MONTH(sale_date) AS month,
       AVG(total_sale) AS avg_monthly_sales,
       SUM(total_sale) AS total_monthly_sales,
       RANK() OVER
			(PARTITION BY YEAR(sale_date)
             ORDER BY SUM(total_sale) DESC
             ) AS rnk
	   FROM retail_sale
        GROUP BY YEAR(sale_date), MONTH(sale_date)
         ) t
           WHERE rnk = 1;
-- 8. Write a SQL query to find the top 5 customers based on the highest total sales :
SELECT customer_id,
 SUM(total_sale) AS highest_sales
 FROM retail_sale
 GROUP BY customer_id
 ORDER BY highest_sales DESC
 LIMIT 5;
 -- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
  SELECT  category, COUNT(DISTINCT customer_id) AS customers_num
  FROM retail_sale
  GROUP BY category;
  
  SELECT * FROM retail_sale;
  -- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
SELECT 
     CASE 
        WHEN sale_time < '12:00:00' THEN 'Morning'
        WHEN sale_time BETWEEN '12:00:00' AND '17:00:00' THEN 'Afternoon'
        ELSE 'Evening'
	END AS shift,
    COUNT(*) AS num_of_orders
    FROM retail_sale
    GROUP BY shift
    ORDER BY FIELD(shift, 'Morning', 'Afternoon', 'Evening');
-- 11. Write a query to find the top-selling category in each year based on total sales.
    SELECT 
    YEAR(sale_date) AS year, 
    category, 
    SUM(total_sale) AS Total_sales
    FROM retail_sale
    GROUP BY year(sale_date), category;
-- 12 Find the average transaction value per customer and show only customers whose average purchase is above the overall average.
SELECT customer_id, AVG(total_sale) AS avg_total_sales
FROM retail_sale
GROUP BY customer_id
HAVING avg_total_sales > (
                          SELECT AVG(total_sale) 
                          FROM retail_sale
                          );
                          
SELECT r.customer_id, AVG(total_sale) AS avg_sale
FROM retail_sale r 
WHERE AVG(total_sale) > ( 
                           SELECT AVG(r2.total_sale) 
                           FROM retail_sale r2
                           WHERE r.customer_id = r2.customer_id
                           GROUP BY r.customer_id
                           ORDER BY avg_sale) ;
-- Write a query to find the number of repeat customers (customers who made more than 1 purchase).
SELECT customer_id, COUNT(transactions_id) Purchase_count
FROM retail_sale
GROUP BY customer_id
HAVING COUNT(transactions_id) > 1;
                           
-- 13 Write a query to find the number of repeat customers (customers who made more than 1 purchase).
SELECT customer_id
FROM retail_sale
GROUP BY customer_id
HAVING COUNT(transactions_id); 

SELECT COUNT(customer_id)
FROM retail_sale
WHERE transactions_id > 1
GROUP BY customer_id;

-- 14 Find the most popular product category for each gender based on number of transactions.
SELECT category, gender, total_transaction
FROM (
       SELECT category,
       gender,
       Count(transactions_id) AS total_transaction,
       RANK()OVER(
			PARTITION BY gender 
			 ORDER BY COUNT(transactions_id) DESC
              ) AS rnk
	   FROM retail_sale
       GROUP BY category, gender
       ) t
       WHERE rnk = 1;
       
select * from retail_sale;

select r.category, r.gender,
       count(r.transactions_id) num_trans
from retail_sale r
group by r.gender, r.category
having count(r.transactions_id) = (
          select max(cnt) from (
                  select gender,
                         category, 
                         count(transactions_id) cnt
                         from retail_sale 
                         group by gender, category
                         ) t 
                         where r.gender= t.gender
                         );

-- 15 Write a query to calculate monthly sales growth (%) compared to the previous month.
SELECT 
year, 
month,
monthly_sale,
LAG (monthly_sale) over( ORDER BY year, month) AS prv_mnth_sale,
ROUND(
       (monthly_sale - LAG (monthly_sale) OVER(ORDER BY year, month))
       / LAG (monthly_sale) OVER(ORDER BY year, month)*100, 2
       ) AS grwth_prcentage
 FROM (
	SELECT 
    YEAR(sale_date) AS year,
    MONTH(sale_date) AS month,
     SUM(total_sale) AS monthly_sale
    FROM retail_sale
    GROUP BY YEAR(sale_date), MONTH(sale_date)
    ) t
    ORDER BY year, month;
    
       
       
    
 



  
       
 


