Medium

Walmart
This is the same question as problem #13 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the below table on transactions from users. Bucketing users based on their latest transaction date, write a query to obtain the number of users who made a purchase and the total number of products bought for each transaction date.

Output the transaction date, number of users and number of products.

user_transactions Table:
Column Name	Type
product_id	integer
user_id	integer
spend	decimal
transaction_date	timestamp
user_transactions Example Input:
product_id	user_id	spend	transaction_date
3673	123	68.90	07/08/2022 12:00:00
9623	123	274.10	07/08/2022 12:00:00
1467	115	19.90	07/08/2022 12:00:00
2513	159	25.00	07/08/2022 12:00:00
1452	159	74.50	07/10/2022 12:00:00
Example Output:
transaction_date	number_of_users	number_of_products
07/08/2022 12:00:00	2	3
07/10/2022 12:00:00	1	1


Solution
First, we obtain the latest transaction date for each user. This can be done with a common table expression (CTE) or subquery using a RANK window function to rank the transaction dates per user and per product.

Then, using the results from the previous CTE or subquery, we COUNT both the user ids and product ids where the rank is 1 (which refers to the latest transaction) while grouping by each transaction date.

A CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only. Read here and here for more details.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value. We share more resources here (1, 2, 3 on their use cases.

Below are two methods of solving the question using CTE and subquery.

Solution #1: Using CTE

WITH latest_date AS (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS days_rank 
  FROM user_transactions) 
  
SELECT 
  transaction_date, 
  COUNT(DISTINCT user_id) AS number_of_users, 
  COUNT(product_id) AS number_of_products 
FROM latest_date 
WHERE days_rank = 1 
GROUP BY transaction_date 
ORDER BY transaction_date;
Solution #2: Using Subquery

SELECT 
  transaction_date, 
  COUNT(DISTINCT user_id) AS number_of_users, 
  COUNT(product_id) AS number_of_products 
FROM (
  SELECT 
    transaction_date, 
    user_id, 
    product_id, 
    RANK() OVER (PARTITION BY user_id 
      ORDER BY transaction_date DESC) AS days_rank 
  FROM user_transactions) AS latest_date
WHERE days_rank = 1 
GROUP BY transaction_date 
ORDER BY transaction_date;
