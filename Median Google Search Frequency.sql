Hard

Google
Google's marketing team is making a Superbowl commercial and needs a simple statistic to put on their TV ad: the median number of searches a person made last year.

However, at Google scale, querying the 2 trillion searches is too costly. Luckily, you have access to the summary table which tells you the number of searches made last year and how many Google users fall into that bucket.

Write a query to report the median of searches made by a user. Round the median to one decimal point.

search_frequency Table:
Column Name	Type
searches	integer
num_users	integer
search_frequency Example Input:
searches	num_users
1	2
2	2
3	3
4	1
Example Output:
median
2.5
By expanding the search_frequency table, we get [1, 1, 2, 2, 3, 3, 3, 4] which has a median of 2.5 searches per user.

Solution
Start by forming a common table expression (CTE) or subquery that will expand each search by the number of users value.

Using the GENERATE_SERIES() function, we can pass in 1 as the start value and the num_users value as the stop value. This will give us a set of numbers, [1, 1, 2, 2, 3, 3, 3, 4], for example. See this link for more information on this function: GENERATE_SERIES()

Since PostgreSQL does not provide a function to help us find the median value, we can use the PERCENTILE_CONT() function. This function takes the percentile required as an argument, in this case it is 0.5, i.e. the 50th percentile (MEDIAN). The WITHIN GROUP clause creates an ordered subset of search values returned by the CTE/Subquery mentioned above that can be used to perform aggregations. Find the MEDIAN value

Finally, to make sure our output is rounded to one decimal place, you can use the ROUND() function. Converting the value returned by the PERCENTILE_CONT to a decimal using ::decimal is necessary since it may be an integer value which won't allow the ROUND function to work properly.

WITH searches_expanded AS (
  SELECT searches
  FROM search_frequency
  GROUP BY 
    searches, 
    GENERATE_SERIES(1, num_users))

SELECT 
  ROUND(PERCENTILE_CONT(0.50) WITHIN GROUP (
    ORDER BY searches)::DECIMAL, 1) AS  median
FROM searches_expanded;
