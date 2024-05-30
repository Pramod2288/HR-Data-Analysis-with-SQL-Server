-- Create Database
create database HR


-- Use Database
use HR


Select * From HRData


-- Data Standardization
Update HRData
Set JobRole = 'Manager'
Where JobRole = 'Ma0ger'


-- 1. Retrieve the total number of Employees in the dataset
Select Count(*) TotalNumber From HRData;



-- 2. List all unique job roles in the dataset
Select distinct(JobRole) From HRData



-- 3. Find the average/max/min age of Employees.
Select AVG(age) Avg_Age, MAX(Age) as Max_Age, Min(Age) as Min_Age From HRData



-- 4. Retrieve the names and ages of Employees who have worked at the company for more than 5 years.
Select Employe, Age, YearsAtCompany From HRData
Where YearsAtCompany >5




-- 5. Get a Count of Employees grouped by their department
Select Count(Employe) as No_of_Employee, Department From HRData
Group By Department



-- 6. List Employees who have 'High' Job Satisfaction, 5 = high
Select Employe, JobLevel From HRData
Where JobLevel = 5


-- 7. Find the highest/average/minimum Monthly Income in the dataset.
Select max(MonthlyIncome) as Max_Income, AVG(MonthlyIncome) as Avg_Income, Min(MonthlyIncome) as Min_Income From HRData


-- 8. List Employees who have 'Travel_Rarely' as their BusinessTravel type.
Select Employe, BusinessTravel From HRData
Where BusinessTravel = 'Travel_Rarely'


-- 9. Retrieve the distinct MaritalStatus categories with Count in the dataset.
Select MaritalStatus, Count(Employe) Count_of_MaritalStatus From HRData
Group By MaritalStatus


-- 10. Get a list of Employees with more than 2 years of work experience but less than 4 years in their current role.
Select Employe, YearsAtCompany, JobRole
From HRData
Where YearsAtCompany > 2 AND YearsAtCompany < 4;


-- 12. Find the average distance From home for Employees in each department.
Select Department, Avg(DistanceFromHome) as Avg_Dist_From_Home From HRData
Group By Department;


-- 13. Retrieve the top 5 Employees with the highest MonthlyIncome.
Select Top 5 Employe, MonthlyIncome From HRData
Order By MonthlyIncome DESC


-- 14. Calculate Average Monthly Income by Education Field.
Select EducationField, Avg(MonthlyIncome) as AvgMonthlyIncome From HRData
Group By EducationField


-- 15. Count Employees Who Received Training in the Last Year
Select Count(*) NumEmployeesWithTraining From HRData
Where TrainingTimesLastYear > 0


-- 16. Analyze Attrition Rates by Age Group:
Select Age, Count(*) as NumEmployees,
SUM(Case when Attrition = '1' Then 1 else 0 End) As AttritionCount,
Round(SUM(Case when Attrition = '1' Then 1 Else 0 End) * 100 / Count(*),2) as AttritionRate
From HRData
Group By Age
Order By Age;



-- 17. Calculate Average Years Since Last Promotion by Job Role
Select JobRole, AVG(YearsSinceLastPromotion) as AvgYearsSinceLastPromotion
From HRData
Group By JobRole



-- 18. Identify Employees with the Highest Performance Ratings in Each Department
WITH RankedEmployees AS (
    Select Employe, Department, PerformanceRating,
           ROW_NUMBER() OVER (PARTITION BY Department Order By PerformanceRating DESC) AS Rank
    From HRData
)
Select Employe, Department, PerformanceRating
From RankedEmployees
Where Rank = 1;


-- 19. Calculate Average Monthly Income by Job Role and Gender:
Select JobRole, Gender, AVG(MonthlyIncome) as AvgMonthlyIncome
From HRData
Group By JobRole, Gender
Order By JobRole, Gender


-- 20. Identify Top 10 Employees with the Longest Tenure in the Company
Select Top 10 EmployeeID, Employe, TotalWorkingYears, Department, JobRole
From HRData
Order By TotalWorkingYears DESC


