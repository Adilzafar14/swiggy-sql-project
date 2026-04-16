🍽️ Swiggy Restaurant Data — SQL Analysis Project
![SQL](https://img.shields.io/badge/SQL-MySQL-blue)
![Dataset](https://img.shields.io/badge/Dataset-61%2C425%20Restaurants-orange)
![Cities](https://img.shields.io/badge/Cities-534-green)
![Queries](https://img.shields.io/badge/Queries-37-purple)
> A complete \*\*MySQL project\*\* built on real Swiggy restaurant data —  
> analyzing 61,000+ restaurants across 534 Indian cities.
---
📁 Project Structure
```
swiggy-sql-project/
├── swiggy\_mysql\_project.sql   ← Main SQL file (all 37 queries)
└── restaurants.csv            ← Raw dataset (61,425 rows)
```
---
🗃️ Dataset Overview
Column	Type	Description
id	INT	Unique restaurant ID
name	VARCHAR	Restaurant name
city	VARCHAR	City location
rating	DECIMAL	Rating (1.0 – 5.0)
rating_count	INT	Total number of ratings
cuisine	VARCHAR	Type of cuisine
cost	INT	Average cost for 2 people (₹)
link	TEXT	Swiggy URL
Dataset Stats:
🏪 Total Restaurants: 61,425
🌆 Cities Covered: 534
🍛 Unique Cuisines: 100+
⭐ Rating Range: 1.0 – 5.0
💰 Cost Range: ₹1 – ₹3,000
---
📊 Queries Covered
Section A — Basic Queries (15 Queries)
SELECT, WHERE, ORDER BY, LIMIT
LIKE, DISTINCT, comparison operators
Section B — Aggregations (12 Queries)
GROUP BY, HAVING
AVG, COUNT, SUM, MAX, MIN
CASE WHEN for custom categories
Section C — Subqueries (5 Queries)
Correlated subqueries
Nested SELECT statements
Section D — Advanced SQL (7 Queries)
Common Table Expressions (CTEs)
Window Functions: RANK, DENSE_RANK, ROW_NUMBER, NTILE
LAG, LEAD functions
Section E — Business Insights (12 Queries)
Revenue estimation (cost × rating_count)
Hidden gems & crowd favorites
Restaurant chain analysis
City-wise market analysis
Section F — Summary Dashboard (1 Query)
Complete project summary in a single query
---
🔍 Key Findings
Insight	Result
🏙️ City with most restaurants	Bangalore (6,580+)
🍛 Most popular cuisine	North Indian
🥘 Biryani capital	Hyderabad
💰 Budget restaurants (≤₹300)	~70% of all restaurants
⭐ Avg rating across India	~3.7
---
🚀 How to Run
Step 1 — Open MySQL Workbench
Launch MySQL Workbench and connect to your local server.
Step 2 — Import the SQL file
```
File → Open SQL Script → swiggy\_mysql\_project.sql
```
Step 3 — Import CSV data
```
Right-click on restaurants table
→ Table Data Import Wizard
→ Select restaurants.csv
→ Follow steps → Finish
```
Step 4 — Run queries
Execute section by section using `Ctrl + Enter` or the run button.
---
💡 Sample Queries
Top 5 highest rated restaurants:
```sql
SELECT name, city, rating, cuisine
FROM restaurants
ORDER BY rating DESC
LIMIT 5;
```
City with maximum revenue:
```sql
SELECT city,
       SUM(cost \* rating\_count) AS total\_revenue
FROM restaurants
GROUP BY city
ORDER BY total\_revenue DESC
LIMIT 1;
```
Top 3 restaurants per city (Window Function):
```sql
WITH ranked AS (
  SELECT name, city, rating,
    RANK() OVER (PARTITION BY city ORDER BY rating DESC) AS rnk
  FROM restaurants
)
SELECT \* FROM ranked WHERE rnk <= 3;
```
---
🛠️ Tools Used
Database: MySQL
Tool: MySQL Workbench
Dataset: Swiggy (real data)
Skills: SQL — Basic to Advanced
---
👤 Author
Adil Zafar  
📌 GitHub Profile
---
⭐ If you found this project helpful, do give it a star!
