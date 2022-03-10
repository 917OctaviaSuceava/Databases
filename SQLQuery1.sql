CREATE DATABASE Hospital;
USE Hospital;

--The database must contain at least: 10 tables, two 1:n relationships, one m:n relationship.
GO
CREATE OR ALTER PROCEDURE insert_into_tables AS
BEGIN
	INSERT INTO Department 
	VALUES (34, 'Inpatient Service'),(39, 'Emergency Department'),(43, 'Radiology Department'),(45, 'Gynecology'),(50,'Cardiology');

	INSERT INTO Doctor
	VALUES (20, 'Popescu', 'Cristian', 40723569102, 39, 'Cluj-Napoca', 'str. Arges, nr. 10', 'M', 47), 
	(25, 'Stan', 'Andreea', 40783129017, 43, 'Turda', 'str. Bistritei, nr. 23', 'F', 40), 
	(48, 'Dima', 'Tudor', 40745123987, 34, 'Turda', 'str. Libertatii, nr. 8', 'M', 51),
	(49, 'Sava', 'Ramona', 40755632981, 45, 'Cluj-Napoca', 'str. Florilor, nr. 43', 'F', 39),
	(50, 'Cristea', 'Stefan', 40736219876, 34, 'Floresti', 'nr. 22', 'M', 45),
	(51, 'Andreescu', 'Dragos', 40754762943, 50, 'Floresti', 'nr. 34', 'M', 39);

	
	INSERT INTO Diagnose
	VALUES (200, 'pneumonia'),(290, 'sinus infection'),(511, 'food poisoning'),(1,'medical tests');
	
	INSERT INTO Patient
	VALUES (1, 'Adam', 'Simona', 220, 20, 'Cluj-Napoca', 'F', 30, 200), 
	(2, 'Dinu', 'Adelin', 134, 25, 'Cluj-Napoca', 'M', 33, 290), 
	(3, 'Dobre', 'Marina', 164, 48, 'Turda', 'F', 40, 511), 
	(4, 'Nistor', 'Andrei', 211, 48, 'Floresti', 'M', 28, 511),
	(5, 'Barbu', 'Liliana', 100, 51, 'Cluj-Napoca', 'F', 32, 1),
	(6, 'Pop', 'Iasmina', 101, 50, 'Cluj-Napoca', 'F', 26, 1),
	(7, 'Popescu', 'Andrei', 134, 25, 'Tg-Mures', 'M', 26, 200),
	(8, 'Adam', 'Ioan', 202, 25, 'Tg-Mures', 'M', 65, 1);
	

	INSERT INTO PatientDischarge
	VALUES (200, 1, '2021-01-01', '2021-01-04'), 
	(340, 2, '2021-03-11', '2021-03-13'), 
	(190, 3, '2021-10-02', '2021-09-22'),
	(50, 4, '2021-09-22', '2021-09-26');

	INSERT INTO PatientDischarge
	VALUES (230, 5, NULL, NULL);

	
	INSERT INTO Medication
	VALUES (10, 5, 'paracetamol', '2025-10-10'), 
	(20, 10, 'nurofen', '2024-09-20'), (25, 4, 'aulin', '2030-01-15'),
	(26, 20, 'aspirina', '2021-10-20'), (27, 10, 'paduden', '2021-12-01');

	
	INSERT INTO PatientTakesMedication(patient_id, med_id)
	VALUES (1, 10),(2, 25),(3,10),(4,20),(7,26);

	
	INSERT INTO Appointment
	VALUES (900,1,'2021-10-10'),(901,2,'2021-11-13'),(902,3,'2021-10-14'),(903,4,'2021-11-02'),(904,5,'2021-11-02'),(905,6,'2021-12-01');

	
	INSERT INTO NurseInfo
	VALUES (6, 'Albu','Cristina', 40723679102, 36, 'Cluj-Napoca', 'str. Arad, nr. 11'), 
	(8, 'Ionescu', 'Adina', 40743129856, 39, 'Floresti', 'nr. 29'), 
	(9, 'Voinea', 'Alexandra', 40740902385, 41, 'Turda', 'str. Dacia, nr. 4'), 
	(18, 'Popescu', 'Maria', 40742302515, 41, 'Cluj-Napoca', 'str. Brasov, nr. 19'),
	(20, 'Andreescu', 'Roberta', 40765892341, 38, 'Floresti', 'nr. 3'),
	(21, 'Nitu', 'Adina', 40759234650, 51, 'Cluj-Napoca', 'str. Brasov, nr 34'),
	(23, 'Popescu', 'Mihaela', 40759763650, 39, 'Bistrita', 'str. Arges, nr. 12');

	
	INSERT INTO PatientsAndNurses
	VALUES (1,6),(2,8),(3,9),(4,18),(5,18),(7,8);

	INSERT INTO Delivery 
	VALUES (410, 25, 'str. Clinicilor, nr. 2', '2021-10-30', '123456'),
	(491, 10, 'str. Alba, nr. 10', '2021-11-04', '345672'),
	(499, 19, 'str. Alunului, nr. 30', '2021-11-11', '574291'),
	(502, 29, 'str. Brasov, nr. 9', '2021-12-01', '404067'),
	(505, 20, 'str. Clinicilor, nr. 2', '2021-11-01', '123456'),
	(506, 10, 'str. Clinicilor, nr. 2', '2021-11-02', '123456');

	INSERT INTO HospitalInfo 
	VALUES (2109, 'str. Clinicilor, nr. 2', '123456');

	INSERT INTO MedicationDelivery
	VALUES (20, 505), (10, 506), (25, 410);
