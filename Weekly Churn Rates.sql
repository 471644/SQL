Hard

Facebook
Facebook is analyzing its user signup data for June 2022. Write a query to generate the churn rate by week in June 2022. Output the week number (1, 2, 3, 4, ...) and the corresponding churn rate rounded to 2 decimal places.

For example, week number 1 represents the dates from 30 May to 5 Jun, and week 2 is from 6 Jun to 12 Jun.

Assumptions:

If the last_login date is within 28 days of the signup_date, the user can be considered churned.
If the last_login is more than 28 days after the signup date, the user didn't churn.
users Table:
Column Name	Type
user_id	integer
signup_date	datetime
last_login	datetime
users Example Input:
user_id	signup_date	last_login
1001	06/01/2022 12:00:00	07/05/2022 12:00:00
1002	06/03/2022 12:00:00	06/15/2022 12:00:00
1004	06/02/2022 12:00:00	06/15/2022 12:00:00
1006	06/15/2022 12:00:00	06/27/2022 12:00:00
1012	06/16/2022 12:00:00	07/22/2022 12:00:00
Example Output:
signup_week	churn_rate
1	66.67
3	50.00
User ids 1001, 1002, and 1004 signed up in the first week of June 2022. Out of the 3 users, 1002 and 1004's last login is within 28 days from the signup date, hence they are churned users.

To calculate the churn rate, we take churned users divided by total users signup in the week. Hence 2 users / 3 users = 66.67%.

Solution
Calculating churn rate is a popular topic for SQL interview questions, so let's clarify the definition of a churn rate before we proceed to this SQL solution.

Based on this article, churn rate is the percentage of customers who leave a service over a given period. The higher the churn rate, the more customers your business is losing.

Assumptions:

If a user's last login date is within 28 days of their signup date, we consider that user to be churned.
If a user's last login date is more than 28 days after their signup date, that user has not churned.
Goals:

Only consider users who signed up in June 2022.
Output a user's signup week in numerical format i.e. 1st week of June is 1, 2nd week of June is 2.
Output the percentage of users who churned in each week in June 2022.
Bear in mind that the 1st week of June represents the dates from 30 May to 5 Jun, and 2nd week is from 6 Jun to 12 Jun, and so on.

For the first step of our solution, we'll use EXTRACT to pull the calendar week from each signup date. We perform a mathematical calculation to display the first week of June 2022 as 1, the second week as 2, etc.

We accomplish this by subtracting the first week in June from any given calendar week and then adding 1. For example, Week #23 is the second week of June, which we want to display as 2 in our output.

We can accomplish this with the following: Week 23 – Week 22 (First Week of June) + 1 = 23 - 22 + 1 = 1 + 1 = 2

Conceptually, what we're doing is: Current Week - First Week in June + 1

We can implement this in SQL, keeping in mind that:

EXTRACT(WEEK FROM signup_date) gives the current calendar week of the signup date
EXTRACT(WEEK FROM DATE_TRUNC('Month', signup_date)) gives the first calendar week of the month of the signup date, which we can constrain to June.
Putting it all together, our SQL expression looks like this: EXTRACT(WEEK FROM signup_date) - EXTRACT(WEEK FROM DATE_TRUNC('Month', signup_date)) + 1 AS signup_week
Next, we use a conditional CASE statement to account for the following:

If the user's last login is within 28 days of their signup date, the user churned.
We indicate this by assigning a value of 1 to use later in our percentage calculation.
Otherwise, we assign a NULL value to indicate that the user did not churn.
Then, we calculate the number of users who signed up in each week of June by using a COUNT window function to PARTITION by week. To end this query, we filter the data to count user signups in June 2022 only.

SELECT
  (EXTRACT(WEEK FROM signup_date) 
    - EXTRACT(WEEK FROM DATE_TRUNC('Month', signup_date)))  +  1 
    AS signup_week,
  CASE WHEN (last_login::DATE - signup_date::DATE)  <=  28  THEN  1  
    ELSE  NULL END AS churned_users,
  COUNT(user_id) OVER (
    PARTITION BY EXTRACT(WEEK FROM signup_date)) AS user_count
FROM  users
WHERE EXTRACT(MONTH FROM signup_date) = 6
  AND EXTRACT(YEAR FROM signup_date) = 2022;
Here's how the first 5 rows of output looks:

signup_week	churned_users	user_count
1	1	4
1	1	4
1		4
1	1	4
2	1	5
We interpret the output as:

In the 1st row, the user in signup_week #1 (1st week in June 2022) has churned. In the same week, there is a total of 4 users regardless of whether they churned or not (we will need this information later).
In the 3rd row, the churned_users is null indicating that the number of days between user's signup date and last login date is more than 28 days, hence this user did not churn.
After converting the above query to a CTE, we calculate the weekly churn percentage with this formula: Churn Rate = Number of churned users / Total number of users

Then, we multiply the churn rate by 100.0 and ROUND the results to 2 decimal places to find the churn percentage.

Solution:

WITH june22_churn AS (
  SELECT
    (EXTRACT(WEEK FROM signup_date)
      - EXTRACT(WEEK FROM DATE_TRUNC('Month', signup_date)))  +  1 AS signup_week,
    CASE WHEN (last_login::DATE - signup_date::DATE)  <=  28  THEN  1  
        ELSE  NULL END AS churned_users,
    COUNT(user_id) OVER (PARTITION BY EXTRACT(WEEK FROM signup_date)) AS user_count
  FROM  users
  WHERE EXTRACT(MONTH FROM signup_date) = 6
    AND EXTRACT(YEAR FROM signup_date) = 2022
)  

SELECT 
  signup_week,
  ROUND(100.0 * COUNT(churned_users)/COUNT(user_count),2) AS churn_rate
FROM june22_churn
GROUP BY signup_week;
