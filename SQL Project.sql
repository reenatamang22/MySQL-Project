create database employee_management_data;

use employee_management_data;

CREATE TABLE departments (
    dept_id      INT PRIMARY KEY AUTO_INCREMENT,
    dept_name    VARCHAR(50) NOT NULL,
    location     VARCHAR(50)
);
 
-- ---------------------------------------------------
-- Table 2: employees  (8 attributes + primary key)
-- ---------------------------------------------------
CREATE TABLE employees (
    emp_id       INT PRIMARY KEY AUTO_INCREMENT,
    first_name   VARCHAR(50) NOT NULL,
    last_name    VARCHAR(50) NOT NULL,
    gender       VARCHAR(10),
    dob          DATE,
    email        VARCHAR(100) UNIQUE,
    phone        VARCHAR(15),
    hire_date    DATE,
    dept_id      INT,
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);
 
-- ---------------------------------------------------
-- Table 3: salaries
-- ---------------------------------------------------
CREATE TABLE salaries (
    salary_id     INT PRIMARY KEY AUTO_INCREMENT,
    emp_id        INT,
    basic_salary  DECIMAL(10,2),
    bonus         DECIMAL(10,2),
    deduction     DECIMAL(10,2),
    net_salary    DECIMAL(10,2),
    pay_date      DATE,
    FOREIGN KEY (emp_id) REFERENCES employees(emp_id) 
    );
    
    ----- EASY (5)------------

-- 1. List all distinct locations where departments are based.

SELECT DISTINCT location
FROM departments;

-- 2. Display employee first name, last name, and hire date, sorted by the most recently hired first.

SELECT first_name, last_name, hire_date
FROM employees
ORDER BY hire_date DESC;

-- 3.Find all employees whose basic_salary is between 30000 and 50000.

SELECT s.emp_id, s.basic_salary
FROM salaries s
WHERE s.basic_salary BETWEEN 30000 AND 50000;

-- 4. Show the top 10 employees in the employees table (by emp_id)

SELECT emp_id, first_name, last_name
FROM employees
ORDER BY emp_id
LIMIT 10;

-- 5. Find all employees who were born after 1995-01-01.

SELECT emp_id, first_name, last_name, dob
FROM employees
WHERE dob > '1995-01-01';

-------- INTERMEDIATE (20)---------

-- 1. List each employee's full name along with their department name.

SELECT e.first_name, e.last_name, d.dept_name
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id;

-- 2. Find the total number of employees in each department.

select d.dept_name, count(e.emp_id) as total_employees
from departments d
join employees e on d.dept_id = e.dept_id
group by d.dept_name;

-- 3. Display the average basic salary for each department.

SELECT d.dept_name, AVG(s.basic_salary) AS avg_basic_salary
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_name;

-- 4. Find the employee(s) with the highest net salary.

SELECT e.first_name, e.last_name, s.net_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.net_salary = (SELECT MAX(net_salary) FROM salaries);

-- 5. Find the employee(s) with the lowest net salary.

SELECT e.first_name, e.last_name, s.net_salary
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.net_salary = (SELECT MIN(net_salary) FROM salaries);

-- 6. Find the number of employees hired in each year.

SELECT YEAR(hire_date) AS hire_year, COUNT(*) AS total_hired
FROM employees
GROUP BY YEAR(hire_date)
ORDER BY hire_year;

-- 7. Show the department name with the maximum number of employees.

SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
ORDER BY total_employees DESC
LIMIT 1;

-- 8. List employees whose email domain is @company.com and hired in the year 2018.

SELECT first_name, last_name, email, hire_date
FROM employees
WHERE email LIKE '%@company.com'
AND YEAR(hire_date) = 2018;

-- 9. Find the total salary bill (sum of net_salary) paid company-wide.

SELECT SUM(net_salary) AS total_salary_bill
FROM salaries;

-- 10. Display employees along with their age (calculated from dob).

SELECT first_name, last_name, dob,
TIMESTAMPDIFF(YEAR, dob, CURDATE()) AS age
FROM employees;

-- 11. Find employees whose first name starts with "A".

SELECT first_name, last_name
FROM employees
WHERE first_name LIKE 'A%';

-- 12. List departments that have more than 500 employees.

