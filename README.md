# E-Commerce Sales & Returns Analysis

## Project Overview

This project analyzes e-commerce transactional data to uncover key drivers of revenue, customer behavior, and product performance. The workflow combines SQL for analysis with Tableau for interactive visualization.

---

## Project Structure

/data
- synthetic_ecommerce_sales_2025.csv

/sql
- ecommerce_analysis.sql

/tableau
- ecommerce_analysis.twbx
- ecommerce_analysis_screenshot.png

---

## Data Preparation (SQL)
- Cleaned and structured raw e-commerce transactional data for analysis
- Transformed fields including revenue, order date, and return indicators
- Engineered key features such as pre-discount order value to analyze pricing impact
- Ensured data consistency for visualization in Tableau

---

## Key Analyses
- Revenue performance trends over time
- Product category analysis based on total revenue contribution
- Discount impact analysis on order value and purchasing behavior
- Return rate analysis by delivery time and customer behavior
- Regional performance comparison across revenue and return rates

---

## Tableau Dashboard
Built an interactive dashboard featuring:
- KPI metrics (Total Revenue, Total Orders, Average Order, Return Rate)
- Time-series analysis of revenue trends
- Product category performance breakdown
- Delivery efficiency vs return rate analysis
- Regional performance visualization
- Discount impact on revenue and original order value

---

## Key SQL Concepts Used
- `COUNT`,`SUM`, and `AVG` for aggregations
- `DATE_FORMAT`
- `ROUND`

---

## Dataset
- Source: [(https://www.kaggle.com/datasets/emirhanakku/synthetic-e-commerce-sales-dataset-2025)](https://www.kaggle.com/datasets/emirhanakku/synthetic-e-commerce-sales-dataset-2025)
- Rows: 100,000
- Columns: 13

---

## Key Insights

- Revenue trends over time show seasonal fluctuations in customer demand
- Higher discount levels are associated with lower-value orders, suggesting targeted discounting strategies
- Delivery times have no clear impact on return rates
- Regional analysis highlights variations in both revenue generation and return behavior

![Dashboard](tableau/ecommerce_analysis_screenshot.png)

## Key Takeaways

This project demonstrates end-to-end data analysis:

* Data preparation
* Exploratory analysis
* Metric development
* Data visualization and storytelling
