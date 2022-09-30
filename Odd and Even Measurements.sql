Medium

Google
This is the same question as problem #28 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing measurement values obtained from a sensor over several days. Measurements are taken several times within a given day.

Write a query to obtain the sum of the odd-numbered and even-numbered measurements on a particular day, in two different columns.

Note that the 1st, 3rd, 5th measurements within a day are considered odd-numbered measurements and the 2nd, 4th, 6th measurements are even-numbered measurements.

measurements Table:
Column Name	Type
measurement_id	integer
measurement_value	decimal
measurement_time	datetime
measurements Example Input:
measurement_id	measurement_value	measurement_time
131233	1109.51	07/10/2022 09:00:00
135211	1662.74	07/10/2022 11:00:00
523542	1246.24	07/10/2022 13:15:00
143562	1124.50	07/11/2022 15:00:00
346462	1234.14	07/11/2022 16:45:00
Example Output:
measurement_day	odd_sum	even_sum
07/10/2022 00:00:00	2355.75	1662.74
07/11/2022 00:00:00	1124.50	1234.14
Explanation
On 07/11/2022, there are only two measurements. In chronological order, the first measurement (odd-numbered) is 1124.50, and the second measurement(even-numbered) is 1234.14.

Solution
Let's break down this question:

Order the measurements by 1, 2, 3 based on the measurement's time and partition by day
Find for odd and even measurements using the output in no. 1.
Add all the odd and even measurement values and output as two columns.
Step 1

We have to establish which measurements are odd numbered and even numbered. We can do so by using ROW_NUMBER window function and partition the measurements based on the casted measurement_time to obtain the order of measurement within each day.

SELECT 
  measurement_time, -- You don't need to pull this field out
  CAST(measurement_time AS DATE) AS measurement_day, 
  measurement_value, 
  ROW_NUMBER() OVER (
    PARTITION BY CAST(measurement_time AS DATE) 
    ORDER BY measurement_time) AS measurement_num 
FROM measurements;
Showing the first 5 rows of output:

measurement_time	measurement_day	measurement_value	measurement_num
07/10/2022 09:00:00	07/10/2022 00:00:00	1109.51	1
07/10/2022 11:00:00	07/10/2022 00:00:00	1662.74	2
07/10/2022 14:30:00	07/10/2022 00:00:00	1246.24	3
07/11/2022 13:15:00	07/11/2022 00:00:00	1124.50	1
07/11/2022 15:00:00	07/11/2022 00:00:00	1234.14	2
We pull the measurement_time field just to show you how the casting of measurement_time to day works.

Bear in mind that you should use measurement_time in the ORDER BY clause in the window function to ensure that the measurements are ordered within each day based on the actual measurement's time.

Step 2 & 3

Next, we filter for odd and even numbers by using these two methods:

Using measurement_num % 2 != 0 by checking whether the result is 1 for odds or measurement_num % 2 = 0 with result as 1 for even number.
Using MOD(measurement_num, 2) != 0 to find for odd result and MOD(measurement_num, 2) = 0 for even results.
P.S. The modulus or modulo operator, % returns the remainder of a division. When we divide an even number with 2, the remainder is always 0, whereas odd number division will result in a non-zero value.

Finally, we apply the above modulus concept onto the CASE statement, SUMming over the corresponding measurement_value:

WITH ranked_measurements AS (
-- Insert above query here
) 

SELECT 
  measurement_day, 
  SUM(
    CASE WHEN measurement_num % 2 != 0 THEN measurement_value ELSE 0 END) AS odd_sum, 
  SUM(
    CASE WHEN measurement_num % 2 = 0 THEN measurement_value ELSE 0 END) AS even_sum 
FROM ranked_measurements
GROUP BY measurement_day;
Results:

measurement_day	odd_sum	even_sum
07/10/2022 00:00:00	2355.75	1662.74
07/11/2022 00:00:00	2377.12	2480.70
07/12/2022 00:00:00	2903.40	1244.30
Solution:

WITH ranked_measurements AS (
  SELECT 
    CAST(measurement_time AS DATE) AS measurement_day, 
    measurement_value, 
    ROW_NUMBER() OVER (
      PARTITION BY CAST(measurement_time AS DATE) 
      ORDER BY measurement_time) AS measurement_num 
  FROM measurements
) 

SELECT 
  measurement_day, 
  SUM(
    CASE WHEN measurement_num % 2 != 0 THEN measurement_value 
      ELSE 0 END) AS odd_sum, 
  SUM(
  CASE WHEN measurement_num % 2 = 0 THEN measurement_value 
    ELSE 0 END) AS even_sum 
FROM ranked_measurements
GROUP BY measurement_day;
