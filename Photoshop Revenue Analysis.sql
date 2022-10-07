Medium

Adobe
For every customer that bought Photoshop, return a list of the customers, and the total spent on all the products except for Photoshop products.

Sort your answer by customer ids in ascending order.

adobe_transactions Table:
Column Name	Type
customer_id	integer
product	integer
revenue	integer
adobe_transactions Example Input:
customer_id	product	revenue
123	Photoshop	50
123	Premier Pro	100
123	After Effects	50
234	Illustrator	200
234	Premier Pro	100
Example Output:
customer_id	revenue
123	150
Explanation: User 123 bought Photoshop, Premier Pro + After Effects, spending $150 for those products. We don't output user 234 because they didn't buy Photoshop.

Solution
This is another example of a task where it is wise to take a step back and break the question into smaller steps. Essentially, we are looking for two things:

Who are the customers who bought Photoshop?
How much did those users spend on all Adobe products, excluding photoshop?
Thus, let's start by finding all of the customer_ids that bought Photoshop.

SELECT customer_id 
FROM adobe_transactions 
WHERE product = 'Photoshop';
Now, we'll be able to sum up the revenues while filtering for those customers. Keep in mind that the spend has to exclude Photoshop itself. To do so, let's insert the previous query into a WHERE clause using a subquery.

Note that we use IN (instead of =), as there might be several customer_ids. Then use an additional condition to exclude Photoshop with the <> (not equal to) operator. Finally, just sum the revenue, and group and order it by each customer as requested in the task.

This is what we should end up with:

SELECT 
  customer_id,
  SUM(revenue) AS revenue
FROM adobe_transactions
WHERE customer_id IN (
  SELECT customer_id FROM adobe_transactions WHERE product = 'Photoshop')
  AND product <> 'Photoshop'
GROUP BY customer_id
ORDER BY customer_id;
Another way to do this would be with a SELF JOIN, where we join the table on a filtered version of itself:

SELECT 
  original.customer_id,
  SUM(original.revenue) AS revenue
FROM adobe_transactions AS original
INNER JOIN adobe_transactions AS filtered
  ON original.customer_id = filtered.customer_id
  AND filtered.product = 'Photoshop'
WHERE original.product <> 'Photoshop'
GROUP BY original.customer_id
ORDER BY original.customer_id;
