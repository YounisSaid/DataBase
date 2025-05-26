--Restore adventureworks2012 Database Then :
--1. Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
--2. Display all Products with a Silver, Black, or Red Color
--3. Display any Product with a Name starting with the letter B
--4. Display the Employees HireDate (note no repeated values are allowed)
--5. Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
--6. Display ProductID, Name if its weight is unknown

--1. Display only Products(Production schema) with a StandardCost below $110.00 (show ProductID, Name only)
select P.ProductID,P.Name
from Production.Product P
where P.StandardCost <= 110

--2. Display all Products with a Silver, Black, or Red Color
select *
from Production.Product P
where P.Color in('Silver','Black','Red')

--3. Display any Product with a Name starting with the letter B
select P.ProductID,P.Name
from Production.Product P
where P.Name like 'B%'

--4. Display the Employees HireDate (note no repeated values are allowed)
select distinct E.HireDate
from HumanResources.Employee E

--5. Display the Product Name and its ListPrice within the values of 100 and 120 the list should have the following format "The [product name] is only! [List price]" (the list will be sorted according to its ListPrice value)
select P.Name [product name],P.ListPrice[List Price]
from Production.Product P
where P.ListPrice between 100 and 120
order by [List Price] desc

--6. Display ProductID, Name if its weight is unknown
select P.ProductID,P.Name
from Production.Product P
where P.Weight is null




--Use ITI DB:
--1. Create a scalar function that takes a date and returns the Month name of that date.
--2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
--3. Create a table-valued function that takes Student No and returns Department Name with Student full name.

--1. Create a scalar function that takes a date and returns the Month name of that date.
create Function GetTheMonthNameByDate(@Date Date)
returns nvarchar(15)

Begin
Declare @Month nvarchar(15) = DateName(MONTH,@Date)
return @Month
End

select dbo.GetTheMonthNameByDate('5-5-2005')

--2. Create a multi-statements table-valued function that takes 2 integers and returns the values between them.
Create Function GetValuesBetweenTw0Ints(@Int1 int,@Int2 int)
returns @table Table (InsertedValue int)
as
Begin
insert into @table Values(@Int1)
while @Int1 < @Int2
  Begin
 set @Int1 = @Int1 +1
 insert into @table Values(@Int1)
  End
  return

End

select * from GetValuesBetweenTw0Ints(1,20)

--3. Create a table-valued function that takes Student No and returns Department Name with Student full name.
Create Function GetDeptNameAndStudentFullNameByStudentNo(@Stud_ID int)
returns Table
as
return
(
  Select D.Dept_Name,CONCAT_WS(' ',S.St_Fname,S.St_Lname) as FullName
  from Student S join Department D
  on S.Dept_Id = D.Dept_Id
  where S.St_Id = @Stud_ID
)

select * from GetDeptNameAndStudentFullNameByStudentNo(10)




--4.Create a scalar function that takes Student ID and returns a message to user.
--a. If first name and Last name are null, then display 'First name & last name are null.'
--a. If First name is null, then display 'first name is null'
--a. If Last name is null, then display 'last name is null.'
--a. Else display 'First name & last name are not null'
Create Function GetUserMessageByStudentID(@StudentID int)
returns nvarchar(100)
Begin
  Declare @Message nvarchar(100)
  Declare @FName nvarchar(20)
  Declare @LName nvarchar(20)


   select @FName = S.St_Fname , @LName =S.St_Lname
   from Student S
   where S.St_Id = @StudentID

    if(@FName is  null and @LName is  null)
    SET @Message = 'First name & last name are null.'

   ELSE if(@FName is null)
    SET @Message = 'first name is null'
  
   ELSE if(@LName is  null)
    SET @Message = 'last name is null.'
   
   ELSE
    SET @Message = 'First name & last name are not null'
    
RETURN @Message
END

SELECT dbo.GetUserMessageByStudentID(10)


--6. Create function that takes project number and display all employees in this project (Use MyCompany DB)
CREATE FUNCTION GETAllEmployeesByProjectNo(@ProjectNo int)
Returns Table
as
Return
(
 select E.SSN,E.Fname,E.Lname,P.Pnumber,P.Pname
 from Employee E join Works_for W
 on E.SSN= W.ESSn
 join Project P
 on P.Pnumber =W.Pno
 where P.Pnumber =@ProjectNo
)

select * from GETAllEmployeesByProjectNo(100)