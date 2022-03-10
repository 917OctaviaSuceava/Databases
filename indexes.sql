
USE Hospital;

CREATE TABLE PatientInfo (
		p_id INT PRIMARY KEY IDENTITY (1,1),
		room INT UNIQUE,
		last_name varchar(40)
		);

CREATE TABLE DoctorInfo (
		d_id INT PRIMARY KEY IDENTITY (1,1),
		department_id INT,
		last_name varchar(40)
		);

CREATE TABLE Room (
		room_id INT PRIMARY KEY,
		fk_doc_id INT FOREIGN KEY REFERENCES DoctorInfo(d_id),
		fk_patient_id INT FOREIGN KEY REFERENCES PatientInfo(p_id)
		);

INSERT INTO PatientInfo VALUES (10, 'Popescu'), (11, 'Stan'), (12, 'Dima'), (13, 'Popescu'), (14, 'Cristea'), (15, 'Barbu'), (16, 'Pop'), (17, 'Popescu');
INSERT INTO DoctorInfo VALUES (50, 'Stan'), (51, 'Popescu'), (52, 'Cristescu'), (53, 'Tudor'), (54, 'Adam'), (55, 'Nistor'), (56, 'Barbu'), (57, 'Andreescu');
INSERT INTO Room VALUES (10, 8, 1), (11, 5, 2), (12, 6, 3), (13, 1, 4), (14, 4, 5), (15, 5, 6), (16, 2, 7), (17, 3, 8);

SELECT * FROM PatientInfo; 
SELECT * FROM DoctorInfo;
SELECT * FROM Room;

-- a)
-- CLUSTERED INDEX SEEK
SELECT last_name, room
FROM PatientInfo
WHERE p_id = 7

-- CLUSTERED INDEX SCAN
SELECT p_id, last_name
FROM PatientInfo 
WHERE last_name LIKE 'P%'

-- NON-CLUSTERED INDEX SCAN
SELECT room
FROM PatientInfo

-- NON-CLUSTERED INDEX SEEK
SELECT p_id, last_name
FROM PatientInfo
WHERE room = 12

-- KEY LOOKUP
SELECT *
FROM PatientInfo
WHERE room = 11

-- b)

-- WHERE b2 = value, CLUSTERED
SELECT d_id
FROM DoctorInfo
WHERE department_id = 57

-- NON-CLUSTERED INDEX FOR DoctorInfo TABLE
CREATE INDEX doc_index ON DoctorInfo(department_id);


SELECT d_id
FROM DoctorInfo
WHERE department_id = 57

DROP INDEX DoctorInfo.doc_index

-- c)
-- VIEW ON 2 TABLES
GO
CREATE OR ALTER VIEW view_tables AS
	SELECT P.p_id, D.d_id, P.last_name
	FROM PatientInfo P
	INNER JOIN DoctorInfo D ON D.last_name = P.last_name
	WHERE D.last_name LIKE 'P%' OR D.last_name LIKE 'B%'
GO

SELECT * FROM view_tables -- clustered index scan on both Patient and Doctor


CREATE INDEX ind ON DoctorInfo(last_name);
DROP INDEX DoctorInfo.ind;

DROP TABLE Room;
DROP TABLE DoctorInfo;
DROP TABLE PatientInfo;
