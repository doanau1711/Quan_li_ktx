-- phpMyAdmin SQL Dump
-- version 5.2.0
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Mar 07, 2023 at 03:38 PM
-- Server version: 10.4.24-MariaDB
-- PHP Version: 8.0.19

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `quanlyltx`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `DoanhThuTheoNam` (IN `nam` INT)   SELECT hopdong.MAHOPDONG, hopdong.NGAYLAP, hopdong.NGAYBATDAUHD, hopdong.NGAYKETTHUCHD, hopdong.MASV, hopdong.MANV, hopdong.TRANGTHAIHUY, hopdong.SOPHONG, ((DATE_FORMAT(hopdong.NGAYKETTHUCHD, '%m') - DATE_FORMAT(hopdong.NGAYBATDAUHD, '%m')) * p.GIA) as GIA
FROM
(SELECT phong.SOPHONG, loaiphong.GIA
FROM loaiphong inner join phong on loaiphong.MALOAIPHONG = phong.MALOAIPHONG) as p inner join hopdong on p.sophong = hopdong.SOPHONG where DATE_FORMAT(hopdong.NGAYLAP, '%Y') = nam$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `DoanhThuTheoThang` (IN `thang` INT, IN `nam` INT)   SELECT hopdong.MAHOPDONG, hopdong.NGAYLAP, hopdong.NGAYBATDAUHD, hopdong.NGAYKETTHUCHD, hopdong.MASV, hopdong.MANV, hopdong.TRANGTHAIHUY, hopdong.SOPHONG, ((DATE_FORMAT(hopdong.NGAYKETTHUCHD, '%m') - DATE_FORMAT(hopdong.NGAYBATDAUHD, '%m')) * p.GIA) as GIA
FROM
(SELECT phong.SOPHONG, loaiphong.GIA
FROM loaiphong inner join phong on loaiphong.MALOAIPHONG = phong.MALOAIPHONG) as p inner join hopdong on p.sophong = hopdong.SOPHONG where DATE_FORMAT(hopdong.NGAYLAP, '%m') = thang and DATE_FORMAT(hopdong.NGAYLAP, '%Y') = nam$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `HopDongCuaSV` (IN `idsv` VARCHAR(20))   SELECT p.mahopdong, p.ngaylap, p.ngaybatdauhd, p.ngayketthuchd, p.sophong, p.trangthaihuy, nhanvien.hoten as HOTENNV
FROM ( SELECT * FROM hopdong WHERE masv = idsv) as p INNER JOIN nhanvien on p.manv = nhanvien.manv$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SelectUser` (IN `idnv` VARCHAR(20))   SELECT * FROM nhanvien WHERE manv = idnv$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `SVcuaPhong` (IN `idp` VARCHAR(20))   SELECT p.masv, sinhvien.lop, sinhvien.hoten, sinhvien.ngaysinh, sinhvien.gioitinh, sinhvien.cmnd, sinhvien.sdt, sinhvien.sdtnguoithan, sinhvien.mailsv, p.sophong
FROM
(SELECT masv, sophong FROM hopdong where sophong = idp AND trangthaihuy = 'Còn hiệu lực') as p INNER JOIN sinhvien on p.masv = sinhvien.masv$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TongNam` (IN `nam` INT)   SELECT SUM(((DATE_FORMAT(hopdong.NGAYKETTHUCHD, '%m') - DATE_FORMAT(hopdong.NGAYBATDAUHD, '%m')) * p.GIA)) as GIA
FROM
(SELECT phong.SOPHONG, loaiphong.GIA
FROM loaiphong inner join phong on loaiphong.MALOAIPHONG = phong.MALOAIPHONG) as p inner join hopdong on p.sophong = hopdong.SOPHONG where DATE_FORMAT(hopdong.NGAYLAP, '%Y') = nam$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `TongThang` (IN `thang` INT, IN `nam` INT)   SELECT SUM(((DATE_FORMAT(hopdong.NGAYKETTHUCHD, '%m') - DATE_FORMAT(hopdong.NGAYBATDAUHD, '%m')) * p.GIA)) as GIA
FROM
(SELECT phong.SOPHONG, loaiphong.GIA
FROM loaiphong inner join phong on loaiphong.MALOAIPHONG = phong.MALOAIPHONG) as p inner join hopdong on p.sophong = hopdong.SOPHONG where DATE_FORMAT(hopdong.NGAYLAP, '%m') = thang and DATE_FORMAT(hopdong.NGAYLAP, '%Y') = nam$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `giadien`
--

