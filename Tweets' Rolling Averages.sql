Medium

Twitter
This is the same question as problem #10 in the SQL Chapter of Ace the Data Science Interview!

The table below contains information about tweets over a given period of time. Calculate the 3-day rolling average of tweets published by each user for each date that a tweet was posted. Output the user id, tweet date, and rolling averages rounded to 2 decimal places.

Important Assumptions:

Rows in this table are consecutive and ordered by date.
Each row represents a different day
A day that does not correspond to a row in this table is not counted. The most recent day is the next row above the current row.
Note: Rolling average is a metric that helps us analyze data points by creating a series of averages based on different subsets of a dataset. It is also known as a moving average, running average, moving mean, or rolling mean.

tweets Table:
Column Name	Type
tweet_id	integer
user_id	integer
tweet_date	timestamp
tweets Example Input:
tweet_id	user_id	tweet_date
214252	111	06/01/2022 12:00:00
739252	111	06/01/2022 12:00:00
846402	111	06/02/2022 12:00:00
241425	254	06/02/2022 12:00:00
137374	111	06/04/2022 12:00:00
Example Output:
user_id	tweet_date	rolling_avg_3days
111	06/01/2022 12:00:00	2.00
111	06/02/2022 12:00:00	1.50
111	06/04/2022 12:00:00	1.33
254	06/02/2022 12:00:00	1.00
Explanation
User 111 made 2 tweets on 06/01/2022, and 1 tweet the next day. By 06/02/2022, the user had made in total 3 tweets over the course of 2 days; thus, the rolling average is 3/2=1.5. By 06/04/2022, there are 4 tweets that were made during 3 days: 4/3 = 1.33 rolling average.

Solution
First, we need to obtain the total number of tweets created by each user on each day using either a common table expression (CTE) or a subquery. Either way, the query must apply a COUNT DISTINCT clause to the tweet_id field and then group the data by user_id and tweet_date.

SELECT
  user_id,
  tweet_date,
  COUNT(DISTINCT tweet_id) AS tweet_num
FROM tweets
GROUP BY user_id, tweet_date;
Output showing the first 5 rows:

user_id	tweet_date	tweet_num
111	06/01/2022 04:00:00	2
111	06/02/2022 04:00:00	1
111	06/04/2022 04:00:00	1
111	06/15/2022 04:00:00	1
199	06/08/2022 04:00:00	2
tweet_num represents the number of tweets that the user tweeted on the particular date.

The query above is then converted into a CTE or subquery called tweet_count. Then, we use a window function on the resulting CTE or subquery to retrieve the AVG number of tweets over a time period that contains the current row and the previous two days, thus yielding the 3-day rolling average. Finally, we order by user id and tweet date.

WITH tweet_count
AS (
-- Insert above query
)

SELECT
  user_id,
  tweet_date,
  tweet_num, -- Note that this column is not required in the output
  ROUND(
    AVG(tweet_num) OVER (
      PARTITION BY user_id
      ORDER BY user_id, tweet_date
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
  AS rolling_avg_3d
FROM tweet_count;
user_id	tweet_date	tweet_num
111	06/01/2022 04:00:00	2
111	06/02/2022 04:00:00	1
111	06/04/2022 04:00:00	1
111	06/15/2022 04:00:00	1
199	06/08/2022 04:00:00	2
This is how the window function is interpreted:

AVG(tweet_num) OVER (
  PARTITION BY user_id
  ORDER BY user_id, tweet_date
    ROWS BETWEEN 2 PRECEDING AND CURRENT ROW)
The tweets are partitioned by user_id and sorted based on user_id followed by tweet_date in ascending order.
ROWS BETWEEN 2 PRECEDING AND CURRENT ROW means the values in tweet_num in previous 2 rows and current row is added and then averaged.
For example, on tweet_date 06/04/2022, the 3-day rolling average is calculated as (2 + 1 + 1) / 3 = 1.33
Below are two methods of solving the question, one with a common table expression (CTE) and another with a subquery.

A CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only. Read here and here for more understanding.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value. We share more resources here (1, 2, 3 on their use cases.

Solution #1: Using CTE

WITH tweet_count
AS (
  SELECT
    user_id,
    tweet_date,
    COUNT(DISTINCT tweet_id) AS tweet_num
  FROM tweets
  GROUP BY user_id,tweet_date
)

SELECT
  user_id,
  tweet_date,
  ROUND(
    AVG(tweet_num) OVER (
      PARTITION BY user_id
      ORDER BY user_id, tweet_date
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
  AS rolling_avg_3d
FROM tweet_count;
Solution #2: Using Subquery

SELECT
  user_id,
  tweet_date,
  ROUND(
    AVG(tweet_num) OVER (
      PARTITION BY user_id
      ORDER BY user_id, tweet_date
      ROWS BETWEEN 2 PRECEDING AND CURRENT ROW), 2)
  AS rolling_avg_3d
FROM (
  SELECT
    user_id,
    tweet_date,
    COUNT(DISTINCT tweet_id) AS tweet_num
  FROM tweets
  GROUP BY user_id, tweet_date) AS tweet_count;
