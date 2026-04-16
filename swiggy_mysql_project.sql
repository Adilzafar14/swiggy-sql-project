-- ================================================================
--        SWIGGY RESTAURANT DATA ANALYSIS — MySQL Project
--        Dataset: 61,425 Restaurants | 534 Cities | India
-- ================================================================
-- Author   : [Adil zafar]
-- Tool     : MySQL Workbench
-- Dataset  : Swiggy Restaurant Dataset (restaurants.csv)
-- GitHub   : https://github.com/[your-username]/swiggy-sql-project
-- ================================================================


-- ================================================================
-- STEP 1 : DATABASE SETUP
-- ================================================================

CREATE DATABASE IF NOT EXISTS swiggy_db;
USE swiggy_db;

DROP TABLE IF EXISTS restaurants;

CREATE TABLE restaurants (
    id           INT            PRIMARY KEY,
    name         VARCHAR(255)   NOT NULL,
    city         VARCHAR(100)   NOT NULL,
    rating       DECIMAL(3,1),
    rating_count INT,
    cuisine      VARCHAR(100),
    cost         INT,
    link         TEXT
);


-- ================================================================
-- STEP 2 : IMPORT DATA
-- ================================================================
-- Method: MySQL Workbench Table Data Import Wizard
-- 1. Right-click on `restaurants` table
-- 2. Select "Table Data Import Wizard"
-- 3. Browse to restaurants.csv → Follow steps → Finish
--
-- OR via LOAD DATA (run this if local_infile is enabled):
--
-- LOAD DATA LOCAL INFILE '/path/to/restaurants.csv'
-- INTO TABLE restaurants
-- FIELDS TERMINATED BY ','
-- ENCLOSED BY '"'
-- LINES TERMINATED BY '\n'
-- IGNORE 1 ROWS
-- (id, name, city, rating, rating_count, cuisine, cost, link);
-- ================================================================


-- ================================================================
-- STEP 3 : VERIFY IMPORT
-- ================================================================

SELECT COUNT(*) AS total_rows FROM restaurants;
-- Expected: 61425

SELECT * FROM restaurants LIMIT 10;


-- ================================================================
-- SECTION A : BASIC QUERIES (Beginner Level)
-- ================================================================

-- A1. Select all columns
SELECT * FROM restaurants LIMIT 20;

-- A2. Show only name, city, cuisine, rating
SELECT name, city, cuisine, rating
FROM restaurants
LIMIT 20;

-- A3. All restaurants in Bangalore
SELECT name, rating, cuisine, cost
FROM restaurants
WHERE city = 'Bangalore'
ORDER BY rating DESC;

-- A4. Restaurants with rating > 4.0
SELECT name, city, rating, cuisine
FROM restaurants
WHERE rating > 4.0
ORDER BY rating DESC;

-- A5. Restaurants with cost <= 300 (budget friendly)
SELECT name, city, cuisine, cost
FROM restaurants
WHERE cost <= 300
ORDER BY cost ASC;

-- A6. All distinct cuisine types
SELECT DISTINCT cuisine
FROM restaurants
WHERE cuisine IS NOT NULL
ORDER BY cuisine;

-- A7. All Biryani restaurants
SELECT name, city, rating, cost
FROM restaurants
WHERE cuisine = 'Biryani'
ORDER BY rating DESC;

-- A8. Top 5 highest rated restaurants
SELECT name, city, rating, cuisine
FROM restaurants
ORDER BY rating DESC
LIMIT 5;

-- A9. Restaurants with more than 1000 ratings
SELECT name, city, rating, rating_count
FROM restaurants
WHERE rating_count > 1000
ORDER BY rating_count DESC;

-- A10. Total number of restaurants
SELECT COUNT(*) AS total_restaurants FROM restaurants;

-- A11. Average cost of all restaurants
SELECT ROUND(AVG(cost), 2) AS avg_cost_for_2 FROM restaurants;

-- A12. Restaurant names and costs ordered by cost ascending
SELECT name, city, cost
FROM restaurants
ORDER BY cost ASC;

