-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 16, 2025 at 02:22 PM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `priyanshu`
--

-- --------------------------------------------------------

--
-- Table structure for table `employees`
--

CREATE TABLE `employees` (
  `id` int(11) NOT NULL,
  `emp_id` varchar(50) DEFAULT NULL,
  `email` varchar(100) DEFAULT NULL,
  `username` varchar(100) DEFAULT NULL,
  `ename` varchar(100) DEFAULT NULL,
  `password` varchar(100) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employees`
--

INSERT INTO `employees` (`id`, `emp_id`, `email`, `username`, `ename`, `password`) VALUES
(1, NULL, 'chandu@gmail.com', 'cc101chandu', 'Chandu', '1234567890');

-- --------------------------------------------------------

--
-- Table structure for table `leads`
--

CREATE TABLE `leads` (
  `id` int(11) NOT NULL,
  `person_id` int(11) DEFAULT NULL,
  `name` varchar(100) DEFAULT NULL,
  `number` varchar(20) DEFAULT NULL,
  `owner` varchar(100) DEFAULT NULL,
  `branch` varchar(20) DEFAULT NULL,
  `source` varchar(20) DEFAULT NULL,
  `priority` varchar(100) DEFAULT NULL,
  `status` varchar(50) DEFAULT NULL,
  `next_meeting` varchar(100) DEFAULT NULL,
  `refrence` varchar(100) DEFAULT NULL,
  `description` varchar(200) DEFAULT NULL,
  `est_budget` int(11) DEFAULT NULL,
  `remark` varchar(255) DEFAULT NULL,
  `createdAt` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `leads`
--

INSERT INTO `leads` (`id`, `person_id`, `name`, `number`, `owner`, `branch`, `source`, `priority`, `status`, `next_meeting`, `refrence`, `description`, `est_budget`, `remark`, `createdAt`) VALUES
(1, 1, 'Ravi Kumar', '9876543210', 'Chandu', 'Delhi', 'Website', 'Important', 'No Requirement', '2025-05-17', 'Google Ads', 'Looking for home loan', 8388, 'ffyc', '2025-05-15 10:21:56'),
(2, 1, 'priyanshu', '12349846', 'priyanshu1', '', '', '', 'No Requirement', '2025-05-15', 'hd7eh', 'heebj', NULL, NULL, '2025-05-15 12:32:49'),
(3, 1, 'priyanshu', '12349846', 'priyanshu1', '', '', '', 'No Requirement', '2025-05-15', 'hd7eh', 'heebj', NULL, NULL, '2025-05-15 12:34:27'),
(4, 1, 'heyve', '9434', 'bshsv', 'Default', 'Newspaper', 'High Priority and Important', 'Interested', '2025-05-15', 'gsusv', 'hs8sb', NULL, NULL, '2025-05-15 12:36:13'),
(6, 1, 'a', '11255', 'me', 'Default', 'Newspaper', 'Mid', 'Call Back', '', 'srf', 'fyv', NULL, NULL, '2025-05-16 07:01:09'),
(7, 1, 'b', '427566', 'me', 'Default', 'Newspaper', 'Mid', 'No Requirement', '', 'vsub', 'beurb', NULL, NULL, '2025-05-16 11:33:21'),
(8, 1, 'c', '86858', 'Preassigned owner Name', 'Default', 'Newspaper', 'Important', 'Document Rejected', '', 'hhib', 'hjb', NULL, NULL, '2025-05-16 11:41:28');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `employees`
--
ALTER TABLE `employees`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `leads`
--
ALTER TABLE `leads`
  ADD PRIMARY KEY (`id`),
  ADD KEY `person_id` (`person_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `employees`
--
ALTER TABLE `employees`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `leads`
--
ALTER TABLE `leads`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `leads`
--
ALTER TABLE `leads`
  ADD CONSTRAINT `leads_ibfk_1` FOREIGN KEY (`person_id`) REFERENCES `employees` (`id`) ON DELETE CASCADE;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
