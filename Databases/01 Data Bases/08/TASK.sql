--P01 Views
--Note : # means number and for example d2 means department which has id or number 2
--Use ITI DB:
--1. Create a view that displays the student's full name, course name if the student has a grade more than 50.
--2. Create an Encrypted view that displays manager names and the topics they teach.
--3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
--4. Create a view “V1” that displays student data for students who live in Alex or Cairo.
--Note: Prevent the users to run the following query
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

--P01 Views
--1. Create a view that displays the student's full name, course name if the student has a grade more than 50.
Create View StudCourseView
as
 Select CONCAT_WS(' ',S.St_Fname,S.St_Lname)as FullName,C.Crs_Name,SC.Grade
 from Student S join Stud_Course SC
 on S.St_Id= SC.St_Id
 join Course C 
 on C.Crs_Id= SC.Crs_Id
 where Grade >50

 select * from StudCourseView

--2. Create an Encrypted view that displays manager names and the topics they teach.
 Alter View MangerTopicsView
 with Encryption
 as
  Select I.Ins_Id,I.Ins_Name,T.Top_Id,T.Top_Name
  from Instructor I join Ins_Course IC
  on I.Ins_Id = IC.Ins_Id
  join Course C 
  on C.Crs_Id = IC.Crs_Id
  join Topic T
  on T.Top_Id = C.Top_Id


select * from MangerTopicsView

--3. Create a view that will display Instructor Name, Department Name for the ‘SD’ or ‘Java’ Department “use Schema binding” and describe what is the meaning of Schema Binding
--Schema Binding => Prevent changes To the tables that whould Break The View

Create View dbo.InstoctorDeptView
with SchemaBinding
as
  select I.Ins_Id ,I.Ins_Name,D.Dept_Name
  from dbo.Instructor I join dbo.Department D
  on I.Dept_Id = D.Dept_Id
  where D.Dept_Name IN ('SD','Java')

select * from InstoctorDeptView
alter table dbo.Instructor drop column Ins_Name --Error 


--4. Create a view “V1” that displays student data for students who live in Alex or Cairo.
--Note: Prevent the users to run the following query
--Update V1 set st_address=’tanta’
--Where st_address=’alex’;

Create View V1
as
  select *
  from Student S
  Where S.St_Address in ('Alex','Cairo')
  with Check Option 



--use IKEA_Company_DB:
--1. Create view named “v_count “ that will display the project name and the Number of jobs in it
--2. modify the view named “v_without_budget” to display all DATA in project p1 and p2.
--3. Delete the view “v_count”
--4. Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
--5. Create view named “v_dept” that will display the department# and department name
--6. Create view name “v_2006_check” that will display employee Number, the project Number where he works and the date of joining the project which must be from the first of January and the last of December 2006.this view will be used to insert data so make sure that the coming new data must match the condition



--1. Create view named “v_count “ that will display the project name and the Number of jobs in it
Create View v_Count
as
  Select P.ProjectNo ,P.ProjectName,Count(W.Job) as jobCount
  from HR.Project P join Works_on W
  on W.ProjectNo = P.ProjectNo
  group By P.ProjectNo ,P.ProjectName

select * from v_Count

--2. modify the view named “v_without_budget” to display all DATA in project p1 and p2.
Alter View v_without_budget
as
 Select *
 from HR.Project P 
 Where P.ProjectNo in (1,2)

select * from v_without_budget

--3. Delete the view “v_count”
drop view v_Count

--4. Create view that will display the emp# and emp last name who works on deptNumber is ‘d2’
Create view v_EmpsForDeptNO1AND2
as
  Select E.EmpNo,E.EmpFname,E.EmpLname,E.DeptNo
  from HR.Employee E
  where E.DeptNo =2

Select * from v_EmpsForDeptNO1AND2


--5. Create view named “v_dept” that will display the department# and department name
Create view v_dept
as
  Select D.DeptNo,D.DeptName
  from  Department D

