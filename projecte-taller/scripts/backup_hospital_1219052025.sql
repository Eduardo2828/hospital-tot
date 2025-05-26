-- MySQL dump 10.13  Distrib 8.4.3, for Win64 (x86_64)
--
-- Host: localhost    Database: hospital-projecte
-- ------------------------------------------------------
-- Server version	5.5.5-10.6.5-MariaDB

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `area`
--

DROP TABLE IF EXISTS `area`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `area` (
  `Codi` int(10) unsigned NOT NULL,
  `Capacitat` tinyint(4) NOT NULL,
  `Horari` time DEFAULT NULL,
  `Nom` varchar(128) DEFAULT NULL,
  `CIF_Hospital` char(9) NOT NULL,
  PRIMARY KEY (`Codi`,`CIF_Hospital`),
  KEY `FK_AREA_HOSPITAL` (`CIF_Hospital`),
  CONSTRAINT `FK_AREA_HOSPITAL` FOREIGN KEY (`CIF_Hospital`) REFERENCES `hospital` (`CIF`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `area`
--

LOCK TABLES `area` WRITE;
/*!40000 ALTER TABLE `area` DISABLE KEYS */;
INSERT INTO `area` VALUES (1,20,'08:00:00','Urgencias','A12345678'),(2,15,'08:00:00','Pediatría','B23456789'),(3,10,'08:00:00','Traumatología','C34567890');
/*!40000 ALTER TABLE `area` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `empleat_visita`
--

DROP TABLE IF EXISTS `empleat_visita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `empleat_visita` (
  `Codi_Empleat` int(10) unsigned NOT NULL,
  `DataHora_Inici_Visita` datetime NOT NULL,
  `DataHora_Final_Visita` datetime NOT NULL,
  `ID_Pacient` int(10) unsigned NOT NULL,
  `Codi_Area` int(10) unsigned NOT NULL,
  `CIF_Hospital` char(9) NOT NULL,
  PRIMARY KEY (`Codi_Empleat`),
  KEY `FK_EMPLEAT_VISITA_VISITA` (`DataHora_Inici_Visita`,`DataHora_Final_Visita`,`ID_Pacient`,`Codi_Area`,`CIF_Hospital`),
  CONSTRAINT `FK_EMPLEAT_VISITA_PERSONAL` FOREIGN KEY (`Codi_Empleat`) REFERENCES `personal` (`Codi`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `FK_EMPLEAT_VISITA_VISITA` FOREIGN KEY (`DataHora_Inici_Visita`, `DataHora_Final_Visita`, `ID_Pacient`, `Codi_Area`, `CIF_Hospital`) REFERENCES `visita` (`DataHora_Inici`, `DataHora_Final`, `ID_Pacient`, `Codi_Area`, `CIF_Hospital`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `empleat_visita`
--

LOCK TABLES `empleat_visita` WRITE;
/*!40000 ALTER TABLE `empleat_visita` DISABLE KEYS */;
INSERT INTO `empleat_visita` VALUES (1,'2025-05-12 10:00:00','2025-05-12 11:00:00',1,1,'A12345678'),(2,'2025-05-12 11:30:00','2025-05-12 12:30:00',2,2,'B23456789'),(3,'2025-05-12 13:00:00','2025-05-12 14:00:00',3,3,'C34567890');
/*!40000 ALTER TABLE `empleat_visita` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `hospital`
--

DROP TABLE IF EXISTS `hospital`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `hospital` (
  `CIF` char(9) NOT NULL,
  `Ubicacio` varchar(128) NOT NULL,
  `Nom` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`CIF`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `hospital`
--

LOCK TABLES `hospital` WRITE;
/*!40000 ALTER TABLE `hospital` DISABLE KEYS */;
INSERT INTO `hospital` VALUES ('A12345678','Barcelona','Hospital General'),('B23456789','Madrid','Hospital Central'),('C34567890','Valencia','Hospital de la Salud');
/*!40000 ALTER TABLE `hospital` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medic`
--

DROP TABLE IF EXISTS `medic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medic` (
  `Codi_Personal` int(10) unsigned NOT NULL,
  `Especialitat` varchar(128) NOT NULL,
  PRIMARY KEY (`Codi_Personal`),
  CONSTRAINT `FK_MEDIC_PERSONAL` FOREIGN KEY (`Codi_Personal`) REFERENCES `personal` (`Codi`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medic`
--

LOCK TABLES `medic` WRITE;
/*!40000 ALTER TABLE `medic` DISABLE KEYS */;
INSERT INTO `medic` VALUES (1,'Cardiología'),(2,'Pediatría'),(3,'Traumatología');
/*!40000 ALTER TABLE `medic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `medic_certificats`
--

DROP TABLE IF EXISTS `medic_certificats`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `medic_certificats` (
  `Certificats` varchar(128) NOT NULL,
  `Codi_Personal` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Certificats`,`Codi_Personal`),
  KEY `FK_MEDIC_CERTIFICATS_PERSONAL` (`Codi_Personal`),
  CONSTRAINT `FK_MEDIC_CERTIFICATS_PERSONAL` FOREIGN KEY (`Codi_Personal`) REFERENCES `medic` (`Codi_Personal`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `medic_certificats`
--

LOCK TABLES `medic_certificats` WRITE;
/*!40000 ALTER TABLE `medic_certificats` DISABLE KEYS */;
INSERT INTO `medic_certificats` VALUES ('Certificado de Cirugía',3),('Certificado de Especialista',1),('Certificado de Urgencias',2);
/*!40000 ALTER TABLE `medic_certificats` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `no_medic`
--

DROP TABLE IF EXISTS `no_medic`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `no_medic` (
  `Codi_Personal` int(10) unsigned NOT NULL,
  `Departament` varchar(64) NOT NULL,
  PRIMARY KEY (`Codi_Personal`),
  CONSTRAINT `FK_NO_MEDIC_PERSONAL` FOREIGN KEY (`Codi_Personal`) REFERENCES `personal` (`Codi`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `no_medic`
--

LOCK TABLES `no_medic` WRITE;
/*!40000 ALTER TABLE `no_medic` DISABLE KEYS */;
INSERT INTO `no_medic` VALUES (1,'Administración'),(2,'Atención al Paciente'),(3,'Mantenimiento');
/*!40000 ALTER TABLE `no_medic` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `no_medic_tasques`
--

DROP TABLE IF EXISTS `no_medic_tasques`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `no_medic_tasques` (
  `Tasques` varchar(128) NOT NULL,
  `Codi_personal` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Tasques`,`Codi_personal`),
  KEY `FK_NO_MEDIC_TASQUES_PERSONAL` (`Codi_personal`),
  CONSTRAINT `FK_NO_MEDIC_TASQUES_PERSONAL` FOREIGN KEY (`Codi_personal`) REFERENCES `no_medic` (`Codi_Personal`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `no_medic_tasques`
--

LOCK TABLES `no_medic_tasques` WRITE;
/*!40000 ALTER TABLE `no_medic_tasques` DISABLE KEYS */;
/*!40000 ALTER TABLE `no_medic_tasques` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacient`
--

DROP TABLE IF EXISTS `pacient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacient` (
  `ID` int(10) unsigned NOT NULL,
  `Nom` varchar(32) NOT NULL,
  `Cognoms` varchar(64) NOT NULL,
  `DataNaixement` datetime NOT NULL,
  `Telefono` varchar(12) NOT NULL,
  `Correu` varchar(64) NOT NULL,
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacient`
--

LOCK TABLES `pacient` WRITE;
/*!40000 ALTER TABLE `pacient` DISABLE KEYS */;
INSERT INTO `pacient` VALUES (1,'Carlos','Sánchez','1985-05-12 00:00:00','612345681','carlos.sanchez@correo.com'),(2,'Ana','López','1990-07-22 00:00:00','612345682','ana.lopez@correo.com'),(3,'Pedro','Ramírez','1978-11-30 00:00:00','612345683','pedro.ramirez@correo.com');
/*!40000 ALTER TABLE `pacient` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pacient_antecedents`
--

DROP TABLE IF EXISTS `pacient_antecedents`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `pacient_antecedents` (
  `Antecedents` varchar(128) NOT NULL,
  `ID_Pacient` int(10) unsigned NOT NULL,
  PRIMARY KEY (`Antecedents`,`ID_Pacient`),
  KEY `FK_PACIENT_ANTECEDENTS_PACIENT` (`ID_Pacient`),
  CONSTRAINT `FK_PACIENT_ANTECEDENTS_PACIENT` FOREIGN KEY (`ID_Pacient`) REFERENCES `pacient` (`ID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pacient_antecedents`
--

LOCK TABLES `pacient_antecedents` WRITE;
/*!40000 ALTER TABLE `pacient_antecedents` DISABLE KEYS */;
INSERT INTO `pacient_antecedents` VALUES ('Asma',3),('Diabetes',2),('Hipertensión',1);
/*!40000 ALTER TABLE `pacient_antecedents` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `personal`
--

DROP TABLE IF EXISTS `personal`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `personal` (
  `Codi` int(10) unsigned NOT NULL,
  `Nom` varchar(32) NOT NULL,
  `Cognoms` varchar(64) NOT NULL,
  `Salari` decimal(10,2) unsigned NOT NULL,
  `DataContracte` datetime NOT NULL,
  `Telefono` varchar(12) NOT NULL,
  `Correu` varchar(64) NOT NULL,
  `CIF_Hospital` char(9) NOT NULL,
  PRIMARY KEY (`Codi`),
  KEY `FK_PERSONAL_HOSPITAL` (`CIF_Hospital`),
  CONSTRAINT `FK_PERSONAL_HOSPITAL` FOREIGN KEY (`CIF_Hospital`) REFERENCES `hospital` (`CIF`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `personal`
--

LOCK TABLES `personal` WRITE;
/*!40000 ALTER TABLE `personal` DISABLE KEYS */;
INSERT INTO `personal` VALUES (1,'Juan','Pérez',3000.00,'2023-01-15 09:00:00','612345678','juan.perez@hospital.com','A12345678'),(2,'María','Gómez',2800.00,'2023-02-20 09:00:00','612345679','maria.gomez@hospital.com','B23456789'),(3,'Luis','Martínez',3200.00,'2023-03-10 09:00:00','612345680','luis.martinez@hospital.com','C34567890');
/*!40000 ALTER TABLE `personal` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `visita`
--

DROP TABLE IF EXISTS `visita`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `visita` (
  `DataHora_Inici` datetime NOT NULL,
  `DataHora_Final` datetime NOT NULL,
  `ID_Pacient` int(10) unsigned NOT NULL,
  `Codi_Area` int(10) unsigned NOT NULL,
  `CIF_Hospital` char(9) NOT NULL,
  PRIMARY KEY (`DataHora_Inici`,`DataHora_Final`,`ID_Pacient`,`Codi_Area`,`CIF_Hospital`),
  KEY `FK_VISITA_PACIENTE` (`ID_Pacient`),
  KEY `FK_VISITA_AREA_HOSPITAL` (`Codi_Area`,`CIF_Hospital`),
  CONSTRAINT `FK_VISITA_AREA_HOSPITAL` FOREIGN KEY (`Codi_Area`, `CIF_Hospital`) REFERENCES `area` (`Codi`, `CIF_Hospital`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `FK_VISITA_PACIENTE` FOREIGN KEY (`ID_Pacient`) REFERENCES `pacient` (`ID`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `visita`
--

LOCK TABLES `visita` WRITE;
/*!40000 ALTER TABLE `visita` DISABLE KEYS */;
INSERT INTO `visita` VALUES ('2025-05-12 10:00:00','2025-05-12 11:00:00',1,1,'A12345678'),('2025-05-12 11:30:00','2025-05-12 12:30:00',2,2,'B23456789'),('2025-05-12 13:00:00','2025-05-12 14:00:00',3,3,'C34567890');
/*!40000 ALTER TABLE `visita` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2025-05-19 12:52:43
