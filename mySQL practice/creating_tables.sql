


-- *** FIRST LEVEL MARKED WITH RED *** --
-- CREATE PHYSICIAN TABLE -- 
CREATE TABLE physician (
    emp_id INT PRIMARY KEY,
    full_name VARCHAR(80),
    physitian_position VARCHAR(80),
    ssn_id INT
);
-- CHECK PHYSITIAN TABLE -- 
SELECT *
FROM physician;

-- CRAETE PROCEDURE TABLE --
CREATE TABLE medical_procedure (
    code_id INT PRIMARY KEY,
    procedure_name VARCHAR (80),
    procedure_cost INT
);
-- CHECK IF MEDICAL PROCEDURE TABLE WAS CREATED --
SELECT *
FROM medical_procedure; 

--CREATE MEDICATION TABLE--
CREATE TABLE medication (
    medication_code_id INT PRIMARY KEY, 
    medication_name VARCHAR(100),
    medication_brand VARCHAR(60), 
    medication_description VARCHAR(1500)
);
--CHECK MEDICATION TABLE -- 
SELECT * 
FROM medication;

--CREATE BLOCK TABLE --
CREATE TABLE building_block (
    block_floor_id INT, 
    block_code_id INT, 
    PRIMARY KEY (block_floor_id, block_code_id)
); 

--CHECK BUILDING BLOCK TABLE -- 
SELECT * 
FROM building_block;

--CREATE NURSE TABLE-- 
CREATE TABLE nurse (
    emp_id INT PRIMARY KEY, 
    full_name VARCHAR(100),
    nurse_position VARCHAR(100),
    nurse_registered BOOLEAN not null default FALSE,
    ssn_id INT
); 

--CHECK NURSE TABLE --
SELECT * 
FROM nurse; 



-- *** SECOND LEVEL MARKED WITH BLUE *** --
-- CREATE DEPARTMENT TABLE -- 
CREATE TABLE department (
    dep_id INT PRIMARY KEY,
    dep_name VARCHAR(100),
    head_id INT,
    FOREIGN KEY(head_id) REFERENCES physician(emp_id) ON DELETE SET NULL
);
-- CHECK DEPARTMENT TABLE -- 
SELECT * 
FROM department;


-- CREATE TRAINED-IN TABLE-- 
CREATE TABLE trained_in (
    physician_id INT, 
    treatment_id INT, 
    PRIMARY KEY (physician_id, treatment_id),
    cert_date DATETIME,
    cert_exp_date DATETIME
);
-- CHECK TRAINED IN TABLE -- 
SELECT *
FROM trained_in; 

--CREATE PATIENT TABLE --

CREATE TABLE patient (
    ssn_id INT PRIMARY KEY, 
    full_name VARCHAR(80),
    address VARCHAR(150),
    phone VARCHAR(30),
    insurance_id INT,
    pcp INT,
    FOREIGN KEY(pcp) REFERENCES physician(emp_id) ON DELETE SET NULL
);

-- CHECK PATIENT TABLE -- 
SELECT *
FROM patient;

-- CREATE ROOM TABLE -- 
CREATE TABLE room (
    room_nr INT PRIMARY KEY,
    room_type VARCHAR(30),
    block_floor INT,
    block_code INT, 
    FOREIGN KEY(block_floor, block_code) REFERENCES building_block(block_floor_id, block_code_id) ON DELETE SET NULL,
    room_unavailable BOOLEAN not null default FALSE
); 

-- CHECK ROOM TABLE -- 
SELECT *
FROM room; 


-- CREATE TABLE ON CALL -- 

CREATE TABLE on_call (
    start_time DATETIME PRIMARY KEY,
    end_time DATETIME,
    nurse INT, 
    block_floor INT, 
    block_code INT,
    FOREIGN KEY (nurse) REFERENCES nurse(emp_id) ON DELETE SET NULL,
    FOREIGN KEY (block_floor, block_code) REFERENCES building_block(block_floor_id, block_code_id) ON DELETE SET NULL
);

-- CHECK ON CALL TABLE -- 
SELECT * 
FROM on_call;

-- *** THIRD LEVEL MARKED WITH GREEN *** --
-- CREATE AFFILIATED WITH TABLE --

