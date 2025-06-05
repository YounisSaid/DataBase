--------------Trigger---------------------------
--like Event,Specail Type Of Stored Procudre----
--Triggers Fire when Event Occured On Table | View
--Event(Not Select or Turncate | Not logged in Log File .LDF)
--1.Insert
--2.Update
--3.Delete

------Welcome Trigger On Table Student---------
Create Trigger WelcomeStudentTrigger
on Student 
After insert
as
   Print 'WELCOME TO ROUTE'

INSERT INTO Student (St_Id,St_Fname,St_Address,St_Age)
 VALUES (1001,'Ali','Cairo',20)
 

--Alter Schema Sales
-- transfer WelcomeStudentTrigger --In vaild Cause it is Owned To A Parent By Default

--After Update
Create trigger NotifyOnUpdateStudent
on Student
After Update
as
   Select SUSER_NAME() as UserName ,GetDate() as UpdateDate


create Trigger FNameUpdated
on  Student
After Update  
as 
 if Update(St_Fname)
   Print 'First Name Is Updated'


Update Student
 Set St_Fname = 'Younis'
where St_Id = 2
 
--instead of Delete 
Create Trigger DisableDeleteForStudent
on Student 
instead of Delete
as
   Print 'You Cannot Delete This Student'

--instead of Delete ,insert,Update
Create Trigger DisableDeleteForStudent2
on Student 
instead of Delete ,insert,Update
as
   Print 'You Cannot Delete This Student'


delete from Student

--After Insert
Create Trigger WelcomeStudentTrigger2
on Student 
After insert
as
   Print 'WELCOME TO ROUTE2'

--Drop Trigger
drop Trigger WelcomeStudentTrigger2

--Disable Trigger
Alter Table Student
 Disable Trigger WelcomeStudentTrigger2

--Enable Trigger
Alter Table Student
 Enable Trigger WelcomeStudentTrigger2

 ------------------------------------Inserted And Deleted Tables------------------------------------
 --Created On RunTime
 --insert =>Inserted Table Will Contain Inserted Table
 --Delete =>Deleted Table Will Contain Deleted Table
 --Update =>Inserted Table Will Contain New Data && Deleted Table Will Contain Old Data

 Create Trigger OnCourseUpdated
  on Course
  after Update
 as
   Select * from inserted
   Select * from Deleted 

Update Course
 set Crs_Name = 'JAVA'
where Crs_Id = 800


select * into DeletedCources
 from Course
 where 1 = 2


 Create Trigger OnCourseUpdated2
  on Course
  after Update
 as
   insert into DeletedCources
   Select * from Deleted 

Update Course
 set Crs_Name = 'JAVA'
where Crs_Id = 800

select * from DeletedCources

Create Trigger DisableDeleteTopic
on Topic
Instead of Delete
 as
   select CONCAT_WS(' ','You Cannot Delete The Topic With Id =',(select Top_Id from Deleted),'And Name = >',(select Top_Name from Deleted))

Delete  from Topic 
where Top_Id = 1

-------------------------DDL Triggers--------------------
--Data Base -- Server Scope
--Events[Create-Update-Delete]
--Command Completed Sucssessfully => Default Trigger

-- On Creat DataBase
Create Trigger ModifyOnDataBaseServer
on All Server
for Create_Database
 as
  Print 'Data Base Created Successfully'

Create DataBase Test

-- On Creat Table
Create Trigger CreateTableTrigger
on DataBase
for Create_Table
 as
  Print 'Table Created Successfully'

Create Table Test (value int)

-- On Alter Table
Create Trigger AlterTableTrigger
on DataBase
for Alter_Table
 as
  Print 'Table Modified Successfully'

Alter Table Test
 Add Name nvarchar(50)

-- On Alter Table
Create Trigger AlterOnTableTrigger
on DataBase
for DDL_Table_Events
 as
  Print 'Table Modified Successfully2'

Alter Table Test
 Add Address nvarchar(50)

Create Trigger EventDataOnTableTrigger
on DataBase
for DDL_Table_Events
 as
  select EVENTDATA()

Alter Table Test
 Drop column Address 

Create Trigger DisableAlterTableTrigger
on DataBase
for Alter_Table
 as
  RollBack Transaction
  Print 'You Cannot Modifiy On This Table'

Alter Table Test
 Add Address nvarchar(50)

 ----------------DCL => Data Control Langauge----------
Alter Schema Sales
 Transfer Student

 Update Sales.Student
 Set St_Fname = 'Younis'
 where St_Id = 1