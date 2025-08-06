use payroll_analysis;

select * from Automated_payroll;
select * from Manual_payroll;

-- Checking for Duplicates or Redundant Records  
select EmployeeID, count(*) from Automated_payroll group by EmployeeID having count(*)>1;

-- Error-Free Compliance Rate: Manual vs Automated Payroll
SELECT 
  'Error-Free Records (%)' AS Metric,
  (SELECT ROUND(SUM(CASE WHEN ComplianceFlag = 'Compliant' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) FROM manual_payroll) AS Manual,
  (SELECT ROUND(SUM(CASE WHEN ComplianceFlag = 'Compliant' THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 2) FROM automated_payroll) AS Automated;
  
-- Comparison of average Net Salary by Department
SELECT 
  mp.Department,
  ROUND(mp.AvgManualSalary, 2) AS Manual_Avg_Salary,
  ROUND(ap.AvgAutomatedSalary, 2) AS Automated_Avg_Salary,
  ROUND(mp.AvgManualSalary - ap.AvgAutomatedSalary, 2) AS Difference
FROM
  (SELECT Department, AVG(NetSalary) AS AvgManualSalary
   FROM manual_payroll
   GROUP BY Department) mp
JOIN
  (SELECT Department, AVG(NetSalary) AS AvgAutomatedSalary
   FROM automated_payroll
   GROUP BY Department) ap
ON mp.Department = ap.Department;

-- Average processing time by payment method 
SELECT 
  mp.PaymentMode,
  ROUND(AVG(mp.ProcessingTime), 2) AS AvgProcessingTime_Manual,
  ROUND(AVG(ap.ProcessingTime2), 2) AS AvgProcessingTime_Automated
FROM manual_payroll mp
JOIN automated_payroll ap ON mp.PaymentMode = ap.PaymentMode
GROUP BY mp.PaymentMode;

-- Terminated Employee Salary Errors Comparison
SELECT 
  'Manual' AS Source,
  COUNT(*) AS TerminatedSalaryErrors
FROM manual_payroll
WHERE TerminationStatus = 'Terminated' AND NetSalary > 0
UNION
SELECT 
  'Automated',
  COUNT(*) 
FROM automated_payroll
WHERE TerminationStatus = 'Terminated' AND Net_Salary_Final > 0;

-- salary based on value date - Automated vs Manual payroll
SELECT 
  MONTH(valuedate) AS Month,
  SUM(NetSalary) AS TotalPayroll
FROM automated_payroll
GROUP BY MONTH(valuedate)
ORDER BY Month;

  
  




