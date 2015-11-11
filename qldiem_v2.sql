-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 11, 2015 at 07:58 AM
-- Server version: 5.6.24
-- PHP Version: 5.6.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `qldiem_v2`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `authenticating`(IN `username` varchar(8),IN `password` varchar(40))
BEGIN
	SELECT * FROM tk WHERE tk.USERNAME = `username` and tk.`PASSWORD` = `password`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_cb_login`(IN `id_cb` int)
BEGIN
	SELECT cb.ID, cb.MSCB, cb.HO_TEN, cb.GIOI_TINH, cb.NGAY_SINH, cb.PHONG_BAN, khoa.KHOA 
	FROM qldiem.cb 
		INNER JOIN qldiem.khoa ON khoa.ID = cb.ID_KHOA
	WHERE cb.ID = `id_cb`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_hk_nk`()
BEGIN
	SELECT
		hk_nh.ID,
		hk_nh.NK,
		hk_nh.HK,
		hk_nh.BD,
		hk_nh.KT
	FROM
		hk_nh
	ORDER BY
		hk_nh.BD desc,
		hk_nh.KT desc,
		hk_nh.NK desc,
		hk_nh.HK desc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_sv_diem_hp`(IN `nk` char(9),IN `hk` tinyint(4),IN `id_sv` int)
BEGIN
	SELECT
		mh.MA_MH,
		mh.TEN_MH,
		mh.DIEU_KIEN,
		hp.MA_HP,
		mh.SO_TC,
		ct_hp.DIEM_CHU,
		ct_hp.DIEM_10,
		ct_hp.DIEM_4,
		ct_hp.TL,
		ct_hp.CAI_THIEN,
		hk_nh.NK,
		hk_nh.HK
	FROM
		hp
		INNER JOIN mh ON mh.ID = hp.ID_MH
		INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
		INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
	WHERE
		(hk_nh.NK = `nk` OR `nk` IS NULL) AND
		(hk_nh.HK = `hk` OR `hk` IS NULL) AND
		 ct_hp.ID_SV = `id_sv`
	ORDER BY
		hk_nh.NK asc,
		hk_nh.HK asc,
		mh.MA_MH asc;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_sv_login`(IN `id_sv` int)