-- A13. Restaurants in Lucknow ordered by rating
SELECT name, rating, cuisine, cost
FROM restaurants
WHERE city = 'Lucknow'
ORDER BY rating DESC;

-- A14. Top 10 most expensive restaurants
SELECT name, city, cuisine, cost
FROM restaurants
ORDER BY cost DESC
LIMIT 10;

-- A15. Restaurants whose name contains 'McDonald'
SELECT name, city, rating, cost
FROM restaurants
WHERE name LIKE '%McDonald%';


-- ================================================================
-- SECTION B : AGGREGATIONS & GROUP BY (Intermediate Level)
-- ================================================================

-- B1. Average rating per city
SELECT
    city,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*)              AS total_restaurants
FROM restaurants
GROUP BY city
ORDER BY avg_rating DESC;

-- B2. Number of restaurants in each city
SELECT city, COUNT(*) AS restaurant_count
FROM restaurants
GROUP BY city
ORDER BY restaurant_count DESC;

-- B3. Max and min cost for each cuisine
SELECT
    cuisine,
    MAX(cost)             AS max_cost,
    MIN(cost)             AS min_cost,
    ROUND(AVG(cost), 0)   AS avg_cost
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
ORDER BY avg_cost DESC;

-- B4. Cuisines with more than 10 restaurants
SELECT cuisine, COUNT(*) AS count
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
HAVING COUNT(*) > 10
ORDER BY count DESC;

-- B5. Top 3 cities with most restaurants
SELECT city, COUNT(*) AS count
FROM restaurants
GROUP BY city
ORDER BY count DESC
LIMIT 3;

-- B6. Average cost per cuisine
SELECT
    cuisine,
    ROUND(AVG(cost), 0) AS avg_cost,
    COUNT(*)            AS restaurant_count
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
ORDER BY avg_cost DESC;

-- B7. Cities where average rating > 4.0
SELECT
    city,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*)              AS total
FROM restaurants
GROUP BY city
HAVING AVG(rating) > 4.0
ORDER BY avg_rating DESC;

-- B8. Total rating_count (reviews) per city
SELECT
    city,
    SUM(rating_count)  AS total_reviews,
    COUNT(*)           AS total_restaurants
FROM restaurants
GROUP BY city
ORDER BY total_reviews DESC;

-- B9. Rating distribution — how many restaurants in each bracket
SELECT
    CASE
        WHEN rating >= 4.5 THEN 'Excellent (4.5-5.0)'
        WHEN rating >= 4.0 THEN 'Good (4.0-4.4)'
        WHEN rating >= 3.5 THEN 'Average (3.5-3.9)'
        WHEN rating >= 3.0 THEN 'Below Average (3.0-3.4)'
        ELSE 'Poor (below 3.0)'
    END AS rating_category,
    COUNT(*) AS count
FROM restaurants
GROUP BY rating_category
ORDER BY count DESC;

-- B10. Price segment analysis
SELECT
    CASE
        WHEN cost <= 200  THEN 'Budget (upto 200)'
        WHEN cost <= 500  THEN 'Affordable (201-500)'
        WHEN cost <= 1000 THEN 'Mid-range (501-1000)'
        ELSE 'Premium (above 1000)'
    END AS price_segment,
    COUNT(*)              AS restaurant_count,
    ROUND(AVG(rating), 2) AS avg_rating
FROM restaurants
GROUP BY price_segment
ORDER BY restaurant_count DESC;

-- B11. Cuisines ordered by average rating descending
SELECT
    cuisine,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*)              AS count
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
ORDER BY avg_rating DESC;

-- B12. Cities having more than one cuisine type
SELECT city, COUNT(DISTINCT cuisine) AS cuisine_variety
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY city
HAVING COUNT(DISTINCT cuisine) > 1
ORDER BY cuisine_variety DESC;


-- ================================================================
-- SECTION C : SUBQUERIES (Intermediate-Advanced)
-- ================================================================

-- C1. Restaurants with rating above overall average
SELECT name, city, rating, cuisine
FROM restaurants
WHERE rating > (SELECT AVG(rating) FROM restaurants)
ORDER BY rating DESC;

