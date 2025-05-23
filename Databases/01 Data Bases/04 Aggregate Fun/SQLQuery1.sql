--P01
--Use ITI DB
--1. Display student with the following Format (use isNull function)
--Student ID
--Student Full Name
--Department name
--2. Select instructor name and his salary but if there is no salary display value ‘0000’ . “use one of Null Function”
--3. Select Supervisor first name and the count of students who supervises on them
--4. Display max and min salary for instructors
--5. Select Average Salary for instructors
--6. Display instructors who have salaries less than the average salary of all instructors.
--7. Display the Department name that contains the instructor who receives the minimum salary
--8. Select max two salaries in instructor table.

--1
select S.St_Id [Student ID] , CONCAT_WS(' ',S.St_Fname,S.St_Lname) [Full Name] ,D.Dept_Name [Depertament Name]
from Student S join Department D 
on S.Dept_Id = D.Dept_Id
--2
select I.Ins_Name ,isnull(Salary,'0000') [Salary]
from Instructor I
--3
select I.Ins_Name ,COUNT(*) [Suprvsied Students]
from Instructor I join Student S
on S.St_super = I.Ins_Id
group by I.Ins_Name
--4
select MIN(Salary) [Min Salary], Max(Salary) [Max Salary]
from Instructor
--5
select AVG(Salary) [AVG Salary]
from Instructor
--6
select * 
from Instructor
where Salary < (select AVG(Salary) [AVG Salary]
from Instructor)
--7
select D.Dept_Name 
from Department D join Instructor I
on D.Dept_Id = I.Dept_Id 
where I.Salary = (select MIN(Salary) from Instructor)
--8
select distinct top 2 Salary
from Instructor I
order by Salary desc


--P02
--Part 02
--Use MyCompany DB

--1. For each department, retrieve the department name and the maximum, minimum and average salary of its employees.
--2. Display the data of the department which has the smallest employee ID over all employees' ID.
--3. Try to get the max 2 salaries using subquery.
--1
select D.Dname , MAX(Salary) [Max Salary] , MIN(Salary) [Min Salary] , AVG(Salary) [AVG Salary]
from Departments D join Employee E 
on D.Dnum = E.Dno
group by D.Dname
--2
select D.* 
from Departments D
join Employee E ON D.Dnum = E.Dno
where E.SSN = (select MIN(SSN) from Employee);
--3
select distinct top 2 Salary
from Employee E 
where SSN in (
select  E.SSN
from Employee E
)
order by Salary desc



