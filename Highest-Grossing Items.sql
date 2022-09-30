Medium

Amazon
This is the same question as problem #12 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing information on Amazon customers and their spend on products belonging to various categories. Identify the top two highest-grossing products within each category in 2022. Output the category, product, and total spend.

product_spend Table:
Column Name	Type
category	string
product	string
user_id	integer
spend	decimal
transaction_date	timestamp
product_spend Example Input:
category	product	user_id	spend	transaction_date
appliance	refrigerator	165	246.00	12/26/2021 12:00:00
appliance	refrigerator	123	299.99	03/02/2022 12:00:00
appliance	washing machine	123	219.80	03/02/2022 12:00:00
electronics	vacuum	178	152.00	04/05/2022 12:00:00
electronics	wireless headset	156	249.90	07/08/2022 12:00:00
electronics	vacuum	145	189.00	07/15/2022 12:00:00
Example Output:
category	product	total_spend
appliance	refrigerator	299.99
appliance	washing machine	219.80
electronics	vacuum	341.00
electronics	wireless headset	249.90

Solution
The first step to solving this Amazon question is writing Ace the Data Science Interview an Amazon review if you liked the book!

To find the highest-grossing products, we must find the total spend by category and product. Note that we must filter by transactions in 2022.

SELECT 
  category, 
  product, 
  SUM(spend) AS total_spend 
FROM product_spend 
WHERE transaction_date >= '2022-01-01' 
  AND transaction_date <= '2022-12-31' 
GROUP BY category, product;
category	product	total_spend
electronics	wireless headset	447.90
appliance	refrigerator	299.99
appliance	washing machine	439.80
electronics	computer mouse	45.00
electronics	vacuum	486.66
The output represents the total spend by category (electronics, appliance) and product.

Then, we reuse the query as a CTE or subquery (in this case, we are using a CTE) and utilize the RANK window function to calculate the ranking by total spend, partition by category and order by the total spend in descending order.

WITH product_category_spend 
AS (
-- Insert query above)

SELECT 
  *, 
  RANK() OVER (
    PARTITION BY category 
    ORDER BY total_spend DESC) AS ranking 
FROM product_category_spend;
category	product	total_spend	ranking
appliance	washing machine	439.80	1
appliance	refrigerator	299.99	2
electronics	vacuum	486.66	1
electronics	wireless headset	447.90	2
electronics	computer mouse	45.00	3
Finally, we use this result and filter for a rank less than or equal to 2 as the question asks for top two highest-grossing products only.

Solution #1: Using CTE

WITH product_category_spend AS (
SELECT 
  category, 
  product, 
  SUM(spend) AS total_spend 
FROM product_spend 
WHERE transaction_date >= '2022-01-01' 
  AND transaction_date <= '2022-12-31' 
GROUP BY category, product
),
top_spend AS (
SELECT *, 
  RANK() OVER (
    PARTITION BY category 
    ORDER BY total_spend DESC) AS ranking 
FROM product_category_spend)

SELECT category, product, total_spend 
FROM top_spend 
WHERE ranking <= 2 
ORDER BY category, ranking;
A CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only. Read here and here for more details.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value. We share more resources here (1, 2, 3 on their use cases.

Solution #2: Using Subquery

SELECT 
  category, 
  product, 
  total_spend 
FROM (
    SELECT 
      *, 
      RANK() OVER (
        PARTITION BY category 
        ORDER BY total_spend DESC) AS ranking 
    FROM (
        SELECT 
          category, 
          product, 
          SUM(spend) AS total_spend 
        FROM product_spend 
        WHERE transaction_date >= '2022-01-01' 
          AND transaction_date <= '2022-12-31' 
        GROUP BY category, product) AS total_spend
  ) AS top_spend 
WHERE ranking <= 2 
ORDER BY category, ranking;
