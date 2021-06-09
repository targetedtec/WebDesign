/*
******************** Targeted Technology Institute **********************************

	Here we build and use a database for a hypothetical Health Record Management System, HRMS portal

	You will be required to write select statements and create DB objects like Stored procs, views and triggers

	TABLES : Patient, Doctor, Disease and Diagnosis, Medicine, PharmacyPersonel, Prescription, MedicinePrescribed, ...

	- First understnad the design of the database - tables and their relationships
	- If at any point you cound't insert the data give nor encountered a problem - try to figre out what caused it.
*/

DROP DATABASE IF EXISTS HRMSDB;

CREATE DATABASE HRMSDB;

USE HRMSDB;

--  CREATING TABLES, WITH APPLICABLE CONSTRAINTS 

CREATE TABLE Patient
(
	mrn CHAR(5) NOT NULL,
	pFName VARCHAR(30) NOT NULL,
	pLName VARCHAR(30) NOT NULL,
	PDoB DATE NOT NULL,
	insuranceId CHAR(7) NULL, 
	gender CHAR(1) NOT NULL,
	SSN CHAR(11) NULL,
	stAddress VARCHAR(25) NOT NULL,
	city VARCHAR(25) NOT NULL,
	`state` CHAR(2) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	registeredDate DATE NOT NULL,
	CONSTRAINT PK_Patient_mrn PRIMARY KEY (mrn),
	CONSTRAINT CK_Patient_mrn_Format CHECK(mrn LIKE '`A-Z``A-Z``0-9``0-9``0-9`'),
	CONSTRAINT UQ_Patient_insuranceId UNIQUE (insuranceId),
	CONSTRAINT CK_Patient_gender_Format CHECK(gender IN ('F', 'M', 'U')),
	CONSTRAINT CK_Patient_SSN_Format CHECK ((SSN LIKE '`0-9``0-9``0-9``-``0-9``0-9``-``0-9``0-9``0-9``0-9`') AND (SSN NOT LIKE '000-00-0000')),
	CONSTRAINT UQ_Patient_SSN UNIQUE (SSN),
	CONSTRAINT CK_Patient_state_Format CHECK(state LIKE '`A-Z``A-Z`'),
	CONSTRAINT CK_Pateint_zipCode_Fomrat CHECK((zipCode LIKE '`0-9``0-9``0-9``0-9``0-9`') AND (zipCode NOT LIKE '00000'))
);

CREATE TABLE Employee
(
	empId CHAR(5) NOT NULL,
	empFName VARCHAR(25) NOT NULL,
	empLName VARCHAR(25) NOT NULL,
	SSN CHAR(11) NOT NULL,
	DoB DATE NOT NULL,
	gender CHAR(1) NOT NULL,
	salary DECIMAL(8,2) NULL,
	employedDate DATE NOT NULL,
	strAddress VARCHAR (30) NOT NULL,
	apt VARCHAR(5) NULL,
	city VARCHAR(25) NOT NULL,
	`state` CHAR(2) NOT NULL,
	zipCode CHAR(5) NOT NULL,
	phoneNo CHAR(14) NOT NULL,
	email VARCHAR(50) NULL,
	empType VARCHAR(20) NOT NULL,
	CONSTRAINT PK_Employee_empId PRIMARY KEY (empId)
);

CREATE TABLE Disease
(
	dId INT NOT NULL,	
	dName VARCHAR(100) NOT NULL,
	dCategory VARCHAR(50) NOT NULL,
	dType VARCHAR(40) NOT NULL,
	CONSTRAINT PK_Disease_dId PRIMARY KEY (dId)
);

