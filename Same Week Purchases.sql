Medium

Etsy
This is the same question as problem #29 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the two tables below containing information on Etsy user signups and user purchases. Write a query to obtain the percentage of users who signed up and made a purchase within the same week of signing up. Results should be rounded to nearest 2 decimal places.

signups Table:
Column Name	Type
user_id	integer
signup_date	datetime
signups Example Input:
user_id	signup_date
445	06/21/2022 12:00:00
742	06/19/2022 12:00:00
648	06/24/2022 12:00:00
789	06/27/2022 12:00:00
123	06/27/2022 12:00:00
user_purchases Table:
Column Name	Type
user_id	integer
product_id	integer
purchase_amount	decimal
purchase_date	datetime
user_purchases Example Input:
user_id	product_id	purchase_amount	purchase_date
244	7575	45.00	06/22/2022 12:00:00
742	1241	50.00	06/28/2022 12:00:00
648	3632	55.50	06/25/2022 12:00:00
123	8475	67.30	06/29/2022 12:00:00
244	2341	74.10	06/30/2022 12:00:00
Example Output:
single_purchase_pct
40.00
Explanation: The only users who purchased within a week are users 648 and 123. The total count of given signups is 5, resulting in a percentage of 2/5 = 40%.

Solution
First, we have to understand the formula and identify the elements to solve this question.

Percentage of users who purchased within the week of signing up = Number of users who purchased within the week of signing up / Number of users who sign-up

There are 2 elements that we will need before calculating the percentage:

Users who sign-up
Users who purchased within the week of signing up
By using the LEFT JOIN on the signups table, we are able to return all of the users that have signed up in addition to those that made a purchase within the same week. This fulfils the first element that we need to find which is the users who sign-up.

Additionally, we include additional filters

user_purchases.purchase_date IS NULL --> Include users who have not made any purchase
(user_purchases.purchase_date BETWEEN signups.signup_date AND (signups.signup_date + '1 week'::INTERVAL)) --> Fulfils the users who purchased within the week of signing up
Simply means that we want the users who purchased between the day of sign-up (Day 1) and the 7th day from the date of sign-up (Day 7).
'1 week'::INTERVAL is used to add 1 week to the signup_date. Neat trick, isn't it?
Run this code and study the output for yourself

SELECT *
FROM signups
LEFT JOIN user_purchases AS purchases
  ON signups.user_id = purchases.user_id
WHERE user_purchases.purchase_date IS NULL
  OR (user_purchases.purchase_date BETWEEN signups.signup_date 
  AND (signups.signup_date + '1 week'::INTERVAL));
Subsequently, we take the count of distinct users from the user_purchases table to obtain the number of users who made a purchase and divide it by the count of distinct users from the signups table to obtain the number of users who signup.

Then, we multiply the results by 100.0 instead of 100 to obtain the results in a percentage format. Finally, we use the ROUND function will allow us to display the results with 2 decimal places.

SELECT ROUND(
  100.0 * 
    COUNT(DISTINCT purchases.user_id) / 
    COUNT(DISTINCT signups.user_id), 2) AS same_week_purchases_pct
FROM signups
LEFT JOIN user_purchases AS purchases
  ON signups.user_id = purchases.user_id
WHERE purchases.purchase_date IS NULL
  OR (purchases.purchase_date BETWEEN signups.signup_date 
  AND (signups.signup_date + '1 week'::INTERVAL));