END
GO


go
CREATE OR ALTER PROCEDURE tables_procedure AS
BEGIN
	CREATE TABLE Department(
		dep_id int PRIMARY KEY,
		dep_name varchar(255)
		);


	CREATE TABLE Doctor(
		doc_id int NOT NULL PRIMARY KEY,
		doc_last_name varchar(255),
		doc_first_name varchar(255),
		doc_phone_number bigint,
		department_id int FOREIGN KEY REFERENCES Department(dep_id),
		doc_city varchar(255),
		doc_address varchar(500),
		doc_gender varchar(10),
		doc_age int
	);
	
	CREATE TABLE Diagnose(
		diagnose_id int PRIMARY KEY,
		diagnose_name varchar(255)
		);


	CREATE TABLE Patient(
		patient_id int NOT NULL PRIMARY KEY,
		patient_last_name VARCHAR(255),
		patient_first_name varchar(255),
		room int,
		doc_id int FOREIGN KEY REFERENCES Doctor(doc_id),
		patient_city varchar(255),
		patient_gender varchar(10),
		patient_age int,
		diagnose_id int FOREIGN KEY REFERENCES Diagnose(diagnose_id)
	);

	
	--ALTER TABLE Patient
	--ADD diagnose_id int FOREIGN KEY REFERENCES Diagnose(diagnose_id);


	CREATE TABLE PatientDischarge(
		bill int,
		patient_id int PRIMARY KEY,
		FOREIGN KEY(patient_id) REFERENCES Patient(patient_id),
		join_date DATE,
		out_date DATE
		);

	

	CREATE TABLE Medication(
		med_id int PRIMARY KEY,
		quantity int,
		med_name varchar(255),
		exp_date DATE
		);


	CREATE TABLE PatientTakesMedication(
		patient_id int FOREIGN KEY REFERENCES Patient(patient_id),
		med_id int FOREIGN KEY REFERENCES Medication(med_id)
		PRIMARY KEY (patient_id, med_id)
		);


	CREATE TABLE Appointment(
			app_id int PRIMARY KEY,
			patient_id int FOREIGN KEY REFERENCES Patient(patient_id),
			app_date DATE
			);


	CREATE TABLE NurseInfo(
			nurse_id int PRIMARY KEY,
			nurse_last_name varchar(255),
			nurse_first_name varchar(255),
			phone_number bigint,
			age int,
			nurse_city varchar(255),
			nurse_address varchar(500)
			);


	CREATE TABLE PatientsAndNurses(
			patient_id int FOREIGN KEY REFERENCES Patient(patient_id),
			nurse_id int FOREIGN KEY REFERENCES NurseInfo(nurse_id),
			PRIMARY KEY (patient_id, nurse_id)
			);


	CREATE TABLE Delivery(
			order_id int PRIMARY KEY,
			med_id int,
			order_address varchar(255),
			order_date DATE,
			postal_code varchar(10)
			);


	CREATE TABLE HospitalInfo(
			hospital_id int PRIMARY KEY,
			hospital_address varchar(255),
			postal_code varchar(10)
			);


	CREATE TABLE MedicationDelivery(
			med_id int NOT NULL FOREIGN KEY REFERENCES Medication(med_id),
			order_id  int, --FOREIGN KEY REFERENCES Delivery(order_id)
			CONSTRAINT fk_order_id FOREIGN KEY(order_id) REFERENCES Delivery(order_id)
			);
END

GO


