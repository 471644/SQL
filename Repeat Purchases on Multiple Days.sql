Medium

Stitch Fix
This is the same question as problem #7 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing information on user purchases. Write a query to obtain the number of users who purchased the same product on two or more different days. Output the number of unique users.

purchases Table:
Column Name	Type
user_id	integer
product_id	integer
quantity	integer
purchase_date	datetime
purchasesExample Input:
user_id	product_id	quantity	purchase_date
536	3223	6	01/11/2022 12:33:44
827	3585	35	02/20/2022 14:05:26
536	3223	5	03/02/2022 09:33:28
536	1435	10	03/02/2022 08:40:00
827	2452	45	04/09/2022 00:00:00
Example Output:
users_num
1

Solution
We can’t simply perform a count since, by definition, the purchases must have been made on different days (and for the same products).

To address this issue, we use the window function RANK while partitioning by user id and product id and then sort the result by the purchase date field (not time), using the DATE function to convert the DATETIME to a DATE type. We are sorting by date and not timestamp so that we do not count multiple purchases of the same product on the same day.

From this inner subquery, we then obtain the distinct count of the user ids for which purchase number is 2 (denoted as =2). Note that we don’t need count above 2 (denoted as >= 2) since any purchase number above 2 denotes multiple products.

Solution #1: Using Subquery

SELECT COUNT(DISTINCT user_id) AS users_num 
FROM (
  SELECT 
    user_id, 
    RANK() OVER (
      PARTITION BY user_id, product_id 
      ORDER BY DATE(purchase_date) ASC) AS purchase_no 
  FROM purchases) AS ranking 
WHERE purchase_no = 2;
Solution #2: Using CTE

WITH ranking 
AS (
  SELECT 
    user_id, 
    RANK() OVER (
      PARTITION BY user_id, product_id 
      ORDER BY DATE(purchase_date) ASC) AS purchase_no 
  FROM purchases) 

SELECT COUNT(DISTINCT user_id) AS users_num 
FROM ranking 
WHERE purchase_no = 2;
Solution #3: Using Self-Join

SELECT COUNT(DISTINCT p1.user_id)
FROM purchases AS p1
JOIN purchases AS p2
  ON p1.product_id = p2.product_id
    AND p1.purchase_date::DATE <> p2.purchase_date::DATE;