CREATE TABLE Doctor
(
	empId CHAR(5) NOT NULL, 
	docId CHAR(4) NOT NULL,
	licenseNo CHAR(11) UNIQUE NOT NULL,
	licenseDate DATE NOT NULL,
	`rank` VARCHAR(25) NOT NULL,
	specialization VARCHAR(50) NOT NULL,
	CONSTRAINT PK_Doctor_docId PRIMARY KEY (docId),
	CONSTRAINT FK_Doctor_Employee_empId FOREIGN KEY (empId) REFERENCES Employee (empId) ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE Diagnosis
(
	diagnosisNo INT NOT NULL,
	mrn CHAR(5) NOT NULL,
	docId CHAR(4) NULL,
	dId INT NOT NULL,
	diagDate DATE NOT NULL,
	diagResult VARCHAR(1000) NOT NULL,
	CONSTRAINT PK_Diagnosis_diagnosisNo PRIMARY KEY (diagnosisNo),
	CONSTRAINT FK_Diagnosis_Patient_mrn FOREIGN KEY (mrn) REFERENCES Patient(mrn),
	CONSTRAINT FK_Diagnosis_Doctor_docId FOREIGN KEY (docId) REFERENCES Doctor(docId) ON DELETE SET NULL ON UPDATE CASCADE,
	CONSTRAINT FK_Diagnosis_Disease_dId FOREIGN KEY (dId) REFERENCES Disease(dId)
);

CREATE TABLE PharmacyPersonel
(
	empId CHAR(5) NOT NULL,
	pharmacistLisenceNo CHAR (11) NOT NULL,
	licenseDate DATE NOT NULL,
	PCATTestResult INT NULL,
	level VARCHAR(40) NOT NULL,
	CONSTRAINT FK_PharmacyPersonel_empId FOREIGN KEY (empId) REFERENCES Employee (empId),
	CONSTRAINT UQ_PharmacyPersonel_pharmacistLisenceNo UNIQUE (pharmacistLisenceNo)
);

CREATE TABLE Medicine
(
	mId SMALLINT NOT NULL,
	brandName VARCHAR(40) NOT NULL,
	genericName VARCHAR(50) NOT NULL,
	qtyInStock INT NOT NULL,
	`use` VARCHAR(50) NOT NULL,
	expDate DATE NOT NULL,
	unitPrice DECIMAL(6,2) NOT NULL,
	CONSTRAINT PK_Medicine_mId PRIMARY KEY (mId)
);

CREATE TABLE Prescription
(
	prescriptionId INT NOT NULL,
	diagnosisNo INT NOT NULL,
	prescriptionDate DATE NOT NULL,
	CONSTRAINT PK_Prescription_prescriptionId PRIMARY KEY (prescriptionId),
	CONSTRAINT FK_Prescription_Diagnosis_diagnosisNo FOREIGN KEY (diagnosisNo) REFERENCES Diagnosis(diagnosisNo) 
);

CREATE TABLE MedicinePrescribed
(
	prescriptionId INT NOT NULL,
	mId SMALLINT NOT NULL,
	dosage VARCHAR(50) NOT NULL,
	numberOfAllowedRefills TINYINT NOT NULL,
	CONSTRAINT PK_MedicinePrescribed_prescriptionId_mId PRIMARY KEY(prescriptionId, mId),
	CONSTRAINT FK_MedicinePrescribed_prescriptionId FOREIGN KEY (prescriptionId) REFERENCES Prescription(prescriptionId),
	CONSTRAINT FK_MedicinePrescribed_mId FOREIGN KEY (mId) REFERENCES Medicine(mId)
);


--  Inserting some data into tables of HRMS database, 


INSERT INTO Disease 
	VALUES (1, 'Anthrax', 'Bacterial infections', 'Contageous'), 
		   (2, 'Acquired hemophilia','Blood Diseases','Type2'), 
		   (3, 'Accessory pancreas ','Digestive Diseases','xyz'),
		   (4, 'Cholera ', 'Bacterial infections', 'Contageous'),
		   (5, 'Acatalasemia ','Blood Diseases', 'Chronic'),
		   (6, 'Acute fatty liver of pregnancy ','Digestive Diseases','Non Contageous');

INSERT INTO Medicine 
	VALUES (1, 'Xaleto','Rivaroxi...', 200, 'Anticoagulant', '2022-12-31', 67.99), 
		   (2, 'Eliquis', 'Apiza...',500, 'ACE inhitor', '2021-06-06', 23.49),
		   (3, 'Tran..Acid', 'Inhibitor', 600, 'Something','2020-12-31', 9.99),
		   (4, 'Fosamax', 'aLENGTHdronate tablet', 200, 'treat certain types of bone loss in adults','2022-12-31',58),
		   (5, 'HexaLENGTH capsules','altretamine',150,'Ovarian cancer','2020-12-31',26),
		   (6, 'Prozac','Fluoxetine...', 125, 'Anti-depressent', '2019-12-31', 43.99),
		   (7, 'Glucofage','Metformine...', 223, 'Anti-Diabetic', '2019-10-13', 22.99),
		   (8, 'Advil', 'Ibuprofine', 500, 'Pain killer', '2023-01-01', 0.10),
		   (9, 'Amoxy','Amoxilcillin', 2000, 'Antibiotics', '2021-12-31', 0.20 );



INSERT INTO Patient
	VALUES	('PA001', 'Kirubel', 'Wassie', '1985-09-12', 'kki95', 'M','031-56-3472','2578 kk st', 'Alexandria', 'VA', '22132','2018-01-01'),
			('PA002', 'Harsha', 'Sagar', '1980-11-19', 'wes41', 'F','289-01-6994','3379 bb st', 'Miami', 'FL', '19376','2017-09-02'),
			('PA003', 'Fekadu', 'nfa', '1990-05-20', 'oi591', 'M','175-50-1235','1538 ff st',  'Seattle', 'WA', '35800','2018-01-01'),
			('PA004', 'Arsema', 'Negera', '1978-01-25', 'iuu53', 'F','531-31-3308','2928 aa st', 'Silver Spring', 'MD', '51763','2017-02-01'),
			('PA005', 'John', 'Craig', '1965-12-31', 'iu979', 'M','231-61-8422','1166 jj st', 'Alexandria', 'VA', '22132','2019-01-03'),
			('PA006', 'Maria', 'Michael', '1979-08-12', 'mk216', 'F', '786-32-0912','7866 mm st', 'Silver Spring', 'MD', '51763','2018-01-01'),
			('PA007', 'Derek', 'Nagaraju', '1975-02-18', 'sd025', 'M','120-21-6743','8889 ff st', 'Silver Spring', 'MD', '51763','2019-02-20'),
			('PA008', 'Birtukan', 'Wale', '1989-01-27', 'is489', 'F','013-32-6789','5464 bb st', 'Seattle', 'WA', '35800','2018-01-05'),
			('PA009', 'Yehualashet', 'Lemma', '1983-05-15', 'kl526', 'M', '745-21-0321','3338 yy st', 'Miami', 'FL', '19376','2018-01-01'),
			('PA010', 'Selam', 'Damtew', '1970-09-22', 's5561', 'F', '300-00-2211','4651 ss st', 'Huston', 'TX', '11156','2018-09-10'),
			('PA011', 'Simon', 'Kifle', '1968-08-11', 'dc256', 'M', '333-44-5555','2287 sk st', 'Springfield', 'VA', '22132','2018-01-01'),
			('PA012', 'Nany', 'Tekle', '1970-08-25', 'po724', 'F', '222-88-4444','1313 nt st', 'Springfield', 'VA', '22132','2019-03-01'),
			('PA013', 'Adane', 'Belay', '1984-11-16', 'sa366', 'M', '001-22-3216','4687 ab st', 'Seattle', 'WA', '35800','2017-02-02'),
			('PA014', 'Genet', 'Misikir', '1982-05-28', 'l8773', 'F', '999-44-2299','00468 gm st', 'Richmond', 'VA', '55982','2017-11-12'),
			('PA015', 'Mikiyas', 'Tesfaye', '1979-01-15', 'w6321', 'M', '221-90-8833','5090 mt st', 'Alexandria', 'VA', '22132','2017-11-12');




INSERT INTO Employee 
	VALUES ('EMP01', 'Neftalem', 'Medhanie', '050-23-1111', '1971-10-07','M',78000,'2017-03-02','1293 Duncan Avenue', '198','Rockville', 'MD','20871', '(707) 890-3212', 'nef@yahoo.com','P'),
		   ('EMP02', 'Mark', 'Lewis', '060-23-2222', '1972-09-12','M',67500,'2018-12-02','4080 Marshall Street', '800','Washington', 'DC','20021', '(202) 890-9032', 'mark@gmail.com','C'),
		   ('EMP03', 'Dennis', 'Price', '060-21-3333', '1973-10-09','F',89800,'2016-03-02','1331 Edsel Road', 'L21','Woodbridge', 'VA','20321', '(570) 000-2112', 'kathe@gmail.com','M'),
		   ('EMP04', 'Robert', 'Iversen', '070-23-4444', '1974-07-01','M',100000,'2017-09-01','786 Eagle Lane', '234','Columbia', 'MD','20990', '(301) 890-3200', 'rob@yahoo.com','P'),
		   ('EMP05', 'Rosie', 'Seiler', '080-23-5555', '1975-03-07','F',79300,'2016-03-02','123 Ky St', '698','Bethesda', 'MD','20871', '(332) 890-3212', 'rosie@yahoo.com','A'),
		   ('EMP06', 'Emmanuel', 'Kepa', '908-23-6666', '1985-09-15','M',89800,'2018-12-02','5 Poe Lane', '832','Washington', 'DC','20021', '(204) 890-9032', 'emma@gmail.com','A'),
		   ('EMP07', 'Andrew', 'Neftalem', '090-21-7777', '1986-11-03','M',100100,'2015-03-02','1378 Gateway Road', '823','Alexandia', 'VA','20321', '(703) 000-2112', 'dennisned@gmail.com','A'),
		   ('EMP08', 'Liang', 'Porter', '111-23-8888', '1987-01-01','M',78000,'2017-09-01','825 Victoria Street', '109','Columbia', 'MD','20990', '(249) 890-3200', 'lian@yahoo.com','P'),
		   ('EMP09', 'Sarah', 'Kathrin', '222-23-9999', '1988-03-18','F',90800,'2014-03-02','1389 Finwood Road', '007','Germantown', 'MD','20871', '(191) 890-3212', 'rosie@yahoo.fr','P'),
		   ('EMP10', 'Christopher', 'Rasmussen', '333-23-0000', '1989-03-23','M',62000,'2018-12-02','3520 Nash Street', '002','Washington', 'DC','20021', '(320) 890-9032', 'chris@gmail.com','C'),
		   ('EMP11', 'Ruth', 'Kumar', '444-21-1122', '1990-11-24','F',90200,'2019-03-02','4656 Byrd Lane', 'L21','Arlington', 'VA','20321', '(521) 000-2112', 'ruth@gmail.com','A'),
		   ('EMP12', 'Stefan', 'Xu', '444-23-2233', '1990-09-01','M',68000,'2013-09-01','3583 Stadium Drive', '100','Beltsville', 'MD','20990', '(260) 890-3200', 'stef@yahoo.com','M'),
		   ('EMP13', 'Jessamine', 'Seiler', '555-23-3344', '1982-11-28','F',90200,'2018-03-02','1337 Havanna Street', '498','Clarksburg', 'MD','20871', '(101) 890-3212', 'jes@yahoo.co.uk','M'),
		   ('EMP14', 'Enza', 'Kepa', '666-23-4455', '1990-09-30','F',85300,'2011-12-02','2780 Irish Lane', NULL,'Washington', 'DC','20021', '(511) 890-9032', 'enz@gmail.com','C'),
		   ('EMP15', 'Andrew', 'Kumar', '777-21-5566', '1983-10-25','M',120800,'2010-03-02','3048 James Avenue', 'L21','Fairfax', 'VA','20321', '(911) 000-2112', 'andkum@gmail.com','P'),
		   ('EMP16', 'Ermias', 'Henriksen', '888-23-6677', '1983-09-16','M',78000,'2017-09-01','714 Chica Avenue', NULL,'Laurel', 'MD','20990', '(199) 890-3200', 'ermias@yahoo.com','P'),
		   ('EMP17', 'Petra', 'Seiler', '123-23-3456', '1980-09-07','F',45000,'2018-03-02','123 Ky St', '198','Clarksburg', 'MD','20871', '(101) 890-3212', 'ps@yahoo.com','P'),
		   ('EMP18', 'Peter', 'Kepa', '908-23-3432', '1990-09-07','M',72300,'2018-12-02','907 12 St', NULL,'Washington', 'DC','20021', '(201) 890-9032', 'pk@gmail.com','C'),
	       ('EMP19', 'Dennis', 'Kumar', '093-21-3456', '1983-10-03','M',120800,'2019-03-02','123 Ky St', 'L21','Manassas', 'VA','20321', '(571) 000-2112', 'dk@gmail.com','P'),
		   ('EMP20', 'Gang', 'Xu', '903-23-9056', '1983-09-01','M',79300,'2017-09-01','213 Coles rd', NULL,'Columbia', 'MD','20990', '(240) 890-3200', 'gxu@yahoo.com','P');


INSERT INTO Doctor 
	VALUES  ('EMP10','MD01', 'KNO-09-6667','2017-09-10', 'Senior','Infectious Disease'),
			('EMP12','MD02', 'BAV-00-9456','2016-08-10', 'senior','Family medicine'),
			('EMP04','MD03', 'LIC-22-0678', '2015-12-31','Senior','Intenal Medicine'),
			('EMP17','MD04', 'KAL-16-5420','2018-09-03','Junior','Cardiologist'),
		    ('EMP15','MD06', 'XYZ-66-7600','2017-02-5', 'Junior','Infectious Disease');



INSERT INTO Diagnosis 
	VALUES (1, 'PA003', 'MD03', 1, '2017-11-06', 'Positive'),
		   (2, 'PA009', 'MD02', 5, '2018-02-06', 'Positive'),
		   (3, 'PA012', 'MD01', 2, '2015-09-04', 'Negative'),
		   (4, 'PA005', 'MD02', 3, '2019-11-06', 'Negative'),
		   (5, 'PA014', 'MD04', 4, '2014-10-04', 'Negative'),
		   (6, 'PA001', 'MD02', 5, '2017-10-04', 'Positive'),
		   (7, 'PA004', 'MD01', 6, '2016-11-04', 'Positive'),
		   (8, 'PA011', 'MD03', 2, '2016-11-04', 'Positive'),
		   (9, 'PA001', 'MD04', 2, CURDATE(),'Positive'),
		   (10,'PA002', 'MD03', 3, CURDATE(),'Not conclusive'),
		   (11,'PA003', 'MD02', 3, CURDATE(),'Negative'),
		   (12,'PA004', 'MD01', 3, CURDATE(),'Not conclusive'),
		   (13,'PA005', 'MD02', 2, CURDATE(),'Positive'),
		   (14,'PA006', 'MD03', 2, CURDATE(),'Not conclusive'),
		   (15,'PA007', 'MD04', 1, CURDATE(),'Positive'),
		   (16,'PA008', 'MD03', 3, CURDATE(),'Not conclusive');


INSERT INTO Prescription 
	VALUES (10, 1, '2019-01-02'),
		   (11, 2, '2017-06-02'),
		   (12, 3, '2018-01-02'),
		   (13, 9, '2019-04-2'),
		   (14, 13, '2016-09-12'),
		   (15, 7, '2019-03-25'), 
		   (16, 14, '2019-03-26'), 
		   (17, 16, '2019-03-27'), 
		   (18, 8, '2019-03-26');



INSERT INTO MedicinePrescribed 
	VALUES (10, 3,'As you wish', 10),
		   (14, 2,'As you wish', 12),
		   (12, 5,'As you wish', 6),
		   (11, 1,'As you wish', 9),
		   (13, 4,'As you wish', 7),
		   (18, 4, '3 times daily', 3),
		   (17, 3, '2 times daily', 2),
		   (10, 5, '2 times a day', 3), 
		   (12, 1, '3 times daly', 2);




INSERT INTO PharmacyPersonel 
	VALUES ('EMP02', 'GP-003', '2012-02-06', 86, 'Senior'),
		   ('EMP06', 'CP-073', '2014-04-13', 93, 'Junior'),
		   ('EMP08', 'AB-099', '2017-02-16', 93, 'Junior');





/****************** The SELECT Statement *****************************

SELECT statement
	- SELECT statement is used to query tables and views,

SYNTAX :
	SELECT select_list ` INTO new_table `
	` FROM table_source ` 
	` WHERE search_condition `
	` GROUP BY group_by_expression `
	` HAVING search_condition `
	` ORDER BY order_expression ` ASC | DESC ` `


Has has the following clauses inside, 
	- FROM clause
		: specifies the source of data, table or view
	- WHERE clause
		: search condition / criteria 
	- GROUP BY clause
		: group by list
	- HAVING clause
		: search condition / criteria for out put of GROUP BY clause
	- ORDER BY clause
		: specify the condition to sort results

Sequence of execution/evaluation of SELECT statement. 
	1st : FROM clause
	2nd : WHERE clause
	3rd : GROPUP BY clause
	4th : HAVING clause
	5th : SELECT 
	6th : ORDER BY clause

IMPORTANT : To avoid erros in tables/views name resoulution, it is best to include
	        schema and object name

			If the table/view contains irregular characters such as spaces or other 
			special characters, you need to delimit, or enclose the name, by backtick ``

			End all statements with semicolon (;) character. It is optional to use semi
			colon to terminate SELECT statement, however future versions will require 
			its use, therefore you should adopt the practice.
*/



-- EXERCISE # 01
-- Write SELECT statement to retrive the entire columns of Employee table by explicitly listing each column.
-- NOTE (1) List all the columns to be retrived on SELECT statement
-- NOTE (2) The name of each column must be separated by comma


-- EXERCISE # 02 
-- Repeat the previous exercise, but SSN and DoB must be displated as the 1st and 2nd column
-- NOTE : The order of columns list determine their display, regardless of the order of defination in source table.


-- EXERCISE # 03 
-- Write SELECT statement to retrive the entire columns of Employee table using "star" character (*)
-- NOTE : This method is frequently used for quick test, refrain using this short cut in production environment



-- EXERCISE # 04 
-- Write SELECT statement to retrive empId, empFName, empLName, phoneNo and email columns of Employee table.



/*
-- SELECT statement can be used to perform calculations and manipulation of data
	Operators, 
		'+' : Adding or Concatinate
		'-' : Subtract
		'*' : Multiply
		'/' : Divide
		'%' : Modulo
	The result will appear in a new column, repeated once per row of result set
	Note : Calculated expressions must be Scalar, must return only single value
	Note : Calculated expressions can operate on other colums in the same row
*/

-- EXAMPLE : 
-- Calculate the amount each type of medicine worth in stock


-- EXERCISE # 05 
-- The unit price of each medicine is increased by 6%. Provide the list of medecine with 
-- their respective rise in price.


-- EXERCISE # 06
-- Calculate and display the old and new prices for each medicine 


-- '+' Can be used to as an operator to concatenate (linked together as in a chain) the content of columns
-- EXAMPLE : Get Employee Full Name of all employees


-- EXERCISE # 07
-- Write a code to display employee's Full Address, and Phone Number



-- CONCAT Function
-- Is string function that joins two or more string values in an end-to-end manner.
-- SYNTAX: CONCAT ( string_value1, string_value2, string_value2, ...)
-- EXAMPLE : Write a code to display the Full Name of all employees using CONCAT function



-- EXERCISE # 08
-- Write a code to display employee's Full Address, and Phone Number using CONCAT function


/*
DISTINCT statement
	SQL query results are not truly relational, are not always unique, and not guranteed order
	Even unique rows in a source table can return duplicate values for some columns
	DISTINCT specifies only unique rows to apper in result set
-- 
*/


-- EXAMPLE :
-- Write a code to retrive the year of employement of all employees in Employee table


-- Notice there are redudant instances on the result set. Execute the following code
-- and observer the change of result set


-- EXERCISE # 09
-- Write a code that retrive the list of dosages from MedicinePrescribed table, use DISTINCT to eliminate duplicates


/*
Column Aliases
	- At data display by SELECT statement, each column is named after it's source.
	- However, if required, columns can be relabeled using aliases
	- This is useful for columns created with expressons
	- Provides custom column headers.

Table Aliases
	- Used in FROM clause to provide convenient way of refering table elsewhere 
	  in the query, enhance readability 

*/



-- EXAMPLE : 
-- Display all columns of Disease table with full name for each column


-- EXERCISE # 10 
-- Write the code to display the 10% rise on the price of each Medicine, use appropriate column alias for comoputed column



-- EXERCISE # 11
-- Modify the above code to include the new price column with the name 'New Price'



-- EXAMPLE :
-- Using '=' signs to assign alias to columns


-- EXERCISE # 12
-- Use '=' to assign alias for the new price of all medecines with price rise by 13%



-- EXAMPLE :
-- Using built in function on a column in the SELECT list. Note the name of column is used as input for the function


-- EXAMPLE : 
-- Write a code to display the the first name and last name of all patients. Use table alias to refer the columns



-- EXERCISE # 13 
-- Assign the appropriate aliases for columns displayed on previous exercise. 



-- EXAMPLE
-- The following code will run free from error, since alias dicleration done before alias used by ORDER BY clause


-- EXAMPLE
-- The following code will err out, since alias decleration done after the execution of WHERE clause
SELECT empId AS `Employee ID`, empFName AS `First Name`, empLName AS `Last Name`
FROM Employee
WHERE `First Name` LIKE 'R%';


/*
Simple CASE Expression
	- Can be used in SELECT, WHERE, HAVING AND ORDER BY clauses
	- Extends the ability of SELECT clause to manipulate data as it is retrived
	- CASE expression returns a scalar (single-valued) value based on conditional logic

	- In SELECT clause, CASE behaves as calculated column requiring an alias
	- Forms of CASE expressions
		- Simple CASE
			: Compares one value to list of possible values, returns first match
		- Searched CASE
			 : Evaluate a set of logical expressions & returns value found in THEN clause

CASE Statement Syntax:
	CASE <column name>
	WHEN <value one> THEN <output one>
	WHEN <value two> THEN <output two>
	.
	.
	.
	ELSE <default output>
	END <new alias>

*/

-- EXAMPLE : 
-- Simple CASE 
/* 
First
	ALTER TABLE Disease
	DROP COLUMN dCatery
*/
SELECT * FROM Disease;

-- EXAMPLE : 
-- Searched CASE


-- EXERCISE # 14 
-- Use simple CASE to list the brand names of medecines available as per Medecine Id


-- EXERCISE # 15 
-- Searched CASE to identify label the price of a medicine cheap, moderate and expensive. Price of cheap ones
-- is less than 15 USD, and expensive ones are above 45 USD. Display Medecine Id, Generic Name, the unit price and 
-- catery of the price.  


--  Display MRN, Full Name and Gender (as Female and Male) of all Patients --  use case statement for gender

/*
SORTING DATA
	- Used to desplay the output of a query in certain order
	- Sorts rows in results for presentation purpose
	- Uses ORDER BY clause
	- ORDER BY clause
		 - The last clause to be logically processed in SELECT statement
		 - Sorts all NULLs together
		 - Refers to columns by name, alias or ordinal position (not recommended)
		 - Declare sort order with ASC or DESC

	- SYNTAX :
			SELECT <select_list>
			FROM <table_source>
			ORDER BY <order_by_list> `ASC|DESC`
*/

--  Get Employees earning less that 75000.00


--  Get Patients not in DC Metro Area (not DC, MD, VA)


--  Get patients from FL, VA and TX



--  Get patients Female Patients from FL, VA and TX

-- ORDER BY clause using column names
-- EXAMPLE : Retrive details of Employees in assending order of their first names


--  Also order by last name - and return the names as lastname, firstname


-- EXERCISE # 16
-- Write a code to retrive details of Patients in assending order of last names 



-- EXERCISE # 17 
-- Write a code to retrive details of Employees in descending order of DoB
-- Note : Use column alias on ORDER BY clause


-- EXAMPLE :
-- ORDER BY clause can uses more than one column



/* Some Date related built in functions
	CURDATE() --  Returns datetime
	YEAR() --  returns integer
	MONTH() --  returns integer
	DAY() --  returns integer

*/

-- EXERCISE # 18
-- Display the list of Patients in the order of the year of their treatement. Use their First name to order the ones that came 
-- to the hospital on same year. 

--  Return the year, month and day separately

/*
FITERING DATA
	- Used to retrive only a subset of all rows stored in the table
	- WHERE clause is used to limit which rows to be retured
	- Data filtered server-side, can reduce network trafic and client memory usage

	-WHERE clause 
		- use predicates, expressed as logical conditions
		- rows which predicate evaluates to TRUE  will be accepted
		- rows of FALSUE or UNKNOWNS filitered out
		- in terms of precidence, it follows FROM clause
    *** - can't see the alias declared in SELECT clause
		- can be optimized to use indexes
		 
	SYNTAX : (WHERE clause only )
			WHERE <search_condition>

		- PREDICATES and OPERATORS
			- IN : Determines whether a specified value matches any value in the subquery or list
			- BETWEEN : Specifies an inclusive range to test
			- LIKE : Determines whether a specific character string matches a specified pattern
			- AND : Combines two Boolean expressions and returns TRUE only when both are TRUE
			- OR : Combines two boolean expressions and returns TRUE if either is TRUE.
			- NOT : Reverses the result of a search condition. 

*/

-- EXAMPLE :
-- Find below a code to get Employee information (across all columns) - who are contractors,
-- Note : P: Principal Associate, A: Associate, C: Contractor, M:Manager



-- EXAMPLE :
-- Find below a code to get Employee information (across all columns) -  for Contract and Associate



-- EXERCISE # 19
-- Find the list of employees with salary above 90,000


-- EXERCISE # 20
-- Find the list of employees with salary range betwen 85,000 to 90,000 inclusive



-- EXERCISE # 21
-- Find the list of patients that had registration to the hospital in the year 2018
-- Use 'BETWEEN' operator

--  The above two queries are efficient ones
--  The query below will also return the same result - but considered inefficient (issue related to indexing)



-- EXERCISE # 22
-- Get Employees born in the year 1980 (from 1980-01-01 - 1980-12-31)using 'BETWEEN' operator



-- EXERCISE # 23
-- Get Employees born in the year 1980 using 'AND' operator


-- We can also use the YEAR() function to do the same for the above exercise - but it is NOT recommended



-- EXERCISE # 24
-- Write a code that retrives details of Patients that live in Silver Spring.



-- EXERCISE # 25
-- Write a code retrive the information of contractor Employees with salary less than 75000.



-- EXERCISE # 26
-- Write a code to retrive list of medicines with price below 30 USD.



-- EXERCISE # 27
-- Write a code to retrive patients that live in Miami and Seattle


-- EXERCISE # 28
-- Write a code to retrive patients that are not living in Silver Spring


/*
STRING FUNCTIONS

	- CONCATENATE
		- Returns a character string that is the result of concatenating string_exp2 to string_exp1. 
		- SYNTAX
			CONCAT( string_exp1, string_exp2, ...)

	- LEFT
		- Returns the leftmost count characters of string_exp.
		- SYNTAX
			LEFT( string or string_exp, number_of_characters )
		
		Get three characters from the left of 'Richards'
			Ans: 'Ric'

	- RIGHT
		- To extract a substring from a string, starting from the right-most character.
		- SYNTAX
			RIGHT( string or string_exp, number_of_characters )
		
		Get three characters from the right of 'Richards'
			Ans: 'rds'

	- LOCATE
		- returns the location of a substring in a char/string, from the left side.
		- The search is NOT case-sensitive.
		- SYNTAX :
			LOCATE( substring, string, `start_position` )
			
		-> given a string and character LOCATE function returns the relative location (index) of the first occurrence of that character in the string

		e.g. thus the LOCATE OF 'g' IN String: 'Johansgurg' is 7 

	-LENGTHGTH
		- Returns the number of characters in string_exp, excluding trailing blanks.
		- SYNTAX
			LENGTH( string or string_exp )
		e.g. LENGTH ('Complete') -> 8

	-LTRIM function
		- removes all space characters from the left-hand side of a string.
		- SYNTAX
			LTRIM( string_exp )
	- RTRIM
	- removes all space characters from the right-hand side of a string.
		- SYNTAX
			RTRIM( string_exp )
	- TRIM
	- removes all space characters from the both sides of a string.
		- SYNTAX
			TRIM( string_exp )



*/


-- EXERCISE # 29
-- Write a code to display full name for employees


-- EXERCISE : 30
-- Get the last four digists of SSN of all Employees together with their id and full name


--  Question Write a query to get the Employee with the last four digits of the SSN is '3456'

--  Q2 - Write a query to get the Employee with the last four digits of the SSN is '3456' and with DoB = '1980-09-07'

-- EXERCISE # 31
-- Write a code to retrive the full name and area code of their phone number, use Employee table



-- EXERCISE # 32
-- Write a code to retrive the full name and area code of their phone number, (without a bracket). use Employee table

-- EXAMPLE # 33
-- Run the following codes and explain the result with the purpose of LOCATE function
SELECT LOCATE('O', 'I love SQL');


-- EXERCISE # 34
-- Modify the above code, so that the output/result will have appopriate column name
SELECT LOCATE('O', 'I love SQL') AS `Index for letter 'O'`;


-- EXAMPLE # 35
-- Write a code that return the index for letter 'q' in the sentence 'I love sql'
SELECT LOCATE('q', 'I love SQL') `Index for letter 'Q'`;




-- EXERCISE # 36
-- Use the LOCATE() function to retrieve the house(building) number of all our employees




-- EXAMPLE : 
-- Run the following code and explain the result with the purpose of LENGTH function
SELECT LENGTH('I love SQL');




-- EXAMPLE : 
-- Reterive the email's domain name for the entiere employees. 
-- NOTE : Use LENGTH(), LOCATE() and RIGHT()



-- EXERCISE # 37
-- Assign a new email address for empId=EMP05 as 'sarah.Kathrin@aol.us'
UPDATE Employee
SET email = 'sarah.Kathrin@aol.us'
WHERE empId = 'EMP05';




-- EXERCISE # 38
-- Using wildcards % and _ ('%' means any number of charactes while '_' means single character)
-- mostly used in conditions (WHERE clause or HAVING clause)
-- Get Employees whose first name begins with the letter 'P'



-- EXERCISE # 39
-- Get the list of employees with 2nd letter of their frst name is 'a'



-- EXERCISE # 40
-- Get full name of employees with earning more than 75000. (Add salary information to result set)


-- EXERCISE # 41
-- Get Employees who have yahoo email account
-- NOTE : the code retrives only the list of employee's with email account having 'yahoo.com'



-- EXERCISE # 42
-- Get Employees who have yahoo email account
-- NOTE : Use RIGHT string function. 



-- EXERCISE # 43
-- Get Employees who have yahoo email account
-- NOTE : The code must checke only 'yahoo' to retrive the entire employees with yahoo account


-- EXERCISE # 44 
-- Create a CHECK constraint on email column of Employee table to check if it's a valid email address
-- NOTE : Assume a valid email address contains the '@' character


/*		Aggregate Functions
	
	COUNT() - returns the number of rows satisfying a given condition (conditions)
	AVG() - Returns the arithimetic mean (Average) on a set of numeric values
	SUM() - Returns the Sum of a set of numeric values
	MIN() - Returns the Minimum from a set of numeric values
	MAX() - Returns the Maximum from a set of numeric values
	STDEV() - Returns the Standard Deveiation of a set of numeric values
	VAR() - Returns the Variance of a set of numeric values
*/


-- EXERCISE # 45
-- Get total number of Employees


-- EXERCISE # 46
-- Get number of Employees not from Maryland

-- OR

-- EXERCISE # 47
-- Get the number of Principal Employees, with emptype = 'P')

