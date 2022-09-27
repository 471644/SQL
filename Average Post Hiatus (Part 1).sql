Easy

Facebook
Given a table of Facebook posts, for each user who posted at least twice in 2021, write a query to find the number of days between each user’s first post of the year and last post of the year in the year 2021. Output the user and number of the days between each user's first and last post.

p.s. If you've read the Ace the Data Science Interview and liked it, consider writing us a review?

posts Table:
Column Name	Type
user_id	integer
post_id	integer
post_date	timestamp
post_content	timestamp
posts Example Input:
user_id	post_id	post_date	post_content
151652	599415	07/10/2021 12:00:00	Need a hug
661093	624356	07/29/2021 13:00:00	Bed. Class 8-12. Work 12-3. Gym 3-5 or 6. Then class 6-10. Another day that's gonna fly by. I miss my girlfriend
004239	784254	07/04/2021 11:00:00	Happy 4th of July!
661093	442560	07/08/2021 14:00:00	Just going to cry myself to sleep after watching Marley and Me.
151652	111766	07/12/2021 19:00:00	I'm so done with covid - need travelling ASAP!
Example Output:
user_id	days_between
151652	2
661093	21


Solution
First, we can use MIN and MAX clauses on the post_date column to retrieve the dates for the first and the last post, and then substract one from another accordingly.

As we are asked to find the difference on a user basis for the year 2021, it is important to GROUP the results by user_id, and then filter for the year 2021. To do so, we can use date_part function, which - as the name suggests - retrieves a part from input date. Thus, in our scenario it is the post_date variable. For more use cases, read more here.

Lastly, to filter out the users who have only posted once during the year, we can use HAVING clause with the COUNT of posts over 1

SELECT 
	user_id, 
    MAX(post_date::DATE) - MIN(post_date::DATE) AS days_between
FROM posts
WHERE DATE_PART('year', post_date::DATE) = 2021 
GROUP BY user_id
HAVING COUNT(post_id)>1;