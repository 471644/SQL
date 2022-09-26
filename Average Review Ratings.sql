Easy

Amazon
Given the reviews table, write a query to get the average stars for each product every month.

The output should include the month in numerical value, product id, and average star rating rounded to two decimal places. Sort the output based on month followed by the product id.

P.S. If you've read the Ace the Data Science Interview, and liked it, consider writing us a review?

reviews Table:
Column Name	Type
review_id	integer
user_id	integer
submit_date	datetime
product_id	integer
stars	integer (1-5)
reviews Example Input:
review_id	user_id	submit_date	product_id	stars
6171	123	06/08/2022 00:00:00	50001	4
7802	265	06/10/2022 00:00:00	69852	4
5293	362	06/18/2022 00:00:00	50001	3
6352	192	07/26/2022 00:00:00	69852	3
4517	981	07/05/2022 00:00:00	69852	2
Example Output:
mth	product	avg_stars
6	50001	3.50
6	69852	4.00
7	69852	2.50
Explanation
In June (month #6), product 50001 had two ratings - 4 and 3, resulting in an average star rating of 3.5.

Solution
As we can see, there is no month column in the reviews table. First, we have to extract the month from the submit_date column.

There is a simple function to extract month from a date. Here's the syntax: EXTRACT(MONTH from column_name)

You can look at this page for more explanation on the EXTRACT function.

After extracting the month in numerical values, get the average of the star ratings and round them to two decimal places. It can be achieved using the functions AVG() and ROUND(). Please refer [1] & [2] for some reading on the functions.

Solution:

SELECT 
  EXTRACT(MONTH FROM submit_date) AS mth,
  product_id,
  ROUND(AVG(stars), 2) AS avg_stars
FROM reviews
GROUP BY EXTRACT(MONTH FROM submit_date), product_id
ORDER BY mth, product_id;
Why can't we write mth in the GROUP BY clause, but we can do so in the ORDER BY clause?

This is the order of sequence of how SQL executes the solution's query from top to bottom:

1 - FROM reviews
2 - GROUP BY EXTRACT(MONTH FROM submit_date) ...
3 - SELECT EXTRACT(MONTH FROM submit_date) AS mth ...
4 - ORDER BY mth ...
SQL runs the GROUP BY clause BEFORE the SELECT statement. Hence, when SQL executes the grouping, it cannot say GROUP BY mth because the mth column only exists AFTER the SELECT statement is executed.

The reason why we can execute mth column in the ORDER BY clause is because it's run after the SELECT statement and mth column has been created.

This is a very popular question in technical interviews so make sure that you learn the order of SQL execution well!