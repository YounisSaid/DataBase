
--Part 01
--● Restore MyCompany Database and then:
--1. Try to create the following Queries:
--1. Display the employee First name, last name, Salary and Department number.
--2. Display all the projects names, locations and the department which is responsible for it.
--3. Display the employees Id, name who earns more than 1000 LE monthly.
--4. Display each department id, name which is managed by a manager with id equals 968574.
--5. Display the ids, names and locations of the projects which are controlled with department 10.


use MyCompany
Go;
-- 1
select Fname,Lname,Salary,Dno
from Employee
--2
select P.Pname ,P.Plocation,D.Dname
from Project P join Departments D
on D.Dnum = P.Dnum
--3
select SSN , Fname + ' ' + Lname as Name ,Salary
from Employee 
where Salary > 1000
--4
select Dnum ,Dname,MGRSSN as MangerID
from Departments 
where  MGRSSN = 968574
--5
select Pnumber,Pname,Plocation,Dnum
from Project
where Dnum = 10



--Part 02
--⮚ Restore ITI Database and then:
--1. Get all instructors Names without repetition.
--2. Display instructor Name and Department Name Note: display all the instructors if they are attached to a department or not.
--3. Display student full name and the name of the course he is taking for only courses which have a grade.
--4. Select Student first name and the data of his supervisor.
--5. Display student with the following Format.
--Student ID
--Student Full Name
--Department name
--P02
Use ITI
Go;
--1
select DISTINCT Ins_Name
from Instructor
--2
select I.Ins_Name ,D.Dept_Name
from Instructor I left join Department D
on I.Dept_Id = D.Dept_Id
--3
select S.St_Fname + ' ' + S.St_Lname as FullName , C.Crs_Name
from Student S join Stud_Course SC
on S.St_Id = SC.St_Id
join Course C 
on C.Crs_Id = SC.Crs_Id
--4
select S.St_Fname,I.Ins_Name
from Student S join Instructor I
on S.St_super = I.Ins_Id
--5
select S.St_Id as 'Student ID',S.St_Fname + ' ' + S.St_Lname as 'Student Full Name',D.Dept_Name as 'Departement Name'
from Student S join Department D
on S.Dept_Id = D.Dept_Id


--Part 03
--⮚ Using MyCompany Database and try to create the following Queries:
--1. Display the Department id, name and id and the name of its manager.
--2. Display the name of the departments and the name of the projects under its control.
--3. Display the Id, name, and location of the projects in Cairo or Alex city.
--4. Display the Projects full data of the projects with a name starting with "a" letter.
--5. display all the employees in department 30 whose salary from 1000 to 2000 LE monthly
--6. Retrieve the names of all employees in department 10 who work more than or equal 10 hours per week on the "AL Rabwah" project.
--7. Find the names of the employees who were directly supervised by Kamel Mohamed
--8. Display All Data of the managers
--9. Retrieve the names of all employees and the names of the projects they are working on, sorted by the project name.

--P03
Use MyCompany
Go;
--1
select Dnum,Dname,MGRSSN as MangerID , Employee.Fname + ' ' + Employee.Lname as MangerName
from Departments join Employee 
on Departments.MGRSSN = Employee.SSN
--2
select D.Dname ,P.Pname
from Departments D join Project P 
on D.Dnum = P.Dnum
--3
select Pnumber,Pname,Plocation
from Project
where Plocation in ('Cairo','Alex')
--4
select *
from Project 
where Pname like 'a%'
--5
select *
from Employee
where Employee.Dno = 30 and Salary between 1000 and 2000
--6
select E.Fname + ' '+E.Lname as Name ,E.Dno,P.Pname
from Employee E join Works_for W
on E.SSN = W.ESSn
join Project P
on P.Pnumber = W.Pno
where E.Dno = 10 and P.Pname = 'AL Rabwah'
--7
select E.Fname + ' '+E.Lname as Name ,E.Superssn as SuperID , S.Fname + ' '+S.Lname as SuperName
from Employee E join Employee S 
on E.Superssn = S.SSN
where S.Fname + ' '+S.Lname like 'Kamel M[oa]hamed'
--8
select distinct S.Fname + ' '+S.Lname as SuperName ,S.SSN,S.Bdate,S.Address,S.Sex,S.Salary
from Employee E join Employee S 
on E.Superssn = S.SSN
--9
select E.Fname + ' '+E.Lname as Name ,P.Pname
from Employee E join Works_for W
on E.SSN = W.ESSn
join Project P
on P.Pnumber = W.Pno



--Part 04
--Use MyCompany DB
--1. Try to update all salaries of employees who work in Project ‘Al Rabwah’ by 30%
--2. In the department table insert a new department called "DEPT IT”, with id 100, employee with SSN = 112233 as a manager for this department. The start date for this manager is '1-11-2006'.
--3. Do what is required if you know that: Mrs. noha Mohamed (SSN=968574) moved to be the manager of the new department (id = 100), and they give you (your SSN =102672) her position (Dept. 20 manager)
--a. First try to update her record in the department table.
--b. Update your record to be department 20 manager.
--P04

--1
update E
set E.Salary = E.Salary * 1.3
from Employee E
join Works_for W
on E.SSN = W.ESSn
join Project P
on P.Pnumber = W.Pno
WHERE P.Pname = 'AL Rabwah';
--2
insert into Departments 
values('DEPT IT',100,112233,'1-11-2006')
--3

--1
update Departments
set MGRSSN = 968574
where Dnum =100
--2
update Departments
set MGRSSN = 102672
where Dnum =20

