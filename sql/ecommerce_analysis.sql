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

-- Total revenue, total amount of orders, average order amount, and the average return rate
SELECT
	ROUND(SUM(revenue), 2) AS total_revenue,
	COUNT(order_id) AS total_orders,
	ROUND(SUM(revenue) / COUNT(order_id), 2) AS avg_order_value,
	ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging;

-- Revenue and return rate by region
SELECT 
	region,
	ROUND(SUM(revenue), 2) AS revenue,
	ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging
GROUP BY region
ORDER BY revenue DESC;

-- Total revenue sorted by month
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS month,
	SUM(revenue) AS total_revenue
FROM ecommerce_staging
GROUP BY month
ORDER BY month;

-- Monthly order amounts and how many units sold
SELECT 
	DATE_FORMAT(order_date, '%Y-%m') AS month,
	COUNT(order_id) AS total_orders,
	SUM(quantity) AS total_units
FROM ecommerce_staging
GROUP BY month
ORDER BY month;

-- Rank product categories by revenue
SELECT
    product_category,
    ROUND(SUM(revenue), 2) AS total_revenue,
    RANK() OVER (ORDER BY SUM(revenue) DESC) AS revenue_rank
FROM ecommerce_staging
GROUP BY product_category;

-- Average amount of money spent by discounts
SELECT 
	discount_percent, 
	ROUND(AVG(revenue), 2) AS avg_revenue
FROM ecommerce_staging
GROUP BY discount_percent
ORDER BY discount_percent;

-- Average original value prior to discount
SELECT
	discount_percent,
	ROUND(AVG(revenue / (1 - discount_percent / 100)), 2) AS avg_original_value
FROM ecommerce_staging
WHERE discount_percent < 100
GROUP BY discount_percent
ORDER BY discount_percent;

-- Top 10 customers who spent the most
SELECT
	customer_id,
	SUM(revenue) AS total_spent
FROM ecommerce_staging
GROUP BY customer_id
ORDER BY total_spent DESC
LIMIT 10;

-- Repeat customers and how many orders they placed
SELECT 
	customer_id, 
    COUNT(order_id) AS order_count
FROM ecommerce_staging
GROUP BY customer_id
ORDER BY 2 DESC;

-- Average delivery time
SELECT AVG(delivery_days) AS avg_delivery_time
FROM ecommerce_staging;

-- Percent of deliveries faster than average
SELECT ROUND(COUNT(*) * 100.0 / (SELECT COUNT(*) FROM e_commerce), 2) AS pct_faster_than_avg
FROM ecommerce_staging
WHERE delivery_days <
(
SELECT AVG(delivery_days)
FROM ecommerce_staging
)
;

-- Percent of returned and unreturned items
SELECT 
	is_returned,
	COUNT(*) AS total_orders,
	ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM ecommerce_staging
GROUP BY is_returned;

-- Percent of returns by delivery days
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

-- Average revenue by customer rating
SELECT 
	customer_rating,
	ROUND(AVG(revenue), 2) AS avg_revenue
FROM ecommerce_staging
GROUP BY customer_rating
ORDER BY customer_rating;

-- Monthly revenue growth
WITH monthly_revenue AS (
    SELECT
        DATE_FORMAT(order_date, '%Y-%m') AS order_month,
        ROUND(SUM(revenue), 2) AS total_revenue
    FROM ecommerce_staging
    GROUP BY DATE_FORMAT(order_date, '%Y-%m')
),
revenue_with_previous_month AS (
    SELECT
        order_month,
        total_revenue,
        LAG(total_revenue) OVER (ORDER BY order_month) AS previous_month_revenue
    FROM monthly_revenue
)
SELECT
    order_month,
    total_revenue,
    previous_month_revenue,
    ROUND(
        (total_revenue - previous_month_revenue) * 100.0 / previous_month_revenue,
        2
    ) AS month_over_month_growth_pct
FROM revenue_with_previous_month;

-- Return rate by category
SELECT
    product_category,
    COUNT(*) AS total_orders,
    SUM(CASE WHEN is_returned = 1 THEN 1 ELSE 0 END) AS returned_orders,
    ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging
GROUP BY product_category
ORDER BY return_rate DESC;

-- Region performance summary
SELECT
    region,
    COUNT(*) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_revenue,
    ROUND(AVG(revenue), 2) AS avg_order_value,
    ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging
GROUP BY region
ORDER BY total_revenue DESC;

-- Top customers
SELECT
    customer_id,
    COUNT(order_id) AS total_orders,
    ROUND(SUM(revenue), 2) AS total_spent,
    ROUND(AVG(revenue), 2) AS avg_order_value,
    ROUND(AVG(is_returned) * 100.0, 2) AS return_rate
FROM ecommerce_staging
GROUP BY customer_id
HAVING COUNT(order_id) > 1
ORDER BY total_spent DESC
LIMIT 10;
