Hard

Wayfair
This is the same question as problem #32 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing information on user transactions for particular products. Write a query to obtain the year-on-year growth rate for the total spend of each product for each year.

Output the year (in ascending order) partitioned by product id, current year's spend, previous year's spend and year-on-year growth rate (percentage rounded to 2 decimal places).

user_transactions Table:
Column Name	Type
transaction_id	integer
product_id	integer
spend	decimal
transaction_date	datetime
user_transactions Example Input:
transaction_id	product_id	spend	transaction_date
1341	123424	1500.60	12/31/2019 12:00:00
1423	123424	1000.20	12/31/2020 12:00:00
1623	123424	1246.44	12/31/2021 12:00:00
1322	123424	2145.32	12/31/2022 12:00:00
Example Output:
year	product_id	curr_year_spend	prev_year_spend	yoy_rate
2019	123424	1500.60		
2020	123424	1000.20	1500.60	-33.35
2021	123424	1246.44	1000.20	24.62
2022	123424	2145.32	1246.44	72.12
The third row in the example output shows that the spend for product 123424 grew 24.62% from 1000.20 in 2020 to 1246.44 in 2021.

Solution
Our goal for this question is to find the year-on-year (y-o-y) growth rate for Wayfair's user spend.

Our multi-step approach for solving the question:

Summarizing user_transactions table into a table containing the yearly spend information.
Find the prior year's spend and keep the information parallel with current year's spend row.
Get the variance between current year and prior year's spend and apply the y-o-y growth rate formula.
Step 1

First, we need to obtain the year by using EXTRACT on the transaction date as written in the code below.

SELECT 
  EXTRACT(YEAR FROM transaction_date) AS year, 
  product_id,
  spend AS curr_year_spend 
FROM user_transactions
In this output table, you can see that the spend for product id 234412 is summarized by year. Take note that you would have to query your output for all the product ids.

year	product_id	curr_year_spend
2019	234412	1800.00
2020	234412	1234.00
2021	234412	889.50
2022	234412	2900.00
Step 2

Next, we convert the query in step 1 into a CTE called yearly_spend (you can name the CTE as you wish). With this CTE, we then calculate the prior year’s spend for each product. We can do so by applying LAG function onto each year and partitioning by product id to calculate the prior year's spend for the given product.

WITH yearly_spend 
AS (
-- Insert query above
)

SELECT 
  *, 
  LAG(curr_year_spend, 1) OVER (
    PARTITION BY product_id 
    ORDER BY product_id, year) AS prev_year_spend 
FROM yearly_spend;
Showing the output only for product id 134412:

year	product_id	curr_year_spend	prev_year_spend
2019	234412	1800.00	
2020	234412	1234.00	1800.00
2021	234412	889.50	1234.00
2022	234412	2900.00	889.50
In year 2020, the previous year's spend is 1800.00 which is the current year's spend for year 2019. Subsequently, in year 2021, 1234.00 which is the previous year's spend is the current year's spend in year 2020. Can you get the gist of how LAG works now?

To better understand the usage of LAG function, check here for more examples.

Step 3

Finally, we wrap the query above in another CTE called yearly_variance.

Year-on-Year Growth Rate = (Current Year's Spend - Prior Year’s Spend) / Prior Year’s Spend x 100

In the final query, we apply the y-o-y growth rate formula and round the results to 2 nearest decimal places.

WITH yearly_spend 
AS (
-- Insert above query
), 
yearly_variance 
AS (
-- Insert above query
) 

SELECT 
  year,
  product_id, 
  curr_year_spend, 
  prev_year_spend, 
  ROUND(100 * (curr_year_spend - prev_year_spend)/ prev_year_spend, 2) AS yoy_rate 
FROM yearly_variance;
Results for product id 134412:

year	product_id	curr_year_spend	prev_year_spend	yoy_rate
2019	234412	1800.00		
2020	234412	1234.00	1800.00	-31.44
2021	234412	889.50	1234.00	-27.92
2022	234412	2900.00	889.50	226.03
Solution:

WITH yearly_spend AS (
  SELECT 
    EXTRACT(YEAR FROM transaction_date) AS year, 
    product_id,
    spend AS curr_year_spend
  FROM user_transactions
), 
yearly_variance AS (
  SELECT 
    *, 
    LAG(curr_year_spend, 1) OVER (
      PARTITION BY product_id
      ORDER BY product_id, year) AS prev_year_spend 
  FROM yearly_spend) 

SELECT 
  year,
  product_id, 
  curr_year_spend, 
  prev_year_spend, 
  ROUND(100 * (curr_year_spend - prev_year_spend)/ prev_year_spend,2) AS yoy_rate 
FROM yearly_variance;
