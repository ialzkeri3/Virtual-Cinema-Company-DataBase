CREATE DATABASE  IF NOT EXISTS `atlmovie` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `atlmovie`;
-- MySQL dump 10.13  Distrib 8.0.17, for macos10.14 (x86_64)
--
-- Host: localhost    Database: atlmovie
-- ------------------------------------------------------
-- Server version	8.0.17

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
-- Table structure for table `Admin`
--

DROP TABLE IF EXISTS `Admin`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Admin` (
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `FK_Admin_User_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Admin`
--

LOCK TABLES `Admin` WRITE;
/*!40000 ALTER TABLE `Admin` DISABLE KEYS */;
INSERT INTO `Admin` VALUES ('cool_class4400');
/*!40000 ALTER TABLE `Admin` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Company`
--

DROP TABLE IF EXISTS `Company`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Company` (
  `comName` varchar(50) NOT NULL,
  PRIMARY KEY (`comName`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Company`
--

LOCK TABLES `Company` WRITE;
/*!40000 ALTER TABLE `Company` DISABLE KEYS */;
INSERT INTO `Company` VALUES ('4400 Theater Company'),('AI Theater Company'),('Awesome Theater Company'),('EZ Theater Company');
/*!40000 ALTER TABLE `Company` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `FK_Customer_User_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES ('calcultron'),('calcultron2'),('calcwizard'),('clarinetbeast'),('cool_class4400'),('DNAhelix'),('does2Much'),('eeqmcsquare'),('entropyRox'),('fullMetal'),('georgep'),('ilikemoney$$'),('imready'),('isthisthekrustykrab'),('notFullMetal'),('programmerAAL'),('RitzLover28'),('thePiGuy3.14'),('theScienceGuy');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CustomerCreditCard`
--

DROP TABLE IF EXISTS `CustomerCreditCard`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerCreditCard` (
  `creditCardNum` char(16) NOT NULL,
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`creditCardNum`),
  KEY `FK_CustomerCreditCard_Customer_username_idx` (`username`),
  CONSTRAINT `FK_CustomerCreditCard_Customer_username` FOREIGN KEY (`username`) REFERENCES `customer` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CustomerCreditCard`
--

LOCK TABLES `CustomerCreditCard` WRITE;
/*!40000 ALTER TABLE `CustomerCreditCard` DISABLE KEYS */;
INSERT INTO `CustomerCreditCard` VALUES ('1111111111000000','calcultron'),('1111111100000000','calcultron2'),('1111111110000000','calcultron2'),('1111111111100000','calcwizard'),('2222222222000000','cool_class4400'),('2220000000000000','DNAhelix'),('2222222200000000','does2Much'),('2222222222222200','eeqmcsquare'),('2222222222200000','entropyRox'),('2222222222220000','entropyRox'),('1100000000000000','fullMetal'),('1111111111110000','georgep'),('1111111111111000','georgep'),('1111111111111100','georgep'),('1111111111111110','georgep'),('1111111111111111','georgep'),('2222222222222220','ilikemoney$$'),('2222222222222222','ilikemoney$$'),('9000000000000000','ilikemoney$$'),('1111110000000000','imready'),('1110000000000000','isthisthekrustykrab'),('1111000000000000','isthisthekrustykrab'),('1111100000000000','isthisthekrustykrab'),('1000000000000000','notFullMetal'),('2222222000000000','programmerAAL'),('3333333333333300','RitzLover28'),('2222222220000000','thePiGuy3.14'),('2222222222222000','theScienceGuy');
/*!40000 ALTER TABLE `CustomerCreditCard` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CustomerViewMovie`
--

DROP TABLE IF EXISTS `CustomerViewMovie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerViewMovie` (
  `creditCardNum` char(16) NOT NULL,
  `thName` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `movName` varchar(50) NOT NULL,
  `movRealeaseDate` date NOT NULL,
  `movPlayDate` date NOT NULL,
  PRIMARY KEY (`creditCardNum`,`thName`,`comName`,`movName`,`movRealeaseDate`,`movPlayDate`),
  KEY `FK_CustomerViewMovie_MoviePlay_thName,comName,movReleaseDat_idx` (`thName`,`comName`,`movName`,`movRealeaseDate`,`movPlayDate`),
  CONSTRAINT `FK_CustomerViewMovie_CustomerCreditCard_creditCardNum` FOREIGN KEY (`creditCardNum`) REFERENCES `customercreditcard` (`creditCardNum`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_CustomerViewMovie_MoviePlay_PrettyMuchTheWholeThing` FOREIGN KEY (`thName`, `comName`, `movName`, `movRealeaseDate`, `movPlayDate`) REFERENCES `movieplay` (`thName`, `comName`, `movName`, `movReleaseDate`, `movPlayDate`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CustomerViewMovie`
--

LOCK TABLES `CustomerViewMovie` WRITE;
/*!40000 ALTER TABLE `CustomerViewMovie` DISABLE KEYS */;
INSERT INTO `CustomerViewMovie` VALUES ('1111111111111111','Cinema Star','4400 Theater Company','How to Train Your Dragon','2010-03-21','2010-04-02'),('1111111111111111','Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-22'),('1111111111111111','Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-23'),('1111111111111100','Star Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-25');
/*!40000 ALTER TABLE `CustomerViewMovie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Employee`
--

DROP TABLE IF EXISTS `Employee`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Employee` (
  `username` varchar(50) NOT NULL,
  PRIMARY KEY (`username`),
  CONSTRAINT `FK_Employee_User_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Employee`
--

LOCK TABLES `Employee` WRITE;
/*!40000 ALTER TABLE `Employee` DISABLE KEYS */;
INSERT INTO `Employee` VALUES ('calcultron'),('entropyRox'),('fatherAl'),('georgep'),('ghcghc'),('imbatman'),('manager1'),('manager2'),('manager3'),('manager4'),('radioactivePoRa');
/*!40000 ALTER TABLE `Employee` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Manager`
--

DROP TABLE IF EXISTS `Manager`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Manager` (
  `username` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `manStreet` varchar(50) NOT NULL,
  `manCity` varchar(50) NOT NULL,
  `manState` enum('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY') NOT NULL,
  `manZipcode` int(5) NOT NULL,
  PRIMARY KEY (`username`),
  KEY `FK_Manager_Employee_username_idx` (`username`),
  KEY `FK_Manager_Company_comName_idx` (`comName`),
  CONSTRAINT `FK_Manager_Company_comName` FOREIGN KEY (`comName`) REFERENCES `company` (`comName`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_Manager_Employee_username` FOREIGN KEY (`username`) REFERENCES `employee` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Manager`
--

LOCK TABLES `Manager` WRITE;
/*!40000 ALTER TABLE `Manager` DISABLE KEYS */;
INSERT INTO `Manager` VALUES ('calcultron','EZ Theater Company','123 Peachtree St','Atlanta','GA',30308),('entropyRox','4400 Theater Company','200 Cool Place','San Francisco','CA',94016),('fatherAl','EZ Theater Company','456 Main Street','New York','NY',10001),('georgep','4400 Theater Company','10 Pearl Dr','Seattle','WA',98105),('ghcghc','AI Theater Company','100 Pi St','Pallet Town','KS',31415),('imbatman','Awesome Theater Company','800 Color Dr','Austin','TX',78653),('manager1','4400 Theater Company','123 Ferst Drive','Atlanta','GA',30332),('manager2','AI Theater Company','456 Ferst Drive','Atlanta','GA',30332),('manager3','4400 Theater Company','789 Ferst Drive','Atlanta','GA',30332),('manager4','4400 Theater Company','000 Ferst Drive','Atlanta','GA',30332),('radioactivePoRa','4400 Theater Company','100 Blu St','Sunnyvale','CA',94088);
/*!40000 ALTER TABLE `Manager` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Movie`
--

DROP TABLE IF EXISTS `Movie`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Movie` (
  `movName` varchar(50) NOT NULL,
  `movReleaseData` date NOT NULL,
  `duration` int(11) NOT NULL,
  PRIMARY KEY (`movName`,`movReleaseData`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Movie`
--

LOCK TABLES `Movie` WRITE;
/*!40000 ALTER TABLE `Movie` DISABLE KEYS */;
INSERT INTO `Movie` VALUES ('4400 The Movie','2019-08-12',130),('Avengers: Endgame','2019-04-26',181),('Calculus Returns: A ML Story','2019-09-19',314),('George P Burdell\'s Life Story','1927-08-12',100),('Georgia Tech The Movie','1985-08-13',100),('How to Train Your Dragon','2010-03-21',98),('Spaceballs','1987-06-24',96),('Spider-Man: Into the Spider-Verse','2018-12-01',117),('The First Pokemon Movie','1998-07-19',75),('The King\'s Speech','2010-11-26',119);
/*!40000 ALTER TABLE `Movie` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MoviePlay`
--

DROP TABLE IF EXISTS `MoviePlay`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MoviePlay` (
  `thName` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `movName` varchar(50) NOT NULL,
  `movReleaseDate` date NOT NULL,
  `movPlayDate` date NOT NULL,
  PRIMARY KEY (`thName`,`comName`,`movName`,`movReleaseDate`,`movPlayDate`),
  KEY `FK_MoviePlay_Movie_movName_idx` (`movName`,`movReleaseDate`),
  CONSTRAINT `FK_MoviePlay_Movie_movName,movReleaseDate` FOREIGN KEY (`movName`, `movReleaseDate`) REFERENCES `movie` (`movName`, `movReleaseData`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `FK_MoviePlay_Theater_thname,comName` FOREIGN KEY (`thName`, `comName`) REFERENCES `theater` (`thName`, `comName`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MoviePlay`
--

LOCK TABLES `MoviePlay` WRITE;
/*!40000 ALTER TABLE `MoviePlay` DISABLE KEYS */;
INSERT INTO `MoviePlay` VALUES ('ABC Theater','Awesome Theater Company','4400 The Movie','2019-08-12','2019-10-12'),('Cinema Star','4400 Theater Company','4400 The Movie','2019-08-12','2019-09-12'),('Star Movies','EZ Theater Company','4400 The Movie','2019-08-12','2019-08-12'),('ML Movies','AI Theater Company','Calculus Returns: A ML Story','2019-09-19','2019-10-10'),('ML Movies','AI Theater Company','Calculus Returns: A ML Story','2019-09-19','2019-12-30'),('Cinema Star','4400 Theater Company','George P Burdell\'s Life Story','1927-08-12','2010-05-20'),('Main Movies','EZ Theater Company','George P Burdell\'s Life Story','1927-08-12','2019-07-14'),('Main Movies','EZ Theater Company','George P Burdell\'s Life Story','1927-08-12','2019-10-22'),('ABC Theater','Awesome Theater Company','Georgia Tech The Movie','1985-08-13','1985-08-13'),('Cinema Star','4400 Theater Company','Georgia Tech The Movie','1985-08-13','2019-09-30'),('Cinema Star','4400 Theater Company','How to Train Your Dragon','2010-03-21','2010-04-02'),('Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-22'),('Main Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-23'),('Star Movies','EZ Theater Company','How to Train Your Dragon','2010-03-21','2010-03-25'),('Cinema Star','4400 Theater Company','Spaceballs','1987-06-24','2000-02-02'),('Main Movies','EZ Theater Company','Spaceballs','1987-06-24','1999-06-24'),('ML Movies','AI Theater Company','Spaceballs','1987-06-24','2010-04-02'),('ML Movies','AI Theater Company','Spaceballs','1987-06-24','2023-01-23'),('ML Movies','AI Theater Company','Spider-Man: Into the Spider-Verse','2018-12-01','2019-09-30'),('ABC Theater','Awesome Theater Company','The First Pokemon Movie','1998-07-19','2018-07-19'),('Cinema Star','4400 Theater Company','The King\'s Speech','2010-11-26','2019-12-20'),('Main Movies','EZ Theater Company','The King\'s Speech','2010-11-26','2019-12-20');
/*!40000 ALTER TABLE `MoviePlay` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Theater`
--

DROP TABLE IF EXISTS `Theater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Theater` (
  `thName` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `capacity` int(11) NOT NULL,
  `thStreet` varchar(50) NOT NULL,
  `thCity` varchar(50) NOT NULL,
  `thState` enum('AL','AK','AZ','AR','CA','CO','CT','DE','FL','GA','HI','ID','IL','IN','IA','KS','KY','LA','ME','MD','MA','MI','MN','MS','MO','MT','NE','NV','NH','NJ','NM','NY','NC','ND','OH','OK','OR','PA','RI','SC','SD','TN','TX','UT','VT','VA','WA','WV','WI','WY') NOT NULL,
  `thZipCode` int(5) NOT NULL,
  `manUsername` varchar(50) NOT NULL,
  PRIMARY KEY (`thName`,`comName`),
  UNIQUE KEY `manUsername_UNIQUE` (`manUsername`),
  KEY `FK_Theater_Company_comName_idx` (`comName`),
  CONSTRAINT `FK_Theater_Company_comName` FOREIGN KEY (`comName`) REFERENCES `company` (`comName`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_Theater_Manager_usernam` FOREIGN KEY (`manUsername`) REFERENCES `manager` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Theater`
--

LOCK TABLES `Theater` WRITE;
/*!40000 ALTER TABLE `Theater` DISABLE KEYS */;
INSERT INTO `Theater` VALUES ('ABC Theater','Awesome Theater Company',5,'880 Color Dr','Austin','TX',73301,'imbatman'),('Cinema Star','4400 Theater Company',4,'100 Cool Place','San Francisco','CA',94016,'entropyRox'),('Jonathan\'s Movies','4400 Theater Company',2,'67 Pearl Dr','Seattle','WA',98101,'georgep'),('Main Movies','EZ Theater Company',3,'123 Main St','New York','NY',10001,'fatherAl'),('ML Movies','AI Theater Company',3,'314 Pi St','Pallet Town','KS',31415,'ghcghc'),('Star Movies','4400 Theater Company',5,'4400 Rocks Ave','Boulder','CA',80301,'radioactivePoRa'),('Star Movies','EZ Theater Company',2,'745 GT St','Atlanta','GA',30332,'calcultron');
/*!40000 ALTER TABLE `Theater` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `username` varchar(50) NOT NULL,
  `status` enum('Approved','Declined','Pending') NOT NULL DEFAULT 'Pending',
  `firstName` varchar(50) NOT NULL,
  `lastName` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `userType` enum('User','Customer','Employee','Employee, Customer') NOT NULL DEFAULT 'User',
  PRIMARY KEY (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES ('calcultron','Approved','Dwight','Schrute','333333333','Employee, Customer'),('calcultron2','Approved','Jim','Halpert','444444444','Customer'),('calcwizard','Approved','Isaac','Newton','222222222','Customer'),('clarinetbeast','Declined','Squidward','Tentacles','999999999','Customer'),('cool_class4400','Approved','A. TA','Washere','333333333','Employee, Customer'),('DNAhelix','Approved','Rosalind','Franklin','777777777','Customer'),('does2Much','Approved','Carl','Gauss','1212121212','Customer'),('eeqmcsquare','Approved','Albert','Einstein','111111110','Customer'),('entropyRox','Approved','Claude','Shannon','999999999','Employee, Customer'),('fatherAl','Approved','Alan','Turing','222222222','Employee'),('fullMetal','Approved','Edward','Elric','111111100','Customer'),('gdanger','Declined','Gary','Danger','555555555','User'),('georgep','Approved','George P.','Burdell','111111111','Employee, Customer'),('ghcghc','Approved','Grace','Hopper','666666666','Employee'),('ilikemoney$$','Approved','Eugene','Krabs','111111110','Customer'),('imbatman','Approved','Bruce','Wayne','666666666','Employee'),('imready','Approved','Spongebob','Squarepants','777777777','Customer'),('isthisthekrustykrab','Approved','Patrick','Star','888888888','Customer'),('manager1','Approved','Manager','One','1122112211','Employee'),('manager2','Approved','Manager','Two','3131313131','Employee'),('manager3','Approved','Three','Three','8787878787','Employee'),('manager4','Approved','Four','Four','5755555555','Employee'),('notFullMetal','Approved','Alphonse','Elric','111111100','Customer'),('programmerAAL','Approved','Ada','Lovelace','3131313131','Customer'),('radioactivePoRa','Approved','Marie','Curie','1313131313','Employee'),('RitzLover28','Approved','Abby','Normal','444444444','Customer'),('smith_j','Pending','John','Smith','333333333','User'),('texasStarKarate','Declined','Sandy','Cheeks','111111110','User'),('thePiGuy3.14','Approved','Archimedes','Syracuse','1111111111','Customer'),('theScienceGuy','Approved','Bill','Nye','999999999','Customer');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `UserVisitTheater`
--

DROP TABLE IF EXISTS `UserVisitTheater`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `UserVisitTheater` (
  `visitID` int(11) NOT NULL,
  `username` varchar(50) NOT NULL,
  `thName` varchar(50) NOT NULL,
  `comName` varchar(50) NOT NULL,
  `visitDate` date NOT NULL,
  PRIMARY KEY (`visitID`),
  KEY `FK_UserVisitTheater_Theater_thName,comName_idx` (`thName`,`comName`),
  KEY `FK_UserVisitTheater_User_username_idx` (`username`),
  CONSTRAINT `FK_UserVisitTheater_Theater_thName,comName` FOREIGN KEY (`thName`, `comName`) REFERENCES `theater` (`thName`, `comName`) ON DELETE RESTRICT ON UPDATE CASCADE,
  CONSTRAINT `FK_UserVisitTheater_User_username` FOREIGN KEY (`username`) REFERENCES `user` (`username`) ON DELETE RESTRICT ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `UserVisitTheater`
--

LOCK TABLES `UserVisitTheater` WRITE;
/*!40000 ALTER TABLE `UserVisitTheater` DISABLE KEYS */;
INSERT INTO `UserVisitTheater` VALUES (1,'georgep','Main Movies','EZ Theater Company','2010-03-22'),(2,'calcwizard','Main Movies','EZ Theater Company','2010-03-22'),(3,'calcwizard','Star Movies','EZ Theater Company','2010-03-25'),(4,'imready','Star Movies','EZ Theater Company','2010-03-25'),(5,'calcwizard','ML Movies','AI Theater Company','2010-03-20');
/*!40000 ALTER TABLE `UserVisitTheater` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2019-11-19 11:18:55
