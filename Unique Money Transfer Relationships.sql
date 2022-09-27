Easy

PayPal
You are given a table of PayPal payments showing the payer, the recipient, and the amount paid. A two-way unique relationship is established when two people send money back and forth. Write a query to find the number of two-way unique relationships in this data.

Assumption:

A payer can send money to the same recipient multiple times.
payments Table:
Column Name	Type
payer_id	integer
recipient_id	integer
amount	integer
payments Example Input:
payer_id	recipient_id	amount
101	201	30
201	101	10
101	301	20
301	101	80
201	301	70
Example Output:
unique_relationships
2
Explanation
There are 2 unique two-way relationships between:

ID 101 and ID 201
ID 101 and ID 301

Solution
In a two-way relationship, the payers must also be recipients at some point; therefore, the recipient_id column must also contain the ID of a payer. Keeping this in mind, we can use the set operator INTERSECT to find the two-way relationships as shown below:

SELECT payer_id, recipient_id
FROM payments
INTERSECT
SELECT recipient_id, payer_id
FROM payments;
The query above shows the output for transaction between ID 101 and ID 201 as follows:

payer_id	recipient_id
101	201
201	101
The INTERSECT operator combines two SELECT statements and returns only the distinct results that are common to both queries (meaning there are no duplicates). That is, if there are many back-and-forth transactions between two people, we'll only obtain two rows, as displayed above. If two people have a one-way transaction relationship, those will be eliminated because the payer never becomes the recipient in this situation.

Because back-and-forth transactions between two people should be counted as a single unique relationship, we can simply wrap this query in a subquery (or CTE) and divide the number of rows by a factor of two.

The number of rows can be obtained with a COUNT function as shown below:

SELECT COUNT(payer_id) / 2 AS unique_relationships
FROM (
-- Enter above query here
) AS relationships;
Output:

unique_relationships
1
You can also use a common table expression (CTE) instead of a subquery. Do you know the differences between a subquery and a CTE?

A CTE is a temporary data et to be used as part of a query that can be reused throughout the entire query session. A subquery is a nested query (a query within a query), and unlike a CTE, it can be used within that query only.

Both methods give the same output and perform fairly similarly. The difference is that a CTE is reusable, whereas a subquery can be used in FROM and WHERE clauses.

Solution #1 Using Subquery

SELECT COUNT(payer_id) / 2 AS unique_relationships
FROM ( 
  SELECT payer_id, recipient_id
  FROM payments
  INTERSECT
  SELECT recipient_id, payer_id
  FROM payments) AS relationships;
Solution #2 Using CTE

WITH relationships AS (
SELECT payer_id, recipient_id
FROM payments
INTERSECT
SELECT recipient_id, payer_id
FROM payments)

SELECT COUNT(payer_id) / 2 AS unique_relationships
FROM relationships;