-- EXERCISE # 48
-- Get the Minimum salary

-- EXERCISE # 49
-- Modify the above code to include the Minimum, Maximum, Average and Sum of the Salaries of all employees


-- EXERCISE # 50
-- Get Average Salary of Female Employees


-- EXERCISE # 51
-- Get Average Salary of Associate Employees (empType = 'A')

-- EXERCISE # 52
-- Get Average salaries for each type of employees?


-- EXERCISE # 53
-- Get Average Salary per gender


-- EXERCISE # 54
-- Get Average Salary per sate of residence


-- EXERCISE # 55
-- Get Employees earning less than the average salary of all employees


/*
NOTE : An aggregate may not appear in the WHERE clause unless it is in a subquery contained in a 
       HAVING clause or a SELECT list, and the column being aggregated is an outer reference.

SUBQUERIES
	- Is SELECT statement nested within another query, (queries within queries)
	- Can be Scalar, multi-valued, or table-valued
		- Scalar subquery : return single value, outer queries handle only single result
		- Multi-valued : return a column table, outer queries must be able to handle multipe results
	- The result of inner query (subquery) are returned to the outer query
	- Enables to enhance ability to create effective queries
	- Can be either Self-Contained or Correlated
	- Self-Contained
		- have no dependency to outer query
	- Correlated
		- one or more column of subquery depends on the outer query.
		- Inner query receives input from the outer query & conceptually executes once per row in it.
		- Writing correlated subqueries
			- if inner query is scalar, use comparision opetators as '=', '<', '>', and '<>'in	WHERE clause
			- if inner query returns multi-values, use and 'IN' predicate 
			- plan to handle 'NULL' results as required.

*/


