-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 21, 2024 at 01:15 AM
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
-- Database: `sentiment_analysis`
--

-- --------------------------------------------------------

--
-- Table structure for table `message`
--

CREATE TABLE `message` (
  `MessageID` int(11) NOT NULL,
  `SenderID` int(11) NOT NULL,
  `ReceiverID` int(11) NOT NULL,
  `SenderContent` text NOT NULL,
  `ReceiverContent` text NOT NULL,
  `Timestamp` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `message`
--

INSERT INTO `message` (`MessageID`, `SenderID`, `ReceiverID`, `SenderContent`, `ReceiverContent`, `Timestamp`) VALUES
(1, 1, 1, 'hello', '', '2024-05-20 22:03:33'),
(2, 1, 1, 'good', '', '2024-05-20 22:04:14'),
(3, 1, 1, 'zsdf', 'AI message goes here...', '2024-05-20 22:09:45'),
(4, 1, 1, 'sxdfg', '', '2024-05-20 22:17:24'),
(5, 1, 1, '', 'This is a bot\'s response.', '2024-05-20 22:17:24'),
(6, 1, 1, 'sdfg', 'This is a bot\'s response.', '2024-05-20 22:25:19'),
(7, 1, 1, 'sdfg', 'This is a bot\'s response.', '2024-05-20 22:25:25'),
(8, 1, 1, 'kjndfg', 'This is a bot\'s response.', '2024-05-20 22:38:45'),
(9, 1, 1, 'hello world', 'This is a bot\'s response.', '2024-05-20 22:39:06'),
(10, 1, 1, 'For most of 2011 to 2024, Apple became the world\'s largest company by market capitalization until Microsoft assumed the position in January 2024.[6][7] In 2022, Apple was the largest technology company by revenue, with US$394.3 billion.[8][failed verification] As of 2023, Apple was the fourth-largest personal computer vendor by unit sales,[9] the largest manufacturing company by revenue, and the largest vendor of mobile phones in the world.[10] It is one of the Big Five American information technology companies, alongside Alphabet (the parent company of Google), Amazon, Meta (the parent company of Facebook), and Microsoft.  Apple was founded as Apple Computer Company on April 1, 1976, to produce and market Steve Wozniak\'s Apple I personal computer. The company was incorporated by Wozniak and Steve Jobs in 1977. Its second computer, the Apple II, became a best seller as one of the first mass-produced microcomputers. Apple introduced the Lisa in 1983 and the Macintosh in 1984, as some of the first computers to use a graphical user interface and a mouse. By 1985, the company\'s internal problems included the high cost of its products and power struggles between executives. That year Jobs left Apple to form NeXT, Inc., and Wozniak withdrew to other ventures. The market for personal computers expanded and evolved throughout the 1990s, and Apple lost considerable market share to the lower-priced Wintel duopoly of the Microsoft Windows operating system on Intel-powered PC clones.', 'This is a bot\'s response.', '2024-05-20 22:46:26'),
(11, 1, 1, 'xcspngjfg', 'This is a bot\'s response.', '2024-05-20 22:51:43'),
(12, 1, 1, 'popopo', 'This is a bot\'s response.', '2024-05-20 22:57:36'),
(13, 1, 1, 'fghfgh', 'This is a bot\'s response.', '2024-05-20 23:01:50');

-- --------------------------------------------------------

--
-- Table structure for table `user`
--

CREATE TABLE `user` (
  `UserId` int(11) NOT NULL,
  `Username` varchar(255) NOT NULL,
  `Email` varchar(255) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user`
--

INSERT INTO `user` (`UserId`, `Username`, `Email`) VALUES
(1, 'Alif Abdullah Siam', 'alifabdullahsiam@gmail.com'),
(2, 'Mushfique Abdullah Rafi 2031435642', 'mushfique.rafi@northsouth.edu');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `message`
--
ALTER TABLE `message`
  ADD PRIMARY KEY (`MessageID`),
  ADD KEY `SenderID` (`SenderID`),
  ADD KEY `ReceiverID` (`ReceiverID`);

--
-- Indexes for table `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`UserId`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `message`
--
ALTER TABLE `message`
  MODIFY `MessageID` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `user`
--
ALTER TABLE `user`
  MODIFY `UserId` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `message`
--
ALTER TABLE `message`
  ADD CONSTRAINT `message_ibfk_1` FOREIGN KEY (`SenderID`) REFERENCES `user` (`UserId`),
  ADD CONSTRAINT `message_ibfk_2` FOREIGN KEY (`ReceiverID`) REFERENCES `user` (`UserId`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
