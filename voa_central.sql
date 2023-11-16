-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1:3306
-- Generation Time: Oct 31, 2023 at 03:43 AM
-- Server version: 8.0.31
-- PHP Version: 8.0.26

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `voa_central`
--

-- --------------------------------------------------------

--
-- Table structure for table `activity_logs`
--

DROP TABLE IF EXISTS `activity_logs`;
CREATE TABLE IF NOT EXISTS `activity_logs` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uid` binary(16) NOT NULL,
  `record_id` binary(16) DEFAULT NULL,
  `record_type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'table name',
  `action` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'add,edit,delete,print,scan,login,logout,change_password',
  `ref_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'main id of action, ex: visa_id, passport_id, username,...',
  `data` json DEFAULT NULL COMMENT 'save data as json',
  `description` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'short description of activity',
  `ip` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `record_id` (`record_id`,`record_type`),
  KEY `action` (`action`),
  KEY `ref_id` (`ref_id`),
  KEY `uid` (`uid`),
  KEY `port` (`port`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `attempts`
--

DROP TABLE IF EXISTS `attempts`;
CREATE TABLE IF NOT EXISTS `attempts` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `user` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `uid` binary(16) DEFAULT NULL,
  `type` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ip` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `created_at` datetime NOT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`),
  KEY `type` (`type`),
  KEY `ip` (`ip`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `checklists`
--

DROP TABLE IF EXISTS `checklists`;
CREATE TABLE IF NOT EXISTS `checklists` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `base_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'nationality-passportNo-port-timestamp, ex: KHM-N0134529-PHN-1687850295',
  `passport_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'nationality-passport_no, ex: KHM-N00001',
  `passport_no` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `issued_date` date DEFAULT NULL,
  `expire_date` date NOT NULL,
  `surname` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `given_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sex` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dob` date DEFAULT NULL,
  `nationality` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'country code',
  `data` json DEFAULT NULL COMMENT 'additional fields',
  `uid` binary(16) NOT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `match_als` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=none, 1=match, 2=no result, 3=not check with ALS',
  `status_code` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=no_internet, 1=success, 2=error_connection, 3=invalid_request, 4=page_not_found, 5=encryption, 6=decryption, 9=other',
  `als_message` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `als_response` json DEFAULT NULL COMMENT 'save the response data from the blacklist in json for reference',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `attempts` tinyint UNSIGNED NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`),
  KEY `passport_id` (`passport_id`),
  KEY `passport_no` (`passport_no`),
  KEY `port` (`port`),
  KEY `created_at` (`created_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `countries`
--