CREATE PROCEDURE assignment_2 AS
BEGIN
	-- ASSIGNMENT 2

	-- invalid INSERT
	INSERT INTO MedicationDelivery VALUES ('a',2);

	-- DELETE & OR
	DELETE FROM PatientTakesMedication
	WHERE patient_id = 1 OR patient_id = 3;

	-- DELETE & AND
	DELETE FROM PatientsAndNurses
	WHERE patient_id = 1 AND nurse_id = 6; 

	-- UPDATE & IN -- rooms between 100 and 103 are reserved for medical tests (diagnose_id = 1)
	UPDATE Patient
	SET diagnose_id = 1
	WHERE room IN (100, 101, 102, 103);

	-- UPDATE & LIKE  -- patients whose diagnose ID is 1 and last name start with A will be placed in room 100 
	UPDATE Patient
	SET room = 100
	WHERE diagnose_id=1 AND patient_last_name LIKE 'A%';

	-- UPDATE & BETWEEN -- if the patient pays between 250 and 350, they can leave home the same day they went to the hospital
	UPDATE PatientDischarge
	SET out_date = join_date 
	WHERE bill BETWEEN 250 AND 350;

	SELECT * FROM Patient;

	-- UNION & OR -- patients and doctors that are from those cities
	SELECT patient_last_name, patient_first_name, patient_id, patient_city FROM Patient
	WHERE patient_city = 'Turda' OR patient_city = 'Cluj-Napoca'
	UNION ALL
	SELECT doc_last_name, doc_first_name, doc_id, doc_city FROM Doctor
	WHERE doc_city = 'Turda' OR doc_city = 'Cluj-Napoca'
	ORDER BY Patient.patient_city;

	-- UNION ALL & OR -- cities of nurses and doctors whose last names start with A
	SELECT * FROM Doctor;
	SELECT * FROM NurseInfo;

	SELECT DISTINCT nurse_city FROM NurseInfo
	WHERE nurse_last_name LIKE 'A%'
	UNION ALL
	SELECT DISTINCT doc_city FROM Doctor
	WHERE doc_last_name LIKE 'A%'

	-- INTERSECT & IN -- city of doctors and nurses whose last name is Popescu
	SELECT * FROM Doctor;
	SELECT * FROM NurseInfo;

	SELECT nurse_city FROM NurseInfo
	WHERE nurse_last_name IN ('Popescu')
	INTERSECT
	SELECT doc_city FROM Doctor
	WHERE doc_last_name IN ('Popescu');

	-- INTERSECT & IN
	SELECT * FROM Patient;
	SELECT * FROM Doctor;

	SELECT patient_city FROM Patient
	WHERE patient_last_name IN ('Popescu', 'Adam')
	INTERSECT
	SELECT doc_city FROM Doctor
	WHERE doc_last_name IN ('Popescu', 'Stan');

	-- EXCEPT & IN -- doctors from the specified cities that are not in the specified departments
	SELECT * FROM Doctor;

	SELECT D.doc_last_name, D.doc_first_name 
	FROM Doctor D
	WHERE D.doc_city IN ('Cluj-Napoca', 'Turda')
	EXCEPT 
	SELECT D1.doc_last_name, D1.doc_first_name 
	FROM Doctor D1
	WHERE D1.department_id IN (39, 43);

	-- EXCEPT & NOT IN 
	SELECT * FROM Doctor;

	SELECT doc_last_name, doc_first_name, doc_id FROM Doctor
	WHERE doc_city = 'Turda' OR doc_city = 'Floresti'
	EXCEPT
	SELECT doc_last_name, doc_first_name, doc_id FROM Doctor
	WHERE department_id NOT IN (34);

	-- INNER JOIN ON 3 TABLES -- information about medication delivery to the hospital
	SELECT * FROM Delivery;
	SELECT * FROM Medication;
	SELECT * FROM HospitalInfo;

	SELECT M.med_id, D.order_id, H.hospital_address
	FROM ((Delivery D
	INNER JOIN Medication M ON M.med_id=D.med_id)
	INNER JOIN HospitalInfo H ON D.order_address=H.hospital_address);

	--SELECT * FROM Patient;
	--SELECT * FROM NurseInfo;
	--SELECT * FROM PatientsAndNurses;
	--SELECT P.patient_last_name, P.patient_first_name, N.nurse_id
	--FROM ((Patient P
	--INNER JOIN PatientsAndNurses PN ON PN.patient_id=P.patient_id)
	--INNER JOIN NurseInfo N ON N.nurse_id=PN.nurse_id);

	-- LEFT JOIN ON M:N TABLES -- displays the patients and the bills they have to pay
	SELECT * FROM Patient;
	SELECT * FROM PatientDischarge;

	SELECT P.patient_id, P.patient_last_name, P.patient_first_name, PD.bill
	FROM Patient P
	LEFT JOIN PatientDischarge PD ON PD.patient_id=P.patient_id;

	-- RIGHT JOIN -- displays the patients and the appointments they have
	SELECT * FROM Appointment;
	SELECT * FROM Patient;

	SELECT P.patient_id, P.patient_last_name, P.patient_first_name, A.app_date
	FROM Appointment A
	RIGHT JOIN Patient P ON P.patient_id=A.patient_id;

	--SELECT Delivery.order_id, Delivery.med_id
	--FROM Delivery
	--RIGHT JOIN HospitalInfo ON Delivery.order_address=HospitalInfo.hospital_address;

	-- FULL JOIN -- patients with the medication
	SELECT * FROM Patient;
	SELECT * FROM Medication;
	SELECT * FROM PatientTakesMedication;

	SELECT P.patient_last_name, P.patient_first_name, M.med_id
	FROM ((Patient P
	FULL JOIN PatientTakesMedication PM ON PM.patient_id = P.patient_id)
	FULL JOIN Medication M ON M.med_id = PM.med_id);

	--SELECT P.patient_last_name, P.patient_first_name, PM.med_id
	--FROM Patient P
	--FULL JOIN PatientTakesMedication PM ON PM.patient_id = P.patient_id;

	--SELECT Doctor.doc_last_name, Doctor.doc_first_name, NurseInfo.nurse_last_name, NurseInfo.nurse_first_name, NurseInfo.nurse_city
	--FROM Doctor
	--FULL JOIN NurseInfo
	--ON Doctor.doc_city=NurseInfo.nurse_city;


	-- subquery IN -- selects the oldest doctors in the database
	SELECT * FROM Doctor;
	SELECT * FROM NurseInfo;

	SELECT D.doc_last_name, D.doc_first_name, D.doc_age
	FROM Doctor D
	WHERE D.doc_age IN (SELECT MAX(D1.doc_age)
						FROM Doctor D1);

	-- subquery IN + subquery in WHERE clause -- doctors that have the same age as the oldest nurse, whose age is below 60
	SELECT * FROM Doctor;
	SELECT * FROM NurseInfo;

	SELECT D.doc_last_name, D.doc_first_name, D.doc_age
	FROM Doctor D
	WHERE D.doc_age IN (SELECT N.age
						FROM NurseInfo N
						WHERE N.age IN (SELECT MAX(N1.age)
										FROM NurseInfo N1
										WHERE N1.age<60));

	-- EXISTS -- 3 doctors that are from the same city as some nurses, ordered by city
	SELECT * FROM Doctor;
	SELECT * FROM NurseInfo;

	SELECT TOP 3 D.doc_last_name, D.doc_first_name, D.doc_city
	FROM Doctor D
	WHERE EXISTS (SELECT N.nurse_city
				  FROM NurseInfo N
				  WHERE N.nurse_city=D.doc_city)
	ORDER BY D.doc_city;

	-- EXISTS -- patients that have the nurse with the ID 18
	SELECT * FROM Patient;
	SELECT * FROM PatientsAndNurses;

	SELECT PN.patient_id
	FROM PatientsAndNurses PN
	WHERE EXISTS (SELECT *
					FROM Patient P
					WHERE P.patient_id=PN.patient_id AND PN.nurse_id=18)
	ORDER BY PN.patient_id;

	-- GROUP BY -- number of patients with a certain age, the table is grouped by age
	SELECT * FROM Patient;

	SELECT COUNT(P.patient_id) AS number_of_patients, P.patient_age
	FROM Patient P
	GROUP BY P.patient_age;

	-- GROUP BY + HAVING -- number of patients younger than 30yo, the table is grouped by age
	SELECT * FROM Patient;

	SELECT COUNT(P.patient_id) AS number_of_patients, P.patient_age
	FROM Patient P
	GROUP BY P.patient_age
	HAVING MAX(P.patient_age)<30;

	-- GROUP BY + HAVING + subquery -- number of patients older than the youngest doctor
	SELECT * from Patient;
	SELECT * FROM Doctor;

	SELECT COUNT(P.patient_id) AS number_of_patients, P.patient_age
	FROM Patient P
	GROUP BY P.patient_age
	HAVING P.patient_age >= (SELECT MIN(D.doc_age)
							FROM Doctor D);

	-- GROUP BY + HAVING + subquery -- number of doctors (at least 1) that are working in the same department and the department ID 
	SELECT * FROM Doctor;
	SELECT * FROM Department;

	SELECT COUNT(D.doc_id) AS number_of_doctors, D.department_id
	FROM Doctor D 
	GROUP BY D.department_id
	HAVING 1 < (SELECT COUNT(*)
				FROM Doctor D2
				WHERE D2.department_id = D.department_id);

	-- ANY -- patients that joined when some other patient left
	SELECT * FROM PatientDischarge;

	SELECT PD.patient_id
	FROM PatientDischarge PD
	WHERE PD.join_date = ANY (SELECT PD1.out_date
							  FROM PatientDischarge PD1);

	-- rewritten with IN 
	SELECT PD.patient_id
	FROM PatientDischarge PD
	WHERE PD.join_date IN (SELECT PD1.out_date
						   FROM PatientDischarge PD1);

	-- ANY -- meds that are past their expiration date from 2021
	SELECT * FROM Medication;
	select CAST(GETDATE() AS DATE);

	SELECT M.med_id, M.med_name
	FROM Medication M
	WHERE M.exp_date = ANY (SELECT M1.exp_date
							 FROM Medication M1
							 WHERE YEAR(M1.exp_date) = 2021 AND CAST(GETDATE() AS DATE)>=M1.exp_date);

	-- nope:
	SELECT M.med_id, M.med_name
	FROM Medication M
	WHERE CAST(GETDATE() AS DATE) >= ANY (SELECT M1.exp_date
										FROM Medication M1
										WHERE YEAR(M1.exp_date) = 2021);


	-- rewritten with IN
	SELECT M.med_id, M.med_name
	FROM Medication M
	WHERE M.exp_date IN (SELECT M1.exp_date
						 FROM Medication M1
						 WHERE YEAR(M1.exp_date) = 2021 AND CAST(GETDATE() AS DATE)>=M1.exp_date);

	-- ALL -- doctors' ages that are older than all the patients from the specified city
	SELECT * FROM Doctor;
	SELECT * FROM Patient;

	SELECT DISTINCT D.doc_age
	FROM Doctor D
	WHERE D.doc_age > ALL (SELECT P.patient_age
							FROM Patient P
							WHERE P.patient_city='Cluj-Napoca')
	ORDER BY D.doc_age;

	-- rewritten with MAX() -- doctors that are older than all the patients from the specified city

	SELECT D.doc_last_name, D.doc_first_name, D.doc_age
	FROM Doctor D
	WHERE D.doc_age > (SELECT MAX(P.patient_age)
							FROM Patient P
							WHERE P.patient_city='Cluj-Napoca');

	-- ALL -- all the appointments after 10th of October
	SELECT * FROM Appointment;

	SELECT A.patient_id
	FROM Appointment A
	WHERE MONTH(A.app_date)=10 AND '2021-10-10' <= ALL (SELECT A1.app_date
														FROM Appointment A1
														WHERE MONTH(A1.app_date)=10);
	-- rewritten with MIN()
	SELECT * FROM Appointment;

	SELECT A.patient_id
	FROM Appointment A
	WHERE MONTH(A.app_date)=10 AND '2021-10-10' <= (SELECT MIN(A1.app_date)
													FROM Appointment A1
													WHERE MONTH(A1.app_date)=10);

	-- subquery in FROM -- doctors from department 34 
	SELECT * FROM Doctor;
	SELECT * FROM Department;

	SELECT D.*
	FROM Doctor D INNER JOIN (SELECT * 
							FROM Department DEP
							WHERE DEP.dep_id=34) D1
	ON D.department_id=D1.dep_id;

	-- subquery in FROM -- doctors older than the average age
	SELECT * FROM Doctor;

	SELECT AVG(D1.doc_age) AS avg_age
	FROM Doctor D1;

	SELECT D.*
	FROM Doctor D INNER JOIN (SELECT AVG(D1.doc_age) AS avg_age
							FROM Doctor D1) A
	ON D.doc_age>A.avg_age;
END
GO

GO
EXEC tables_procedure;
EXEC insert_into_tables;
GO

--show tables
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

--drop tables
DROP TABLE Appointment;
DROP TABLE PatientTakesMedication;
DROP TABLE PatientsAndNurses;
DROP TABLE PatientDischarge;
DROP TABLE Patient;
DROP TABLE Doctor;
DROP TABLE Department;
DROP TABLE Diagnose;
DROP TABLE NurseInfo;
DROP TABLE MedicationDelivery;
DROP TABLE Delivery;
DROP TABLE Medication;
DROP TABLE HospitalInfo;	

DROP DATABASE Hospital;