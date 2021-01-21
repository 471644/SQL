The Employee table holds all employees including their managers. Every employee has an Id, and there is also a column for the manager Id.

+----+-------+--------+-----------+
| Id | Name  | Salary | ManagerId |
+----+-------+--------+-----------+
| 1  | Joe   | 70000  | 3         |
| 2  | Henry | 80000  | 4         |
| 3  | Sam   | 60000  | NULL      |
| 4  | Max   | 90000  | NULL      |
+----+-------+--------+-----------+
Given the Employee table, write a SQL query that finds out employees who earn more than their managers. For the above table, Joe is the only employee who earns more than his manager.

+----------+
| Employee |
+----------+
| Joe      |
+----------+



###################################################################
select
temp.employee_name as 'Employee'
from 
(select 
o.Id,
o.name,
o.Salary as 'manager_salary',
o.ManagerId,
i.Salary as 'employee_salary',
i.name as 'employee_name'
from 
Employee as o 
inner join 
Employee as i 
on o.Id=i.ManagerId) temp
where
temp.employee_salary > temp.manager_salary

#####################################################################
SELECT emp.Name as 'Employee'
FROM 
Employee as emp
INNER JOIN 
Employee as mang
ON emp.ManagerId = mang.Id
WHERE 
emp.Salary > mang.Salary