-- EXERCISE # 58 
-- Get list of Employees with earning less than the average salary of Associate Employees
-- Note : Use a scalar subquery which is self contained to solve the problem


-- EXERCISE # 59 
-- Get Principal Employees earning less than the average of Contractors


-- EXERCISE # 60 
-- Get Principal Employees earning less than or equal to the average salary of Pricipal Employees


-- EXERCISE # 61 
-- Get Contractors earning less than or equal to the average salary of Contractors


-- EXERCISE # 62 
-- Get Associate Employees earning less than or equal to the average salary of Associate Employees


-- EXERCISE # 63 
-- Get Managers earning less than or equal to the average salary of Managers


-- EXERCISE # 64
-- Get the count of Employees based on the year they were born


-- EXERCISE # 65
-- Get list of patients diagnoized by each doctor
-- NOTE : Use multi-valued subquery to get the list of doctors from 'Doctors' table


/*
Note : Here is the logical structure of the outer query for the above example
	   Subqueries that have multi-values will follow the same fashion
	
	SELECT docId,MRN,diagDate,diagResult
	FROM Diagnosis AS D
	WHERE D.docId IN ( MD01, MD02, MD03, MD04  )
	ORDER BY DOCID

*/


-- EXERCISE # 67
-- Get list of patients diagnoized for each disease type
-- NOTE : Use multi-valued subquery to get the list of disease from 'Disease' table


-- EXAMPLE :
-- Get Employees who are earning less than or equal to the average salary of their gender
-- NOTE : Use correlated subquery


-- EXERCISE # 68 
-- Retrieve all Employees earning less than or equal to their groups averages
-- NOTE : Use correlated subquery, 

-- EXAMPLE
-- Better way to deal with previous exercise is to use 'JOIN', run the following and confirm 
-- try to analizye how the problem is sloved, the next section try to introduce about JOINing tables


--  Create one table called - Department (depId, depName, depEstablishmentDate)
--  And also allocate our employees to the departments
USE HRMSDB;

CREATE TABLE Department 
(
	depId CHAR(4) PRIMARY KEY NOT NULL, 
	depName VARCHAR(40) NOT NULL, 
	depEstablishmentDate DATE
);
 
INSERT INTO Department VALUES	('KB10', 'Finance', '2010-10-10'), ('VL20', 'Marketing', '2010-01-10'), ('HN02', 'Medicine', '2010-01-10'),
								('AK12', 'Information Technology', '2015-01-01');

