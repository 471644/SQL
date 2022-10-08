Hard

Facebook
This is the same question as problem #23 in the SQL Chapter of Ace the Data Science Interview!

Assume you have the table below containing information on Facebook user actions. Write a query to obtain the active user retention in July 2022. Output the month (in numerical format 1, 2, 3) and the number of monthly active users (MAUs).

Hint: An active user is a user who has user action ("sign-in", "like", or "comment") in the current month and last month.

user_actions Table:
Column Name	Type
user_id	integer
event_id	integer
event_type	string ("sign-in, "like", "comment")
event_date	datetime
user_actionsExample Input:
user_id	event_id	event_type	event_date
445	7765	sign-in	05/31/2022 12:00:00
742	6458	sign-in	06/03/2022 12:00:00
445	3634	like	06/05/2022 12:00:00
742	1374	comment	06/05/2022 12:00:00
648	3124	like	06/18/2022 12:00:00
Example Output for June 2022:
month	monthly_active_users
6	1
Example
In June 2022, there was only one monthly active user (MAU), user_id 445.

Note: We are showing you output for June 2022 as the user_actions table only have event_dates in June 2022. You should work out the solution for July 2022.

Solution
In order to calculate the active user retention, we will have to check for each user whether they were active in the current month versus last month.

We can use a 2-step approach:

Find users who were active in the last month.
Find users who are active in the current month which exist in the last month.
Step 1

Let's start with finding users who were active in the last month.

This is a tricky question, so take your time and read through the solution a few times if you have to.

Sharing the code here with the interpretation below.

SELECT last_month.user_id 
FROM user_actions AS last_month
WHERE last_month.user_id = curr_month.user_id
  AND EXTRACT(MONTH FROM last_month.event_date) =
  EXTRACT(MONTH FROM curr_month.event_date - interval '1 month'
In FROM, we alias the user_actions table as last_month to say that "Hey, this table contains last month's user information".
In WHERE clause, we match users in the last month's table to the current month's table based on user id.
EXTRACT(MONTH FROM last_month.event_date) = EXTRACT(MONTH FROM curr_month.event_date - interval '1 month') means a particular user from last month exists in the current month. Hence, this user is an active user which is what we're finding for.
- interval '1 month' means to subtracts one month from current month's date to give us last month's date.
Important: Bear in mind that you will not able to run this query on its own because it is referencing to another table curr_month which do not reside in this query. We will show you the query to run later. For now, just try to understand the logic behind the solution.

Step 2

Using EXISTS operator, we find for users in the current month which also exists in the subquery, which represents active users in the last month (in step 1). Note that the user_actions table is aliased as curr_month (to say "Hey, this is current month's user information!").

To bucket days into its month, we extract the month information by using EXTRACT. Then, we use a COUNT DISTINCT over user id to obtain the monthly active user count for the month.

Now you can run this query in the editor.

SELECT 
  EXTRACT(MONTH FROM curr_month.event_date) AS mth, 
  COUNT(DISTINCT curr_month.user_id) AS monthly_active_users 
FROM user_actions AS curr_month
WHERE EXISTS (
  SELECT last_month.user_id 
  FROM user_actions AS last_month
  WHERE last_month.user_id = curr_month.user_id
    AND EXTRACT(MONTH FROM last_month.event_date) =
    EXTRACT(MONTH FROM curr_month.event_date - interval '1 month')
)
  AND EXTRACT(MONTH FROM curr_month.event_date) = 7
  AND EXTRACT(YEAR FROM curr_month.event_date) = 2022
GROUP BY EXTRACT(MONTH FROM curr_month.event_date);
Results:

month	monthly_active_users
7	2
In July 2022, there are only 2 distinct users who are active in the last month and current month.

