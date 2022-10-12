Hard

Airbnb
The Airbnb Booking Recommendations team is trying to understand the "substitutability" of two rentals and whether one rental is a good substitute for another. They want you to write a query to determine if two Airbnb rentals have the same exact amenities offered.

Output the count of matching rental ids.

Assumptions:

If property 1 has kitchen and pool, and property 2 has kitchen and pool too, then it is a good substitute and represents a count of 1 matching rental.
If property 3 has kitchen, pool and fireplace, and property 4 only has pool and fireplace, then it is not a good substitute.
rental_amenities Table:
Column Name	Type
rental_id	integer
amenity	string
rental_amenities Example Input:
rental_id	amenity
123	pool
123	kitchen
234	hot tub
234	fireplace
345	kitchen
345	pool
456	pool
Example Output:
matching_airbnb
1
Explanation: The count of matching rentals is 1 as rentals 123 and 345 are a match as they both have a kitchen and a pool.

Solution
To find matching records between the different rows of the same table, we can use self-join on a common identifier.

If we are looking for a match on any of the amenities (i.e. property 1 has a pool; property 2 has a pool & beach facility), we could do the join on the existing amenity column. However, as per the question, we have to make sure the two properties have the exact same amenities (i.e. property 1 has a pool & beach facility, then property 2 has to have a pool & beach facility too).

Thus, we can aggregate the amenities into an array with ARRAY_AGG() function. You can read more about the function here. It is important to order the dataset as otherwise, we could end up with a situation where property 1 has a row {"kitchen", "pool"} while property 2 is {"pool", "kitchen"}, and so when we're performing the self-join, it would not yield a match. We'll explain more about this later.

SELECT
  rental_id,
  ARRAY_AGG(amenity ORDER BY amenity) AS amenities
FROM rental_amenities
GROUP BY rental_id;
Showing you the partial output:

rental_id	amenities
123	kitchen","pool
231	pet-friendly
234	hot tub","pool
345	kitchen","pool
452	beach","free parking
Note that rental id 123 and 345 have the exact same amenities of {"kitchen", "pool"}.

What happens if we did not sort the ordering in the ARRAY_AGG function? Then we may have one of the rentals having an output of {"pool", "kitchen"} (incorrect order of amenity)and we would not be able to join them on the amenities field.

For the next step, we name the above query as airbnb_amenities and perform a self-join by creating two aliases (airbnb1, airbnb2) for the two tables.

WITH airbnb_amenities AS (
SELECT
  rental_id,
  ARRAY_AGG(amenity ORDER BY amenity) AS amenities
FROM rental_amenities
GROUP BY rental_id)

SELECT *
FROM airbnb_amenities AS airbnb1
JOIN airbnb_amenities AS airbnb2
  ON airbnb1.amenities = airbnb2.amenities;
This query will yield all of the matches between the properties - however, there are two problems.

A property will match itself.
It will yield duplicate matches as we have the same table two times.
Do you see what we mean by the two problems?

rental_id	amenities	rental_id	amenities
123	"kitchen","pool"	345	"kitchen","pool"
123	"kitchen","pool"	123	"kitchen","pool"
231	"pet-friendly"	956	"pet-friendly"
231	"pet-friendly"	231	"pet-friendly"
In row 2 and 4, rental id 123 and 231 is matching with itself on {"kitchen","pool"} and {"pet-friendly"}.
The correct answer should be a count of 2 matching rentals from the match between 123 & 345 and 231 & 956, however, the output would give us a count of 4 matching rentals.
To combat this, let's revise our query and exclude those situations.

The first problem is easy to tackle. We could just look at the rows where the ids are different by adding a condition airbnb1.rental_id <> airbnb2.rental_id. However, this still does not solve the second problem where the output yields duplicate matches.

Give this query a go and you'll understand what we mean by incorrect duplicate matches.

WITH airbnb_amenities AS (
SELECT
  rental_id,
  ARRAY_AGG(amenity ORDER BY amenity) AS amenities
FROM rental_amenities
GROUP BY rental_id)

SELECT *
FROM airbnb_amenities AS airbnb1
JOIN airbnb_amenities AS airbnb2
  ON airbnb1.amenities = airbnb2.amenities
WHERE airbnb1.rental_id <> airbnb2.rental_id;
Fortunately, there is a clever way to kill two birds with one stone.

Instead of just specifying the ids to be different, we will look at matches where one rental id is bigger than the other (does not matter which combination) by applying the condition at1.rental_id > at2.rental_id. For easier understanding, refer to the sequence of tables below.

at1.rental_id > at2.rental_id

r1.rental_id	amenity	r2.rental_id
345	kitchen	123
at1.rental_id < at2.rental_id

r1.rental_id	amenity	r2.rental_id
123	pool	345
Both comparison operators, > & <give the same output and count of 1 matching rental.

For the final step, simply count the rows and we are done!

WITH airbnb_amenities AS (
SELECT
  rental_id,
  ARRAY_AGG(amenity ORDER BY amenity) AS amenities
FROM rental_amenities
GROUP BY rental_id)

SELECT COUNT(*) AS matching_airbnb
FROM airbnb_amenities AS airbnb1
JOIN airbnb_amenities AS airbnb2
  ON airbnb1.amenities = airbnb2.amenities
WHERE airbnb1.rental_id > airbnb2.rental_id;