ALTER TABLE Employee
ADD department CHAR(4) NULL;

ALTER TABLE Employee
ADD CONSTRAINT fk_Employee_Department FOREIGN KEY (department) REFERENCES Department(depId);

UPDATE Employee
SET department = 'HN02'
WHERE empId IN ('EMP10','EMP12','EMP04','EMP17','EMP15');

UPDATE Employee
SET department = 'KB10'
WHERE empId IN ('EMP01', 'EMP02', 'EMP03');

UPDATE Employee
SET department = 'VL20'
WHERE empId IN
('EMP05',
'EMP06',
'EMP07',
'EMP08',
'EMP09');

UPDATE Employee
SET department = 'AK12'
WHERE department IS NULL;


-- EXERCISE # 56
-- Note : The answer for the this exercise will be used as subquery to the next question )
-- Get the average salary of all employees


-- EXERCISE # 56.1
--  Get the average salary of employees in each department


-- EXERCISE # 57
-- Get the list of employees with salary less than the average employee's salary
-- Note : Use a scalar subquery which is self contained to solve the problem

 --  EXERCISE 57 -1
 --  Get Employees earning less than or equal to the average salary of thier corresponding departments
 --  We do this in diferent ways
 -- --  Let's use Correlated sub-query
 --  First let's do this one by one
 -- --  Q1: Get Employees working in department 'AK12' and earning less than or equal to the departmental average salary

-- - Q2: Get Employees working in department 'HN02' and earning less than or equal to the departmental average salary

-- - Q3: Get Employees working in department 'KB10' and earning less than or equal to the departmental average salary

-- - Q4: Get Employees working in department 'VL20' and earning less than or equal to the departmental average salary

--  The question is to create one query that returns all the above together



/*
Using 'EXISTS' Predicate with subqueries
	- It evaluates whether rows exist, but rather than return them, it returns 'TRUE' or 'FALSE'
	- Useful technique for validating data without incurring the overhead of retriving and counting the results
	- Database engine optimize execution for query having this form
*/


-- EXAMPLE
-- The following code uses 'EXIST' predicate to display the list of doctors that diagnose a patient



-- EXERCISE # 69
-- Modify the above code to display list of doctor/s that had never diagnosed a patient


-- EXERCISE # 70
-- Write a code that display the list of medicines which are not prescribed to patients


-- EXERCISE # 71
-- Write a code that display the list of medicines which are prescribed to patients



/************ Working with Multiple Tables
 
 Usually it is required to query for data stored in multiple locations,
 Creates intermediate virtual tables that will be consumed by subsequent phases or the query

	- FROM clause determines source of table/s to be used in SELECT statement
	- FROM clause can contain tables and operators
*** - Resulst set of FROM clause is virtual table
		: Subsequent logical operations in SELECT statement consume this virtual table
	- FROM clause can establish table aliases for use by subsequent pharses of query
	
	- JOIN : is a means for combining columns from one (self-join) or more tables by using values 
	         common to each.
	
	- Types of JOINs
		 CROSS JOIN : 
			: Combines all rows in both tables (Creates Carticial product)
		 INNER JOIN ( JOIN )
			: Starts with Cartecian product, and applies filter to match rows 
			  between tables based on predicate
			: MOST COMMONLY USED TO SOLVE BUSINESS PROBLEMS.
		 OUTER JOIN
			: Starts with Cartician product, all rows from designated table preserved,
			  matching rows from other table retrived, Additional NULL's inserted as
			  place holders

			: Types of OUTER JOIN
				: LEFT OUTER JOIN ( LEFT JOIN )
					- All rows of LEFT table is preserved, 
				: RIGHT OUTER JOIN ( RIGHT JOIN )
					- All rows of RIGHT table is preserved, 
				: FULL OUTER JOIN ( FULL JOIN )

*/


-- For demonstration purpose, run the following codes that creates two tables, T1 and T2
-- After inserting some data on each tables view the cross product, 'CROSS JOIN'  of the two tables

CREATE TABLE T1 
	( A CHAR(1),
	  B CHAR(1),
	  C CHAR(1)
	 );


CREATE TABLE T2 
	( A CHAR(1), 
	  Y CHAR(1), 
	  Z CHAR(1)
	 );


INSERT INTO T1 
	VALUES ('a','b','c'), 
		   ('d','e','f'), 
		   ('g','h','i');


INSERT INTO T2 
	VALUES ('a','m','n'),
		   ('X','Y','Z'), 
		   ('d','x','f');



-- First see the content of each table one by one


-- Now get the Cross Product (CROSS JOIN) of T1 and T2


-- Execute the following to get LEFT OUTER JOIN b/n T1 and T2 with condition columns 'A'
-- on both tables have same value


-- Execute the following to get RIGHT OUTER JOIN b/n T1 and T2 with condition columns 'A'
-- on both tables have same value, Notice the difference with LEFT OUTER JOIN


-- Execute the following to get FULL OUTER JOIN b/n T1 and T2 with condition columns 'A'
-- on both tables have same value, Again notice the difference with LEFT/RIGHT OUTER JOINs


-- EXERCISE # 72
-- Get the CROSS JOIN of Patient and Diagnosis tables


-- EXERCISE # 73
-- Get the information of a patient along with its diagnosis. 
-- NOTE : First CROSS JOIN Patient and Diagnosis tables, and retrive only the ones that share the same 'mrn on both tables

-- EXERCISE # 74
--  Retrive MRN, Full Name, Diagnosed Date, Disease Id, Result and Doctor Id for Patient, MRN = 'PA002'


-- EXAMPLE :
-- LEFT OUTER JOIN : Returns all rows form the first table, only matches from second table. 
-- It assignes 'NULL' on second table that has no matching with first table


-- EXERCISE :
-- List employees that are not doctors by profession
-- NOTE : Use LEFT OUTER JOIN as required


-- EXAMPLE : 
-- RIGHT OUTER JOIN : Returns all rows form the second table, only matches from first table. 
-- It assignes 'NULL' on second table that has no matching with second table
-- The following query displays the list of doctors that are not employees to the hospital

-- Obviously all Doctors are employees, hence the result has no instance.


-- EXAMPLE : The following query displays the list of doctors that had never diagnosed 
-- a parient


-- EXERCISE # 75
-- Display the list of medicines that are prescribed by any of the doctor. (Use RIGHT OUTER JOIN)


-- EXERCISE # 76
-- Display the list of medicines that which not prescribed by any of the doctors. (Use RIGHT OUTER JOIN)


-- EXERCISE # 77 
-- Get Patients with their diagnosis information: MRN, Full Name, Insurance Id, Diagnosed Date, Disease Id and Doctor Id
-- You can get this information from Patient and Diagnosis tables


-- EXERCISE # 78 
-- Get Doctors who have ever dianosed a patient(s) with the diagnosis date, mrn 
-- and Disease Id and result of the patient who is diagnosed
-- The result should include Doctor Id, Specialization, Diagnosis Date, mrn of 
-- the patient, Disease Id, Result


-- EXERCISE # 79
-- Add the Full Name of the Doctors to the above query.
-- HINT : Join Employee table with the existing table formed by joining Doctor & Diagnosis tables on previous exercise


-- EXERCISE # 80
-- Add the Full Name of the Patients to the above query.


-- EXERCISE # 81
-- Add the Disease Name to the above query


-- EXERCISE # 82
-- Join tables as required and retrive PresciptionId, DiagnosisId, PrescriptionDate, MedicineId and Dosage


-- EXERCISE # 83
-- Retrive PresciptionId, DiagnosisId, PrescriptionDate, MedicineId, Dosage and Medicine Name


-- EXERCISE # 84
--  Get the MRN, Full Name and Number of times each Patient is Diagnosed


-- EXERCISE # 85
-- Get Full Name and number of times every Doctor Diagnosed Patients


-- EXERCISE # 86
-- Patient diagnosis and prescribed Medicine Information 
-- MRN, Patient Full Name, Medicine Name, Prescibed Date and Doctor's Full Name


/*
OR 

SELECT	DG.mrn `MRN`, CONCAT(P.pFName,' ',P.pLName) `Pateint Full Name`, M.brandName `Medicine Name`, PR.prescriptionDate,
		CONCAT(E.empFName,' ',E.empLName) `Doctor Full Name`
FROM Doctor DR JOIN Diagnosis DG ON DR.docId = DG.docId JOIN Employee E ON DR.empId = E.empId JOIN 
		Patient P ON DG.mrn = P.mrn JOIN Prescription PR ON DG.diagnosisNo = PR.diagnosisNo JOIN 
		MedicinePrescribed MP ON PR.prescriptionId = MP.prescriptionId JOIN Medicine M ON MP.mId = M.mId

*/


