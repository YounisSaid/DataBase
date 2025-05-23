Create Database Sales_OfficeDB
Go

use Sales_OfficeDB
Go

CREATE TABLE Sales_Office(
 Number int Primary Key identity(1,1),
 Location nvarchar(200) not null,
 Emp_ID int 
 )
 Go

CREATE TABLE Employee(
 ID int Primary Key identity(1,1),
 Name nvarchar(100) not null,
 Off_Number int  references  Sales_Office(Number)
 )
Go

Alter TABLE Sales_Office
ADD CONSTRAINT FK_EMPID foreign KEY (Emp_ID) references Employee(ID)
Go

CREATE TABLE Property(
 ID int Primary Key identity(1,1),
Address nvarchar(100) not null,
City nvarchar(20) not null,
State nvarchar(20) not null,
Code nvarchar(20) not null,
 Off_Number int  references  Sales_Office(Number)
)
Go

CREATE TABLE Owner(
 ID int Primary Key identity(1,1),
 Name nvarchar(50) not null
 )
 Go

CREATE TABLE Property_Owner(
 Own_ID int not null references Owner(ID),
 Prop_ID int not null references Property(ID),
 Percentage dec(5,4) not null
 Primary Key(Own_ID,Prop_ID)
 )
 Go









