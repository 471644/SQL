Medium

Accenture
Your team at Accenture is helping a Fortune 500 client revamp their compensation and benefits program. The first step in this analysis is to manually review employees who are potentially overpaid or underpaid.

An employee is considered to be potentially overpaid if they earn more than 2 times the average salary for people with the same title. Similarly, an employee might be underpaid if they earn less than half of the average for their title. We'll refer to employees who are both underpaid and overpaid as compensation outliers for the purposes of this problem.

Write a query that shows the following data for each compensation outlier: employee ID, salary, and whether they are potentially overpaid or potentially underpaid.

employee_pay Table:
Column Name	Type
employee_id	integer
salary	integer
title	varchar
employee_pay Example Input:
employee_id	salary	title
101	80000	Data Analyst
102	90000	Data Analyst
103	100000	Data Analyst
104	30000	Data Analyst
105	120000	Data Scientist
106	100000	Data Scientist
107	80000	Data Scientist
108	310000	Data Scientist
Example Output:
employee_id	salary	status
104	30000	Underpaid
108	310000	Overpaid
Explanation
In this example, 2 employees qualify as compensation outliers. Employee 104 is a Data Analyst, and the average salary for this position is $75,000. Meanwhile, the salary of employee 104 is less than $37,500 (half of $75,000); therefore, they are underpaid.

Solution
Let's break this problem down into 3 steps.

Calculate the average salary for each title
Create new columns that show double and half of the average salaries.
Identify outliers using the newly created columns.
Step 1: Average Salaries

We'll use AVG for this step; however, instead of using AVG in the typical fashion, we'll use it as a window function.

Why use it as a window function, you might ask? Well, the regular AVG aggregate function would give us the overall average of all salaries, which we would then need to GROUP BY job title later. By using AVG as a window function, we can PARTITION BY job titles directly, thus grouping the results inside the AVG clause itself. Click here to learn more about window functions in PostgreSQL.

The query should look something like this:

SELECT
  employee_id,
  salary,
  title,
  AVG(salary) OVER (PARTITION BY title) AS average_salary
FROM employee_pay;
The output will appear as follows for the Data Analysts:

employee_id	salary	title	average_salary
101	80000	Data Analyst	75000
102	90000	Data Analyst	75000
103	100000	Data Analyst	75000
104	30000	Data Analyst	75000
The average of the data analyst positions was calculated by summing all of their salaries and then dividing by the number of analysts (4):

(80000+90000+100000+30000)/4 = 300000/4 = 75000

Step 2: Double and Half Salaries

Let's adjust our previous query to take this into account. We'll simply double the AVG clause for one field and then halve it for the other:

SELECT
  employee_id,
  salary,
  title,
  (AVG(salary) OVER (PARTITION BY title)) * 2 AS double_average,
  (AVG(salary) OVER (PARTITION BY title)) / 2 AS half_average
FROM employee_pay;
Step 3: Identify Outliers

The question specifies that employees are potentially

overpaid if they make over two times the average salary
underpaid if they make less than half the average salary
We'll enclose the above query in a Common Table Expression (CTE) and use a CASE WHEN statement to compare each employee's pay to the double_average and half_average values for their title.

The query will look something like this

WITH payout AS (
-- Insert previous query here
)

SELECT
  employee_id,
  salary,
  double_average,
  half_average,
  CASE WHEN salary > double_average THEN 'Overpaid'
    WHEN salary < half_average THEN 'Underpaid'
  END AS outlier_status
FROM payout;
Output:

employee_id	salary	double_average	half_average	outlier_status
101	80000	150000	37500	
102	90000	150000	37500	
103	100000	150000	37500	
104	30000	150000	37500	Underpaid
Employee 104 is underpaid because their compensation of $30,000 is less than half of the average income of $37,500. The remaining employees are all comfortably within the compensation range.

We're almost there now! All we have left to do now is filter on the outliers with a WHERE clause, as per the task instructions.

Note: We can't simply use WHERE outlier_status IS NOT NULL because outlier_status is a calculated field, and will not be recognized in a WHERE clause.

The final query will be structured as follows:

Full Solution:

WITH payout AS (
SELECT
  employee_id,
  salary,
  title,
  (AVG(salary) OVER (PARTITION BY title)) * 2 AS double_average,
  (AVG(salary) OVER (PARTITION BY title)) / 2 AS half_average
FROM employee_pay)

SELECT
  employee_id,
  salary,
  CASE WHEN salary > double_average THEN 'Overpaid'
    WHEN salary < half_average THEN 'Underpaid'
  END AS outlier_status
FROM payout
WHERE salary > double_average
  OR salary < half_average;



 


