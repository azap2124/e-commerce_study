/*What are the most popular products based on units sold? How do they compare in terms of price and rating?*/
-- Top 10 units by revenue
-- Shows highest units sold and their ratings 
SELECT TOP 10
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

-- Top 10 worst rated products
-- Shows worst rated products with a rating count of 800 or more
SELECT TOP 10
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating,
	rating_count
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND rating_count >= 800
ORDER BY rating ASC;

-- Average rating for top 10 products
SELECT AVG (rating) AS avg_best_selling_products
FROM
(
SELECT TOP 10
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL
ORDER BY units_sold DESC
)
AS avg_best_selling_products;

-- Average rating for least selling products
SELECT AVG (rating) AS avg_least_selling_products
FROM
(
SELECT TOP 10
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating,
	rating_count
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND rating_count >= 800
ORDER BY units_sold ASC
)
AS avg_least_selling_products;


/*Do products with ad boosts have higher sales compared to those without ad boosts?*/
-- Average revenue for products that use ads
SELECT ROUND(AVG(total_revenue),2) AS uses_ads
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
SELECT ROUND(AVG(total_revenue),2) AS no_ads
FROM
(
SELECT
	title_orig,
	(units_sold*retail_price) AS total_revenue
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND uses_ad_boosts = 0
) 
AS avg_revenue_no_ads;


/*What are the most common product tags and how do they relate to sales?*/
-- Divides, counts and compares the tags by revenue 
SELECT value, 
	COUNT(value) AS tag_count,
	SUM(units_sold * retail_price) AS total_revenue 
FROM wish.dbo.summer_products
CROSS APPLY STRING_SPLIT(tags, ',') AS tag
GROUP BY value
ORDER BY total_revenue DESC;


/*Is there a relationship between merchant rating and product quality as indicated by the badges?*/
-- Merchant rating and number of badges
SELECT COUNT(merchant_rating) AS merchants_with_badges
FROM wish.dbo.summer_products
WHERE badges_count >= 1;

-- Merchant rating for badge non-holders
SELECT COUNT(merchant_rating) AS merchants_no_badges
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

-- Average rating for merchants with the product quality badge
SELECT AVG(merchant_rating) AS avg_rating
FROM wish.dbo.summer_products
WHERE badge_product_quality = 1;

-- Average rating for merchants that DO NOT hold product quality badge
SELECT AVG(merchant_rating) AS avg_rating
FROM wish.dbo.summer_products
WHERE badge_product_quality = 0;



/*Do companies that sell to many countries have higher revenues?*/
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
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'average'
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
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'average'
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
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'average'
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
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'average'
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
		WHEN (countries_shipped_to) BETWEEN 30 AND 60 THEN 'average'
		WHEN (countries_shipped_to) > 61 THEN 'high'
	END countries_level
FROM wish.dbo.summer_products
)
AS medium_average
WHERE countries_level = 'average';



/*Is there a relationship between merchant profile pictures and sales?*/
SELECT AVG(units_sold) AS avg_units_sold
FROM wish.dbo.summer_products
WHERE merchant_has_profile_picture = 1;

SELECT AVG(units_sold) AS avg_units_sold
FROM wish.dbo.summer_products
WHERE merchant_has_profile_picture = 0;
