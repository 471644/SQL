Easy

Microsoft
Microsoft Azure's capacity planning team wants to understand how much data its customers are using, and how much spare capacity is left in each of it's data centers. You’re given three tables: customers, datacenters, and forecasted_demand.

Write a query to find the total monthly unused server capacity for each data center. Output the data center id in ascending order and the total spare capacity.

P.S. If you've read the Ace the Data Science Interview and liked it, consider writing us a review?

customers Table:
Column Name	Type
name	string
customer_id	integer
customers Example Input:
name	customer_id
Florian Simran	144
Esperanza A. Luna	109
Garland Acacia	852
datacenters Table:
Column Name	Type
datacenter_id	integer
name	string
monthly_capacity	integer
datacenters Example Input:
datacenter_id	name	monthly_capacity
1	London	100
3	Amsterdam	250
4	Hong Kong	400
forecasted_demand Table:
Column Name	Type
customer_id	integer
datacenter_id	integer
monthly_demand	integer
forecasted_demand Example Input:
customer_id	datacenter_id	monthly_demand
109	4	120
144	3	60
144	4	105
852	1	60
852	3	178
Example Output:
datacenter_id	spare_capacity
1	40
3	12
4	175


Solution
First, we need to find the total demand for each data center. This can be done by querying the table forecasted_demand and summing up the monthly_demand while simultaneously grouping on datacenter_id.

SELECT 
  datacenter_id,
  SUM(monthly_demand) AS total_demand
FROM forecasted_demand
GROUP BY datacenter_id;
Output shows the total demand grouped by the data centers.

datacenter_id	total_demand
1	78
2	145
3	238
4	250
As the next step is to calculate the spare capacity, we will need to join the query above with the datacenters table to retrieve the total monthly_capacity. Hence, using the results from previous step as a subquery or CTE, we join it with the table datacenters using the related datacenter_id field.

WITH demands AS (
  SELECT 
    datacenter_id,
    SUM(monthly_demand) AS total_demand
  FROM forecasted_demand
  GROUP BY datacenter_id)

SELECT 
  demands.datacenter_id, 
  demands.total_demand, 
  centers.name, 
  centers.monthly_capacity AS total_capacity
FROM demands
INNER JOIN datacenters AS centers
  ON demands.datacenter_id = centers.datacenter_id;
Output:

datacenter_id	total_demand	name	total_capacity
1	78	London	100
2	145	New York	200
3	238	Amsterdam	250
4	250	Hong Kong	400
So, now that we have the total demand and total capacity by data center, we can simply just deduct the total demand against total capacity to obtain the spare capacity.

Full Solution:

WITH demands 
AS (
  SELECT 
    datacenter_id,
    SUM(monthly_demand) AS total_demand
  FROM forecasted_demand
  GROUP BY datacenter_id)

SELECT 
  centers.datacenter_id, 
  (centers.monthly_capacity - demands.total_demand) AS spare_capacity
FROM demands
INNER JOIN datacenters AS centers
  ON demands.datacenter_id = centers.datacenter_id
ORDER BY centers.datacenter_id;
datacenter_id	spare_capacity
1	22
2	55
3	12
4	150
A CTE is a temporary data set to be used as part of a query and it exists during the entire query session. A subquery is a nested query. It’s a query within a query and unlike CTE, it can be used within that query only. Read here and here for more details.

Both methods give the same output and perform fairly similarly. Differences are CTE is reusable during the entire session and more readable, whereas subquery can be used in FROM and WHERE clauses and can act as a column with a single value. We share more resources here (1, 2, 3 on their use cases.

Solution #2: Using subquery

SELECT 
  centers.datacenter_id, 
  (centers.monthly_capacity - demands.total_demand) AS spare_capacity
FROM (
SELECT 
    datacenter_id,
    SUM(monthly_demand) AS total_demand
FROM forecasted_demand
GROUP BY datacenter_id) AS demands
INNER JOIN datacenters AS centers
  ON demands.datacenter_id = centers.datacenter_id
ORDER BY centers.datacenter_id;