SELECT d.dept_name, COUNT(e.emp_id) AS total_employees
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
GROUP BY d.dept_name
HAVING COUNT(e.emp_id) > 500;

-- 13. Show the top 5 highest-paid employees along with their department name.

SELECT e.first_name, e.last_name, d.dept_name, s.net_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
ORDER BY s.net_salary DESC
LIMIT 5;

-- 14. Find the number of male and female employees in each department.

SELECT d.dept_name, e.gender, COUNT(*) AS total
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
GROUP BY d.dept_name, e.gender
ORDER BY d.dept_name;

-- 15. Categorize each employee into a salary band (Low / Medium / High) using CASE.

SELECT e.first_name, e.last_name, s.net_salary,
CASE
WHEN s.net_salary < 40000 THEN 'Low'
WHEN s.net_salary BETWEEN 40000 AND 65000 THEN 'Medium'
ELSE 'High'
END AS salary_band
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id;

-- 16. Display gender as short codes (M/F) and label employees as "Senior" or "Junior" based on hire year, using CASE.

SELECT first_name, last_name,
CASE gender
WHEN 'Male' THEN 'M'
WHEN 'Female' THEN 'F'
ELSE 'O'
END AS gender_code,
CASE
WHEN YEAR(hire_date) <= 2017 THEN 'Senior'
ELSE 'Junior'
END AS seniority
FROM employees;

-- 17. Display each employee's full name (concatenated) along with the number of characters in it.

SELECT CONCAT(first_name, ' ', last_name) AS full_name,
       LENGTH(CONCAT(first_name, ' ', last_name)) AS name_length
FROM employees;

-- 18. List each department along with the total bonus paid, ordered from highest to lowest.

SELECT d.dept_name, SUM(s.bonus) AS total_bonus
FROM departments d
JOIN employees e ON d.dept_id = e.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
GROUP BY d.dept_name
ORDER BY total_bonus DESC;

-- 19. Find employees who joined in the last 5 years (relative to today's date).

SELECT first_name, last_name, hire_date
FROM employees
WHERE hire_date >= DATE_SUB(CURDATE(), INTERVAL 5 YEAR);

-- 20. Find the total number of distinct departments that actually have at least one employee.

SELECT COUNT(DISTINCT e.dept_id) AS departments_with_employees
FROM employees e;

-------- HARD (5)--------------------

-- 1. Find the second highest net_salary in the company.

SELECT MAX(net_salary) AS second_highest_salary
FROM salaries
WHERE net_salary < (SELECT MAX(net_salary) FROM salaries);

-- 2. For each department, find the employee with the highest net_salary (correlated subquery).

SELECT d.dept_name, e.first_name, e.last_name, s.net_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.net_salary = (
    SELECT MAX(s2.net_salary)
    FROM salaries s2
    JOIN employees e2 ON s2.emp_id = e2.emp_id
    WHERE e2.dept_id = e.dept_id
);

-- 3. Rank employees within each department by net_salary using RANK() OVER (PARTITION BY ...).

SELECT e.first_name, e.last_name, e.dept_id, s.net_salary,
RANK() OVER (PARTITION BY e.dept_id ORDER BY s.net_salary DESC) AS dept_salary_rank
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
ORDER BY e.dept_id, dept_salary_rank;

-- 4. Combine two employee groups — those hired before 2015 and those earning above 80000 — into one result using UNION.

SELECT emp_id, first_name, last_name, 'Hired Before 2015' AS matched_rule
FROM employees
WHERE hire_date < '2015-01-01'

UNION

SELECT e.emp_id, e.first_name, e.last_name, 'High Earner' AS matched_rule
FROM employees e
JOIN salaries s ON e.emp_id = s.emp_id
WHERE s.net_salary > 80000;

-- 5. Create a VIEW that shows each employee's full salary details with department name, then query it.

CREATE VIEW employee_salary_view AS
SELECT e.emp_id, e.first_name, e.last_name, d.dept_name,
       s.basic_salary, s.bonus, s.deduction, s.net_salary
FROM employees e
JOIN departments d ON e.dept_id = d.dept_id
JOIN salaries s ON e.emp_id = s.emp_id;

-- Query the view like a normal table
SELECT * FROM employee_salary_view
WHERE dept_name = 'IT'
ORDER BY net_salary DESC;

