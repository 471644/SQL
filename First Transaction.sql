Medium

Etsy
This is the same question as problem #9 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below on user transactions. Write a query to obtain the list of customers whose first transaction was valued at $50 or more. Output the number of users.

Clarification:

Use the transaction_date field to determine which transaction should be labeled as the first for each user.
Use a specific function (we can't give too much away!) to account for scenarios where a user had multiple transactions on the same day, and one of those was the first.
user_transactions Table:
Column Name	Type
transaction_id	integer
user_id	integer
spend	decimal
transaction_date	timestamp
user_transactions Example Input:
transaction_id	user_id	spend	transaction_date
759274	111	49.50	02/03/2022 00:00:00
850371	111	51.00	03/15/2022 00:00:00
615348	145	36.30	03/22/2022 00:00:00
137424	156	151.00	04/04/2022 00:00:00
248475	156	87.00	04/16/2022 00:00:00
Example Output:
users
1
Explanation: Only user 156 has a first transaction valued over $50.

Solution
To get the ordering of the customer purchases, we can use the ROW_NUMBER window function to get the ordering of customer purchases.

Then, we can use the common table expression (CTE) or subquery to filter customers whose first purchase (denoted as row_num = 1) and is valued at 50 dollars or more (denoted as spend >= 50). Note that this would require the CTE or subquery to include spend also.

CTE vs. Subquery

A CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only. Read here and here for more understanding.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value. We share more resources here (1, 2, 3 on their use cases.

Below are two methods of solving the question using CTE and subquery.

Solution 1: Using CTE

WITH purchase_num AS (
  SELECT 
    user_id, 
    spend, 
    RANK() OVER (
      PARTITION BY user_id 
      ORDER BY transaction_date ASC) AS row_num 
  FROM user_transactions) 

SELECT COUNT(DISTINCT user_id) AS users
FROM purchase_num 
WHERE row_num = 1 
  AND spend >= 50;
Solution 2: Using subquery

SELECT COUNT(DISTINCT user_id) AS users
FROM (
    SELECT 
      user_id, 
      spend, 
      RANK() OVER (
        PARTITION BY user_id 
        ORDER BY transaction_date ASC) AS row_num
    FROM user_transactions) AS purchase_num
WHERE row_num = 1 
  AND spend >= 50;
