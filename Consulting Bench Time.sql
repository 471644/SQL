Medium

Google
In consulting, being "on the bench" means you have a gap between two client engagements. Google wants to know how many days of bench time each consultant had in 2021. Assume that each consultant is only staffed to one consulting engagement at a time.

Write a query to pull each employee ID and their total bench time in days during 2021.

Assumptions:

All listed employees are current employees who were hired before 2021.
The engagements in the consulting_engagements table are complete for the year 2022.
staffing Table:
Column Name	Type
employee_id	integer
is_consultant	boolean
job_id	integer
staffing Example Input:
employee_id	is_consultant	job_id
111	true	7898
121	false	6789
156	true	4455
consulting_engagements Table:
Column Name	Type
job_id	integer
client_id	integer
start_date	date
end_date	date
contract_amount	integer
consulting_engagements Example Input:
job_id	client_id	start_date	end_date	contract_amount
7898	20076	05/25/2021 00:00:00	06/30/2021 00:00:00	11290.00
6789	20045	06/01/2021 00:00:00	11/12/2021 00:00:00	33040.00
4455	20001	01/25/2021 00:00:00	05/31/2021 00:00:00	31839.00
Example Output:
employee_id	bench_days
111	328
156	238
Explanation
Employee 111 had 328 days of bench time in 2021.

To calculate the 328 days of bench time for employee id 111, we first calculate their total number of work days between start date 05/25/2021 and end date 06/30/2021. Then we subtract this work time from 365 (days in a year) to get the number of bench days: 328.

Solution
Before we begin, we want to credit our DataLemur user Aidan Dominguez for coming up with this concise solution!

Now, let's move onto our action plan for solving this problem:

Calculate total work days for each employee: Find the non-bench days and inclusive days for each engagement.
Calculate the bench days for each employee: 365 – Number of Work Days
Step 1

Google wants to know the number of bench days each employee has in 2021.

Bench days refer to the time when a consultant isn't working on any engagements, but remains on the payroll and receives a regular salary. Essentially, they're the gaps between engagements.

We're going to calculate the reverse by finding the non-bench days with this query:

SELECT 
  staffs.employee_id,
  SUM(engagements.end_date - engagements.start_date) AS non_bench_days,
  COUNT(staffs.job_id) AS inclusive_days
FROM staffing AS staffs
INNER JOIN consulting_engagements AS engagements
  ON staffs.job_id = engagements.job_id
WHERE staffs.is_consultant = 'true'
GROUP BY staffs.employee_id;
employee_id	non_bench_days	inclusive_days
111	140	3
156	126	1
Let's interpret the output:

non_bench_days represent the days when the consultants are on an engagements and days that they are not on the bench, so to speak.
inclusive_days are the +1 days that we have to add when we're deducting a date from another day. For example, employee id 111 has an engagement that starts on 05/25/2021 and ends on 06/30/2021. To get the number of days, we do 06/30/2021 - 05/25/2021 and get 36 days. Then, we have to add 1 day to include the last day.
Because we're adding 1 day for each job, counting the number of job IDs for each employee is the same as adding an additional day for each job!
Step 2

Then, we wrap the query in a CTE and calculate the number of bench days by applying this formula. Click here to learn more about CTEs in PostgreSQL.

Number of bench days = 365 days - Number of bench days - Number of inclusive days

WITH consulting_days AS (
SELECT 
  staffs.employee_id,
  SUM(engagements.end_date - engagements.start_date) AS non_bench_days,
  COUNT(staffs.employee_id) AS inclusive_days
FROM staffing AS staffs
INNER JOIN consulting_engagements AS engagements
  ON staffs.job_id = engagements.job_id
WHERE staffs.is_consultant = 'true'
GROUP BY staffs.employee_id)

SELECT
  employee_id,
  365 - SUM(non_bench_days) - SUM(inclusive_days) AS bench_days
FROM consulting_days
GROUP BY employee_id;
Results:

employee_id	bench_days
111	222
156	238
