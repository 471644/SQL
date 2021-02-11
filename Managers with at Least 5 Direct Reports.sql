The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+------+----------+-----------+----------+
|Id    |Name 	  |Department |ManagerId |
+------+----------+-----------+----------+
|101   |John 	  |A 	      |null      |
|102   |Dan 	  |A 	      |101       |
|103   |James 	  |A 	      |101       |
|104   |Amy 	  |A 	      |101       |
|105   |Anne 	  |A 	      |101       |
|106   |Ron 	  |B 	      |101       |
+------+----------+-----------+----------+
Given the Employee table, write a SQL query that finds out managers with at least 5 direct report. For the above table, your SQL query should return:

+-------+
| Name  |
+-------+
| John  |
+-------+
Note:
No one would report to himself.

################## My Solution ###################
# Write your MySQL query statement below
SELECT 
Name
FROM
Employee
WHERE 
Id IN (
SELECT
t.ManagerId
FROM
(SELECT 
ManagerId,
COUNT(COALESCE(Id,0)) AS "C"
FROM
Employee
GROUP BY ManagerId
HAVING C>4)t)

################# Eligent Solution ################

select name
from
Employee E
Join
(
    select Managerid as mid
    from Employee
    group by 1
    Having count(id) >=5
)MangersWith5Reports
On(mid = E.id)
