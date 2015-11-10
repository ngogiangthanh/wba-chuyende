-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 10, 2015 at 07:18 PM
-- Server version: 5.6.24
-- PHP Version: 5.6.8

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `qldiem`
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
		hk_nh.HK asc;
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
				SUM(SO_TC) AS SO_TC
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
				SUM(SO_TC) AS SO_TC
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
				SO_TC,
				mh.SO_TC * ct_hp.DIEM_4 AS TICH_DIEM
			FROM
				hp
				INNER JOIN mh ON mh.ID = hp.ID_MH
				INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
				INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
			WHERE
				 ct_hp.ID_SV = `id_sv` AND
				 ct_hp.TL = 1 AND
				 ct_hp.DIEM_10 <= 10 AND
				 STRCMP(hk_nh.NK, `nk`) = -1
		) UNION (
		SELECT
				SO_TC,
				mh.SO_TC * ct_hp.DIEM_4 AS TICH_DIEM
			FROM
				hp
				INNER JOIN mh ON mh.ID = hp.ID_MH
				INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
				INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
			WHERE
				 ct_hp.ID_SV = `id_sv` AND
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
) ENGINE=InnoDB AUTO_INCREMENT=16 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `cb`
--

INSERT INTO `cb` (`ID`, `ID_KHOA`, `MSCB`, `HO_TEN`, `GIOI_TINH`, `NGAY_SINH`, `PHONG_BAN`) VALUES
(1, 1, '1122', 'Hồ Quang Thái', 0, '1986-11-22', NULL),
(2, 1, '2211', 'Trần Thức Tỉnh', 0, '1986-12-31', NULL),
(3, 1, '1133', 'Tô Châu', 1, '1967-11-16', NULL),
(4, NULL, '1234', 'Văn C', 0, '1956-01-02', 'Phòng Đào tạo'),
(5, 2, '1204', 'Trần Việt Dũng', 0, '1980-11-01', NULL),
(6, 1, '0029 ', 'Trần Ngọc Khánh', 1, '1987-01-08', NULL),
(7, 1, '0430 ', 'Vũ Thanh Nguyên ', 0, '1997-09-18', NULL),
(8, NULL, '0434', 'Trần Đình Thi ', 0, '1976-11-09', 'Phòng Đào Tạo'),
(9, 1, '0112', 'Nguyễn Thị Hoa', 1, '1981-10-09', NULL),
(10, 2, '0132 ', 'Nguyễn Phi Hùng ', 0, '1978-09-19', NULL),
(11, 2, '0356 ', 'Lê ngọc Thạch', 0, '1967-08-21', NULL),
(12, 3, '0412', 'Nguyễn Hoàng Lan ', 1, '1989-02-10', NULL),
(13, 1, '0968', 'Trần Mỹ Hạnh', 1, '1986-07-11', 'Phòng Đào Tạo'),
(14, 1, '0208', 'Nguyễn Thị Ngọc Hiền', 1, '1968-03-19', NULL),
(15, 1, '0422', 'Lê Thị Mỹ Linh', 1, '1965-06-18', NULL);

-- --------------------------------------------------------

--
-- Table structure for table `cn`
--

