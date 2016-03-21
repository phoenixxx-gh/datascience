### Question 1.
1)
mysql> SELECT id, extra FROM SLEEP;
2) 
mysql> SELECT extra, id FROM SLEEP;
3)
mysql> SELECT DISTINCT(category) FROM SLEEP;
4)
mysql> SELECT id FROM SLEEP WHERE extra > 0;
5)
mysql> SELECT SUM(extra) AS 'extraSum', SUM(category) AS 'categoryNum' FROM SLEEP GROUP BY category;
6)
mysql> SELECT AVG(extra) mean_extra FROM SLEEP GROUP BY category;

### Question 2.
1)
mysql> SELECT * FROM Department LIMIT 2;
2)
mysql> SELECT EmployeeName, HireDate, BaseWage FROM Employee;
3)
mysql> SELECT EmployeeName,(BaseWage * WageLevel) AS 'Total Wage' FROM Employee;
4)
mysql> SELECT EmployeeName FROM Employee WHERE BaseWage BETWEEN 2000 AND 3000 ORDER BY BaseWage DESC;
5)
mysql>  SELECT EmployeeName, HireDate, BaseWage FROM Employee WHERE EmployeeName LIKE '%8' AND HireDate > '2010-06-10%';
##
6)
mysql> SELECT EmployeeName, (Employee.BaseWage * Employee.WageLevel) AS 'Total wage', DepartmentID FROM Employee WHERE (Employee.BaseWage * Employee.WageLevel) > 7000;

#
SELECT Departmentid FROM DEPARTMENT inner join EMPLOYEE using (DeptId) where Salary>1000 group by Departmentid having count(*)>2
SELECT Departmentid FROM Employee where basewage>3000 group by Departmentid having count(*)>2
##
7)
mysql> SELECT DepartmentID FROM Employee WHERE BaseWage >3000 AND (SELECT count(*) > 2);
Empty set (0.01 sec)

8)
mysql>  SELECT DepartmentID, AVG(BaseWage * WageLevel) AS AVG_Total_Wage FROM Employee GROUP BY DepartmentID ASC;
9)
mysql> SELECT DepartmentID, AVG(BaseWage * WageLevel) AS 'Average Total Wage', EmployeeSex FROM Employee GROUP BY EmployeeSex, DepartmentID ORDER BY DepartmentID DESC;
10)
mysql> SELECT Employee.EmployeeName, Department.DepartmentName, Department.Principal FROM Employee JOIN Department ON Employee.DepartmentID = Department.DepartmentID;

### Question 3.
1)
mysql> DELETE FROM Employee WHERE EmployeeID = 5;
2)
mysql> DELETE FROM Employee WHERE DepartmentID = (SELECT DepartmentID FROM Department WHERE LOWER(DepartmentName) = 'sale');
Query OK, 4 rows affected (0.04 sec)
3)
mysql> ALTER TABLE Department ADD AvgWage FLOAT;
4)
mysql> SELECT DepartmentID, AVG(BaseWage * WageLevel) FROM Employee GROUP BY DepartmentID;
mysql> UPDATE Department SET AvgWage = 3750 WHERE DepartmentID = 1;
mysql> UPDATE Department SET AvgWage = 6250 WHERE DepartmentID = 2;
5)
mysql> UPDATE Employee SET BaseWage = (BaseWage * 1.1) WHERE DepartmentID =(SELECT DepartmentID FROM Department WHERE LOWER(DepartmentName) = 'finance');

### Question 4.

1) 
# Get adult.data file FROM website into server.
$ wget http://archive.ics.uci.edu/ml/machine-learning-databases/adult/adult.data

# Create Table Adult with same structure as adult.data file. Unable to add ID column as primary key during table creation.

CREATE TABLE Adult
(
	Age INT,
	WorkClass VARCHAR(30),
	FnlWgt DOUBLE(10,2),
	Education VARCHAR(20),
	EducationNum DOUBLE(3,2),
	MaritalStatus VARCHAR(30),
	Occupation VARCHAR(30),
	Relationship VARCHAR(20),
	Race VARCHAR(25),
	Sex VARCHAR(10),
	CapitalGain DOUBLE(20,2),
	CapitalLoss DOUBLE(20,2),
	HoursPerWeek DOUBLE(4,2),
	NativeCountry VARCHAR(30),
	Class VARCHAR(10)
);

ALTER TABLE Adult ADD ID INT NOT NULL AUTO_INCREMENT PRIMARY KEY FIRST;

2)
# Load adult.data into table Adult.
LOAD DATA LOCAL INFILE 'adult.data' INTO TABLE Adult
    FIELDS TERMINATED BY ', '
    LINES TERMINATED BY '\n';
