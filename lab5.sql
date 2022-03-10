USE Hospital;

-- 3 TABLES:  

-- Department: 1PK, no FK
-- Appointment: 1PK, 1FK
-- PatientTakesMedication: multicolumn PK


-- 3 VIEWS

-- select on 1 table
GO
CREATE OR ALTER VIEW first_view AS
	SELECT P.patient_id, P.patient_last_name, P.patient_first_name
	FROM Patient P
	WHERE P.diagnose_id = 1
GO
SELECT * FROM first_view;

-- select on 2 tables
GO 
CREATE OR ALTER VIEW second_view AS 
	SELECT P.patient_id, P.patient_last_name, P.patient_first_name
	FROM Patient P
	WHERE P.patient_id IN
			(SELECT A.patient_id 
			FROM Appointment A
			WHERE A.app_date = '2021-11-02')
GO

SELECT * FROM second_view;
-- select on 2 tables with GROUP BY -- number of doctors (at least 1) that are working in the same department and the department ID 
GO
CREATE OR ALTER VIEW third_view AS 
	    SELECT COUNT(D.doc_id) AS number_of_doctors, D.department_id
		FROM Doctor D 
		GROUP BY D.department_id
		HAVING 1 < (SELECT COUNT(*)
					FROM Doctor D2
					WHERE D2.department_id = D.department_id);
GO
SELECT * FROM third_view;




SELECT * from Patient;
SELECT * FROM Doctor;
SELECT * FROM Department;
SELECT * FROM PatientDischarge;
SELECT * FROM Diagnose;
SELECT * FROM Medication;
SELECT * FROM PatientTakesMedication;
SELECT * FROM Appointment;
SELECT * FROM NurseInfo;
SELECT * FROM PatientsAndNurses;
SELECT * FROM Delivery;
SELECT * FROM MedicationDelivery;
SELECT * FROM HospitalInfo;

-- GET RANDOM NUMBER
GO
CREATE OR ALTER VIEW rand_view
AS
	SELECT RAND() AS VALUE
GO

GO
CREATE FUNCTION random_between(@first INT, @last INT) RETURNS INT AS
		BEGIN
			RETURN FLOOR((SELECT VALUE FROM rand_view)*(@last-@first)+@first);
		END
GO 

--PRINT dbo.random_between(1,9);

-- DELETE

DELETE FROM Appointment;
DELETE FROM PatientTakesMedication;
DELETE FROM PatientsAndNurses;
DELETE FROM PatientDischarge;
DELETE FROM Patient;
DELETE FROM Doctor;
DELETE FROM Department;
DELETE FROM Diagnose;
DELETE FROM NurseInfo;
DELETE FROM MedicationDelivery;
DELETE FROM Delivery;
DELETE FROM Medication;
DELETE FROM HospitalInfo;

-- DELETE FROM TABLE 
GO
CREATE OR ALTER PROCEDURE delete_table @table VARCHAR(40) AS
		DECLARE @cmd varchar(40)
		IF @table = 'Department' -- delete by department name
		BEGIN 
			DELETE FROM Department
			WHERE Department.dep_name = 'DEP_NAME'
		END

		ELSE IF @table = 'Appointment' -- delete by date
		BEGIN
			DELETE FROM Appointment
			WHERE app_date = CAST(GETDATE() AS DATE)
		END

		ELSE IF @table = 'PatientTakesMedication' -- delete by med_id
		BEGIN
			DELETE FROM PatientTakesMedication
			WHERE med_id = 27
		END
GO


-- INSERT INTO TABLES
GO
CREATE OR ALTER PROCEDURE insert_table @table VARCHAR(40), @rows INT AS
	DECLARE @crt INT, @cmd varchar(40)
	DECLARE @mx INT
	IF @table = 'Department'
	BEGIN
		SET @crt = 1
		WHILE @crt <= @rows
		BEGIN
			INSERT INTO Department(dep_id, dep_name) VALUES (@crt, 'DEP_NAME')
			SET @crt = @crt + 1
		END
	END

	ELSE IF @table = 'Appointment'
	BEGIN
		SET @crt = 1
		SET @mx = (SELECT MAX(patient_id) FROM Patient)
		WHILE @crt <= @rows
		BEGIN
			IF @crt <= @mx
			BEGIN
				return
			END		
			INSERT INTO Appointment(app_id, patient_id, app_date) VALUES (@crt, @crt, CAST(GETDATE() AS DATE))
			SET @crt = @crt + 1
		END
	END

	ELSE IF @table = 'PatientTakesMedication'
	BEGIN
		SET @crt = 1
		SET @mx = (SELECT MAX(patient_id) FROM Patient)
		WHILE @crt <= @rows
		BEGIN
			IF @crt > @mx
			BEGIN
				return
			END		
			INSERT INTO PatientTakesMedication(patient_id, med_id) VALUES (@crt, 27)
			SET @crt = @crt + 1
		END
	END
GO

-- ADD TABLE 
CREATE OR ALTER PROCEDURE add_test_table
	@table_name varchar(50),
	@test_name varchar(50),
	@rows int,
	@position int
	AS
		BEGIN
			IF @position <= 0 
			BEGIN
				PRINT 'Position cannot be a negative number!'
				RETURN
			END
			IF @rows <=0
			BEGIN
				PRINT 'Rows cannot be a negative number'
				RETURN
			END

			DECLARE @test_id INT, @table_id INT
			SET @test_id = (SELECT TestID FROM Tests WHERE Name = @test_name)

			SET @table_id = (SELECT TableId FROM Tables WHERE Name = @table_name)
			
			INSERT INTO TestTables VALUES (@test_id, @table_id, @rows, @position)
			
		END
GO

