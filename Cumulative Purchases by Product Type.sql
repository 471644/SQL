Medium

Amazon
This is the same question as problem #4 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below for the purchasing activity by order date and product type. Write a query to calculate the cumulative purchases for each product type over time in chronological order.

Output the order date, product, and the cumulative number of quantities purchased.

total_trans Table:
Column Name	Type
order_id	integer
product_type	string
quantity	integer
order_date	datetime
total_trans Example Input:
order_id	product_type	quantity	order_date
213824	printer	20	06/27/2022 12:00:00
132842	printer	18	06/28/2022 12:00:00
Example Output:
order_date	product_type	cum_purchased
06/27/2022 12:00:00	printer	20
06/28/2022 12:00:00	printer	38
Explanation
On 06/27/2022, 20 printers were purchased. Subsequently, on 06/28/2022, 38 printers were purchased cumulatively (20 + 18 printers).

Solution
Goal: Find the cumulative purchases for each product type chronologically.

That means the number of purchases of each product type should be summed chronologically by the order date. A handy window function can be very useful for this case - it's the SUM window function!

Solution:

SELECT 
  order_date,
  product_type,
  quantity, -- This field is not required in the solution
  SUM(quantity) OVER (
    PARTITION BY product_type 
    ORDER BY order_date) AS cum_purchased
FROM total_trans
ORDER BY product_type, order_date; -- You do not need to order your solution
Note that you do not need the quantity field in the SELECT clause or order your solution in any specific order.

Showing the output for printer only:

order_date	product_type	quantity	cum_purchased
06/27/2022 12:00:00	printer	20	20
06/28/2022 12:00:00	printer	18	38
07/05/2022 12:00:00	printer	25	63
09/16/2022 12:00:00	printer	15	78
09/26/2022 12:00:00	printer	12	90
Let us explain to you how the SUM window function works.

On 06/27/2022, the cumulative purchase is equivalent to the quantity of 20 as this is the first order.
Subsequently, on 06/28/2022, there is an order of 18 printers, and the cumulative purchase is 38, which are 20 + 18.
Then, on 07/05/2022, the cumulative purchases are 63 which is 20 + 18 + 25.
Do you get the gist? Using this function, we can obtain cumulative purchases very easily.

