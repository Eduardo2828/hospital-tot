DROP DATABASE IF EXISTS `hospital-projecte`;
CREATE DATABASE `hospital-projecte`;
USE `hospital-projecte`;

CREATE TABLE `HOSPITAL` (
    `CIF` CHAR(9) NOT NULL,
    `Ubicacio` VARCHAR(128) NOT NULL,
    `Nom` VARCHAR(128)
);

CREATE TABLE `AREA` (
	`Codi` INT UNSIGNED NOT NULL,
    `Capacitat` TINYINT NOT NULL,
    `Horari` TIME,
    `Nom` VARCHAR(128),
    `CIF_Hospital` CHAR(9) NOT NULL
);

CREATE TABLE `PERSONAL` (
    `Codi` INT UNSIGNED NOT NULL,
    `Nom` VARCHAR(32) NOT NULL,
    `Cognoms` VARCHAR(64) NOT NULL,
    `Salari` DECIMAL(10, 2) UNSIGNED NOT NULL,
    `DataContracte` DATETIME NOT NULL,
    `Telefono` VARCHAR(12) NOT NULL,
    `Correu` VARCHAR(64) NOT NULL,
    `CIF_Hospital` CHAR(9) NOT NULL
);

CREATE TABLE `MEDIC` (
    `Codi_Personal` INT UNSIGNED NOT NULL,
    `Especialitat` VARCHAR(128) NOT NULL
);

CREATE TABLE `MEDIC_CERTIFICATS` (
    `Certificats` VARCHAR(128) NOT NULL,
    `Codi_Personal` INT UNSIGNED NOT NULL
    );

CREATE TABLE `NO_MEDIC_TASQUES` (
	`Tasques`VARCHAR(128) NOT NULL,
    `Codi_personal` INT UNSIGNED NOT NULL
);

CREATE TABLE `NO_MEDIC` (
    `Codi_Personal` INT UNSIGNED NOT NULL,
    `Departament` VARCHAR(64) NOT NULL
);

CREATE TABLE `PACIENT` (
    `ID` INT UNSIGNED NOT NULL,
    `Nom` VARCHAR(32) NOT NULL,
    `Cognoms` VARCHAR(64) NOT NULL,
    `DataNaixement` DATETIME NOT NULL,
    `Telefono` VARCHAR(12) NOT NULL,
    `Correu` VARCHAR(64) NOT NULL
);

CREATE TABLE `PACIENT_ANTECEDENTS` (
    `Antecedents` VARCHAR(128),
    `ID_Pacient` INT UNSIGNED NOT NULL
);

CREATE TABLE `VISITA` (
    `DataHora_Inici` DATETIME NOT NULL,
    `DataHora_Final` DATETIME NOT NULL,
    `ID_Pacient` INT UNSIGNED NOT NULL,
    `Codi_Area` INT UNSIGNED NOT NULL,
    `CIF_Hospital` CHAR(9) NOT NULL
);

CREATE TABLE `EMPLEAT_VISITA` (
    `Codi_Empleat` INT UNSIGNED NOT NULL,
    `DataHora_Inici_Visita` DATETIME NOT NULL,
    `DataHora_Final_Visita` DATETIME NOT NULL,
    `ID_Pacient` INT UNSIGNED NOT NULL,
    `Codi_Area` INT UNSIGNED NOT NULL,
    `CIF_Hospital` CHAR(9) NOT NULL   
);


-- PRIMARY KEYS
ALTER TABLE `HOSPITAL`
    ADD CONSTRAINT PK_HOSPITAL PRIMARY KEY(`CIF`);
    
ALTER TABLE `AREA`
    ADD CONSTRAINT PK_AREA PRIMARY KEY(`Codi`, `CIF_Hospital`);

ALTER TABLE `PERSONAL`
    ADD CONSTRAINT PK_PERSONAL PRIMARY KEY(`Codi`);

ALTER TABLE `MEDIC`
    ADD CONSTRAINT PK_MEDIC PRIMARY KEY(`Codi_Personal`);
    
ALTER TABLE `MEDIC_CERTIFICATS`
    ADD CONSTRAINT PK_MEDIC_CERTIFICATS PRIMARY KEY(`Certificats`, `Codi_Personal`);
    
