--Part 01

--Use ITI DB
--• Create a trigger to prevent anyone from inserting a new record in the
--Department table ( Display a message for user to tell him that he
--can’t insert a new record in that table )
--• Create a table named “StudentAudit”. Its Columns are (Server User
--Name , Date, Note).
--Server UserName Date Note

--Create a trigger on student table after insert to add Row in StudentAudit
--table

--• The Name of User Has Inserted the New Student
--• Date
--• Note that will be like ([username] Insert New Row with Key =
--[Student Id] in table [table name]

--Create a trigger on student table instead of delete to add Row in
--StudentAudit table

--○ The Name of User Has Inserted the New Student
--○ Date
--○ Note that will be like “try to delete Row with id = [Student Id]”




--• Create a trigger to prevent anyone from inserting a new record in the
--Department table ( Display a message for user to tell him that he
--can’t insert a new record in that table )

Create Trigger DisableInsertTrigger
on Department 
instead of insert
as
   Print 'You Can Not Insert in this Table'

insert  into Department (Dept_Id) 
 Values(100)


--• Create a table named “StudentAudit”. Its Columns are (Server User
--Name , Date, Note).
--Server UserName Date Note

Create Table StudentAudit
(
  [Server UserName] nvarchar(Max),
  [Date] Date ,
  [Notes] nvarchar(Max)
)

----Create a trigger on student table after insert to add Row in StudentAudit
----table
--• The Name of User Has Inserted the New Student
--• Date
--• Note that will be like ([username] Insert New Row with Key =
--[Student Id] in table [table name]


Alter trigger OnInsertStudent
on Student
After insert
as
  insert into StudentAudit([Server UserName], [Date] ,[Notes])
  select SUSER_NAME(),GetDate(),CONCAT_WS(' ',(SUSER_NAME() ),'Insert New Row with Key =',(Select St_Id from inserted ),'in table Student')

insert into Student (S.St_Id,S.St_Fname,S.St_Address)
 values (30004,'ALY','Cairo')

select * from StudentAudit


--Create a trigger on student table instead of delete to add Row in
--StudentAudit table

--○ The Name of User Has Inserted the New Student
--○ Date
--○ Note that will be like “try to delete Row with id = [Student Id]”


Alter Trigger OnStudentDeleteTrigger
on Student
Instead of Delete
as
   insert into StudentAudit([Server UserName], [Date] ,[Notes])
  select SUSER_NAME(),GetDate(),CONCAT_WS(' ',(SUSER_NAME() ),'tried to delete Row with id =',(Select St_Id from deleted ))

  Delete from Student 
  where St_Id =2

select * from StudentAudit


--Part 02

--Use MyCompany DB:
--• Create a trigger that prevents the insertion Process for
--Employee table in March.
--Use IKEA_Company:
--• Create an Audit table with the following structure
--ProjectNo UserName ModifiedDate Budget_Old Budget_New
--p2 Dbo 2008-01-31 95000 200000

--This table will be used to audit the update trials on the Budget
--column (Project table, IKEA_Company DB)
--If a user updated the budget column then the project number,
--username that made that update, the date of the modification
--and the value of the old and the new budget will be inserted
--into the Audit table
--(Note: This process will take place only if the user updated the
--budget column)

--Use MyCompany DB:
--• Create a trigger that prevents the insertion Process for
--Employee table in March.

Alter Trigger OnAddEmployeeinMarch
on Employee
for insert
as
  if(MONTH(GETDATE())) = 3
  Begin
   RollBack transaction
   Print 'You Cannot Insert in March'
  End

insert into Employee (SSN) values (1003)


--• Create an Audit table with the following structure
--ProjectNo UserName ModifiedDate Budget_Old Budget_New
--p2 Dbo 2008-01-31 95000 200000

--This table will be used to audit the update trials on the Budget
--column (Project table, IKEA_Company DB)
--If a user updated the budget column then the project number,
--username that made that update, the date of the modification
--and the value of the old and the new budget will be inserted
--into the Audit table
--(Note: This process will take place only if the user updated the
--budget column)


--• Create an Audit table with the following structure
--ProjectNo UserName ModifiedDate Budget_Old Budget_New
--p2 Dbo 2008-01-31 95000 200000

Create Table AduitTable
(
  ProjectNo int,
  UserName  nvarchar(Max),
  ModifiedDate Date,
  Budget_Old money,
  Budget_New money
)


--This table will be used to audit the update trials on the Budget
--column (Project table, IKEA_Company DB)
--If a user updated the budget column then the project number,
--username that made that update, the date of the modification
--and the value of the old and the new budget will be inserted
--into the Audit table
--(Note: This process will take place only if the user updated the
--budget column)

Create trigger OnPudgetUpdated
on HR.Project
After Update
as
  if(UPDATE(Budget))
  insert into AduitTable
  select (Select ProjectNo from deleted),SUSER_NAME(),GETDATE(),(select Budget from deleted),(select Budget from inserted)

select * from HR.Project

Update HR.Project
set Budget = 300
where ProjectNo =1

select * from AduitTable


--Part 03

-- Create a trigger to prevent anyone from Modifying or
--Delete or Insert in the Employee table ( Display a
--message for user to tell him that he can’t take any
--action with this Table).

Create Trigger DisableDMLonEmployee
on HR.Employee
instead of insert , Update , Delete
as
   Print ' You can’t take any action with this Table'

Delete from HR.Employee
where EmpNo =1