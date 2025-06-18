--Triggers 
--- Trigger for Grade Check
--   Create an AFTER INSERT or UPDATE trigger on the Stud_Course table that prevents inserting or updating a grade that is not
--   between 0 and 100. If attempted, raise an error.

Alter Trigger GradeCheck  
on Stud_Course  
After Insert,Update  
as  
  If  Exists(Select 1 from inserted  
             Where Grade not between 0 and 100)  
    Begin   
    Print'Error'  
    RollBack  
    End  



--- Trigger for Instructor Salary Log
--   Create a FOR UPDATE trigger on the Instructor table to log changes in salary into a separate audit table   
--  InstructorSalaryLog with the fields: Ins_Id, OldSalary, NewSalary, ChangeDate.

CREATE TABLE InstrctorsalaryLog
(
  Ins_Id int ,
  OldSalary int,
  NewSalary int,
  ChangeDate Date
)
create trigger logchangesoninstructortable  
on instructor  
for update  
as  
begin  
    insert into instructorsalarylog (ins_id, oldsalary, newsalary, changedate)  
    select 
        d.ins_id, 
        d.ins_salary as oldsalary, 
        i.ins_salary as newsalary, 
        getdate()  
    from deleted d
    join inserted i on d.ins_id = i.ins_id;
end




--Stored Procedures 
--- Procedure to Assign Student to Course
--   Write a stored procedure AssignStudentToCourse that takes @StId, @CrsId, and @Grade as parameters and inserts into 
--   Stud_Course. Before insertion, it should check if the student already has that course.

Alter Proc AssignStudentToCourse @StId int, @CrsId int ,@Grade int
as
  if not exists(select 1 from Stud_Course 
             Where St_Id = @StId AND Crs_Id = @CrsId )
		Begin
			 insert into Stud_Course Values(@StId,@CrsId,@Grade)
		End




--- Procedure to List Instructors with Evaluation Above a Value
--   Create a procedure GetTopInstructors that accepts a course ID and minimum evaluation value, and returns all instructors
--   who teach that course and have an evaluation higher than the given value (from Ins_Course).
--??Eval nvarchar??



--Views 
--- View of Student Performance
--   Create a view vw_StudentPerformance that lists each student with their full name, department name, course name, and grade.
Create view vw_StudentPerformance
as
  select CONCAT_WS(' ',(S.St_Fname),(S.St_Lname)) as FullName,D.Dept_Name,C.Crs_Name,SC.Grade
  from Student S join Department D
  on S.Dept_Id = D.Dept_Id
  join Stud_Course SC
  on SC.St_Id = S.St_Id
  join Course C
  on SC.Crs_Id = C.Crs_Id

select * from vw_StudentPerformance



--- View of Department Overview
--   Create a view vw_DepartmentOverview that shows each department with the number of instructors and students assigned to it.
Alter view vw_departmentoverview as
with instructorcounts as (
    select dept_id, count(*) as numofinstructors
    from instructor
    group by dept_id
),
studentcounts as (
    select dept_id, count(*) as numofstudents
    from student
    group by dept_id
)
select 
    d.dept_id,
    d.dept_name,
    isnull(i.numofinstructors, 0) as numofinstructors,
    isnull(s.numofstudents, 0) as numofstudents
from department d
left join instructorcounts i on d.dept_id = i.dept_id
left join studentcounts s on d.dept_id = s.dept_id;


select * from vw_departmentoverview


--Functions
--- Scalar Function to Get Full Name
--   Write a scalar function fn_GetStudentFullName(@StId) that returns the full name of a student as Fname + ' ' + Lname.

Create Function fn_GetStudentFullName(@StId int)
returns Nvarchar(100)
as
   Begin
    Declare @FullName Nvarchar(100)
    select @FullName =  CONCAT_WS(' ',(S.St_Fname),(S.St_Lname))
	from Student S
	return @FullName
   End
--- Table-Valued Function to Get Courses by Topic
--   Create an inline table-valued function fn_GetCoursesByTopic(@TopId) that returns the list of course names and durations 
--   under a specific topic.

Alter Function fn_GetCoursesByTopic(@TopId int)
returns Table
as
 return
 (
   select T.Top_Name,C.Crs_Name,C.Crs_Duration
   from Course C join Topic T
   on C.Top_Id = T.Top_Id
   where T.Top_Id = @TopId
 )

select * from fn_GetCoursesByTopic(1)