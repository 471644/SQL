Easy

LinkedIn
The LinkedIn Creator team is looking for power creators who use their personal profile as a company or influencer page. If someone's LinkedIn page has more followers than the company they work for, we can safely assume that person is a power creator.

Write a query to return the IDs of these LinkedIn power creators ordered by the IDs.

Assumption:

Each person with a LinkedIn profile in this database works at one company only.
personal_profiles Table:
Column Name	Type
profile_id	integer
name	string
followers	integer
employer_id	integer
personal_profiles Example Input:
profile_id	name	followers	employer_id
1	Nick Singh	92,000	4
2	Zach Wilson	199,000	2
3	Daliana Liu	171,000	1
4	Ravit Jain	107,000	3
5	Vin Vashishta	139,000	6
6	Susan Wojcicki	39,000	5
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
Example Output:
profile_id
1
3
4
5
This output shows that profile IDs 1-5 are all power creators, meaning that they have more followers than their company page.

Solution
Our goal is to identify all LinkedIn profiles that have more followers than their employer's pages.

Since the data is located in two different tables, the first step will be to join them on a common field. We can see that employer_id in the personal_profiles table is the same field as company_id in the company_pages table. Therefore, we can join using these fields. Note that you cannot join using the followers field here.

Use JOIN to merge the tables personal_profiles and company_pages. Note that we use aliases to make the query more concise.

The query should look like this:

SELECT *
FROM personal_profiles AS profiles
INNER JOIN company_pages AS pages
  ON profiles.employer_id = pages.company_id;
Click here to learn more about different types of SQL joins such as the LEFT JOIN and RIGHT JOIN . We used a regular JOIN (also known as an INNER JOIN) here because we only want to pull the personal profiles that have a matching company ID value.

Now that our query data is combined, it's time to compare the number of followers of each personal profile and their company's page. To accomplish this, we'll use a WHERE clause that explicitly compares follower counts from both tables, and outputs only the results where the former is greater: WHERE profiles.followers > pages.followers

By combining the two steps together, we'll achieve our final solution. Since the example output shows only the profile_id field, there is no need to include all of the columns.

SELECT profiles.profile_id
FROM personal_profiles AS profiles
INNER JOIN company_pages AS pages
  ON profiles.employer_id = pages.company_id
WHERE profiles.followers > pages.followers
ORDER BY profiles.profile_id;
