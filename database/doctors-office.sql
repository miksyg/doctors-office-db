-- MySQL dump 10.13  Distrib 8.0.27, for macos11 (x86_64)
--
-- Host: localhost    Database: doctors_office
-- ------------------------------------------------------
-- Server version	8.0.27

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `appointment`
--

DROP TABLE IF EXISTS `appointment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment` (
  `AppointmentID` int NOT NULL AUTO_INCREMENT,
  `DoctorID` int NOT NULL,
  `PatientID` int NOT NULL,
  `RoomID` int NOT NULL,
  `AppointmentBookingDate` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `AppointmentDate` datetime DEFAULT NULL,
  `AppointmentTime` varchar(8) DEFAULT NULL,
  `Notes` text,
  `IsFOC` varchar(1) NOT NULL DEFAULT 'N',
  `IsCancelled` varchar(1) NOT NULL DEFAULT 'N',
  `LastModified` datetime DEFAULT NULL,
  PRIMARY KEY (`AppointmentID`),
  KEY `DoctorID` (`DoctorID`),
  KEY `PatientID` (`PatientID`),
  KEY `RoomID` (`RoomID`),
  CONSTRAINT `appointment_ibfk_1` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`),
  CONSTRAINT `appointment_ibfk_2` FOREIGN KEY (`PatientID`) REFERENCES `patient` (`PatientID`),
  CONSTRAINT `appointment_ibfk_3` FOREIGN KEY (`RoomID`) REFERENCES `room` (`RoomID`),
  CONSTRAINT `check_dates` CHECK ((`AppointmentDate` >= `AppointmentBookingDate`)),
  CONSTRAINT `check_iscancelled` CHECK ((`IsCancelled` in (_utf8mb3'Y',_utf8mb3'N'))),
  CONSTRAINT `check_isfoc` CHECK ((`IsFOC` in (_utf8mb3'Y',_utf8mb3'N')))
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_lastmodified` BEFORE UPDATE ON `appointment` FOR EACH ROW set new.lastmodified = current_timestamp() */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `appointment_diagnosis`
--

DROP TABLE IF EXISTS `appointment_diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `appointment_diagnosis` (
  `AppointmentID` int NOT NULL,
  `DiagnosisID` int NOT NULL,
  KEY `AppointmentID` (`AppointmentID`),
  KEY `DiagnosisID` (`DiagnosisID`),
  CONSTRAINT `appointment_diagnosis_ibfk_1` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`),
  CONSTRAINT `appointment_diagnosis_ibfk_2` FOREIGN KEY (`DiagnosisID`) REFERENCES `diagnosis` (`DiagnosisID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `bill`
--

DROP TABLE IF EXISTS `bill`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bill` (
  `BillID` int NOT NULL AUTO_INCREMENT,
  `AppointmentID` int NOT NULL,
  `BillCode` varchar(255) NOT NULL,
  `DateIssued` datetime NOT NULL,
  `DatePaid` datetime DEFAULT NULL,
  `Cost` decimal(10,0) NOT NULL,
  `IsPaid` varchar(1) NOT NULL DEFAULT 'N',
  `Notes` text,
  PRIMARY KEY (`BillID`),
  UNIQUE KEY `AppointmentID_UNIQUE` (`AppointmentID`),
  CONSTRAINT `bill_ibfk_1` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`),
  CONSTRAINT `check_ispaid` CHECK ((`IsPaid` in (_utf8mb3'Y',_utf8mb3'N')))
) ENGINE=InnoDB AUTO_INCREMENT=90 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `diagnosis`
--

DROP TABLE IF EXISTS `diagnosis`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `diagnosis` (
  `DiagnosisID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `ICDCode` varchar(7) NOT NULL,
  `Description` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`DiagnosisID`),
  UNIQUE KEY `ICDCode` (`ICDCode`)
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `doctor`
--

DROP TABLE IF EXISTS `doctor`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor` (
  `DoctorID` int NOT NULL AUTO_INCREMENT,
  `UserID` int NOT NULL,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `LicenseNumber` varchar(255) NOT NULL,
  PRIMARY KEY (`DoctorID`),
  UNIQUE KEY `UserID_UNIQUE` (`UserID`),
  CONSTRAINT `doctor_ibfk_1` FOREIGN KEY (`UserID`) REFERENCES `user` (`UserID`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `doctor_speciality`
--

DROP TABLE IF EXISTS `doctor_speciality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `doctor_speciality` (
  `DoctorID` int NOT NULL,
  `SpecialityID` int NOT NULL,
  KEY `doctor_speciality_ibfk_1` (`DoctorID`),
  KEY `doctor_speciality_ibfk_2` (`SpecialityID`),
  CONSTRAINT `doctor_speciality_ibfk_1` FOREIGN KEY (`DoctorID`) REFERENCES `doctor` (`DoctorID`),
  CONSTRAINT `doctor_speciality_ibfk_2` FOREIGN KEY (`SpecialityID`) REFERENCES `speciality` (`SpecialityID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `drug`
--

DROP TABLE IF EXISTS `drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `drug` (
  `DrugID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Description` text,
  `Dosage` varchar(255) DEFAULT NULL,
  `IsRefund` varchar(1) NOT NULL,
  `Notes` text,
  PRIMARY KEY (`DrugID`),
  CONSTRAINT `check_isrefund` CHECK ((`IsRefund` in (_utf8mb3'Y',_utf8mb3'N')))
) ENGINE=InnoDB AUTO_INCREMENT=101 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `patient`
--

DROP TABLE IF EXISTS `patient`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `patient` (
  `PatientID` int NOT NULL AUTO_INCREMENT,
  `FirstName` varchar(255) NOT NULL,
  `LastName` varchar(255) NOT NULL,
  `DOB` datetime DEFAULT NULL,
  `IsEnsurance` varchar(1) NOT NULL,
  `Address` text,
  `Phone` char(20) DEFAULT NULL,
  `Email` char(255) DEFAULT NULL,
  PRIMARY KEY (`PatientID`),
  CONSTRAINT `check_isensurance` CHECK ((`IsEnsurance` in (_utf8mb3'Y',_utf8mb3'N')))
) ENGINE=InnoDB AUTO_INCREMENT=76 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `prescription`
--

DROP TABLE IF EXISTS `prescription`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription` (
  `PrescriptionID` int NOT NULL AUTO_INCREMENT,
  `AppointmentID` int NOT NULL,
  `PrescriptionCode` varchar(255) NOT NULL,
  `Date` datetime NOT NULL,
  `ValidUntil` datetime DEFAULT NULL,
  PRIMARY KEY (`PrescriptionID`),
  UNIQUE KEY `PrescriptionCode` (`PrescriptionCode`),
  KEY `AppointmentID` (`AppointmentID`),
  CONSTRAINT `prescription_ibfk_1` FOREIGN KEY (`AppointmentID`) REFERENCES `appointment` (`AppointmentID`)
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_validuntil_insert` BEFORE INSERT ON `prescription` FOR EACH ROW set new.validuntil = date_add(new.date, interval 30 day) */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`root`@`localhost`*/ /*!50003 TRIGGER `trg_validuntil_update` BEFORE UPDATE ON `prescription` FOR EACH ROW BEGIN
   IF !(NEW.Date <=> OLD.Date) THEN
	set new.validuntil = date_add(new.Date, interval 30 day);
   END IF;
   END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `prescription_drug`
--

DROP TABLE IF EXISTS `prescription_drug`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `prescription_drug` (
  `PrescriptionID` int NOT NULL,
  `DrugID` int NOT NULL,
  KEY `PrescriptionID` (`PrescriptionID`),
  KEY `DrugID` (`DrugID`),
  CONSTRAINT `prescription_drug_ibfk_1` FOREIGN KEY (`PrescriptionID`) REFERENCES `prescription` (`PrescriptionID`),
  CONSTRAINT `prescription_drug_ibfk_2` FOREIGN KEY (`DrugID`) REFERENCES `drug` (`DrugID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `room`
--

DROP TABLE IF EXISTS `room`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room` (
  `RoomID` int NOT NULL AUTO_INCREMENT,
  `RoomCode` varchar(25) NOT NULL,
  `RoomDescription` text,
  `LogActive` varchar(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`RoomID`),
  UNIQUE KEY `RoomCode_UNIQUE` (`RoomCode`),
  CONSTRAINT `check_isactive` CHECK ((`LogActive` in (_utf8mb3'Y',_utf8mb3'N')))
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `speciality`
--

DROP TABLE IF EXISTS `speciality`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `speciality` (
  `SpecialityID` int NOT NULL AUTO_INCREMENT,
  `Name` varchar(255) NOT NULL,
  `Description` text,
  PRIMARY KEY (`SpecialityID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `UserID` int NOT NULL AUTO_INCREMENT,
  `Email` varchar(255) NOT NULL,
  `Password` varchar(255) NOT NULL,
  `LogActive` varchar(1) NOT NULL DEFAULT 'Y',
  PRIMARY KEY (`UserID`),
  UNIQUE KEY `uniqe_mail` (`Email`),
  CONSTRAINT `check_logactive` CHECK ((`LogActive` in (_utf8mb3'Y',_utf8mb3'N')))
) ENGINE=InnoDB AUTO_INCREMENT=51 DEFAULT CHARSET=utf8mb3;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Temporary view structure for view `v_avarage_booking_to_appointment_time`
--

DROP TABLE IF EXISTS `v_avarage_booking_to_appointment_time`;
/*!50001 DROP VIEW IF EXISTS `v_avarage_booking_to_appointment_time`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_avarage_booking_to_appointment_time` AS SELECT 
 1 AS `DAYS`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_doctors_specialities`
--

DROP TABLE IF EXISTS `v_doctors_specialities`;
/*!50001 DROP VIEW IF EXISTS `v_doctors_specialities`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_doctors_specialities` AS SELECT 
 1 AS `Doctor`,
 1 AS `Specialization`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_patient_drugs`
--

DROP TABLE IF EXISTS `v_patient_drugs`;
/*!50001 DROP VIEW IF EXISTS `v_patient_drugs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_patient_drugs` AS SELECT 
 1 AS `PATIENT`,
 1 AS `DRUG`,
 1 AS `PRESCRIPTION DATE`,
 1 AS `PRESCRIPTION`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_patients_age`
--

DROP TABLE IF EXISTS `v_patients_age`;
/*!50001 DROP VIEW IF EXISTS `v_patients_age`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_patients_age` AS SELECT 
 1 AS `AGE`,
 1 AS `PATIENTS COUNT`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_pending_bills`
--

DROP TABLE IF EXISTS `v_pending_bills`;
/*!50001 DROP VIEW IF EXISTS `v_pending_bills`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_pending_bills` AS SELECT 
 1 AS `BILL CODE`,
 1 AS `BILL DATE`,
 1 AS `APPOINTMENT DATE`,
 1 AS `COST`,
 1 AS `PATIENT`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_timetable_for_today`
--

DROP TABLE IF EXISTS `v_timetable_for_today`;
/*!50001 DROP VIEW IF EXISTS `v_timetable_for_today`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_timetable_for_today` AS SELECT 
 1 AS `TIME`,
 1 AS `DOCTOR`,
 1 AS `ROOM`,
 1 AS `PATIENT`*/;
SET character_set_client = @saved_cs_client;

--
-- Temporary view structure for view `v_top_used_drugs`
--

DROP TABLE IF EXISTS `v_top_used_drugs`;
/*!50001 DROP VIEW IF EXISTS `v_top_used_drugs`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `v_top_used_drugs` AS SELECT 
 1 AS `DRUG NAME`,
 1 AS `PRESCRIPTED`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'doctors_office'
--
/*!50003 DROP PROCEDURE IF EXISTS `pr_cancel_visit` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_cancel_visit`(
	IN Appointment INT
)
BEGIN
	update appointment
    set IsCancelled = 'Y' 
    where AppointmentID = Appointment ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pr_deactivate_user` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_deactivate_user`(
	IN User INT
)
BEGIN
	update user
    set LogActive = 'N' 
    where UserID = User ;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `pr_show_timetable_for_doctor` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER=`root`@`localhost` PROCEDURE `pr_show_timetable_for_doctor`(start_date varchar(10), end_date varchar(10), mail varchar(255))
BEGIN
      SELECT date(a.appointmentdate) AS 'DATE', a.appointmenttime AS 'TIME',  concat(r.roomcode,', ', r.roomdescription) AS 'ROOM', concat(p.firstname,' ', p.lastname) AS 'PATIENT' 
      FROM appointment a INNER JOIN doctor d ON a.doctorid = d.doctorid
INNER JOIN patient p ON p.patientid = a.patientid
INNER JOIN room r ON r.roomid = a.roomid 
INNER JOIN user u ON u.userid = d.userid
WHERE a.iscancelled = 'N' AND (a.appointmentdate BETWEEN cast(start_date AS DATE) AND cast(end_date AS DATE)) 
AND u.email = mail
ORDER BY a.appointmentdate;
   END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `v_avarage_booking_to_appointment_time`
--

/*!50001 DROP VIEW IF EXISTS `v_avarage_booking_to_appointment_time`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_avarage_booking_to_appointment_time` AS select round(avg((to_days(`appointment`.`AppointmentDate`) - to_days(`appointment`.`AppointmentBookingDate`))),2) AS `DAYS` from `appointment` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_doctors_specialities`
--

/*!50001 DROP VIEW IF EXISTS `v_doctors_specialities`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_doctors_specialities` AS select concat(`doctor`.`FirstName`,' ',`doctor`.`LastName`) AS `Doctor`,group_concat(`speciality`.`Description` separator ',') AS `Specialization` from ((`doctor` left join `doctor_speciality` on((`doctor`.`DoctorID` = `doctor_speciality`.`DoctorID`))) left join `speciality` on((`speciality`.`SpecialityID` = `doctor_speciality`.`SpecialityID`))) group by `doctor`.`DoctorID` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_patient_drugs`
--

/*!50001 DROP VIEW IF EXISTS `v_patient_drugs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_patient_drugs` AS select concat(`pat`.`FirstName`,' ',`pat`.`LastName`) AS `PATIENT`,`d`.`Name` AS `DRUG`,cast(`p`.`Date` as date) AS `PRESCRIPTION DATE`,`p`.`PrescriptionCode` AS `PRESCRIPTION` from ((((`prescription` `p` join `prescription_drug` `pd` on((`p`.`PrescriptionID` = `pd`.`PrescriptionID`))) join `drug` `d` on((`d`.`DrugID` = `pd`.`DrugID`))) join `appointment` `a` on((`p`.`AppointmentID` = `a`.`AppointmentID`))) join `patient` `pat` on((`pat`.`PatientID` = `a`.`PatientID`))) order by `p`.`Date` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_patients_age`
--

/*!50001 DROP VIEW IF EXISTS `v_patients_age`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_patients_age` AS select timestampdiff(YEAR,`patient`.`DOB`,curdate()) AS `AGE`,count(`patient`.`PatientID`) AS `PATIENTS COUNT` from `patient` group by timestampdiff(YEAR,`patient`.`DOB`,curdate()) order by `AGE` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_pending_bills`
--

/*!50001 DROP VIEW IF EXISTS `v_pending_bills`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_pending_bills` AS select `b`.`BillCode` AS `BILL CODE`,`b`.`DateIssued` AS `BILL DATE`,`a`.`AppointmentDate` AS `APPOINTMENT DATE`,`b`.`Cost` AS `COST`,concat(`p`.`FirstName`,' ',`p`.`LastName`) AS `PATIENT` from ((`appointment` `a` join `bill` `b` on((`a`.`AppointmentID` = `b`.`AppointmentID`))) join `patient` `p` on((`p`.`PatientID` = `a`.`PatientID`))) where (`b`.`IsPaid` = 'N') order by `b`.`DateIssued` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_timetable_for_today`
--

/*!50001 DROP VIEW IF EXISTS `v_timetable_for_today`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_timetable_for_today` AS select `a`.`AppointmentTime` AS `TIME`,concat(`d`.`FirstName`,' ',`d`.`LastName`) AS `DOCTOR`,concat(`r`.`RoomCode`,', ',`r`.`RoomDescription`) AS `ROOM`,concat(`p`.`FirstName`,' ',`p`.`LastName`) AS `PATIENT` from (((`appointment` `a` join `doctor` `d` on((`a`.`DoctorID` = `d`.`DoctorID`))) join `patient` `p` on((`p`.`PatientID` = `a`.`PatientID`))) join `room` `r` on((`r`.`RoomID` = `a`.`RoomID`))) where ((`a`.`IsCancelled` = 'N') and (`a`.`AppointmentDate` = curdate())) order by `a`.`AppointmentTime` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `v_top_used_drugs`
--

/*!50001 DROP VIEW IF EXISTS `v_top_used_drugs`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `v_top_used_drugs` AS select `d`.`Name` AS `DRUG NAME`,count(`pd`.`PrescriptionID`) AS `PRESCRIPTED` from (`prescription_drug` `pd` join `drug` `d` on((`pd`.`DrugID` = `d`.`DrugID`))) group by `pd`.`DrugID` order by count(`pd`.`PrescriptionID`) desc */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2022-07-04 22:12:01
