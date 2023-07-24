/* SQL Queries on HR Analytics on Dataset From Dr Rich(Kaggle)*/

--To view all the dataset
SELECT *
FROM HR_clean_data

---Total Number of Employees
SELECT 
   COUNT(DISTINCT Employee_Name) AS StaffNumber
FROM HR_clean_data

---Total Number of Employees After Attrition
SELECT 
   (SELECT COUNT(DISTINCT Employee_Name) FROM HR_clean_data) AS StaffNumber,
   COUNT(DISTINCT Employee_Name) AS AfterAttritionStaffNumber
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'

--Average Salary
SELECT 
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   AVG(Salary) AS AvgSalary 
FROM HR_clean_data

---Total Salary
SELECT
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   SUM(Salary) AS TotalSalary 
FROM HR_clean_data

---Total Salary after Attrition
SELECT 
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   SUM(Salary) AS AfterAttritionTotalSalary 
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'

--Total Salary before and after attrition, and Percentage decrease in total salary after attrition
SELECT 
    COUNT(DISTINCT Employee_Name) AS StaffNumber,
	SUM(Salary) AS TotalSalary,
	(SELECT SUM(Salary) FROM HR_clean_data WHERE TermReason = 'Still-Employed') AS AfterAttritionTotalSalary, 
   (((SELECT SUM(Salary) FROM HR_clean_data) - (SELECT SUM(Salary) 
   FROM HR_clean_data WHERE TermReason = 'Still-Employed'))/(SELECT SUM(Salary) FROM HR_clean_data)) * 100 AS ChangeInTotalSalary
FROM HR_clean_data

--Average Salary before and after attrition, and Percentage increase in average salary after attrition
SELECT 
    COUNT(DISTINCT Employee_Name) AS StaffNumber,
    AVG(Salary) AS AvgSalary,
	(SELECT AVG(Salary) FROM HR_clean_data WHERE TermReason = 'Still-Employed') AS AfterAttritionAvgSalary, 
   (((SELECT AVG(Salary) FROM HR_clean_data) - (SELECT AVG(Salary) 
   FROM HR_clean_data WHERE TermReason = 'Still-Employed'))/(SELECT AVG(Salary) FROM HR_clean_data)) * 100 AS ChangeInAvgSalary
FROM HR_clean_data

--Number of Staff before and after Attrition, and number of staff left the company due to various reasons
SELECT 
    COUNT(DISTINCT Employee_Name) AS StaffNumber, 
	(SELECT COUNT(*) FROM HR_clean_data WHERE TermReason = 'Still-Employed') AS AfterAttritionStaffNumber,
	((SELECT COUNT(*) FROM HR_clean_data) - (SELECT COUNT(*) FROM HR_clean_data
	WHERE TermReason = 'Still-Employed')) AS StaffGone
 FROM HR_clean_data

--Total Number of Staff and number of department
SELECT 
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   COUNT(DISTINCT DeptID) AS TotalDept
FROM HR_clean_data

--Number of Staff after attrition, Average Salary After attrition
SELECT 
   COUNT(DISTINCT Employee_Name) AS AfterAttritionStaffNumber,
   AVG(Salary) AS AfterAttritionAvgSalary
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'

--Maximum Salary
SELECT
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   MAX(Salary) AS Max_Salary
FROM HR_clean_data

--Minimum Salary
SELECT
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   MIN(Salary) AS Max_Salary
FROM HR_clean_data

--Average Age
SELECT
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   ROUND(AVG(2023 - YearOfBirth), 0) AS Avg_Age
FROM HR_clean_data

--Average Abseentism
SELECT
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   ROUND(AVG(Absences), 1) AS AvgAbsentDays
FROM HR_clean_data

--Total Abseentism
SELECT
   COUNT(DISTINCT Employee_Name) AS StaffNumber,
   SUM(Absences) AS TotalAbsentDays
FROM HR_clean_data

--Abseentism by Gender
SELECT
   Gender,
   SUM(Absences) AS AbsencesByGender
FROM HR_clean_data
GROUP BY Gender

--Average Abseentism by Gender
SELECT
   Gender,
   AVG(Absences) AS AvgAbsencesByGender
FROM HR_clean_data
GROUP BY Gender

--Abseentism Count by Gender
SELECT
   Gender,
   COUNT(*) AS AbsencesCount
FROM HR_clean_data
GROUP BY Gender

--No of Employees by Gender, by Job Satisfaction and By Special Project Count
SELECT
   Gender,
   COUNT ( DISTINCT Employee_Name) StaffNumberByGender,
   ROUND(AVG(EmpSatisfaction), 2) AS JobSatisfaction,
   ROUND(AVG(SpecialProjectsCount), 2) AS SpecialProjectCounts
FROM HR_clean_data
GROUP BY Gender

/*Senior Executives, Executives and Managers(Number of Employees by Position,
Average Salary by Position and Average Age by Position*/
SELECT TOP 15
   Position,
   COUNT (DISTINCT Employee_Name) AS StaffNumber,
   ROUND(AVG(Salary),0) AS AvgSalary,
   ROUND(AVG(2023 - YearOfBirth), 0) AS AvgAgeByPosition 
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'
GROUP BY Position
HAVING (COUNT (DISTINCT Position)) <= 3
ORDER BY AvgSalary DESC

