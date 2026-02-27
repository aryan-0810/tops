use storedb;
use hrbd;
select * from emp_details;
select* from customer;
-- 1. write a SQL query to find customers who are either from the city 'NewYork' or
-- who do not have a grade greater than 100. Return customer_id, cust_name, city, grade, and salesman_id.

select customer_id,cust_name,city,grade,salesman_id from customer
where city = "new york" or grade < 100;

-- 2.write a SQL query to find all the customers in ‘New York’ city
-- who have agradevalue above 100. Return customer_id, cust_name, city, grade, and salesman_id.

select customer_id,cust_name,city,grade,salesman_id from customer
where city = "new york" and grade > 100;

-- 3. Write a SQL query that displays order number, purchase amount, and the
-- achieved and unachieved percentage (%) for those orders that exceed 50%of thetarget value of 6000

select * from orders;
select ord_no,purch_amt, ((purch_amt/6000)* 100) as achived_perch, 
100 - ((purch_amt / 6000) * 100) AS unachieved_percentage
from orders
WHERE (purch_amt / 6000) * 100 > 50;

 -- 4.write a SQL query to calculate the total purchase amount of all orders. Returntotal purchase amount.
 
 select sum(purch_amt) as total_pur_amt from orders;
 
 -- 5. write a SQL query to find the highest purchase amount ordered by each customer. Return customer ID, maximum purchase amount
 
 select * from orders;
 select customer_id,max(purch_amt) as highest_amt
from orders group by customer_id;


-- 6. write a SQL query to calculate the average product price. Return average product
-- price.

select avg(pro_price) as avg_price from item_mast;

-- 7.write a SQL query to find those employees whose department is located at ‘Toronto’.
-- Return first name, last name, employee ID, job ID.

select * from departments;
select * from locations;

select e.first_name,e.last_name from employees e 
join  departments d on e.department_id  = d.department_id
join  locations l on d.location_id = l.location_id
where city = 'toronto';

-- 8. write a SQL query to find those employees whose salary is lower than that of
-- employees whose job title is "MK_MAN". Exclude employees of the Jobtitle‘MK_MAN’. Return employee ID, first name, last name, job ID.  

select * from employees;
select first_name,last_name,salary,employee_id,job_id from employees
where salary < (select min(salary) from employees
where job_id = 'MK_MAN');

-- 9. write a SQL query to find all those employees who work in department ID 80 or 40. 
-- Return first name, last name, department number and department name.

select * from departments;
select e.first_name,e.last_name,e.department_id from employees e
join departments d on e.department_id = d.department_id
where d.department_id = 80 or d.department_id = 40;

-- 10.write a SQL query to calculate the average salary, the number of employees
-- receiving commissions in that department. Return department name, averagesalary and number of employees.

select avg(salary) as avg_salary,count(employee_id) as num_of_emp from employees
where commission_pct is not null;

-- 11.write a SQL query to find out which employees have the same designationas then employee whose ID is 169. 
-- Return first name, last name, department ID and jobID

select * from employees;
select first_name,last_name,department_id,job_id from employees
where job_id = (
select job_id from employees
where employee_id =169);

-- 12.write a SQL query to find those employees who earn more than the averagesalary. 
-- Return employee ID, first name, last name

select first_name,last_name,employee_id from employees
where salary > (select avg(salary) from employees);

-- 13.write a SQL query to find all those employees who work in the Finance
-- department. Return department ID, name (first), job ID and department name.

select * from employees;
select * from departments;
select e.first_name,e.last_name,e.department_id from employees e
join departments d on e.department_id = d.department_id
where d.department_name = (select department_name from departments
where department_name = 'Finance');

-- 14.From the following table, write a SQL query to find the employees who earn less than the employee of ID 182. 
-- Return first name, last name and salary

select first_name,last_name,employee_id,salary from employees
where salary < (select avg(salary) from employees);

-- 15.Create a stored procedure CountEmployeesByDept that returns the number of
-- employees in each department

select * from employees;
DELIMITER $$
CREATE PROCEDURE CountEmployeesByDept()
BEGIN
SELECT department_id,
COUNT(employee_id) AS total_employees
FROM employees
GROUP BY department_id;
END$$
DELIMITER ;
call CountEmployeesByDept();
--

-- 16 .Create a stored procedure AddNewEmployee that adds a new employee to the database.
DELIMITER //

CREATE PROCEDURE AddNewEmployee(
    IN p_first_name VARCHAR(50),
    IN p_last_name VARCHAR(50),
    IN p_email VARCHAR(100),
    IN p_phone_number VARCHAR(20),
    IN p_hire_date DATE,
    IN p_job_id VARCHAR(20),
    IN p_salary DECIMAL(10,2),
    IN p_department_id INT
)
BEGIN
    INSERT INTO employees (
        first_name,
        last_name,
        email,
        phone_number,
        hire_date,
        job_id,
        salary,
        department_id
    )
    VALUES (
        p_first_name,
        p_last_name,
        p_email,
        p_phone_number,
        p_hire_date,
        p_job_id,
        p_salary,
        p_department_id
    );
END //

DELIMITER ;


-- 17.Create a stored procedure DeleteEmployeesByDept that removes all employeesfrom a specific department

 DELIMITER $$
 create procedure DeleteEmployeesByDept()
 BEGIN
 delete from employees 
 where department_id = 100 ;
 end$$
 DELIMITER ;
 call DeleteEmployeesByDept();
 select * from employees;
 
 
 -- 18.Create a stored procedure GetTopPaidEmployees that retrieves the highest-paidemployee in each department.
 DELIMITER $$
 CREATE PROCEDURE GetTopPaidEmployees()
BEGIN
    SELECT 
        d.DepartmentName,
        e.EmployeeName,
        e.Salary
    FROM Employees e
    INNER JOIN Departments d 
        ON e.DepartmentID = d.DepartmentID
    INNER JOIN (
        SELECT 
            DepartmentID, 
            MAX(Salary) AS MaxSalary
        FROM Employees
        GROUP BY DepartmentID
    ) max_sal
        ON e.DepartmentID = max_sal.DepartmentID
        AND e.Salary = max_sal.MaxSalary;
END$$
DELIMITER ;
call GetTopPaidEmployees();

 
 -- 19.Create a stored procedure PromoteEmployee that increases an employee’s salary and changes their job role.
 
 DELIMITER $$

CREATE PROCEDURE PromoteEmployees (
    IN p_EmployeeID INT,
    IN p_SalaryIncrement DECIMAL(10,2),
    IN p_NewJobRole VARCHAR(50)
)
BEGIN
    UPDATE Employees
    SET 
        Salary = Salary + p_SalaryIncrement,
        JobRole = p_NewJobRole
    WHERE EmployeeID = p_EmployeeID;
END $$

DELIMITER ;
call PromoteEmployees();


-- 20.Create a stored procedure AssignManagerToDepartment that assigns a newmanager to all employees in a specific department

DELIMITER $$
CREATE PROCEDURE AssignManagerToDepartments (
    IN p_department_id INT,
    IN p_manager_id INT
)
BEGIN
    UPDATE employees
    SET manager_id = p_manager_id
    WHERE department_id = p_department_id;
END $$

DELIMITER ;
call AssignManagerToDepartments();
