Medium

LinkedIn
The LinkedIn Creator team is looking for power creators who use their personal profile as a company or influencer page. If someone's LinkedIn page has more followers than the company they work for, we can safely assume that person is a power creator.

Write a query to return the IDs of these LinkedIn power creators in alphabetical order.

Assumption:

A person can work at multiple companies.
This is the second part of the question, so make sure your start with Part 1 if you haven't completed that yet!

personal_profiles Table:
Column Name	Type
profile_id	integer
name	string
followers	integer
personal_profiles Example Input:
profile_id	name	followers
1	Nick Singh	92,000
2	Zach Wilson	199,000
3	Daliana Liu	171,000
4	Ravit Jain	107,000
5	Vin Vashishta	139,000
6	Susan Wojcicki	39,000
employee_company Table:
Column Name	Type
personal_profile_id	integer
company_id	integer
employee_company Example Input:
personal_profile_id	company_id
1	4
1	9
2	2
3	1
4	3
5	6
6	5
company_pages Table:
Column Name	Type
company_id	integer
name	string
followers	integer
company_pages Example Input:
company_id	name	followers
1	The Data Science Podcast	8,000
2	Airbnb	700,000
3	The Ravit Show	6,000
4	DataLemur	200
5	YouTube	1,6000,000
6	DataScience.Vin	4,500
9	Ace The Data Science Interview	4479
Example Output:
profile_id
1
3
4
5
This output shows that profile IDs 1-5 are all power creators, meaning that they have more followers than their each of their company pages, whether they work for 1 company or 3.

Solution
In contrast to the first part of this question, the assumption here is that a person can work at multiple companies. Since this is the case, we should only compare a person's profile followers against the employer company with the highest follower count.

Step 1

Before we can analyze the data, we need to combine the company_pages and employee_company tables that show the relationships between each profile_id and their employers.

Using a LEFT JOIN, the query should look like this:

SELECT *
FROM employee_company AS employees
LEFT JOIN company_pages AS pages
  ON employees.company_id = pages.company_id;
Click here to learn more about the different SQL JOINs.

Step 2

Now we have profiles, companies, and their respective follower counts all in one dataset. It's time to determine the companies with the largest follower count per profile_id using MAX aggregate function and group by.

Let's wrap this finished query in a common table expression (CTE) so we can reuse it later.

WITH popular_companies 
AS (
  SELECT
    employees.personal_profile_id,
	MAX(pages.followers) AS highest_followers
FROM employee_company AS employees
LEFT JOIN company_pages AS pages
  ON employees.company_id = pages.company_id  
GROUP BY employees.personal_profile_id)
Step 3

We made it to the final step!

Just like in Part 1, it's time to compare the followers between each profile ID and its most popular employer company. Then, we'll select the profile IDs that have more followers than their respective company.

That's it – well done!

Solution:

WITH popular_companies 
AS (
  SELECT
    employees.personal_profile_id,
	MAX(pages.followers) AS highest_followers
  FROM employee_company AS employees 
  LEFT JOIN company_pages AS pages
    ON employees.company_id = pages.company_id  
  GROUP BY employees.personal_profile_id)

SELECT profiles.profile_id
FROM popular_companies AS companies
LEFT JOIN personal_profiles AS profiles
	ON companies.personal_profile_id = profiles.profile_id
WHERE profiles.followers > companies.highest_followers
ORDER BY profiles.profile_id;