ALTER TABLE `NO_MEDIC_TASQUES`
    ADD CONSTRAINT PK_NO_MEDIC_TASQUES PRIMARY KEY(`Tasques`, `Codi_Personal`);
    
ALTER TABLE `NO_MEDIC`
    ADD CONSTRAINT PK_NO_MEDIC PRIMARY KEY(`Codi_Personal`);
    
ALTER TABLE `PACIENT`
    ADD CONSTRAINT PK_PACIENT PRIMARY KEY(`ID`);

ALTER TABLE `PACIENT_ANTECEDENTS`
    ADD CONSTRAINT PK_PACIENT_ANTECEDENTS PRIMARY KEY(`Antecedents`, `ID_Pacient`);
    
ALTER TABLE `VISITA`
    ADD CONSTRAINT PK_VISITA PRIMARY KEY(`DataHora_Inici`, `DataHora_Final`, `ID_Pacient`, `Codi_Area`, `CIF_Hospital`);
    
ALTER TABLE `EMPLEAT_VISITA`
    ADD CONSTRAINT PK_EMPLEAT_VISITA PRIMARY KEY(`Codi_Empleat`);
    
-- FOREIGN KEYS

ALTER TABLE `PERSONAL` 
	ADD CONSTRAINT FK_PERSONAL_HOSPITAL FOREIGN KEY (`CIF_Hospital`) 
		REFERENCES `HOSPITAL`(`CIF`);

ALTER TABLE `MEDIC` 
	ADD CONSTRAINT FK_MEDIC_PERSONAL FOREIGN KEY (`Codi_Personal`) 
		REFERENCES `PERSONAL`(`Codi`);

ALTER TABLE `MEDIC_CERTIFICATS` 
	ADD CONSTRAINT FK_MEDIC_CERTIFICATS_PERSONAL FOREIGN KEY (`Codi_Personal`) 
		REFERENCES `MEDIC`(`Codi_Personal`);

-- Agregar claves foráneas a la tabla NO_MEDIC
ALTER TABLE `NO_MEDIC`
	ADD CONSTRAINT FK_NO_MEDIC_PERSONAL FOREIGN KEY (`Codi_Personal`) 
		REFERENCES `PERSONAL`(`Codi`);

-- Agregar claves foráneas a la tabla NO_MEDIC_TASQUES
ALTER TABLE `NO_MEDIC_TASQUES` 
	ADD CONSTRAINT FK_NO_MEDIC_TASQUES_PERSONAL FOREIGN KEY (`Codi_Personal`) 
		REFERENCES `NO_MEDIC`(`Codi_Personal`);

-- Agregar claves foráneas a la tabla AREA
ALTER TABLE `AREA` 
ADD CONSTRAINT FK_AREA_HOSPITAL FOREIGN KEY (`CIF_Hospital`) 
	REFERENCES `HOSPITAL`(`CIF`);

-- Agregar claves foráneas a la tabla VISITA
ALTER TABLE `VISITA` 
	ADD CONSTRAINT FK_VISITA_PACIENTE FOREIGN KEY (`ID_Pacient`) 
		REFERENCES `PACIENT`(`ID`);

ALTER TABLE `VISITA`
	ADD CONSTRAINT FK_VISITA_AREA_HOSPITAL FOREIGN KEY (`Codi_Area`, `CIF_Hospital`) 
		REFERENCES `AREA`(`Codi`, `CIF_Hospital`);

-- Agregar claves foráneas a la tabla EMPLEAT_VISITA
ALTER TABLE `EMPLEAT_VISITA` 
	ADD CONSTRAINT FK_EMPLEAT_VISITA_PERSONAL FOREIGN KEY (`Codi_Empleat`) 
		REFERENCES `PERSONAL`(`Codi`);

ALTER TABLE `EMPLEAT_VISITA` 
	ADD CONSTRAINT FK_EMPLEAT_VISITA_VISITA FOREIGN KEY (`DataHora_Inici_Visita`, `DataHora_Final_Visita`,`ID_Pacient`, `Codi_Area`, `CIF_Hospital`) 
		REFERENCES `VISITA`(`DataHora_Inici`, `DataHora_Final`,`ID_Pacient`, `Codi_Area`, `CIF_Hospital`);

