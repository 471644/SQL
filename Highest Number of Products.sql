Easy

eBay
This is the same question as problem #5 in the SQL Chapter of Ace the Data Science Interview!

Assume that you are given the table below containing information on various orders made by eBay customers. Write a query to obtain the user IDs and number of products purchased by the top 3 customers; these customers must have spent at least $1,000 in total.

Output the user id and number of products in descending order. To break ties (i.e., if 2 customers both bought 10 products), the user who spent more should take precedence.

user_transactions Table:
Column Name	Type
transaction_id	integer
product_id	integer
user_id	integer
spend	decimal
user_transactions Example Input:
transaction_id	product_id	user_id	spend
131432	1324	128	699.78
131433	1313	128	501.00
153853	2134	102	1001.20
247826	8476	133	1051.00
247265	3255	133	1474.00
136495	3677	133	247.56
Example Output:
user_id	product_num
133	3
128	2
102	1


Solution
First, we need to obtain a count of products by users by using the COUNT function on the product_id field and grouping the results by the user_id field.

We will use a ’ HAVING’ clause to filter users who spent at least 1000.

HAVING SUM(spend) >= 1000

Click here to learn more about the difference between HAVING and WHERE.

For the final step, we order the user IDs by the count of the products they've bought in descending order and take the top 3.

To break ties where 2 users have the same count of product IDs, we should choose the user who spent more. We can do so by applying a SUM(spend) DESC to the same ORDER BY clause.

Solution:

SELECT 
  user_id, 
  COUNT(product_id) AS product_num 
FROM user_transactions 
GROUP BY user_id 
HAVING SUM(spend) >= 1000 
ORDER BY product_num DESC, SUM(spend) DESC
LIMIT 3;
