--Use ITI DB
--1. Write a query to select the highest two salaries in Each
--Department for instructors who have salaries. “Using one of
--Ranking Functions”
--2. Write a query to select a random student from each department.
--“Using one of Ranking Functions”

--1
select *
from (
select I.Ins_Name,I.Dept_Id,I.Salary,DENSE_RANK() over(PARTITION by Dept_Id order by Salary desc) as [Salary Rank]
from Instructor I where Salary is not null) as NewTable
where [Salary Rank] <= 2
--2
select *
from (
select *,Row_Number() over(PARTITION by Dept_Id order by newId()) as [Random Rank]
from Student S where Dept_Id is not null) as NewTable
where [Random Rank] = 1

--1. Top N Students per Department by Total Grade
--2. Rank Courses by Average Grade in Each Topic
--3. Ntile: Divide Students into 4 Quartiles Based on Total Grades
--4. Dense Rank Instructors by Salary in Each Department
--5. Get the Second Highest Grade in Each Course
--6. Top Course by Instructor Evaluation
--7. Rank Departments by Average Instructor Salary
--8. Assign Row Numbers to Students Ordered by Age in Each Department
--9. Courses by Duration Percentile Using NTILE
--10.Top 2 Students in Each Course Based on Grade

--1. Top N Students per Department by Total Grade
Select *
from(
select S.St_Id,Concat(S.St_Fname,' ',S.St_Lname) as Name,s.Dept_Id,Sum(SC.Grade)as TotalGrade,DENSE_RANK() over(PARTITION by Dept_Id order by Sum(SC.Grade)) as R
from Student S join Stud_Course SC 
on S.St_Id = SC.St_Id
group by S.St_Id,S.St_Fname,S.St_Lname,s.Dept_Id) as NewTable
where R <=2


--2. Rank Courses by Average Grade in Each Topic
select  T.Top_Name, C.Crs_Name ,Avg(SC.Grade) as AvgGrade,DENSE_RANK() over(PARTITION by T.Top_Name order by AVG(SC.Grade)) as [Grade Rank]
from Student S join Stud_Course SC 
on S.St_Id = SC.St_Id
join Course C 
on C.Crs_Id = SC.Crs_Id
join Topic T
on T.Top_Id = C.Top_Id
group by C.Crs_Name,T.Top_Name

--3. Ntile: Divide Students into 4 Quartiles Based on Total Grades
select Concat(S.St_Fname,' ',S.St_Lname) as Name,Sum(SC.Grade)as TotalGrade,NTILE(4) over(order by Sum(SC.Grade) desc )as G
from Student S join Stud_Course SC 
on S.St_Id = SC.St_Id
group by S.St_Fname,S.St_Lname

--4. Dense Rank Instructors by Salary in Each Department
select I.Ins_Id,I.Ins_Name,I.Dept_Id,I.Salary,DENSE_RANK() over(PARTITION by Dept_Id order by Salary desc) as R
from Instructor I 
where Salary is not null

--5. Get the Second Highest Grade in Each Course
select * 
from(
select C.Crs_Id,C.Crs_Name,SC.Grade,DENSE_RANK() over(PARTITION by C.Crs_Name order by SC.Grade desc) as R
from Student S join Stud_Course SC
on S.St_Id = SC.St_Id
join Course C
on SC.Crs_Id = C.Crs_Id ) as Ranked
where R =2

--6. Top Course by Instructor Evaluation
--???

--7. Rank Departments by Average Instructor Salary
select I.Dept_Id,AVG(I.Salary) as AVGSalary,DENSE_RANK() over (order by AVG(I.Salary) desc ) as SalaryRank
from Instructor I 
WHERE Salary IS NOT NULL
group by I.Dept_Id

--8. Assign Row Numbers to Students Ordered by Age in Each Department
select S.St_Id,Concat(S.St_Fname,' ',S.St_Lname) as Name,S.Dept_Id,ROW_NUMBER() over (PARTITION by S.Dept_Id order by St_Age desc) as RankedAge
from Student S
Where S.Dept_Id is not null


--9. Courses by Duration Percentile Using NTILE
Select C.Crs_Name ,C.Crs_Duration,NTILE(4) Over (order By C.Crs_Duration desc) as RankedDuration
from Course C 

--10.Top 2 Students in Each Course Based on Grade
select *
from(
select S.St_Id,Concat(S.St_Fname,' ',S.St_Lname) as Name,C.Crs_Name, SC.Grade ,DENSE_RANK() over (PARTITION by C.Crs_Name order by SC.Grade desc) as R
from Student S join Stud_Course SC
on S.St_Id = SC.St_Id 
join Course C 
on C.Crs_Id= SC.Crs_Id ) as NewTable
where R <=2