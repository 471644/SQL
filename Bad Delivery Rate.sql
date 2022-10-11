Hard

DoorDash
DoorDash's Growth Team is trying to make sure new users (those who are making orders in their first 14 days) have a great experience on all their orders in their 2 weeks on the platform.

Unfortunately, many deliveries are being messed up because:

the orders are being completed incorrectly (missing items, wrong order, etc.)
the orders aren't being received (wrong address, wrong drop off spot)
the orders are being delivered late (the actual delivery time is 30 minutes later than when the order was placed). Note that the estimated_delivery_timestamp is automatically set to 30 minutes after the order_timestamp.
Write a query to find the bad experience rate in the first 14 days for new users who signed up in June 2022. Output the percentage of bad experience rounded to 2 decimal places.

P.S. If you've read the Ace the Data Science Interview and liked it, consider writing us a review?

orders Table:
Column Name	Type
order_id	integer
customer_id	integer
trip_id	integer
status	string ('completed successfully', 'completed incorrectly', 'never received')
order_timestamp	timestamp
orders Example Input:
order_id	customer_id	trip_id	status	order_timestamp
727424	8472	100463	completed successfully	06/05/2022 09:12:00
242513	2341	100482	completed incorrectly	06/05/2022 14:40:00
141367	1314	100362	completed incorrectly	06/07/2022 15:03:00
582193	5421	100657	never_received	07/07/2022 15:22:00
253613	1314	100213	completed successfully	06/12/2022 13:43:00
trips Table:
Column Name	Type
dasher_id	integer
trip_id	integer
estimated_delivery_timestamp	timestamp
actual_delivery_timestamp	timestamp
trips Example Input:
dasher_id	trip_id	estimated_delivery_timestamp	actual_delivery_timestamp
101	100463	06/05/2022 09:42:00	06/05/2022 09:38:00
102	100482	06/05/2022 15:10:00	06/05/2022 15:46:00
101	100362	06/07/2022 15:33:00	06/07/2022 16:45:00
102	100657	07/07/2022 15:52:00	-
103	100213	06/12/2022 14:13:00	06/12/2022 14:10:00
customers Table:
Column Name	Type
customer_id	integer
signup_timestamp	timestamp
customers Example Input:
customer_id	signup_timestamp
8472	05/30/2022 00:00:00
2341	06/01/2022 00:00:00
1314	06/03/2022 00:00:00
1435	06/05/2022 00:00:00
5421	06/07/2022 00:00:00
Example Output:
bad_experience_pct
75.00
Order 727424 es excluded as the order is made after the first 14 days upon signing up. There are 4 orders, however, there are only 3 orders with bad experiences as one of the orders 253613 is completed successfully. So, 3 out of 4 orders are 75% bad experience.

Solution
This is a multi-step approach, so let's break it down into piecemeal.

First, we identify the points requiring our attention:

Customers who signed up in June 2022.
Orders made within the first 14 days from customers' signup date.
Orders with status of 'completed incorrectly' and 'never received'.
Orders with actual delivery times later than the estimated delivery times because these orders signify late orders and contribute to the bad experience rating.
Orders with null actual delivery times because these orders failed to be delivered.
Based on these points, here's our action plan:

Join customers and orders table and then obtain data with customers in June 2022 with orders within the first 14 days of signup.
Join query from #1 with trips table.
Filter for orders with bad experiences, late orders and null delivery times.
Calculate the percentage of bad experiences.
Step 1

Let's kickstart by joining customers and orders tables based on related column user_id.

Then, in the WHERE clause we filter the customers' signup_date to June 2022 and ensure that orders were made between the customer's signup_date and customer's signup_date + 14 days.

SELECT 
  orders.order_id,
  orders.trip_id,
  orders.status
FROM customers
INNER JOIN orders
  ON customers.customer_id = orders.customer_id
WHERE EXTRACT(MONTH FROM customers.signup_timestamp) = 6
  AND EXTRACT(YEAR FROM customers.signup_timestamp) = 2022
  AND customers.signup_timestamp + interval '14 days' > orders.order_timestamp;
The table represents the orders within the first 14 days made by customers who signed up in June 2022.

Showing the first 5 rows of output:

