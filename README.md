# E-Commerce-Study
Tableau Dashboard: https://public.tableau.com/app/profile/angel.zapata2615/viz/E-CommerceDashboard_16827981312070/Dashboard1?publish=yes
## Introduction: Exploring Product Sales and Merchant Metrics
In the dynamic world of e-commerce, businesses thrive on understanding consumer behavior, product trends, and merchant performance to stay ahead in a competitive market. To shed light on these critical aspects, this data analysis project embarks on an exploration of a rich dataset. Our main objective is to tackle questions that explore different dimensions of product sales and merchant-related metrics.

In this data analysis project, we explore women's shopping preferences on the Wish platform. Our objective is to analyze the dataset to uncover valuable insights, shedding light on the e-commerce environment. Through an examination of product popularity, ad's impacts on sales, item's tags and sales relationship, and merchant ratings, we aim to provide a thorough understanding of the factors influencing product performance and merchant success. Additionally, we will investigate the potential correlation between companies selling to multiple countries and higher revenues. We will be using data analysis techniques to offer a data-driven perspective on women's online shopping trends.

Cleaning the Data:
- I used excel to remove duplicates
- Changed all columns to snake_case for consistency
- Changed data types when importing data to SQL Server

Data Exploration: 
- Answer questions proposed

Interpret the Results:
- Analyze the results and identify any correlations or causations
- Draw conclusions from the data to answer the initial questions

Communicate the Results:
- Visualize data
- Tableau? Should we create a presentation? 

# Analysis notes for us:

### NOTES: 
-- Had a really hard time importing files into SQL Server. My solution was to save the files as a Excel Workbook rather than a .csv and it seems to be working. 

#### Possible questions to answer: 
1. What are the most popular products based on units sold? How do they compare in terms of price and rating?
2. Do products with ad boosts have higher sales compared to those without ad boosts?
3. What are the most common product tags and how do they relate to sales?
4. Is there a relationship between merchant rating and product quality as indicated by the badges?
5. Do companies that sell to many countries have higher revenues? 
6. Is there a relationship between merchant profile pictures and sales?

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
AS avg_top_rated_products;

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
AS avg_worst_rated_products;
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
AS avg_revenue_ads;

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
AS avg_revenue_no_ads;
```
### What are the most common product tags and how do they relate to sales?
Top 10 used tags by revenue: 
|value|	tag_count|total_revenue|
|-----|----------|-------------|
|Women's Fashion|1,301|$142,085,944|
|Women|950|$112,049,239|
|Fashion|1,070|$111,594,890|
|Summer|1,304|$94,012,398|
|Casual|894|$68,669,314|
|Dress|538|$66,922,725|
|sexy|325|$64,130,228|
|Tops|503|$55,257,908|
|Plus Size|632|$48,916,631|
|sleeveless|570|$48,889,972|

```
-- Dividing tags 
-- Divides individual tags and counts how many times the tags were used 
SELECT value, 
	COUNT(value) AS tag_count
FROM wish.dbo.summer_products
CROSS APPLY STRING_SPLIT(tags, ',') AS tag_name
GROUP BY value
ORDER BY tag_count DESC;

-- Divides, counts and compares the tags by revenue 
SELECT value, 
	COUNT(value) AS tag_count,
	SUM(units_sold * retail_price) AS total_revenue 
FROM wish.dbo.summer_products
CROSS APPLY STRING_SPLIT(tags, ',') AS tag
GROUP BY value
ORDER BY total_revenue DESC;
```
###  Is there a relationship between merchant rating and product quality as indicated by the badges?
* There's only 151 merchants with at least one badge
* There's 1405 merchants without badges
* Average rating for badge holders: 4.17
* Average rating for badge non-holders: 4.02
* Average rating for merchants with the product quality badge: 4.17
* Average rating for merchants that **do not** hold a product quality badge: 4.02
* There is a slight difference, but it is not a significant one.
```
-- Merchant rating and number of badges
SELECT merchant_rating, badges_count
FROM wish.dbo.summer_products
WHERE badges_count >= 1
ORDER BY merchant_rating DESC;

-- Merchant rating for badge non-holders
SELECT merchant_rating, badges_count
FROM wish.dbo.summer_products
WHERE badges_count = 0;

-- Average rating for mechants with at least one badge
SELECT AVG(merchant_rating) AS avg_rating
FROM wish.dbo.summer_products
WHERE badges_count >= 1;

-- Average rating for badge non-holders
SELECT AVG(merchant_rating) AS avg_rating
FROM wish.dbo.summer_products
WHERE badges_count = 0;