-- Agregar claves foráneas a la tabla PACIENT_ANTECEDENTS
ALTER TABLE `PACIENT_ANTECEDENTS` 
	ADD CONSTRAINT FK_PACIENT_ANTECEDENTS_PACIENT FOREIGN KEY (`ID_Pacient`) 
		REFERENCES `PACIENT`(`ID`);
        
INSERT INTO `HOSPITAL` (`CIF`, `Ubicacio`, `Nom`) VALUES
('A12345678', 'Barcelona', 'Hospital General'),
('B23456789', 'Madrid', 'Hospital Central'),
('C34567890', 'Valencia', 'Hospital de la Salud');

INSERT INTO `AREA` (`Codi`, `Capacitat`, `Horari`, `Nom`, `CIF_Hospital`) VALUES
(1, 20, '08:00:00', 'Urgencias', 'A12345678'),
(2, 15, '08:00:00', 'Pediatria', 'B23456789'),
(3, 10, '08:00:00', 'Traumatologia', 'C34567890');

INSERT INTO `PERSONAL` (`Codi`, `Nom`, `Cognoms`, `Salari`, `DataContracte`, `Telefono`, `Correu`, `CIF_Hospital`) VALUES
(1, 'Juan', 'Perez', 3000.00, '2023-01-15 09:00:00', '612345678', 'juan.perez@hospital.com', 'A12345678'),
(2, 'María', 'Gomez', 2800.00, '2023-02-20 09:00:00', '612345679', 'maria.gomez@hospital.com', 'B23456789'),
(3, 'Luis', 'Martinez', 3200.00, '2023-03-10 09:00:00', '612345680', 'luis.martinez@hospital.com', 'C34567890');

INSERT INTO `MEDIC` (`Codi_Personal`, `Especialitat`) VALUES
(1, 'Cardiologia'),
(2, 'Pediatria'),
(3, 'Traumatologia');

INSERT INTO `MEDIC_CERTIFICATS` (`Certificats`, `Codi_Personal`) VALUES
('Certificado de Especialista', 1),
('Certificado de Urgencias', 2),
('Certificado de Cirugia', 3);

-- INSERT INTO `NO_MEDIC_TASQUES` (`Tasques`, `Codi_personal`) VALUES
-- ('Administración', 1),
-- ('Atención al Paciente', 2),
-- ('Limpieza', 3);

INSERT INTO `NO_MEDIC` (`Codi_Personal`, `Departament`) VALUES
(1, 'Administracion'),
(2, 'Atencion al Paciente'),
(3, 'Mantenimiento');

INSERT INTO `PACIENT` (`ID`, `Nom`, `Cognoms`, `DataNaixement`, `Telefono`, `Correu`) VALUES
(1, 'Carlos', 'Sanchez', '1985-05-12', '612345681', 'carlos.sanchez@correo.com'),
(2, 'Ana', 'Lopez', '1990-07-22', '612345682', 'ana.lopez@correo.com'),
(3, 'Pedro', 'Ramirez', '1978-11-30', '612345683', 'pedro.ramirez@correo.com');

INSERT INTO `PACIENT_ANTECEDENTS` (`Antecedents`, `ID_Pacient`) VALUES
('Hipertension', 1),
('Diabetes', 2),
('Asma', 3);

INSERT INTO `VISITA` (`DataHora_Inici`, `DataHora_Final`, `ID_Pacient`, `Codi_Area`, `CIF_Hospital`) VALUES
('2025-05-12 10:00:00', '2025-05-12 11:00:00', 1, 1, 'A12345678'),
('2025-05-12 11:30:00', '2025-05-12 12:30:00', 2, 2, 'B23456789'),
('2025-05-12 13:00:00', '2025-05-12 14:00:00', 3, 3, 'C34567890');

INSERT INTO `EMPLEAT_VISITA` (`Codi_Empleat`, `DataHora_Inici_Visita`, `DataHora_Final_Visita`, `ID_Pacient`, `Codi_Area`, `CIF_Hospital`) VALUES
(1, '2025-05-12 10:00:00', '2025-05-12 11:00:00', 1, 1, 'A12345678'),
(2, '2025-05-12 11:30:00', '2025-05-12 12:30:00', 2, 2, 'B23456789'),
(3, '2025-05-12 13:00:00', '2025-05-12 14:00:00', 3, 3, 'C34567890');