-- C2. Restaurants costing more than average cost
SELECT name, city, cuisine, cost
FROM restaurants
WHERE cost > (SELECT AVG(cost) FROM restaurants)
ORDER BY cost DESC;

-- C3. Restaurant(s) with maximum rating_count
SELECT name, city, rating, rating_count, cuisine
FROM restaurants
WHERE rating_count = (SELECT MAX(rating_count) FROM restaurants);

-- C4. Highest rated restaurant in each city (correlated subquery)
SELECT r.city, r.name, r.rating, r.cuisine
FROM restaurants r
WHERE r.rating = (
    SELECT MAX(r2.rating)
    FROM restaurants r2
    WHERE r2.city = r.city
)
ORDER BY r.city;

-- C5. How many restaurants have rating above average?
SELECT COUNT(*) AS above_avg_count
FROM restaurants
WHERE rating > (SELECT AVG(rating) FROM restaurants);


-- ================================================================
-- SECTION D : ADVANCED — CTEs & WINDOW FUNCTIONS
-- ================================================================

-- D1. Top 3 restaurants per city by rating (RANK)
WITH ranked_restaurants AS (
    SELECT
        name, city, rating, cuisine, cost,
        RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS city_rank
    FROM restaurants
)
SELECT city, city_rank, name, rating, cuisine, cost
FROM ranked_restaurants
WHERE city_rank <= 3
ORDER BY city, city_rank;

-- D2. Running average cost within each city
SELECT
    city,
    name,
    cost,
    ROUND(AVG(cost) OVER (PARTITION BY city), 0) AS city_avg_cost,
    cost - ROUND(AVG(cost) OVER (PARTITION BY city), 0) AS diff_from_avg
FROM restaurants
ORDER BY city, cost DESC;

-- D3. Cuisines ranked by average rating (DENSE_RANK)
SELECT
    cuisine,
    ROUND(AVG(rating), 2) AS avg_rating,
    COUNT(*)              AS count,
    DENSE_RANK() OVER (ORDER BY AVG(rating) DESC) AS cuisine_rank
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
HAVING COUNT(*) > 50
ORDER BY cuisine_rank;

-- D4. Top 10% restaurants by review count (NTILE)
WITH percentile_data AS (
    SELECT
        name, city, rating, rating_count, cuisine,
        NTILE(10) OVER (ORDER BY rating_count DESC) AS decile
    FROM restaurants
)
SELECT name, city, rating, rating_count, cuisine
FROM percentile_data
WHERE decile = 1
ORDER BY rating_count DESC
LIMIT 20;

-- D5. Best value restaurants — high rating, low cost (CTE)
WITH value_scored AS (
    SELECT *,
        ROUND((rating * 10) - (cost / 100.0), 2) AS value_score
    FROM restaurants
    WHERE rating >= 4.0 AND cost > 0
)
SELECT name, city, cuisine, rating, cost, value_score
FROM value_scored
ORDER BY value_score DESC
LIMIT 20;

-- D6. Row number within each cuisine by rating
SELECT
    ROW_NUMBER() OVER (PARTITION BY cuisine ORDER BY rating DESC) AS row_num,
    cuisine, name, city, rating
FROM restaurants
WHERE cuisine IS NOT NULL
ORDER BY cuisine, row_num
LIMIT 50;

-- D7. Cities with cost above national average (CTE chain)
WITH city_avg AS (
    SELECT city, ROUND(AVG(cost), 0) AS avg_cost
    FROM restaurants
    GROUP BY city
),
national AS (
    SELECT ROUND(AVG(cost), 0) AS national_avg FROM restaurants
)
SELECT
    c.city,
    c.avg_cost,
    n.national_avg,
    (c.avg_cost - n.national_avg) AS above_by
FROM city_avg c
CROSS JOIN national n
WHERE c.avg_cost > n.national_avg
ORDER BY above_by DESC
LIMIT 15;


-- ================================================================
-- SECTION E : BUSINESS INSIGHTS
-- NOTE: Revenue = cost × rating_count (estimated)
-- ================================================================

-- E1. Restaurant visited by least people in Abohar
SELECT name, city, rating_count, rating
FROM restaurants
WHERE city = 'Abohar'
ORDER BY rating_count ASC
LIMIT 1;

