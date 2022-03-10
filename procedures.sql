USE Hospital;
GO
--a
CREATE PROCEDURE version1 AS
BEGIN
	ALTER TABLE Doctor
	ALTER COLUMN doc_phone_number varchar(12)
	PRINT('Changed column from bigint to varchar')
END
GO

--EXEC version1;

CREATE PROCEDURE undo_version1 AS
BEGIN
	ALTER TABLE Doctor
	ALTER COLUMN doc_phone_number bigint
	PRINT('Changed column back from varchar to bigint')
END
GO

--EXEC undo_version1;
--b
CREATE PROCEDURE version2 AS
BEGIN
	ALTER TABLE Patient
	ADD patient_phone_number bigint
	PRINT('Added column')
END
GO

--EXEC version2;
--SELECT * FROM Patient;

CREATE PROCEDURE undo_version2 AS
BEGIN
	ALTER TABLE Patient
	DROP COLUMN patient_phone_number
	PRINT('Removed column')
END
GO

--EXEC undo_version2;
--c
CREATE PROCEDURE version3 AS
BEGIN
	ALTER TABLE PatientDischarge
	ADD CONSTRAINT default_date DEFAULT GETDATE() FOR join_date
	PRINT('Added default constraint')
END
GO

--EXEC version3;

CREATE PROCEDURE undo_version3 AS
BEGIN
	ALTER TABLE PatientDischarge
	DROP CONSTRAINT default_date
	PRINT('Dropped default constraint')
END
GO

--EXEC undo_version3;
--d
CREATE PROCEDURE version4 AS 
BEGIN 
	ALTER TABLE MedicationDelivery
	ADD CONSTRAINT pk_med_id PRIMARY KEY(med_id)
	PRINT('Added primary key')
END
GO

--DROP PROCEDURE version4;
EXEC version4;

CREATE PROCEDURE undo_version4 AS 
BEGIN 
	ALTER TABLE MedicationDelivery
	DROP CONSTRAINT pk_med_id
	PRINT('Dropped primary key')
END
GO

--EXEC version4;
--EXEC undo_version4;
--e
CREATE PROCEDURE version5 AS
BEGIN
	ALTER TABLE NurseInfo
	ADD CONSTRAINT candidate_key UNIQUE(nurse_id, nurse_last_name, nurse_first_name)
	PRINT('Added candidate key')
END
GO

EXEC version5;

CREATE PROCEDURE undo_version5 AS
BEGIN
	ALTER TABLE NurseInfo
	DROP CONSTRAINT candidate_key
	PRINT('Removed candidate key')
END
GO

--EXEC version5;
EXEC undo_version5;
--f
CREATE PROCEDURE version6 AS
BEGIN
	ALTER TABLE MedicationDelivery
	DROP CONSTRAINT fk_order_id
	PRINT('Removed foreign key')
END
GO


CREATE PROCEDURE undo_version6 AS
BEGIN
	ALTER TABLE MedicationDelivery
	ADD CONSTRAINT fk_order_id FOREIGN KEY(order_id) REFERENCES Delivery(order_id)
	PRINT('Added foreign key')
END
GO

--EXEC version6;
--EXEC undo_version6;
--g
CREATE PROCEDURE version7 AS
BEGIN
	DROP TABLE IF EXISTS HospitalInfo
	PRINT('Dropped a table')
END
GO

CREATE PROCEDURE undo_version7 AS
BEGIN
	CREATE TABLE HospitalInfo(
		hospital_id int PRIMARY KEY,
		hospital_address varchar(255),
		postal_code varchar(10)
		);
	PRINT('Created a table')
END
GO

--EXEC version7;
--EXEC undo_version7;
--SELECT * FROM HospitalInfo;

CREATE TABLE DatabaseSchema(
		db_version int
		);
INSERT INTO DatabaseSchema
VALUES (0);
go

CREATE PROCEDURE get_version(@selected_version int = 0) AS
BEGIN
	DECLARE @procedure varchar(100)
	DECLARE @current_version int
	SET @current_version = (SELECT db_version FROM DatabaseSchema)
	IF @selected_version < 0 OR @selected_version > 7 
	BEGIN
		PRINT('The version should be a number between 0 and 7')
		return;
	END
	
	WHILE @selected_version > @current_version
	BEGIN 
		SET @current_version = @current_version + 1
		SET @procedure = 'version' + CAST(@current_version as varchar(3))
		EXEC @procedure
	END

	WHILE @selected_version < @current_version
	BEGIN 
		IF @selected_version != 0
		BEGIN
			SET @procedure = 'undo_version' + CAST(@current_version as varchar(3))
			EXEC @procedure
		END
		SET @current_version = @current_version - 1
	END
	TRUNCATE TABLE DatabaseSchema
	INSERT INTO DatabaseSchema
	VALUES (@current_version);
END
GO

EXEC get_version 8;

EXEC get_version 2;
SELECT * FROM Patient;

EXEC get_version 3;
SELECT * FROM Patient;

EXEC get_version 7;
SELECT * FROM HospitalInfo;

EXEC get_version 1;
SELECT * FROM HospitalInfo;

SELECT * FROM DatabaseSchema;

DROP TABLE DatabaseSchema;
DROP PROCEDURE version1;
DROP PROCEDURE undo_version1;
DROP PROCEDURE version2;
DROP PROCEDURE undo_version2;
DROP PROCEDURE version3;
DROP PROCEDURE undo_version3;
DROP PROCEDURE version4;
DROP PROCEDURE undo_version4;
DROP PROCEDURE version5;
DROP PROCEDURE undo_version5;
DROP PROCEDURE version6;
DROP PROCEDURE undo_version6;
DROP PROCEDURE version7;
DROP PROCEDURE undo_version7;
DROP PROCEDURE get_version;

--IF ISNUMERIC(@selected_version) != 0
	--BEGIN
		--PRINT('The version should be a number!')
		--return;
	--END
