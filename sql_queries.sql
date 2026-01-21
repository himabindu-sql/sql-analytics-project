employees(emp_id, name, department_id, salary, city, manager_id)
departments(department_id, department_name)

-- 1. Highest salary in each department
SELECT d.department_name, MAX(e.salary) AS highest_salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;


-- 2. Employees earning above department average salary
SELECT name, department_name, salary
FROM (
    SELECT e.name,
           d.department_name,
           e.salary,
           AVG(e.salary) OVER (PARTITION BY d.department_name) AS avg_salary
    FROM employees e
    JOIN departments d
    ON e.department_id = d.department_id
) t
WHERE salary > avg_salary;


-- 3. Second highest salary in the company
SELECT salary
FROM (
    SELECT salary,
           DENSE_RANK() OVER (ORDER BY salary DESC) AS dr
    FROM employees
) t
WHERE dr = 2;


-- 4. Top 2 highest paid employees in each department
SELECT name, department_name, salary
FROM (
    SELECT e.name,
           d.department_name,
           e.salary,
           DENSE_RANK() OVER (
               PARTITION BY d.department_name
               ORDER BY e.salary DESC
           ) AS dr
    FROM employees e
    JOIN departments d
    ON e.department_id = d.department_id
) t
WHERE dr <= 2;


-- 5. Total salary expense by department
SELECT d.department_name, SUM(e.salary) AS total_salary
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name;


-- 6. Departments having more than 1 employee
SELECT d.department_name, COUNT(*) AS emp_count
FROM employees e
JOIN departments d
ON e.department_id = d.department_id
GROUP BY d.department_name
HAVING COUNT(*) > 1;


-- 7. Running total of salaries ordered by employee ID
SELECT emp_id, name, salary,
       SUM(salary) OVER (ORDER BY emp_id) AS running_total
FROM employees;


-- 8. Employees who earn more than their manager
SELECT e.name AS employee,
       m.name AS manager,
       e.salary AS employee_salary,
       m.salary AS manager_salary
FROM employees e
JOIN employees m
ON e.manager_id = m.emp_id
WHERE e.salary > m.salary;


-- 9. Duplicate salaries in employees table
SELECT salary
FROM employees
GROUP BY salary
HAVING COUNT(*) > 1;


-- 10. Employee with lowest salary in each department
SELECT name, department_name, salary
FROM (
    SELECT e.name,
           d.department_name,
           e.salary,
           DENSE_RANK() OVER (
               PARTITION BY d.department_name
               ORDER BY e.salary ASC
           ) AS dr
    FROM employees e
    JOIN departments d
    ON e.department_id = d.department_id
) t
WHERE dr = 1;
