Medium

Yelp
This is the same question as problem #27 in the SQL Chapter of Ace the Data Science Interview!

Assume you are given the table below containing information on user reviews. Write a query to obtain the number and percentage of businesses that are top rated. A top-rated busines is defined as one whose reviews contain only 4 or 5 stars.

Output the number of businesses and percentage of top rated businesses rounded to the 2 decimal places.

reviews Table:
Column Name	Type
business_id	integer
review_id	integer
review_stars	integer
review_date	datetime
reviews Example Input:
business_id	review_id	review_stars	review_date
532	1234	5	07/13/2022 12:00:00
824	1452	3	07/13/2022 12:00:00
819	2341	5	07/13/2022 12:00:00
716	1325	4	07/14/2022 12:00:00
423	1434	2	07/14/2022 12:00:00
Example Output:
business_num	top_business_pct
3	60.00
Explanation: There are 3 business with the rating at least 4 - business ids 532;819;716. The total count of the businesses is 5, resulting in a percentage of 3/5 = 60%.

Solution
First, we need to identify businesses having reviews consisting of only 4 or 5 stars. We can do so by using a CTE to find the reviews with 4 or 5 stars across all its reviews.

Then, we can use a COUNT to find the total number of top-rated businesses with 4 and 5 stars, then divide this by the total number of businesses to find the percentage of top-rated businesses.

WITH top_reviews 
AS (
  SELECT business_id, review_stars 
  FROM reviews 
  WHERE review_stars IN (4, 5)
) 

SELECT 
  COUNT(business_id) AS business_num, 
  ROUND(100.0 * COUNT(business_id)/ 
    (SELECT COUNT(business_id) 
      FROM reviews), 2) AS top_business_pct 
FROM top_reviews;