-- Mechants with the product quality badge
SELECT merchant_rating,
	badge_product_quality
FROM wish.dbo.summer_products
WHERE badge_product_quality >= 1
ORDER BY merchant_rating DESC;

-- Average rating for merchants with the product quality badge
SELECT AVG(merchant_rating) AS avg_rating
FROM wish.dbo.summer_products
WHERE badge_product_quality >= 1;

-- Average rating for merchants that DO NOT hold product quality badge
SELECT AVG(merchant_rating) AS avg_rating
FROM wish.dbo.summer_products
WHERE badge_product_quality = 0;  
```
###  Do companies that sell to many countries have higher revenues? 
* Average number of countries that products are shipped to: 40
* Products that ship to less than 29 countries: 329
* Products that ship to more than 61 countries: 98
* Average revenue for products that ship to less than 29 countries: $40,592.47
* Average revenue for products that ship to more than 61 countries: $78,144.74
* Average revenue for products that ship to between 30 and 60 countries: $128,272.41
* There's a significant difference of revenues between products that ship to less than 29 countries and products that ship to more than 61 countries. 
```
-- Average of countries_shipped_to
-- Calculates the average of how many countries are shipped to per product
SELECT AVG(countries_shipped_to) AS average_countries_shipped
FROM wish.dbo.summer_products;


-- Count of products that ship to less than 29 countries 
SELECT COUNT(countries_shipped_to) AS low_countries
FROM
(
SELECT (units_sold * retail_price) AS total_revenue,
countries_shipped_to,
	CASE
		WHEN (countries_shipped_to) < 29 THEN 'low'
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'medium'
		WHEN (countries_shipped_to) > 61 THEN 'high'
	END countries_level
FROM wish.dbo.summer_products
)
AS low_average
WHERE countries_level = 'low';

-- Count of products that ship to more than 61 countries 
SELECT COUNT(countries_shipped_to) AS high_countries
FROM
(
SELECT (units_sold * retail_price) AS total_revenue,
countries_shipped_to,
	CASE
		WHEN (countries_shipped_to) < 29 THEN 'low'
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'medium'
		WHEN (countries_shipped_to) > 61 THEN 'high'
	END countries_level
FROM wish.dbo.summer_products
)
AS low_average
WHERE countries_level = 'high';


-- Average revenue for products that ship to less than 29 countries 
SELECT ROUND(AVG(total_revenue),2) AS avg_revenue_low 
FROM
(
SELECT (units_sold * retail_price) AS total_revenue,
countries_shipped_to,
	CASE
		WHEN (countries_shipped_to) < 29 THEN 'low'
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'medium'
		WHEN (countries_shipped_to) > 61 THEN 'high'
	END countries_level
FROM wish.dbo.summer_products
)
AS low_average
WHERE countries_level = 'low';

-- Average revenue for products that ship to more than 61 countries 
SELECT ROUND(AVG(total_revenue),2) AS avg_revenue_high 
FROM
(
SELECT (units_sold * retail_price) AS total_revenue,
countries_shipped_to,
	CASE
		WHEN (countries_shipped_to) < 29 THEN 'low'
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'medium'
		WHEN (countries_shipped_to) > 61 THEN 'high'
	END countries_level
FROM wish.dbo.summer_products
)
AS high_average
WHERE countries_level = 'high';

-- Average revenue for products that ship to between 30 and 60 countries 
SELECT ROUND(AVG(total_revenue),2) AS avg_revenue_medium
FROM
(
SELECT (units_sold * retail_price) AS total_revenue,
countries_shipped_to,
	CASE
		WHEN (countries_shipped_to) < 29 THEN 'low'
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'medium'
		WHEN (countries_shipped_to) > 61 THEN 'high'
	END countries_level
FROM wish.dbo.summer_products
)
AS medium_average
WHERE countries_level = 'medium';
```
### Is there a relationship between merchant profile pictures and sales?
* There's a significant difference between products where merchants have profile pictures to those who don't
* Products where merchants have a profile pictures sold a lot more units than those who don't have a profile picture
* Has profile picture sold on average: 7,617 units 
* Does not have a profile picture sold on average: 3,824 units
```
SELECT AVG(units_sold) AS avg_units_sold
FROM wish.dbo.summer_products
WHERE merchant_has_profile_picture = 1;

SELECT AVG(units_sold) AS avg_units_sold
FROM wish.dbo.summer_products
WHERE merchant_has_profile_picture = 0;
``` 




