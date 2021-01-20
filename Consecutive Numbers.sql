Table: Logs

+-------------+---------+
| Column Name | Type    |
+-------------+---------+
| id          | int     |
| num         | varchar |
+-------------+---------+
id is the primary key for this table.
 

Write an SQL query to find all numbers that appear at least three times consecutively.

Return the result table in any order.

The query result format is in the following example:

 

Logs table:
+----+-----+
| Id | Num |
+----+-----+
| 1  | 1   |
| 2  | 1   |
| 3  | 1   |
| 4  | 2   |
| 5  | 1   |
| 6  | 2   |
| 7  | 2   |
+----+-----+

Result table:
+-----------------+
| ConsecutiveNums |
+-----------------+
| 1               |
+-----------------+
1 is the only number that appears consecutively for at least three times.


#################################################################
select
distinct(num) as 'ConsecutiveNums'
from
(select 
num,
lag(num,1) over() as 'lag_1',
lead(num,1) over() as 'lead_1'
from 
Logs) as temp_table
where 
temp_table.num=temp_table.lag_1
and 
temp_table.num=temp_table.lead_1



##################################################################

select
num as 'ConsecutiveNums'
from
(select 
num,
lag(num,1) over() as 'lag_1',
lead(num,1) over() as 'lead_1'
from 
Logs) as temp_table
where 
temp_table.num=temp_table.lag_1
and 
temp_table.num=temp_table.lead_1
group by temp_table.num