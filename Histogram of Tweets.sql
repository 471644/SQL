Easy

Twitter
This is the same question as problem #6 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing tweet data. Write a query to obtain a histogram of tweets posted per user in 2022. Output the tweet count per user as the bucket, and then the number of Twitter users who fall into that bucket.

tweets Table:
Column Name	Type
tweet_id	integer
user_id	integer
msg	string
tweet_date	timestamp
tweets Example Input:
tweet_id	user_id	msg	tweet_date
214252	111	Am considering taking Tesla private at $420. Funding secured.	12/30/2021 00:00:00
739252	111	Despite the constant negative press covfefe	01/01/2022 00:00:00
846402	111	Following @NickSinghTech on Twitter changed my life!	02/14/2022 00:00:00
241425	254	If the salary is so competitive why won’t you tell me what it is?	03/01/2022 00:00:00
231574	148	I no longer have a manager. I can't be managed	03/23/2022 00:00:00
Example Output:
tweet_bucket	users_num
1	2
2	1
Explanation: 2 users fall under the 1 tweet bucket whereas 1 user is in the 2 tweets bucket.

Solution
First, we obtain the number of tweets for each user in 2022 and group them by the user id.

SELECT 
  user_id, 
  COUNT(tweet_id) AS tweets_num 
FROM tweets 
WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
GROUP BY user_id;
Output:

user_id	tweets_num
111	2
148	1
254	1
We can interpret the output as in the year 2022, user 111 has tweeted twice and users 148 and 254 have tweeted only one time.

Next, we use the query above as a subquery, then we use the number of tweets tweets_num field as the tweet bucket and retrieve the number of users.

Solution #1: Using Subquery

SELECT 
  tweets_num AS tweet_bucket, 
  COUNT(user_id) AS users_num 
FROM (
  SELECT 
    user_id, 
    COUNT(tweet_id) AS tweets_num 
  FROM tweets 
  WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31'
  GROUP BY user_id) AS total_tweets 
GROUP BY tweets_num;
tweet_bucket	users_num
1	2
2	1
Below is another method to solve this question using CTE.

A CTE is a temporary data set to be used as part of a query. It exists during the execution of the query. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only.

The advantages of using CTE are it is reusable during the entire session and more readable, whereas a subquery can be used in the FROM and WHERE clauses and act as a column with a single value.

Solution #2: Using CTE

WITH total_tweets AS (
  SELECT 
    user_id, 
    COUNT(tweet_id) AS tweets_num 
  FROM tweets 
  WHERE tweet_date BETWEEN '2022-01-01' AND '2022-12-31' 
  GROUP BY user_id) 
  
SELECT 
  tweets_num AS tweet_bucket, 
  COUNT(user_id) AS users_num 
FROM total_tweets 
GROUP BY tweets_num;
