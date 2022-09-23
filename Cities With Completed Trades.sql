Easy

Robinhood
This is the same question as problem #2 in the SQL Chapter of Ace the Data Science Interview!

You are given the tables below containing information on Robinhood trades and users. Write a query to list the top three cities that have the most completed trade orders in descending order.

Output the city and number of orders.

trades Table:
Column Name	Type
order_id	integer
user_id	integer
price	decimal
quantity	integer
status	string('Completed' ,'Cancelled')
timestamp	datetime
trades Example Input:
order_id	user_id	price	quantity	status	timestamp
100101	111	9.80	10	Cancelled	08/17/2022 12:00:00
100102	111	10.00	10	Completed	08/17/2022 12:00:00
100259	148	5.10	35	Completed	08/25/2022 12:00:00
100264	148	4.80	40	Completed	08/26/2022 12:00:00
100305	300	10.00	15	Completed	09/05/2022 12:00:00
100400	178	9.90	15	Completed	09/09/2022 12:00:00
100565	265	25.60	5	Completed	12/19/2022 12:00:00
users Table:
Column Name	Type
user_id	integer
city	string
email	string
signup_date	datetime
users Example Input:
user_id	city	email	signup_date
111	San Francisco	rrok10@gmail.com	08/03/2021 12:00:00
148	Boston	sailor9820@gmail.com	08/20/2021 12:00:00
178	San Francisco	harrypotterfan182@gmail.com	01/05/2022 12:00:00
265	Denver	shadower_@hotmail.com	02/26/2022 12:00:00
300	San Francisco	houstoncowboy1122@hotmail.com	06/30/2022 12:00:00
Example Output:
city	total_orders
San Francisco	3
Boston	2
Denver	1
Explanation
In this example, San Francisco has first place with 3 orders, Boston has second place with 2 orders, and Denver has third place with 1 order.

Solution
Let's start small by joining the trades and users table based on the related column user_id.

Psst, do you know why we have to join the tables? That's because the 'Completed' order status is residing in the trades table whereas the cities are in the users table.

In the SELECT statement, we pull the city field from the users table and the order_id field from the trades table.

SELECT users.city, trades.order_id
FROM trades
INNER JOIN users
  ON trades.user_id = users.user_id;
Output (showing the first 5 rows only):

city	order_id
San Francisco	100777
San Francisco	100102
San Francisco	100101
Boston	100259
Boston	100264
Now that we have the table containing information on the city and orders, let's retrieve the completed orders by filtering 'Completed' orders. Note that we also want the number of orders which we can find using the COUNT function.

SELECT 
  users.city,
  COUNT(trades.order_id) AS total_orders
FROM trades 
INNER JOIN users 
  ON trades.user_id = users.user_id
WHERE trades.status = 'Completed'
GROUP BY users.city;
GROUP BY statement is often used with aggregate functions (i.e. COUNT, MAX, MIN, SUM, AVG) to group the results by non-aggregate columns. Did you notice that our output is grouped by the city column?

city	total_orders
Boston	1
New York	2
San Francisco	4
Finally, to sort the output from the highest number of completed orders, we sort it in descending order in the ORDER BY clause and LIMIT the results to the top 3 orders.

city	total_orders
San Francisco	4
Boston	3
Denver	2
Full solution:

SELECT 
  users.city, 
  COUNT(trades.order_id) AS total_orders 
FROM trades 
INNER JOIN users 
  ON trades.user_id = users.user_id 
WHERE trades.status = 'Completed' 
GROUP BY users.city 
ORDER BY total_orders DESC
LIMIT 3;