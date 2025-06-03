----------------------View-------------------------------------------------
----------------------Virtual Table => SQL Query---------------------------
--Very Fast --Hides Complexity -- More Secure (permissions and Column Name) --Simple
--Pre Compiled  (Syntax-MetaData-Execution Order) --Cashed
---------------------------------
--Note
--Exxecution Plan (Syntax-MetaData-Execution Order-Execute in Memory)
---------------------------------

--------------Standard View (Single View) =>Built in one Table----------

Create View CairoStudentNames
as
   Select S.St_Id,S.St_Fname,S.St_Address
   from Student S
   Where St_Address = 'Cairo'
--Order by Invaild Here

select * from CairoStudentNames


Create View AlexStudentNames
as
   Select *
   from Student
   Where St_Address = 'Cairo'

select * from AlexStudentNames

-- View With Top
Create View TopCairoStudentNames
as
   Select top 2 *
   from Student
   Where St_Address = 'Cairo'
  Order by St_Age --Vaild With Top Specail Case

select * from TopCairoStudentNames

------------------Complex View(join) --------------
Alter View DepartementStudentView(StID,StName,DeptID,DeptName)
with Encryption
as
   Select S.St_Id,S.St_Fname ,D.Dept_Id,D.Dept_Name
   from Student S join Department D
   on S.Dept_Id = D.Dept_Id

Select * from DepartementStudentView
-------------------Partionoted View (More than one Select)-------------
Alter View CairoAlexStudent
with Encryption
as
select * from CairoStudentNames
union 
Select * from AlexStudentNames


sp_helpText 'CairoAlexStudent'

----------------------View + DML----------------------
---Insert 
insert into CairoStudentNames
values (3000,'SAMY','Cairo')


--Insert Student with departement
Alter View DepartementStudentView(StID,StName,DeptID,DeptName)
with Encryption
as
   Select S.St_Id,S.St_Fname ,S.Dept_Id,D.Dept_Name
   from Student S join Department D
   on S.Dept_Id = D.Dept_Id


insert into DepartementStudentView(StID,StName,DeptID)
values (3002,'Younis',10)
--Insert Student with  No departement
insert into DepartementStudentView(StID,StName)
values (3003,'Younis')


--Insert  departement Only
Alter View DepartementStudentView(StID,StName,DeptID,DeptName)
with Encryption
as
   Select S.St_Id,S.St_Fname ,D.Dept_Id,D.Dept_Name
   from Student S join Department D
   on S.Dept_Id = D.Dept_Id

insert into DepartementStudentView(DeptID,DeptName)
values (32,'FR')



-------------UPdate-------------
Update CairoStudentNames
set St_Fname = 'Ali'
where St_Id =2

Update DepartementStudentView
set StName = 'Ahmed'
where StId =2 -- Vaild if the modification is in one table
--where StId =2 and DeptName ='LB' --IN Vaild Cause the modification is more than one table

---------Delete--------
Delete from CairoStudentNames
where St_Id =2

Delete from DepartementStudentView
--where StId =2 --IN Vaild Cause the modification is more than one table
-----------------------------------

--Views With Check Option
Alter View CairoStudentNames
as
   Select S.St_Id,S.St_Fname,S.St_Address
   from Student S
   Where St_Address = 'Cairo'
   with Check option

insert into CairoStudentNames
values (3009,'SAMY','Alex') --Invaild Cause of Check Option --Update is The same

---------------------------Stored Procudre-------------
------------Pros---------
--Pre Compiled -- Fast --Secure 
--Can Write DDL,DML,Handling Errors(Try--Catch)
--Allow Transcations
--Take Input and outPut parameters
--Permisions 
--Network Tarfic when number Of Words Decreased It will be faster
----------Cons----------
--Syntax belongs to Server only so you cannot Debug On sql server only
--No Version Control [git]
---------When to use--------
--Frequent Query
--Complex Query


------BuiltIn---
sp_Help 'Student' --Info about structure of table
sp_HelpText 'Student' --Query

----UserDefined----
Create Proc Sp_GetStudentById(@Id int)
as
  Select *
  from Student 
  Where St_Id = @Id

--To Call 
Sp_GetStudentById 1
exec Sp_GetStudentById 1
execute Sp_GetStudentById 1


----Insert Based On Execute
Alter proc Sp_GetStudentByAddress @Address nvarchar(50)
With encryption 
as
 Select St_Id,St_Fname,St_Address
 from Student
 where St_Address = @Address

Create Table StudentWithAddress
(
   StId int Primary Key,
   StName nvarchar(55),
   StAddress nvarchar(55)

)

insert into StudentWithAddress
EXEC
Sp_GetStudentByAddress'Cairo'

----SP ERROR HANDLING ----
Create Proc Sp_DeleteTopicById @ID int
as
    Set NoCount On 
  Begin Try
   Delete From Topic 
   where Top_Id = @ID
  End Try

  Begin Catch 
   Print 'ERROR!!'
  END Catch 

Sp_DeleteTopicById 1

----------Input Parameter-----
Alter Proc Sp_SumTwoNumbers @X int =10 ,@Y int =20
as
  Print @X + @Y

Sp_SumTwoNumbers 1,2 -- Passing Parameter by order/Postion
Sp_SumTwoNumbers @Y = 1,@X =2  -- Passing Parameter by Name
Sp_SumTwoNumbers  -- Passing Parameter by Default value

------OutPut Parameter--------
Create proc Sp_GetNameAndAgeByID @id int , @Name varchar(20) Output,@Age int Output
as
 select @Name = St_Fname ,@Age = St_Age
 from Student
 where St_Id = @id

Declare @name nvarchar(20) ,@Age int  
exec Sp_GetNameAndAgeByID 1, @name output , @Age output
Print @Name 
Print @Age 

------Function Vs View Vs Stored Procudre---------
--Function 
--Returns Single Value or Table
--Takes Parameter
--Select ,Insert Based on select
--No Data Modification
--No Transcations
--No Need For Error Handaling
--Preformance is good
--Can Select from view But Not From SP

--View
--Returns Only Table
--No Parameter
--Select
--No Data Modification
--No Transcations
--No Need For Error Handaling
--Preformance is high 
--cannot Select From View or SP

--Stored Procudre
--Can return Table Or Not
--Takes Parameter
--Select + DML + Insert Based on select
--Data Modification
--Has Transcations
--Error Handaling
--Highest Preformance
--Can select From Both

