Hard

Facebook
This is the same question as problem #31 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing information on Facebook user logins. Write a query to obtain the number of reactivated users (which are dormant users who did not log in the previous month, then logged in during the current month).

Output the current month (in numerical) and number of reactivated users.

Assumption:

The rows in user_logins table is complete for the year of 2022 and there are no missing dates.
user_logins Table:
Column Name	Type
user_id	integer
login_date	datetime
user_logins Table:
user_id	login_date
725	03/03/2022 12:00:00
245	03/28/2022 12:00:00
112	03/05/2022 12:00:00
245	04/29/2022 12:00:00
112	04/05/2022 12:00:00
Assume that the above table is complete for month of February to April 2022.

Example Output:
current_month	reactivated_users
3	3
In March 2022, there are 3 reactivated users which are 725, 245, and 112. These 3 users did not login in February 2022, but login in the current month in March 2022.

There are no reactivated users in April because users 245 and 112 login in the previous month in March 2022 and the current month in April, thus they are not reactivated users.

Solution
Before we proceed with the solution, let's understand what is a Reactivated User.

Reactivated users are dormant users who did not log in the previous month, who then logged in the following month.

We'll use a multi-step approach to solve this:

First, find the users who login in the previous month.
Then, find the users who login in the current month.
In the final query, we will find for the users who login in the current month, then using a NOT EXISTS operator, we will exclude users who exist in the previous month's login data.
In the first step, we look at all the users who login during the previous month. To obtain the last month’s data, we subtract an INTERVAL of 1 month from the current month’s login date.

Then, we use a NOT EXISTS against previous month’s login information to check whether there was a login in the previous month. If there is a login in the previous month, then the NOT EXISTS operator excludes this particular user.

Finally, we COUNT the number of users satisfying this condition.

SELECT 
  EXTRACT(MONTH FROM curr_month.login_date) AS current_month, 
  COUNT(curr_month.user_id) AS reactivated_users
FROM user_logins AS curr_month 
WHERE 
  NOT EXISTS (
    SELECT * 
    FROM user_logins AS last_month 
    WHERE curr_month.user_id = last_month.user_id 
      AND EXTRACT(MONTH FROM last_month.login_date) = (
        EXTRACT(MONTH FROM curr_month.login_date - '1 month' :: INTERVAL))
) 
GROUP BY EXTRACT(MONTH FROM curr_month.login_date)
ORDER BY current_month ASC;