BEGIN
	SELECT sv.MSSV AS 1_MSSV, sv.HO_TEN as 2_HO_TEN, 
				sv.GIOI_TINH as 3_GIOI_TINH, DATE_FORMAT(sv.NGAY_SINH,'%d/%m/%Y') as 4_NGAY_SINH, 
				lop.LOP as 5_LOP, lop.TEN_LOP as 6_TEN_LOP, 
				cn.CHUYEN_NGANH as 7_CHUYEN_NGANH, khoa.KHOA as 8_KHOA, 
				sv.ID as 9_ID 
	FROM sv 
		INNER JOIN lop ON lop.ID = sv.ID_LOP 
		INNER JOIN khoa ON khoa.ID = sv.ID_KHOA 
		INNER JOIN cn ON cn.ID = sv.ID_CN 
	WHERE sv.ID = `id_sv`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_thang_diem`()
BEGIN
	SELECT
		thang_diem.ID,
		thang_diem.THANG_DIEM,
		DATE_FORMAT(thang_diem.TD_AP_DUNG,'%d/%m/%Y') as NGAY_AP_DUNG
	FROM
		thang_diem
	WHERE
		thang_diem.TD_AP_DUNG = (SELECT max(thang_diem.TD_AP_DUNG) FROM thang_diem);
END$$

--
-- Functions
--
CREATE DEFINER=`root`@`localhost` FUNCTION `get_tt_sv_diem_hp_tc_tl`(`nk` char(9),`hk` tinyint(4),`id_sv` int) RETURNS int(11)
BEGIN
	DECLARE tstctl int;
		SELECT SUM(SO_TC) INTO tstctl FROM ((SELECT
				ct_hp.ID_HP,
				SO_TC
			FROM
				hp
				INNER JOIN mh ON mh.ID = hp.ID_MH
				INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
				INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
			WHERE
				 ct_hp.ID_SV = `id_sv` AND
				 ct_hp.TL = 1 AND
				 STRCMP(hk_nh.NK, `nk`) = -1
		) UNION (
		SELECT
				ct_hp.ID_HP,
				SO_TC
			FROM
				hp
				INNER JOIN mh ON mh.ID = hp.ID_MH
				INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
				INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
			WHERE
				 ct_hp.ID_SV = `id_sv` AND
				 ct_hp.TL = 1 AND
				 hk_nh.NK = `nk` AND
				 hk_nh.HK <= `hk`  
		)) x;
	return tstctl;
END$$

CREATE DEFINER=`root`@`localhost` FUNCTION `get_tt_sv_diem_hp_tl`(`nk` char(9),`hk` tinyint(4),`id_sv` int) RETURNS float
BEGIN
		DECLARE tbtl float;
		SELECT SUM(TICH_DIEM)/SUM(SO_TC) INTO tbtl FROM ((SELECT
				ct_hp.ID_HP,
				SO_TC,
				mh.SO_TC * ct_hp.DIEM_4 AS TICH_DIEM
			FROM
				hp
				INNER JOIN mh ON mh.ID = hp.ID_MH
				INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
				INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
			WHERE
				 ct_hp.ID_SV = `id_sv` AND
				 mh.DIEU_KIEN = 0 AND
				 ct_hp.TL = 1 AND
				 ct_hp.DIEM_10 <= 10 AND
				 STRCMP(hk_nh.NK, `nk`) = -1
		) UNION (
		SELECT
				ct_hp.ID_HP,
				SO_TC,
				mh.SO_TC * ct_hp.DIEM_4 AS TICH_DIEM
			FROM
				hp
				INNER JOIN mh ON mh.ID = hp.ID_MH
				INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
				INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
			WHERE
				 ct_hp.ID_SV = `id_sv` AND
				 mh.DIEU_KIEN = 0 AND
				 ct_hp.TL = 1 AND
				 ct_hp.DIEM_10 <= 10 AND
				 hk_nh.NK = `nk` AND
				 hk_nh.HK <= `hk`  
		)) x;
	return tbtl;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `cb`
--

CREATE TABLE IF NOT EXISTS `cb` (
  `ID` int(10) unsigned NOT NULL,
  `ID_KHOA` int(10) unsigned DEFAULT NULL,
  `MSCB` varchar(5) COLLATE utf8_bin NOT NULL,
  `HO_TEN` varchar(200) COLLATE utf8_bin NOT NULL,
  `GIOI_TINH` tinyint(1) NOT NULL,
  `NGAY_SINH` date NOT NULL,
  `PHONG_BAN` varchar(100) COLLATE utf8_bin DEFAULT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `cb`
--

INSERT INTO `cb` (`ID`, `ID_KHOA`, `MSCB`, `HO_TEN`, `GIOI_TINH`, `NGAY_SINH`, `PHONG_BAN`) VALUES
(1, 1, '1122', 'Hồ Quang Thái', 0, '1986-11-22', NULL),
(2, 1, '2211', 'Trần Thức Tỉnh', 0, '1986-12-31', NULL),
(3, 1, '1133', 'Tô Châu', 1, '1967-11-16', NULL),
(4, 1, '1234', 'Nguyễn Thị Thu Lan', 1, '1956-01-02', ''),
(5, 1, '1204', 'Trần Ngọc Khánh', 0, '1980-11-01', NULL),
(6, 1, '0029 ', 'Trần Việt Dũng', 1, '1987-01-08', 'Quản lý ngành'),
(7, NULL, '0430 ', 'Vũ Thanh Nguyên ', 0, '1997-09-18', 'Admin'),
(8, NULL, '0434', 'Trần Đình Thi ', 0, '1976-11-09', 'Phòng Đào Tạo');

-- --------------------------------------------------------

--
-- Table structure for table `cn`
--

CREATE TABLE IF NOT EXISTS `cn` (
  `ID` int(10) unsigned NOT NULL,
  `CHUYEN_NGANH` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `cn`
--

INSERT INTO `cn` (`ID`, `CHUYEN_NGANH`) VALUES
(2, 'Công nghệ phần mềm'),
(1, 'Hệ thống thông tin'),
(3, 'Khoa Học Máy Tính'),
(4, 'Mạng máy tính');

-- --------------------------------------------------------

--
-- Table structure for table `ct_hp`
--

CREATE TABLE IF NOT EXISTS `ct_hp` (
  `ID_SV` int(10) unsigned NOT NULL,
  `ID_HP` int(10) unsigned NOT NULL,
  `DIEM_CHU` varchar(2) COLLATE utf8_bin DEFAULT NULL,
  `DIEM_10` float DEFAULT NULL,
  `DIEM_4` float DEFAULT NULL,
  `CAI_THIEN` tinyint(1) NOT NULL,
  `TL` tinyint(1) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `ct_hp`
--

INSERT INTO `ct_hp` (`ID_SV`, `ID_HP`, `DIEM_CHU`, `DIEM_10`, `DIEM_4`, `CAI_THIEN`, `TL`) VALUES
(1, 1, 'B', 7, 3, 0, 1),
(1, 4, 'M', 11, 5, 0, 1),
(1, 6, 'F', 3, 0, 0, 0),
(1, 10, 'C', 6, 2, 0, 1),
(1, 18, 'B+', 8, 3.5, 0, 1),
(1, 21, 'B', 7.3, 3, 0, 1),
(1, 26, 'F', 3.7, 0, 0, 0),
(1, 36, 'D+', 5.3, 1.5, 0, 0),
(1, 39, 'D', 4, 1, 0, 1),
(1, 46, 'C', 6, 2, 1, 1),
(1, 48, 'A', 9.8, 4, 0, 1),
(1, 49, 'B+', 8.7, 3.5, 0, 1),
(1, 51, 'A', 9.3, 4, 0, 1),
(1, 54, 'B+', 8, 3.5, 0, 1),
(1, 55, 'B', 7.5, 3, 0, 1),
(1, 68, 'W', 11, 5, 0, 0),
(1, 70, '', NULL, NULL, 1, 0),
(1, 72, 'I', 11, 5, 1, 0),
(1, 73, '', NULL, NULL, 0, 0),
(1, 75, '', NULL, NULL, 0, 0),
(1, 78, '', NULL, NULL, 1, 0),
(1, 79, '', NULL, NULL, 1, 0),
(2, 1, 'C+', 6.6, 2.5, 0, 1),
(2, 3, 'F', NULL, NULL, 0, 0),
(2, 10, 'C', 6, 2, 0, 1),
(2, 14, 'C+', 6.6, 2.5, 0, 1),
(2, 17, 'D+', 5.1, 1.5, 0, 1),
(2, 19, 'A', 9.8, 4, 0, 1),
(2, 22, 'B+', 8.1, 3.5, 0, 1),
(2, 30, 'B', 7.3, 3, 0, 1),
(2, 32, 'C', 6, 2, 1, 1),
(2, 34, 'C', 6, 2, 1, 1),
(2, 36, 'B', 7.3, 3, 0, 1),
(2, 38, 'C+', 6.6, 2.5, 1, 1),
(2, 41, 'C', 6, 2, 1, 1),
(2, 43, 'B', 7.5, 3, 1, 1),
(2, 45, 'B', 7.1, 3, 1, 1),
(2, 47, 'B', 7.8, 3, 0, 1),
(2, 48, 'F', NULL, NULL, 1, 0),
(2, 49, 'B', 7.9, 3, 0, 1),
(2, 54, 'A', 9, 4, 0, 1),
(2, 55, 'B+', 8.3, 3.5, 1, 1),
(2, 61, '', NULL, NULL, 1, 0),
(2, 63, '', NULL, NULL, 1, 0),
(2, 66, '', NULL, NULL, 1, 0),
(2, 73, '', NULL, NULL, 1, 0),
(2, 75, '', NULL, NULL, 0, 0),
(2, 78, '', NULL, NULL, 0, 0),
(2, 79, '', NULL, NULL, 1, 0),
(3, 2, 'B', 7.6, 3, 0, 1),
(3, 3, 'B', 7.6, 3, 0, 1),
(3, 7, 'B+', 8.4, 3.5, 0, 1),
(3, 12, 'C', 6, 2, 0, 1),
(3, 14, 'D', 4.6, 1, 0, 1),
(3, 15, 'C', 6.1, 2, 0, 1),
(3, 18, 'F', NULL, NULL, 0, 0),
(3, 19, 'A', 10, 4, 0, 1),
(3, 20, 'B', 7.6, 3, 1, 1),
(3, 24, 'D', 4.1, 1, 0, 1),
(3, 26, 'D', 4.9, 1, 0, 1),
(3, 28, 'D+', 5.1, 1.5, 0, 1),
(3, 29, 'D', 4, 1, 0, 1),
(3, 31, 'B', 7, 3, 1, 1),
(3, 34, 'B', 7.5, 3, 1, 1),
(3, 35, 'C+', 6.3, 2.5, 0, 1),
(3, 37, 'B+', 8.6, 3.5, 0, 1),
(3, 41, 'C+', 6.5, 2.5, 1, 1),
(3, 43, 'B', 7.2, 3, 1, 1),
(3, 45, 'B', 7.6, 3, 1, 1),
(3, 50, 'D', 4, 1, 1, 1),
(3, 51, 'C+', 6.8, 2.5, 1, 1),
(3, 54, 'A', 9.3, 4, 1, 1),
(3, 55, 'B+', 8.7, 3.5, 1, 1),
(3, 58, 'F', NULL, NULL, 0, 1),
(3, 60, 'C+', 6.5, 2.5, 1, 1),
(3, 61, '', NULL, NULL, 1, 0),
(3, 63, '', NULL, NULL, 1, 0),
(3, 67, '', NULL, NULL, 1, 0),
(3, 68, '', NULL, NULL, 1, 0),
(3, 70, '', NULL, NULL, 1, 0),
(3, 72, '', NULL, NULL, 1, 0),
(3, 74, '', NULL, NULL, 1, 0),
(3, 75, '', NULL, NULL, 1, 0),
(3, 78, '', NULL, NULL, 1, 0),
(3, 79, '', NULL, NULL, 1, 0),
(4, 1, 'D', 4.3, 1, 0, 1),
(4, 4, 'B', 7, 3, 0, 1),
(4, 5, 'C+', 6.7, 2.5, 0, 1),
(4, 7, 'B', 7.5, 3, 0, 1),
(4, 10, 'C+', 6.7, 2.5, 0, 1),
(4, 11, 'A', 9.3, 4, 0, 1),
(4, 14, 'C', 5.7, 2, 0, 1),
(4, 15, 'B+', 8, 3.5, 0, 1),
(4, 18, 'D', 4.1, 1, 0, 1),
(4, 21, 'C+', 6.7, 2.5, 0, 1),
(4, 24, 'B', 7.9, 3, 0, 1),
(4, 26, 'D+', 5.2, 1.5, 0, 1),
(4, 27, 'B', 7, 3, 0, 1),
(4, 28, 'D', 4.8, 1, 1, 1),
(4, 30, 'C', 5.6, 2, 0, 1),
(4, 31, 'B+', 8, 3.5, 1, 1),
(4, 32, 'D+', 5.3, 1.5, 1, 1),
(4, 35, 'C', 5.7, 2, 1, 1),
(4, 38, 'I', NULL, NULL, 1, 0),
(4, 39, 'C+', 6.9, 2.5, 0, 1),
(4, 41, 'D+', 5.3, 1.5, 1, 1),
(4, 44, 'B+', 8.4, 3.5, 1, 1),
(4, 45, 'B+', 8.7, 3.5, 1, 1),
(4, 46, 'A', 9.4, 4, 1, 1),
(4, 48, 'A', 10, 4, 1, 1),
(4, 49, 'B', 7.3, 3, 1, 1),
(4, 54, 'A', 9.5, 4, 1, 1),
(4, 55, 'B', 7.2, 3, 1, 1),
(4, 58, 'D', 4.2, 1, 1, 1),
(4, 59, 'F', NULL, NULL, 1, 1),
(4, 60, 'B', 7.4, 3, 1, 1),
(4, 61, '', NULL, NULL, 1, 0),
(4, 64, '', NULL, NULL, 1, 0),
(4, 66, '', NULL, NULL, 1, 0),
(4, 70, '', NULL, NULL, 1, 0),
(4, 72, '', NULL, NULL, 1, 0),
(4, 74, '', NULL, NULL, 1, 0),
(4, 75, '', NULL, NULL, 1, 0),
(4, 78, '', NULL, NULL, 1, 0),
(4, 79, '', NULL, NULL, 1, 0),
(5, 1, 'M', NULL, NULL, 0, 0),
(5, 2, 'M', 6, 2, 0, 0),
(5, 6, 'B', 7.3, 3, 0, 1),
(5, 9, 'B', 7.1, 3, 0, 1),
(5, 11, 'B', 7.6, 3, 0, 1),
(5, 13, 'B+', 8.3, 3.5, 0, 1),
(5, 15, 'D', 4, 1, 0, 1),
(5, 16, 'D+', 5.2, 1.5, 1, 1),
(5, 17, 'C', 6.3, 2, 0, 1),
(5, 20, 'B', 7, 3, 0, 1),
(5, 21, 'C', 6, 2, 0, 1),
(5, 22, 'F', NULL, NULL, 1, 0),
(5, 26, 'C', 6.2, 2, 0, 1),
(5, 28, 'A', 9.6, 4, 0, 1),
(5, 30, 'C+', 6.5, 2.5, 0, 1),
(5, 34, 'B+', 8.9, 3.5, 1, 1),
(5, 36, 'A', 9.4, 4, 1, 1),
(5, 38, 'C', 5.5, 2, 1, 1),
(5, 41, 'D', 4.5, 1, 1, 1),
(5, 44, 'B', 7, 3, 1, 1),
(5, 46, 'B', 7.8, 3, 1, 1),
(5, 48, 'C+', 6.7, 2.5, 0, 1),
(5, 51, 'B+', 8.6, 3.5, 1, 1),
(5, 54, 'A', 9, 4, 1, 1),
(5, 55, 'D', 4.5, 1, 1, 1),
(5, 58, 'D', 4.3, 1, 1, 1),
(5, 59, 'D', 4.5, 1, 1, 1),
(5, 61, '', NULL, NULL, 1, 0),
(5, 63, '', NULL, NULL, 1, 0),
(5, 64, '', NULL, NULL, 1, 0),
(5, 66, '', NULL, NULL, 1, 0),
(5, 68, '', NULL, NULL, 1, 0),
(5, 69, '', NULL, NULL, 1, 0),
(5, 71, '', NULL, NULL, 1, 0),
(5, 72, '', NULL, NULL, 1, 0),
(5, 74, '', NULL, NULL, 1, 0),
(5, 75, '', NULL, NULL, 0, 0),
(5, 77, '', NULL, NULL, 1, 0),
(5, 79, '', NULL, NULL, 1, 0),
(6, 2, 'A', 9.7, 4, 0, 1),
(6, 4, 'C', 5.1, 2.5, 0, 1),
(6, 6, 'B', 7.4, 3, 0, 1),
(6, 8, 'B+', 8.8, 3.5, 0, 1),
(6, 9, 'F', NULL, NULL, 0, 0),
(6, 11, 'B', 7.7, 3, 0, 1),
(6, 13, 'B', 7, 3, 0, 1),
(6, 15, 'B ', 7.7, 3, 0, 1),
(6, 17, 'D', 4.8, 1, 0, 1),
(6, 18, 'D+', 5.3, 1.5, 1, 1),
(6, 19, 'B', 7, 3, 0, 1),
(6, 21, 'D', 4.3, 1, 0, 1),
(6, 24, 'W', NULL, NULL, 0, 0),
(6, 25, 'D', 4.4, 1, 0, 1),
(6, 27, 'B+', 8.7, 3.5, 0, 1),
(6, 29, 'B', 7.2, 3, 0, 1),
(6, 31, 'B', 7.5, 3, 1, 1),
(6, 34, 'B+', 8.7, 3.5, 1, 1),
(6, 36, 'D+', 5, 1.5, 1, 1),
(6, 38, 'B+', 8.5, 3.5, 1, 1),
(6, 40, 'C', 6.2, 2, 1, 1),
(6, 42, 'B', 7.8, 3, 1, 1),
(6, 44, 'B', 7.1, 3, 1, 1),
(6, 46, 'B+', 8.5, 3.5, 1, 1),
(6, 51, 'C', 6.2, 2, 1, 1),
(6, 53, 'B+', 8.7, 3.5, 1, 1),
(6, 56, 'D+', 5.2, 1.5, 1, 1),
(6, 58, 'F', NULL, NULL, 1, 0),
(6, 59, 'I', NULL, NULL, 1, 0),
(6, 62, '', NULL, NULL, 1, 0),
(6, 64, '', NULL, NULL, 1, 0),
(6, 66, '', NULL, NULL, 1, 0),
(6, 68, '', NULL, NULL, 1, 0),
(6, 69, '', NULL, NULL, 1, 0),
(6, 72, '', NULL, NULL, 1, 0),
(6, 74, '', NULL, NULL, 1, 0),
(6, 76, '', NULL, NULL, 1, 0),
(6, 78, '', NULL, NULL, 1, 0),
(7, 1, 'D+', 5, 1.5, 0, 1),
(7, 4, 'W', NULL, NULL, 0, 0),
(7, 5, 'A', 9.4, 4, 0, 1),
(7, 7, 'C+', 6.7, 2.5, 0, 1),
(7, 10, 'D', 4.5, 1, 0, 1),
(7, 11, 'F', NULL, NULL, 0, 0),
(7, 13, 'D', 4.5, 1, 0, 1),
(7, 16, 'C', 6.1, 2, 0, 1),
(7, 18, 'F', NULL, NULL, 0, 0),
(7, 20, 'B', 7.4, 3, 0, 1),
(7, 21, 'W', NULL, NULL, 0, 0),
(7, 22, 'B', 7, 3, 1, 1),
(7, 24, 'C+', 6.6, 2.5, 0, 1),
(7, 25, 'D+', 5.4, 1.5, 0, 1),
(7, 29, 'F', NULL, NULL, 0, 0),
(7, 31, 'F', NULL, NULL, 1, 0),
(7, 32, 'B+', 8.2, 3.5, 1, 1),
(7, 33, 'C+', 6.1, 2, 1, 1),
(7, 35, 'D', 4.7, 1, 1, 1),
(7, 37, 'F', NULL, NULL, 1, 1),
(7, 39, 'F', NULL, NULL, 1, 1),
(7, 42, 'M', NULL, NULL, 1, 0),
(7, 44, 'M', NULL, NULL, 1, 0),
(7, 48, 'C', 6, 2, 1, 1),
(7, 50, 'B', 7.4, 3, 1, 1),
(7, 52, 'B', 7.3, 3, 1, 1),
(7, 53, 'B', 7, 3, 1, 1),
(7, 56, 'D', 4, 1, 1, 1),
(7, 57, 'D', 4.3, 1, 1, 1),
(7, 60, 'C', 6.4, 2, 1, 1),
(7, 62, '', NULL, NULL, 1, 0),
(7, 64, '', NULL, NULL, 1, 0),
(7, 65, '', NULL, NULL, 1, 0),
(7, 68, '', NULL, NULL, 1, 0),
(7, 69, '', NULL, NULL, 1, 0),
(7, 77, '', NULL, NULL, 1, 0),
(7, 80, '', NULL, NULL, 1, 0),
(8, 2, 'D', 4.3, 1, 0, 1),
(8, 3, 'D', 4.7, 1, 0, 1),
(8, 5, 'C', 5.6, 2, 0, 1),
(8, 8, 'A', 9.2, 4, 0, 1),
(8, 9, 'B', 7.7, 3, 0, 1),
(8, 12, 'B+', 8, 3.5, 0, 1),
(8, 13, 'C+', 6.8, 2.5, 0, 1),
(8, 16, 'A', 9.7, 4, 0, 1),
(8, 19, 'A', 10, 4, 0, 1),
(8, 22, 'C+', 6.7, 2.5, 0, 1),
(8, 23, 'C', 5.5, 2, 0, 1),
(8, 24, 'C', 6, 2, 1, 1),
(8, 25, 'B', 7.8, 3, 0, 1),
(8, 28, 'A', 9.3, 4, 0, 1),
(8, 29, 'A', 9.1, 4, 0, 1),
(8, 32, 'B+', 8, 3.5, 1, 1),
(8, 34, 'D+', 5.2, 1.5, 1, 1),
(8, 36, 'B', 7.4, 3, 1, 1),
(8, 37, 'W', NULL, NULL, 1, 0),
(8, 40, 'D', 4, 1, 1, 1),
(8, 42, 'C+', 6.9, 2.5, 1, 1),
(8, 46, 'B+', 8, 3.5, 1, 1),
(8, 47, 'B', 7, 3, 1, 1),
(8, 49, 'F', NULL, NULL, 1, 0),
(8, 52, 'B', 7.6, 3, 1, 1),
(8, 53, 'C', 6.2, 2, 1, 1),
(8, 56, 'C', 5, 2, 1, 1),
(8, 57, 'C+', 6.7, 2.5, 1, 1),
(8, 60, 'D', 4.5, 1, 1, 1),
(8, 62, '', NULL, NULL, 1, 0),
(8, 64, '', NULL, NULL, 1, 0),
(8, 66, '', NULL, NULL, 1, 0),
(8, 67, '', NULL, NULL, 1, 0),
(8, 70, '', NULL, NULL, 0, 0),
(8, 71, '', NULL, NULL, 1, 0),
(8, 73, '', NULL, NULL, 1, 0),
(8, 76, '', NULL, NULL, 1, 0),
(8, 77, '', NULL, NULL, 1, 0),
(8, 80, '', NULL, NULL, 1, 0),
(9, 3, 'A', 9.7, 4, 0, 1),
(9, 6, 'D', 4.3, 1, 0, 1),
(9, 8, 'A', 9.3, 4, 0, 1),
(9, 12, 'B', 7.4, 3, 0, 1),
(9, 14, 'F', NULL, NULL, 0, 0),
(9, 16, 'B+', 8.5, 3.5, 0, 1),
(9, 20, 'B+', 8.4, 3.5, 0, 1),
(9, 22, 'B+', 8.5, 3.5, 0, 1),
(9, 23, 'A', 9.4, 4, 0, 1),
(9, 26, 'F', NULL, NULL, 0, 1),
(9, 28, 'B', 7.8, 3, 0, 1),
(9, 30, 'C', 6, 2, 0, 1),
(9, 32, 'M', NULL, NULL, 1, 0),
(9, 33, 'M', NULL, NULL, 0, 0),
(9, 37, 'A', 9, 4, 0, 1),
(9, 40, 'D+', 5.3, 1.5, 1, 1),
(9, 42, 'C+', 6.7, 2.5, 1, 1),
(9, 44, 'D+', 5.2, 1.5, 1, 1),
(9, 47, 'B', 7, 3, 1, 1),
(9, 49, 'C+', 6.5, 2.5, 1, 1),
(9, 52, 'B', 7.2, 3, 1, 1),
(9, 53, 'C+', 6.6, 2.5, 1, 1),
(9, 56, 'B', 7.3, 3, 1, 1),
(9, 57, 'B+', 7.3, 3, 1, 1),
(9, 60, 'D', 4.7, 1, 1, 1),
(9, 62, '', NULL, NULL, 1, 0),
(9, 65, '', NULL, NULL, 1, 0),
(9, 67, '', NULL, NULL, 1, 0),
(9, 70, '', NULL, NULL, 1, 0),
(9, 71, '', NULL, NULL, 1, 0),
(9, 73, '', NULL, NULL, 1, 0),
(9, 76, '', NULL, NULL, 1, 0),
(9, 80, '', NULL, NULL, 1, 0),
(10, 4, 'B+', 8.4, 3.5, 0, 1),
(10, 6, 'D+', 5.1, 1.5, 0, 1),
(10, 7, 'A', 9, 4, 0, 1),
(10, 9, 'B+', 8.9, 3.5, 0, 1),
(10, 12, 'C+', 6.9, 2.5, 0, 1),
(10, 16, 'B', 7.4, 3, 0, 1),
(10, 20, 'B', 7.5, 3, 0, 1),
(10, 23, 'C+', 6.8, 2.5, 0, 1),
(10, 25, 'C', 6.1, 2, 0, 1),
(10, 27, 'B', 7.5, 3, 0, 1),
(10, 29, 'B+', 8.1, 3.5, 0, 1),
(10, 31, 'D', 4.3, 1, 1, 1),
(10, 33, 'B', 7.4, 3, 0, 1),
(10, 35, 'B', 7.6, 3, 1, 1),
(10, 37, 'A', 9.7, 4, 1, 1),
(10, 39, 'A', 9.4, 4, 1, 1),
(10, 40, 'B', 7.7, 3, 1, 1),
(10, 42, 'C', 6, 2, 1, 1),
(10, 45, 'A', 9.4, 4, 1, 1),
(10, 47, 'B', 7.3, 3, 1, 1),
(10, 50, 'C', 6, 2, 1, 1),
(10, 51, 'C+', 6.8, 2.5, 1, 1),
(10, 52, 'B+', 7.9, 3.5, 1, 1),
(10, 53, 'C', 6.1, 2, 1, 1),
(10, 56, 'B+', 8, 3.5, 0, 1),
(10, 57, 'B+', 8, 3.5, 0, 1),
(10, 59, 'C', 6.1, 2, 1, 1),
(10, 62, '', NULL, NULL, 1, 0),
(10, 65, '', NULL, NULL, 1, 0),
(10, 67, '', NULL, NULL, 1, 0),
(10, 69, '', NULL, NULL, 0, 0),
(10, 71, '', NULL, NULL, 1, 0),
(10, 73, '', NULL, NULL, 1, 0),
(10, 76, '', NULL, NULL, 1, 0),
(10, 77, '', NULL, NULL, 1, 0),
(10, 80, '', NULL, NULL, 1, 0),
(11, 3, 'B', 7, 3, 0, 1),
(11, 5, 'F', NULL, NULL, 0, 0),
(11, 7, 'B+', 8.2, 3.5, 0, 1),
(11, 8, 'A', 10, 4, 1, 1),
(11, 9, 'C+', 6.6, 2.5, 0, 1),
(11, 12, 'B', 7.5, 3, 0, 1),
(11, 14, 'C', 5.6, 2, 0, 1),
(11, 15, 'C+', 6.6, 2.5, 0, 1),
(11, 17, 'B+', 8.5, 3.5, 0, 1),
(11, 19, 'C', 6, 2, 0, 1),
(11, 23, 'A', 9, 4, 0, 1),
(11, 27, 'C+', 6.5, 2.5, 0, 1),
(11, 30, 'C+', 6.6, 2.5, 0, 1),
(11, 33, 'C+', 6.7, 2.5, 0, 1),
(11, 35, 'B', 7, 3, 1, 1),
(11, 38, 'B', 7.4, 3, 1, 1),
(11, 39, 'C', 6, 2, 1, 1),
(11, 43, 'B+', 8.7, 3.5, 1, 1),
(11, 45, 'A', 9, 4, 1, 1),
(11, 47, 'B', 7.5, 3, 1, 1),
(11, 50, 'D', 4.8, 1, 1, 1),
(11, 52, 'B', 7.4, 3, 1, 1),
(11, 57, 'B', 7, 3, 0, 1),
(11, 58, 'F', NULL, NULL, 1, 0),
(11, 59, 'C+', 6.8, 2.5, 1, 1),
(11, 63, '', NULL, NULL, 1, 0),
(11, 65, '', NULL, NULL, 1, 0),
(11, 67, '', NULL, NULL, 1, 0),
(11, 69, '', NULL, NULL, 1, 0),
(11, 71, '', NULL, NULL, 1, 0),
(11, 74, '', NULL, NULL, 1, 0),
(11, 77, '', NULL, NULL, 1, 0),
(11, 80, '', NULL, NULL, 0, 0),
(12, 2, 'C+', 6.8, 2.5, 0, 1),
(12, 5, 'D', 4.1, 1, 0, 1),
(12, 8, 'A', 9.7, 4, 0, 1),
(12, 10, 'B+', 8.3, 3.5, 0, 1),
(12, 11, 'B+', 8.8, 3.5, 0, 1),
(12, 13, 'D+', 5.2, 1.5, 0, 1),
(12, 17, 'B', 7.6, 3, 0, 1),
(12, 23, 'B+', 8.2, 3.5, 0, 1),
(12, 25, 'B', 7.7, 3, 0, 1),
(12, 27, 'B', 7, 3, 0, 1),
(12, 40, 'F', NULL, NULL, 0, 0),
(12, 43, 'B+', 8.6, 3.5, 0, 1);

-- --------------------------------------------------------

--
-- Table structure for table `hk_nh`
--

CREATE TABLE IF NOT EXISTS `hk_nh` (
  `ID` int(10) unsigned NOT NULL,
  `NK` char(9) COLLATE utf8_bin NOT NULL,
  `HK` tinyint(4) NOT NULL,
  `BD` date NOT NULL,
  `KT` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `hk_nh`
--

INSERT INTO `hk_nh` (`ID`, `NK`, `HK`, `BD`, `KT`) VALUES
(1, '2014-2015', 1, '2014-08-01', '2015-12-31'),
(2, '2014-2015', 2, '2015-01-01', '2015-06-01'),
(3, '2014-2015', 3, '2015-06-01', '2015-07-01'),
(4, '2015-2016', 1, '2015-08-01', '2016-12-31');

-- --------------------------------------------------------

--
-- Table structure for table `hp`
--

CREATE TABLE IF NOT EXISTS `hp` (
  `ID` int(10) unsigned NOT NULL,
  `ID_MH` int(10) unsigned NOT NULL,
  `ID_HK_NH` int(10) unsigned NOT NULL,
  `ID_GV` int(10) unsigned NOT NULL,
  `MA_HP` varchar(8) COLLATE utf8_bin NOT NULL,
  `LT` tinyint(4) NOT NULL,
  `TH` tinyint(4) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=81 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `hp`
--

INSERT INTO `hp` (`ID`, `ID_MH`, `ID_HK_NH`, `ID_GV`, `MA_HP`, `LT`, `TH`) VALUES
(1, 15, 1, 1, 'TH00101', 15, 15),
(2, 15, 1, 2, 'TH00102', 15, 15),
(3, 14, 1, 2, 'TH00201', 0, 30),
(4, 14, 1, 3, 'TH00201', 0, 30),
(5, 1, 1, 4, 'CT10001', 15, 30),
(6, 1, 1, 4, 'CT10002', 15, 30),
(7, 2, 1, 2, 'CT10101', 15, 30),
(8, 2, 1, 5, 'CT10102', 15, 30),
(9, 3, 1, 4, 'CT12301', 15, 15),
(10, 3, 1, 2, 'CT12302', 15, 15),
(11, 4, 1, 5, 'CT10601', 15, 45),
(12, 4, 1, 4, 'CT10602', 15, 45),
(13, 5, 1, 3, 'CT10701', 15, 30),
(14, 5, 1, 4, 'CT10701', 15, 30),
(15, 6, 1, 1, 'CT10901', 15, 30),
(16, 6, 1, 5, 'CT10902', 15, 30),
(17, 7, 1, 4, 'CT11301', 15, 30),
(18, 7, 1, 2, 'CT11302', 15, 30),
(19, 8, 1, 3, 'CT11801', 15, 15),
(20, 8, 1, 1, 'CT11802', 15, 15),
(21, 9, 2, 1, 'CT12501', 15, 15),
(22, 9, 2, 3, 'CT12502', 15, 15),
(23, 10, 2, 5, 'CT12701', 15, 30),
(24, 10, 2, 2, 'CT12702', 15, 30),
(25, 11, 2, 4, 'CT11601', 15, 30),
(26, 11, 2, 2, 'CT11602', 15, 30),
(27, 12, 2, 5, 'CT30401', 15, 15),
(28, 12, 2, 4, 'CT30402', 15, 15),
(29, 13, 2, 4, 'CT31701', 15, 15),
(30, 13, 2, 3, 'CT31702', 15, 15),
(31, 14, 2, 2, 'TH00201', 0, 30),
(32, 14, 2, 3, 'TH00202', 0, 30),
(33, 15, 2, 1, 'TH00101', 15, 15),
(34, 15, 2, 5, 'TH00102', 15, 15),
(35, 1, 2, 4, 'CT10001', 15, 30),
(36, 1, 2, 5, 'CT10002', 15, 30),
(37, 3, 2, 3, 'CT12301', 15, 45),
(38, 3, 2, 1, 'CT12302', 15, 45),
(39, 8, 2, 1, 'CT11801', 15, 15),
(40, 8, 2, 3, 'CT11802', 15, 15),
(41, 15, 3, 1, 'TH00101', 15, 15),
(42, 15, 3, 2, 'TH00102', 15, 15),
(43, 14, 3, 4, 'TH00201', 0, 30),
(44, 14, 3, 2, 'TH00201', 0, 30),
(45, 1, 3, 1, 'CT10001', 15, 30),
(46, 1, 3, 4, 'CT10002', 15, 30),
(47, 2, 3, 5, 'CT10101', 15, 30),
(48, 2, 3, 3, 'CT10102', 15, 30),
(49, 12, 3, 1, 'CT30401', 15, 15),
(50, 12, 3, 4, 'CT30402', 15, 15),
(51, 6, 3, 2, 'CT10901', 15, 30),
(52, 6, 3, 4, 'CT10902', 15, 30),
(53, 11, 3, 1, 'CT11601', 15, 30),
(54, 11, 3, 5, 'CT11602', 15, 30),
(55, 5, 3, 2, 'CT10701', 15, 30),
(56, 5, 3, 1, 'CT10702', 15, 30),
(57, 9, 3, 1, 'CT12501', 15, 15),
(58, 9, 3, 3, 'CT12502', 15, 15),
(59, 4, 3, 5, 'CT10701', 15, 30),
(60, 4, 3, 2, 'CT10702', 15, 30),
(61, 15, 4, 1, 'TH00101', 15, 15),
(62, 15, 4, 3, 'TH00102', 15, 15),
(63, 14, 4, 2, 'TH00201', 0, 30),
(64, 14, 4, 5, 'TH00202', 0, 30),
(65, 1, 4, 2, 'CT10001', 15, 30),
(66, 1, 4, 5, 'CT10002', 15, 30),
(67, 4, 4, 1, 'CT10601', 15, 45),
(68, 4, 4, 3, 'CT10602', 15, 45),
(69, 7, 4, 2, 'CT11301', 15, 30),
(70, 7, 4, 3, 'CT11302', 15, 30),
(71, 5, 4, 5, 'CT10701', 15, 30),
(72, 5, 4, 4, 'CT10702', 15, 30),
(73, 13, 4, 2, 'CT31701', 15, 15),
(74, 13, 4, 1, 'CT31702', 15, 15),
(75, 10, 4, 3, 'CT12701', 15, 30),
(76, 10, 4, 4, 'CT12702', 15, 30),
(77, 12, 4, 4, 'CT30401', 15, 15),
(78, 12, 4, 1, 'CT30402', 15, 15),
(79, 11, 4, 1, 'CT11601', 15, 30),
(80, 11, 4, 3, 'CT11602', 15, 30);

-- --------------------------------------------------------

--
-- Table structure for table `kh`
--

CREATE TABLE IF NOT EXISTS `kh` (
  `ID` int(10) unsigned NOT NULL,
  `ID_HK_NH` int(10) unsigned NOT NULL,
  `MO_TA` text COLLATE utf8_bin NOT NULL,
  `BD` date NOT NULL,
  `KT` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `kh`
--

INSERT INTO `kh` (`ID`, `ID_HK_NH`, `MO_TA`, `BD`, `KT`) VALUES
(1, 1, 'Nhập điểm học kỳ 1', '2014-12-15', '2014-12-22'),
(2, 1, 'Lập báo cáo thống kê học kỳ 1', '2014-12-22', '2015-12-29'),
(3, 2, 'Nhập điểm học kỳ 2', '2015-05-15', '2015-05-22'),
(4, 2, 'Lập báo cáo thống kê học kỳ 2', '2015-05-22', '2015-05-29'),
(5, 3, 'Nhập điểm học kỳ hè', '2015-06-15', '2015-06-22'),
(6, 3, 'Lập báo cáo thống kê học kỳ hè', '2015-06-22', '2015-06-29'),
(7, 4, 'Nhập điểm học kỳ 1', '2015-12-15', '2015-12-22'),
(8, 4, 'Lập báo cáo thống kê học kỳ 1', '2015-12-22', '2015-12-29');

-- --------------------------------------------------------

--
-- Table structure for table `khoa`
--

CREATE TABLE IF NOT EXISTS `khoa` (
  `ID` int(10) unsigned NOT NULL,
  `KHOA` varchar(150) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `khoa`
--

INSERT INTO `khoa` (`ID`, `KHOA`) VALUES
(1, 'Khoa CNTT & TT');

-- --------------------------------------------------------

--
-- Table structure for table `lop`
--

CREATE TABLE IF NOT EXISTS `lop` (
  `ID` int(10) unsigned NOT NULL,
  `ID_CB` int(10) unsigned DEFAULT NULL,
  `LOP` varchar(8) COLLATE utf8_bin NOT NULL,
  `TEN_LOP` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `lop`
--

INSERT INTO `lop` (`ID`, `ID_CB`, `LOP`, `TEN_LOP`) VALUES
(1, 2, 'DI1094A1', 'Hệ thống thông tin'),
(2, 3, 'DI1095A1', 'Công nghệ phần mềm'),
(3, 1, 'DI1096A1', 'Khoa Học Máy Tính'),
(4, 5, 'DI1097A1', 'Mạng máy tính');

-- --------------------------------------------------------

--
-- Table structure for table `mh`
--

CREATE TABLE IF NOT EXISTS `mh` (
  `ID` int(10) unsigned NOT NULL,
  `MA_MH` varchar(6) COLLATE utf8_bin NOT NULL,
  `TEN_MH` varchar(150) COLLATE utf8_bin NOT NULL,
  `SO_TC` tinyint(4) NOT NULL,
  `DIEU_KIEN` bit(1) NOT NULL DEFAULT b'0'
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `mh`
--

INSERT INTO `mh` (`ID`, `MA_MH`, `TEN_MH`, `SO_TC`, `DIEU_KIEN`) VALUES
(1, 'CT100', 'Lập trình căn bản', 3, b'0'),
(2, 'CT101', 'Kiến trúc máy tính', 3, b'0'),
(3, 'CT123', 'Chuyên đề ngôn ngữ lập trình', 2, b'0'),
(4, 'CT106', 'Hệ cơ sở dữ liệu', 4, b'0'),
(5, 'CT107', 'Hệ điều hành', 3, b'0'),
(6, 'CT109', 'Phân tích thiết kế hệ thống thông tin', 3, b'0'),
(7, 'CT113', 'Nhập môn công nghệ phần mềm', 2, b'0'),
(8, 'CT118', 'Anh văn chuyên môn tin học', 2, b'0'),
(9, 'CT125', 'Mô phỏng', 2, b'0'),
(10, 'CT127', 'Lý thuyết thông tin', 3, b'0'),
(11, 'CT116', 'Java', 3, b'0'),
(12, 'CT304', 'Đồ họa', 2, b'0'),
(13, 'CT317', 'Giao diện người và máy', 2, b'0'),
(14, 'TH002', 'Thực hành  tin học căn bản', 2, b'1'),
(15, 'TH001', 'Tin học căn bản', 3, b'1');

-- --------------------------------------------------------

--
-- Table structure for table `sv`
--

CREATE TABLE IF NOT EXISTS `sv` (
  `ID` int(10) unsigned NOT NULL,
  `ID_LOP` int(10) unsigned NOT NULL,
  `ID_KHOA` int(10) unsigned NOT NULL,
  `ID_CN` int(10) unsigned NOT NULL,
  `MSSV` varchar(8) COLLATE utf8_bin NOT NULL,
  `HO_TEN` varchar(200) COLLATE utf8_bin NOT NULL,
  `GIOI_TINH` tinyint(1) NOT NULL,
  `NGAY_SINH` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `sv`
--

INSERT INTO `sv` (`ID`, `ID_LOP`, `ID_KHOA`, `ID_CN`, `MSSV`, `HO_TEN`, `GIOI_TINH`, `NGAY_SINH`) VALUES
(1, 1, 1, 1, '1101682', 'Ngô Giang Thanh', 0, '1992-08-25'),
(2, 1, 1, 1, '1101681', 'Lê Hoài Thanh', 0, '1992-01-02'),
(3, 1, 1, 1, '1101683', 'Phạm Hoài Thanh', 1, '1991-04-12'),
(4, 2, 1, 2, '1101684', 'Nguyễn Văn A', 0, '1993-12-31'),
(5, 2, 1, 2, '1101685', 'Nguyễn Văn C', 0, '1994-11-30'),
(6, 2, 1, 2, '1101686', 'Trần Thị An', 1, '1992-01-02'),
(7, 3, 1, 3, '1101687', 'Tâm Đoan', 1, '1992-05-01'),
(8, 3, 1, 3, '1101688', 'Cao Kỳ', 0, '1989-07-11'),
(9, 3, 1, 3, '1101689', 'Văn Thiệu', 0, '1992-06-26'),
(10, 4, 1, 1, '1111500', 'Nguyễn Văn Ngọc\r\n', 0, '1993-03-17'),
(11, 4, 1, 3, '1111501', 'Nguyễn Thị Hương Tuyền\r\n', 1, '1992-03-13'),
(12, 4, 1, 4, '1111502', 'Danh Nam', 0, '1993-05-15');

-- --------------------------------------------------------

--
-- Table structure for table `thang_diem`
--

CREATE TABLE IF NOT EXISTS `thang_diem` (
  `ID` int(10) unsigned NOT NULL,
  `THANG_DIEM` varchar(150) COLLATE utf8_bin NOT NULL,
  `TD_AP_DUNG` date NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `thang_diem`
--

INSERT INTO `thang_diem` (`ID`, `THANG_DIEM`, `TD_AP_DUNG`) VALUES
(1, 'A-9-Y-Y-4.0,B-7-Y-Y-3.0,C-6-Y-Y-2.0,D-4.0-Y-Y-1.0,F-0-N-N-0,M-11-Y-N-5,I-11-N-N-5,W-11-N-N-5', '2010-08-01'),
(2, 'A-9-Y-Y-4.0,B+-8-Y-Y-3.5,B-7-Y-Y-3.0,C+-6.5-Y-Y-2.5,C-6-Y-Y-2.0,D+-5-Y-Y-1.5,D-4.0-Y-Y-1.0,F-0-N-N-0,M-11-Y-N-5,I-11-N-N-5,W-11-N-N-5', '2012-08-01');

-- --------------------------------------------------------

--
-- Table structure for table `tk`
--

CREATE TABLE IF NOT EXISTS `tk` (
  `ID` int(10) unsigned NOT NULL,
  `ID_SV` int(10) unsigned DEFAULT NULL,
  `ID_CB` int(10) unsigned DEFAULT NULL,
  `USERNAME` varchar(8) COLLATE utf8_bin NOT NULL,
  `PASSWORD` varchar(40) COLLATE utf8_bin NOT NULL,
  `STATUS` tinyint(1) NOT NULL,
  `ROLE` varchar(10) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `tk`
--

INSERT INTO `tk` (`ID`, `ID_SV`, `ID_CB`, `USERNAME`, `PASSWORD`, `STATUS`, `ROLE`) VALUES
(1, NULL, 1, '1122', '3b712de48137572f3849aabd5666a4e3', 1, '1'),
(2, NULL, 2, '2211', '3323fe11e9595c09af38fe67567a9394', 1, '1'),
(3, NULL, 3, '1133', 'fd06b8ea02fe5b1c2496fe1700e9d16c', 1, '1'),
(4, NULL, 4, '1234', '81dc9bdb52d04dc20036dbd8313ed055', 1, '1'),
(5, NULL, 5, '1204', 'fb2fcd534b0ff3bbed73cc51df620323', 1, '1'),
(6, NULL, 6, '0029 ', '0e0b24fc303d2b384be5a2464654a5d2', 1, '1,2'),
(7, NULL, 7, '0430 ', '1b8ecc49a1e5dba91d313dd3a41aaff2', 1, '4'),
(8, NULL, 8, '0434', 'c6a135d746c5a896b4c8ac6bc502fa00', 1, '3'),
(9, 1, NULL, '1101682', '75e8f21f426828d2d89be9681b8f829c', 1, '0'),
(10, 2, NULL, '1101681', 'c6f1f2d1949e8364912f696d022effd6', 1, '0'),
(11, 3, NULL, '1101683', '195b2aa681cab13e2f11d5013a38fb8d', 1, '0'),
(12, 4, NULL, '1101684', '15b8d3758222799bf5bffcc134ef0545', 1, '0'),
(13, 5, NULL, '1101685', '492bb4b335805c9b3711e5ae2920076d', 1, '0'),
(14, 6, NULL, '1101686', 'afb07382dd0aa7a28159b611e57dc70a', 1, '0'),
(15, 7, NULL, '1101687', '79c35dd2cc3f8992583deb7da9defaef', 1, '0'),
(16, 8, NULL, '1101688', '24d92fd2d8aa3fb0c2e43692d4b3e069', 1, '0'),
(17, 9, NULL, '1101689', '8f564ecc49eeaa7c9e47341ef1bbdd32', 1, '0'),
(18, 10, NULL, '1111500', 'e961ec8b542e3f486e5749fdad36b32d', 1, '0'),
(19, 11, NULL, '1111501', '84a449b7b6f11c7ecc111bc87b5aa7a3', 1, '0'),
(20, 12, NULL, '1111502', '108c30723b81d8c1de5ba0ad6da680b1', 1, '0');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `cb`
--
ALTER TABLE `cb`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `MSCB` (`MSCB`), ADD KEY `FK_CB_OF_KHOA` (`ID_KHOA`);

--
-- Indexes for table `cn`
--
ALTER TABLE `cn`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `CHUYEN_NGANH` (`CHUYEN_NGANH`);

--
-- Indexes for table `ct_hp`
--
ALTER TABLE `ct_hp`
  ADD PRIMARY KEY (`ID_SV`,`ID_HP`), ADD KEY `FK_CT_OF_HP` (`ID_HP`);

--
-- Indexes for table `hk_nh`
--
ALTER TABLE `hk_nh`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `hp`
--
ALTER TABLE `hp`
  ADD PRIMARY KEY (`ID`), ADD KEY `FK_GV_DAY_HP` (`ID_GV`), ADD KEY `FK_HP_IN_HKNH` (`ID_HK_NH`), ADD KEY `FK_HP_OF_MH` (`ID_MH`);

--
-- Indexes for table `kh`
--
ALTER TABLE `kh`
  ADD PRIMARY KEY (`ID`), ADD KEY `FK_KH_IN_HK_NH` (`ID_HK_NH`);

--
-- Indexes for table `khoa`
--
ALTER TABLE `khoa`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `KHOA` (`KHOA`);

--
-- Indexes for table `lop`
--
ALTER TABLE `lop`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `LOP` (`LOP`), ADD KEY `CB_CV_LOP` (`ID_CB`);

--
-- Indexes for table `mh`
--
ALTER TABLE `mh`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `MA_MH` (`MA_MH`);

--
-- Indexes for table `sv`
--
ALTER TABLE `sv`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `MSSV` (`MSSV`), ADD KEY `FK_SV_IN_CN` (`ID_CN`), ADD KEY `FK_SV_IN_LOP` (`ID_LOP`), ADD KEY `FK_SV_OF_KHOA` (`ID_KHOA`);

--
-- Indexes for table `thang_diem`
--
ALTER TABLE `thang_diem`
  ADD PRIMARY KEY (`ID`);

--
-- Indexes for table `tk`
--
ALTER TABLE `tk`
  ADD PRIMARY KEY (`ID`), ADD UNIQUE KEY `USERNAME` (`USERNAME`), ADD KEY `FK_CB_HAS_TK` (`ID_CB`), ADD KEY `FK_SV_HAS_TK` (`ID_SV`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `cb`
--
ALTER TABLE `cb`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `cn`
--
ALTER TABLE `cn`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `hk_nh`
--
ALTER TABLE `hk_nh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `hp`
--
ALTER TABLE `hp`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=81;
--
-- AUTO_INCREMENT for table `kh`
--
ALTER TABLE `kh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `khoa`
--
ALTER TABLE `khoa`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `lop`
--
ALTER TABLE `lop`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `mh`
--
ALTER TABLE `mh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `sv`
--
ALTER TABLE `sv`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT for table `thang_diem`
--
ALTER TABLE `thang_diem`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tk`
--
ALTER TABLE `tk`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
--
-- Constraints for dumped tables
--

--
-- Constraints for table `cb`
--
ALTER TABLE `cb`
ADD CONSTRAINT `FK_CB_OF_KHOA` FOREIGN KEY (`ID_KHOA`) REFERENCES `khoa` (`ID`);

--
-- Constraints for table `ct_hp`
--
ALTER TABLE `ct_hp`
ADD CONSTRAINT `FK_CT_OF_HP` FOREIGN KEY (`ID_HP`) REFERENCES `hp` (`ID`),
ADD CONSTRAINT `FK_SV_OF_HP` FOREIGN KEY (`ID_SV`) REFERENCES `sv` (`ID`);

--
-- Constraints for table `hp`
--
ALTER TABLE `hp`
ADD CONSTRAINT `FK_GV_DAY_HP` FOREIGN KEY (`ID_GV`) REFERENCES `cb` (`ID`),
ADD CONSTRAINT `FK_HP_IN_HKNH` FOREIGN KEY (`ID_HK_NH`) REFERENCES `hk_nh` (`ID`),
ADD CONSTRAINT `FK_HP_OF_MH` FOREIGN KEY (`ID_MH`) REFERENCES `mh` (`ID`);

--
-- Constraints for table `kh`
--
ALTER TABLE `kh`
ADD CONSTRAINT `FK_KH_IN_HK_NH` FOREIGN KEY (`ID_HK_NH`) REFERENCES `hk_nh` (`ID`);

--
-- Constraints for table `lop`
--
ALTER TABLE `lop`
ADD CONSTRAINT `CB_CV_LOP` FOREIGN KEY (`ID_CB`) REFERENCES `cb` (`ID`);

--
-- Constraints for table `sv`
--
ALTER TABLE `sv`
ADD CONSTRAINT `FK_SV_IN_CN` FOREIGN KEY (`ID_CN`) REFERENCES `cn` (`ID`),
ADD CONSTRAINT `FK_SV_IN_LOP` FOREIGN KEY (`ID_LOP`) REFERENCES `lop` (`ID`),
ADD CONSTRAINT `FK_SV_OF_KHOA` FOREIGN KEY (`ID_KHOA`) REFERENCES `khoa` (`ID`);

--
-- Constraints for table `tk`
--
ALTER TABLE `tk`
ADD CONSTRAINT `FK_CB_HAS_TK` FOREIGN KEY (`ID_CB`) REFERENCES `cb` (`ID`),
ADD CONSTRAINT `FK_SV_HAS_TK` FOREIGN KEY (`ID_SV`) REFERENCES `sv` (`ID`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
