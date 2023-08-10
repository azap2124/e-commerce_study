# E-Commerce-Study

## Introduction: Exploring Product Sales and Merchant Metrics
In the dynamic world of e-commerce, businesses thrive on understanding consumer behavior, product trends, and merchant performance to stay ahead in a competitive market. To shed light on these critical aspects, this data analysis project embarks on an exploration of a rich dataset. Our main objective is to tackle questions that explore different dimensions of product sales and merchant-related metrics.

In this data analysis project, we explore women's shopping preferences on the Wish platform. Our objective is to analyze the dataset to uncover valuable insights, shedding light on the e-commerce environment. Through an examination of product popularity, ad's impacts on sales, item's tags and sales relationship, and merchant ratings, we aim to provide a thorough understanding of the factors influencing product performance and merchant success. Additionally, we will investigate the potential correlation between companies selling to multiple countries and higher revenues. We will be using data analysis techniques to offer a data-driven perspective on women's online shopping trends.

We aim to answer the following questions: 
1. What are the most popular products based on units sold? How do they compare in terms of price and rating?
2. Do products with ad boosts have higher sales compared to those without ad boosts?
3. What are the most common product tags and how do they relate to sales?
4. Is there a relationship between merchant rating and product quality as indicated by the badges?
5. Do companies that sell to many countries have higher revenues? 
6. Is there a relationship between merchant profile pictures and sales?

## Preparing our data
The dataset I used can be found [here](https://data.world/jfreex/summer-products-and-sales-performance-in-e-commerce-on-wish). This data comes from the Wish platform. It incorporates data gathered from 2020. 

This data covers information on various product attributes in the database. It includes details such as the original title of the product, its price, retail price, units sold, ad boosts usage, ratings, and rating counts. The dataset also contains information on badges associated with each product, product tags, color, size variation, countries shipped to, origin country, merchant rating count, merchant rating, whether the merchant has a profile picture, and unique product IDs. With this comprehensive dataset, we can gain valuable insights into product trends, merchant performance, and customer preferences in the online marketplace.

I will be using Microsoft SQL Server Management Studio to analyze the data.

## Processing
#### Cleaning the Data
* Used Microsoft Excel to remove duplicates in the data, streamlining the dataset and ensuring that each record is unique.
* For consistency, I converted all columns to the snake_case naming convention.
* Converted data types when importing data to SQL Server to it's corresponding data types in the database schema. This ensures the data is accurately stored in the database, allowing for efficient querying.
* Removed columns that were irrelevant to this analysis, streamlining the dataset further and focusing only on the essential variables pertinent to our research objectives. 
  
## Analysis
### What are the most popular products based on units sold? How do they compare in terms of price and rating?
The following code retrieves the top 10 products from the "summer_products" table in the "wish" database based on the highest number of units sold. The products are then sorted in descending order based on the number of units sold, presenting the most popular products with their corresponding ratings and revenue generated. Here are the results along with their corresponding revenues: 
1. Sleeveless Lace Crop Tops - $2,500,000
2. Summer Stranger Things Tracksuit 2 Piece Outfit - $4,800,000
3. ZANZEA Strand Retro Longtop Kleid Kaftan Dress - $700,000
4. Beachwear Spaghetti Strap Jumpsuit Rompers - $3,300,000
5. Summer Bandage Cut Out Crop Top - $2,200,000
6. Summer V-Neck Loose Jumpsuit - $1,900,000
7. Loose Lace Blouse with Bat Sleeves - $300,000
8. Beach Casual Striped T-shirt Mini Dress - $4,050,000
9. Plus Size Summer V Neck Floral Printed Dresses - $300,000
10. Summer LOVE Printed Sleeveless Tank Top T-Shirt - $250,000
```
-- Top 10 units by revenue
-- Shows highest units sold and their ratings 
SELECT TOP 10
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating,
	rating_count
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL
ORDER BY units_sold DESC;
```

Next, I aimed to analyze the lowest rated products. For a balanced comparison, I found the average rating count across all products. This allowed me to fairly compare the products based on consistent rating counts. The average rating count for all products is **897 reviews**. 
```
-- Average rating count
-- Shows average rating count for all the products 
SELECT AVG(rating_count) AS avg_rating_count
FROM wish. dbo.summer_products;
```

Moving forward, I was curious to identify the top 10 products with the lowest ratings. To ensure a fair comparison, these products were required to have a minimum of 800 reviews and bear the lowest ratings. As we can see, three of them cater to plus-size women, while three products feature v-neck styles. These observations suggest potential areas for improvements. The products and their ratings are: 
1. **Plus Size** Summer Cross Bandage Loose Dress - 2.93
2. Summer Sleepwear Lace Night Dress - 2.97
3. **Plus Size** Summer Sleeveless Low Cut Tank Top - 3.01
4. Summer Tie Dye Printed Two Piece Set - 3.13
5. **Plus Size** Loose V neck long sleeve Floral print dress - 3.18
6. Summer **V-neck** Short Sleeve Dress - 3.19
7. Summer Beachwear **V-neck** Sleeveless Boho Mini Dress - 3.23
8. Summer Bikini Set High waist Bathing Suit - 3.25
9. Summer Loose **V Neck** Blouse Shirt - 3.27
10. One-Piece Push Up Bikini Monokini Swimsuit - 3.28
```
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
```

The average rating for the best-selling products and the least-selling products are provided below. A difference of 0.153 could be considered minor and might not signify a major difference in perceived quality. This observation makes me wonder how the top-selling products manage to achieve such high sales volumes despite the small difference in average ratings. To obtain these averages, I needed to create subqueries.
* Best: 3.946
* Worst: 3.793
```
-- Average rating for top 10 products
SELECT AVG (rating) AS avg_top_rated_products
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
AS avg_top_rated_products;

-- Average rating for least selling products
SELECT AVG (rating) AS avg_top_rated_products
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
AS avg_top_rated_products
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
Tableau Dashboard: https://public.tableau.com/app/profile/angel.zapata2615/viz/E-CommerceDashboard_16827981312070/Dashboard1?publish=yes