CREATE TABLE `giadien` (
  `GIA` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `giadien`
--

INSERT INTO `giadien` (`GIA`) VALUES
(6000);

-- --------------------------------------------------------

--
-- Table structure for table `hoadondien`
--

CREATE TABLE `hoadondien` (
  `MAHD` varchar(25) NOT NULL,
  `MANV` varchar(20) NOT NULL,
  `SOPHONG` varchar(10) NOT NULL,
  `GIADIEN` bigint(20) NOT NULL,
  `NGAYLAP` date NOT NULL,
  `CHISODIENDAU` int(11) NOT NULL,
  `CHISODIENCUOI` int(11) NOT NULL,
  `TRANGTHAI` varchar(20) DEFAULT NULL
) ;

--
-- Dumping data for table `hoadondien`
--

INSERT INTO `hoadondien` (`MAHD`, `MANV`, `SOPHONG`, `GIADIEN`, `NGAYLAP`, `CHISODIENDAU`, `CHISODIENCUOI`, `TRANGTHAI`) VALUES
('HD2023232136499', 'NV01', 'P041', 6000, '2023-03-03', 20, 200, 'Đã thanh toán'),
('HD202327211435166', 'NV01', 'P041', 6000, '2023-03-07', 100, 300, 'Đã thanh toán');

-- --------------------------------------------------------

--
-- Table structure for table `hopdong`
--

CREATE TABLE `hopdong` (
  `MAHOPDONG` varchar(30) NOT NULL,
  `NGAYLAP` date NOT NULL,
  `NGAYBATDAUHD` date NOT NULL,
  `NGAYKETTHUCHD` date NOT NULL,
  `TRANGTHAIHUY` varchar(20) DEFAULT NULL,
  `SOPHONG` varchar(10) NOT NULL,
  `MASV` varchar(20) NOT NULL,
  `MANV` varchar(20) NOT NULL
) ;

--
-- Dumping data for table `hopdong`
--

INSERT INTO `hopdong` (`MAHOPDONG`, `NGAYLAP`, `NGAYBATDAUHD`, `NGAYKETTHUCHD`, `TRANGTHAIHUY`, `SOPHONG`, `MASV`, `MANV`) VALUES
('HD202327205849508', '2023-03-07', '2023-03-09', '2023-09-09', 'Đã hủy', 'P056', 'N19DCCN007', 'NV01'),
('HD20232721123540', '2023-03-07', '2023-03-08', '2023-09-08', 'Đã hủy', 'P086', 'N19DCCN007', 'NV01'),
('HD202327211550426', '2023-03-07', '2023-03-08', '2023-09-08', 'Còn hiệu lực', 'P056', 'N19DCCN007', 'NV01');

--
-- Triggers `hopdong`
--
DELIMITER $$
CREATE TRIGGER `updateHetHan` BEFORE UPDATE ON `hopdong` FOR EACH ROW UPDATE phong SET SOLUONGCONLAI = (SELECT SOLUONGCONLAI FROM phong WHERE SOPHONG = NEW.SOPHONG) + 1 WHERE SOPHONG = NEW.SOPHONG AND (NEW.TRANGTHAIHUY = 'Đã hết hạn' OR NEW.TRANGTHAIHUY = 'Đã hủy')
$$
DELIMITER ;
DELIMITER $$
CREATE TRIGGER `updateSL` BEFORE INSERT ON `hopdong` FOR EACH ROW UPDATE phong SET SOLUONGCONLAI = (SELECT SOLUONGCONLAI FROM phong WHERE SOPHONG = NEW.SOPHONG) - 1 WHERE SOPHONG = NEW.SOPHONG
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `loaiphong`
--

CREATE TABLE `loaiphong` (
  `MALOAIPHONG` varchar(10) NOT NULL,
  `TENLOAIPHONG` varchar(50) CHARACTER SET utf8 NOT NULL,
  `GIOITINH` varchar(3) DEFAULT NULL,
  `GIA` bigint(20) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `loaiphong`
--

INSERT INTO `loaiphong` (`MALOAIPHONG`, `TENLOAIPHONG`, `GIOITINH`, `GIA`) VALUES
('DV', 'Dịch vụ', 'Nữ', 400000),
('DV-N', 'Dich vụ', 'Nam', 360000),
('DVCLC', 'Dịch vụ chất lượng cao', 'Nữ', 430000),
('DVCLC-N', 'Dịch vụ chất lượng cao', 'Nam', 430000),
('TT', 'Thông thường', 'Nữ', 160000),
('TT-N', 'Thông thường', 'Nam', 160000);

-- --------------------------------------------------------

--
-- Table structure for table `nhanvien`
--

CREATE TABLE `nhanvien` (
  `MANV` varchar(20) NOT NULL,
  `HOTEN` varchar(50) CHARACTER SET utf8 NOT NULL,
  `NGAYSINH` date NOT NULL,
  `DIACHI` varchar(100) CHARACTER SET utf8 NOT NULL,
  `SDT` varchar(20) NOT NULL,
  `MAILNV` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `nhanvien`
--

INSERT INTO `nhanvien` (`MANV`, `HOTEN`, `NGAYSINH`, `DIACHI`, `SDT`, `MAILNV`) VALUES
('NV01', 'Võ Văn A', '2001-11-13', 'HN', '0832131101', 'n19dccn086@student.ptithcm.edu.vn'),
('NV10', 'Nguyễn Minh Khang', '2001-09-22', 'HCM', '0365867273', 'minhkhangg18@gmail.com'),
('NV11', 'Nguyễn Thanh Dũng', '2001-02-22', 'py', '098765421', 'n19dccn086@student.ptithcm.edu.vn'),
('NV14', 'Nguyễn Văn A', '2000-02-22', 'HCM', '09123091', 'khang2209@gmail.com'),
('NV15', 'Trần Thị B', '1999-10-30', 'HCM', '0987676222', 'thib@gmail.com'),
('NV16', 'Hồ Việt Anh', '2001-08-19', 'HCM', '0976182828', 'vanh@gmail.com'),
('NV17', 'Nguyễn Văn C', '1999-03-03', 'HCM', '090909901', 'khang2209@gmail.com'),
('NV18', 'Đoàn Long Âu', '2002-01-01', 'ABC', '098762626', 'longau123@gmail.com');

-- --------------------------------------------------------

--
-- Table structure for table `phong`
--

CREATE TABLE `phong` (
  `SOPHONG` varchar(10) NOT NULL,
  `SOLUONGSVTOIDA` int(11) DEFAULT NULL,
  `SOLUONGCONLAI` int(11) NOT NULL,
  `MALOAIPHONG` varchar(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `phong`
--

INSERT INTO `phong` (`SOPHONG`, `SOLUONGSVTOIDA`, `SOLUONGCONLAI`, `MALOAIPHONG`) VALUES
('P001', 12, 12, 'TT'),
('P002', 12, 12, 'TT'),
('P003', 12, 12, 'TT'),
('P004', 12, 12, 'TT'),
('P005', 12, 12, 'TT'),
('P006', 12, 12, 'TT'),
('P007', 12, 12, 'TT'),
('P008', 12, 12, 'TT'),
('P009', 12, 12, 'TT'),
('P010', 12, 12, 'TT'),
('P011', 12, 12, 'TT'),
('P012', 12, 12, 'TT'),
('P013', 12, 12, 'TT'),
('P014', 12, 12, 'TT'),
('P015', 12, 12, 'TT'),
('P016', 12, 12, 'TT'),
('P017', 12, 12, 'TT'),
('P018', 12, 12, 'TT'),
('P019', 12, 12, 'TT'),
('P020', 12, 12, 'TT'),
('P021', 12, 12, 'TT-N'),
('P022', 12, 12, 'TT-N'),
('P023', 12, 12, 'TT-N'),
('P024', 12, 12, 'TT-N'),
('P025', 12, 12, 'TT-N'),
('P026', 12, 12, 'TT-N'),
('P027', 12, 12, 'TT-N'),
('P028', 12, 12, 'TT-N'),
('P029', 12, 12, 'TT-N'),
('P030', 12, 12, 'TT-N'),
('P031', 12, 12, 'TT-N'),
('P032', 12, 12, 'TT-N'),
('P033', 12, 12, 'TT-N'),
('P034', 12, 12, 'TT-N'),
('P035', 12, 12, 'TT-N'),
('P036', 12, 12, 'TT-N'),
('P037', 12, 12, 'TT-N'),
('P038', 12, 12, 'TT-N'),
('P039', 12, 12, 'TT-N'),
('P040', 12, 12, 'TT-N'),
('P041', 12, 12, 'DV'),
('P042', 12, 12, 'DV'),
('P043', 12, 12, 'DV'),
('P044', 12, 12, 'DV'),
('P045', 12, 12, 'DV'),
('P046', 12, 12, 'DV'),
('P047', 12, 12, 'DV'),
('P048', 12, 12, 'DV'),
('P049', 12, 12, 'DV'),
('P050', 12, 12, 'DV'),
('P051', 12, 12, 'DV'),
('P052', 12, 12, 'DV'),
('P053', 12, 12, 'DV'),
('P054', 12, 12, 'DV'),
('P055', 12, 12, 'DV'),
('P056', 12, 11, 'DV-N'),
('P057', 12, 12, 'DV-N'),
('P058', 12, 12, 'DV-N'),
('P059', 12, 12, 'DV-N'),
('P060', 12, 12, 'DV-N'),
('P061', 12, 12, 'DV-N'),
('P062', 12, 12, 'DV-N'),
('P063', 12, 12, 'DV-N'),
('P064', 12, 12, 'DV-N'),
('P065', 12, 12, 'DV-N'),
('P066', 12, 12, 'DV-N'),
('P067', 12, 12, 'DV-N'),
('P068', 12, 12, 'DV-N'),
('P069', 12, 12, 'DV-N'),
('P070', 12, 12, 'DV-N'),
('P071', 12, 12, 'DVCLC'),
('P072', 12, 12, 'DVCLC'),
('P073', 12, 12, 'DVCLC'),
('P074', 12, 12, 'DVCLC'),
('P075', 12, 12, 'DVCLC'),
('P076', 12, 12, 'DVCLC'),
('P077', 12, 12, 'DVCLC'),
('P078', 12, 12, 'DVCLC'),
('P079', 12, 12, 'DVCLC'),
('P080', 12, 12, 'DVCLC'),
('P081', 12, 12, 'DVCLC'),
('P082', 12, 12, 'DVCLC'),
('P083', 12, 12, 'DVCLC'),
('P084', 12, 12, 'DVCLC'),
('P085', 12, 12, 'DVCLC'),
('P086', 12, 11, 'DVCLC-N'),
('P087', 12, 12, 'DVCLC-N'),
('P088', 12, 12, 'DVCLC-N'),
('P089', 12, 12, 'DVCLC-N'),
('P090', 12, 12, 'DVCLC-N'),
('P091', 12, 12, 'DVCLC-N'),
('P092', 12, 12, 'DVCLC-N'),
('P093', 12, 12, 'DVCLC-N'),
('P094', 12, 12, 'DVCLC-N'),
('P095', 12, 12, 'DVCLC-N'),
('P096', 12, 12, 'DVCLC-N'),
('P097', 12, 12, 'DVCLC-N'),
('P098', 12, 12, 'DVCLC-N'),
('P099', 12, 12, 'DVCLC-N'),
('P100', 12, 12, 'DVCLC-N'),
('P101', 10, 10, 'DV-N'),
('P102', 8, 8, 'DV-N'),
('P103', 8, 8, 'DV');

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

CREATE TABLE `role` (
  `MAROLE` varchar(20) NOT NULL,
  `TENROLE` varchar(50) CHARACTER SET utf8 DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`MAROLE`, `TENROLE`) VALUES
('NV', 'Nhân viên'),
('QL', 'Quản lí');

-- --------------------------------------------------------

--
-- Table structure for table `sinhvien`
--

CREATE TABLE `sinhvien` (
  `MASV` varchar(20) NOT NULL,
  `LOP` varchar(15) NOT NULL,
  `HOTEN` varchar(50) CHARACTER SET utf8 NOT NULL,
  `NGAYSINH` date NOT NULL,
  `GIOITINH` varchar(3) CHARACTER SET utf8 NOT NULL,
  `CMND` varchar(20) NOT NULL,
  `SDT` varchar(20) NOT NULL,
  `SDTNGUOITHAN` varchar(20) NOT NULL,
  `MAILSV` varchar(50) NOT NULL
) ;

--
-- Dumping data for table `sinhvien`
--

INSERT INTO `sinhvien` (`MASV`, `LOP`, `HOTEN`, `NGAYSINH`, `GIOITINH`, `CMND`, `SDT`, `SDTNGUOITHAN`, `MAILSV`) VALUES
('N19DCCN007', 'D19CQCN01-N', 'Nguyễn Quốc Anh', '2001-09-11', 'Nam', '79201013004', '0948678446', '0948678446', 'n19dccn007@student.ptithcm.edu.vn'),
('N19DCCN009', 'D19CQCN01-N', 'Nguyễn Văn Anh', '2001-01-01', 'Nam', '79201013003', '0888696684', '0888696684', 'n19dccn009@student.ptithcm.edu.vn'),
('N19DCCN010', 'D19CQCN01-N', 'Phạm Việt Anh', '2001-04-23', 'Nam', '79201013002', '0338252502', '0338252502', 'n19dccn010@student.ptithcm.edu.vn'),
('N19DCCN013', 'D19CQCN01-N', 'Nguyễn Sơn Bá', '2001-08-03', 'Nam', '79201013001', '0336066709', '0336066709', 'n19dccn013@student.ptithcm.edu.vn'),
('N19DCCN015', 'D19CQCN01-N', 'Đoàn Long Bảo', '2001-11-13', 'Nam', '79201013000', '0832131101', '0333880916', 'n19dccn015@student.ptithcm.edu.vn'),
('N19DCCN021', 'D19CQCN01-N', 'Trương Phạm Trí Cường', '2001-01-18', 'Nam', '79201012999', '0938519766', '0331695123', 'n19dccn021@student.ptithcm.edu.vn'),
('N19DCCN024', 'D19CQCN01-N', 'Nguyễn Bảo Chính', '2001-02-11', 'Nam', '79201012998', '0978021101', '0329509330', 'n19dccn024@student.ptithcm.edu.vn'),
('N19DCCN028', 'D19CQCN01-N', 'Nguyễn Văn Danh', '2001-03-07', 'Nam', '79201012997', '0396903083', '0327323537', 'n19dccn028@student.ptithcm.edu.vn'),
('N19DCCN030', 'D19CQCN01-N', 'Nguyễn Thanh Dũng', '2001-09-08', 'Nam', '79201012996', '0343263672', '0325137744', 'n19dccn030@student.ptithcm.edu.vn'),
('N19DCCN032', 'D19CQCN01-N', 'Võ Đông Duy', '2001-07-03', 'Nam', '79201012995', '0399164437', '0322951951', 'n19dccn032@student.ptithcm.edu.vn'),
('N19DCCN036', 'D19CQCN01-N', 'Trần Thư Đạt', '2001-12-03', 'Nam', '79201012994', '0941374589', '0320766158', 'n19dccn036@student.ptithcm.edu.vn'),
('N19DCCN038', 'D19CQCN01-N', 'Lê Mậu Anh Đức', '2001-03-07', 'Nam', '79201012993', '0941555027', '0318580365', 'n19dccn038@student.ptithcm.edu.vn'),
('N19DCCN042', 'D19CQCN01-N', 'Đồng Nguyễn Bút Giang', '2001-09-08', 'Nam', '79201012992', '0528575730', '0316394572', 'n19dccn042@student.ptithcm.edu.vn'),
('N19DCCN045', 'D19CQCN01-N', 'Nguyễn Trường Giang', '2001-07-03', 'Nam', '79201012991', '0934778738', '0314208779', 'n19dccn045@student.ptithcm.edu.vn'),
('N19DCCN055', 'D19CQCN01-N', 'Nguyễn Tuấn Hiệp', '2001-03-07', 'Nam', '79201012990', '0987109650', '0312022986', 'n19dccn055@student.ptithcm.edu.vn'),
('N19DCCN062', 'D19CQCN01-N', 'Nguyễn Huy Hoài', '2001-09-08', 'Nam', '79201012989', '0354952793', '0309837193', 'n19dccn062@student.ptithcm.edu.vn'),
('N19DCCN069', 'D19CQCN01-N', 'Bùi Tuấn Hùng', '2001-05-09', 'Nam', '79201012988', '0932215765', '0307651400', 'n19dccn069@student.ptithcm.edu.vn'),
('N19DCCN071', 'D19CQCN01-N', 'Nguyễn Thế Hùng', '2001-10-10', 'Nam', '79201012987', '0904819503', '0305465607', 'n19dccn071@student.ptithcm.edu.vn'),
('N19DCCN072', 'D19CQCN01-N', 'Trần Thanh Hùng', '2001-07-06', 'Nam', '79201012986', '0974204908', '0303279814', 'n19dccn072@student.ptithcm.edu.vn'),
('N19DCCN078', 'D19CQCN01-N', 'Trương Trung Kiên', '2001-04-01', 'Nam', '79201012985', '0986349122', '0301094021', 'n19dccn078@student.ptithcm.edu.vn'),
('N19DCCN079', 'D19CQCN01-N', 'Huỳnh Tuấn Kiệt', '2000-12-26', 'Nam', '79201012984', '0367083461', '0298908228', 'n19dccn079@student.ptithcm.edu.vn'),
('N19DCCN081', 'D19CQCN01-N', 'Phan Anh Kiệt', '2001-03-05', 'Nam', '79201012983', '0937079054', '0296722435', 'n19dccn081@student.ptithcm.edu.vn'),
('N19DCCN083', 'D19CQCN01-N', 'Nguyễn Tất Kỳ', '2001-03-06', 'Nam', '79201012982', '0782121538', '0294536642', 'n19dccn083@student.ptithcm.edu.vn'),
('N19DCCN085', 'D19CQCN01-N', 'Đỗ Tấn Kha', '2001-03-07', 'Nam', '79201012981', '0359830311', '0292350849', 'n19dccn085@student.ptithcm.edu.vn'),
('N19DCCN086', 'D19CQCN01-N', 'Nguyễn Minh Khang', '2001-03-08', 'Nam', '79201012980', '0589477090', '0290165056', 'n19dccn086@student.ptithcm.edu.vn'),
('N19DCCN088', 'D19CQCN01-N', 'Lê An Khánh', '2001-04-08', 'Nam', '79201012979', '0834250701', '0287979263', 'n19dccn088@student.ptithcm.edu.vn'),
('N19DCCN089', 'D19CQCN01-N', 'Lê Đăng Khánh', '2001-04-09', 'Nam', '79201012978', '0349031716', '0285793470', 'n19dccn089@student.ptithcm.edu.vn'),
('N19DCCN090', 'D19CQCN01-N', 'Phạm Văn Khánh', '2001-04-10', 'Nam', '79201012977', '0378692876', '0283607677', 'n19dccn090@student.ptithcm.edu.vn'),
('N19DCCN091', 'D19CQCN01-N', 'Trần Duy Khánh', '2001-04-11', 'Nam', '79201012976', '0375192740', '0281421884', 'n19dccn091@student.ptithcm.edu.vn'),
('N19DCCN093', 'D19CQCN01-N', 'Đỗ Đăng Khoa', '2001-04-12', 'Nam', '79201012975', '0938051783', '0279236091', 'n19dccn093@student.ptithcm.edu.vn'),
('N19DCCN096', 'D19CQCN01-N', 'Cao Văn Lâm', '2001-04-13', 'Nam', '79201012974', '0868729154', '0277050298', 'n19dccn096@student.ptithcm.edu.vn'),
('N19DCCN097', 'D19CQCN01-N', 'Nguyễn Thị Mỹ Linh', '2001-04-14', 'Nữ', '79201012973', '0869698300', '0274864505', 'n19dccn097@student.ptithcm.edu.vn'),
('N19DCCN100', 'D19CQCN01-N', 'Trần Minh Long', '2001-04-09', 'Nam', '79201012972', '0362209367', '0272678712', 'n19dccn100@student.ptithcm.edu.vn'),
('N19DCCN102', 'D19CQCN01-N', 'Mai Văn Lợi', '2001-01-04', 'Nam', '79201012971', '0969323862', '0270492919', 'n19dccn102@student.ptithcm.edu.vn'),
('N19DCCN104', 'D19CQCN01-N', 'Trần Thị Trúc Ly', '2001-02-07', 'Nữ', '79201012970', '0988948824', '0268307126', 'n19dccn104@student.ptithcm.edu.vn'),
('N19DCCN105', 'D19CQCN01-N', 'Chu Văn Mạnh', '2001-04-09', 'Nam', '79201012969', '0354149880', '0266121333', 'n19dccn105@student.ptithcm.edu.vn'),
('N19DCCN110', 'D19CQCN01-N', 'Nguyễn Nhật Minh', '2001-01-04', 'Nam', '79201012968', '0384985558', '0263935540', 'n19dccn110@student.ptithcm.edu.vn'),
('N19DCCN116', 'D19CQCN01-N', 'Nguyễn Quang Niên', '2001-02-07', 'Nam', '79201012967', '0855586358', '0261749747', 'n19dccn116@student.ptithcm.edu.vn'),
('N19DCCN119', 'D19CQCN01-N', 'Võ Thị Ngân', '2001-04-09', 'Nữ', '79201012966', '0395442149', '0259563954', 'n19dccn119@student.ptithcm.edu.vn'),
('N19DCCN120', 'D19CQCN01-N', 'Nguyễn Thanh Nghị', '2001-01-04', 'Nam', '79201012965', '0336593650', '0257378161', 'n19dccn120@student.ptithcm.edu.vn'),
('N19DCCN121', 'D19CQCN01-N', 'Phạm Hồng Nghĩa', '2001-02-07', 'Nam', '79201012964', '0334569493', '0255192368', 'n19dccn121@student.ptithcm.edu.vn'),
('N19DCCN122', 'D19CQCN01-N', 'Bùi Tá Tân Ngọc', '2001-04-09', 'Nam', '79201012963', '0334397556', '0253006575', 'n19dccn122@student.ptithcm.edu.vn'),
('N19DCCN125', 'D19CQCN01-N', 'Cao Thanh Nhàn', '2001-01-04', 'Nữ', '79201012962', '0837206458', '0250820782', 'n19dccn125@student.ptithcm.edu.vn'),
('N19DCCN126', 'D19CQCN01-N', 'Lê Hoài Nhân', '2001-02-07', 'Nam', '79201012961', '0354490718', '0248634989', 'n19dccn126@student.ptithcm.edu.vn'),
('N19DCCN130', 'D19CQCN01-N', 'Nguyễn Tân Nhật', '2001-10-12', 'Nam', '79201012960', '0963763594', '0246449196', 'n19dccn130@student.ptithcm.edu.vn'),
('N19DCCN131', 'D19CQCN01-N', 'Nguyễn Hoài Nhớ', '2001-10-11', 'Nam', '79201012959', '0915713846', '0244263403', 'n19dccn131@student.ptithcm.edu.vn'),
('N19DCCN135', 'D19CQCN01-N', 'Vũ Thị Hồng Oanh', '2001-10-10', 'Nữ', '79201012958', '0961319365', '0242077610', 'n19dccn135@student.ptithcm.edu.vn'),
('N19DCCN136', 'D19CQCN01-N', 'Trần Hoàng Phi', '2001-10-09', 'Nam', '79201012957', '0372671979', '0239891817', 'n19dccn136@student.ptithcm.edu.vn'),
('N19DCCN141', 'D19CQCN01-N', 'Trịnh Quốc Phong', '2001-10-08', 'Nam', '79201012956', '0855556532', '0237706024', 'n19dccn141@student.ptithcm.edu.vn'),
('N19DCCN144', 'D19CQCN01-N', 'Nguyễn Tuấn Phụng', '2001-10-07', 'Nam', '79201012955', '0828532784', '0235520231', 'n19dccn144@student.ptithcm.edu.vn'),
('N19DCCN147', 'D19CQCN01-N', 'Lê Nguyễn Duy Phương', '2001-10-06', 'Nam', '79201012954', '0962111508', '0233334438', 'n19dccn147@student.ptithcm.edu.vn'),
('N19DCCN148', 'D19CQCN01-N', 'Nguyễn Minh Phương', '2001-10-05', 'Nam', '79201012953', '0708701795', '0231148645', 'n19dccn148@student.ptithcm.edu.vn'),
('N19DCCN153', 'D19CQCN01-N', 'Trần Nhật Quân', '2001-10-04', 'Nam', '79201012952', '0868466696', '0228962852', 'n19dccn153@student.ptithcm.edu.vn'),
('N19DCCN155', 'D19CQCN01-N', 'Đặng Thanh Sang', '2001-10-03', 'Nam', '79201012951', '0777930928', '0226777059', 'n19dccn155@student.ptithcm.edu.vn'),
('N19DCCN162', 'D19CQCN01-N', 'Võ Kim Sơn', '2001-12-09', 'Nam', '79201012950', '0978651363', '0224591266', 'n19dccn162@student.ptithcm.edu.vn'),
('N19DCCN163', 'D19CQCN01-N', 'Nguyễn Duy Tài', '2001-12-10', 'Nam', '79201012949', '0935153492', '0222405473', 'n19dccn163@student.ptithcm.edu.vn'),
('N19DCCN166', 'D19CQCN01-N', 'Nguyễn Thành Tân', '2001-12-11', 'Nam', '79201012948', '0399746032', '0220219680', 'n19dccn166@student.ptithcm.edu.vn'),
('N19DCCN168', 'D19CQCN01-N', 'Lê Văn Anh Tiến', '2001-12-12', 'Nam', '79201012947', '0865952435', '0218033887', 'n19dccn168@student.ptithcm.edu.vn'),
('N19DCCN175', 'D19CQCN01-N', 'Nguyễn Anh Tú', '2001-12-13', 'Nam', '79201012946', '0945499078', '0215848094', 'n19dccn175@student.ptithcm.edu.vn'),
('N19DCCN180', 'D19CQCN01-N', 'Nguyễn Văn Tuấn', '2001-12-14', 'Nam', '79201012945', '0931695492', '0213662301', 'n19dccn180@student.ptithcm.edu.vn'),
('N19DCCN182', 'D19CQCN01-N', 'Đỗ Văn Tuyền', '2001-12-15', 'Nam', '79201012944', '0394652395', '0211476508', 'n19dccn182@student.ptithcm.edu.vn'),
('N19DCCN184', 'D19CQCN01-N', 'Nguyễn Thái Tường', '2001-12-16', 'Nam', '79201012943', '0399035815', '0209290715', 'n19dccn184@student.ptithcm.edu.vn'),
('N19DCCN200', 'D19CQCN01-N', 'Nguyễn Doãn Thông', '2001-12-17', 'Nam', '79201012942', '0366218281', '0207104922', 'n19dccn200@student.ptithcm.edu.vn'),
('N19DCCN204', 'D19CQCN01-N', 'Phạm Văn Thuận', '2001-12-18', 'Nam', '79201012941', '0365338185', '0204919129', 'n19dccn204@student.ptithcm.edu.vn'),
('N19DCCN207', 'D19CQCN01-N', 'Lê Thị Thùy Trang', '2001-10-07', 'Nữ', '79201012940', '0917057613', '0202733336', 'n19dccn207@student.ptithcm.edu.vn'),
('N19DCCN208', 'D19CQCN01-N', 'Lê Viết Trí', '2001-01-09', 'Nam', '79201012939', '0976919072', '0200547543', 'n19dccn208@student.ptithcm.edu.vn'),
('N19DCCN210', 'D19CQCN01-N', 'Tạ Minh Trí', '2001-07-07', 'Nam', '79201012938', '0983154195', '0198361750', 'n19dccn210@student.ptithcm.edu.vn'),
('N19DCCN215', 'D19CQCN01-N', 'Ngô Quốc Trung', '2001-10-07', 'Nam', '79201012937', '0839768848', '0196175957', 'n19dccn215@student.ptithcm.edu.vn'),
('N19DCCN220', 'D19CQCN01-N', 'Vũ Việt Trường', '2001-01-09', 'Nam', '79201012936', '0392395607', '0193990164', 'n19dccn220@student.ptithcm.edu.vn'),
('N19DCCN227', 'D19CQCN01-N', 'Lê Nguyễn Ngọc Vũ', '2001-07-07', 'Nam', '79201012935', '0948387811', '0191804371', 'n19dccn227@student.ptithcm.edu.vn'),
('N19DCCN228', 'D19CQCN01-N', 'Nguyễn Đăng Vũ', '2001-10-07', 'Nam', '79201012934', '0379015026', '0189618578', 'n19dccn228@student.ptithcm.edu.vn'),
('N19DCCN230', 'D19CQCN01-N', 'NguyễN Thị Yến Vy', '2001-01-09', 'Nữ', '79201012933', '0911987261', '0187432785', 'n19dccn230@student.ptithcm.edu.vn'),
('N19DCCN232', 'D19CQCN01-N', 'Nguyễn Khánh Ý', '2001-07-07', 'Nam', '79201012932', '0917388548', '0185246992', 'n19dccn232@student.ptithcm.edu.vn'),
('N20DCCN001', 'D20CQCN01-N', 'Trần Văn A', '2002-02-02', 'Nam', '098282828222', '0988777666', '0966886666', 'n20dccn001@student.ptithcm.edu.vn'),
('N20DCCN002', 'D20CQCN01-N', 'Trần Văn C', '2001-03-03', 'Nam', '08123123123', '0365867273', '0909020092', 'n20dccn002@student.ptithcm.edu.vn');

-- --------------------------------------------------------

--
-- Table structure for table `sotheodoi`
--

CREATE TABLE `sotheodoi` (
  `MAKL` int(11) NOT NULL,
  `MASV` varchar(20) NOT NULL,
  `MANV` varchar(20) NOT NULL,
  `LYDO` longtext NOT NULL,
  `NGAYGHINHAN` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `sotheodoi`
--

INSERT INTO `sotheodoi` (`MAKL`, `MASV`, `MANV`, `LYDO`, `NGAYGHINHAN`) VALUES
(8, 'N19DCCN007', 'NV01', 'Về trễ', '2023-03-03');

-- --------------------------------------------------------

--
-- Table structure for table `taikhoan`
--

CREATE TABLE `taikhoan` (
  `MANV` varchar(20) NOT NULL,
  `MATKHAU` varchar(100) NOT NULL,
  `QUYEN` varchar(20) NOT NULL,
  `TRANGTHAI` varchar(20) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `taikhoan`
--

INSERT INTO `taikhoan` (`MANV`, `MATKHAU`, `QUYEN`, `TRANGTHAI`) VALUES
('NV01', '$2a$10$THvvrk4bGfWPsplDJgzWQOjJooyV9PW19oi9VLrXCmF5T14MjTzUG', 'Quản lý', 'Hoạt động'),
('NV10', '$2a$10$IX.w5DiNr/qn/wgv1Zhi8uETVaw4MBuSxNRzlubnsT1..A3Vnz1be', 'Quản lý', 'Hoạt động'),
('NV11', '$2a$10$IX.w5DiNr/qn/wgv1Zhi8uETVaw4MBuSxNRzlubnsT1..A3Vnz1be', 'Nhân viên', 'Hoạt động'),
('NV14', '$2a$10$IX.w5DiNr/qn/wgv1Zhi8uETVaw4MBuSxNRzlubnsT1..A3Vnz1be', 'Nhân viên', 'Hoạt động'),
('NV15', '$2a$10$IX.w5DiNr/qn/wgv1Zhi8uETVaw4MBuSxNRzlubnsT1..A3Vnz1be', 'Quản lý', 'Hoạt động'),
('NV16', '$2a$10$IX.w5DiNr/qn/wgv1Zhi8uETVaw4MBuSxNRzlubnsT1..A3Vnz1be', 'Nhân viên', 'Hoạt động'),
('NV17', '$2a$10$GJZe2Lpkg/QS8UXHK5CxguNCJrRP.NmNQr8BJ1Kbz82HmIpKEsN0a', 'Nhân viên', 'Hoạt động'),
('NV18', '$2a$10$IX.w5DiNr/qn/wgv1Zhi8uETVaw4MBuSxNRzlubnsT1..A3Vnz1be', 'Nhân viên', 'Hoạt động');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `hoadondien`
--
ALTER TABLE `hoadondien`
  ADD PRIMARY KEY (`MAHD`,`MANV`,`SOPHONG`),
  ADD KEY `MANV` (`MANV`),
  ADD KEY `SOPHONG` (`SOPHONG`);

--
-- Indexes for table `hopdong`
--
ALTER TABLE `hopdong`
  ADD PRIMARY KEY (`MAHOPDONG`),
  ADD KEY `hopdong_ibfk_1` (`MANV`),
  ADD KEY `hopdong_ibfk_2` (`SOPHONG`),
  ADD KEY `hopdong_ibfk_3` (`MASV`);

--
-- Indexes for table `loaiphong`
--
ALTER TABLE `loaiphong`
  ADD PRIMARY KEY (`MALOAIPHONG`);

--
-- Indexes for table `nhanvien`
--
ALTER TABLE `nhanvien`
  ADD PRIMARY KEY (`MANV`);

--
-- Indexes for table `phong`
--
ALTER TABLE `phong`
  ADD PRIMARY KEY (`SOPHONG`),
  ADD KEY `MALOAIPHONG` (`MALOAIPHONG`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`MAROLE`);

--
-- Indexes for table `sinhvien`
--
ALTER TABLE `sinhvien`
  ADD PRIMARY KEY (`MASV`);

--
-- Indexes for table `sotheodoi`
--
ALTER TABLE `sotheodoi`
  ADD PRIMARY KEY (`MAKL`,`MASV`,`MANV`),
  ADD KEY `MANV` (`MANV`),
  ADD KEY `MASV` (`MASV`);

--
-- Indexes for table `taikhoan`
--
ALTER TABLE `taikhoan`
  ADD PRIMARY KEY (`MANV`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `sotheodoi`
--
ALTER TABLE `sotheodoi`
  MODIFY `MAKL` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `hoadondien`
--
ALTER TABLE `hoadondien`
  ADD CONSTRAINT `fk_hoadonnv` FOREIGN KEY (`MANV`) REFERENCES `nhanvien` (`MANV`),
  ADD CONSTRAINT `hoadondien_ibfk_1` FOREIGN KEY (`MANV`) REFERENCES `nhanvien` (`MANV`),
  ADD CONSTRAINT `hoadondien_ibfk_2` FOREIGN KEY (`SOPHONG`) REFERENCES `phong` (`SOPHONG`);

--
-- Constraints for table `hopdong`
--
ALTER TABLE `hopdong`
  ADD CONSTRAINT `hopdong_ibfk_1` FOREIGN KEY (`MANV`) REFERENCES `nhanvien` (`MANV`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hopdong_ibfk_2` FOREIGN KEY (`SOPHONG`) REFERENCES `phong` (`SOPHONG`) ON UPDATE CASCADE,
  ADD CONSTRAINT `hopdong_ibfk_3` FOREIGN KEY (`MASV`) REFERENCES `sinhvien` (`MASV`) ON UPDATE CASCADE;

--
-- Constraints for table `phong`
--
ALTER TABLE `phong`
  ADD CONSTRAINT `phong_ibfk_1` FOREIGN KEY (`MALOAIPHONG`) REFERENCES `loaiphong` (`MALOAIPHONG`);

--
-- Constraints for table `sotheodoi`
--
ALTER TABLE `sotheodoi`
  ADD CONSTRAINT `sotheodoi_ibfk_1` FOREIGN KEY (`MANV`) REFERENCES `nhanvien` (`MANV`),
  ADD CONSTRAINT `sotheodoi_ibfk_2` FOREIGN KEY (`MASV`) REFERENCES `sinhvien` (`MASV`);

--
-- Constraints for table `taikhoan`
--
ALTER TABLE `taikhoan`
  ADD CONSTRAINT `taikhoan_ibfk_3` FOREIGN KEY (`MANV`) REFERENCES `nhanvien` (`MANV`);

DELIMITER $$
--
-- Events
--
CREATE DEFINER=`root`@`localhost` EVENT `updateHD` ON SCHEDULE EVERY 1 DAY STARTS '2023-03-04 00:00:00' ON COMPLETION NOT PRESERVE ENABLE DO UPDATE hopdong
SET TRANGTHAIHUY = 'Đã kết thúc' WHERE DATEDIFF(NGAYLAP, CURRENT_DATE()) < 0$$

DELIMITER ;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
