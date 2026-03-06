CREATE DATABASE  IF NOT EXISTS `ocean_view_resort` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `ocean_view_resort`;
-- MySQL dump 10.13  Distrib 8.0.44, for Win64 (x86_64)
--
-- Host: localhost    Database: ocean_view_resort
-- ------------------------------------------------------
-- Server version	8.0.44

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
-- Table structure for table `bills`
--

DROP TABLE IF EXISTS `bills`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `bills` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reservation_id` int NOT NULL,
  `num_nights` int NOT NULL,
  `room_rate` decimal(10,2) NOT NULL,
  `subtotal` decimal(10,2) NOT NULL,
  `tax_rate` decimal(5,2) DEFAULT '10.00',
  `tax_amount` decimal(10,2) NOT NULL,
  `total_amount` decimal(10,2) NOT NULL,
  `payment_status` enum('PENDING','PAID','PARTIAL') DEFAULT 'PENDING',
  `payment_method` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_id` (`reservation_id`),
  CONSTRAINT `bills_ibfk_1` FOREIGN KEY (`reservation_id`) REFERENCES `reservations` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `bills`
--

LOCK TABLES `bills` WRITE;
/*!40000 ALTER TABLE `bills` DISABLE KEYS */;
INSERT INTO `bills` VALUES (1,1,1,8500.00,8500.00,10.00,850.00,9350.00,'PENDING',NULL,'2026-03-05 10:23:25'),(2,2,2,12500.00,25000.00,10.00,2500.00,27500.00,'PENDING',NULL,'2026-03-05 22:28:34');
/*!40000 ALTER TABLE `bills` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `guests`
--

DROP TABLE IF EXISTS `guests`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `guests` (
  `id` int NOT NULL AUTO_INCREMENT,
  `guest_name` varchar(100) NOT NULL,
  `address` text NOT NULL,
  `contact_number` varchar(20) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `nic_passport` varchar(50) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `guests`
--

LOCK TABLES `guests` WRITE;
/*!40000 ALTER TABLE `guests` DISABLE KEYS */;
INSERT INTO `guests` VALUES (1,'Nimal Perera','20, galle Road colombo','0771001005','Nimalperera@gmail.com','','2026-03-05 10:23:25'),(2,'Hemal Perara','06 , Nugegoda Road , Colombo','077100300','hemalperera@gmail.com','','2026-03-05 22:28:34');
/*!40000 ALTER TABLE `guests` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `reservations`
--

DROP TABLE IF EXISTS `reservations`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `reservations` (
  `id` int NOT NULL AUTO_INCREMENT,
  `reservation_number` varchar(20) NOT NULL,
  `guest_id` int NOT NULL,
  `room_id` int NOT NULL,
  `room_type_id` int NOT NULL,
  `check_in_date` date NOT NULL,
  `check_out_date` date NOT NULL,
  `num_guests` int DEFAULT '1',
  `special_requests` text,
  `status` enum('CONFIRMED','CHECKED_IN','CHECKED_OUT','CANCELLED') DEFAULT 'CONFIRMED',
  `total_amount` decimal(10,2) DEFAULT NULL,
  `created_by` int DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  `updated_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `reservation_number` (`reservation_number`),
  KEY `guest_id` (`guest_id`),
  KEY `room_id` (`room_id`),
  KEY `room_type_id` (`room_type_id`),
  KEY `created_by` (`created_by`),
  CONSTRAINT `reservations_ibfk_1` FOREIGN KEY (`guest_id`) REFERENCES `guests` (`id`),
  CONSTRAINT `reservations_ibfk_2` FOREIGN KEY (`room_id`) REFERENCES `rooms` (`id`),
  CONSTRAINT `reservations_ibfk_3` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`),
  CONSTRAINT `reservations_ibfk_4` FOREIGN KEY (`created_by`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `reservations`
--

LOCK TABLES `reservations` WRITE;
/*!40000 ALTER TABLE `reservations` DISABLE KEYS */;
INSERT INTO `reservations` VALUES (1,'RES0001',1,1,1,'2026-03-06','2026-03-07',2,'-','CONFIRMED',9350.00,2,'2026-03-05 10:23:25','2026-03-05 10:23:25'),(2,'RES0002',2,16,2,'2026-03-07','2026-03-09',1,'','CONFIRMED',27500.00,5,'2026-03-05 22:28:34','2026-03-05 22:28:34');
/*!40000 ALTER TABLE `reservations` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `room_types`
--

DROP TABLE IF EXISTS `room_types`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `room_types` (
  `id` int NOT NULL AUTO_INCREMENT,
  `type_name` varchar(50) NOT NULL,
  `description` text,
  `rate_per_night` decimal(10,2) NOT NULL,
  `total_rooms` int NOT NULL DEFAULT '10',
  `is_active` tinyint(1) DEFAULT '1',
  PRIMARY KEY (`id`),
  UNIQUE KEY `type_name` (`type_name`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `room_types`
--

LOCK TABLES `room_types` WRITE;
/*!40000 ALTER TABLE `room_types` DISABLE KEYS */;
INSERT INTO `room_types` VALUES (1,'Standard','Comfortable room with garden view, AC, TV, WiFi',8500.00,15,1),(2,'Deluxe','Spacious room with partial sea view, AC, TV, minibar, WiFi',12500.00,10,1),(3,'Suite','Luxury suite with full sea view, jacuzzi, living area, WiFi',22000.00,5,1),(4,'Family Room','Large room for families, 2 queen beds, AC, TV, WiFi',16000.00,8,1),(5,'Beachfront Villa','Private villa with direct beach access, all amenities',35000.00,3,1);
/*!40000 ALTER TABLE `room_types` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `rooms`
--

DROP TABLE IF EXISTS `rooms`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `rooms` (
  `id` int NOT NULL AUTO_INCREMENT,
  `room_number` varchar(10) NOT NULL,
  `room_type_id` int NOT NULL,
  `floor_number` int DEFAULT '1',
  `status` enum('AVAILABLE','OCCUPIED','MAINTENANCE') DEFAULT 'AVAILABLE',
  PRIMARY KEY (`id`),
  UNIQUE KEY `room_number` (`room_number`),
  KEY `room_type_id` (`room_type_id`),
  CONSTRAINT `rooms_ibfk_1` FOREIGN KEY (`room_type_id`) REFERENCES `room_types` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=42 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rooms`
--

LOCK TABLES `rooms` WRITE;
/*!40000 ALTER TABLE `rooms` DISABLE KEYS */;
INSERT INTO `rooms` VALUES (1,'101',1,1,'OCCUPIED'),(2,'102',1,1,'AVAILABLE'),(3,'103',1,1,'AVAILABLE'),(4,'104',1,1,'AVAILABLE'),(5,'105',1,1,'AVAILABLE'),(6,'106',1,1,'AVAILABLE'),(7,'107',1,1,'AVAILABLE'),(8,'108',1,1,'AVAILABLE'),(9,'109',1,1,'AVAILABLE'),(10,'110',1,1,'AVAILABLE'),(11,'201',1,2,'AVAILABLE'),(12,'202',1,2,'AVAILABLE'),(13,'203',1,2,'AVAILABLE'),(14,'204',1,2,'AVAILABLE'),(15,'205',1,2,'AVAILABLE'),(16,'206',2,2,'OCCUPIED'),(17,'207',2,2,'AVAILABLE'),(18,'208',2,2,'AVAILABLE'),(19,'209',2,2,'AVAILABLE'),(20,'210',2,2,'AVAILABLE'),(21,'301',2,3,'AVAILABLE'),(22,'302',2,3,'AVAILABLE'),(23,'303',2,3,'AVAILABLE'),(24,'304',2,3,'AVAILABLE'),(25,'305',2,3,'AVAILABLE'),(26,'401',3,4,'AVAILABLE'),(27,'402',3,4,'AVAILABLE'),(28,'403',3,4,'AVAILABLE'),(29,'404',3,4,'AVAILABLE'),(30,'405',3,4,'AVAILABLE'),(31,'501',4,5,'AVAILABLE'),(32,'502',4,5,'AVAILABLE'),(33,'503',4,5,'AVAILABLE'),(34,'504',4,5,'AVAILABLE'),(35,'505',4,5,'AVAILABLE'),(36,'506',4,5,'AVAILABLE'),(37,'507',4,5,'AVAILABLE'),(38,'508',4,5,'AVAILABLE'),(39,'V01',5,1,'AVAILABLE'),(40,'V02',5,1,'AVAILABLE'),(41,'V03',5,1,'AVAILABLE');
/*!40000 ALTER TABLE `rooms` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `users` (
  `id` int NOT NULL AUTO_INCREMENT,
  `username` varchar(50) NOT NULL,
  `password` varchar(255) NOT NULL,
  `full_name` varchar(100) NOT NULL,
  `email` varchar(100) DEFAULT NULL,
  `role` enum('ADMIN','STAFF') NOT NULL DEFAULT 'STAFF',
  `is_active` tinyint(1) DEFAULT '1',
  `created_at` timestamp NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `users`
--

LOCK TABLES `users` WRITE;
/*!40000 ALTER TABLE `users` DISABLE KEYS */;
INSERT INTO `users` VALUES (1,'admin','admin123','System Administrator','admin@oceanview.com','ADMIN',1,'2026-03-03 17:56:29'),(2,'staff1','staff123','John Perera','john@oceanview.com','STAFF',1,'2026-03-03 17:56:29'),(5,'staff','staff123','Nadun Thathsara','Nadun@gmail.com','STAFF',1,'2026-03-05 22:22:59');
/*!40000 ALTER TABLE `users` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-03-07  5:10:54
