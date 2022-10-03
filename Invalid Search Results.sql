Medium

Google
Assume you are given the table below containing the information on the searches attempted and the percentage of invalid searches by country. Write a query to obtain the percentage of invalid search result.

Output the country (in ascending order), total number of searches and percentage of invalid search rounded to 2 decimal places.

Note that to find the percentages, multiply by 100.0 and not 100 to avoid integer division.

Definition and assumptions:

num_search is the number of searches attempted and invalid_result_pct is the percentage of invalid searches.
In cases where countries has search attempts but does not have an invalid result percentage, it should be excluded, and vice versa.
search_category Table:
Column Name	Type
country	string
search_cat	string
num_search	integer
invalid_result_pct	decimal
search_category Example Input:
country	search_cat	num_search	invalid_result_pct
UK	home	null	null
UK	tax	98000	1.00
UK	travel	100000	3.25
Example Output:
country	total_search	invalid_result_pct
UK	198000	2.14
Example: UK had 98,000 * 1% + 100,000 x 3.25% = 4,230 invalid searches, out of the total 198,000 searches, resulting in a percentage of 2.14%.

Solution
We can take the following steps to solve this problem:

Convert the invalid search percentage into number of invalid searches.
Find the invalid search percentage for every country.
Step 1: Convert the invalid search percentage into number of invalid searches

First, we convert the invalid search percentage for a given search category into the number of invalid searches.

We can find number of invalid searches using the formula below:

Number of invalid searches = (Percentage of invalid result searches * Number of searches)/100

Now, here comes the tricky part:

The Hidden Error: If the percentage of invalid result searches is NULL, then multiplying it with the total number of searches results in NULL.

To be considered as a valid search, each row of searches must be accompanied by a percentage of invalid searches. It doesn't make sense if all the searches are valid, won't it? There must be a percentage of searches that turned out to be invalid.

To exclude NULL searches and percentages, we can add a CASE statement.

CASE WHEN zero_result_pct IS NOT NULL THEN num_search 
  ELSE NULL END as num_search_2
The CASE statement is saying:

When the percentage of invalid result is not null, then retrieve the number of searches.
Otherwise, keep it null.
We can summarize our findings with the code snippet below:

SELECT
  country,
  num_search,
  invalid_result_pct,
  CASE WHEN invalid_result_pct IS NOT NULL THEN num_search
    ELSE NULL END AS num_search_2,
  ROUND((num_search * invalid_result_pct)/100.0,0) AS invalid_search
FROM search_category
WHERE num_search IS NOT NULL 
  AND invalid_result_pct IS NOT NULL;
This is how the first 3 rows of output looks:

country	num_search	invalid_result_pct	num_search_2	invalid_search
CN	1200000	13.00	1200000	156000
CN	1200	99.00	1200	1188
CN	980000	11.00	980000	107800
Step 2: Find the invalid search percentage for every country

The query above is then converted into a CTE called invalid results (you can name it as you wish, but it's appropriate to name something that represents the overall results of the query).

Next, we find the percentage of invalid searches against the total searches using this mathematical expression.

Percentage of invalid results = (Total of invalid searches / Total of searches) * 100

Did you know?

When dividing 2 integers, the division / operator in PostgreSQL only considers the integer part of the results and do not deal with the remainder (ie. .123, .352). Hence, to avoid integer division which happens when we multiply by 100 and to convert the numerical values into decimal values, we multiply the values with 100.0.

The final step is to order our result by the ascending order of country names. For this, we can use the ORDER BY clause with country field.

WITH invalid_results
AS (
-- Insert above query here
)

SELECT 
  country,
  SUM(num_search_2) AS total_search,
  ROUND(SUM(invalid_search)/SUM(num_search_2) * 100.0,2) AS invalid_result_pct
FROM invalid_results
GROUP BY country
ORDER BY country;
Results:

country	total_search	invalid_result_pct
CN	2181200	12.15
UK	198000	2.14
US	199500	5.52
Let's interpret the results. For example, in the first row, country CN has an invalid result percentage of 12.15% out of 2,181,200 total searches.

Solution:

WITH invalid_results
AS (
SELECT
  country,
  num_search,
  invalid_result_pct,
  CASE WHEN invalid_result_pct IS NOT NULL THEN num_search
    ELSE NULL END AS num_search_2,
  ROUND((num_search * invalid_result_pct)/100.0,0) AS invalid_search
FROM search_category
WHERE num_search IS NOT NULL 
  AND invalid_result_pct IS NOT NULL
)

SELECT 
  country,
  SUM(num_search_2) AS total_search,
  ROUND(SUM(invalid_search)/SUM(num_search_2) * 100.0,2) AS invalid_result_pct
FROM invalid_results
GROUP BY country
ORDER BY country;
