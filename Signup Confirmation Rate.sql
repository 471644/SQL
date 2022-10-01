Medium

TikTok
New TikTok users sign up with their emails, so each signup requires a text confirmation to activate the new user's account.

Write a SQL query to find the confirmation rate of people who confirmed their signups with text messages. Round the result to 2 decimal places.

Assumptions:

A user may fail to confirm many times with text. Once signup is confirmed for a user, they will not be able to initiate the same process again.
A user may not initiate the signup confirmation process at at all.
emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime
emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
236	6950	07/01/2022 00:00:00
433	1052	07/09/2022 00:00:00
texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	varchar
texts Example Input:
text_id	email_id	signup_action
6878	125	Confirmed
6920	236	Not Confirmed
6994	236	Confirmed
Example Output:
confirm_rate
0.67
Explanation
This output indicates that 67% of users have successfully confirmed their signup. The other 33% have either not initiated signup, or their signup is not confirmed yet.

Solution
The formula to pull the signup confirmation rate is:

Signup Confirmation Rate = Number of users who activated their accounts with texts / Total number of users

First, we need to pull the number of users who signed up with text confirmation successfully. We'll use the column signup_action in the texts table. We'll then use JOINS to connect users and the data of their signup confirmation activities. We can use a LEFT JOIN here, but INNER JOIN is not an option. See this link for more information.

The JOIN query looks like this:

SELECT user_id, signup_action
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND signup_action = 'Confirmed';
Your output should look something like this:

user_id	signup_action
7771	Confirmed
6950	Confirmed
1052	NULL
Let's break down the above query: We LEFT JOIN the tables on the email_id column and filter only on users whose signup_action is confirmed.

When an email_id is found in both tables and signup action is Confirmed, we'll see both columns that appear in the SELECT clause.

However, the email_id might not have a matching value in the texts table for a few reasons, either because:

The email_id is not available in texts, or because
The email_id is found but it is not confirmed yet
In these cases, the LEFT JOIN will create a new row that contains email_id. The value for the signup_action column will simply be NULL because no match for email_id was found in the texts table.

If we replaced the LEFT JOIN with INNER JOIN, the output would show only the overlap between the two tables with no NULL values. It would look something like this:

user_id	signup_action
7771	Confirmed
6950	Confirmed
We are missing the user ID 1052 here because the user did not initiate any text-confirmation activity, and has no corresponding value in the texts table. Therefore, this INNER JOIN would give us incorrect confirmation rates, as relevant users might be excluded from the calculation completely. We want to avoid this type of scenario by choosing the correct JOIN.

Now, we will separate out the users who never initiated text confirmation. Result rows that contain NULL are the users who should not be counted for the rate calculation.

We'll use a conditional CASE WHEN statement to assign 0 to such users and 1 to the rest of them who have non-null values.

SELECT
  user_id,
  CASE WHEN texts.email_id IS NOT NULL THEN 1
    ELSE 0 END AS signup
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND signup_action = 'Confirmed';
After wrapping the above query into a common table expression (CTE), we calculate the signup confirmation rate by referring to the formula at the beginning of this solution. You can also use a subquery, but CTEs tend to be the best practice.

So far, our output looks like this:

user_id	signup
7771	1
6950	1
1052	0
There are three users in the output, and two have activated their accounts. All of these numbers are of integer type. When we use integers to divide, one of them must be converted to the decimal type in order to prevent the result from being rounded to zero. So, we will cast one of them to decimal. Read here to learn more about division issues in PostgreSQL.

At the end, we'll use the ROUND function to truncate the decimal result to 2 decimal places, as specified in the instructions.

Full Solution #1: Using CTE

WITH rate AS (
SELECT
  user_id,
  CASE WHEN texts.email_id IS NOT NULL THEN 1
    ELSE 0 END AS signup
FROM emails
LEFT JOIN texts
  ON emails.email_id = texts.email_id
  AND signup_action = 'Confirmed')
  
SELECT ROUND(SUM(signup)::DECIMAL / COUNT(USER_ID), 2) AS confirm_rate
FROM rate;
Full Solution #2: Using Subquery

SELECT
  ROUND(SUM(signup)::DECIMAL / COUNT(user_id), 2) AS confirm_rate
FROM (
  SELECT
    user_id,
    CASE WHEN texts.email_id IS NOT NULL THEN 1
      ELSE 0 END AS signup
  FROM emails
  LEFT JOIN texts
    ON emails.email_id = texts.email_id
    AND signup_action = 'Confirmed'
    ) AS rate;
