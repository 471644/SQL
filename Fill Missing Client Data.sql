Medium

Accenture
When you log in to your retailer client's database, you notice that their product catalog data is full of gaps in the category column. Can you write a SQL query that returns the product catalog with the missing data filled in?

Assumptions

Each category is mentioned only once in a category column.
All the products belonging to same category are grouped together.
The first product from a product group will always have a defined category.
Meaning that the first item from each category will not have a missing category value.
products Table:
Column Name	Type
product_id	integer
category	varchar
name	varchar
products Example Input:
product_id	category	name
1	Shoes	Sperry Boat Shoe
2		Adidas Stan Smith
3		Vans Authentic
4	Jeans	Levi 511
5		Wrangler Straight Fit
6	Shirts	Lacoste Classic Polo
7		Nautica Linen Shirt
Example Output:
product_id	category	name
1	Shoes	Sperry Boat Shoe
2	Shoes	Adidas Stan Smith
3	Shoes	Vans Authentic
4	Jeans	Levi 511
5	Jeans	Wrangler Straight Fit
6	Shirts	Lacoste Classic Polo
7	Shirts	Nautica Linen Shirt
Explanation:
Shoes will replace all NULL values below the product Sperry Boat Shoe until Jeans appears. Similarly, Jeans will replace NULLs for the product Wrangler Straight Fit, and so on.


Solution
It is given that all the products belonging to same category are listed together in sequence, and that the first product in a group will have its category defined. The first thing we want to do is label products that are in the same category so that we can tell them apart.

We can use COUNT as a window function to assign a number for each type of category. COUNT function will compute the number of rows with non-null values in the category column.

The goal of this exercise is to understand the category groups so that we know which values should fill in the NULLs.

The query should look like this:

SELECT
  product_id,
  category,
  name,
  COUNT(category) OVER (ORDER BY product_id) AS category_group
FROM products;
Query output:

product_id	category	name	category_group
1	Shoes	Sperry Boat Shoe	1
2		Adidas Stan Smith	1
3		Vans Authentic	1
4	Jeans	Levi 511	2
5		Wrangler Straight Fit	2
Let's interpret the output.

The first product in the table is the Sperry Boat Shoe. The category_group value for this product will be determined by the COUNT function as 1. No category has been assigned to the second or third products. In this case, the counter will not be increased, and category_group will remain at 1 for each of them. The fourth product, Levi 511, is labelled as Jeans, which is a non-null value, hence the counter gets increased for this product.

On the basis of the newly generated column category_group, the next step is to fill the missing category for each product. We can accomplish this by using another window function: FIRST_VALUE.

Let's apply this function to the query we have created using a common table expression(CTE).

WITH fill_products AS (
-- Enter previous query here
)
SELECT
  product_id,
  name,
  category_group,
  FIRST_VALUE (category) OVER (
  	PARTITION BY category_group
    ORDER BY product_id) AS category,
FROM fill_products;
Output:

product_id	name	category_group	category
1	Sperry Boat Shoe	1	Shoes
2	Adidas Stan Smith	1	Shoes
3	Vans Authentic	1	Shoes
4	Levi 511	2	Jeans
5	Wrangler Straight Fit	2	Jeans
The PARTITION BY clause will distribute rows by category_group into several partitions, one for 1, another for 2, and so on. The FIRST_VALUE function is applied to each category group separately. For the first partition, it will return Shoes, and for the second partition it will return Jeans because these categories were the first value of each category group.

Let's clean-up our code a little bit to format the result as the task requested.

Bonus: The technical term for this type of task is a fill-down activity.

Full Solution:

WITH fill_products AS (
SELECT
  product_id,
  category,
  name,
  COUNT(category) OVER (ORDER BY product_id) AS category_group
FROM products)

SELECT
  product_id,
  FIRST_VALUE (category) OVER (
  	PARTITION BY category_group
    ORDER BY product_id) AS category,
  name
FROM fill_products;
