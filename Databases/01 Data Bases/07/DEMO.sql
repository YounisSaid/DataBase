----------EXECUTETION ORDER----------
SELECT CONCAT_WS(' ',S.St_Fname,S.St_Lname) as FullName
FROM Student S 
--where FullName = 'AHMED'   -- INVAILD
ORDER BY FullName --VAILD
----------EXECUTETION ORDER----------
--1-FROM
--2-JOIN
--3-ON
--4-WHERE
--5-GROUP BY
--6-HAVING
--7-SELECT
--8-DISTINCT
--9-ORDER BY
--10-TOP
------------------------------------------------------------------------------


---------------UNION FAMILY----------------
--UNION , UNION ALL,INTERSECT,EXCEPT
-------------------------------------------
----UNION FAMILY CONDITIONS
--NUMBER OF SELECTED COLUMNS IN SET1= NUMBER OF SELECTED COLUMNS IN SET2
--CORROSPONDING COLUMNS MUST BE THE SAME TYPE

--UNION
SELECT S.St_Id,S.St_Fname     FROM Student S
 UNION 
SELECT I.Ins_Id,I.Ins_Name      FROM Instructor I
-- UNION REMOVES DUOLICATE DATA
-- IT ORDERS DATA


--UNION ALL
SELECT S.St_Id,S.St_Fname     FROM Student S
 UNION ALL
SELECT I.Ins_Id,I.Ins_Name      FROM Instructor I
-- IT COMBINES THE TWO TABLES


--INTERSECT
SELECT S.St_Id,S.St_Fname     FROM Student S
 INTERSECT
SELECT I.Ins_Id,I.Ins_Name      FROM Instructor I
-- IT GET THE INTERSECTION

--EXCEPT
SELECT S.St_Id,S.St_Fname     FROM Student S
 EXCEPT
SELECT I.Ins_Id,I.Ins_Name      FROM Instructor I
--SET1     SET2
--1 AHMED  1 AHMED 
--ALL ROWS WILL BE GOT EXCEPT 1 AHMED
------------------------------------------------------------------

--------------------SCHEMA----------------------
--dbo =>DEFAULT SCHEMA
SELECT *
FROM ITI02.dbo.Student

CREATE SCHEMA HR

ALTER SCHEMA HR
TRANSFER STUDENT

SELECT * FROM HR.STUDENT

ALTER SCHEMA dbo
TRANSFER HR.STUDENT

Create table HR.Test
 ( id int primary key ,
   Name nvarchar(50)
 )

drop table HR.Test
drop schema HR
-----------------------------------------------------------

----------SELECT INTO-------------
--NO RELATIONS IS COPIED

-- COPY STRUCTURE AND DATA
SELECT * INTO NEWPROJECT
FROM Project

-- COPY STRUCTURE ONLY
SELECT * INTO NEWPROJECT1
FROM Project
WHERE 1=2

--------------------------------------------------------------------------------
------INSERT BASED ON SELECT

------COPY THE DATA ONLY
--SAME TABLE DEFENTION IS A MUST
INSERT INTO NEWPROJECT1
SELECT * FROM Project
--------------------------------------------------------------------------------

---------DELETE VS DROP VS TRUNCATE

-- DROP FOR STRUCTURE
DROP TABLE Project

--DELETE 
DELETE FROM Dependent 
WHERE Dependent.ESSN = 5 -- VAILD
-- NO RESET FOR IDENTITY
-- STORED IN LOG

--TRUNCATE
TRUNCATE TABLE DEPENDENT 
--WHERE Dependent.ESSN = 5 -- IN VAILD
--RESET FOR IDENTITY
-- NOT STORED IN LOG
------------------------------------------------------------------------------------------------


------------DELETE AND UPDATE RULES
---CASE 1
DELETE FROM Student
WHERE Student.Dept_Id =110

DELETE FROM Department
WHERE Department.Dept_Id =110

--CASE2
UPDATE Student
SET Dept_Id =110
WHERE Student.Dept_Id =110

DELETE FROM Department
WHERE Department.Dept_Id =110

--CASE3
UPDATE Student
SET Dept_Id = NULL
WHERE Student.Dept_Id =110

DELETE FROM Department
WHERE Department.Dept_Id =110

--CAN BE DID BY MOUSE -- CANNOT BE IN SELF RELATION
--INSRET AND UPDATE SPECIFICATION
--CASCADE CASE1
--SET DEFAULT CASE2
--NULL CASE3

Create table HR.Test
 ( id int primary key ,
   DEPTID INT references Department(Dept_Id)  ON DELETE CASCADE)
-----------------------------------------------------------------------------------------------------


---------------------USER DEFINED FUNCTION

------------------SCALAR FUNCTION (SINGLE VALUE)
CREATE FUNCTION GETSTUDENTNAMEBYID(@ID INT)
RETURNS VARCHAR(50)

BEGIN 
DECLARE @STUDENETNAME VARCHAR(50)
SELECT @STUDENETNAME = CONCAT_WS(' ',S.St_Fname,S.St_Lname) 
FROM Student S 
WHERE s.St_Id = @ID

RETURN @STUDENETNAME

END

SELECT dbo.GETSTUDENTNAMEBYID(10) [Full Name]


CREATE FUNCTION GetmangerNameBYDepName(@DepName varchar(50))
RETURNS VARCHAR(50)

BEGIN

Declare @MangerName VARCHAR(50)

SELECT @MangerName = E.Fname
FROM Employee E join Departments D
on E.Superssn = D.MGRSSN
where D.Dname = @DepName

Return @MangerName

END

SELECT dbo.GetmangerNameBYDepName('DP1') [MANGER NAME]

DROP FUNCTION GetmangerNameBYDepName



----------INLINE TABLE VALUED FUNCTION--------
CREATE FUNCTION GetInstrctorsByDeptID(@Dept_ID int)
Returns Table
as
   Return
   (
    select * from Instructor
	where Dept_ID = @Dept_ID
   )

select * from GetInstrctorsByDeptID(10)

---------Multi Statement Table Valued Functions
CREATE FUNCTION GetStudentNameBasedOnFormat(@Format nvarchar(50))
Returns  @Table Table ( SSN int PRIMARY KEY , Name nvarchar(50) )
as 
begin
  
  if @Format = 'FIRST'
  INSERT INTO @Table
  SELECT S.St_Id,S.St_Fname
  FROM Student S

  ELSE IF @Format = 'LAST'
  INSERT INTO @Table
  SELECT S.St_Id,S.St_Lname
  FROM Student S

  ELSE IF @Format = 'FULL'
  INSERT INTO @Table
  SELECT S.St_Id,CONCAT_WS(' ',S.St_Fname,S.St_Lname) 
  FROM Student S

  RETURN 
END


SELECT * FROM GetStudentNameBasedOnFormat('FULL')