-- ADD VIEW
GO 
CREATE OR ALTER PROCEDURE add_test_view @view_name varchar(50), @test_name varchar(50) AS
BEGIN
	DECLARE @test_id INT, @view_id INT

	SET @test_id = (SELECT TestID FROM Tests WHERE Name = @test_name)
	SET @view_id = (SELECT ViewID FROM Views WHERE Name = @view_name)
	
	INSERT INTO TestViews VALUES (@test_id, @view_id) 
END
GO


-- MAIN

CREATE OR ALTER PROCEDURE run_test @test_name varchar(40) AS
BEGIN
	DECLARE @tid INT
	SET @tid = (SELECT TestID FROM Tests WHERE Name = @test_name) -- get test id for the given test name

	INSERT INTO TestRuns(Description) VALUES ('TESTS FOR ' + (SELECT Name FROM Tests WHERE TestID = @tid)) -- insert description into TestRuns

	DECLARE @testRunID INT
	--SET @testRunID = dbo.random_between(1,999)
	SET @testRunID = (SELECT MAX(TestRunID) FROM TestRuns)

	DECLARE @tname VARCHAR(40)
	SET @tname = (SELECT T.Name 
				FROM Tests T	
				WHERE T.TestID = @tid)

	DECLARE @rows INT
	DECLARE @tableID INT
	DECLARE @tableName VARCHAR(40)
	DECLARE @start DATETIME
	DECLARE @end DATETIME
	DECLARE @viewID INT
	DECLARE @viewName VARCHAR(40)

	-- DELETE CURSOR 
	DECLARE DeleteCursor CURSOR FOR 
	SELECT TableID, NoOfRows
	FROM TestTables
	WHERE TestID = @tid
	ORDER BY Position ASC

	DECLARE @testStart DATETIME
	DECLARE @testEnd DATETIME

	SET @testStart = GETDATE() --start test for TestRuns

	OPEN DeleteCursor

	FETCH NEXT 
	FROM DeleteCursor
	INTO @tableID, @rows

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @tableName = (SELECT T.Name FROM Tables T WHERE T.TableID = @tableID)
		EXEC delete_table @tableName

		FETCH NEXT 
		FROM DeleteCursor
		INTO @tableID, @rows
	END

	CLOSE DeleteCursor
	DEALLOCATE DeleteCursor

	-- INSERT CURSOR
	DECLARE InsertCursor CURSOR FOR
	SELECT TableID, NoOfRows
	FROM TestTables
	WHERE TestID = @tid
	ORDER BY Position DESC

	OPEN InsertCursor

	FETCH NEXT 
	FROM InsertCursor
	INTO @tableID, @rows

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @tableName = (SELECT Name FROM Tables WHERE TableID = @tableID)

		SET @start = GETDATE()
		EXEC insert_table @tableName, @rows
		SET @end = GETDATE()

		INSERT INTO TestRunTables(TestRunID, TableID, StartAt, EndAt) VALUES (@testRunID, @tableID, @start, @end)

		FETCH NEXT 
		FROM InsertCursor
		INTO @tableID, @rows
	END

	CLOSE InsertCursor
	DEALLOCATE InsertCursor

	-- VIEW CURSOR
	DECLARE ViewCursor CURSOR FOR
	SELECT ViewID
	FROM TestViews
	WHERE TestID = @tid

	OPEN ViewCursor

	FETCH NEXT 
	FROM ViewCursor
	INTO @viewID

	WHILE @@FETCH_STATUS = 0
	BEGIN
		SET @viewName=(SELECT Name FROM Views WHERE ViewID = @viewID)

		SET @start = GETDATE()

		IF @viewName = 'first_view'
		BEGIN
			SELECT * FROM first_view
		END

		ELSE IF @viewName = 'second_view'
		BEGIN
			SELECT * FROM second_view
		END

		ELSE IF @viewName = 'third_view'
		BEGIN
			SELECT * FROM third_view
		END

		SET @end = GETDATE()

		INSERT INTO TestRunViews(TestRunID, ViewID, StartAt, EndAt) VALUES (@testRunID, @viewID, @start, @end)

		FETCH NEXT 
		FROM ViewCursor
		INTO @viewID
	END

	CLOSE ViewCursor
	DEALLOCATE ViewCursor

	SET @testEnd = GETDATE()

	UPDATE TestRuns 
	SET StartAt = @testStart, EndAt = @testEnd
	WHERE TestRunID = @testRunId

END
GO

DELETE FROM Tables
DELETE FROM Tests
DELETE FROM Views
DELETE FROM TestRunTables
DELETE FROM TestRunViews
DELETE FROM TestRuns
DELETE FROM TestTables
DELETE FROM TestViews

INSERT INTO Tables VALUES ('Appointment'), ('Department'), ('PatientTakesMedication')
INSERT INTO Views VALUES ('first_view'), ('second_view'), ('third_view')
INSERT INTO Tests VALUES ('test_1'), ('test_2'), ('test_3')

EXEC add_test_table 'Appointment', 'test_1', 10, 1
EXEC add_test_table 'Department', 'test_1', 10, 2
EXEC add_test_table 'Department', 'test_2', 10, 2
EXEC add_test_table 'PatientTakesMedication', 'test_3', 10, 3

EXEC add_test_view 'first_view', 'test_1'
EXEC add_test_view 'second_view', 'test_1'
EXEC add_test_view 'second_view', 'test_3'
EXEC add_test_view 'first_view', 'test_3'

EXEC run_test 'test_3'


SELECT * FROM Tables
SELECT * FROM Views
SELECT * FROM TestRunTables
SELECT * FROM TestRunViews
SELECT * FROM Tests
SELECT * FROM TestRuns
SELECT * FROM TestTables
SELECT * FROM TestViews