-- 21. Analyze Job Satisfaction Levels by Age Group:
Select AgeGroup, AVG(JobSatisfaction) as AvgJobSatisfaction
From(
	Select Case
			When Age Between 18 And 30 Then '18-30'
			When Age Between 31 And 40 Then '31-40'
			When Age Between 41 And 50 Then '41-50'
			Else '51+'
		End as AgeGroup, JobSatisfaction
	From HRData) As AgeGroups
Group By AgeGroup
Order By AgeGroup


------------------------------------------------------------------------------------------------------------------------------------------

-- More Detail Analysis
-- Below queries provide a comprehensive analysis of the HR data, covering demographics, attrition, salary and benefits, performance, career progression, and work environment factors.


-- Basic Analysis

-- 1. Calculate the average, minimum, and maximum values for columns like Age, MonthlyIncome, TotalWorkingYears, etc.:
SELECT 
    AVG(Age) AS AvgAge, 
    MIN(Age) AS MinAge, 
    MAX(Age) AS MaxAge,

    AVG(MonthlyIncome) AS AvgMonthlyIncome, 
    MIN(MonthlyIncome) AS MinMonthlyIncome, 
    MAX(MonthlyIncome) AS MaxMonthlyIncome,

    AVG(TotalWorkingYears) AS AvgTotalWorkingYears, 
    MIN(TotalWorkingYears) AS MinTotalWorkingYears, 
    MAX(TotalWorkingYears) AS MaxTotalWorkingYears
FROM HRData;


-- 2. Count the number of employees in each department, gender, education level, job role, and marital status:
-- Count by Department
SELECT Department, COUNT(*) AS NumEmployees
FROM HRData
GROUP BY Department;

-- Count by Gender
SELECT Gender, COUNT(*) AS NumEmployees
FROM HRData
GROUP BY Gender;

-- Count by EducationField
SELECT EducationField, COUNT(*) AS NumEmployees
FROM HRData
GROUP BY EducationField;

-- Count by Job Role
SELECT JobRole, COUNT(*) AS NumEmployees
FROM HRData
GROUP BY JobRole;

-- Count by Marital Status
SELECT MaritalStatus, COUNT(*) AS NumEmployees
FROM HRData
GROUP BY MaritalStatus;



-- Attrition Analysis

-- 3. Calculate the attrition rate based on different factors like department, job role, job level, education field, etc.:

-- Attrition Rate by Department
SELECT Department, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY Department;

-- Attrition Rate by Job Role
SELECT JobRole,
	Count(*) as NumEmployees,
	SUM(Case When Attrition = '1' Then 1 Else 0 End) as AttritonCount,
	Round(SUM(Case When Attrition = '1' Then 1 Else 0 End) * 100 / Count(*), 2) As AttritionRate
From HRData
Group By JobRole

-- Attrition Rate by Job Level
SELECT JobLevel, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY JobLevel;

-- Attrition Rate by Education Field
SELECT EducationField, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY EducationField;


-- 4. Analyze the reasons for attrition by identifying common patterns or correlations:

-- Correlation with DistanceFromHome
SELECT DistanceFromHome, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY DistanceFromHome;

-- Correlation with JobSatisfaction
SELECT JobSatisfaction, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY JobSatisfaction;

-- Correlation with WorkLifeBalance
SELECT WorkLifeBalance, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY WorkLifeBalance;


-- Salary and Benefits Analysis

-- 5. Compare average monthly incomes across different job roles, departments, and education fields:
-- Average Monthly Income by Job Role
SELECT JobRole, AVG(MonthlyIncome) AS AvgMonthlyIncome
FROM HRData
GROUP BY JobRole;

-- Average Monthly Income by Department
SELECT Department, AVG(MonthlyIncome) AS AvgMonthlyIncome
FROM HRData
GROUP BY Department;

-- Average Monthly Income by Education Field
SELECT EducationField, AVG(MonthlyIncome) AS AvgMonthlyIncome
FROM HRData
GROUP BY EducationField;


-- 6. Analyze the impact of stock option level, percent salary hike, and total working years on employee satisfaction and retention:
-- Impact of StockOptionLevel on JobSatisfaction
SELECT StockOptionLevel, AVG(JobSatisfaction) AS AvgJobSatisfaction
FROM HRData
GROUP BY StockOptionLevel;

