Easy

New York Times
This is the same question as problem #3 in the SQL Chapter of Ace the Data Science Interview!

Assume that you are given the table below containing information on viewership by device type (where the three types are laptop, tablet, and phone). Define “mobile” as the sum of tablet and phone viewership numbers. Write a query to compare the viewership on laptops versus mobile devices.

Output the total viewership for laptop and mobile devices in the format of "laptop_views" and "mobile_views".

viewership Table:
Column Name	Type
user_id	integer
device_type	string ('laptop', 'tablet', 'phone')
view_time	timestamp
viewershipExample Input:
user_id	device_type	view_time
123	tablet	01/02/2022 00:00:00
125	laptop	01/07/2022 00:00:00
128	laptop	02/09/2022 00:00:00
129	phone	02/09/2022 00:00:00
145	tablet	02/24/2022 00:00:00
Example Output:
laptop_views	mobile_views
2	3
Explanation: Given the example input, there are 2 laptop views and 3 mobile views.

Solution
To compare the viewership on laptops versus mobile devices, we can use a CASE conditional statement to define the device type according to the question's specifications.

The tablet and phone categories are considered to be the 'mobile' device type and the laptop can be set as its own device type (i.e., 'laptop').

SELECT 
  CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END AS laptop_views, 
  CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END AS mobile_views 
FROM viewership;
laptop_views	mobile_views
0	1
1	0
1	0
0	1
0	1
Let us explain how the CASE statement works using the mobile_views field as an example.

When the device is a tablet or a phone, it is assigned the value of 1. Otherwise, it is given the value of 0.
The IN operator after device_type means OR, as in when the device type is a table OR phone, then it is assigned the value of 1.
Next, we calculate the number of viewership for laptops and mobiles. We can do so by applying the SUM function.

Solution:

SELECT 
  SUM(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
  SUM(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;
laptop_views	mobile_views
2	3
Ok, timeout guys!

We want you to take a step back and ask yourself this "Why can't you use the COUNT function instead since we're essentially "counting" the number of viewership?"

Say, we apply the COUNT function to the solution instead.

Run this query and we'll explain why it will give you the wrong output.

-- Incorrect solution
SELECT 
  COUNT(CASE WHEN device_type = 'laptop' THEN 1 ELSE 0 END) AS laptop_views, 
  COUNT(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE 0 END) AS mobile_views 
FROM viewership;
Instead of adding the values of 1 and 0, using COUNT will count the number of rows instead which gives you the following output of 5 laptop views and 5 mobile views. That's counterintuitive!

laptop_views	mobile_views
5	5
There's another way that you can use the COUNT function and obtain the correct output. Since COUNT is counting the number of values in the rows, what you can do is switch out the value of 0 with NULL instead.

-- Another correct solution
SELECT 
  COUNT(CASE WHEN device_type = 'laptop' THEN 1 ELSE NULL END) AS laptop_views, 
  COUNT(CASE WHEN device_type IN ('tablet', 'phone') THEN 1 ELSE NULL END) AS mobile_views 
FROM viewership;
With this query, only the correctly assigned device type gets the value of 1.

COUNT and SUM are two very important functions and are frequently asked in technical interviews. We hope that with this question, you'll know how to apply them appropriately.