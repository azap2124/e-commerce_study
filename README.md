# E-Commerce-Study


# Analysis notes for us:

### NOTES: 
-- Had a really hard time importing files into SQL Server. My solution was to save the files as a Excel Workbook rather than a .csv and it seems to be working. 

#### Possible questions to answer: 
1. What are the most popular products based on units sold? How do they compare in terms of price and rating?
2. Do products with ad boosts have higher sales compared to those without ad boosts?
3. What are the most common product tags and how do they relate to sales?
4. Is there a relationship between merchant rating and product quality as indicated by the badges?
5. What are the most common countries where products are shipped to?
6. What factors are associated with higher ratings, such as product color, size, or merchant rating?
7. Is there a relationship between merchant profile pictures and sales?

## CODES:
### What are the most popular products based on units sold? How do they compare in terms of price and rating?
* Top 20 units by units sold: shows top 20 products with highest units sold 
* Average rating counts: to calculate average rating and be able to compare products bases on fair rating counts  
* Top 20 worst rated products: products with at least 800 reviews and rated the worst  
```
-- Top 20 units by revenue
-- Shows highest units sold and their ratings 
SELECT TOP 20
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL
ORDER BY units_sold DESC;


-- Average rating counts
-- Shows average rating count for all the products 
SELECT AVG(rating_count)
FROM wish. dbo.summer_products;


-- Top 20 worst rated products
-- Shows worst rated products with a rating count of 800 or more
SELECT TOP 20
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating,
	rating_count
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND rating_count >= 800
ORDER BY rating ASC;
```
#### Average rating for top and worst rated products:
* Best: 3.9045
* Worst: 3.233
```
-- Average rating for top 20 products
SELECT AVG (rating) AS avg_top_rated_products
FROM
(
SELECT TOP 20
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL
ORDER BY units_sold DESC
)
AS avg_top_rated_products

-- Average rating for worst rated products
SELECT AVG(rating) AS avg_worst_rated_products
FROM
(
SELECT TOP 20
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating,
	rating_count
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND rating_count >= 800
ORDER BY rating ASC
)
AS avg_worst_rated_products
```
### Do products with ad boosts have higher sales compared to those without ad boosts?
* There's no direct correlation at least with the data we have available
*  Uses ads: $100,852.38
* Don't use ads: $111,721.59
```
-- Average revenue for products that use ads
SELECT ROUND(AVG(total_revenue),2)
FROM
(
SELECT
	title_orig,
	(units_sold*retail_price) AS total_revenue
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND uses_ad_boosts = 1
) 
AS avg_revenue_ads

-- Average revenue for products that don't use ads
SELECT ROUND(AVG(total_revenue),2)
FROM
(
SELECT
	title_orig,
	(units_sold*retail_price) AS total_revenue
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND uses_ad_boosts = 0
) 
AS avg_revenue_no_ads
```
### What are the most common product tags and how do they relate to sales?





