Hard

Amazon
Amazon wants to maximize the number of items it can stock in a 500,000 square feet warehouse. It wants to stock as many prime items as possible, and afterwards use the remaining square footage to stock the most number of non-prime items.

Write a SQL query to find the number of prime and non-prime items that can be stored in the 500,000 square feet warehouse. Output the item type and number of items to be stocked.

inventory table:
Column Name	Type
item_id	integer
item_type	string
item_category	string
square_footage	decimal
inventory Example Input:
item_id	item_type	item_category	square_footage
1374	prime_eligible	mini refrigerator	68.00
4245	not_prime	standing lamp	26.40
2452	prime_eligible	television	85.00
3255	not_prime	side table	22.60
1672	prime_eligible	laptop	8.50
Example Output:
item_type	item_count
prime_eligible	9285
not_prime	6
To prioritise storage of prime_eligible items:

The combination of the prime_eligible items has a total square footage of 161.50 sq ft (68.00 sq ft + 85.00 sq ft + 8.50 sq ft).

To prioritise the storage of the prime_eligible items, we find the number of times that we can stock the combination of the prime_eligible items which are 3,095 times, mathematically expressed as: 500,000 sq ft / 161.50 sq ft = 3,095 items

Then, we multiply 3,095 times with 3 items (because we're asked to output the number of items to stock), which gives us 9,285 items.

Stocking not_prime items with remaining storage space:

After stocking the prime_eligible items, we have a remaining 157.50 sq ft (500,000 sq ft - (3,095 times x 161.50 sq ft).

Then, we divide by the total square footage for the combination of 2 not_prime items which is mathematically expressed as 157.50 sq ft / (26.40 sq ft + 22.60 sq ft) = 3 times so the total number of not_prime items that we can stock is 6 items (3 times x (26.40 sq ft + 22.60 sq ft)).

Solution
Goal: Find the maximum number of combination of the prime and non-prime items to be stocked, with prime items prioritized first.

Greedy Approach: Maximize the number of prime items first, then fill the remaining warehouse space with the maximum number of non-prime items. The output should be grouped by item type ('prime_eligible' and 'not_prime').

First, we build a summary table of the necessary fields: item type ('prime_eligible', 'not_prime'), then sum the square footage and count of items.

SELECT
  item_type,
  SUM(square_footage) AS total_sqft,
  COUNT(*) AS item_count
FROM inventory
GROUP BY item_type;
Results from the above query:

item_type	total_sqft	item_count
not_prime	128.50	4
prime_eligible	555.20	6
total_sqft refers to the total square feet for the specified item_count. The 4 'not_prime' items has a total square feet of 128.50.

After converting the above query into a CTE called summary, we find the number of times that we can stock the prime items in the warehouse space, since those have the highest priority.
We accomplish this by dividing 500,000 (the square-footage of the space) by the total square footage of prime items, and truncating the result to 0 decimal places using TRUNC.

WITH summary 
AS (  
  SELECT  
    item_type,  
    SUM(square_footage) AS total_sqft,  
    COUNT(*) AS item_count  
  FROM inventory  
  GROUP BY item_type)

SELECT  
  DISTINCT item_type,
  total_sqft,
  TRUNC(500000/total_sqft,0) AS prime_item_combo,
  (TRUNC(500000/total_sqft,0) * item_count) AS prime_item_count
FROM summary  
WHERE item_type = 'prime_eligible';
item_type	total_sqft	prime_item_combo	prime_item_count
prime_eligible	555.20	900	5400
We can stock 900 times of prime eligible items which can be mathematically expressed as:

900 times x 555.20 sq ft = 499,680 sq ft

Hence, the remaining warehouse space is 500,000 sq ft - 499,680 sq ft = 320 sq ft.

Next, we convert the previous query into a second CTE called prime_items, and write a similar query to find the number of times that we can stock the non-prime items to fill the remaining 320 sq ft.

Note that we use the sub-select SELECT prime_item_count * total_sqft FROM prime_items here to reference the square footage already taken up (~499,80 sq ft) by prime-eligible items.

WITH summary 
AS (  
  SELECT  
    item_type,  
    SUM(square_footage) AS total_sqft,  
    COUNT(*) AS item_count  
  FROM inventory  
  GROUP BY item_type),
prime_items 
AS (  
  SELECT  
    DISTINCT item_type,
    total_sqft,
    TRUNC(500000/total_sqft,0) AS prime_item_combo,
    (TRUNC(500000/total_sqft,0) * item_count) AS prime_item_count
  FROM summary  
  WHERE item_type = 'prime_eligible')

  SELECT
    DISTINCT item_type,
    total_sqft,  
    TRUNC(
      (500000 - (SELECT prime_item_combo * total_sqft FROM prime_items))  
      / total_sqft,0)  
      * item_count AS non_prime_item_count  
  FROM summary
  WHERE item_type = 'not_prime';
item_type	total_sqft	non_prime_item_count
not_prime	128.50	8
We can stock 8 total non-prime items; in other words, we can stock the established combination of 4 non-prime items (see first results table) twice. This is expressed in the query as:

TRUNC(
  (500000 - (SELECT prime_item_x * total_sqft FROM prime_items)) 
    / total_sqft,0)
    * item_count
It can be mathematically expressed in two steps as:
Step 1: (500,000 sq ft-(900 times * 555.20 prime sq ft)) / 128.50 non-prime sq ft =
~2 sq ft per non-prime item
Step 2: ~2 sq ft per non-prime item * 4 items per non-prime group = 8 non-prime items total

Now that we have the number of prime and non-prime items in two separate tables, we can combine them using the UNION ALL operator. Note that UNION ALL only works when the two SELECT statements have the same number of result fields with similar data types.

SELECT 
  item_type, 
  prime_item_count AS item_count
FROM prime_items
UNION ALL
SELECT 
  item_type, 
  non_prime_item_count AS item_count
FROM non_prime_items;
Final results:

item_type	item_count
prime_eligible	5400
not_prime	8
Solution:

WITH summary AS (  
  SELECT  
    item_type,  
    SUM(square_footage) AS total_sqft,  
    COUNT(*) AS item_count  
  FROM inventory  
  GROUP BY item_type
),
prime_items AS (  
  SELECT  
    DISTINCT item_type,
    total_sqft,
    TRUNC(500000/total_sqft,0) AS prime_item_combo,
    (TRUNC(500000/total_sqft,0) * item_count) AS prime_item_count
  FROM summary  
  WHERE item_type = 'prime_eligible'
),
non_prime_items AS (  
  SELECT
    DISTINCT item_type,
    total_sqft,  
    TRUNC(
      (500000 - (SELECT prime_item_combo * total_sqft FROM prime_items))  
      / total_sqft, 0) * item_count AS non_prime_item_count  
  FROM summary
  WHERE item_type = 'not_prime')

SELECT 
  item_type,  
  prime_item_count AS item_count  
FROM prime_items  
UNION ALL  
SELECT  
  item_type,  
  non_prime_item_count AS item_count  
FROM non_prime_items;
