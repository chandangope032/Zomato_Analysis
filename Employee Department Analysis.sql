create database Employee_Deparment_Analysis;
use Employee_Deparment_Analysis;


#######################################################################################
# Q-1) Employee Table 

CREATE TABLE Employee (
  empno INTEGER NOT NULL PRIMARY KEY,
  ename VARCHAR(50) NOT NULL,
  job VARCHAR(50) DEFAULT 'CLERK',
  mgr INTEGER,
  hiredate DATE,
  sal DECIMAL(10, 2) NOT NULL CHECK (sal >= 0),
  comm DECIMAL(10, 2),
  deptno INTEGER REFERENCES Dept(deptno)
);

INSERT INTO Employee (empno, ename, job, mgr, hiredate, sal, comm, deptno) VALUES
(7369, 'SMITH', 'CLERK', 7902, '1890-12-17', 800.00, NULL, 20),
(7499, 'ALLEN', 'SALESMAN', 7698, '1981-02-20', 1600.00, 300.00, 30),
(7521, 'WARD', 'SALESMAN', 7698, '1981-02-22', 1250.00, 500.00, 30),
(7566, 'JONES', 'MANAGER', 7839, '1981-04-02', 2975.00, NULL, 20),
(7654, 'MARTIN', 'SALESMAN', 7698, '1981-09-28', 1250.00, 1400.00, 30),
(7698, 'BLAKE', 'MANAGER', 7839, '1981-05-01', 2850.00, NULL, 30),
(7782, 'CLARK', 'MANAGER', 7839, '1981-06-09', 2450.00, NULL, 10),
(7788, 'SCOTT', 'ANALYST', 7566, '1987-04-19', 3000.00, NULL, 20),
(7839, 'KING', 'PRESIDENT', NULL, '1981-11-17', 5000.00, NULL, 10),
(7844, 'TURNER', 'SALESMAN', 7698, '1981-09-08', 1500.00, 0.00, 30),
(7876, 'ADAMS', 'CLERK', 7788, '1987-05-23', 1100.00, NULL, 20),
(7900, 'JAMES', 'CLERK', 7698, '1981-12-03', 950.00, NULL, 30),
(7902, 'FORD', 'ANALYST', 7566, '1981-12-03', 3000.00, NULL, 20),
(7934, 'MILLER', 'CLERK', 7782, '1982-01-23', 1300.00, NULL, 10);

select * from employee;


#######################################################################################
# Q-2) The Dept Table 

CREATE TABLE dept (
  deptno INT,
  dname VARCHAR(255),
  loc VARCHAR(255)
);

INSERT INTO dept (deptno, dname, loc) VALUES
(10, 'OPERATIONS ', 'BOSTON'),
(20, 'RESEARCH', 'DALLAS'),
(30, 'SALES', 'CHICAGO'),
(40,  'ACCOUNTING', 'NEW YORK');


select * from dept;

#######################################################################################
# Q-3) List the Names and salary of the employee whose salary is greater than 1000

SELECT ename, sal
FROM employee
WHERE sal > 1000;


#######################################################################################
# Q-4) List the details of the employees who have joined before the end of September 81:

SELECT *
FROM employee
WHERE hiredate < '1981-10-01';


#######################################################################################
# Q-5) List Employee Names having 'I' as the second character:

SELECT ename
FROM employee
WHERE ename LIKE '_I%';


#######################################################################################
# Q-6) List Employee Name, Salary, Allowances (40% of Sal), P.F. (10% of Sal), and Net Salary. Also assign the alias name for the columns:

SELECT ename AS "Employee Name", sal AS "Salary", sal * 0.4 AS "Allowances",
       sal * 0.1 AS "P.F.", sal * 0.5 AS "Net Salary"
FROM employee;


#######################################################################################
# Q-7) List Employee Names with designations who do not report to anybody:

select ename,job from employee
where mgr is null;


#######################################################################################
# Q-8) List Empno, Ename, and Salary in ascending order of salary:

SELECT empno, ename, sal
FROM employee
ORDER BY sal ASC;


#######################################################################################
# Q-9) How many jobs are available in the organization?

SELECT COUNT(DISTINCT job) AS job_count
FROM employee;


#######################################################################################
# Q-10) Determine the total payable salary of the salesman category:

SELECT SUM(sal + COALESCE(comm, 0)) AS total_salary
FROM employee
WHERE job = 'SALESMAN';

#######################################################################################
# Q-11) List the average monthly salary for each job within each department:

SELECT d.dname, e.job, AVG(e.sal) AS avg_salary
FROM employee e
JOIN dept d ON e.deptno = d.deptno
GROUP BY d.dname, e.job;

#######################################################################################
# Q-12) Use the same EMP and DEPT table to display EMPNAME, SALARY, and DEPTNAME in which the employee is working:

SELECT e.ename AS "EMPNAME", e.sal AS "SALARY", d.dname AS "DEPTNAME"
FROM employee e
 left JOIN dept d ON e.deptno = d.deptno;


#######################################################################################
# Q-13) the Job Grades Table 

CREATE TABLE job_grades (
  grade VARCHAR(1),
  lowest_sal INT,
  highest_sal INT
);

INSERT INTO job_grades (grade, lowest_sal, highest_sal) VALUES
('A', 0, 999),
('B', 1000, 1999),
('C', 2000, 2999),
('D', 3000, 3999),
('E', 4000, 5000);

select * from job_grades;

#######################################################################################
# Q-14) Display the last name, salary, and corresponding grade:

SELECT e.ename AS "Last Name", e.sal AS "Salary", jg.grade AS "Grade"
FROM employee e
JOIN job_grades jg ON e.sal BETWEEN jg.lowest_sal AND jg.highest_sal;


#######################################################################################
# Q-15) Display the Emp name and the Manager name under whom the Employee works in the below format:

SELECT e.ename AS "Empname", m.ename AS "Manager Name"
FROM employee e
JOIN employee m ON e.mgr = m.empno;

#######################################################################################
# Q-16) Display Empname and Total sal where Total Sal (sal + Comm):

SELECT ename AS "Empname", sal + COALESCE(comm, 0) AS "Total Sal"
FROM employee;


#######################################################################################
# Q-17) Display Empname and Sal whose empno is an odd number:

SELECT ename AS "Empname", sal
FROM employee
WHERE MOD(empno, 2) = 1;


#######################################################################################
# Q-18) Display Empname, Rank of sal in the Organization, Rank of Sal in their department:

SELECT ename AS "Empname",
       RANK() OVER (ORDER BY sal DESC) AS "Rank in Organization",
       RANK() OVER (PARTITION BY deptno ORDER BY sal DESC) AS "Rank in Department"
FROM employee;


#######################################################################################
# Q-19) Display the Top 3 Empnames based on their Salary:

SELECT ename AS "Empname"
FROM employee
ORDER BY sal DESC
LIMIT 3;


#######################################################################################
# Q-20) Display Empname who has the highest Salary in Each Department:

SELECT d.dname, e.ename AS "Empname",sal
FROM employee e
JOIN dept d ON e.deptno = d.deptno
WHERE (e.deptno, e.sal) IN (
  SELECT deptno, MAX(sal)
  FROM employee
  GROUP BY deptno
);