CREATE TABLE affiliated_with (
   emp_id INT,
   dep_id INT,
   primary_affiliation BOOLEAN not null default FALSE
);

-- ADDING FOREIGN KEYS TO AFFILIATED WOTH -- 
ALTER TABLE affiliated_with
ADD FOREIGN KEY (emp_id)
REFERENCES physician(emp_id)
ON DELETE SET NULL; 


ALTER TABLE affiliated_with
ADD FOREIGN KEY (dep_id)
REFERENCES department(dep_id)
ON DELETE SET NULL; 



-- CHECK AFFILIATED WITH -- 
SELECT * 
FROM affiliated_with;


-- CREATE APPOINTMENT TABLE -- 

CREATE TABLE appointment (
    appointment_id INT PRIMARY KEY,
    patient INT,
    prep_nurse INT NULL,
    physician INT, 
    start_time DATETIME,
    end_time DATETIME,
    examination_room VARCHAR(100)
);

-- ADDING FOREIGN KEYS -- 
ALTER TABLE appointment
ADD FOREIGN KEY (patient)
REFERENCES patient(ssn_id)
ON DELETE SET NULL; 

ALTER TABLE appointment
ADD FOREIGN KEY (prep_nurse)
REFERENCES nurse(emp_id)
ON DELETE SET NULL;

ALTER TABLE appointment
ADD FOREIGN KEY (physician)
REFERENCES physician(emp_id)
ON DELETE SET NULL;

-- CHECK APPOINTMENT TABLE -- 
SELECT *
FROM appointment; 


-- CREATE STAY TABLE -- 
CREATE TABLE stay (
    stay_id INT PRIMARY KEY, 
    patient INT,
    room INT,
    start_time DATETIME,
    end_time DATETIME
);

-- ADD FOREIGN KEYS -- 

ALTER TABLE stay
ADD FOREIGN KEY (patient)
REFERENCES patient(ssn_id)
ON DELETE SET NULL;

ALTER TABLE stay
ADD FOREIGN KEY (room)
REFERENCES room(room_nr)
ON DELETE SET NULL;

-- CHECK STAY TABLE -- 
SELECT *
FROM stay; 


-- *** FOURTH LEVEL MARKED WITH YELLOW *** --

-- CREATE TABLE PRESCRIBES -- 

CREATE TABLE prescribes (
    prescribe_date DATETIME PRIMARY KEY,
    physician INT,
    patient INT,
    medication INT,
    appointmnet INT,
    dose VARCHAR(100)
);

-- ADDING FOREIGN KEYS -- 

ALTER TABLE prescribes
ADD FOREIGN KEY (physician)
REFERENCES physician(emp_id)
ON DELETE SET NULL; 

ALTER TABLE prescribes 
ADD FOREIGN KEY (patient)
REFERENCES patient(ssn_id)
ON DELETE SET NULL; 


ALTER TABLE prescribes
ADD FOREIGN KEY (medication)
REFERENCES medication(medication_code_id)
ON DELETE SET NULL; 


-- CHECK PRESCRIBES TABLE -- 
SELECT *
FROM prescribes;


-- CREATE TABLE UNDERGOES -- 

CREATE TABLE undergoes (
    undergoes_date DATETIME PRIMARY KEY, 
    undergoes_patient INT,
    undergoes_procedure INT,
    undergoes_stay INT,
    physician INT,
    assisting_nurse INT NULL
); 


-- ADD FOREIGN KEYS TO UNDERGOES -- 

ALTER TABLE undergoes
ADD FOREIGN KEY (undergoes_patient)
REFERENCES patient(ssn_id)
ON DELETE SET NULL; 

ALTER TABLE undergoes 
ADD FOREIGN KEY (undergoes_procedure)
REFERENCES medical_procedure(code_id)
ON DELETE SET NULL; 

ALTER TABLE undergoes
ADD FOREIGN KEY (undergoes_stay)
REFERENCES stay(stay_id)
ON DELETE SET NULL; 

ALTER TABLE undergoes
ADD FOREIGN KEY (physician)
REFERENCES physician(emp_id)
ON DELETE SET NULL; 

ALTER TABLE undergoes
ADD FOREIGN KEY (assisting_nurse)
REFERENCES nurse(emp_id)
ON DELETE SET NULL; 