/********** Some Join Exercises ***************

	Write Queries for the following

	1- Get Patients' information: MRN, Patient Full Name, and Diagnosed Date of those diagnosed for disease with dId = 3
		(Use filter in Where clause in addition to Joining tables Patient and Diagnosis)

			SELECT P.mrn, CONCAT(P.pFName,' ',P.pLName) AS `PATIENT NAME`,D.diagDate
			FROM PATIENT AS P JOIN DIAGNOSIS AS D ON P.MRN = D.MRN
			WHERE D.DID=3


	2- Get the Employee Id, Full Name and Specializations for All Doctors
		
			SELECT CONCAT(E.empFName,' ',E.empLName) AS `EMPLOYEE NAME`, E.empId, D.Specialization
			FROM Employee AS E JOIN Doctor AS D on e.empId=D.empId

	3- Get Disease Ids (dId) and the number of times Patients are diagnosed for those diseases
	   (Use only Diagnosis table for this)
			- Can you put in the order of (highest to lowest) based on the number of times people diagnosed for the disease?
			- Can you get the top most prevaLENGTHt disease?


			SELECT did, count(did)
			FROM Diagnosis
			GROUP BY did
			ORDER BY count(did)


			SELECT TOP (2) did, count(did)
			FROM Diagnosis
			GROUP BY did
			ORDER BY count(did) DESC


	4- Get Medicines (mId) and the number of times they are prescribed. 
		(Use only the MedicinePrescribed table)
		- Also get the mId of medicine that is Prescribed the most

			SELECT mId, count(mId)
			FROM MedicinePrescribed
			GROUP BY mId
			ORDER BY count(mId)

			-- Medicine that is prescribed the most
			SELECT TOP (2) mId, count(mId)
			FROM MedicinePrescribed
			GROUP BY mId
			ORDER BY count(mId) desc


	5- Can you add the name of the medicines the above query (question 4)? 
		(Join MedicinePrescribed and Medicine tables for this)

			SELECT MP.mId, count(MP.mId), m.BrandName, M.genericName
			FROM MedicinePrescribed AS MP JOIN Medicine as M ON MP.mId=M.mId
			GROUP BY MP.mId,m.BrandName, M.genericName
			ORDER BY count(MP.mId)


	6- Alter the table PharmacyPersonel and Add a column ppId - which is a primary key. You may use INT as a data type
	
			ALTER TABLE PharmacyPersonel ADD ppId INT PRIMARY KEY (ppId) NOT NULL	
	
	
	
	7- Create one table called MedicineDispense with the following properties
		MedicineDispense(
							dispenseNo - pk, 
							presciptionId and mId - together fk
							dispensedDate - defaults to today
							ppId - foreign key referencing the ppId of PharmacyPersonnel table
						)


			CREATE TABLE MedicineDispense
			(
			 dispenseNo INT NOT NULL,
			 prescriptionId INT NOT NULL,
			 mId SMALLINT NOT NULL,
			 dispensedDate DATE DEFAULT CURDATE(),
			 ppId INT NOT NULL,
			 CONSTRAINT PK_MedicineDispense_dispenseNo PRIMARY KEY (dispenseNo),
			 CONSTRAINT FK_MedicineDispense_presciptionId_mId FOREIGN KEY (`prescriptionId`,mId) REFERENCES MedicinePrescribed(`prescriptionId`,mId),
-- 			 CONSTRAINT DEF_MedicineDispense_dispensedDate DEFAULT CURDATE() for dispensedDate,
			 CONSTRAINT FK_MedicineDispense_ppId FOREIGN KEY (ppId) REFERENCES PharmacyPersonel(ppId)		
			)



	8- Add four Pharmacy Personnels (add four rows of data to the PharmacyPersonnel table) - Remember PharmacyPersonnel are Employees
		and every row you insert into the PharmacyPersonnel table should each reference one Employee from Employee table

		   INSERT INTO PharmacyPersonel (empId, pharmacistLisenceNo,licenceDate, PCATTestResult, level, ppId)
				VALUES ('EMP02','GP-003','2012-02-06', 86, 'Out Patient', 1),
					   ('EMP06','HP-012','2015-11-12',  72, 'In Patient',2),
					   ('EMP08','CP-073','2014-04-13',  93, 'Store Manager',3),
					   ('EMP10','GP-082', '2017-06-19', 67, 'Duty Manager',4)


	9- Add six MedicineDispense data

		 INSERT INTO MedicineDispense (dispenseNo, prescriptionId, mId, dispensedDate, ppId)
				VALUES (1,10,3,'2018-03-11',4),
					   (2,11,1,'2017-09-21',3),
					   (3,12,5,'2016-08-26',2),
					   (4,13,4,'2015-04-04',1),
					   (5,17,3,'2014-03-23',2),
					   (6,18,4,'2017-09-28',4)

*/



/*
	SET OPERATIONS :
		-UNION
		-UNION ALL
		-INTERSECT
		-EXCEPT
*/


--  Set Operations on Result Sets
--  To Exemplify this in more detail, let's create below two tables

-- CREATE TABLE HotelCust
-- (
-- 	fName VARCHAR(20),
-- 	lName VARCHAR(20),
-- 	SSN CHAR(11),
-- 	DoB DATE
-- );
-- 

-- CREATE TABLE RentalCust
-- (
-- 	firstName VARCHAR(20),
-- 	lastName VARCHAR(20),
-- 	social CHAR(11),
-- 	DoB DATE,
-- 	phoneNo CHAR(12)
-- );
-- 


-- INSERT INTO HotelCust 
-- 	VALUES	('Dennis', '', '123-45-6789', '2000-01-01'), 
-- 	        ('Belew', 'Haile', '210-45-6789', '1980-09-10'),
-- 			('Nathan', 'Kasu', '302-45-6700', '1989-02-01'), 
-- 			('Kumar', 'Sachet', '318-45-3489', '1987-09-20'),
-- 			('Mahder', 'Nega', '123-02-0089', '2002-01-05'), 
-- 			('Fiker', 'Johnson', '255-22-6033', '1978-05-10'),
-- 			('Alemu', 'Tesema', '240-29-6035', '1982-05-16')


-- INSERT INTO RentalCust 
-- 	VALUES	('Ujulu', 'Obang', '000-48-6789', '2001-01-01','908-234-0987'), 
-- 			('Belew', 'Haile', '210-45-6789', '1980-09-10', '571-098-2312'),
-- 			('Janet', 'Caleb', '903-00-4700', '1977-02-01', '204-123-0987'), 
-- 			('Kumar', 'Sachet', '318-45-3489', '1987-09-20', '555-666-7788'),
-- 			('Mahder', 'Nega', '123-02-0089', '2002-01-05', '301-678-9087'),
-- 			('John', 'Miller', '792-02-0789', '2005-10-25', '436-678-4567')




-- To use UNION, the two tables must be UNION compatable
-- EXAMPLE : Execute the following and explain the result, 

-- EXERCISE # 85 
-- Correct the above code and use 'UNION' operator to get the list of all customers in HotelCustomrs and RentalCustomer 



-- EXERCISE # 86 
-- Use UNION ALL operator instead of UNION and explain the differece on the result/output



-- EXERCISE # 87 
-- Get list of customers in both Hotel and Rental Customers ( INTERSECT )

-- EXERCISE # 88 
-- Get list of customers who are Hotel Customers but not Rental ( EXCEPT )


-- EXERCISE # 89
-- Get list of customers who are Rental Customers but not Hotel  (EXCEPT )




/*********************   STORED PROCEDURES  **************************************
	
- STORED PROCEDURES (Procedure or Proc for short) are named database 
	- Are collections of TSQL statement stored in a database
	- Can return results, manipulate data, and perform adminstrative actions on server
	- Stored procedures can include
		- Insert / Update / Delete
	- objects that encapsualte T-SQL Code (DDL, DML, DQL, DCL)
	- Can be called with EXECUTE (EXEC) to run the encapsulated code
	- Can accept parameters
	- Used as interface layer between a database and application.

	- Used for retrival / insertion / updating and deleting with complex validation
		: 	Views and Table Valued Functions are used for simple retrival
		
	SYNTAX : 
		CREATE PROC <proc name> 
		`optional Parameter list` 
		AS 
			<t-sql code>
		
		;

*/



-- NOTE : use 'usp' as prefix for new procedures, to mean ' User created Stored Procedure'


-- EXAMPLE # 01 
-- Write a code that displays the list of patients and the dates they were diagnosed



-- EXAMPLE # 02
-- Customize the above code to creates a stored proc to gets the same result


-- EXAMPLE # 03
-- Execute the newly created stored procedure, using EXEC



-- EXAMPLE # 04
-- Modify the above procedure disply patients that was diagnosed in the year 2018



-- EXAMPLE # 05
-- Drop the procedure created in the above example




-- EXAMPLE # 06 ` Procedure with parameter/s `
-- Create a proc that returns Doctors who diagnosed Patients in a given year




-- EXAMPLE # 07 ` Procedure with DEFAULT values for parameter/s`
-- Create a proc that returns Doctors who diagnosed Patients in a given year. The same procedure 
-- will display a message 'Diagnosis Year Missing' if the year is not given as an input. 
-- NOTE : If no specific year is entered, NULL is a default value for the parameter




-- EXERCISE # 01 
-- Create a stored procedure that returns the the average salaries for each type of employees.
-- NOTE : use 'usp' as prefix for new procedures, to mean ' user created stored procedure'


-- It is also possible to use 'PROC' instead of 'PROCEDURE', 



-- It is also possible to use 'EXEC' instead of 'EXECUTE', 





-- EXERCISE # 02
-- Create a stored procedure to get list of employees earning less than the average salary of 
-- all employees
-- NOTE : use 'usp' as prefix for new procedures, to mean ' user created stored procedure'




-- EXERCISE # 03
-- Create a procedure that returns list of Contractors that earn less than average salary of Principals

-- EXERCISE # 04 (*)
-- Create a proc that returns Doctors who diagnosed Patients in a year 2017
-- NOTE : (1) The result must include DocId, Full Name, Specialization, Email Address and DiagnosisDate




-- EXERCISE # 05 (*)
-- Create a stored proc that returns list of patients diagnosed by a given doctor. 






-- EXERCISE # 06 (*)
-- Create a stored procedure that returns the average salary of Employees with a given empType






-- EXERCISE # 07 (*)
-- Create a stored Proc that returns the number of diagnosis each doctor made in a 
-- given month of the year -> pass both month and year as integer values





-- Putting the parameters in correct order when the procedure is defined
-- Sequence of the parmeters matter


-- Assigning the parameters when the procedure is called, 
-- Sequene of the parameters does't matter



/*

USING STORED PROCEDURES - STORED FUNCTION FOR DML
 
Stored procs are mainly used to perform DML on tables or views
Stored Procs to insert data into a table

*/



-- EXAMPLE # 08
-- Create a proc that is used to insert data into the Disease table
DELIMITER //
CREATE PROCEDURE sp_Insert_Disease(IN p_did int, IN p_dname varchar(100),IN p_dcat Varchar(50), IN p_dtype Varchar(40))
BEGIN
	INSERT INTO Disease(did, dName, dCategory, dType) VALUES (p_did, p_dname, p_dcat, p_dtype);
