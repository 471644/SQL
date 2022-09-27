Easy

TikTok
New TikTok users sign up with their emails and each user receives a text confirmation to activate their account. Assume you are given the below tables about emails and texts.

Write a query to display the ids of the users who did not confirm on the first day of sign-up, but confirmed on the second day.

Assumption:

action_date is the date when the user activated their account and confirmed their sign-up through the text.
emails Table:
Column Name	Type
email_id	integer
user_id	integer
signup_date	datetime
emails Example Input:
email_id	user_id	signup_date
125	7771	06/14/2022 00:00:00
433	1052	07/09/2022 00:00:00
texts Table:
Column Name	Type
text_id	integer
email_id	integer
signup_action	string ('Confirmed', 'Not confirmed')
action_date	datetime
texts Example Input:
text_id	email_id	signup_action	action_date
6878	125	Confirmed	06/14/2022 00:00:00
6997	433	Not Confirmed	07/09/2022 00:00:00
7000	433	Confirmed	07/10/2022 00:00:00
Example Output:
user_id
1052
Explanation: User 1052 is the only user who confirmed their sign up on the second day.

Solution
Credits to Deepak K @ Linkedin for sharing such an easy and concise solution that we have to share it with you.

There are 2 conditions that we have to fulfill:

Users who confirmed on the second day. (We'll explain how to define this below)
The texts received must say 'Confirmed'.
First, we join the emails and texts tables on the matching user_id field. Note that you can skip this step as we want to show you how condition no. 1 is defined.

SELECT *
FROM emails 
INNER JOIN texts
  ON emails.email_id = texts.email_id;
Showing you output with selected rows:

email_id	user_id	signup_date	text_id	email_id	signup_action	action_date
433	1052	07/09/2022 00:00:00	6997	433	Not confirmed	07/09/2022 00:00:00
433	1052	07/09/2022 00:00:00	7000	433	Confirmed	07/10/2022 00:00:00
236	6950	07/01/2022 00:00:00	9841	236	Confirmed	07/01/2022 00:00:00
450	8963	08/02/2022 00:00:00	6800	450	Not confirmed	08/03/2022 00:00:00
555	8963	08/09/2022 00:00:00	1255	555	Not confirmed	08/09/2022 00:00:00
555	8963	08/09/2022 00:00:00	2660	555	Not confirmed	08/10/2022 00:00:00
555	8963	08/09/2022 00:00:00	2800	555	Confirmed	08/11/2022 00:00:00
Let's interpret the output together.

Rows 1-2: User 1052 signed up on 07/09/2022 and confirmed their account on the next day, 07/10/2022. This is what we meant by "Users who confirmed on the second day" so the user satisfied both conditions.
Row 3: User 6950 signed up and confirmed their account on the same day, 07/01/2022 so this user fails both conditions.
Rows 4-7: User 8963 signed up twice, once on 08/02/2022 and another time on 08/09/2022, and only confirmed their account on 08/11/2022 which is 3 days after their signup. So, the first condition is not fulfilled.
Now that you understand how we're fulfilling those conditions, let's incorporate them into the solution.

Condition #1: Users who confirmed on the second day

SELECT *
FROM emails 
INNER JOIN texts
  ON emails.email_id = texts.email_id
WHERE texts.action_date = emails.signup_date + INTERVAL '1 day'
Note that you don't need to retrieve all the columns using SELECT *.

The texts.action_date = emails.signup_date + INTERVAL '1 day' condition in the WHERE clause essentially means as we only want users who confirmed on the second day as reflected in the texts.action_date field, then we can simply take emails.signup_date and add an interval of 1 day.

email_id	user_id	signup_date	text_id	signup_action	action_date
433	1052	07/09/2022 00:00:00	7000	Confirmed	07/10/2022 00:00:00
450	8963	08/02/2022 00:00:00	6800	Not confirmed	08/03/2022 00:00:00
555	8963	08/09/2022 00:00:00	2660	Not confirmed	08/10/2022 00:00:00
741	1235	07/25/2022 00:00:00	1568	Confirmed	07/26/2022 00:00:00
Did you see that the action_date is 1 day after the signup_date? We have fulfilled the 1st condition. Moving on to the second condition.

Condition #2: The texts received must say 'Confirmed'

SELECT *
FROM emails 
INNER JOIN texts
  ON emails.email_id = texts.email_id
WHERE texts.action_date = emails.signup_date + INTERVAL '1 day'
  AND texts.signup_action = 'Confirmed';
email_id	user_id	signup_date	text_id	signup_action	action_date
433	1052	07/09/2022 00:00:00	7000	Confirmed	07/10/2022 00:00:00
741	1235	07/25/2022 00:00:00	1568	Confirmed	07/26/2022 00:00:00
Finally, we have the information on users who confirmed their accounts on the day after their sign-up.

Note that the question asks you to output user ids only, not the entire table.

Solution:

SELECT DISTINCT user_id
FROM emails 
INNER JOIN texts
  ON emails.email_id = texts.email_id
WHERE texts.action_date = emails.signup_date + INTERVAL '1 day'
  AND texts.signup_action = 'Confirmed';