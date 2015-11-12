-- phpMyAdmin SQL Dump
-- version 4.3.11
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Nov 12, 2015 at 07:25 AM
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
	SELECT cb.MSCB as 1_MSCB, cb.HO_TEN as 2_HO_TEN, 
				cb.GIOI_TINH as 3_GIOI_TINH, DATE_FORMAT(cb.NGAY_SINH,'%d/%m/%Y') as 4_NGAY_SINH,
				cb.PHONG_BAN as 5_PHONG_BAN, khoa.KHOA as 6_KHOA, 
				cb.ID as 7_ID 
	FROM qldiem.cb 
		INNER JOIN qldiem.khoa ON khoa.ID = cb.ID_KHOA
	WHERE cb.ID = `id_cb`;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_cvht_lop_cv`(IN `id_gv` int)
BEGIN
	SELECT
		lop.ID AS ID_LOP,
		lop.LOP,
		lop.TEN_LOP
	FROM
		lop
	WHERE
		lop.ID_CB = `id_gv` 
	ORDER BY
		lop.LOP ASC,
		lop.TEN_LOP ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_cvht_lop_cv_ds_sv`(IN `id_lop` int)
BEGIN
	SELECT
		sv.ID AS ID_SV,
		sv.MSSV,
		sv.HO_TEN,
		sv.GIOI_TINH,
		sv.NGAY_SINH,
		khoa.KHOA,
		cn.CHUYEN_NGANH
	FROM
		sv
		INNER JOIN khoa ON khoa.ID = sv.ID_KHOA
		INNER JOIN cn ON cn.ID = sv.ID_CN
	WHERE
		sv.ID_LOP = `id_lop` 
	ORDER BY
		sv.MSSV ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_gv_day_hp`(IN `nk` char(9),IN `hk` tinyint(4),IN `id_gv` int)
BEGIN
	SELECT
		hp.ID_MH,
		hp.ID as ID_HP,
		mh.MA_MH,
		hp.MA_HP,
		mh.TEN_MH,
		mh.SO_TC,
		hp.LT,
		hp.TH
	FROM
		hp
		INNER JOIN mh ON mh.ID = hp.ID_MH
		INNER JOIN hk_nh ON hk_nh.ID = hp.ID_HK_NH
	WHERE
		hp.ID_GV = `id_gv`  AND
		hk_nh.NK = `nk` AND
		hk_nh.HK = `hk`
	ORDER BY
		mh.MA_MH ASC,
		hp.MA_HP ASC;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_gv_day_hp_ds_sv`(IN `id_hp` int)
BEGIN
	SELECT
		sv.MSSV,
		sv.HO_TEN,
		ct_hp.ID_SV,
		ct_hp.DIEM_CHU,
		ct_hp.DIEM_10,
		ct_hp.DIEM_4,
		ct_hp.CAI_THIEN
	FROM
		sv
		INNER JOIN ct_hp ON sv.ID = ct_hp.ID_SV
	WHERE
		ct_hp.ID_HP = `id_hp` AND
		(ct_hp.DIEM_CHU <> "M" AND ct_hp.DIEM_CHU <> "I" AND ct_hp.DIEM_CHU <> "W")
	ORDER BY
		sv.MSSV ASC,
		sv.HO_TEN ASC;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `get_tt_kh_nhap_diem`()
