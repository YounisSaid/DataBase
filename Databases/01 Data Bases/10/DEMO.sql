--Index
--By Binary Search --Log n
--Faster in search more than Insert or delete or update
--By default Clustred Index is created on Primary Key
--It consumes Storage 

--Clustred Index
--Store Data Phscaially ordered by Clustred Index
--Only one at A Table

Create Clustered index In_Name
-- on Student (St_Fname) --Invalid


--Non Clustered
Create nonClustered index In_Name
 on Student (St_Fname) 

Create Table Test2
(
  X int Primary Key,
  Y int Unique,
  Z int Foreign Key references Student(St_ID)
)

Create Unique index In_Student_Age
--on Student (St_Age) -- invalid Cause Age is not Unique

Create Unique index In_Dept_Name
on  Department (Dept_Name) 

----------indexed View(Matrarlized View)-------------
--Stored Data Physcailly
--Unique Clustred index
--More Storage
Alter View CommentsView
with SchemaBinding
as
   Select PostId,COUNT_BIG(*) as TotalComments,sum(Score) as TotalScore
   from dbo.Comments
   group By PostId

select * from  CommentsView
 where PostId = 341166

Create Unique Clustered index IX_PostComments
on CommentsView(PostId)

Alter Table Comments
--drop column Score --Invalid Cause of SchemaBinding

-------------------TCL---------
--implict Transcation --insert Update

--explicit Transcation
Create Table Parent1
(
 Id int Primary Key
)

Create Table Child
(
 Id int,
 ParentId int Foreign Key references Parent1(Id)
)

Begin Try
  Begin Transaction
    insert into Child Values(1,1)
    insert into Child Values(2,2)
    insert into Child Values(3,5)
    insert into Child Values(4,4)
  Commit Transaction
End Try

Begin Catch
  Rollback Transaction
End Catch

select * from Child
delete from Child

Begin Try
  Begin Transaction
    insert into Child Values(1,1)
    insert into Child Values(2,2)
	Save Transaction P01
    insert into Child Values(3,5)
    insert into Child Values(4,4)
    insert into Child Values(5,5)

  Commit Transaction
End Try

Begin Catch
  Rollback Transaction P01
End Catch
