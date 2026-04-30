-- E-Commerce Sales Analysis

-- Creating a duplicate table so we don't mess with the raw data
CREATE TABLE ecommerce_staging
LIKE e_commerce;

INSERT INTO ecommerce_staging
SELECT *
FROM e_commerce;

-- Checking for duplicates
SELECT 
	COUNT(*), 
	COUNT(DISTINCT customer_id)
FROM ecommerce_staging;

-- Checking for nulls
SELECT *
FROM ecommerce_staging
WHERE region IS NULL;

-- Checking for blank values
SELECT *
FROM ecommerce_staging
WHERE TRIM(customer_rating) = '';

-- Making sure results are only 1 (Yes) and 0 (No)
SELECT DISTINCT(is_returned)
FROM ecommerce_staging;

-- Dataset looks good, let's start!
SELECT *
FROM ecommerce_staging;

-- Find total revenue, total amount of orders, average order amount, and the average return rate
SELECT
	ROUND(SUM(revenue), 2) AS total_revenue,
	COUNT(order_id) AS total_orders,
	ROUND(SUM(revenue) / COUNT(order_id), 2) AS avg_order_value,
	ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging;

-- Find revenue and return rate by region
SELECT 
	region,
	ROUND(SUM(revenue), 2) AS revenue,
	ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging
GROUP BY region
ORDER BY revenue DESC;

-- Find total revenue sorted by month
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS month,
	SUM(revenue) AS total_revenue
FROM ecommerce_staging
GROUP BY month
ORDER BY month;

-- Find monthly order amounts and how many units sold
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS month,
	COUNT(order_id) AS total_orders,
	SUM(quantity) AS total_units
FROM ecommerce_staging
GROUP BY month
ORDER BY month;

-- Find revenue by product category
SELECT 
	product_category, 
    SUM(revenue) AS revenue
FROM ecommerce_staging
GROUP BY product_category
ORDER BY revenue DESC;

-- Find average amount of money spent by discounts
SELECT 
	discount_percent, 
	ROUND(AVG(revenue), 2) AS avg_revenue
FROM ecommerce_staging
GROUP BY discount_percent
ORDER BY discount_percent;

-- Find average original value prior to discount
SELECT
	discount_percent,
	ROUND(AVG(revenue / (1 - discount_percent / 100)), 2) AS avg_original_value
FROM ecommerce_staging
WHERE discount_percent < 100
GROUP BY discount_percent
ORDER BY discount_percent;

-- Find top 10 customers who spent the most
SELECT
	customer_id,
	SUM(revenue) AS total_spent
FROM ecommerce_staging
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Find repeat customers and how many orders they placed
SELECT 
	customer_id, 
    COUNT(order_id) AS order_count
FROM ecommerce_staging
GROUP BY customer_id
ORDER BY 2 DESC;

-- What is average delivery time?
SELECT AVG(delivery_days) AS avg_delivery_time
FROM ecommerce_staging;

-- What percent of deliveries are faster than average?
SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM e_commerce), 2) AS pct_faster_than_avg
FROM ecommerce_staging
WHERE delivery_days <
(
SELECT AVG(delivery_days)
FROM e_commerce
)
;

-- What is percent of returned and unreturned items?
SELECT 
	is_returned,
	COUNT(*) AS total_orders,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM ecommerce_staging
GROUP BY is_returned;

-- Find the percentage of returns by delivery days
SELECT 
	delivery_days,
	ROUND(AVG(is_returned) * 100.0 , 2) AS return_rate
FROM ecommerce_staging
GROUP BY delivery_days
ORDER BY return_rate;

-- Rank the categories by customer satisfaction
SELECT 
	product_category, 
    AVG(customer_rating)
FROM ecommerce_staging
GROUP BY product_category
ORDER BY 2 DESC;

-- Find the average revenue by customer rating
SELECT 
	customer_rating,
	ROUND(AVG(revenue), 2) AS avg_revenue
FROM ecommerce_staging
GROUP BY customer_rating
ORDER BY customer_rating;