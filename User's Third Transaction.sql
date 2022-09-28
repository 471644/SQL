Medium

Uber
This is the same question as problem #11 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below on Uber transactions made by users. Write a query to obtain the third transaction of every user. Output the user id, spend and transaction date.

transactions Table:
Column Name	Type
user_id	integer
spend	decimal
transaction_date	timestamp
transactions Example Input:
user_id	spend	transaction_date
111	100.50	01/08/2022 12:00:00
111	55.00	01/10/2022 12:00:00
121	36.00	01/18/2022 12:00:00
145	24.99	01/26/2022 12:00:00
111	89.60	02/05/2022 12:00:00
Example Output:
user_id	spend	transaction_date
111	89.60	02/05/2022 12:00:00


Solution
First, we obtain the order of transaction numbers for each user. We can do this by using the RANK window function where we PARTITION the all transactions by user_id and ORDER BY the transaction_date.

SELECT 
  user_id, 
  spend, 
  transaction_date, 
  RANK() OVER (
    PARTITION BY user_id ORDER BY transaction_date) AS rank_num
FROM transactions;
Here's how the first 5 rows of output looks like:

user_id	spend	transaction_date	rank_num
111	100.50	01/08/2022 12:00:00	1
111	55.00	01/10/2022 12:00:00	2
111	89.60	02/05/2022 12:00:00	3
121	36.00	01/18/2022 12:00:00	1
121	22.20	04/01/2022 12:00:00	2
From there on, we can simply convert the query into a subquery and filter for the users' third transaction which is their third transaction sorted by the transaction date (and is denoted as rank_num = 3).

SELECT 
  user_id, 
  spend, 
  transaction_date
FROM (
  -- Insert the above query here 
) AS trans_num 
WHERE rank_num = 3;
Results:

user_id	spend	transaction_date
111	89.60	02/05/2022 12:00:00
121	67.90	04/03/2022 12:00:00
Apart from using subquery to solve this question, you can also use a CTE. Do you know the differences between a subquery and a CTE?

A CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only. Read here and here for more understanding.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value. We share more resources here (1, 2, 3) on their use cases.

Solution #1: Using Subquery

SELECT 
  user_id,
  spend,
  transaction_date
FROM (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date) AS rank_num
  FROM transactions) AS trans_num 
WHERE rank_num = 3;
Solution #2: Using CTE

WITH trans_num 
AS (
  SELECT 
    user_id, 
    spend, 
    transaction_date, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date) AS rank_num 
  FROM transactions)
 
SELECT 
  user_id, 
  spend, 
  transaction_date 
FROM trans_num 
WHERE rank_num = 3;
