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
	
);-- DATA EXPLOPRATION

Data Exploration & Cleaning
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

-- HOW MANY SALES WE HAVE
 SELECT COUNT(*) AS total_sales FROM retails.sales

--HOW MANY CUSTOMER WE HAVE
 SELECT COUNT(DISTINCT customer_id) as total_sales from retails.sales

 HOW MANY UNIQUE CUSTOMES WE HAVE 
SELECT DISTINCT category  from retails.sales

-- data analysis

-- 1.Write a SQL query to retrieve all columns for sales made on '2022-11-05:
SELECT * FROM	retails.sales
where sale_date = '2022-11-05'

-- 2. Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022:
SELECT * FROM retails.sales
WHERE category = 'Clothing' 
  AND EXTRACT(MONTH FROM sale_date) = 11
  AND EXTRACT(YEAR FROM sale_date) = 2022
  AND quantity >= 4;
  
--  3. Write a SQL query to calculate the total sales (total_sale) for each category.:
SELECT category, SUM(total_sale) AS net_sale,
    COUNT(*) AS total_orders
FROM retails.sales
GROUP BY category;

-- 4. Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.:
SELECT  ROUND(AVG(age), 2) as 'avg_age', category from retails.sales
where category = 'Beauty'

-- 5. Write a SQL query to find all transactions where the total_sale is greater than 1000.:

select * from retails.sales
where total_sale > 1000

-- 6. Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.:
select category,gender,count(*) as 'total_transactions'from retails.sales
group by  category, gender
order by 1

-- 7. Write a SQL query to calculate the average sale for each month. Find out best selling month in each year:

SELECT year, month,avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale,
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank_
FROM retails.sales
GROUP BY 1, 2
) as t1
WHERE rank_ = 1

-- 8. Write a SQL query to find the top 5 customers based on the highest total sales

SELECT customer_id, SUM(total_sale) AS total_sales FROM retails.sales
GROUP BY customer_id
ORDER BY total_sales DESC
LIMIT 5;

-- 9. Write a SQL query to find the number of unique customers who purchased items from each category.:
SELECT category, count(distinct customer_id) as unique_cust from retails.sales
group by category

-- 10. Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17):
WITH hourly_sale
AS
(
select *, 
	case 
		WHEN EXTRACT(HOUR FROM sale_time) < 12 then 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time)  BETWEEN 12 AND 17 then 'Afternoon'
		else 'Evening'	
	end as shift 
from retails.sales
)
SELECT shift, count(*) as 'total_order'
from hourly_sale
group by shift
			
