Easy

LinkedIn
Given a table of candidates and their skills, you're tasked with finding the candidates best suited for an open Data Science job. You want to find candidates who are proficient in Python, Tableau, and PostgreSQL.

Write a SQL query to list the candidates who possess all of the required skills for the job. Sort the the output by candidate ID in ascending order.

Assumption:

There are no duplicates in the candidates table.
candidates Table:
Column Name	Type
candidate_id	integer
skill	varchar
candidates Example Input:
candidate_id	skill
123	Python
123	Tableau
123	PostgreSQL
234	R
234	PowerBI
234	SQL Server
345	Python
345	Tableau
Example Output:
candidate_id
123
Explanation
Candidate 123 is displayed because they have Python, Tableau, and PostgreSQL skills. 345 isn't included in the output because they're missing one of the required skills: PostgreSQL.

-----------------------------------------------------------------------------------------------------------------
-- Questions 
  -- 1. we don't have any pre-processing needs ?
  -- 2. proficient means all the 3 skills ?
SELECT 
  candidates.candidate_id
FROM
  candidates
WHERE
  candidates.skill IN ('Python','Tableau','PostgreSQL')
GROUP BY
  1
HAVING COUNT(candidates.candidate_id) = 3
ORDER BY
  1 ASC