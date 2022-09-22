Assume you are given the tables below about Facebook pages and page likes. Write a query to return the page IDs of all the Facebook pages that don't have any likes. The output should be in ascending order.

pages Table:
Column Name	Type
page_id	integer
name	varchar
pages Example Input:
page_id	name
20001	SQL Solutions
20045	Brain Exercises
20701	Tips for Data Analysts
page_likes Table:
Column Name	Type
user_id	integer
page_id	integer
liked_date	datetime
page_likes Example Input:
user_id	page_id	liked_date
111	20001	04/08/2022 00:00:00
121	20045	03/12/2022 00:00:00
156	20001	07/25/2022 00:00:00
Example Output:
page_id
20701
Explanation: The page with ID 20701 has no likes.
-----------------------------------------------------------------------------------------------------------------------------------------------------
Solution
There are two ways to go about it. Either LEFT JOIN or RIGHT JOIN can be established between tables pages and page_likes or a subquery can be used to identify which pages have not been liked by any user.

The LEFT JOIN clause starts selecting data from the left table. For each row in the left table (pages), it compares the value in the page_id column with the value of each row in the page_id column in the right table (page_likes).

When page_id are found on both sides, the LEFT JOIN clause creates a new row that contains columns that appear in the SELECT clause and adds this row to the result set.

In case page_id frompages table is not available in page_likes table, the LEFT JOIN clause also creates a new row that contains columns that appear in the SELECT clause. In addition, it fills the columns that come from the page_likes (right table) with NULL. Rows having NULL values in the result is the set of the solution.

Read about LEFT JOIN [1] and RIGHT JOIN [2] to get the better understanding.

Solution #1: Using LEFT OUTER JOIN

SELECT pages.page_id
FROM pages
LEFT OUTER JOIN page_likes AS likes
  ON pages.page_id = likes.page_id
WHERE likes.page_id IS NULL;
Another solution to this problem, since pages with NO LIKES are needed, would be the NOT EXISTS clause. It's an appropriate and efficient operator to get this information. Check out here.

Both methods give the same output.

Solution #2: Using NOT EXISTS clause

SELECT page_id
FROM pages
WHERE NOT EXISTS (
  SELECT 1
  FROM page_likes AS likes
  WHERE likes.page_id = pages.page_id);