-- Impact of PercentSalaryHike on JobSatisfaction
SELECT PercentSalaryHike, AVG(JobSatisfaction) AS AvgJobSatisfaction
FROM HRData
GROUP BY PercentSalaryHike;

-- Impact of TotalWorkingYears on JobSatisfaction
SELECT TotalWorkingYears, AVG(JobSatisfaction) AS AvgJobSatisfaction
FROM HRData
GROUP BY TotalWorkingYears;


-- Employee Performance Analysis

-- 7. Calculate average performance ratings and job involvement levels across different departments, job roles, and education levels:
-- Average Performance Rating by Department
SELECT Department, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY Department;

-- Average Performance Rating by Job Role
SELECT JobRole, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY JobRole;

-- Average Performance Rating by Education Level
SELECT Education, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY Education;

-- Average Job Involvement by Department
SELECT Department, AVG(JobInvolvement) AS AvgJobInvolvement
FROM HRData
GROUP BY Department;

-- Average Job Involvement by Job Role
SELECT JobRole, AVG(JobInvolvement) AS AvgJobInvolvement
FROM HRData
GROUP BY JobRole;

-- Average Job Involvement by Education Level
SELECT Education, AVG(JobInvolvement) AS AvgJobInvolvement
FROM HRData
GROUP BY Education;


-- 8. Identify factors such as work-life balance, environment satisfaction, and job satisfaction that correlate with higher performance ratings:
-- Correlation between WorkLifeBalance and PerformanceRating
SELECT WorkLifeBalance, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY WorkLifeBalance;

-- Correlation between EnvironmentSatisfaction and PerformanceRating
SELECT EnvironmentSatisfaction, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY EnvironmentSatisfaction;

-- Correlation between JobSatisfaction and PerformanceRating
SELECT JobSatisfaction, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY JobSatisfaction;


-- Career Progression Analysis

-- 9. Calculate the average years at the company, years since last promotion, and years with the current manager to understand career progression patterns:
-- Average Years at Company by Job Role
SELECT JobRole, AVG(YearsAtCompany) AS AvgYearsAtCompany
FROM HRData
GROUP BY JobRole;

-- Average Years Since Last Promotion by Job Role
SELECT JobRole, AVG(YearsSinceLastPromotion) AS AvgYearsSinceLastPromotion
FROM HRData
GROUP BY JobRole;

-- Average Years with Current Manager by Job Role
SELECT JobRole, AVG(YearsWithCurrMa0ger) AS AvgYearsWithCurrManager
FROM HRData
GROUP BY JobRole;

-- 10. Analyze the relationship between education level, training times last year, and job level to identify factors influencing career growth:
-- Relationship between Education Level and Job Level
SELECT Education, AVG(JobLevel) AS AvgJobLevel
FROM HRData
GROUP BY Education;

-- Relationship between Training Times Last Year and Job Level
SELECT TrainingTimesLastYear, AVG(JobLevel) AS AvgJobLevel
FROM HRData
GROUP BY TrainingTimesLastYear;

-- Work Environment Analysis

-- 11. Analyze employee satisfaction levels (environment satisfaction, job satisfaction, work-life balance) and their impact on attrition and performance:
-- Impact of EnvironmentSatisfaction on Attrition
SELECT EnvironmentSatisfaction, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY EnvironmentSatisfaction;

-- Impact of JobSatisfaction on Attrition
SELECT JobSatisfaction, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY JobSatisfaction;

-- Impact of WorkLifeBalance on Attrition
SELECT WorkLifeBalance, 
       COUNT(*) AS NumEmployees, 
       SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) AS AttritionCount,
       ROUND(SUM(CASE WHEN Attrition = '1' THEN 1 ELSE 0 END) * 100 / COUNT(*), 2) AS AttritionRate
FROM HRData
GROUP BY WorkLifeBalance;

-- Impact of EnvironmentSatisfaction on Performance
SELECT EnvironmentSatisfaction, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY EnvironmentSatisfaction;

-- Impact of JobSatisfaction on Performance
SELECT JobSatisfaction, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY JobSatisfaction;

-- Impact of WorkLifeBalance on Performance
SELECT WorkLifeBalance, AVG(PerformanceRating) AS AvgPerformanceRating
FROM HRData
GROUP BY WorkLifeBalance;