Select * from v_dept

--6. Create view name “v_2006_check” that will display employee Number, the project Number where he works and the date of joining the project which must be from the first of January and the last of December 2006.this view will be used to insert data so make sure that the coming new data must match the condition
Alter View v_2006_check
as
  Select E.EmpNo,P.ProjectNo ,P.ProjectName,W.Enter_Date
  from HR.Project P join Works_on W
  on W.ProjectNo = P.ProjectNo
  join HR.Employee E
  on W.EmpNo = E.EmpNo
  where W.Enter_Date between '2006-01-01' AND '2006-12-31'
  with Check Option

select * from v_2006_check


--1. Create a stored procedure to show the number of students per department.[use ITI DB]
--2. Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to the user “'The following employees work for the project 100'” in addition to the first name and last name of each one. [MyCompany DB]
--3. Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]



--1. Create a stored procedure to show the number of students per department.[use ITI DB]
Create Proc Sp_NumOfStudentsPerDepartement 
as
 Select S.Dept_Id,D.Dept_Name,Count(S.Dept_Id)as NumOfStudents
 from Student S join Department D
 on S.Dept_Id = D.Dept_Id
 group by S.Dept_Id,D.Dept_Name

 Sp_NumOfStudentsPerDepartement


--2. Create a stored procedure that will check for the Number of employees in the project 100 if they are more than 3 print message to the user “'The number of employees in the project 100 is 3 or more'” if they are less display a message to the user “'The following employees work for the project 100'” in addition to the first name and last name of each one. [MyCompany DB]
 Create Proc CheckStudentNum
 as 
  Declare @NumOfEmployees int

  select @NumOfEmployees = COUNT(E.SSN)
  from Employee E join Works_for W
  on W.ESSn = E.SSN
  join Project P
  on W.Pno = P.Pnumber
  where P.Pnumber =100

  if @NumOfEmployees > 3
  Print 'The number of employees in the project 100 is 3 or more'

  else 
  Print 'The following employees work for the project 100'
  select E.Fname, E.Lname
        from Employee E
        join Works_for W on W.ESSn = E.SSN
        join Project P on W.Pno = P.Pnumber
        where P.Pnumber = 100;


CheckStudentNum


--3. Create a stored procedure that will be used in case an old employee has left the project and a new one becomes his replacement. The procedure should take 3 parameters (old Emp. number, new Emp. number and the project number) and it will be used to update works_on table. [MyCompany DB]
Create Proc ChangeEmployeeProject(@OldID int ,@NewID int,@PNo int)
as
  Update Works_for 
  Set Works_for.ESSn = @NewID
  where ESSn = @OldID and Works_for.Pno = @PNo

 
  ChangeEmployeeProject 112233,512463,100


--1. Create a stored procedure that calculates the sum of a given range of numbers
--2. Create a stored procedure that calculates the area of a circle given its radius
--3. Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')

--1. Create a stored procedure that calculates the sum of a given range of numbers
Alter Proc SumOfRange(@Num1 int , @Num2 int)
as
 Declare @Sum int = 0
 While @Num1 <= @Num2
  Begin
  set @Sum = @Sum + @Num1
  set @Num1 = @Num1 +1
  End

  Print @Sum

SumOfRange 2,5

--2. Create a stored procedure that calculates the area of a circle given its radius
Alter proc AreaOfCircle @R decimal(5,2)
as
 Print PI() * @R * @R

AreaOfCircle 2


--3. Create a stored procedure that determines the maximum, minimum, and average of a given set of numbers ( Note : set of numbers as Numbers = '5, 10, 15, 20, 25')
Alter Proc Operations 
as
 Declare @Table Table (Value int);
 insert into @Table values (5), (10), (15), (20), (25);

 Select MAX(Value) as Max ,MIN(Value) as Min ,AVG(Value) as AVG
  from @Table

  Operations