CREATE TABLE IF NOT EXISTS `cn` (
  `ID` int(10) unsigned NOT NULL,
  `CHUYEN_NGANH` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `cn`
--

INSERT INTO `cn` (`ID`, `CHUYEN_NGANH`) VALUES
(2, 'Công nghệ phần mềm'),
(4, 'Công nghệ thông tin'),
(1, 'Hệ thống thông tin'),
(3, 'Khoa Học Máy Tính'),
(5, 'Mạng máy tính');

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
(1, 1, 'B+', 8, 3.5, 1, 1),
(1, 3, 'F', 3, 0, 0, 0),
(1, 4, 'B', 7.8, 3, 0, 1),
(1, 5, 'B', 7.6, 3, 0, 1),
(1, 6, 'D', 4, 1, 0, 1),
(1, 7, 'A', 9, 4, 0, 1),
(1, 8, 'F', 3.5, 0, 0, 0),
(1, 9, 'M', 11, 5, 0, 1),
(1, 10, 'B+', 8.7, 3.5, 1, 1),
(3, 2, 'F', 3, 0, 0, 0),
(8, 1, 'D', 4.1, 1, 0, 1),
(8, 6, 'C', 5, 2, 1, 1),
(8, 7, NULL, NULL, NULL, 0, 1),
(8, 9, NULL, NULL, NULL, 0, 1),
(8, 10, 'D+', 4.7, 1.5, 0, 1),
(9, 4, 'B+', 8.6, 3.5, 0, 1),
(11, 6, NULL, NULL, NULL, 0, 1),
(16, 1, 'C', 5.4, 2, 0, 1),
(16, 3, 'A', 9.6, 4, 0, 1),
(17, 4, 'B', 7.2, 3, 0, 1),
(17, 5, 'F', 3.4, 0, 0, 1),
(17, 6, 'C+', 5.6, 2.5, 0, 1);

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `hk_nh`
--

INSERT INTO `hk_nh` (`ID`, `NK`, `HK`, `BD`, `KT`) VALUES
(1, '2014-2015', 3, '2015-05-01', '2015-06-01'),
(2, '2015-2016', 1, '2015-08-01', '2015-12-30'),
(3, '2014-2015', 2, '2015-01-15', '2015-05-15'),
(4, '2014-2015', 1, '2014-08-05', '2014-12-05'),
(5, '2015-2016', 2, '2016-01-15', '2016-05-15');

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
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `hp`
--

INSERT INTO `hp` (`ID`, `ID_MH`, `ID_HK_NH`, `ID_GV`, `MA_HP`, `LT`, `TH`) VALUES
(1, 1, 1, 3, '0', 15, 30),
(2, 1, 1, 7, '0', 15, 30),
(3, 2, 2, 5, '0', 15, 15),
(4, 2, 1, 11, '0', 15, 15),
(5, 3, 3, 6, '0', 15, 15),
(6, 8, 5, 14, '0', 30, 0),
(7, 12, 3, 14, '0', 15, 15),
(8, 13, 4, 3, '0', 15, 15),
(9, 10, 4, 5, '0', 15, 30),
(10, 13, 2, 7, '0', 15, 15);

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
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `kh`
--

INSERT INTO `kh` (`ID`, `ID_HK_NH`, `MO_TA`, `BD`, `KT`) VALUES
(1, 1, 'Nhập điểm học kỳ hè', '2015-05-24', '2014-06-01'),
(2, 2, 'Nhập điểm học kỳ 1', '2015-12-15', '2015-12-22'),
(3, 3, 'Nhập điểm học kỳ 2', '2015-05-01', '2015-05-07'),
(4, 2, 'Lập báo cáo thống kê', '2015-12-22', '2015-12-30'),
(5, 5, 'Lập báo cáo thống kê', '2016-05-01', '2016-05-08');

-- --------------------------------------------------------

--
-- Table structure for table `khoa`
--

CREATE TABLE IF NOT EXISTS `khoa` (
  `ID` int(10) unsigned NOT NULL,
  `KHOA` varchar(150) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `khoa`
--

INSERT INTO `khoa` (`ID`, `KHOA`) VALUES
(1, 'Khoa CNTT & TT'),
(2, 'Khoa NN & PTNN'),
(3, 'Khoa sư phạm');

-- --------------------------------------------------------

--
-- Table structure for table `lop`
--

CREATE TABLE IF NOT EXISTS `lop` (
  `ID` int(10) unsigned NOT NULL,
  `ID_CB` int(10) unsigned DEFAULT NULL,
  `LOP` varchar(8) COLLATE utf8_bin NOT NULL,
  `TEN_LOP` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `lop`
--

INSERT INTO `lop` (`ID`, `ID_CB`, `LOP`, `TEN_LOP`) VALUES
(1, 7, 'DI1096A1', 'CNPM 1'),
(2, NULL, 'DI1096A2', 'CNPM 2'),
(3, NULL, 'DI1095A1', 'HTTT 1'),
(4, 5, 'DI1094A1', 'KHMT 1'),
(5, 12, 'DI1094A2', 'KHMT 2'),
(6, 1, 'DI1093A1', 'MMT 1'),
(7, 14, 'DI1097A1', 'CNTT 1');

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
(12, 'CT128', 'Kỹ thuật đồ họa', 2, b'0'),
(13, 'CT136', 'Xử lý ảnh', 2, b'0'),
(14, 'CT181', 'UML', 2, b'0'),
(15, 'CT304', 'Giao diện người và máy', 2, b'0');

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
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `sv`
--

INSERT INTO `sv` (`ID`, `ID_LOP`, `ID_KHOA`, `ID_CN`, `MSSV`, `HO_TEN`, `GIOI_TINH`, `NGAY_SINH`) VALUES
(1, 1, 1, 1, '1101682', 'Ngô Giang Thanh', 0, '1992-08-25'),
(3, 1, 1, 1, '1101681', 'Lê Hoài Thanh', 0, '1992-01-02'),
(4, 1, 1, 1, '1101683', 'Phạm Hoài Thanh', 1, '1991-04-12'),
(5, 2, 1, 1, '1101684', 'Nguyễn Văn A', 0, '1993-12-31'),
(6, 2, 1, 1, '1101685', 'Nguyễn Văn C', 0, '1994-11-30'),
(7, 2, 1, 1, '1101686', 'Trần Thị An', 1, '1992-01-02'),
(8, 3, 1, 2, '1101687', 'Tâm Đoan', 1, '1992-05-01'),
(9, 3, 1, 2, '1101688', 'Cao Kỳ', 0, '1989-07-11'),
(10, 3, 1, 2, '1101689', 'Văn Thiệu', 0, '1992-06-26'),
(11, 3, 1, 2, '1101700', 'Nguyễn Văn Ngọc\r\n', 0, '1997-03-17'),
(12, 6, 1, 4, '1101701', 'Nguyễn Thị Hương Tuyền\r\n', 1, '1992-03-13'),
(13, 6, 1, 3, '1101702', 'Nguyễn Đình Anh\r\n', 0, '1995-07-16'),
(14, 5, 1, 3, '1101703', 'Phan Thị Hương Giang \r\n', 1, '1996-05-15'),
(15, 2, 1, 5, '1101704', 'Hoàng Thế Nữ \r\n', 0, '1995-04-14'),
(16, 4, 1, 5, '1101705', 'Nguyễn Hồng Nhung\r\n\r\n', 1, '1988-04-01'),
(17, 5, 1, 3, '1101706', 'Đoàn Văn Phương\r\n', 0, '1992-03-19'),
(18, 4, 1, 5, '1101707', 'Hoàng Ngọc Huy\r\n', 0, '1995-09-14'),
(19, 5, 1, 4, '1101708', 'Nguyễn Thị Quyên \r\n', 1, '1996-06-06'),
(20, 1, 1, 2, '1101709', 'Nguyễn Hữu Chí\r\n', 0, '1996-07-08');

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
(1, 1, NULL, '1101682', '75e8f21f426828d2d89be9681b8f829c', 1, '0'),
(2, 3, NULL, '1101681', '195b2aa681cab13e2f11d5013a38fb8d', 0, '0'),
(3, 7, NULL, '1101686', 'afb07382dd0aa7a28159b611e57dc70a', 1, '0'),
(4, 8, NULL, '1101687', '79c35dd2cc3f8992583deb7da9defaef', 1, '0'),
(5, 5, NULL, '1101684', '15b8d3758222799bf5bffcc134ef0545', 1, '0'),
(6, 9, NULL, '1101688', '24d92fd2d8aa3fb0c2e43692d4b3e069', 1, '0'),
(7, 10, NULL, '1101689', '8f564ecc49eeaa7c9e47341ef1bbdd32', 1, '0'),
(8, 11, NULL, '1101700', '43c6b56302034ee2499fa265e73667fe', 1, '0'),
(9, 12, NULL, '1101701', '697e713ea83d2dab473454ab1b5e38b9', 1, '0'),
(10, 13, NULL, '1101702', '5153e2b17d27c488d9a3e5351e865e8a', 1, '1,2'),
(11, NULL, 1, '1122', '3b712de48137572f3849aabd5666a4e3', 1, '1'),
(12, NULL, 2, '2211', '3323fe11e9595c09af38fe67567a9394', 1, '1'),
(13, NULL, 3, '1133', 'fd06b8ea02fe5b1c2496fe1700e9d16c', 1, '1,2'),
(14, NULL, 5, '1204', 'fb2fcd534b0ff3bbed73cc51df620323', 1, '1'),
(15, NULL, 6, '0029', '0e0b24fc303d2b384be5a2464654a5d2', 1, '1'),
(16, NULL, 6, '0430', '1b8ecc49a1e5dba91d313dd3a41aaff2', 1, '1'),
(17, NULL, 8, '0434', 'c6a135d746c5a896b4c8ac6bc502fa00', 1, '1'),
(18, NULL, 9, '0112', '07aeb18febbdbf77511a10fd4aa49942', 1, '1'),
(19, NULL, 10, '0132', 'dad2fd502d209b12ac27f451b0b9c17e', 1, '1'),
(20, NULL, 13, '0968', 'da653eeb79f958560b9af6988b0bcec3', 1, '1,2,3,4');

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
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `cn`
--
ALTER TABLE `cn`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `hk_nh`
--
ALTER TABLE `hk_nh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `hp`
--
ALTER TABLE `hp`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=11;
--
-- AUTO_INCREMENT for table `kh`
--
ALTER TABLE `kh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=6;
--
-- AUTO_INCREMENT for table `khoa`
--
ALTER TABLE `khoa`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=4;
--
-- AUTO_INCREMENT for table `lop`
--
ALTER TABLE `lop`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=8;
--
-- AUTO_INCREMENT for table `mh`
--
ALTER TABLE `mh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `sv`
--
ALTER TABLE `sv`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=21;
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
