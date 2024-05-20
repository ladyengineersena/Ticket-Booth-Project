-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Anamakine: 127.0.0.1:3306
-- Üretim Zamanı: 13 May 2024, 16:41:31
-- Sunucu sürümü: 8.0.31
-- PHP Sürümü: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Veritabanı: `cinema`
--

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `bookings`
--

DROP TABLE IF EXISTS `bookings`;
CREATE TABLE IF NOT EXISTS `bookings` (
  `booking_id` int NOT NULL AUTO_INCREMENT,
  `customer_id` int DEFAULT NULL,
  `salon_id` int DEFAULT NULL,
  `seat_id` int DEFAULT NULL,
  `time_slot_id` int DEFAULT NULL,
  `status` varchar(50) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`booking_id`),
  UNIQUE KEY `unique_booking` (`time_slot_id`,`salon_id`,`seat_id`),
  KEY `customer_id` (`customer_id`),
  KEY `salon_id` (`salon_id`),
  KEY `seat_id` (`seat_id`),
  KEY `time_slot_id` (`time_slot_id`)
) ENGINE=MyISAM AUTO_INCREMENT=55 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `bookings`
--

INSERT INTO `bookings` (`booking_id`, `customer_id`, `salon_id`, `seat_id`, `time_slot_id`, `status`) VALUES
(42, 1, 1, 2, 1, 'confirmed'),
(43, 1, 2, 6, 1, 'confirmed'),
(44, 1, 3, 11, 4, 'confirmed'),
(48, 1, 3, 13, 1, 'pending'),
(51, 1, 3, 11, 1, 'pending');

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `salons`
--

DROP TABLE IF EXISTS `salons`;
CREATE TABLE IF NOT EXISTS `salons` (
  `salon_id` int NOT NULL AUTO_INCREMENT,
  `name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `location` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `capacity` int DEFAULT NULL,
  `image_url` text CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `price` int NOT NULL,
  PRIMARY KEY (`salon_id`)
) ENGINE=MyISAM AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `salons`
--

INSERT INTO `salons` (`salon_id`, `name`, `location`, `capacity`, `image_url`, `price`) VALUES
(1, 'Harry Potter and the\r\nDeathly Hallows – Part 1', 'Mid Town', 10, 'https://m.media-amazon.com/images/M/MV5BMTQ2OTE1Mjk0N15BMl5BanBnXkFtZTcwODE3MDAwNA@@._V1_.jpg', 150),
(2, 'PK', 'Up Town', 8, 'https://m.media-amazon.com/images/M/MV5BMTYzOTE2NjkxN15BMl5BanBnXkFtZTgwMDgzMTg0MzE@._V1_.jpg', 100),
(3, 'Capernaum', 'Down Town', 12, 'https://m.media-amazon.com/images/M/MV5BOGY3YzQxZWQtYjA4NS00ZDU1LWJhZmYtZjhlYmMxY2QzZGY1XkEyXkFqcGdeQXVyMTA4NjE0NjEy._V1_.jpg', 120);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `seats`
--

DROP TABLE IF EXISTS `seats`;
CREATE TABLE IF NOT EXISTS `seats` (
  `seat_id` int NOT NULL AUTO_INCREMENT,
  `salon_id` int DEFAULT NULL,
  `number` int DEFAULT NULL,
  `is_taken` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`seat_id`),
  KEY `salon_id` (`salon_id`)
) ENGINE=MyISAM AUTO_INCREMENT=16 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `seats`
--

INSERT INTO `seats` (`seat_id`, `salon_id`, `number`, `is_taken`) VALUES
(1, 1, 1, 0),
(2, 1, 2, 0),
(3, 1, 3, 1),
(4, 1, 4, 0),
(5, 1, 5, 1),
(6, 2, 1, 1),
(7, 2, 2, 1),
(8, 2, 3, 0),
(9, 2, 4, 0),
(10, 2, 5, 0),
(11, 3, 1, 0),
(12, 3, 2, 0),
(13, 3, 3, 0),
(14, 3, 4, 1),
(15, 3, 5, 1);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `timeslots`
--

DROP TABLE IF EXISTS `timeslots`;
CREATE TABLE IF NOT EXISTS `timeslots` (
  `time_slot_id` int NOT NULL AUTO_INCREMENT,
  `start_time` time DEFAULT NULL,
  `end_time` time DEFAULT NULL,
  `is_available` tinyint(1) DEFAULT NULL,
  PRIMARY KEY (`time_slot_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `timeslots`
--

INSERT INTO `timeslots` (`time_slot_id`, `start_time`, `end_time`, `is_available`) VALUES
(1, '12:00:00', '15:00:00', 1),
(2, '15:00:00', '18:00:00', 0),
(3, '18:00:00', '21:00:00', 1),
(4, '13:00:00', '16:00:00', 1),
(5, '16:00:00', '19:00:00', 0);

-- --------------------------------------------------------

--
-- Tablo için tablo yapısı `transactions`
--

DROP TABLE IF EXISTS `transactions`;
CREATE TABLE IF NOT EXISTS `transactions` (
  `transaction_id` int NOT NULL AUTO_INCREMENT,
  `booking_id` int DEFAULT NULL,
  `amount` decimal(10,2) DEFAULT NULL,
  `discount_applied` tinyint(1) DEFAULT NULL,
  `final_price` decimal(10,2) DEFAULT NULL,
  PRIMARY KEY (`transaction_id`),
  KEY `booking_id` (`booking_id`)
) ENGINE=MyISAM AUTO_INCREMENT=40 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Tablo döküm verisi `transactions`
--

INSERT INTO `transactions` (`transaction_id`, `booking_id`, `amount`, `discount_applied`, `final_price`) VALUES
(32, 42, '150.00', 1, '127.50'),
(33, 43, '100.00', 1, '85.00'),
(34, 44, '150.00', 1, '127.50');
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
