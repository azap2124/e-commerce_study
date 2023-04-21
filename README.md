# E-Commerce-Study

### NOTES: 
-- Had a really hard time importing files into SQL Server. My solution was to save the files as a Excel Workbook rather than a .csv and it seems to be working. 

#### Possible questions to answer: 
1. What are the most popular products based on units sold? How do they compare in terms of price and rating?
2. Do products with ad boosts have higher sales compared to those without ad boosts?
3. Is there a correlation between product rating and the number of ratings received?
4. What are the most common product tags and how do they relate to sales?
5. Is there a relationship between merchant rating and product quality as indicated by the badges?
6. What are the most common countries where products are shipped to?
7. What factors are associated with higher ratings, such as product color, size, or merchant rating?
8. Is there a relationship between merchant profile pictures and sales?

#### CODES:
-- Top 20 units by revenue: shows top 20 products with highest revenues
-- Average rating counts: to calculate average rating and be able to compare products bases on fair rating counts
-- Top 20 worst rated products: products with at least 800 reviews and rated the worst


```
-- Top 20 units by revenue
SELECT TOP 20
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL
ORDER BY total_revenue DESC;


-- Average rating counts
SELECT AVG(rating_count)
FROM wish. dbo.summer_products;


-- Top 20 worst rated products
SELECT TOP 20
	title_orig,
	units_sold,
	retail_price,
	(units_sold*retail_price) AS total_revenue,
	rating,
	rating_count
FROM wish. dbo.summer_products
WHERE title_orig IS NOT NULL AND rating_count > 800
ORDER BY rating;
```
