Easy

Linkedin
This is the same question as problem #8 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below that shows job postings for all companies on the LinkedIn platform. Write a query to get the number of companies that have posted duplicate job listings (two jobs at the same company with the same title and description).

job_listings Table:
Column Name	Type
job_id	integer
company_id	integer
title	string
description	string
job_listings Example Input:
job_id	company_id	title	description
248	827	Business Analyst	Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.
149	845	Business Analyst	Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.
945	345	Data Analyst	Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.
164	345	Data Analyst	Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.
172	244	Data Engineer	Data engineer works in a variety of settings to build systems that collect, manage, and convert raw data into usable information for data scientists and business analysts to interpret.
Example Output:
duplicate_companies
1
Explanation
Because job_ids 945 and 164 are at the same company (345), and the jobs have the same title and description, there is exactly one company with a duplicate job.

Solution
The first step to solving this LinkedIn question correctly is connecting with me on LinkedIn 🥺 (This is Nick by the way!).

He's joking... but really, Nick's a very friendly guy! We can attest to it!

Ok, let's get back to business. First, we need to find all the companies with job listings that has the same title and description. We can do that by COUNTing the number of job_ids grouped by company_id, title and description.

SELECT 
  company_id, 
  title, 
  description, 
  COUNT(job_id) AS job_count
FROM job_listings
GROUP BY 
  company_id, 
  title, 
  description;
Output (showing first 5 rows with total of 7 rows):

company_id	title	description	job_count
827	Data Scientist	Data scientist uses data to understand and explain the phenomena around them, and help organizations make better decisions.	2
244	Data Engineer	Data engineer works in a variety of settings to build systems that collect, manage, and convert raw data into usable information for data scientists and business analysts to interpret.	1
845	Business Analyst	Business analyst evaluates past and current business data with the primary goal of improving decision-making processes within organizations.	1
244	Software Engineer	Software engineers design and create computer systems and applications to solve real-world problems.	2
345	Data Analyst	Data analyst reviews data to identify key insights into a business's customers and ways the data can be used to solve problems.	2
Next, we convert the previous query into a CTE and filter for when job_count is more than 1 meaning we only want where there are 2 or more duplicate job listings. Then, we apply a DISTINCT on company_id to get the unique company_id and COUNT them.

WITH jobs_grouped 
AS (
-- Insert above query here
)

SELECT 
  COUNT(DISTINCT company_id) AS duplicate_companies
FROM jobs_grouped
WHERE job_count > 1;
Results:

duplicate_jobs
3
Full solution:

WITH jobs_grouped 
AS (
  SELECT 
    company_id, 
    title, 
    description, 
    COUNT(job_id) AS job_count
  FROM job_listings
  GROUP BY 
    company_id, 
    title, 
    description)

SELECT 
  COUNT(DISTINCT company_id) AS duplicate_companies
FROM jobs_grouped
WHERE job_count > 1;