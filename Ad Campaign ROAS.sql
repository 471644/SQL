Easy

Google
Google marketing managers are analyzing the performance of various advertising accounts over the last month. They need your help to gather the relevant data.

Write a query to calculate the return on ad spend (ROAS) for each advertiser across all ad campaigns. Round your answer to 2 decimal places, and order your output by the advertiser_id.

Hint: ROAS = Ad Revenue / Ad Spend

ad_campaigns Table:
Column Name	Type
campaign_id	integer
spend	integer
revenue	float
advertiser_id	integer
ad_campaigns Example Input:
campaign_id	spend	revenue	advertiser_id
1	5000	7500	3
2	1000	900	1
3	3000	12000	2
4	500	2000	4
5	100	400	4
Example Output:
advertiser_id	ROAS
1	0.9
2	4
3	1.5
4	4
Explanation
The example output shows that advertiser_id 1 returned 90% of their ad spend, advertiser_id 2 returned 400% of their ad spend, and so on.

Solution
We are asked to find the ROAS for each advertiser, so we only need to operate on 3 fields: advertiser_id, revenue, and spend. To sum up the amounts from different campaigns, we'l use SUM(revenue) and SUM(spend) respectively, then group and order by the advertising account.

As shown above, ROAS (return on ad spend) is calculated by dividing the revenue by the ad spend. By following this logic, you should arrive at a query that looks like this:

SELECT
  advertiser_id,
  SUM(revenue) / SUM(spend) AS ROAS
FROM ad_campaigns
GROUP BY advertiser_id
ORDER BY advertiser_id;
The above produces an output with an inconsistent number of decimal places. The final step should be to round all the results to a uniform 2 decimal places.

However, PostgreSQL requires the input to the ROUND function to be a numeric data type, so we'll convert the resulting ROAS to a decimal type before rounding. We can accomplish this using the double-colon :: conversion, as shown below. You can read more about different numeric types in the PostgreSQL documentation here.

Solution:

SELECT
  advertiser_id,
  ROUND(((SUM(revenue) / SUM(spend))::DECIMAL), 2) AS ROAS
FROM ad_campaigns
GROUP BY advertiser_id
ORDER BY advertiser_id;
Congratulations, you have completed the task!