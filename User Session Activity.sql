Medium

Twitter
This is the same question as problem #24 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing information on user session activity. Write a query that ranks users according to their total session durations (in minutes) by descending order for each session type between the start date (2022-01-01) and end date (2022-02-01). Output the user id, session type, and the ranking of the total session duration.

sessions Table:
Column Name	Type
session_id	integer
user_id	integer
session_type	string ("like", "reply", "retweet")
duration	integer (in minutes)
start_date	timestamp
session Example Input:
session_id	user_id	session_type	duration	start_date
6368	111	like	3	12/25/2021 12:00:00
1742	111	retweet	6	01/02/2022 12:00:00
8464	222	reply	8	01/16/2022 12:00:00
7153	111	retweet	5	01/28/2022 12:00:00
3252	333	reply	15	01/10/2022 12:00:00
Example Output:
user_id	session_type	ranking
333	reply	1
222	reply	2
111	retweet	1
Explanation: User 333 is listed on the top due to the highest duration of 15 minutes. The ranking resets on 3rd row as the session type changes.

Solution
First, we can perform a CTE or subquery to obtain the total session duration by user and session type between the start and end dates. Then, we can use RANK to obtain the rank, making sure to partition by session type and then order by duration as in the query below:

Below are two methods of solving the question using CTE and subquery.

CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value.

Solution 1: Using CTE

WITH user_duration 
AS (
  SELECT 
    user_id, 
    session_type, 
    SUM(duration) AS total_duration 
  FROM sessions 
  WHERE start_date >= '2022-01-01' 
    AND start_date <= '2022-02-01' 
  GROUP BY user_id, session_type) 

SELECT 
  user_id, 
  session_type, 
  RANK() OVER (
    PARTITION BY session_type 
    ORDER BY total_duration DESC) AS ranking 
FROM user_duration 
ORDER BY session_type, ranking;
Solution 2: Using Subquery

SELECT 
  user_id, 
  session_type, 
  RANK() OVER (
    PARTITION BY session_type 
    ORDER BY total_duration DESC) AS ranking 
FROM (
  SELECT 
    user_id, 
    session_type, 
    SUM(duration) AS total_duration 
  FROM sessions 
  WHERE start_date >= '2022-01-01' 
    AND start_date <= '2022-02-01' 
  GROUP BY user_id, session_type) AS user_duration
ORDER BY session_type, ranking;
