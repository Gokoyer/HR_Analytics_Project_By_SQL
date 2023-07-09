--This is to perform the Data wrangling and Cleaning, and transforming the dataset
SELECT *
FROM [dbo].[HRM_data]

--Going through the records with NULL values
SELECT *
FROM HRM_data
WHERE EmpID is NULL
   OR DeptID is NULL
   OR Salary is NULL
   OR Position is NULL
   OR DOB is NULL
   OR Gender is NULL
   OR RaceDesc is NULL
   OR TermReason is NULL
   OR EmploymentStatus is NULL
   OR Department is NULL
   OR ManagerName is NULL
   OR RecruitmentSource is NULL 
   OR PerformanceScore is NULL
   OR EngagementSurvey is NULL
   OR EmpSatisfaction is NULL
   OR SpecialProjectsCount is NULL
   OR Absences is NULL

/*
Out of the 311 rows, there are 257s rowns that have NULL has Date of Hire and Date of termination
I have to just delete these 2 columns alone
*/

ALTER TABLE [dbo].[HRM_data]
DROP COLUMN DateofHire, DateofTermination

--Wrangling the Date of Birth(DOB) column
SELECT CAST(DOB AS date) AS DOB
FROM HRM_data

UPDATE HRM_data
SET DOB = CAST(DOB AS DATE)

--Wrangling the TermReason(Reasons for leaving)
SELECT DISTINCT TermReason
FROM HRM_data  

UPDATE HRM_data
SET TermReason = REPLACE(REPLACE(REPLACE(TermReason, 'N/A-StillEmployed', 'Still-Employed'), 'return to School', 'School-Return'),
'Another position', 'Another Position')
FROM HRM_data
  

--Wrangling TermReason, changing other values from from irregular cases to Proper case
UPDATE HRM_data
SET TermReason = UPPER(LEFT(TermReason, 1)) + SUBSTRING(TermReason, 2, LEN(TermReason))
FROM HRM_data

/*ALTERNATIVELY
SELECT CONCAT(UPPER(SUBSTRING(TermReason, 1, 1)), LOWER(SUBSTRING(TermReason, 2, LEN(TermReason)))) AS 'TermReason'
FROM HRM_data

UPDATE HRM_data
SET TermReason = CONCAT(UPPER(SUBSTRING(TermReason, 1, 1)), LOWER(SUBSTRING(TermReason, 2, LEN(TermReason)))) AS 'TermReason'
*/
-------------------------------------------------------------------------------------------------------------------------------
--To extract Year from Employees' Date of Birth(DOB) and Add A Column for year of Birth(YOB)
SELECT SUBSTRING(DOB, 1, 4) AS YearOfBirth
FROM HRM_data

UPDATE HRM_data
SET YearOfBirth = SUBSTRING(DOB, 1, 4)

--Rename the column Sex to Gender
sp_rename 'HRM_data.Sex', 'Gender', 'COLUMN'


--Delete unwanted observations
ALTER TABLE HRM_data
DROP COLUMN MarriedID, MaritalStatusID, GenderID, PerfScoreID, FromDiversityJobFairID, Termd, PositionID, State, Zip,
   CitizenDesc, HispanicLatino, ManagerID, LastPerformanceReview_Date, DaysLateLast30


SELECT MAX(YearOfBirth)
FROM [dbo].[HRM_data]
-- The youngest worker was born in 1992

SELECT MIN(YearOfBirth)
FROM [dbo].[HRM_data]
--The oldest worker was born in 1951

--Categorized age brackets
SELECT YearOfBirth, CASE
   WHEN YearOfBirth <= 1962 THEN 'Senior Worker'
   WHEN YearOfBirth >= 1963 AND YearOfBIrth <= 1983 THEN 'Middle-Age Worker'
   WHEN YearOfBirth >= 1984 AND YearOfBirth <= 1992 THEN 'Adult Worker'
ELSE YearOfBirth 
END AS AgeCategory
FROM [dbo].[HRM_data] 

ALTER TABLE [dbo].[HRM_data]
ADD AgeCategory varchar(30)

UPDATE [dbo].[HRM_data]
SET AgeCategory = (CASE
   WHEN YearOfBirth <= 1962 THEN 'Senior Worker'
   WHEN YearOfBirth >= 1963 AND YearOfBIrth <= 1983 THEN 'Middle_Age Worker'
   WHEN YearOfBirth >= 1984 AND YearOfBirth <= 1992 THEN 'Adult Worker'
ELSE NULL
END)