-- E2. Restaurant with maximum estimated revenue across India
SELECT
    name, city, cuisine, cost, rating_count,
    (cost * rating_count) AS estimated_revenue
FROM restaurants
ORDER BY estimated_revenue DESC
LIMIT 1;

-- E3. How many restaurants have rating above average?
SELECT COUNT(*) AS count_above_avg
FROM restaurants
WHERE rating > (SELECT AVG(rating) FROM restaurants);

-- E4. Delhi restaurant with highest revenue
SELECT
    name, city, cuisine, cost, rating_count,
    (cost * rating_count) AS estimated_revenue
FROM restaurants
WHERE city = 'Delhi'
ORDER BY estimated_revenue DESC
LIMIT 1;

-- E5. Restaurant chain with most outlets
SELECT
    name,
    COUNT(*)              AS outlet_count,
    COUNT(DISTINCT city)  AS cities_present
FROM restaurants
GROUP BY name
ORDER BY outlet_count DESC
LIMIT 10;

-- E6. Restaurant chain with maximum total revenue
SELECT
    name,
    COUNT(*)                      AS outlets,
    SUM(cost * rating_count)      AS total_revenue
FROM restaurants
GROUP BY name
ORDER BY total_revenue DESC
LIMIT 10;

-- E7. City with maximum restaurants
SELECT city, COUNT(*) AS count
FROM restaurants
GROUP BY city
ORDER BY count DESC
LIMIT 1;

-- E8. City with maximum estimated revenue
SELECT
    city,
    SUM(cost * rating_count) AS total_revenue,
    COUNT(*)                 AS restaurants
FROM restaurants
GROUP BY city
ORDER BY total_revenue DESC
LIMIT 1;

-- E9. 10 least expensive cuisines (avg cost)
SELECT
    cuisine,
    ROUND(AVG(cost), 0) AS avg_cost,
    COUNT(*)            AS count
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
HAVING COUNT(*) > 10
ORDER BY avg_cost ASC
LIMIT 10;

-- E10. 10 most expensive cuisines (avg cost)
SELECT
    cuisine,
    ROUND(AVG(cost), 0) AS avg_cost,
    COUNT(*)            AS count
FROM restaurants
WHERE cuisine IS NOT NULL
GROUP BY cuisine
HAVING COUNT(*) > 10
ORDER BY avg_cost DESC
LIMIT 10;

-- E11. City having most Biryani restaurants
SELECT city, COUNT(*) AS biryani_count
FROM restaurants
WHERE cuisine = 'Biryani'
GROUP BY city
ORDER BY biryani_count DESC
LIMIT 5;

-- E12. Top 10 restaurants with unique name (appear only once in dataset)
SELECT name, city, cuisine, rating, cost
FROM restaurants
WHERE name IN (
    SELECT name FROM restaurants
    GROUP BY name
    HAVING COUNT(*) = 1
)
ORDER BY rating DESC
LIMIT 10;


-- ================================================================
-- SECTION F : SUMMARY DASHBOARD (Run at end)
-- ================================================================

SELECT
    (SELECT COUNT(*)                    FROM restaurants)                    AS total_restaurants,
    (SELECT COUNT(DISTINCT city)        FROM restaurants)                    AS cities_covered,
    (SELECT COUNT(DISTINCT cuisine)     FROM restaurants WHERE cuisine IS NOT NULL) AS cuisines,
    (SELECT ROUND(AVG(rating), 2)       FROM restaurants)                    AS overall_avg_rating,
    (SELECT ROUND(AVG(cost), 0)         FROM restaurants)                    AS overall_avg_cost,
    (SELECT city FROM restaurants GROUP BY city ORDER BY COUNT(*) DESC LIMIT 1) AS top_city,
    (SELECT cuisine FROM restaurants WHERE cuisine IS NOT NULL GROUP BY cuisine ORDER BY COUNT(*) DESC LIMIT 1) AS top_cuisine,
    (SELECT name FROM restaurants ORDER BY rating_count DESC LIMIT 1)        AS most_reviewed_restaurant;

-- ================================================================
-- END OF PROJECT
-- ================================================================