DROP TABLE IF EXISTS `countries`;
CREATE TABLE IF NOT EXISTS `countries` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nationality` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `published` tinyint UNSIGNED DEFAULT '0' COMMENT '1 enable',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`),
  KEY `published` (`published`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `countries`
--

INSERT INTO `countries` (`id`, `name`, `nationality`, `code`, `published`, `created_at`, `updated_at`) VALUES
(0x00924338d1f85b7c95af2faea3728e0d, 'Mayotte', 'Mahoran', 'MYT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x01b0ece8f3315512a75ca2633b506585, 'New Zealand', 'New Zealand, NZ', 'NZL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0216aff85cd558b0861f3d66c1248d03, 'Congo (Democratic Republic of the)', 'Congolese', 'COD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x064d25980b74552f87771270881d55c6, 'Grenada', 'Grenadian', 'GRD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x071beeb1b1ed5e7c87e330a0877942b4, 'Bahamas', 'Bahamian', 'BHS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x07598200e09a5685972ea8a44cafdb43, 'Honduras', 'Honduran', 'HND', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x07b8c90fb51e5dc8914835b5eff86a20, 'Saint Lucia', 'Saint Lucian', 'LCA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x08dd4b1a48b55db1a2aca2562422d280, 'Solomon Islands', 'Solomon Island', 'SLB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0967cc3516ce58e0860322e8e8592bcc, 'Svalbard and Jan Mayen', 'Svalbard', 'SJM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0c2c7dff45ae5f1c9456600544a51e29, 'Taiwan, Province of China', 'Chinese, Taiwanese', 'TWN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0c49e57f9f0c56d48fdb7d3ae6246ec9, 'Bhutan', 'Bhutanese', 'BTN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0d1b887c92dd5478901b26772c953873, 'Kyrgyzstan', 'Kyrgyzstani, Kyrgyz, Kirgiz, Kirghiz', 'KGZ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0de3ffd707ab5f7a88f8779f74b8822a, 'Swaziland', 'Swazi', 'SWZ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x0df4ec094af859efb239f7e161489924, 'South Africa', 'South African', 'ZAF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x107cd9a8f0a059ecab86b49a0952a8f1, 'Madagascar', 'Malagasy', 'MDG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1149a6bfca975554b62f2efaca955bef, 'Saint Kitts and Nevis', 'Kittitian or Nevisian', 'KNA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1191d1bc0dde52ed9a2e9a7ef299e46b, 'Comoros', 'Comoran, Comorian', 'COM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x12f1810436a25810a811e616e5314449, 'Aruba', 'Aruban', 'ABW', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x158d6c292bad531eb59d5197be05a1cf, 'Mongolia', 'Mongolian', 'MNG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x15ffd26f4502568cbe694eb4bccb76c5, 'Serbia', 'Serbian', 'SRB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1604bfebdd1452d587d5922dea42209d, 'Falkland Islands (Malvinas)', 'Falkland Island', 'FLK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x163990cd9f5957e1acf223648195c146, 'Bermuda', 'Bermudian, Bermudan', 'BMU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1647f3adc8d951c2b363c31e880320fd, 'Poland', 'Polish', 'POL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x16e45b3fb76f513d8e273667845ba892, 'Suriname', 'Surinamese', 'SUR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x17594aa664d55b6eb6b3ff4e1e3e71bf, 'Norfolk Island', 'Norfolk Island', 'NFK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1835b973244f5072a03f21f9fe41d2c9, 'Morocco', 'Moroccan', 'MAR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x193012d0c4925d05b0d049563473344f, 'Macao', 'Macanese, Chinese', 'MAC', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1b214c5c13b050829dd09a6fc7530099, 'Uzbekistan', 'Uzbekistani, Uzbek', 'UZB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1b413f2778b35590b052baefbc1465d9, 'Nauru', 'Nauruan', 'NRU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1bd8e5e6f37a5444a5b780353595f082, 'Norway', 'Norwegian', 'NOR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1ddb8ad967a15fdfa5c4bf5937d983a1, 'Nicaragua', 'Nicaraguan', 'NIC', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1ed0470d5bb258b985392f9c0a60a345, 'Haiti', 'Haitian', 'HTI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1f138e24659154d792daa65571d0b791, 'Sao Tome and Principe', 'São Toméan', 'STP', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1f83b4c3cd00564b8e405270a7cf5306, 'Sri Lanka', 'Sri Lankan', 'LKA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1fd49624f6dc511d94bc226237ab4a4d, 'Ecuador', 'Ecuadorian', 'ECU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x1fdaa47a21ac5365934a42c53f6d327f, 'Benin', 'Beninese, Beninois', 'BEN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2018fde1193b547daca1cbccfabe029d, 'Cocos (Keeling) Islands', 'Cocos Island', 'CCK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x204d5f33224b5eb8a7c8ff1a4f3732b7, 'Vietnam', 'Vietnamese', 'VNM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x22a299e01845536f8d8a59034e52e600, 'French Southern Territories', 'French Southern Territories', 'ATF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x22de3257778e5f1eb4e984c844967a4f, 'Montserrat', 'Montserratian', 'MSR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2342aa206cb653c8976461bcac17bdcc, 'Argentina', 'Argentine', 'ARG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x24e53689836452528f24c461d661e1c5, 'Guatemala', 'Guatemalan', 'GTM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2646a198b51a5f118dff19bef528655d, 'Monaco', 'Monégasque, Monacan', 'MCO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2715a35351a556738b1d5a3780d5bfa0, 'Mauritania', 'Mauritanian', 'MRT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x271e98a93b7a5bd5bfa9c0047b5f235f, 'Guyana', 'Guyanese', 'GUY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x289dd7fb89ab53ff803d2fd731906127, 'Barbados', 'Barbadian', 'BRB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2adf3b5e40d755899b9f3dd3895e55e4, 'Nepal', 'Nepali, Nepalese', 'NPL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2afb56dc31ce5c099cde6b07ac2bebaf, 'Iran', 'Iranian, Persian', 'IRN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2b9b14bab4bc565ab23d122fcf78e6f4, 'Isle of Man', 'Manx', 'IMN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2bc29c52441e53059e90f167c773a86a, 'Russian Federation', 'Russian', 'RUS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2bfc074ea3aa5852935d77aafcaaa814, 'Guadeloupe', 'Guadeloupe', 'GLP', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2c6e5af15b9d589190d2786607a2882e, 'Belarus', 'Belarusian', 'BLR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2dab7f410c2053ec91624b72acce1a60, 'Uruguay', 'Uruguayan', 'URY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2dd8d3a6eb835c899872b627df9add2b, 'Mozambique', 'Mozambican', 'MOZ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2eda13b28ccd5ab7a3053813c83432e2, 'Oman', 'Omani', 'OMN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x2f5e6b6bdece51b38083ee6f32cabb92, 'Puerto Rico', 'Puerto Rican', 'PRI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x30287437ea5f53d798e263c7ecff13df, 'Tajikistan', 'Tajikistani', 'TJK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x30f2511fe7f259e5b55ae1687813f809, 'Guinea', 'Guinean', 'GIN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x313925496d2357978568a1593e44b43c, 'Romania', 'Romanian', 'ROU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x31c1fa4986355943b57ec7e667e181db, 'Bosnia and Herzegovina', 'Bosnian or Herzegovinian', 'BIH', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x334b6b3112a25bfcbf4f870c0954b343, 'Åland Islands', 'Åland Island', 'ALA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x335ccdcf24715f9e845d59833799ddf9, 'Tunisia', 'Tunisian', 'TUN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x33921e5421da56178c8e27ab8e5716f6, 'Cabo Verde', 'Cabo Verdean', 'CPV', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x33cb1b80173d599caa610399ade7298a, 'Jersey', 'Channel Island', 'JEY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x348ce11bf9ba5931a93bcd5546c2ba63, 'Lithuania', 'Lithuanian', 'LTU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3577af1c295a539f91fff17ef3a95447, 'Bulgaria', 'Bulgarian', 'BGR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3834143135c05ded9aa7118d6dd21bed, 'Qatar', 'Qatari', 'QAT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x38a01d76c5185afc9b9414cb038b4370, 'Bangladesh', 'Bangladeshi', 'BGD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x39d93a083c7f5cfe9b665a60832da226, 'Nigeria', 'Nigerian', 'NGA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3a242dce7e7f5644bcf41c0c7baf3033, 'French Guiana', 'French Guianese', 'GUF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3a8b9d4cb2925153b16070f43a18999e, 'Armenia', 'Armenian', 'ARM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3c7ea849af4c57de993f6062c2e37152, 'Ethiopia', 'Ethiopian', 'ETH', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3d04c8a6cc4753caacab6be3481dca5f, 'China', 'Chinese', 'CHN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3d0de6131eaa57ad80a81d6ea30e9da0, 'Niger', 'Nigerien', 'NER', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3d930c8ba9eb525d8dcdff696fd2e68a, 'Christmas Island', 'Christmas Island', 'CXR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x3fb5eb5f71f955de8c4c4792d4269ff5, 'Chile', 'Chilean', 'CHL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x407ed4d0c6065251b0e32354489a3ef3, 'Germany', 'German', 'DEU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x41bb8d7ae096590ea0e018272be62d34, 'Liberia', 'Liberian', 'LBR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x46db1cda58f058f48dd455131753ad50, 'Spain', 'Spanish', 'ESP', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4805bf628ba151ddbcac8d03077bfac5, 'Niue', 'Niuean', 'NIU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4880bf5f79a65c6db7202bc74613dbaf, 'Peru', 'Peruvian', 'PER', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4905e95eda6551e697af5003dcf070c1, 'Denmark', 'Danish', 'DNK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x49c1477cefb65a29a062fe2c918a4ffa, 'Ghana', 'Ghanaian', 'GHA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4a0c945aafa8518989c62deccebd8adb, 'Moldova (Republic of)', 'Moldovan', 'MDA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4adccb0506d8543389949f62b1f59b93, 'Turkmenistan', 'Turkmen', 'TKM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4ae42be7470e5602abd4b0718be07d12, 'Timor-Leste', 'Timorese', 'TLS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4d6c49455016503c99dfafcc4b2ef455, 'Kenya', 'Kenyan', 'KEN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x4ffb1b168d695ec6bd66ce11767a98e1, 'Cameroon', 'Cameroonian', 'CMR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x51e4ac9a92ed5ca595abf9260e15f813, 'Belgium', 'Belgian', 'BEL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x52193f2bc68452ad8e49057d93435223, 'Zimbabwe', 'Zimbabwean', 'ZWE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x525dd23356985b07811672e75105a3b2, 'Hungary', 'Hungarian, Magyar', 'HUN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x574da85a8e1c561aba16c0b314f1f6c6, 'Togo', 'Togolese', 'TGO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x5a58e2355df75c06ac06d7a36b76485a, 'Eritrea', 'Eritrean', 'ERI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x5bccf91eaec85b2db5e9376e477ba198, 'Curaçao', 'Curaçaoan', 'CUW', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x5bd20866347853f7bc79d2aae304b443, 'Angola', 'Angolan', 'AGO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x5c2b23de4bad58eea4b3f22f3b9cfd7d, 'Cayman Islands', 'Caymanian', 'CYM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x5f7f4a6e577e5b90b1287ab0acc50f5f, 'Somalia', 'Somali, Somalian', 'SOM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x60acce27e5405fd499e97fdccd1c4478, 'Zambia', 'Zambian', 'ZMB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6186515d399859f2b07a4efc424ed936, 'Georgia', 'Georgian', 'GEO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x64227016116758c486d9d03b4ba0148c, 'Saint Martin (French part)', 'Saint-Martinoise', 'MAF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6470e91b5a2f55cca74e286dfa161143, 'Iceland', 'Icelandic', 'ISL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x65aff90aa2205483bc6f5f2698d1ce13, 'Japan', 'Japanese', 'JPN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x66caf453a9485c48a4fee1b3736783f9, 'United States of America', 'American', 'USA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x69ec8f5344e556b2b9c2d5ecbe41e8ae, 'Maldives', 'Maldivian', 'MDV', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6aa2703bd2f75206be18ccdb8c7553a9, 'Cuba', 'Cuban', 'CUB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6c2adc8791d056a3809edab65d517dbd, 'Croatia', 'Croatian', 'HRV', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6c556c3a51b05f34aad17f85c39b2963, 'Yemen', 'Yemeni', 'YEM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6d5f64e6d53b5df680057d9a26547399, 'Austria', 'Austrian', 'AUT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x6f172386e9685c41baff803a3b4fb6d0, 'Czech Republic', 'Czech', 'CZE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x709d58ce53b1592d843289e7f93c97e5, 'Iraq', 'Iraqi', 'IRQ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x70ede393d2265e569f1631b79e2b724b, 'Bahrain', 'Bahraini', 'BHR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x71d3d7474c185f1cbd22d634ad535dd3, 'Equatorial Guinea', 'Equatorial Guinean, Equatoguinean', 'GNQ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x737fbc68f4a85b4587e171cae7303ee0, 'Tuvalu', 'Tuvaluan', 'TUV', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x760d67d4fb665beebe6aeb44ed90baa4, 'Burundi', 'Burundian', 'BDI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7680381239d452d9a62bacb5ea25d73d, 'Kazakhstan', 'Kazakhstani, Kazakh', 'KAZ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x76ec6198b83d5cd69da761096298b7b7, 'Djibouti', 'Djiboutian', 'DJI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x77a518aef6ee5192bb05665bdbfb4a28, 'Gambia', 'Gambian', 'GMB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7911a2fe90e25884a9a5ffbca4979c3f, 'Heard Island and McDonald Islands', 'Heard Island or McDonald Islands', 'HMD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7addeba4de005895bf05ea96b9816c0e, 'Sierra Leone', 'Sierra Leonean', 'SLE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7afb5aa354df586ba82e5d375db7b406, 'Panama', 'Panamanian', 'PAN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7c2b9fda1449536daa63f6ea01836442, 'Montenegro', 'Montenegrin', 'MNE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7c6a3a8ecf585e7189875a59385334f7, 'British Indian Ocean Territory', 'BIOT', 'IOT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7ea1438d1ad55198b957a5fa617d63b4, 'Israel', 'Israeli', 'ISR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7efd446beb1f57f8b12682d7026087ca, 'Sweden', 'Swedish', 'SWE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7f8da4f92af15075be8a06481bbeeafc, 'Côte d\'Ivoire', 'Ivorian', 'CIV', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x7fb92d7386ec5509ba7b7be21db93784, 'Azerbaijan', 'Azerbaijani, Azeri', 'AZE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x80798e70401c5194a03ad707995ba3d6, 'Botswana', 'Motswana, Botswanan', 'BWA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x818fc0cd726b50dea1557668142a4691, 'Mexico', 'Mexican', 'MEX', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x84713bd0d2f450f6a878cf62266c8079, 'Malawi', 'Malawian', 'MWI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x84a025aec5b2581fbe6fd0ee0b9cefe2, 'Switzerland', 'Swiss', 'CHE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x879346eb3f455f6cb1cc24792c634793, 'Thailand', 'Thai', 'THA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8817ace821445954a8d279beb84985e2, 'Mali', 'Malian, Malinese', 'MLI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x88b3db78860e586498979fff803e3de1, 'Paraguay', 'Paraguayan', 'PRY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x88d39dc93c4b5bb4afefb92b34a5f62d, 'Cyprus', 'Cypriot', 'CYP', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x898b12809e955140acb8345b37d4af86, 'Faroe Islands', 'Faroese', 'FRO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x89f80e021c585567b4f642edbe185319, 'Macedonia (the former Yugoslav Republic of)', 'Macedonian', 'MKD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8a5f551cfd8558c0ae0e3b585ca3dd0a, 'Saint Helena, Ascension and Tristan da Cunha', 'Saint Helenian', 'SHN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8a68535eab585de3b63273252b72409c, 'Samoa', 'Samoan', 'WSM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8b2678decdc9523f9b745362b4ce6c92, 'Luxembourg', 'Luxembourg, Luxembourgish', 'LUX', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8e164708f3df5aec9bbe521b3c8b03db, 'Trinidad and Tobago', 'Trinidadian or Tobagonian', 'TTO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8f4885abe13a558bb550aa81a1f9bbb1, 'Vatican City State', 'Vatican', 'VAT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x8fa396965edf5ad6a75058b1ad71b333, 'Tanzania, United Republic of', 'Tanzanian', 'TZA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x92b530dedfba5a35a2e08e626aa88e75, 'Latvia', 'Latvian', 'LVA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x935eef494f745aea918e381d8a03c3f1, 'United States Minor Outlying Islands', 'American', 'UMI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x942569edba8e5454a6800c89983a22ea, 'Jamaica', 'Jamaican', 'JAM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x962d2f1ef40052af9eecf3ba3495b3e9, 'Saint Vincent and the Grenadines', 'Saint Vincentian, Vincentian', 'VCT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x965e199ebeaa5493ae102223b3dc1e2e, 'Ireland', 'Irish', 'IRL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x972f49343e84522990be83a905fd8d99, 'Venezuela (Bolivarian Republic of)', 'Venezuelan', 'VEN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x975b095c19f8505f8f369774c099e719, 'Martinique', 'Martiniquais, Martinican', 'MTQ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x9a600b23bba05d09b15bc508131f10a2, 'El Salvador', 'Salvadoran', 'SLV', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x9d660b4d1c7b52238f2f240444e0bd45, 'Malaysia', 'Malaysian', 'MYS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x9daf72ab21fd5c8c82be82aa3e2ee9a9, 'Kiribati', 'I-Kiribati', 'KIR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x9ea37f2f3d2d5bbe95d317be5e26a517, 'Sint Maarten (Dutch part)', 'Sint Maarten', 'SXM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0x9f6cbe61d58754d79ea4c9708eb922ef, 'Tokelau', 'Tokelauan', 'TKL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa1dd06e98496580e835e976fb50a75c2, 'Malta', 'Maltese', 'MLT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa4c170c58f405acb9fd8876a4f0680d7, 'United Arab Emirates', 'Emirati, Emirian, Emiri', 'ARE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa545a5ac9ea05b65adb004afa85f25e0, 'France', 'French', 'FRA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa6845065840757da9cf5e5cd1b0e69c4, 'Costa Rica', 'Costa Rican', 'CRI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa7d7e5e198c8502dbbfd4c7ab64e1bc4, 'Micronesia (Federated States of)', 'Micronesian', 'FSM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa9736eb64f095a9d817fa8c0b8a9b15e, 'Tonga', 'Tongan', 'TON', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xa99c3c4986915ec98ff8b655539d2a8d, 'Kuwait', 'Kuwaiti', 'KWT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xab827ed286c25c7f8eee0326d169f0da, 'Bonaire, Sint Eustatius and Saba', 'Bonaire', 'BES', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xac1643223fbc5f58b51edf5f772e2a6b, 'Singapore', 'Singaporean', 'SGP', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xaca5264026075fada9fffb5312de53af, 'Northern Mariana Islands', 'Northern Marianan', 'MNP', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xad8b8d0fa385580da06bbbc1470a5539, 'Réunion', 'Réunionese, Réunionnais', 'REU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xae3be504177552b7b9c6f93b28cb8243, 'Western Sahara', 'Sahrawi, Sahrawian, Sahraouian', 'ESH', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xaeb0f2fe1fa4542b8d083f4eee8fc795, 'Wallis and Futuna', 'Wallis and Futuna, Wallisian or Futunan', 'WLF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xafca48e959ea5a28b8a488e0cc6eda1c, 'American Samoa', 'American Samoan', 'ASM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xafff1d849f4e59e394bbb38647a96eae, 'Sudan', 'Sudanese', 'SDN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb03380f18aa35211b33142735f44b013, 'Lao People\'s Democratic Republic', 'Lao, Laotian', 'LAO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb0d51db1d57055379e1e65c692c2f32c, 'Gabon', 'Gabonese', 'GAB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb217f755d7965a4c878ba0d48df7a8ba, 'Netherlands', 'Dutch, Netherlandic', 'NLD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb30256b4082a5d1a9cef8e13e9b9c050, 'New Caledonia', 'New Caledonian', 'NCL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb420fd97db8e5fe3a020238c8e5ba39c, 'Guam', 'Guamanian, Guambat', 'GUM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb44fc0e37d565f5cac41956867061d0d, 'Palau', 'Palauan', 'PLW', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb515d77a162958569697c82f3c839a7d, 'Belize', 'Belizean', 'BLZ', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb756dcb03600525dbacb285c0f1a07e2, 'Antarctica', 'Antarctic', 'ATA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb80c8fefa677534085fb2c162d75df03, 'Afghanistan', 'Afghan', 'AFG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb818df3ed4f7504695b747f4882a35a7, 'Gibraltar', 'Gibraltar', 'GIB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb89ca43b3386579ba498a4ec1c22f31b, 'Uganda', 'Ugandan', 'UGA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb8c8050b398953e7a8b2e70e9a7fd126, 'Greece', 'Greek, Hellenic', 'GRC', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xb9b6607d6974594f8e99ac3de71c4d89, 'Lebanon', 'Lebanese', 'LBN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbbe2901073fa5eb9b57b2e45b15d8c8b, 'Myanmar', 'Burmese', 'MMR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbf2f7049cd295282a61306cca4ef34d0, 'Burkina Faso', 'Burkinabé', 'BFA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbf6365f34ec6598f933f4b32d2362453, 'Saudi Arabia', 'Saudi, Saudi Arabian', 'SAU', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbf7dacf29953598e94b5425d6e1f4a91, 'Slovenia', 'Slovenian, Slovene', 'SVN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbf8d3ce767785d87a7f967e16dabc7c3, 'Central African Republic', 'Central African', 'CAF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbfdfa5238a6256a28a6aa0afdd7f04f6, 'Jordan', 'Jordanian', 'JOR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xbffa352246295e7cac080433874a4508, 'Lesotho', 'Basotho', 'LSO', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc02033195ef05c04bdbfbe9de6d3bc2f, 'Egypt', 'Egyptian', 'EGY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc06243dceaed5ddfbc34c28ae6c89ede, 'Anguilla', 'Anguillan', 'AIA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc093c7f66edf595e953970de788efbaa, 'Albania', 'Albanian', 'ALB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc0a650ffd9ec59fba183eb0635fe3346, 'Liechtenstein', 'Liechtenstein', 'LIE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc26dd0f050885a0c8d7c2cd7b0aba927, 'Mauritius', 'Mauritian', 'MUS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc2d1d12093c85c7e9e77365a04a057d7, 'Slovakia', 'Slovak', 'SVK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc3eb1b7d7032541ebbdf315d26c85ef1, 'Canada', 'Canadian', 'CAN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc46afaae6aad588f8a5ef15f6ebfd45b, 'Palestine, State of', 'Palestinian', 'PSE', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc64e6ce645495b73ab536746ec8714af, 'Brunei Darussalam', 'Bruneian', 'BRN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc6577abe8c0f5a02ac84aa94c2247b1e, 'Andorra', 'Andorran', 'AND', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc765fb021ee15ffe8576759aba4607d1, 'Italy', 'Italian', 'ITA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xc9e8e7114c5757f09376095d44e81a07, 'Dominican Republic', 'Dominican', 'DOM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xca01b83d37a35903b8b5e619bfb5bc55, 'Rwanda', 'Rwandan', 'RWA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xcca0cc0a8d455ac9b77552b84a45cd1d, 'Fiji', 'Fijian', 'FJI', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xcd92195af84851d8b7628980f6d8eb02, 'Saint Barthélemy', 'Barthélemois', 'BLM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xce1b28ad1a2e5c7d97fa17fb9a837014, 'India', 'Indian', 'IND', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xcf25115f7af459d08254a195b22b8bfb, 'Syrian Arab Republic', 'Syrian', 'SYR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xcf3452c6b7905d4092a986ddde6d8e7f, 'Pitcairn', 'Pitcairn Island', 'PCN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xcfff2af7ed855f59824688bfc5a0d398, 'Chad', 'Chadian', 'TCD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd3dcf303271e5d47bded7720b1d812f3, 'South Sudan', 'South Sudanese', 'SSD', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd7b65d1b5fbc53c3b8c8a538cb3d070a, 'Namibia', 'Namibian', 'NAM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd819af648b6a53a98fb66aa154e6f572, 'Korea (Republic of)', 'South Korean', 'KOR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd821db2bad1a5483a9f53b0b6009f299, 'Pakistan', 'Pakistani', 'PAK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd836402a30e65178a8c504a68ffd6fa5, 'United Kingdom of Great Britain and Northern Ireland', 'British, UK', 'GBR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd850a1ddf50d54ff9303ada59f1b4905, 'Marshall Islands', 'Marshallese', 'MHL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xd86f9a2ba2bc5f35b882e612474e6e5f, 'Greenland', 'Greenlandic', 'GRL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdbb5320ce6b15f5c88196c25c2531101, 'Hong Kong', 'Hong Kong, Hong Kongese', 'HKG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdbca436310c1527da9ee818c1f682b7c, 'French Polynesia', 'French Polynesian', 'PYF', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdc6ddbd18732575f86948e48527b5998, 'Finland', 'Finnish', 'FIN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdcf7bebe2ae853d78569e39a2aae958d, 'Bouvet Island', 'Bouvet Island', 'BVT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdd4a8658957f5d2383803536917cc1f9, 'Senegal', 'Senegalese', 'SEN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdea2dfca195759348fcf5d473cee64eb, 'Cambodia', 'Cambodian', 'KHM', 0, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xdedbed4912365497ae1f458cdf482530, 'Portugal', 'Portuguese', 'PRT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe09259f4442b58f2a040459ee1fd7b2b, 'Libya', 'Libyan', 'LBY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe0f11cf5d2a059abac195bcba6e67161, 'Ukraine', 'Ukrainian', 'UKR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe1e5b788f4295a329f7e63865921a5e5, 'Antigua and Barbuda', 'Antiguan or Barbudan', 'ATG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe207861b69dd594fa230d0044ff3b0a0, 'Philippines', 'Philippine, Filipino', 'PHL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe21fe6d4626c53b3a4a23d983b837714, 'Brazil', 'Brazilian', 'BRA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe2ca90333f0f5b89bd7d96cf9e2530b0, 'Colombia', 'Colombian', 'COL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe3dc096c921d57078d70402ab0b702cf, 'Vanuatu', 'Ni-Vanuatu, Vanuatuan', 'VUT', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xe588b7d92449595f964562386fe1e433, 'Virgin Islands (British)', 'British Virgin Island', 'VGB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xeb3960c9dedf51e398ccc4746e8940c3, 'South Georgia and the South Sandwich Islands', 'South Georgia or South Sandwich Islands', 'SGS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xeba453cadb1c51d8b9d40c09adf52b9c, 'Cook Islands', 'Cook Island', 'COK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xec749a3b740b5b8b9bd2654e35c5fca1, 'Saint Pierre and Miquelon', 'Saint-Pierrais or Miquelonnais', 'SPM', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xeda7157e22455c53ae25f201b2bc2043, 'Turks and Caicos Islands', 'Turks and Caicos Island', 'TCA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf0c79aa1320250aa8c5a4f67d64891d8, 'Korea (Democratic People\'s Republic of)', 'North Korean', 'PRK', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf1215345ed6b5be1a4a40db084c6cf55, 'Papua New Guinea', 'Papua New Guinean, Papuan', 'PNG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf3255cbf6b7159e4b0916d1cd3a0ab93, 'Seychelles', 'Seychellois', 'SYC', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf4dee25dc6a058d48e66b58431dfceef, 'Indonesia', 'Indonesian', 'IDN', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf501766616c75d04b9bdf7fe5e2b8708, 'San Marino', 'Sammarinese', 'SMR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf6d5d99ecfd85ce2825d900ed8d255b6, 'Dominica', 'Dominican', 'DMA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf7176b112dfd5188b1f76591925d43d7, 'Turkey', 'Turkish', 'TUR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf834e664473a5d238dfa785e823614e1, 'Estonia', 'Estonian', 'EST', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xf9d78e51cc6158cc910f5aac419f1d70, 'Guinea-Bissau', 'Bissau-Guinean', 'GNB', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xfb5ee05b8ff05a2d8e7aa74358a96b3b, 'Bolivia (Plurinational State of)', 'Bolivian', 'BOL', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xfb8962faab9d582a9c85fa761496670d, 'Guernsey', 'Channel Island', 'GGY', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xfc13841d8ea75f38a8195ae8e6605a41, 'Congo (Republic of the)', 'Congolese', 'COG', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xfc340caed62953cabfc2f46c1a22d325, 'Australia', 'Australian', 'AUS', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xfd4e8ad5eb7d5a2e8944f31fff3b03ed, 'Virgin Islands (U.S.)', 'U.S. Virgin Island', 'VIR', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05'),
(0xff6c5a08b2fa56b6ac006830f4074b6a, 'Algeria', 'Algerian', 'DZA', 1, '2023-06-21 12:00:05', '2023-06-21 12:00:05');

--
-- Triggers `countries`
--
DROP TRIGGER IF EXISTS `countries_insert`;
DELIMITER $$
CREATE TRIGGER `countries_insert` AFTER INSERT ON `countries` FOR EACH ROW BEGIN
INSERT INTO countries_sync(id, created_at) VALUES(new.id, now());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `countries_update`;
DELIMITER $$
CREATE TRIGGER `countries_update` AFTER UPDATE ON `countries` FOR EACH ROW BEGIN
DELETE FROM countries_sync where id=new.id;
INSERT INTO countries_sync(id, created_at) VALUES(new.id, now());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `countries_sync`
--

DROP TABLE IF EXISTS `countries_sync`;
CREATE TABLE IF NOT EXISTS `countries_sync` (
  `sid` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` binary(16) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `created_at` (`created_at`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `countries_sync`
--

INSERT INTO `countries_sync` (`sid`, `id`, `created_at`) VALUES
(3, 0xdea2dfca195759348fcf5d473cee64eb, '2023-10-30 13:47:51');

-- --------------------------------------------------------

--
-- Table structure for table `deleted_visas`
--

DROP TABLE IF EXISTS `deleted_visas`;
CREATE TABLE IF NOT EXISTS `deleted_visas` (
  `id` varbinary(16) NOT NULL,
  `vid` binary(16) NOT NULL,
  `uid` binary(16) NOT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `deleted_at` datetime NOT NULL,
  `attachments` json DEFAULT NULL COMMENT '{''passport'':'''',''visa'':''''}',
  `passport_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sex` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nationality` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visa_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vid` (`vid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `devices`
--

DROP TABLE IF EXISTS `devices`;
CREATE TABLE IF NOT EXISTS `devices` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `uid` binary(16) DEFAULT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'device name',
  `os` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'window,ios,android',
  `os_version` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `platform` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'website,app',
  `app_version` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `ip` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `last_active_at` datetime DEFAULT NULL,
  `updated_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `status` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '0=pending, 1=allowed, 2=banned',
  `reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `device_id` (`device_id`),
  KEY `uid` (`uid`),
  KEY `port` (`port`),
  KEY `last_active_at` (`last_active_at`),
  KEY `platform` (`platform`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `devices`
--

INSERT INTO `devices` (`id`, `uid`, `port`, `device_id`, `name`, `os`, `os_version`, `platform`, `app_version`, `user_agent`, `ip`, `last_active_at`, `updated_at`, `created_at`, `status`, `reason`) VALUES
(0xb1bd375a6f1759898afdaadf50cbd345, 0x02f5d68f76607b5bcda97825958fb56b, 'PHN', 'F9615C43-E117-49F9-BA54-5F3FEA806265', 'PC 1', 'Windows 11 Pro', '22H2', 'app', '1.0.0', 'PostmanRuntime/7.34.0', '192.168.88.209', '2023-10-28 12:02:05', '2023-10-27 11:58:44', '2023-10-26 08:39:14', 1, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `passports`
--

DROP TABLE IF EXISTS `passports`;
CREATE TABLE IF NOT EXISTS `passports` (
  `pid` binary(16) NOT NULL COMMENT 'uuid5(nationality-passportNo)',
  `passport_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'nationality-passport_no, ex: KHM-N00001',
  `passport_no` varchar(15) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `issued_date` date DEFAULT NULL,
  `expire_date` date NOT NULL,
  `full_name` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `surname` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `given_name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sex` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `dob` date NOT NULL,
  `nationality` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'country code',
  `pob` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'Place of Birth',
  `profession` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `phone` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `address_in_cambodia` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `attachments` json DEFAULT NULL COMMENT '{''photo'':'''',''passport'':''''}',
  `vid` binary(16) DEFAULT NULL COMMENT 'last visas vid',
  `uid` binary(16) NOT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'port code',
  `entry_at` datetime NOT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`pid`),
  KEY `passport_no` (`passport_no`),
  KEY `expire_date` (`expire_date`),
  KEY `nationality` (`nationality`),
  KEY `sex` (`sex`),
  KEY `vid` (`vid`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`),
  KEY `port` (`port`),
  KEY `passport_id` (`passport_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ports`
--

DROP TABLE IF EXISTS `ports`;
CREATE TABLE IF NOT EXISTS `ports` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `name_en` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `name_km` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `code` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `report_time_zone` tinyint NOT NULL DEFAULT '0' COMMENT 'some port need to +4 hours to match their worktime',
  `published` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '1 enable',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `check_als` tinyint UNSIGNED NOT NULL DEFAULT '1' COMMENT '1=check passport with ALS, 0=not check with ALS',
  PRIMARY KEY (`id`),
  UNIQUE KEY `code` (`code`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ports`
--

INSERT INTO `ports` (`id`, `name_en`, `name_km`, `code`, `report_time_zone`, `published`, `created_at`, `updated_at`, `check_als`) VALUES
(0x334b6b3112a25bfcbf4f870c0954b343, 'សៀមរាប', 'Siem Reap', 'SRP', 0, 1, '2023-06-21 05:05:08', '2023-06-21 05:05:08', 1),
(0x76ee205f353e58d69cf8dcb5b28e451b, 'បាវិត', 'Bavet', 'BV', 4, 0, '2023-10-30 14:05:18', '2023-10-30 14:06:12', 0),
(0xb80c8fefa677534085fb2c162d75df03, 'ភ្នំពេញ', 'Phnom Penh', 'PHN', 4, 1, '2023-06-21 05:05:08', '2023-10-28 12:02:05', 0),
(0xc093c7f66edf595e953970de788efbaa, 'ព្រះសីហនុ', 'Preah Sihanouk', 'PSN', 0, 1, '2023-06-21 05:05:08', '2023-06-21 05:05:08', 1);

--
-- Triggers `ports`
--
DROP TRIGGER IF EXISTS `ports_insert`;
DELIMITER $$
CREATE TRIGGER `ports_insert` AFTER INSERT ON `ports` FOR EACH ROW BEGIN
INSERT INTO ports_sync(id, created_at) VALUES(new.id, now());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `ports_update`;
DELIMITER $$
CREATE TRIGGER `ports_update` AFTER UPDATE ON `ports` FOR EACH ROW BEGIN
DELETE FROM ports_sync where id=new.id;
INSERT INTO ports_sync(id, created_at) VALUES(new.id, now());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `ports_sync`
--

DROP TABLE IF EXISTS `ports_sync`;
CREATE TABLE IF NOT EXISTS `ports_sync` (
  `sid` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` binary(16) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `created_at` (`created_at`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=15 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ports_sync`
--

INSERT INTO `ports_sync` (`sid`, `id`, `created_at`) VALUES
(14, 0x76ee205f353e58d69cf8dcb5b28e451b, '2023-10-30 14:06:12');

-- --------------------------------------------------------

--
-- Table structure for table `printed_visas`
--

DROP TABLE IF EXISTS `printed_visas`;
CREATE TABLE IF NOT EXISTS `printed_visas` (
  `id` binary(16) NOT NULL,
  `vid` binary(16) NOT NULL,
  `uid` binary(16) NOT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `printed_at` datetime NOT NULL,
  `passport_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sex` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nationality` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `visa_type` varchar(2) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  PRIMARY KEY (`id`),
  KEY `vid` (`vid`),
  KEY `printed_at` (`printed_at`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `tokens`
--

DROP TABLE IF EXISTS `tokens`;
CREATE TABLE IF NOT EXISTS `tokens` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uid` binary(16) DEFAULT NULL,
  `token` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `issued_at` datetime NOT NULL,
  `expire_at` datetime NOT NULL,
  `last_used_at` datetime DEFAULT NULL,
  `ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `device_id` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `uid` (`uid`),
  KEY `expire_at` (`expire_at`),
  KEY `token` (`token`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tokens`
--

INSERT INTO `tokens` (`id`, `port`, `uid`, `token`, `issued_at`, `expire_at`, `last_used_at`, `ip`, `device_id`, `user_agent`, `created_at`, `updated_at`) VALUES
(0x01e77aedf17a575994890fb947a81c1d, 'PHN', 0x02f5d68f76607b5bcda97825958fb56b, 'MDJmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZilmdixVAIbm1r9QU9HEz0VPB22CxvREAnkrIF3F9UcssjNx8VYLzeEeeu1LhJ', '2023-10-26 08:46:05', '2024-10-26 08:46:05', NULL, '192.168.88.209', NULL, 'PostmanRuntime/7.34.0', '2023-10-26 08:46:05', '2023-10-26 08:46:05'),
(0x02db43b2faa257fab2e192bbf2a06b26, 'PHN', 0x02f5d68f76607b5bcda97825958fb56b, 'MDJmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZiKGPnvUnzxyqCDyBmmloyHJ27XZ5iGyMy4Fpmcef6bk0UW8XHW1sozS4hyg6x', '2023-10-26 09:02:39', '2024-10-26 09:02:39', NULL, '192.168.88.209', 'F9615C43-E117-49F9-BA54-5F3FEA806265', 'PostmanRuntime/7.34.0', '2023-10-26 09:02:39', '2023-10-26 09:02:39'),
(0x2826b41f686f5169acd01ff6d30b7a94, 'PHN', 0x01f5d68f76607b5bcda97825958fb56b, 'MDFmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZibENbanGU7XLmjN8siLcqtQJ5howDpnt6wdIauQEAysOhFQTYqP1pLdYbcKr0', '2023-10-26 09:10:52', '2024-10-26 09:10:52', NULL, '192.168.88.209', 'F9615C43-E117-49F9-BA54-5F3FEA806265', 'PostmanRuntime/7.34.0', '2023-10-26 09:10:52', '2023-10-26 09:10:52'),
(0x32e8293b27815b7ba90bc7d7eab19417, 'PHN', 0x02f5d68f76607b5bcda97825958fb56b, 'MDJmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZiu7gU7pvbiiyrklejYWomewyZNUxvhazZUBNajdngT6LFIHLL9JrawHXauDfJ', '2023-10-26 09:01:04', '2024-10-26 09:01:04', NULL, '192.168.88.209', NULL, 'PostmanRuntime/7.34.0', '2023-10-26 09:01:04', '2023-10-26 09:01:04'),
(0x500c68eaa704555eb52852e63dda0335, 'PHN', 0x02f5d68f76607b5bcda97825958fb56b, 'MDJmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZilyBefSe1qMTyS25MgkeaZkSepfai0wC6H5vCMEQZL2H92MgdQcTh7GTrPAeo', '2023-10-26 09:03:52', '2024-10-26 09:03:52', '2023-10-28 12:02:05', '192.168.88.209', 'F9615C43-E117-49F9-BA54-5F3FEA806265', 'PostmanRuntime/7.34.0', '2023-10-26 09:03:52', '2023-10-26 09:03:52'),
(0x6c604ed3b4a95b5b89a3f6ee82b2520b, 'PHN', 0x02f5d68f76607b5bcda97825958fb56b, 'MDJmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZil2oqAuQlS5W76mWXgoC0nsxTRhSfBzQKp05gghQimWeNsnM4zV6hrPuXtW16', '2023-10-27 11:58:44', '2024-10-27 11:58:44', NULL, '192.168.88.209', 'F9615C43-E117-49F9-BA54-5F3FEA806265', 'PostmanRuntime/7.34.0', '2023-10-27 11:58:44', '2023-10-27 11:58:44'),
(0xde5f0747a6635f1d95700808549ccb05, 'PHN', 0x02f5d68f76607b5bcda97825958fb56b, 'MDJmNWQ2OGYtNzY2MC03YjViLWNkYTktNzgyNTk1OGZiNTZiRORXfVAbXawOsZ07oEfI3oLZlhG5iMEPvzq6dyWEMxrn3O9W16pIV7VblywM', '2023-10-26 08:40:13', '2024-10-26 08:40:13', NULL, '192.168.88.209', NULL, 'PostmanRuntime/7.34.0', '2023-10-26 08:40:13', '2023-10-26 08:40:13');

-- --------------------------------------------------------

--
-- Table structure for table `users`
--

DROP TABLE IF EXISTS `users`;
CREATE TABLE IF NOT EXISTS `users` (
  `uid` binary(16) NOT NULL COMMENT 'uuid',
  `name` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `username` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `sex` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'm',
  `phone` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `email` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `role` enum('super_admin','admin','sub_admin','staff','report') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'staff',
  `permissions` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'port code, set it null for access all ports',
  `photo` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `banned` tinyint UNSIGNED NOT NULL DEFAULT '0' COMMENT '1=banned',
  `banned_reason` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `password` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `logined_at` datetime DEFAULT NULL,
  `logout_at` datetime DEFAULT NULL,
  `last_ip` varchar(60) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `last_user_agent` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`uid`),
  UNIQUE KEY `username` (`username`),
  KEY `port` (`port`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users`
--

INSERT INTO `users` (`uid`, `name`, `username`, `sex`, `phone`, `email`, `role`, `permissions`, `port`, `photo`, `banned`, `banned_reason`, `password`, `logined_at`, `logout_at`, `last_ip`, `last_user_agent`, `created_at`, `updated_at`) VALUES
(0x01f5d68f76607b5bcda97825958fb56b, 'Sub Admin ', 'subadmin', 'm', NULL, NULL, 'sub_admin', NULL, NULL, NULL, 0, NULL, '$2b$10$Gsyf/3TKTt4YigeeZp79Z.YEUKJbJZdpDW.v4zj7iRBuUk9dOufua', '2023-10-26 09:10:52', '2023-10-05 15:37:24', '192.168.88.209', 'PostmanRuntime/7.34.0', '2023-08-04 02:29:11', '2023-10-26 09:10:52'),
(0x02f5d68f76607b5bcda97825958fb56b, 'Admin', 'admin', 'm', NULL, NULL, 'admin', NULL, NULL, NULL, 0, NULL, '$2b$10$fUfJ6K4djPE7GPazUuFw4O6rQviMWDKvno3F5jgy2XiDRvEa25awa', '2023-10-27 11:58:44', '2023-10-06 10:29:48', '192.168.88.209', 'PostmanRuntime/7.34.0', '2023-08-04 02:29:11', '2023-10-27 11:58:44'),
(0x1449ca98032a4ec085a8d4d68cf5a8f7, 'Dara 1', 'dara', 'm', NULL, NULL, 'staff', NULL, NULL, NULL, 1, NULL, '', NULL, NULL, NULL, NULL, '2023-10-26 05:00:35', '2023-10-27 12:03:24'),
(0xe7ae558c87925dfc88ee8bdd6434d61e, 'Hong Ly 11111', 'ut1', 'm', NULL, NULL, 'staff', 'view_visa,add_visa,print_visa,scan_visa,delete_visa,report,blacklist', 'PHN', NULL, 0, NULL, '$2b$10$U6urKQxo7trG8w75nJlCdO4E.TXOoC5s5gqmiYyLlTAnLCoQXCYqy', NULL, NULL, '192.168.88.209', 'PostmanRuntime/7.34.0', '2023-10-27 13:47:40', '2023-10-28 10:35:19'),
(0xf5d68f76607b5bcda97825958fb56bf1, 'Admin', 'superadmin', 'm', NULL, NULL, 'super_admin', NULL, NULL, NULL, 0, NULL, '$2b$10$X3E7l1e/NPIish68YYALk.FEuGelYh2tq1bSh72We6GDxwuXQyMnK', '2023-10-04 16:55:50', '2023-10-04 16:57:06', '192.168.88.209', 'PostmanRuntime/7.33.0', '2023-08-04 02:29:11', '2023-10-04 16:57:06');

--
-- Triggers `users`
--
DROP TRIGGER IF EXISTS `users_insert`;
DELIMITER $$
CREATE TRIGGER `users_insert` AFTER INSERT ON `users` FOR EACH ROW BEGIN
INSERT INTO users_sync(id, port, created_at) VALUES(new.uid, new.port, now());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `users_update`;
DELIMITER $$
CREATE TRIGGER `users_update` AFTER UPDATE ON `users` FOR EACH ROW BEGIN
DELETE FROM users_sync WHERE id=new.uid;
INSERT INTO users_sync(id, port, created_at) VALUES(new.uid, new.port, now());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `users_sync`
--

DROP TABLE IF EXISTS `users_sync`;
CREATE TABLE IF NOT EXISTS `users_sync` (
  `sid` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` binary(16) NOT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `created_at` (`created_at`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `users_sync`
--

INSERT INTO `users_sync` (`sid`, `id`, `port`, `created_at`) VALUES
(12, 0x02f5d68f76607b5bcda97825958fb56b, NULL, '2023-10-27 11:58:44'),
(13, 0x1449ca98032a4ec085a8d4d68cf5a8f7, NULL, '2023-10-27 12:03:24'),
(22, 0xe7ae558c87925dfc88ee8bdd6434d61e, 'PHN', '2023-10-28 10:35:19');

-- --------------------------------------------------------

--
-- Table structure for table `visas`
--

DROP TABLE IF EXISTS `visas`;
CREATE TABLE IF NOT EXISTS `visas` (
  `vid` binary(16) NOT NULL COMMENT 'uuid(checklist id)',
  `visa_id` varchar(20) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'visa_type-visa_no, ex: E-000001',
  `visa_no` bigint UNSIGNED NOT NULL DEFAULT '0',
  `visa_type` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `issued_date` date NOT NULL,
  `expire_date` date NOT NULL,
  `remarks` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `passport_id` varchar(25) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'nationality-passport_no, ex: KHM-N00001',
  `passport_expire_date` date NOT NULL,
  `sex` enum('m','f') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `nationality` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'country code',
  `travel_no` varchar(30) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `travel_from` char(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'country code',
  `final_city` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `travel_purpose` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `attachments` json DEFAULT NULL COMMENT '{''visa'':'''',''passport'':''''}',
  `visa_no_on_photo` bigint UNSIGNED NOT NULL DEFAULT '0',
  `uid` binary(16) NOT NULL,
  `port` varchar(8) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL COMMENT 'port code',
  `officer_notes` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL,
  `printed_at` datetime DEFAULT NULL,
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  `printed` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `deleted` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `deleted_at` datetime DEFAULT NULL,
  `scanned` tinyint UNSIGNED NOT NULL DEFAULT '0',
  `base_id` varchar(40) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci DEFAULT NULL COMMENT 'null=not check with ALS',
  PRIMARY KEY (`vid`),
  KEY `visa_id` (`visa_id`),
  KEY `visa_no` (`visa_no`),
  KEY `visa_type` (`visa_type`),
  KEY `expire_date` (`expire_date`),
  KEY `passport_id` (`passport_id`),
  KEY `nationality` (`nationality`),
  KEY `sex` (`sex`),
  KEY `created_at` (`created_at`),
  KEY `updated_at` (`updated_at`),
  KEY `port` (`port`),
  KEY `issued_date` (`issued_date`),
  KEY `base_id` (`base_id`),
  KEY `printed_at` (`printed_at`) USING BTREE,
  KEY `deleted` (`deleted`) USING BTREE,
  KEY `printed` (`printed`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `visa_types`
--

DROP TABLE IF EXISTS `visa_types`;
CREATE TABLE IF NOT EXISTS `visa_types` (
  `id` binary(16) NOT NULL COMMENT 'uuid',
  `label` varchar(120) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `type` varchar(3) CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL,
  `duration` int UNSIGNED NOT NULL DEFAULT '0',
  `duration_type` enum('day','month','year','passport_expire_date') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'day',
  `entries` enum('single','multiple') CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT 'single',
  `price` double(15,2) DEFAULT '0.00',
  `ordering` tinyint UNSIGNED DEFAULT '99',
  `popular` tinyint UNSIGNED DEFAULT '0',
  `published` tinyint UNSIGNED DEFAULT '0' COMMENT '1 enable',
  `sort_reports` tinyint UNSIGNED NOT NULL DEFAULT '99',
  `created_at` datetime NOT NULL,
  `updated_at` datetime NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `type` (`type`),
  KEY `published` (`published`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visa_types`
--

INSERT INTO `visa_types` (`id`, `label`, `type`, `duration`, `duration_type`, `entries`, `price`, `ordering`, `popular`, `published`, `sort_reports`, `created_at`, `updated_at`) VALUES
(0x12f1810436a25810a811e616e5314449, 'ទិដ្ធាការទេសចរណ៍រយះពេលវែង', 'T3', 3, 'year', 'multiple', 100.00, 12, 0, 1, 4, '2023-06-21 14:21:08', '2023-10-30 11:07:37'),
(0x2342aa206cb653c8976461bcac17bdcc, 'ទិដ្ធាការទេសចរណ៍រយះពេលវែង', 'T1', 1, 'year', 'multiple', 40.00, 10, 0, 1, 2, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0x334b6b3112a25bfcbf4f870c0954b343, 'ទិដ្ធាការផ្លូលការ', 'B', 3, 'month', 'single', 0.00, 4, 0, 1, 12, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0x3a8b9d4cb2925153b16070f43a18999e, 'ទិដ្ធាការទេសចរណ៍រយះពេលវែង', 'T2', 2, 'year', 'multiple', 60.00, 11, 0, 1, 3, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0x5bd20866347853f7bc79d2aae304b443, 'ទិដ្ធាការធម្មតារយះពេលវែង', 'E2', 2, 'year', 'multiple', 75.00, 8, 0, 1, 7, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xafca48e959ea5a28b8a488e0cc6eda1c, 'ទិដ្ធាការធម្មតា', 'E', 1, 'month', 'single', 35.00, 1, 1, 1, 5, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xb756dcb03600525dbacb285c0f1a07e2, 'ទិដ្ធាការពិសេស', 'K', 0, 'passport_expire_date', 'multiple', 0.00, 13, 0, 1, 10, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xb80c8fefa677534085fb2c162d75df03, 'ទិដ្ធាការការទូត', 'A', 3, 'month', 'multiple', 0.00, 3, 0, 1, 11, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xc06243dceaed5ddfbc34c28ae6c89ede, 'ទិដ្ធាការធម្មតារយះពេលវែង', 'E3', 3, 'year', 'multiple', 100.00, 9, 0, 1, 8, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xc093c7f66edf595e953970de788efbaa, 'ទិដ្ធាការបោរីភាព', 'C', 3, 'month', 'single', 0.00, 5, 0, 1, 13, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xc6577abe8c0f5a02ac84aa94c2247b1e, 'ទិដ្ធាការធម្មតារយះពេលវែង', 'E1', 1, 'year', 'multiple', 50.00, 7, 0, 1, 6, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xe1e5b788f4295a329f7e63865921a5e5, 'ទិដ្ធាការទេសចរណ៍', 'T', 1, 'month', 'single', 30.00, 2, 1, 1, 1, '2023-06-21 14:21:08', '2023-06-21 14:21:08'),
(0xff6c5a08b2fa56b6ac006830f4074b6a, 'ទិដ្ធាការឆ្លង់កាត់', 'D', 5, 'day', 'single', 15.00, 6, 0, 1, 9, '2023-06-21 14:21:08', '2023-06-21 14:21:08');

--
-- Triggers `visa_types`
--
DROP TRIGGER IF EXISTS `visa_types_insert`;
DELIMITER $$
CREATE TRIGGER `visa_types_insert` AFTER INSERT ON `visa_types` FOR EACH ROW BEGIN
INSERT INTO visa_types_sync(id, created_at) VALUES(new.id, now());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `visa_types_update`;
DELIMITER $$
CREATE TRIGGER `visa_types_update` AFTER UPDATE ON `visa_types` FOR EACH ROW BEGIN
DELETE FROM visa_types_sync where id=new.id;
INSERT INTO visa_types_sync(id, created_at) VALUES(new.id, now());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `visa_types_sync`
--

DROP TABLE IF EXISTS `visa_types_sync`;
CREATE TABLE IF NOT EXISTS `visa_types_sync` (
  `sid` bigint UNSIGNED NOT NULL AUTO_INCREMENT,
  `id` binary(16) NOT NULL,
  `created_at` datetime NOT NULL,
  PRIMARY KEY (`sid`),
  KEY `created_at` (`created_at`),
  KEY `id` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `visa_types_sync`
--

INSERT INTO `visa_types_sync` (`sid`, `id`, `created_at`) VALUES
(12, 0x923ba7b859e657b9b3155c85c3d6f60c, '2023-10-30 14:10:02');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `passports`
--
ALTER TABLE `passports` ADD FULLTEXT KEY `full_name` (`full_name`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