END//


CALL sp_Insert_Disease (10, 'Covid 19', 'Viral infections', 'Contageous');

SELECT * FROM Disease;

-- EXERCISE # 09
-- Create a procedure to insert data into Doctors table,



-- Confirm for the insertion of new record using SELECT statement



-- EXERCISE # 10
-- Create a stored Proc to deletes a record from RentalCust table with a given SSN 



-- EXERCISE # 11
-- Create the stored procedure that delete a record of a customer in HotelCust table for a given SSN
-- The procedure must display 'invalid SSN' if the given ssn is not found in the table


-- EXERCISE # 12
-- Write a stored procedure to delete a record from RentalCust for a given SSN. If the SSN is not found
-- the procedure deletes the entire rows in the table.
-- NOTE : First take backup for Employee table before performing this task. 


-- EXERCISE # 13
-- Write a code that displays the list of customers with the middle two numbers of their SS is 45



-- EXERCISE # 14
-- Create a Proc that Deletes record/s from RentalCustomer table, by accepting ssn as a parameter. 
-- The deletion can only happen if the middle two numbers of SSN is 45

--  Now test the sp


-- EXERCISE # 15
-- Create a procedure that takes two numeric characters, and delete row/s from RentalCust table 
-- if the middle two characters of the customer/s socal# are same as the passed characters 



-- EXERCISE # 16
-- STORED PROCEDURES to update a table
-- Create an stored procedure that updates the phone Number of a rental customer, for a given customer
-- Note : The procesure must take two parameters social and new phone number



-- EXERCISE # 17
-- Create a stored procedure that takes backup for RentalCust table into RentalCust_Archive table
-- Note : RentalCustArchive table must be first created.



-- EXERCISE # 18
-- Create a stored procedure that takes backup for HotelCust table into HotelCustArchive table
-- Note : Use 'EXECUTE' command to automatically create and populate HotelCustArchive table.



-- Exercise - 17
-- Recreate the above stored proc such that, it shouldn't delete (purge the data) before making
-- sure the data is copied. Hint: use conditions (IF...ELSE) and TRY ... CATCH clauses


--  A simpler version of the above Stored Proc - with no dynamic date value appending to table name


/*
-- ************************************  VIEWS  *****************************************************

	VIEWS
		- Quite simply VIEW is saved query, or a copy of stored query, stored on the server
		- Is Virtual Table - that encapsulate SELECT queriey/es
****	- It doesn't store data persistantly, but creates a Virtual table.
		- Can be used as a source for queries in much the same way as tables themselves
				: Can also be used to Join with tables
		- Replaces commonly run query/ies
		- Can't accept input parameters (Unlike Table Valued Functions (TVFs))

		- Components
			: A name
			: Underlaying query

		- Advantages
			- Hides the complexity of queries, (large size of codding)
			- Used as a mechanism to implement ROW and COLUMN level security
			- Can be used to present aggregated data and hide detail data

		- SYNTAX 
			: To create a view: 

					CREATE VIEW <view name> 
					AS 
						<Select statement>
					
			: To modify

					ALTER VIEW <view name>
					AS 
						<Select statement>
					
			: To drop
					DROP VIEW statement
					AS 
						<Select statement>
					
					
	At view creation, '' acts as delimiter to form a batch.  

	To display the code, use 'sp_helptext' for a stored procedure
		Syntax : 'sp_helptext < view_name >

*/


-- EXAMPLE - View # 01 
-- Write a code that displays patient's MRN, Full Name, Address, Disease Id and Disease Name



-- EXAMPLE - View # 02
-- Create simple view named vw_PatientDiagnosed using the above code.  


-- EXAMPLE - View # 03
-- Check the result of vw_PatientDiagnosed by SELECT statement


-- EXAMPLE - View # 04
-- Use vw_PatientDiagnosed and retrieve only the patients that came from MD
-- Note : It is possible to filter Views based on a criteria, similar with tables

-- EXAMPLE - View # 05
-- Modify vw_PatientDiagnosed so that it returns the patients diagnosed in year 2017 


-- EXAMPLE - View # 06
-- Check the result of modified vw_PatientDiagnosed by SELECT statement



-- EXERCISE - View # 01
-- Create a view that returns Employees that live in state of Maryland, (Employee empId, FullName, DOB)




-- EXERCISE - View # 02
-- Create view that displays mId, Medicine ID and the number of times each medicine was 
-- prescribed.



-- EXERCISE - View # 03
-- Join vw_MedicinePrescribed with Medicine table and get mId, brandName, genericName and 
-- number of times each medicine was prescribed  



-- EXERCISE - View # 04
-- Create a view that displays all details of a patient along with his/her diagnosis details



-- EXERCISE - View # 05
-- Use the view created for 'EXERCISE - View # 04' to get the full detail of the doctors



-- EXERCISE - View # 06 (*)
-- Create the view that returns Contract employees only, empType='C'



-- EXERCISE - View # 07 (*)
-- Create the view that returns list of female employees that earn more 
-- than the average salary of male employees



-- EXERCISE - View # 08 (*)
-- Create the view that returns list of employees that are not doctors



-- EXERCISE - View # 09 (*)
-- Create the view that returns list of employees that are not pharmacy personel



-- EXERCISE - View # 10 (*)
-- Create the view that returns empid, full name, dob and ssn of doctors and pharmacy personels



-- EXERCISE - View # 11 (*)
-- Create the view that returns list of medicines that are not never prescribed. 



-- EXERCISE - View # 12 (*)
-- Create the view that returns list of patients that are not diagnosed for a disease 'Cholera'



-- EXERCISE - View # 13 (*)
-- Create the view that returns list of employees that earn less than employees averge salary



-- EXERCISE - View # 14 (*)
-- Create simple view on Disease table vw_Disease that dispaly entire data



-- EXERCISE - View # 15 (*)
-- Create view that returns list of doctors that had never done any diagnossis. 



-- EXERCISE - View # 16 (*)
-- Use view, vw_Disease, to insert one instance/record in Disease table

-- EXERCISE - View # 17 (*)
-- Use view, vw_Disease, to delete a record intered on previous exercise.


-- EXERCISE - View # 18 (*)
-- Create simple view on Medicine table vw_Medicine that dispaly entire data



-- EXERCISE - View # 19 (*)
-- Insert data into the Medicine table using vw_Medicine

--  INSERT INTO vw_Medicine VALUES (13, 'Asprine', 'No name', 2000, 'Pain killer','2024-02-09', 0.35)


/*
NOTE : Data insertion by views on more than one tables (joined) is not supported
     : Data insertion on joined tables is supported by triggers
*/



-- EXERCISE - View # 20 (*)
-- Create a view, vw_PatientAndDiagnosis, by joining patient and diagnosis tables and 
-- try to insert data into vw_PatientDiagnosis view and explain your observation



/*******************    COMMON TABLE EXPRESSIONS (CTEs)        ***************************************


                           COMMON TABLE EXPRESSIONS (CTEs)

		- It is a TEMPORARY result set, that can be referenced within a SELECT, INSERT,
		  UPDATE or DELETE statements that immediately follows the CTE.
		- Is a named table expressions defined in a query
		- Provides a mechanism for defining a subquery that may then be used elsewhere in a query
*****	- Should be used after the statement that created it
		- Defined at the beginning of a query and may be refernced multiple times in the outer query
		- Defined in 'WITH clause'
		- Does not take parameter (unlike views, functions and stored procedures)
		- Does not reside in database (unlike views, functions and stored procedures)

	Syntax:

		WITH <CTE_name> `Optional Columns list corresponding to the values returned from inner select`
		AS	(
				<Select Statement>
			)
		...
		...
		...
		< SELECT query where the CTE is utilized >

*/


-- EXAMPLE - CTE # 01
-- Create a CTE that returns medicines and number of times they are prescribed (mId, NumberOfPrescriptions)
-- Then join the created CTE with Medicine table to get the name and number of prescription of the medecines



-- EXAMPLE - CTE # 02
-- Create CTE that returns the average salaries of each type of employees


-- EXERCISE - CTE # 01
-- Modify the above code to sort the output by empType in descending order. 


-- EXERCISE - CTE # 02
-- Create CTE to display PrescriptionId, DiagnossisNo, Prescription Date for each patient. Then use  
-- the created CTE to retrive the dossage and number of allowed refills. 

-- EXERCISE - CTE # 03 (*)
-- Create CTE to display the list of patients. The result must include mrn, full name, gender, dob and ssn.

-- EXERCISE - CTE # 04 (*)
-- Modify the above script to make use of the CTE to display the name of a disease
-- each patient is diagnosed 



-- EXERCISE - CTE # 05 (*)
-- Create CTE to display DiagnossisNo, DiagnossisDate and Disease Type of all Diagnossis made. Later use the CTE 
-- to include the rank of the specialization and rank of the doctor. 


-- EXERCISE - CTE # 06 (*)
-- Modify the above code, to incude doctor's full name and dob. 




-- EXERCISE - CTE # 07 (*)
-- Create CTE that returns the average salaries of each type of employees. Then use the same CTE
-- to display the list of employees that earn less than their respective employee type average salaries

-- EXERCISE - CTE # 08 (*)
-- Create CTE that calculates the average salaries for each type of employees




-- EXERCISE - CTE # 09 (*)
-- Use the CTE created for 'EXERCISE - CTE # 09' and provide the list of employees that earn less more than
-- the average salary of their own gender.




-- EXERCISE - CTE # 10 (*)
-- Create CTE that calculates the average salaries for female employees. Use the created CTE to display
-- list of male employees that earn less than the average salary of female employees.





