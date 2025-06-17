--Part 01

--Use ITI DB :
-- Create an index on column (Hiredate) that allows you to cluster the data in table Department.
--What will happen?

-- Create an index that allows you to enter unique ages in the student table. What will happen?

-- Try to Create Login Named(RouteStudent) who can access Only student and Course tables from
--ITI DB then allow him to select and insert data into tables and deny Delete and update

--Part 02

--● Try to Create Login With Your Name And give yourself access Only to Employee and Floor tables
--then allow this login to select and insert data into tables and deny Delete and update (Don't Forget To
--take screenshot to every step)


--Part 01

--Use ITI DB :
-- Create an index on column (Hiredate) that allows you to cluster the data in table Department.
--What will happen?

Create nonClustered index In_Dept
on Department(Manager_hiredate)
--A table will be added Physcailly in the data base that is sorted with Manager_hiredate and searched by Binary Search 
--If you want aclusterd one you should drop The clusterd one First



-- Create an index that allows you to enter unique ages in the student table. What will happen?
Create Unique index In_Student_Age
--on Student (St_Age) -- invalid Cause Age is not Unique and has Duplicates if not it will not allow duplicates in the future



