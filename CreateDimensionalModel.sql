/*
Generate your Job Dimension
DimJob will have the following columns

JobID - auto generated and incremental
JobUniqueIdentifier
JobTitle
JobType
DateCreated -- Auto generated
DateLastUpdated -- Auto Generated

*/
DROP TABLE IF EXISTS test.DimJob;
GO

CREATE TABLE test.DimJob
(
	JobID INT IDENTITY(1,1), -- Autoincrement
	JobUniqueIdentifier nvarchar(50) NOT NULL,
	JobTitle nvarchar(50) NOT NULL,
	JobType nvarchar(50) NOT NULL,
	DateCreated date,
	DateLastUpdated date,
	CONSTRAINT [PK_DimJob] PRIMARY KEY CLUSTERED 
	(
		JobID ASC
	) -- Primay key AND Clustered Index, It's possible to have a different PK and Clustered Index
);
-- Populate the Table
INSERT INTO test.DimJob
SELECT 
	--JobID is auto-generated, no need to add in the select statement
	JobUniqueIdentifier = j.JobUniqueIdentifier,
	JobTitle			= j.JobTitle,
	JobType				= jt.JobType,
	DateCreated			= GETDATE(),
	DateLastUpdated		= GETDATE()
FROM test.Jobs j
INNER JOIN test.JobType jt ON j.JobTypeID = jt.JobTypeID
GO

-- Look at the data
SELECT TOP 10 * FROM test.DimJob;
GO

/*
Generate your Employee Dimension
DimEmployee will have the following columns

EmployeeID - auto generated and incremental
EmployeeUniqueIdentifier
EEFirstName
EELastName
EmploymentStatus
JobID
DateCreated -- Auto generated
DateLastUpdated -- Auto Generated
*/
DROP TABLE IF EXISTS test.DimEmployee;

CREATE TABLE test.DimEmployee
(
	EmployeeID INT IDENTITY(1,1), -- Autoincrement
	EmployeeUniqueIdentifier nvarchar(50) NOT NULL,
	EEFirstName nvarchar(50) NOT NULL,
	EELastName nvarchar(50) NOT NULL,
	EmploymentStatus nvarchar(50) NOT NULL,
	JobID int,
	DateCreated date,
	DateLastUpdated date,
	CONSTRAINT PK_DimEmployee PRIMARY KEY CLUSTERED 
	(
		EmployeeID ASC
	) -- Primay key AND Clustered Index, It's possible to have a different PK and Clustered Index
);


INSERT INTO test.DimEmployee
SELECT 
	--EmployeeID is auto-generated, no need to add in the select statement
	EmployeeUniqueIdentifier	= e.EmployeeUniqueIdentifier,
	EEFirstName					= e.EEFirstName,
	EELastName					= e.EELastName,
	EmploymentStatus			= et.EmploymentStatus,
	JobID						= j.JobID,
	DateCreated					= GETDATE(),
	DateLastUpdated				= GETDATE()
FROM test.Employees e
INNER JOIN test.DimJob j ON e.JobID = j.JobUniqueIdentifier
INNER JOIN test.EmploymentStatus et ON e.EmploymentStatus = et.EmploymentStatusID
GO

-- Look at the data
SELECT TOP 10 * FROM test.DimEmployee;
GO

/*
Done with the dimensions,
lets generate the fact table
There are two potential fact tables here: JobMarketValue and EmployeeSalary.
We can do both but if we want to look at salaries and compare it to job marketvalues, 
we will have to create a single fact table.

We can still compare salary vs market value even if we have two separate fact tables but it will be more computationally expensive
to join two fact tables especially if the data is huge. 

*/
DROP TABLE IF EXISTS test.FactEmployeeJob
GO

SELECT 
EmployeeID		= e.EmployeeID,
JobID			= e.JobID,
AnnualSalary	= es.AnnualSalary,
MarketValue		= jm.JobMarketValue
INTO test.FactEmployeeJob -- This will automatically create the table from the SELECT statement
FROM 
(
	SELECT 
		EmployeeUniqueIdentifier,
		SUM(AnnualAmount) AS AnnualSalary
	FROM test.EmployeeSalary
	GROUP BY EmployeeUniqueIdentifier
)es
INNER JOIN test.DimEmployee e ON es.EmployeeUniqueIdentifier = e.EmployeeUniqueIdentifier
INNER JOIN test.DimJob j ON e.JobID = j.JobID
INNER JOIN test.JobMarketValue jm ON jm.JobID = j.JobUniqueIdentifier
GO

SELECT * FROM test.FactEmployeeJob;