/*********************************    TRIGGERS    ***********************************************

TRIGGERS - 
	- Are a special type of stored procedures that are fired/executed automatically in response
	  to a triggering action
	- Helps to get/capture audit information
	- Like stored procedures, views or functions, triggers encapsulate code.  
	- Triggers get fired (and run) by themselves only when the event for which they are 
	  created for occurs, i.e. We do not call and run triggers, they get fired/run 
	  by by their own


	Types of triggers
		- DML triggers
			: Fires in response to DML events (Insert/Delete/Update)
		- DDL triggers
			: Fires in response to DDL events (Create/Alter/Drop)
		- login triggers
			: Fires in response to login events

	DML Triggers
		There are two types of DML Triggers: AFTER/FOR and INSTEAD OF, and there are 
		three DML events (INSERT, DELETE and UPDATE) under each type - 

				AFTER	INSERT
						DELETE
						UPDATE

				BEFORE	INSERT
						DELETE
						UPDATE

		
	Syntax: 
		Whenever a trigger is created, it must be created for a given table, and for a 
		specific event, 
		
		CREATE TRIGGER <trigger name>                         --  name of the trigger
		ON <table name>										  --  name of table
		<AFTER | BEFORE INSERT/DELETE/UPDATE>         --  specific event 
		AS 
			BEGIN
				<your t-sql statement>
			END	


	Uses for triggers:
		- Enforce business rules
		- Validate input data
		- Generate a unique value for a newly-inserted row in a different file.
		- Write to other files for audit trail purposes
		- Query from other files for cross-referencing purposes
		- Access system functions
		- Replicate data to different files to achieve data consistency

*/



-- EXERCISE - TRIGGER # 01 (AFTER) UPDATE
-- Create a trigger that displays a message 'Disease table is updated' when the table gets updated 



-- First check the content dType for dId=5 before updating

-- Update the table, 


-- Check the table after update, 


-- Drop/Delete a trigger


-- EXERCISE - TRIGGER # 02 (AFTER INSERT)
-- Create a trigger that displays a message 'New disease is inserted' when a new record gets 
-- instered on disease table



-- EXERCISE - TRIGGER # 03 (AFTER) DELETE
-- Create a trigger that displays a message 'A record is deleted from HotelCust table' when a new record gets 
-- deleted from HotelCust table




-- EXERCISE - TRIGGER # 04 (BEFORE INSERT)(*)
-- Create a trigger that displays a message 'A new record was about to be inserted into HotelCust table' when 
-- a new record was about to be inserted on HotelCust table




-- EXERCISE - TRIGGER # 05 (INSTEAD OF UPDATE) (*)
-- Create a trigger that displays a message 'A record was about to be UPDATED into Medicine table' when 
-- a record was about to be updated on Medicine table



-- EXERCISE - TRIGGER # 06 (BEFORE DELETE) (*)
-- Create a trigger that displays a message 'A record was about to be DELETED from RentalCust table' when 
-- a record was about to be deleted on RentalCust table



/*
The use of 'inserted' table and 'deleted' table by triggers.

	- DML trigger statements use two special tables: the deleted table and the inserted tables. 
	- SQL Server automatically creates and manages these two tables. 
	- They are temporary, that only lasts within the life of trigger
	- These two tables can be used to test the effects of certain data modifications 
	  and to set conditions for DML trigger actions.

	- In DML triggers, the inserted and deleted tables are primarily used to perform the following:
		- Extend referential integrity between tables.
		- Insert or update data in base tables underlying a view.
		- Test for errors and take action based on the error.
		- Find the difference between the state of a table before and after a data 
		  modification and take actions based on that difference.


**** - The deleted table stores copies of the affected rows during DELETE and UPDATE statements.
***  - The inserted table stores copies of the affected rows during INSERT and UPDATE statements. 


*/


-- EXERCISE - TRIGGER # 07  (Using 'inserted' table)
-- Create a trigger that displays the inserted record on RentalCust table


-- EXAMPLE - TRIGGER # 08  (Using 'deleted' table)

-- EXAMPLE - TRIGGER # 09  (Using 'deleted' table)
-- Create following audit table, that maintains/captures the records deleted/removed from HotelCust
-- and create a trigger that inititate data backup when a record is deleted from HotelCust table 
-- Note : Use FOR/AFTER DELETE trigger as required.


-- EXERCISE - TRIGGER # 10  (Using 'inserted' table)
-- Create Audit table, RentalCustInsertAudit, that maintains/captures the records inserted 
-- on RentalCust table. The audit table also capture the date the insertion took place
-- Note : Use FOR/AFTER INSERT trigger as required.


-- EXERCISE - TRIGGER # 11  (AFTER INSERT TRIGGER, Application for Audit) (*)
-- Create Audit table, Medicine_Insert_Audit, that maintains/captures the new mId, BrandName, 
-- the person that made the entery, the date/time of data entery.
-- Use system function 'SYSTEM_USER' to get login detail of the user that perform data insertion


-- Now create a trigger that automagically inserts data into the MedicineInsertAudit table, 
-- whenever data inserted into Medicine table


-- Test how the trigger works by inserting one row data to Medicine table


-- EXERCISE - TRIGGER # 12 (AFTER DELETE TRIGGER, Application for Archive) (*)
-- Create and use archieve table, Disease_Delete_Archive, that archieves the disease information
-- deleted from Disease table. The same table must also capture the time and the person 
-- that does the delete.
-- NOTE : Use system function SYSTEM_USER to return the system user.      


-- EXERCISE - TRIGGER # 13  (*)
-- Create a trigger that displays the following kind of message when a record is deleted from HotelCust table.
-- Assume the record for 'Abebe' is deleted, the trigger should display
-- 			'A record for Abebe is deleted from HotelCust table'  



-- EXERCISE - TRIGGER # 14 (AFTER UPDATE TRIGGER, Application for audit) (*)
-- Create an After Update Trigger on Employee table that documents the old and new salary information of 
-- an Employee and the date salary update was changed. 
-- First create EmployeePromotionTracker (empId, promoDate, oldSalary, newSalary)



-- Now check the tigger by updating one employee salary
-- First check the data in both tables



-- EXERCISE - TRIGGER # 15  ( AFTER UPDATE )
-- Create the following audit table, RentalCust_Update_Audit, and code a trigger that 
-- can maintains/captures the updated record/s of RentalCust table.
 
-- Assume both the fist name and DoB changed during update, The 'Message' column should capture 
-- a customized statement as follows
-- 	  'First Name changed from 'Abebe' to 'Kebede', DoB changed from 'old DoB' to 'new DoB'

-- Similarly the 'Message' column should be able to capture all the changes that took place.



-- EXERCISE - TRIGGER # 16 (*)
-- Create Medicine_Audit table, with two columns having Integer with IDENDITY function and description - nvarchar(500) 
-- data types. The table must insert a description for the changes made on Medicine table during UPDATE




-- EXERCISE - TRIGGER # 18 (After Delete Trigger ) (*)
-- Create a trigger that archieve the list of Terminated/Deleted Employees.


-- Problem analysis :
-- The employee can be a Doctor, PharmacyPersonel or Just Employee. Since, Doctor and 
-- PharmacyPersonnel tables depend on the Employee table, we need to first redfine the foreign keys
-- to allow employee delete - with cascading effect. Then the next chalLENGTHge is, deleting a Doctor
-- also affecs the Diagnosis table, we should redefine the foreign key between Doctor and Diagnosis
-- table to allow the delete - with SET NULL effect


-- Steps to follow,
-- Step (1): Drop the Foreign Key Constraints from the Doctor, PharmacyPersonel, Diagnosis, and MedicineDispense tables
--           and redefine FK constraints for all child tables
-- Step (2): Create the Employee_Terminated_Archive table
-- Step (3): Create the trigger that inserts the deleted employee data into Employee_Terminated_Archive



-- Step (1): Drop the Foreign Key Constraints from the Doctor, PharmacyPersonel, Diagnosis, and MedicineDispense tables
--           and redefine FK constraints for all child tables


-- : Now redefine the Constraints


-- Step 2: Create the Employee_Terminated_Archive table


-- Step3: Create the trigger that inserts the deleted employee data into Employee_Terminated_Archive table 
-- by checking the role of the employee


-- Now test the trigger at work  by deleting an Employee - employee data will be archived, but 
-- the employee role wont be set as expected



-- EXERCISE - TRIGGER # 19 (*)
-- Modify the above trigger and archieve table to include the role of the employee if he/she is Doctor 
-- or PharmacyPersonel, and the date the employee was terminated.



-- Step3: Create the trigger that inserts the deleted employee data into Employee_Terminated_Archive table by checking the role of the employee



-- Now test the trigger at work  by deleting an Employee - employee data will be archived, but 
-- the employee role wont be set as expected


-- EXAMPLE - TRIGGER (Instead of Delete Trigger )
-- The above requirement can better be fulfilled within INSTEAD OF DELETE trigger as follows:
-- DROP TRIGGER trg_Instead_Of_Delete_Employee_Termination 


-- Now test deleting an employee that is a 1) Doctor 2) PharmacyPersonel and 3)any other employee



-- EXERCISE - TRIGGER # 20 ( Instead of Delete Trigger ) (*)
-- Create an Instead of delete trigger on Diagnosis table, that simply prints a warning 'You can't delete Diagnosis data!'




-- EXERCISE - TRIGGER # 19 - TRIGGER # 06  ( AFTER UPDATE )
-- Create the following audit table, RentalCust_Update_Audit, and code a trigger that 
-- can maintains/captures the updated record/s of RentalCust table. 



-- EXERCISE - TRIGGER # 21 ( Using triggers to insert data into multiple tables )
-- Inserting data into a view that is created from multiple base tables
-- First create the view - e.g. a view on Doctor and Employee tables ( vw_DoctorEmployee )



--  There are times where we want to insert data into tables through views,
--  Assume that we hired a doctor (an employee) having all the employee and doctor information; 
--  for this we want to insert data into both tables through the view vw_DoctorEmployee
--  But this will not  as intended, because of multiple base tables.... see below



-- Above insert statement will error out as follows
-- Error: 
-- Msg 4405, Level 16, State 1, Line 1763
-- View or function 'vw_DoctorEmployee' is not updatable because the modification affects multiple base tables.

-- Now create an instead of insert trigger on the view vw_DoctorEmployee -> that takes the data and inserts into 
-- the tables individually



--  Now retry the above insert statement