3)
# Zero was used for missing numerical values so I had to check for zero and not ""IS NOT NULL"."
SELECT COUNT(*) FROM Adult WHERE
	Age = 0 OR 
	WorkClass = '?' OR
	FnlWgt = 0 OR
	Education = '?' OR
	EducationNum = 0 OR
	MaritalStatus = '?' OR
	Occupation = '?' OR
	Relationship = '?' OR
	Race = '?' OR
	Sex = '?' OR
	CapitalGain = 0 OR
	CapitalLoss =0 OR
	HoursPerWeek = 0 OR
	NativeCountry = '?' OR
	Class = '?' 
;
## Rows with missing values
32561

4)
# All rows had a missing value, a visual check for "0" or "?" confirmed this.
# The below sql statement was therefore not executed since this would have deleted
# all the data needed for the rest of the exercise.

DELETE FROM Adult WHERE
	Age = 0 OR 
	WorkClass = '?' OR
	FnlWgt = 0 OR
	Education = '?' OR
	EducationNum = 0 OR
	MaritalStatus = '?' OR
	Occupation = '?' OR
	Relationship = '?' OR
	Race = '?' OR
	Sex = '?' OR
	CapitalGain = 0 OR
	CapitalLoss =0 OR
	HoursPerWeek = 0 OR
	NativeCountry = '?' OR
	Class = '?' 
;

5)
CREATE TEMPORARY TABLE IF NOT EXISTS Adult1 AS (SELECT COUNT(*) AS 'SumUnder50K' FROM Adult WHERE Class = '<=50K');
CREATE TEMPORARY TABLE IF NOT EXISTS Adult2 AS (SELECT COUNT(*) AS 'SumAbove50K' FROM Adult WHERE Class = '>50K');  
# "IF NOT EXISTS" used to prevent overwriting existing table with same name.

mysql> select SumUnder50K / SumAbove50K from Adult1, Adult2;
+---------------------------+
| SumUnder50K / SumAbove50K |
+---------------------------+
|                    3.1527 |
+---------------------------+

# This shows that the Ratio of poeple in the '<=50K' Class to those in the '>50K' Class is 3.1527 to 1.

6)
mysql> select Avg(Age) from Adult where Class = '<=50K';
+----------+
| Avg(Age) |
+----------+
|  36.7837 |


mysql> select Avg(Age) from Adult where Class = '>50K';
+----------+
| Avg(Age) |
+----------+
|  44.2498 |
+----------+
1 row in set (0.04 sec)

7)
mysql> select count(*) from Adult where Class = '>50K' AND Age < 36.78;
+----------+
| count(*) |
+----------+
|     1968 |
+----------+

8)
mysql> select Avg(HoursPerWeek) from Adult where Class = '<=50K';
+-------------------+
| Avg(HoursPerWeek) |
+-------------------+
|         38.840210 |
+-------------------+

mysql> select Avg(HoursPerWeek) from Adult where Class = '>50K';
+-------------------+
| Avg(HoursPerWeek) |
+-------------------+
|         45.473026 |
+-------------------+

9)
CREATE TEMPORARY TABLE Adult4 AS (SELECT COUNT(*) AS 'MaleUnder50K' FROM Adult WHERE Class = '<=50K' AND UPPER(Sex) = 'MALE');
CREATE TEMPORARY TABLE Adult5 AS (SELECT COUNT(*) AS 'MaleAbove50K' FROM Adult WHERE Class = '>50K' AND UPPER(Sex) = 'MALE');

mysql> select MaleUnder50K /MaleAbove50K from Adult4, Adult5;
+----------------------------+
| MaleUnder50K /MaleAbove50K |
+----------------------------+
|                     2.2708 |
+----------------------------+

# The Ratio of men in the '<=50K' Class to those in the '>50K' Class is 2.2708 to 1.

CREATE TEMPORARY TABLE Adult6 AS (SELECT COUNT(*) AS 'FemaleUnder50K' FROM Adult WHERE Class = '<=50K' AND UPPER(Sex) = 'FEMALE');
CREATE TEMPORARY TABLE Adult7 AS (SELECT COUNT(*) AS 'FemaleAbove50K' FROM Adult WHERE Class = '>50K' AND UPPER(Sex) = 'FEMALE');

mysql> select FemaleUnder50K /FemaleAbove50K from Adult6, Adult7;
+--------------------------------+
| FemaleUnder50K /FemaleAbove50K |
+--------------------------------+
|                         8.1357 |
+--------------------------------+

# The Ratio of women in the '<=50K' Class to those in the '>50K' Class is 8.1357 to 1.