--Number of Employees by Position, Average Salary by Position and Average Age by Position
SELECT
   Position,
   ROUND(AVG(Salary),0) AS AvgSalary,
   COUNT (DISTINCT Employee_Name) AS StaffNumber,
   ROUND(AVG(2023 - YearOfBirth), 0) AS AvgAgeByPosition
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'
GROUP BY Position
HAVING (COUNT (Position)) >= 2
ORDER BY AvgSalary DESC

/*EmpID, Position, Total Staff Number, Staff by Position, Average Age, Average Age Position, Total Salary,
Average Salary By Position, Total Salary By Position, Job Satisfaction By Position, Special Projects By positions
Abseentism by post, Average Age by Post
*/
SELECT 
   EmpID,
   Position,
   COUNT(*) OVER () AS StaffNumber,
   COUNT(*) OVER (PARTITION BY Position) AS StaffByPost,
   ROUND(AVG(2023 - YearOfBirth) OVER (), 2) AS AvgAge,
   ROUND(AVG(2023 - YearOfBirth) OVER (PARTITION BY Position), 2) AS AvgAgePosition,
   SUM(Salary) OVER () AS TotalSalary,
   ROUND(AVG(Salary) OVER (PARTITION BY Position), 2) AS AvgSalaryByPosition,
   SUM(Salary) OVER (PARTITION BY Position) AS TotalSalaryByPosition,
   ROUND(AVG(EmpSatisfaction) OVER (PARTITION BY Position), 2) AS JobSatisfyByPost,
   ROUND(AVG(SpecialProjectsCount) OVER (PARTITION BY Position), 2) AS SpecialProjectByPost,
   ROUND(AVG(Absences) OVER (PARTITION BY Position), 2) AS AbsencesByPost,
   ROUND(AVG(2023-YearOfBirth) OVER (PARTITION BY Position), 2) AS AvgAgeByPost
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'

/*Gender, Age Category, Salary by Gender by Age Category, Absences by Gender by Age Category,
Job Satisfaction by Gender by Age Category, Special Projects By Gender by Age Category
*/
SELECT
   Gender,
   AgeCategory,
   ROUND(AVG(Salary),0) AS GenderBySalary,
   COUNT(Absences) AS AbsencesByGender,
   ROUND(AVG(EmpSatisfaction), 2) AS JobSatisfyByGender,
   ROUND(AVG(SpecialProjectsCount), 2) AS SpecialProjectByGender
FROM HR_clean_data
WHERE TermReason = 'Still-Employed'
GROUP BY Gender, AgeCategory

--Gender, Performance Score, Performance Score by Gender 
SELECT
   Gender,
   PerformanceScore,
   COUNT(PerformanceScore) AS PerformanceScoreByGender 
FROM HR_clean_data
GROUP BY Gender, PerformanceScore
ORDER BY  PerformanceScoreByGender

--Source of Recruitment and its counts
SELECT
  RecruitmentSource,
  COUNT(*) AS RecruitmentSourceCount
FROM HR_clean_data
GROUP BY  RecruitmentSource
ORDER BY RecruitmentSourceCount DESC

--Employment Status, TermReason and Employment Status Count
SELECT TOP 10
   EmploymentStatus,
   TermReason,
   COUNT(*) AS EmploymentStatus_Count
FROM HR_clean_data
GROUP BY EmploymentStatus, TermReason
ORDER BY EmploymentStatus_Count DESC

--Position and Department Strength
SELECT
   Position, 
   COUNT(Position) AS DepartmentStrength
FROM HR_clean_data
GROUP BY Position
HAVING COUNT (Position) > 3
ORDER BY DepartmentStrength DESC

--Position and Department Strength by Gender
SELECT TOP 10
   Position, 
   Gender,
   COUNT(Position) AS DepartmentStrength
FROM HR_clean_data
GROUP BY Position, Gender
ORDER BY DepartmentStrength DESC

SELECT
   COUNT(*) AS Employees_Count
FROM HR_clean_data
GROUP BY Employee_Name

ALTER TABLE HR_clean_data
ADD Employee_Count int null

UPDATE HR_clean_data
SET Employee_Count = 1

ALTER TABLE HR_clean_data DROP CONSTRAINT CK_HRM_data
GO
ALTER TABLE HR_clean_data DROP COLUMN Employees_Count

SELECT DOB 
FROM HR_clean_data 

SELECT CAST(DOB AS date) AS DOB
FROM HR_clean_data 

UPDATE HR_clean_data 
SET DOB = CAST(DOB AS DATE)

--Change to date format
SELECT DISTINCT CONVERT(date, DOB) AS YearOfBirth
FROM HR_clean_data

UPDATE HR_clean_data
SET DOB = CONVERT(date, DOB)

--Remove commas between Employees' Names
SELECT REPLACE(Employee_Name, ',', ' ') AS Employee_Name
FROM HR_clean_data

UPDATE HR_clean_data
SET Employee_Name = REPLACE(Employee_Name, ',', ' ')
