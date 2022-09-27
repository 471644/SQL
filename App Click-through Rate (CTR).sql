Easy

Facebook
This is the same question as problem #1 in the SQL Chapter of Ace the Data Science Interview!

Assume you have an events table on app analytics. Write a query to get the click-through rate (CTR %) per app in 2022. Output the results in percentages rounded to 2 decimal places.

Notes:

To avoid integer division, you should multiply the click-through rate by 100.0, not 100.
Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions
events Table:
Column Name	Type
app_id	integer
event_type	string
timestamp	datetime
events Example Input:
app_id	event_type	timestamp
123	impression	07/18/2022 11:36:12
123	impression	07/18/2022 11:37:12
123	click	07/18/2022 11:37:42
234	impression	07/18/2022 14:15:12
234	click	07/18/2022 14:16:12
Example Output:
app_id	ctr
123	50.00
234	100.00
Explanation
App 123 has a CTR of 50.00% because this app receives 1 click out of the 2 impressions. Hence, it's 1/2 = 50.00%.


Solution
Before we proceed, let's list down the steps to solve the question.

Filter for analytics events from the year 2022.
Find the number of clicks and number of impressions.
Calculate the percentage of click-through rate.
First, we filter for events from the year 2022 in the WHERE clause by using the appropriate comparison operators.

timestamp >= '2022-01-01' refers to the events on 2022-01-01 and later.
timestamp < means events before 2023-01-01 and does not include 2023-01-01.
SELECT *
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01';
Next, we want to find the number of clicks and number of impressions using the CASE statement and how you can interpret it:

If the event_type is 'click', then assign the value of 1. Otherwise, assign the value of 0.

SELECT
  app_id,
  CASE WHEN event_type = 'click' THEN 1 ELSE 0 END AS clicks,
  CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END AS impressions
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01';
Showing the first 5 rows of output:

app_id	clicks	impressions
123	0	1
123	0	1
123	1	0
234	0	1
234	1	0
Next, we have to add up the clicks and impressions by simply wrapping the CASE statements with a SUM function.

SELECT
  app_id,
  SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) AS clicks, 
  SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END) AS impressions
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY app_id;
app_id	clicks	impressions
123	2	3
234	1	3
Based on the formula below, we have to divide the number of clicks by the number of impressions and then multiply by 100.0.

Percentage of click-through rate = 100.0 * Number of clicks / Number of impressions

Remember to use the ROUND(_____, 2) function to round up the percentage results to 2 decimal places.


Solution #1: Using SUM(CASE ...)

SELECT
  app_id,
  ROUND(100.0 *
    SUM(CASE WHEN event_type = 'click' THEN 1 ELSE 0 END) /
    SUM(CASE WHEN event_type = 'impression' THEN 1 ELSE 0 END), 2)  AS ctr_rate
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY app_id;

Solution #2: Using COUNT(CASE ...)

SELECT
  app_id,
  ROUND(100.0 *
    COUNT(CASE WHEN event_type = 'click' THEN 1 ELSE NULL END) /
    COUNT(CASE WHEN event_type = 'impression' THEN 1 ELSE NULL END), 2)  AS ctr_rate
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY app_id;

Solution #3: Using SUM() FILTER ()

SELECT
  app_id,
  ROUND(100.0 *
    SUM(1) FILTER (WHERE event_type = 'click') /
    SUM(1) FILTER (WHERE event_type = 'impression'), 2) AS ctr_app
FROM events
WHERE timestamp >= '2022-01-01' AND timestamp < '2023-01-01'
GROUP BY app_id;