BEGIN
	SELECT
		hk_nh.HK,
		hk_nh.NK,
		kh.LOAI,
		kh.BD,
		kh.KT
	FROM kh
			INNER JOIN hk_nh ON hk_nh.ID = kh.ID_HK_NH
	WHERE
		kh.LOAI = 1
	ORDER BY
		hk_nh.BD desc,
		hk_nh.KT desc,
		hk_nh.NK desc,
		hk_nh.HK desc
	LIMIT 0, 1;
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

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_gv_diem_hp`(IN `id_hp` int, IN `id_sv` int, IN `diem_10` float, IN `diem_chu` varchar(20), IN `diem_4` float, IN `cai_thien` tinyint)
BEGIN
	DECLARE idmh int;
	DECLARE id_hp_tl_cn int;

  SELECT hp.ID_MH into idmh FROM hp WHERE hp.ID = `id_hp`;
	UPDATE ct_hp SET DIEM_10 = `diem_10`,DIEM_CHU = `diem_chu`,DIEM_4 = `diem_4` WHERE ct_hp.ID_HP = `id_hp` AND ct_hp.ID_SV = `id_sv`;
	IF `cai_thien` = 1 AND `diem_chu` = "F" THEN
		UPDATE ct_hp SET TL = 0 WHERE ct_hp.ID_HP in (SELECT hp.ID
																						FROM
																						hp
																						WHERE
																						hp.ID_MH = idmh) AND
																						ct_hp.ID_SV = `id_sv`;
	ELSEIF `cai_thien` = 1 AND `DIEM_CHU` <> "F" THEN
		UPDATE ct_hp SET ct_hp.TL = 0 WHERE ct_hp.ID_HP in (SELECT hp.ID
																								FROM
																								hp
																								WHERE
																								hp.ID_MH = `idmh`) AND
																								ct_hp.ID_SV = `id_sv`;
		SELECT hp.ID INTO `id_hp_tl_cn` FROM hp 
					INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP 
		WHERE hp.ID_MH = idmh 
					AND ct_hp.ID_SV = `id_sv` 
					AND ct_hp.CAI_THIEN <> 0 
					AND ct_hp.DIEM_4 = (SELECT max(ct_hp.DIEM_4) AS DIEM_LON_NHAT FROM hp 
																	INNER JOIN ct_hp ON hp.ID = ct_hp.ID_HP
																WHERE hp.ID_MH = idmh 
																		AND ct_hp.ID_SV = `id_sv`  
																		AND ct_hp.CAI_THIEN <> 0);
		UPDATE ct_hp SET ct_hp.TL = 1 WHERE ct_hp.ID_HP = `id_hp_tl_cn` AND ct_hp.ID_SV = `id_sv`;
	ELSE
		IF `diem_chu` <> "F" THEN
			UPDATE ct_hp SET TL = 1 WHERE ct_hp.ID_HP = `id_hp` AND ct_hp.ID_SV = `id_sv`;
		ELSE
			UPDATE ct_hp SET TL = 0 WHERE ct_hp.ID_HP = `id_hp` AND ct_hp.ID_SV = `id_sv`;
		END IF;
	END IF;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `update_qldvn_diem_hp`(IN `id_hp` int, IN `mssv` varchar(8), IN `diem_10` float, IN `diem_chu` varchar(20), IN `diem_4` float)
BEGIN
		DECLARE id_sv int default NULL;
		SELECT sv.ID into id_sv FROM sv WHERE sv.MSSV = `mssv`;

		IF `diem_chu` = "I" AND `id_sv` IS NOT NULL THEN
				UPDATE ct_hp SET DIEM_10 = `diem_10`,DIEM_CHU = `diem_chu`,DIEM_4 = `diem_4`, TL = 0 WHERE ct_hp.ID_HP = `id_hp` AND ct_hp.ID_SV = `id_sv`;
		ELSEIF `diem_chu` = "M" AND `id_sv` IS NOT NULL THEN
				UPDATE ct_hp SET DIEM_10 = `diem_10`,DIEM_CHU = `diem_chu`,DIEM_4 = `diem_4`, TL = 1 WHERE ct_hp.ID_HP = `id_hp` AND ct_hp.ID_SV = `id_sv`;
		END IF;
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
(6, 1, '0029', 'Trần Việt Dũng', 1, '1987-01-08', 'Quản lý ngành'),
(7, NULL, '0430 ', 'Vũ Thanh Nguyên ', 0, '1997-09-18', 'Admin'),
(8, NULL, '0434', 'Trần Đình Thi ', 0, '1976-11-09', 'Phòng Đào Tạo');

-- --------------------------------------------------------

--
-- Table structure for table `cn`
--

CREATE TABLE IF NOT EXISTS `cn` (
  `ID` int(10) unsigned NOT NULL,
  `CHUYEN_NGANH` varchar(100) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `cn`
--

INSERT INTO `cn` (`ID`, `CHUYEN_NGANH`) VALUES
(2, 'Công nghệ phần mềm'),
(1, 'Hệ thống thông tin ');

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
(1, 26, 'F', 0, 0, 0, 0),
(1, 36, 'D+', 5.3, 1.5, 0, 0),
(1, 39, 'D', 4, 1, 0, 1),
(1, 46, 'C', 6, 2, 1, 1),
(1, 48, 'A', 9.8, 4, 0, 1),
(1, 49, 'B+', 8.7, 3.5, 0, 1),
(1, 51, 'A', 9.3, 4, 0, 1),
(1, 54, 'B+', 8, 3.5, 1, 1),
(1, 55, 'B', 7.5, 3, 0, 1),
(1, 68, 'I', 11, 5, 0, 0),
(1, 70, '', NULL, NULL, 1, 0),
(1, 72, 'I', 11, 5, 1, 0),
(1, 73, 'F', 0, 0, 0, 0),
(1, 75, '', NULL, NULL, 0, 0),
(1, 78, '', NULL, NULL, 1, 0),
(1, 79, '', NULL, NULL, 1, 0),
(2, 1, 'C+', 6.6, 2.5, 0, 1),
(2, 3, 'F', 0.6, 0, 0, 0),
(2, 10, 'C', 6, 2, 0, 0),
(2, 14, 'C+', 6.6, 2.5, 0, 0),
(2, 17, 'D+', 5.1, 1.5, 0, 1),
(2, 19, 'A', 9.8, 4, 0, 1),
(2, 22, 'B+', 8.1, 3.5, 0, 1),
(2, 30, 'B', 7.3, 3, 0, 1),
(2, 32, 'C', 6, 2, 0, 1),
(2, 36, 'B', 7.3, 3, 0, 0),
(2, 38, 'C+', 6.6, 2.5, 1, 1),
(2, 45, 'B', 7.1, 3, 1, 1),
(2, 48, 'F', 3, 0, 0, 0),
(2, 49, 'B', 7.9, 3, 0, 1),
(2, 54, 'A', 9, 4, 0, 1),
(2, 55, 'B+', 8.3, 3.5, 1, 1),
(2, 73, '\r\n', NULL, NULL, 1, 0),
(2, 75, '\r\n', NULL, NULL, 0, 0),
(2, 78, '\r\n', NULL, NULL, 1, 0),
(3, 2, 'B', 7.6, 3, 0, 1),
(3, 3, 'B', 7.6, 3, 0, 1),
(3, 7, 'B+', 8.4, 3.5, 0, 1),
(3, 15, 'C', 6.1, 2, 0, 1),
(3, 18, 'F', 3.1, 0, 0, 0),
(3, 20, 'B', 7.6, 3, 0, 1),
(3, 24, 'D', 4.1, 1, 0, 1),
(3, 26, 'D', 4.9, 1, 0, 1),
(3, 28, 'D+', 5.1, 1.5, 0, 1),
(3, 29, 'D', 4, 1, 0, 1),
(3, 35, 'C+', 6.3, 2.5, 0, 0),
(3, 37, 'B+', 8.6, 3.5, 0, 1),
(3, 45, 'B', 7.6, 3, 1, 1),
(3, 55, 'B+', 8.7, 3.5, 0, 1),
(3, 58, 'F', 0, 0, 0, 1),
(3, 60, 'C+', 6.5, 2.5, 0, 1),
(3, 68, 'W', 11, 5, 1, 0),
(3, 70, '', NULL, NULL, 0, 0),
(3, 72, 'W', 11, 5, 1, 0),
(3, 74, '', NULL, NULL, 1, 0),
(3, 75, '', NULL, NULL, 1, 0),
(3, 78, '', NULL, NULL, 1, 0),
(3, 79, '', NULL, NULL, 1, 0),
(4, 5, 'C+', 6.7, 2.5, 0, 0),
(4, 7, 'B', 7.5, 3, 0, 1),
(4, 10, 'C+', 6.7, 2.5, 0, 1),
(4, 11, 'A', 9.3, 4, 0, 1),
(4, 14, 'C', 5.7, 2, 0, 0),
(4, 15, 'B+', 8, 3.5, 0, 1),
(4, 18, 'D', 4.1, 1, 0, 1),
(4, 21, 'C+', 6.7, 2.5, 0, 1),
(4, 24, 'B', 7.9, 3, 0, 1),
(4, 26, 'D+', 5.2, 1.5, 0, 0),
(4, 27, 'B', 7, 3, 0, 1),
(4, 30, 'C', 5.6, 2, 0, 1),
(4, 31, 'B+', 8, 3.5, 0, 1),
(4, 35, 'C', 5.7, 2, 1, 1),
(4, 39, 'C+', 6.9, 2.5, 0, 1),
(4, 41, 'D+', 5.3, 1.5, 0, 1),
(4, 48, 'A', 10, 4, 1, 1),
(4, 54, 'A', 9.5, 4, 1, 1),
(4, 55, 'B', 7.2, 3, 1, 1),
(4, 59, 'F', 0, 0, 1, 0),
(4, 70, '', NULL, NULL, 1, 0),
(4, 72, '', NULL, NULL, 1, 0),
(4, 74, '', NULL, NULL, 1, 0),
(4, 75, '', NULL, NULL, 1, 0),
(4, 78, '', NULL, NULL, 1, 0);

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
(1, '2014-2015', 1, '2014-08-01', '2014-12-31'),
(2, '2014-2015', 2, '2015-01-01', '2015-06-01'),
(3, '2014-2015', 3, '2015-06-01', '2015-07-01'),
(4, '2015-2016', 1, '2015-08-01', '2015-12-31');

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
) ENGINE=InnoDB AUTO_INCREMENT=80 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `hp`
--

INSERT INTO `hp` (`ID`, `ID_MH`, `ID_HK_NH`, `ID_GV`, `MA_HP`, `LT`, `TH`) VALUES
(1, 15, 1, 6, 'TH00101', 15, 15),
(2, 15, 1, 2, 'TH00102', 15, 15),
(3, 14, 1, 2, 'TH00201', 0, 30),
(4, 14, 1, 3, 'TH00201', 0, 30),
(5, 1, 1, 4, 'CT10001', 15, 30),
(6, 1, 1, 4, 'CT10002', 15, 30),
(7, 2, 1, 2, 'CT10101', 15, 30),
(10, 3, 1, 2, 'CT12302', 15, 15),
(11, 4, 1, 5, 'CT10601', 15, 45),
(14, 5, 1, 4, 'CT10701', 15, 30),
(15, 6, 1, 6, 'CT10901', 15, 30),
(17, 7, 1, 4, 'CT11301', 15, 30),
(18, 7, 1, 2, 'CT11302', 15, 30),
(19, 8, 1, 3, 'CT11801', 15, 15),
(20, 8, 1, 6, 'CT11802', 15, 15),
(21, 9, 2, 6, 'CT12501', 15, 15),
(22, 9, 2, 3, 'CT12502', 15, 15),
(24, 10, 2, 2, 'CT12702', 15, 30),
(26, 11, 2, 2, 'CT11602', 15, 30),
(27, 12, 2, 5, 'CT30401', 15, 15),
(28, 12, 2, 4, 'CT30402', 15, 15),
(29, 13, 2, 4, 'CT31701', 15, 15),
(30, 13, 2, 3, 'CT31702', 15, 15),
(31, 14, 2, 2, 'TH00201', 0, 30),
(32, 14, 2, 3, 'TH00202', 0, 30),
(35, 1, 2, 4, 'CT10001', 15, 30),
(36, 1, 2, 5, 'CT10002', 15, 30),
(37, 3, 2, 3, 'CT12301', 15, 45),
(38, 3, 2, 6, 'CT12302', 15, 45),
(39, 8, 2, 6, 'CT11801', 15, 15),
(41, 15, 3, 6, 'TH00101', 15, 15),
(45, 1, 3, 6, 'CT10001', 15, 30),
(46, 1, 3, 4, 'CT10002', 15, 30),
(48, 2, 3, 3, 'CT10102', 15, 30),
(49, 12, 3, 6, 'CT30401', 15, 15),
(51, 6, 3, 2, 'CT10901', 15, 30),
(54, 11, 3, 5, 'CT11602', 15, 30),
(55, 5, 3, 2, 'CT10701', 15, 30),
(58, 9, 3, 3, 'CT12502', 15, 15),
(59, 4, 3, 5, 'CT10701', 15, 30),
(60, 4, 3, 2, 'CT10702', 15, 30),
(68, 4, 4, 3, 'CT10602', 15, 45),
(70, 7, 4, 3, 'CT11302', 15, 30),
(72, 5, 4, 4, 'CT10702', 15, 30),
(73, 13, 4, 2, 'CT31701', 15, 15),
(74, 13, 4, 6, 'CT31702', 15, 15),
(75, 10, 4, 3, 'CT12701', 15, 30),
(78, 12, 4, 6, 'CT30402', 15, 15),
(79, 11, 4, 6, 'CT11601', 15, 30);

-- --------------------------------------------------------

--
-- Table structure for table `kh`
--

CREATE TABLE IF NOT EXISTS `kh` (
  `ID` int(10) unsigned NOT NULL,
  `ID_HK_NH` int(10) unsigned NOT NULL,
  `MO_TA` text COLLATE utf8_bin NOT NULL,
  `BD` date NOT NULL,
  `KT` date NOT NULL,
  `LOAI` tinyint(4) NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=9 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `kh`
--

INSERT INTO `kh` (`ID`, `ID_HK_NH`, `MO_TA`, `BD`, `KT`, `LOAI`) VALUES
(1, 1, 'Nhập điểm học kỳ 1', '2014-12-15', '2014-12-22', 1),
(2, 1, 'Lập báo cáo thống kê học kỳ 1', '2014-12-22', '2014-12-29', 2),
(3, 2, 'Nhập điểm học kỳ 2', '2015-05-15', '2015-05-22', 1),
(4, 2, 'Lập báo cáo thống kê học kỳ 2', '2015-05-22', '2015-05-29', 2),
(5, 3, 'Nhập điểm học kỳ hè', '2015-06-15', '2015-06-22', 1),
(6, 3, 'Lập báo cáo thống kê học kỳ hè', '2015-06-22', '2015-06-29', 2),
(7, 4, 'Nhập điểm học kỳ 1', '2015-12-15', '2015-12-22', 1),
(8, 4, 'Lập báo cáo thống kê học kỳ 1', '2015-12-22', '2015-12-29', 2);

-- --------------------------------------------------------

--
-- Table structure for table `khoa`
--

CREATE TABLE IF NOT EXISTS `khoa` (
  `ID` int(10) unsigned NOT NULL,
  `KHOA` varchar(150) COLLATE utf8_bin NOT NULL
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

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
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `lop`
--

INSERT INTO `lop` (`ID`, `ID_CB`, `LOP`, `TEN_LOP`) VALUES
(1, 2, 'DI1094A1', 'Hệ thống thông tin K39'),
(2, 3, 'DI1095A1', 'Công nghệ phần mềm K39');

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
(14, 'TH002', 'TT.  Tin học căn bản', 2, b'1'),
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
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `sv`
--

INSERT INTO `sv` (`ID`, `ID_LOP`, `ID_KHOA`, `ID_CN`, `MSSV`, `HO_TEN`, `GIOI_TINH`, `NGAY_SINH`) VALUES
(1, 1, 1, 1, '1101682', 'Ngô Giang Thanh', 0, '1992-08-25'),
(2, 1, 1, 1, '1101681', 'Lê Hoài Thanh', 0, '1992-01-02'),
(3, 2, 1, 2, '1101683', 'Phạm Hoài Thanh', 1, '1991-04-12'),
(4, 2, 1, 2, '1101684', 'Nguyễn Văn A', 0, '1993-12-31');

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
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

--
-- Dumping data for table `tk`
--

INSERT INTO `tk` (`ID`, `ID_SV`, `ID_CB`, `USERNAME`, `PASSWORD`, `STATUS`, `ROLE`) VALUES
(1, NULL, 1, '1122', '3b712de48137572f3849aabd5666a4e3', 1, '1'),
(2, NULL, 2, '2211', '3323fe11e9595c09af38fe67567a9394', 1, '1'),
(3, NULL, 3, '1133', 'fd06b8ea02fe5b1c2496fe1700e9d16c', 1, '1'),
(4, NULL, 4, '1234', '81dc9bdb52d04dc20036dbd8313ed055', 1, '1'),
(5, NULL, 5, '1204', 'fb2fcd534b0ff3bbed73cc51df620323', 1, '1'),
(6, NULL, 6, '0029 ', '0e0b24fc303d2b384be5a2464654a5d2', 1, '0,1,2,3,4'),
(7, NULL, 7, '0430 ', '1b8ecc49a1e5dba91d313dd3a41aaff2', 1, '4'),
(8, NULL, 8, '0434', 'c6a135d746c5a896b4c8ac6bc502fa00', 1, '3'),
(9, 1, NULL, '1101682', '75e8f21f426828d2d89be9681b8f829c', 1, '0'),
(10, 2, NULL, '1101681', 'c6f1f2d1949e8364912f696d022effd6', 1, '0'),
(11, 3, NULL, '1101683', '195b2aa681cab13e2f11d5013a38fb8d', 1, '0'),
(12, 4, NULL, '1101684', '15b8d3758222799bf5bffcc134ef0545', 1, '0');

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
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `hk_nh`
--
ALTER TABLE `hk_nh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `hp`
--
ALTER TABLE `hp`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=80;
--
-- AUTO_INCREMENT for table `kh`
--
ALTER TABLE `kh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=9;
--
-- AUTO_INCREMENT for table `khoa`
--
ALTER TABLE `khoa`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=2;
--
-- AUTO_INCREMENT for table `lop`
--
ALTER TABLE `lop`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `mh`
--
ALTER TABLE `mh`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=16;
--
-- AUTO_INCREMENT for table `sv`
--
ALTER TABLE `sv`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT for table `thang_diem`
--
ALTER TABLE `thang_diem`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=3;
--
-- AUTO_INCREMENT for table `tk`
--
ALTER TABLE `tk`
  MODIFY `ID` int(10) unsigned NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
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
ADD CONSTRAINT `ct_hp_ibfk_1` FOREIGN KEY (`ID_HP`) REFERENCES `hp` (`ID`),
ADD CONSTRAINT `ct_hp_ibfk_2` FOREIGN KEY (`ID_SV`) REFERENCES `sv` (`ID`);

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