order_id	trip_id	status
242513	100482	completed incorrectly
141367	100362	completed incorrectly
123413	100134	completed successfully
393852	100857	completed successfully
642634	100232	never received
Step 2

Subsequently, we wrap the codes in #1 in a common table expression (CTE) or subquery and join with trips table based on a foreign key, trip_id.

WITH june22_orders 
AS (
-- Insery query from Step 1)

SELECT *
FROM june22_orders AS june22
INNER JOIN trips
  ON june22.trip_id = trips.trip_id;
Showing the first 5 rows of output:

order_id	trip_id	status	dasher_id	trip_id	estimated_delivery_timestamp	actual_delivery_timestamp
242513	100482	completed incorrectly	102	100482	06/05/2022 07:10:00	06/05/2022 07:46:00
141367	100362	completed incorrectly	101	100362	06/07/2022 07:33:00	06/07/2022 08:45:00
642634	100232	never received	103	100232	06/08/2022 14:30:00	
123413	100134	completed successfully	104	100134	06/15/2022 14:00:00	06/15/2022 13:58:00
393852	100857	completed successfully	101	100857	06/16/2022 01:15:00	06/16/2022 01:13:00
In the 1st row the order is completed incorrectly because the customer received the order AFTER the estimated delivery time.
In the 3rd row's order id 642634, the actual delivery time is null? That's because the customer didn't even receive their order and we'll have to account this order into the bad experience rating.
Step 3

Next, we filter this newly joined table with the following conditions:

Order status with 'completed incorrectly' and 'never received' only
Orders with actual_delivery_timestamp later than estimated_delivery_timestamp because it means that the orders were delivered later than the promised 30 minutes.
actual_delivery_timestamp is null as it means that orders failed to be delivered to the customers.
WITH june22_orders 
AS (
-- Insery query from Step 1)

SELECT *
FROM june22_orders AS june22
INNER JOIN trips
  ON june22.trip_id = trips.trip_id
WHERE june22.status IN ('completed incorrectly', 'never received')
  OR trips.actual_delivery_timestamp IS NULL 
  AND trips.estimated_delivery_timestamp > trips.actual_delivery_timestamp;
order_id	trip_id	status	dasher_id	trip_id	estimated_delivery_timestamp	actual_delivery_timestamp
242513	100482	completed incorrectly	102	100482	06/05/2022 07:10:00	06/05/2022 07:46:00
141367	100362	completed incorrectly	101	100362	06/07/2022 07:33:00	06/07/2022 08:45:00
642634	100232	never received	103	100232	06/08/2022 14:30:00	
582193	100657	never received	102	100657	07/07/2022 07:52:00	
Step 4

Finally, we calculate the percentage of bad experience using the formula.

Percentage of bad experience: Orders with bad experience from customers who signed up in June 2022 / Total orders made by customers who signed up in June 2022

To get Orders with bad experience from customers who signed up in June 2022, we can simply take the count of user_id since we filtered out the irrelevant orders and customers who signed up in other months.

As for Total orders made by customers who signed up in June 2022, we take the count of total orders in june22_orders CTE because this table contains all the orders made by customers in June 2022 and within the first 14 days from signup date.

With that, we wrap the formula with ROUND( ,2) function to round the percentage to 2 decimal places.

WITH june22_orders AS (
SELECT 
  orders.order_id,
  orders.trip_id,
  orders.status
FROM customers
INNER JOIN orders
  ON customers.customer_id = orders.customer_id
WHERE EXTRACT(MONTH FROM customers.signup_timestamp) = 6
  AND EXTRACT(YEAR FROM customers.signup_timestamp) = 2022
  AND customers.signup_timestamp + interval '14 days' > orders.order_timestamp)

SELECT ROUND(
  100.0 *
    COUNT(june22.order_id)/
    (SELECT COUNT(order_id) FROM june22_orders),2) AS bad_experience_pct
FROM june22_orders AS june22
INNER JOIN trips
  ON june22.trip_id = trips.trip_id
WHERE june22.status IN ('completed incorrectly', 'never received')
  OR trips.actual_delivery_timestamp IS NULL 
  AND trips.estimated_delivery_timestamp > trips.actual_delivery_timestamp;
