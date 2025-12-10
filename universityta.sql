/*
 Navicat Premium Data Transfer

 Source Server         : MySQL_cyh
 Source Server Type    : MySQL
 Source Server Version : 90500 (9.5.0)
 Source Host           : localhost:3306
 Source Schema         : universityta

 Target Server Type    : MySQL
 Target Server Version : 90500 (9.5.0)
 File Encoding         : 65001

 Date: 10/12/2025 12:57:34
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_bj
-- ----------------------------
DROP TABLE IF EXISTS `t_bj`;
CREATE TABLE `t_bj`  (
  `BJ_BH` int NOT NULL COMMENT '班级编号',
  `BJ_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '班级名称',
  `ZY_BH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '(所属)专业编号',
  `SSNJ` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属年级',
  `SSXY` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院',
  PRIMARY KEY (`BJ_BH`) USING BTREE,
  INDEX `FK_BJ_ZY`(`ZY_BH` ASC) USING BTREE,
  CONSTRAINT `FK_BJ_ZY` FOREIGN KEY (`ZY_BH`) REFERENCES `t_zy` (`ZY_BH`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校班级表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bj
-- ----------------------------
INSERT INTO `t_bj` VALUES (1, '24级英语1班', '01', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (2, '25级英语2班', '01', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (3, '24级商务英语1班', '02', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (4, '25级商务英语2班', '02', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (5, '24级翻译1班', '03', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (6, '25级翻译2班', '03', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (7, '24级西班牙语1班', '04', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (8, '25级西班牙语2班', '04', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (9, '24级法语1班', '05', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (10, '25级法语2班', '05', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (11, '24级意大利语1班', '06', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (12, '25级意大利语2班', '06', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (13, '24级葡萄牙语1班', '07', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (14, '25级葡萄牙语2班', '07', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (15, '24级俄语德语1班', '08', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (16, '25级俄语德语2班', '08', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (17, '24级捷克语1班', '09', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (18, '25级捷克语2班', '09', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (19, '24级波兰语1班', '10', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (20, '25级波兰语2班', '10', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (21, '24级汉语言1班', '11', '24级', '语言文化学院');
INSERT INTO `t_bj` VALUES (22, '25级汉语言2班', '11', '25级', '语言文化学院');
INSERT INTO `t_bj` VALUES (23, '24级国际经济与贸易1班', '12', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (24, '25级国际经济与贸易2班', '12', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (25, '24级国际商务1班', '13', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (26, '25级国际商务2班', '13', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (27, '24级金融工程1班', '14', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (28, '25级金融工程2班', '14', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (29, '24级电子商务1班', '15', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (30, '25级电子商务2班', '15', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (31, '24级跨境电子商务1班', '16', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (32, '25级跨境电子商务2班', '16', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (33, '24级计算机科学与技术1班', '17', '24级', '国商学院');
INSERT INTO `t_bj` VALUES (34, '25级计算机科学与技术2班', '17', '25级', '国商学院');
INSERT INTO `t_bj` VALUES (35, '24级小学教育1班', '18', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (36, '25级小学教育2班', '18', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (37, '24级学前教育1班', '19', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (38, '25级学前教育2班', '19', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (39, '24级科学教育1班', '20', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (40, '25级科学教育2班', '20', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (41, '24级数学与应用数学1班', '21', '24级', '教育学院');
INSERT INTO `t_bj` VALUES (42, '25级数学与应用数学2班', '21', '25级', '教育学院');
INSERT INTO `t_bj` VALUES (43, '24级旅游管理1班', '22', '24级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (44, '25级旅游管理2班', '22', '25级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (45, '24级会展经济与管理1班', '23', '24级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (46, '25级会展经济与管理2班', '23', '25级', '文化和旅游学院');
INSERT INTO `t_bj` VALUES (47, '24级音乐学1班', '24', '24级', '艺术学院');
INSERT INTO `t_bj` VALUES (48, '25级音乐学2班', '24', '25级', '艺术学院');
INSERT INTO `t_bj` VALUES (49, '24级美术学1班', '25', '24级', '艺术学院');
INSERT INTO `t_bj` VALUES (50, '25级美术学2班', '25', '25级', '艺术学院');
INSERT INTO `t_bj` VALUES (51, '24级艺术与科技1班', '26', '24级', '艺术学院');
INSERT INTO `t_bj` VALUES (52, '25级艺术与科技2班', '26', '25级', '艺术学院');

-- ----------------------------
-- Table structure for t_bqzd
-- ----------------------------
DROP TABLE IF EXISTS `t_bqzd`;
CREATE TABLE `t_bqzd`  (
  `BQ_ID` int NOT NULL AUTO_INCREMENT COMMENT '标签ID',
  `BQ_MC` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '标签名称',
  `BQ_LX` int NOT NULL COMMENT '标签类型：1-兴趣/活动类别, 2-技能',
  PRIMARY KEY (`BQ_ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 14 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '标签字典表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_bqzd
-- ----------------------------
INSERT INTO `t_bqzd` VALUES (1, '社区服务', 1);
INSERT INTO `t_bqzd` VALUES (2, '赛会服务', 1);
INSERT INTO `t_bqzd` VALUES (3, '环境保护', 1);
INSERT INTO `t_bqzd` VALUES (4, '敬老助残', 1);
INSERT INTO `t_bqzd` VALUES (5, '支教助学', 1);
INSERT INTO `t_bqzd` VALUES (6, '校园建设', 1);
INSERT INTO `t_bqzd` VALUES (7, '摄影摄像', 2);
INSERT INTO `t_bqzd` VALUES (8, '新闻写作', 2);
INSERT INTO `t_bqzd` VALUES (9, '英语翻译', 2);
INSERT INTO `t_bqzd` VALUES (10, '计算机维修', 2);
INSERT INTO `t_bqzd` VALUES (11, '急救技能', 2);
INSERT INTO `t_bqzd` VALUES (12, '驾驶', 2);
INSERT INTO `t_bqzd` VALUES (13, '主持演讲', 2);

-- ----------------------------
-- Table structure for t_gly
-- ----------------------------
DROP TABLE IF EXISTS `t_gly`;
CREATE TABLE `t_gly`  (
  `GLY_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号',
  `GLY_MM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `GLY_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '名称',
  PRIMARY KEY (`GLY_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '管理员表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_gly
-- ----------------------------
INSERT INTO `t_gly` VALUES ('GUOZHIXIE', '240910132201Cyh', '国志协');

-- ----------------------------
-- Table structure for t_xjbmfzr
-- ----------------------------
DROP TABLE IF EXISTS `t_xjbmfzr`;
CREATE TABLE `t_xjbmfzr`  (
  `XJBM_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '校级部门名称',
  `XJBMFZR_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '账号',
  `XJBMFZR_MM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `XJBMFZR_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '姓名',
  `XJBMFZR_DH` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '电话',
  PRIMARY KEY (`XJBMFZR_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '校级部门负责人信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_xjbmfzr
-- ----------------------------
INSERT INTO `t_xjbmfzr` VALUES ('体育部', '800001', '800001', '张一', '05761001');
INSERT INTO `t_xjbmfzr` VALUES ('行政部门', '800002', '800002', '李二', '05761002');
INSERT INTO `t_xjbmfzr` VALUES ('服务保障单位', '800003', '800003', '王三', '05761003');
INSERT INTO `t_xjbmfzr` VALUES ('党群组织', '800004', '800004', '杨四', '05761004');
INSERT INTO `t_xjbmfzr` VALUES ('教务处', '800005', '800005', '赵五', '05761005');
INSERT INTO `t_xjbmfzr` VALUES ('国际交流合作处', '800006', '800006', '吴六', '05761006');
INSERT INTO `t_xjbmfzr` VALUES ('学生处', '800007', '800007', '江七', '05761007');
INSERT INTO `t_xjbmfzr` VALUES ('学校办公室', '800008', '800008', '孟八', '05761008');
INSERT INTO `t_xjbmfzr` VALUES ('教学辅助单位', '800009', '800009', '周九', '05761009');

-- ----------------------------
-- Table structure for t_xs
-- ----------------------------
DROP TABLE IF EXISTS `t_xs`;
CREATE TABLE `t_xs`  (
  `XS_XH` int NOT NULL COMMENT '学生学号',
  `XS_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学生姓名',
  `XS_MM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '密码',
  `XS_DH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '联系电话',
  `XS_XB` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '性别',
  `ZZMM` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '政治面貌',
  `SS_XY` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院',
  `BJ_BH` int NOT NULL COMMENT '(所属)班级编号',
  `BJ_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '班级名称',
  `XQ_BQ` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '兴趣标签(用于内容推荐)',
  `JN_BQ` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '技能标签(用于内容推荐)',
  `GRJJ` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '个人简介',
  PRIMARY KEY (`XS_XH`) USING BTREE,
  INDEX `FK_XS_BJ`(`BJ_BH` ASC) USING BTREE,
  CONSTRAINT `FK_XS_BJ` FOREIGN KEY (`BJ_BH`) REFERENCES `t_bj` (`BJ_BH`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学生信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_xs
-- ----------------------------
INSERT INTO `t_xs` VALUES (2024104, '李胜男', '123456Cyh', '13372369295', '1', '群众', '语言文化学院', 1, '24英语1班', '社区服务,ab', '摄影摄像,cd', 'ef');
INSERT INTO `t_xs` VALUES (2024106, '章客', '2024106', '1512564625', '1', '共青团员', '语言文化学院', 3, '24商务英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024108, '陈基', '2024108', '1512564649', '1', '共青团员', '语言文化学院', 5, '24翻译1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024110, '陈客', '2024110', '1512564681', '0', '共青团员', '语言文化学院', 7, '24西班牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024112, '陈政', '2024112', '15125646121', '1', '共青团员', '语言文化学院', 9, '24法语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024114, '王政', '2024114', '15125646169', '0', '共青团员', '语言文化学院', 11, '24意大利语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024116, '林别', '2024116', '15125646225', '1', '共青团员', '语言文化学院', 13, '24葡萄牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024118, '季和', '2024118', '15125646289', '1', '共青团员', '语言文化学院', 15, '24俄语德语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024120, '陈别', '2024120', '15125646361', '1', '共青团员', '语言文化学院', 17, '24捷克语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024122, '陈政政', '2024122', '15125646441', '1', '共青团员', '语言文化学院', 19, '24波兰语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024124, '章基大', '2024124', '15125646529', '0', '共青团员', '语言文化学院', 21, '24汉语言1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024126, '卢于基', '2024126', '15125646625', '0', '共青团员', '国商学院', 23, '24国际经济与贸易1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024128, '方基个', '2024128', '15125646729', '1', '共青团员', '国商学院', 25, '24国际商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024130, '季拿媒', '2024130', '15125646841', '1', '共青团员', '国商学院', 27, '24金融工程1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024132, '陈政于', '2024132', '15125646961', '0', '共青团员', '国商学院', 29, '24电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024134, '王别于', '2024134', '151256461089', '1', '共青团员', '国商学院', 31, '24跨境电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024136, '方加政', '2024136', '151256461225', '1', '共青团员', '国商学院', 33, '24计算机科学与技术1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024138, '季拿基', '2024138', '151256461369', '1', '共青团员', '教育学院', 35, '24小学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024140, '陈府大', '2024140', '151256461521', '0', '共青团员', '教育学院', 37, '24学前教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024203, '林定关', '2024203', '151256464', '1', '共青团员', '教育学院', 39, '24科学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024205, '李定严', '2024205', '1512564616', '1', '共青团员', '教育学院', 41, '24数学与应用数学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024207, '李定中', '2024207', '1512564636', '0', '共青团员', '文化和旅游学院', 43, '24旅游管理1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024209, '李反定', '2024209', '1512564664', '1', '共青团员', '文化和旅游学院', 45, '24会展经济与管理1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024211, '金协协', '2024211', '15125646100', '1', '共青团员', '艺术学院', 47, '24音乐学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024213, '张违加', '2024213', '15125646144', '0', '共青团员', '艺术学院', 49, '24美术学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024215, '卢严违', '2024215', '15125646196', '1', '共青团员', '艺术学院', 51, '24艺术与科技1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024217, '季重定', '2024217', '15125646256', '0', '共青团员', '语言文化学院', 1, '24英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024219, '金反重', '2024219', '15125646324', '1', '共青团员', '语言文化学院', 3, '24商务英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024221, '方中边', '2024221', '15125646400', '1', '共青团员', '语言文化学院', 5, '24翻译1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024223, '金重加', '2024223', '15125646484', '0', '共青团员', '语言文化学院', 7, '24西班牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024225, '李关重', '2024225', '15125646576', '0', '共青团员', '语言文化学院', 9, '24法语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024227, '林违反', '2024227', '15125646676', '0', '共青团员', '语言文化学院', 11, '24意大利语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024229, '季相双', '2024229', '15125646784', '1', '共青团员', '语言文化学院', 13, '24葡萄牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024231, '林边违', '2024231', '15125646900', '0', '共青团员', '语言文化学院', 15, '24俄语德语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024233, '李严边', '2024233', '151256461024', '0', '共青团员', '语言文化学院', 17, '24捷克语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024235, '陈定边', '2024235', '151256461156', '1', '共青团员', '语言文化学院', 19, '24波兰语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024238, '陈双协', '2024238', '151256461369', '1', '共青团员', '语言文化学院', 21, '24汉语言1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024240, '金反边', '2024240', '151256461521', '1', '共青团员', '国商学院', 23, '24国际经济与贸易1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024302, '张公边', '2024302', '151256461', '0', '共青团员', '国商学院', 25, '24国际商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024304, '王协双', '2024304', '151256469', '0', '共青团员', '国商学院', 27, '24金融工程1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024306, '王和关', '2024306', '1512564625', '0', '共青团员', '国商学院', 29, '24电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024308, '卢国协', '2024308', '1512564649', '0', '共青团员', '国商学院', 31, '24跨境电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024310, '陈公边', '2024310', '1512564681', '1', '共青团员', '国商学院', 33, '24计算机科学与技术1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024312, '卢中公', '2024312', '15125646121', '1', '共青团员', '教育学院', 35, '24小学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024314, '章中依', '2024314', '15125646169', '1', '共青团员', '教育学院', 37, '24学前教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024316, '王和际', '2024316', '15125646225', '1', '共青团员', '教育学院', 39, '24科学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024318, '章际公', '2024318', '15125646289', '0', '共青团员', '教育学院', 41, '24数学与应用数学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024320, '李国双', '2024320', '15125646361', '1', '共青团员', '文化和旅游学院', 43, '24旅游管理1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024322, '卢定', '2024322', '15125646441', '0', '共青团员', '文化和旅游学院', 45, '24会展经济与管理1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024324, '季关', '2024324', '15125646529', '1', '共青团员', '艺术学院', 47, '24音乐学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024326, '李边', '2024326', '15125646625', '0', '共青团员', '艺术学院', 49, '24美术学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024328, '陈关', '2024328', '15125646729', '1', '共青团员', '艺术学院', 51, '24艺术与科技1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024330, '章国', '2024330', '15125646841', '0', '共青团员', '语言文化学院', 1, '24英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024332, '李加', '2024332', '15125646961', '1', '共青团员', '语言文化学院', 3, '24商务英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024334, '陈公', '2024334', '151256461089', '1', '共青团员', '语言文化学院', 5, '24翻译1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024336, '王约', '2024336', '151256461225', '1', '共青团员', '语言文化学院', 7, '24西班牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024338, '陈约', '2024338', '151256461369', '0', '共青团员', '语言文化学院', 9, '24法语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024340, '金中', '2024340', '151256461521', '0', '共青团员', '语言文化学院', 11, '24意大利语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024402, '林关', '2024402', '151256461', '1', '共青团员', '语言文化学院', 13, '24葡萄牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024404, '金约定', '2024404', '151256469', '1', '共青团员', '语言文化学院', 15, '24俄语德语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024406, '卢际双', '2024406', '1512564625', '0', '共青团员', '语言文化学院', 17, '24捷克语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024408, '李中', '2024408', '1512564649', '1', '共青团员', '语言文化学院', 19, '24波兰语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024410, '金定', '2024410', '1512564681', '0', '共青团员', '语言文化学院', 21, '24汉语言1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024412, '林公', '2024412', '15125646121', '0', '共青团员', '国商学院', 23, '24国际经济与贸易1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024414, '王国', '2024414', '15125646169', '0', '共青团员', '国商学院', 25, '24国际商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024416, '方际', '2024416', '15125646225', '0', '共青团员', '国商学院', 27, '24金融工程1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024418, '林协国', '2024418', '15125646289', '1', '共青团员', '国商学院', 29, '24电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024420, '季协', '2024420', '15125646361', '0', '共青团员', '国商学院', 31, '24跨境电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024422, '陈中', '2024422', '15125646441', '0', '共青团员', '国商学院', 33, '24计算机科学与技术1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024424, '王约边', '2024424', '15125646529', '0', '共青团员', '教育学院', 35, '24小学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024426, '林协', '2024426', '15125646625', '1', '共青团员', '教育学院', 37, '24学前教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024428, '李际', '2024428', '15125646729', '0', '共青团员', '教育学院', 39, '24科学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024430, '金定定', '2024430', '15125646841', '1', '共青团员', '教育学院', 41, '24数学与应用数学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024432, '林双', '2024432', '15125646961', '0', '共青团员', '文化和旅游学院', 43, '24旅游管理1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024434, '李约约', '2024434', '151256461089', '0', '共青团员', '文化和旅游学院', 45, '24会展经济与管理1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024436, '卢际', '2024436', '151256461225', '1', '共青团员', '艺术学院', 47, '24音乐学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024438, '张边和', '2024438', '151256461369', '1', '共青团员', '艺术学院', 49, '24美术学1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024440, '张约', '2024440', '151256461521', '0', '共青团员', '艺术学院', 51, '24艺术与科技1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024510, '王边', '2024510', '1512564681', '0', '共青团员', '语言文化学院', 1, '24英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024512, '金定际', '2024512', '15125646121', '1', '共青团员', '语言文化学院', 3, '24商务英语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024514, '陈加', '2024514', '15125646169', '1', '共青团员', '语言文化学院', 5, '24翻译1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024516, '金国和', '2024516', '15125646225', '1', '共青团员', '语言文化学院', 7, '24西班牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024518, '林中', '2024518', '15125646289', '1', '共青团员', '语言文化学院', 9, '24法语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024520, '季国', '2024520', '151256461', '0', '共青团员', '语言文化学院', 11, '24意大利语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024521, '季边', '2024521', '15125646400', '1', '共青团员', '语言文化学院', 13, '24葡萄牙语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024523, '张定', '2024523', '15125646484', '1', '共青团员', '语言文化学院', 15, '24俄语德语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024525, '卢依', '2024525', '15125646576', '0', '共青团员', '语言文化学院', 17, '24捷克语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024527, '金中依', '2024527', '15125646676', '1', '共青团员', '语言文化学院', 19, '24波兰语1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024529, '陈际国', '2024529', '15125646784', '0', '共青团员', '语言文化学院', 21, '24汉语言1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024530, '张和', '2024530', '15125646841', '0', '共青团员', '国商学院', 23, '24国际经济与贸易1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024532, '章际约', '2024532', '15125646961', '0', '共青团员', '国商学院', 25, '24国际商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024534, '季中双', '2024534', '151256461089', '0', '共青团员', '国商学院', 27, '24金融工程1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024536, '林际', '2024536', '151256461225', '0', '共青团员', '国商学院', 29, '24电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024538, '卢中中', '2024538', '151256461369', '1', '共青团员', '国商学院', 31, '24跨境电子商务1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024540, '王际边', '2024540', '151256469', '1', '共青团员', '国商学院', 33, '24计算机科学与技术1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024550, '陈协协', '2024550', '1512564616', '0', '共青团员', '教育学院', 35, '24小学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024570, '陈协', '2024570', '1512564636', '1', '共青团员', '教育学院', 37, '24学前教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2024590, '陈际边', '2024590', '1512564664', '1', '共青团员', '教育学院', 39, '24科学教育1班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025105, '陈府', '2025105', '1512564616', '0', '共青团员', '语言文化学院', 2, '25英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025107, '章拿', '2025107', '1512564636', '1', '共青团员', '语言文化学院', 4, '25商务英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025109, '陈拿', '2025109', '1512564664', '0', '共青团员', '语言文化学院', 6, '25翻译2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025111, '林政', '2025111', '15125646100', '0', '共青团员', '语言文化学院', 8, '25西班牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025113, '王加', '2025113', '15125646144', '1', '共青团员', '语言文化学院', 10, '25法语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025115, '张媒', '2025115', '15125646196', '0', '共青团员', '语言文化学院', 12, '25意大利语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025117, '林府', '2025117', '15125646256', '0', '共青团员', '语言文化学院', 14, '25葡萄牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025119, '王和', '2025119', '15125646324', '1', '共青团员', '语言文化学院', 16, '25俄语德语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025121, '张加客', '2025121', '15125646400', '1', '共青团员', '语言文化学院', 18, '25捷克语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025123, '王客个', '2025123', '15125646484', '1', '共青团员', '语言文化学院', 20, '25波兰语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025125, '李拿个', '2025125', '15125646576', '0', '共青团员', '语言文化学院', 22, '25汉语言2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025127, '卢政别', '2025127', '15125646676', '1', '共青团员', '国商学院', 24, '25国际经济与贸易2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025129, '王客基', '2025129', '15125646784', '0', '共青团员', '国商学院', 26, '25国际商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025131, '张客和', '2025131', '15125646900', '0', '共青团员', '国商学院', 28, '25金融工程2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025133, '章大大', '2025133', '151256461024', '1', '共青团员', '国商学院', 30, '25电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025135, '陈客府', '2025135', '151256461156', '1', '共青团员', '国商学院', 32, '25跨境电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025137, '李基和', '2025137', '151256461296', '0', '共青团员', '国商学院', 34, '25计算机科学与技术2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025139, '金加基', '2025139', '151256461444', '1', '共青团员', '教育学院', 36, '25小学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025202, '方关加', '2025202', '151256461', '1', '共青团员', '教育学院', 38, '25学前教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025204, '章关定', '2025204', '151256469', '1', '共青团员', '教育学院', 40, '25科学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025206, '章定加', '2025206', '1512564625', '0', '共青团员', '教育学院', 42, '25数学与应用数学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025208, '张相反', '2025208', '1512564649', '1', '共青团员', '文化和旅游学院', 44, '25旅游管理2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025210, '金相边', '2025210', '1512564681', '1', '共青团员', '文化和旅游学院', 46, '25会展经济与管理2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025212, '方严相', '2025212', '15125646121', '1', '共青团员', '艺术学院', 48, '25音乐学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025214, '李关协', '2025214', '15125646169', '1', '共青团员', '艺术学院', 50, '25美术学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025216, '季双协', '2025216', '15125646225', '1', '共青团员', '艺术学院', 52, '25艺术与科技2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025218, '林相双', '2025218', '15125646289', '1', '共青团员', '语言文化学院', 2, '25英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025220, '张重关', '2025220', '15125646361', '1', '共青团员', '语言文化学院', 4, '25商务英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025222, '金反相', '2025222', '15125646441', '0', '共青团员', '语言文化学院', 6, '25翻译2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025224, '张协双', '2025224', '15125646529', '1', '共青团员', '语言文化学院', 8, '25西班牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025226, '王双严', '2025226', '15125646625', '0', '共青团员', '语言文化学院', 10, '25法语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025228, '方关严', '2025228', '15125646729', '0', '共青团员', '语言文化学院', 12, '25意大利语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025230, '金加违', '2025230', '15125646841', '0', '共青团员', '语言文化学院', 14, '25葡萄牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025232, '季重中', '2025232', '15125646961', '0', '共青团员', '语言文化学院', 16, '25俄语德语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025234, '方违边', '2025234', '151256461089', '0', '共青团员', '语言文化学院', 18, '25捷克语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025237, '章违相', '2025237', '151256461296', '1', '共青团员', '语言文化学院', 20, '25波兰语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025239, '陈加重', '2025239', '151256461444', '0', '共青团员', '语言文化学院', 22, '25汉语言2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025301, '陈协和', '2025301', '151256460', '0', '共青团员', '国商学院', 24, '25国际经济与贸易2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025303, '陈中双', '2025303', '151256464', '1', '共青团员', '国商学院', 26, '25国际商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025305, '陈际加', '2025305', '1512564616', '0', '共青团员', '国商学院', 28, '25金融工程2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025307, '季协际', '2025307', '1512564636', '1', '共青团员', '国商学院', 30, '25电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025309, '李际公', '2025309', '1512564664', '0', '共青团员', '国商学院', 32, '25跨境电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025311, '李依依', '2025311', '15125646100', '0', '共青团员', '国商学院', 34, '25计算机科学与技术2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025313, '林公中', '2025313', '15125646144', '1', '共青团员', '教育学院', 36, '25小学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025315, '王公公', '2025315', '15125646196', '0', '共青团员', '教育学院', 38, '25学前教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025317, '林关中', '2025317', '15125646256', '0', '共青团员', '教育学院', 40, '25科学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025319, '季中关', '2025319', '15125646324', '0', '共青团员', '教育学院', 42, '25数学与应用数学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025321, '方加', '2025321', '15125646400', '0', '共青团员', '文化和旅游学院', 44, '25旅游管理2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025323, '李关', '2025323', '15125646484', '0', '共青团员', '文化和旅游学院', 46, '25会展经济与管理2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025325, '王定', '2025325', '15125646576', '1', '共青团员', '艺术学院', 48, '25音乐学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025327, '季国', '2025327', '15125646676', '0', '共青团员', '艺术学院', 50, '25美术学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025329, '金中', '2025329', '15125646784', '1', '共青团员', '艺术学院', 52, '25艺术与科技2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025331, '方公', '2025331', '15125646900', '1', '共青团员', '语言文化学院', 2, '25英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025333, '王和', '2025333', '151256461024', '1', '共青团员', '语言文化学院', 4, '25商务英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025335, '陈公', '2025335', '151256461156', '1', '共青团员', '语言文化学院', 6, '25翻译2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025337, '林中', '2025337', '151256461296', '0', '共青团员', '语言文化学院', 8, '25西班牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025339, '金公', '2025339', '151256461444', '0', '共青团员', '语言文化学院', 10, '25法语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025401, '方依加', '2025401', '151256460', '0', '共青团员', '语言文化学院', 12, '25意大利语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025403, '章国协', '2025403', '151256464', '0', '共青团员', '语言文化学院', 14, '25葡萄牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025405, '方双边', '2025405', '1512564616', '0', '共青团员', '语言文化学院', 16, '25俄语德语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025407, '林际', '2025407', '1512564636', '1', '共青团员', '语言文化学院', 18, '25捷克语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025409, '金双双', '2025409', '1512564664', '1', '共青团员', '语言文化学院', 20, '25波兰语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025411, '方和', '2025411', '15125646100', '1', '共青团员', '语言文化学院', 22, '25汉语言2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025413, '陈国', '2025413', '15125646144', '0', '共青团员', '国商学院', 24, '25国际经济与贸易2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025415, '陈依中', '2025415', '15125646196', '0', '共青团员', '国商学院', 26, '25国际商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025417, '方公公', '2025417', '15125646256', '0', '共青团员', '国商学院', 28, '25金融工程2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025419, '李中', '2025419', '15125646324', '1', '共青团员', '国商学院', 30, '25电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025421, '季关', '2025421', '15125646400', '0', '共青团员', '国商学院', 32, '25跨境电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025423, '季定约', '2025423', '15125646484', '0', '共青团员', '国商学院', 34, '25计算机科学与技术2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025425, '林公和', '2025425', '15125646576', '0', '共青团员', '教育学院', 36, '25小学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025427, '王约', '2025427', '15125646676', '0', '共青团员', '教育学院', 38, '25学前教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025429, '金和', '2025429', '15125646784', '1', '共青团员', '教育学院', 40, '25科学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025431, '章和', '2025431', '15125646900', '0', '共青团员', '教育学院', 42, '25数学与应用数学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025433, '方际', '2025433', '151256461024', '0', '共青团员', '文化和旅游学院', 44, '25旅游管理2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025435, '陈边约', '2025435', '151256461156', '0', '共青团员', '文化和旅游学院', 46, '25会展经济与管理2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025437, '李国', '2025437', '151256461296', '1', '共青团员', '艺术学院', 48, '25音乐学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025439, '张依', '2025439', '151256461444', '0', '共青团员', '艺术学院', 50, '25美术学2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025510, '章加', '2025510', '151256460', '1', '共青团员', '艺术学院', 52, '25艺术与科技2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025511, '陈定', '2025511', '15125646100', '0', '共青团员', '语言文化学院', 2, '25英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025513, '林中依', '2025513', '15125646144', '1', '共青团员', '语言文化学院', 4, '25商务英语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025515, '金际国', '2025515', '15125646196', '0', '共青团员', '语言文化学院', 6, '25翻译2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025517, '章边', '2025517', '15125646256', '1', '共青团员', '语言文化学院', 8, '25西班牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025519, '陈协中', '2025519', '15125646324', '1', '共青团员', '语言文化学院', 10, '25法语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025520, '章双约', '2025520', '15125646361', '1', '共青团员', '语言文化学院', 12, '25意大利语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025522, '王约加', '2025522', '15125646441', '1', '共青团员', '语言文化学院', 14, '25葡萄牙语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025524, '金约定', '2025524', '15125646529', '0', '共青团员', '语言文化学院', 16, '25俄语德语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025526, '金定', '2025526', '15125646625', '0', '共青团员', '语言文化学院', 18, '25捷克语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025528, '方国双', '2025528', '15125646729', '0', '共青团员', '语言文化学院', 20, '25波兰语2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025530, '陈约', '2025530', '151256464', '1', '共青团员', '语言文化学院', 22, '25汉语言2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025531, '张约', '2025531', '15125646900', '1', '共青团员', '国商学院', 24, '25国际经济与贸易2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025533, '方双关', '2025533', '151256461024', '0', '共青团员', '国商学院', 26, '25国际商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025535, '张协', '2025535', '151256461156', '0', '共青团员', '国商学院', 28, '25金融工程2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025537, '金公双', '2025537', '151256461296', '1', '共青团员', '国商学院', 30, '25电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025539, '林加双', '2025539', '151256461444', '0', '共青团员', '国商学院', 32, '25跨境电子商务2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025540, '卢边关', '2025540', '151256461521', '0', '共青团员', '国商学院', 34, '25计算机科学与技术2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025560, '章公中', '2025560', '1512564625', '1', '共青团员', '教育学院', 36, '25小学教育2班', NULL, NULL, NULL);
INSERT INTO `t_xs` VALUES (2025580, '章中', '2025580', '1512564649', '0', '共青团员', '教育学院', 38, '25学前教育2班', NULL, NULL, NULL);

-- ----------------------------
-- Table structure for t_xy
-- ----------------------------
DROP TABLE IF EXISTS `t_xy`;
CREATE TABLE `t_xy`  (
  `XY_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院账号',
  `XY_MC` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院名称',
  `XY_MM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院密码',
  `FZR_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '负责人姓名',
  `XY_DH` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院电话',
  PRIMARY KEY (`XY_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校各学院信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_xy
-- ----------------------------
INSERT INTO `t_xy` VALUES ('100001', '语言文化学院', '100001', '100001', '0576100001');
INSERT INTO `t_xy` VALUES ('100002', '国商学院', '100002', '100002', '0576100002');
INSERT INTO `t_xy` VALUES ('100003', '教育学院', '100003', '100003', '0576100003');
INSERT INTO `t_xy` VALUES ('100004', '文化和旅游学院', '100004', '100004', '0576100004');
INSERT INTO `t_xy` VALUES ('100005', '艺术学院', '100005', '100005', '0576100005');
INSERT INTO `t_xy` VALUES ('100006', '马克思主义学院', '100006', '100006', '0576100006');

-- ----------------------------
-- Table structure for t_zy
-- ----------------------------
DROP TABLE IF EXISTS `t_zy`;
CREATE TABLE `t_zy`  (
  `ZY_BH` varchar(2) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '专业编号',
  `ZY_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '专业名称',
  `ZY_XK` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学科',
  `ZY_XZ` int NOT NULL COMMENT '学制',
  `XYZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院编号',
  `SS_XY` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '所属学院名称',
  PRIMARY KEY (`ZY_BH`) USING BTREE,
  INDEX `FK_ZY_XY`(`XYZH` ASC) USING BTREE,
  CONSTRAINT `FK_ZY_XY` FOREIGN KEY (`XYZH`) REFERENCES `t_xy` (`XY_ZH`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校各专业信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_zy
-- ----------------------------
INSERT INTO `t_zy` VALUES ('01', '英语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('02', '商务英语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('03', '翻译', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('04', '西班牙语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('05', '法语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('06', '意大利语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('07', '葡萄牙语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('08', '俄语德语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('09', '捷克语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('10', '波兰语', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('11', '汉语言', '语言', 4, '100001', '语言文化学院');
INSERT INTO `t_zy` VALUES ('12', '国际经济与贸易', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('13', '国际商务', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('14', '金融工程', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('15', '电子商务', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('16', '跨境电子商务', '商学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('17', '计算机科学与技术', '工学', 4, '100002', '国商学院');
INSERT INTO `t_zy` VALUES ('18', '小学教育', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('19', '学前教育', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('20', '科学教育', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('21', '数学与应用数学', '教育学', 4, '100003', '教育学院');
INSERT INTO `t_zy` VALUES ('22', '旅游管理', '管理学', 4, '100004', '文化和旅游学院');
INSERT INTO `t_zy` VALUES ('23', '会展经济与管理', '管理学', 4, '100004', '文化和旅游学院');
INSERT INTO `t_zy` VALUES ('24', '音乐学', '艺术', 4, '100005', '艺术学院');
INSERT INTO `t_zy` VALUES ('25', '美术学', '艺术', 4, '100005', '艺术学院');
INSERT INTO `t_zy` VALUES ('26', '艺术与科技', '艺术', 4, '100005', '艺术学院');

-- ----------------------------
-- Table structure for t_zyhd
-- ----------------------------
DROP TABLE IF EXISTS `t_zyhd`;
CREATE TABLE `t_zyhd`  (
  `HD_BH` int NOT NULL AUTO_INCREMENT COMMENT '活动编号',
  `HD_MC` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动名称',
  `BM_KSSJ` datetime NULL DEFAULT NULL COMMENT '报名开始时间',
  `BM_JSSJ` datetime NULL DEFAULT NULL COMMENT '报名结束时间',
  `HD_KSSJ` datetime NULL DEFAULT NULL COMMENT '活动开始时间',
  `HD_JSSJ` datetime NULL DEFAULT NULL COMMENT '活动结束时间',
  `HD_NR` text CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL COMMENT '活动内容',
  `HD_DD` varchar(500) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动地点',
  `ZM_RS` int NULL DEFAULT 0 COMMENT '招募人数(整数)',
  `YBM_RS` int NULL DEFAULT 0 COMMENT '已报名人数(缓存字段)',
  `BBH` int NULL DEFAULT 0 COMMENT '乐观锁版本号(VERSION)',
  `HD_BQ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动类别标签(用于匹配兴趣)',
  `JN_YQ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '技能要求标签(用于匹配技能)',
  `ZY_XZ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '专业限制(用于匹配专业,空则不限)',
  `HDXQ` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动需求条件(文本)',
  `HD_BZ` varchar(1000) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动保障',
  `HD_FQ_DW` varchar(100) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动发起单位',
  `HD_ZT` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动状态：未开始；报名中；进行中；已结束',
  PRIMARY KEY (`HD_BH`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 39 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '志愿活动信息表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_zyhd
-- ----------------------------
INSERT INTO `t_zyhd` VALUES (1, '审核评估志愿者', '2026-02-05 14:00:00', '2026-02-07 14:00:00', '2026-02-08 14:00:00', '2026-02-08 16:00:00', '保障审核评估前期工作顺利开展', '浙江外国语学院', 4, 0, 0, '校园建设', NULL, NULL, '无', '无', '教学辅助单位', '未开始');
INSERT INTO `t_zyhd` VALUES (2, '体质健康测试志愿者', '2026-01-20 08:00:00', '2026-01-22 08:00:00', '2026-01-23 08:00:00', '2026-02-03 17:00:00', '协助体育教师完成体质健康测试相关测试工作', '浙江外国语学院', 42, 0, 0, '校园建设', NULL, NULL, '无', '包一顿工作餐', '体育部', '未开始');
INSERT INTO `t_zyhd` VALUES (3, '心晴驿站新生打卡活动志愿者', '2025-12-26 11:00:00', '2025-12-28 11:00:00', '2025-12-29 11:00:00', '2026-01-02 18:00:00', '负责心晴驿站的新生引导与礼品发放', '浙江外国语学院·心晴驿站', 20, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '未开始');
INSERT INTO `t_zyhd` VALUES (4, '教工气排球志愿者招募', '2025-12-18 12:00:00', '2025-12-20 12:00:00', '2025-12-21 12:00:00', '2025-12-29 14:00:00', '教工气排球赛事志愿服务（场地引导、秩序协助等）', '浙江外国语学院（校内）', 27, 0, 0, '赛会服务', NULL, NULL, '无', '无', '体育部', '未开始');
INSERT INTO `t_zyhd` VALUES (5, '健步走志愿者招募', '2026-03-03 08:00:00', '2026-03-05 08:00:00', '2026-03-06 08:00:00', '2026-03-06 12:00:00', '健步走活动现场志愿服务（签到引导、秩序维护、物资协助等）', '浙江外国语学院（校内）', 10, 0, 0, '赛会服务', NULL, NULL, '无', '无', '体育部', '未开始');
INSERT INTO `t_zyhd` VALUES (6, '心理访谈引导志愿者（3日）', '2026-01-05 09:00:00', '2026-01-07 09:00:00', '2026-01-08 09:00:00', '2026-01-10 20:00:00', '负责心晴驿站的引导与礼品发放', '浙江外国语学院·心晴驿站', 3, 0, 0, '校园建设', NULL, NULL, '无', '无', '教育学院', '未开始');
INSERT INTO `t_zyhd` VALUES (7, '两河会议志愿者招募', '2026-02-11 11:00:00', '2026-02-13 11:00:00', '2026-02-14 11:00:00', '2026-02-14 20:00:00', '协助会议场地布置、会议进行、路线指引等岗位', '浙江外国语学院（校内）', 17, 0, 0, '赛会服务', NULL, NULL, '无', '无', '文化和旅游学院', '未开始');
INSERT INTO `t_zyhd` VALUES (8, '心晴驿站打卡志愿者招募（第一期）', '2026-02-13 11:00:00', '2026-02-15 11:00:00', '2026-02-16 11:00:00', '2026-02-20 18:00:00', '负责心晴驿站的引导与礼品发放', '浙江外国语学院·雅正4楼下心晴驿站', 30, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '未开始');
INSERT INTO `t_zyhd` VALUES (9, '迷你马拉松礼包分装志愿活动', '2025-12-20 10:00:00', '2025-12-22 10:00:00', '2025-12-23 10:00:00', '2025-12-23 12:00:00', '进行迷你马拉松礼包分装', '浙江外国语学院', 20, 0, 0, '赛会服务', NULL, NULL, '无', '无', '服务保障单位', '未开始');
INSERT INTO `t_zyhd` VALUES (10, '心理访谈引导志愿者（2日）', '2026-02-10 09:00:00', '2026-02-12 09:00:00', '2026-02-13 09:00:00', '2026-02-14 16:00:00', '心理访谈引导相关志愿服务', '浙江外国语学院·心晴驿站', 5, 0, 0, '校园建设', NULL, NULL, '无', '无', '教育学院', '未开始');
INSERT INTO `t_zyhd` VALUES (11, '第五届全球外国语大学联盟校长论坛暨协作组年会志愿服务', '2026-02-27 08:00:00', '2026-03-01 08:00:00', '2026-03-02 08:00:00', '2026-03-05 18:00:00', '外宾接机/抵离、信息咨询、语言服务、场内引导、嘉宾1V1接待等', '浙江外国语学院（校内及校外会场）', 118, 0, 0, '赛会服务', '英语翻译', NULL, '浙江外国语学院全日制在校生至政治立场坚定，遵纪守法至年满18周岁至形象气质良好、身心健康至沟通协调能力强，英语口语流利（非中国国籍志愿者需具备基本汉语交流能力）至可全程参加培训及活动。', '提供岗前培训', '国际交流合作处', '未开始');
INSERT INTO `t_zyhd` VALUES (12, '会议志愿者招募（2日）', '2025-12-23 09:00:00', '2025-12-25 09:00:00', '2025-12-26 09:00:00', '2025-12-27 10:00:00', '协助会议进行（签到/引导/会务协助等）', '浙江外国语学院（校内）', 6, 0, 0, '校园建设', NULL, NULL, '无', '无', '学校办公室', '未开始');
INSERT INTO `t_zyhd` VALUES (13, '运动会志愿者招募', '2026-02-02 08:00:00', '2026-02-04 08:00:00', '2026-02-05 08:00:00', '2026-02-05 18:00:00', '协助运动会进行（检录、场地秩序、物资、引导等）', '浙江外国语学院（校内）', 245, 0, 0, '赛会服务', '急救技能', NULL, '无', '无', '体育部', '未开始');
INSERT INTO `t_zyhd` VALUES (14, '心晴驿站打卡志愿者招募（第二期）', '2026-02-20 11:00:00', '2026-02-22 11:00:00', '2026-02-23 11:00:00', '2026-02-27 18:00:00', '负责心晴驿站的引导与礼品发放', '浙江外国语学院·雅正4楼下心晴驿站', 20, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '未开始');
INSERT INTO `t_zyhd` VALUES (15, '中国拉丁美洲学会年会暨“中拉关系：新机遇、新挑战”研讨会志愿服务', '2025-12-22 08:00:00', '2025-12-24 08:00:00', '2025-12-25 08:00:00', '2025-12-26 18:00:00', '接待联系嘉宾、会场布置、入场签到等', '杭州（会议会场）', 15, 0, 0, '赛会服务', '英语翻译', '西班牙语,葡萄牙语', '无', '无', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (16, '离退休人员返校活动志愿者招募', '2026-02-01 08:00:00', '2026-02-03 08:00:00', '2026-02-04 08:00:00', '2026-02-04 12:00:00', '协助开展老年趣味活动及维持秩序、校园内引导、老同志帮扶', '浙江外国语学院', 12, 0, 0, '敬老助残', NULL, NULL, '无', '无', '党群组织', '未开始');
INSERT INTO `t_zyhd` VALUES (17, '杭州某国际会议志愿服务', '2026-02-16 08:00:00', '2026-02-18 08:00:00', '2026-02-19 08:00:00', '2026-02-21 20:00:00', '外宾接待、语言协助、会场引导、信息咨询、嘉宾入住办理等', '杭州市余杭区（室内为主）', 60, 0, 0, '赛会服务', '英语翻译', '英语,法语,西班牙语,阿拉伯语', '浙江外国语学院全日制在校生至政治立场坚定，遵纪守法至年满18周岁至形象气质良好、身心健康至沟通协调能力强，能使用相应语种有效沟通至可全程参加培训及活动。优先：大型国际赛会志愿经验至党员/预备党员/团员/优秀学生骨干。', '提供岗前培训', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (18, '开学典礼筹备志愿者招募', '2026-03-01 16:00:00', '2026-03-03 16:00:00', '2026-03-04 16:00:00', '2026-03-04 18:00:00', '在行健馆贴座椅背贴', '浙江外国语学院·行健馆', 40, 0, 0, '校园建设', NULL, NULL, '无', '无', '学校办公室', '未开始');
INSERT INTO `t_zyhd` VALUES (19, '开学报到润院打卡点引导互动志愿者招募', '2025-12-31 08:00:00', '2026-01-02 08:00:00', '2026-01-03 08:00:00', '2026-01-03 16:00:00', '打卡点引导、信息咨询解答、互动氛围营造、协助应急处理', '浙江外国语学院·润院', 4, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '未开始');
INSERT INTO `t_zyhd` VALUES (20, '铁路杭州西站志愿服务', '2026-01-06 08:00:00', '2026-01-08 18:00:00', '2026-01-09 08:00:00', '2026-01-16 16:00:00', '站内引导、咨询、秩序维护等志愿服务', '杭州西站', 10, 0, 0, '赛会服务', NULL, NULL, '着装得体（不穿奇装异服/不适合运动鞋）至仪容仪表规范（男生不留胡须，女生长发扎马尾，不染彩发，不涂有色指甲油）至性格外向，有领导能力至精神面貌良好，有一定志愿服务经历。', '提供中餐、饮用水、点心及防暑降温物资至服务满3天及以上提供交通补贴30元/天至服务满3天可开具社会实践证明至岗位均为室内。', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (21, '全国数字贸易大赛跨境电商直播赛道总决赛志愿服务', '2026-01-12 14:00:00', '2026-01-14 14:00:00', '2026-01-15 14:00:00', '2026-01-17 18:00:00', '设备组：场地布置、设备监控与紧急维修至\n接待联络组：报到、参观引导、嘉宾与参赛者引导、答疑至\n考务组：签到抽签、候赛与比赛组织、场地引导、评委嘉宾服务至\n会务组：物料准备、赛区封闭及人员进出控制。', '浙江外国语学院（校内）', 30, 0, 0, '赛会服务', '计算机维修', '计算机科学与技术,电子商务', '无', '无', '国商学院', '未开始');
INSERT INTO `t_zyhd` VALUES (22, '迎新志愿者招募', '2026-01-31 06:00:00', '2026-02-02 06:00:00', '2026-02-03 06:00:00', '2026-02-03 19:00:00', '协助迎新工作顺利展开（站点引导、物资/行李协助、信息咨询等）', '浙江外国语学院各迎新点（屏峰地铁站、正大门、西门、西北门、小北门、行健馆、望A、各寝室楼、小推车服务点等）', 213, 0, 0, '校园建设', NULL, NULL, '无', '无', '学生处', '未开始');
INSERT INTO `t_zyhd` VALUES (23, '世界互联网大会乌镇峰会志愿者招募', '2026-01-15 08:00:00', '2026-01-17 08:00:00', '2026-01-18 08:00:00', '2026-01-22 18:00:00', '峰会期间承担接待、引导、咨询等志愿服务', '浙江省嘉兴市桐乡乌镇', 40, 0, 0, '赛会服务', '英语翻译', NULL, '省内高校全日制在读学生至自愿参加志愿服务至遵纪守法无违法犯罪记录至18周岁以上，身心健康至可参加会前培训至服从调剂与岗位安排并遵守纪律至至少熟练运用一门外语进行交流（VIP接待外宾）。', '能开公假，食宿统一负责', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (24, '第五届世界生物圈保护区大会志愿服务', '2026-01-24 08:00:00', '2026-01-26 08:00:00', '2026-01-27 08:00:00', '2026-02-01 18:00:00', '外宾接机/抵离、信息咨询、语言服务、场内引导、嘉宾接待等', '杭州（会场及相关点位）', 50, 0, 0, '赛会服务', '英语翻译', '法语,西班牙语', '浙江外国语学院全日制在校生至政治立场坚定、遵纪守法至年满18周岁至形象气质良好、身心健康至沟通协调能力强，英语口语流利，具备中英文写作能力（非中国国籍志愿者需较好汉语交流能力）至可全程参加培训及活动。优先：大型国际赛会志愿经验至法语/西班牙语等小语种特长至党员/预备党员/团员/优秀学生骨干至服务期间全勤。', '可请公假至提供岗前培训', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (25, '学院毕业典礼志愿者招募', '2026-02-26 10:00:00', '2026-02-28 10:00:00', '2026-03-01 10:00:00', '2026-03-01 12:00:00', '整理毕业证书壳子、搬运宣传物料、布置场地、引导进场等', '浙江外国语学院（校内）', 30, 0, 0, '校园建设', NULL, NULL, '优先：有车（汽车/电驴）的同学、男性同学。', '无', '语言文化学院', '未开始');
INSERT INTO `t_zyhd` VALUES (26, '毕业典礼布置志愿者招募', '2025-12-27 09:00:00', '2025-12-29 09:00:00', '2025-12-30 09:00:00', '2025-12-30 12:00:00', '座椅到位后分类粘贴椅背贴，检查椅子无破损', '浙江外国语学院（校内）', 40, 0, 0, '校园建设', NULL, NULL, '无', '无', '服务保障单位', '未开始');
INSERT INTO `t_zyhd` VALUES (27, '创新创业文化节志愿服务', '2026-02-12 15:00:00', '2026-02-14 15:00:00', '2026-02-15 15:00:00', '2026-02-16 18:00:00', '摊位布置与秩序维护、游客引导与活动讲解、后勤保障工作', '浙江外国语学院（校内，具体地点另行通知）', 20, 0, 0, '校园建设', NULL, NULL, '热情开朗，有服务意识至责任心强，能按时到岗至对宋韵文化或创新创业活动感兴趣者优先。', '无', '国商学院', '未开始');
INSERT INTO `t_zyhd` VALUES (28, '三进大会志愿服务', '2025-12-24 14:00:00', '2025-12-26 14:00:00', '2025-12-27 14:00:00', '2025-12-28 18:00:00', '引导参会人员到校及校内行程指引至协助签到、礼仪、茶歇、会场布置等', '浙江外国语学院及相关酒店会场', 75, 0, 0, '赛会服务', '礼仪接待', NULL, '确保全程参与至对校园足够熟悉便于引导至服从安排、有志愿服务精神至外向灵活者优先，最好具备一定领导能力。', '无', '马克思主义学院', '未开始');
INSERT INTO `t_zyhd` VALUES (29, '三位一体活动志愿者招募', '2025-12-30 06:00:00', '2026-01-01 06:00:00', '2026-01-02 06:00:00', '2026-01-02 17:00:00', '协助三位一体活动顺利进行（考场引导、秩序维护、物资与信息协助等）', '浙江外国语学院', 72, 0, 0, '校园建设', NULL, NULL, '无', '提供岗前培训', '教务处', '未开始');
INSERT INTO `t_zyhd` VALUES (30, '简历门诊与职业规划咨询活动志愿者招募', '2026-02-21 13:00:00', '2026-02-23 13:00:00', '2026-02-24 13:00:00', '2026-02-24 16:00:00', '记录学生咨询内容并统计数量至回收导师易拉宝至活动前协助点位引导与布置至活动中待命处理临时情况。', '浙江外国语学院', 6, 0, 0, '校园建设', '新闻写作', NULL, '无', '无', '行政部门', '未开始');
INSERT INTO `t_zyhd` VALUES (31, '中国体外诊断（IVD）产业发展大会志愿服务', '2026-01-19 07:00:00', '2026-01-21 16:00:00', '2026-01-22 07:00:00', '2026-01-23 19:00:00', '咨询、指引', '杭州大会展中心及周边', 10, 0, 0, '赛会服务', '英语翻译', NULL, '英语口语流畅', '无', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (32, '献血活动志愿者招募（5人）', '2026-02-22 10:00:00', '2026-02-24 10:00:00', '2026-02-25 10:00:00', '2026-02-25 13:00:00', '维持秩序、协助医护人员、发放物资', '浙江外国语学院·雅正四楼下花坛处', 5, 0, 0, '社区服务', NULL, NULL, '无', '无', '服务保障单位', '未开始');
INSERT INTO `t_zyhd` VALUES (33, '雷锋月姚缘社区志愿服务', '2026-01-07 13:00:00', '2026-01-09 13:00:00', '2026-01-10 13:00:00', '2026-01-10 16:00:00', '书籍整理归类与打包', '姚缘社区（杭州）', 5, 0, 0, '社区服务', NULL, NULL, '无', '无', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (34, '春运铁路杭州站志愿服务', '2026-01-21 08:00:00', '2026-01-23 08:00:00', '2026-01-24 08:00:00', '2026-02-06 16:00:00', '站内引导、咨询、秩序维护等', '杭州站', 5, 0, 0, '赛会服务', NULL, NULL, '着装得体（不穿无袖/裙子/短裤/打底裤/破洞裤/花裤等，不穿凉鞋拖鞋高跟鞋等）至仪容仪表规范（前不遮眉、侧不掩耳、后不及领至男生不留胡须至女生长发马尾至不染彩发至不涂有色指甲油至不浓妆不戴多余饰品）至外向、有领导能力至精神面貌良好、有志愿服务经历。', '交通补贴30元/天至提供中餐、点心和水至服务满3天及以上可盖寒假社会实践证明章至提供暖宝宝、围巾、手套等保暖用品。', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (35, '垃圾分类宣传短片拍摄志愿者招募', '2026-01-13 13:00:00', '2026-01-15 13:00:00', '2026-01-16 13:00:00', '2026-01-16 15:00:00', '参与完成“垃圾大作战”垃圾分类宣传短片拍摄', '浙江外国语学院·大操场', 20, 0, 0, '环境保护', '摄影摄像', '艺术与科技', '无', '无', '艺术学院', '未开始');
INSERT INTO `t_zyhd` VALUES (36, '献血活动志愿者招募（6人）', '2025-12-11 10:00:00', '2025-12-13 10:00:00', '2025-12-14 10:00:00', '2025-12-14 13:00:00', '协助献血活动开展，引导献血学生，协助医务人员工作', '浙江外国语学院·雅正四楼下花坛处', 6, 0, 0, '社区服务', NULL, NULL, '无', '无', '服务保障单位', '未开始');
INSERT INTO `t_zyhd` VALUES (37, '余杭区国际会议志愿服务', '2026-01-08 08:00:00', '2026-01-10 08:00:00', '2026-01-11 08:00:00', '2026-01-14 20:00:00', '国内外嘉宾抵离服务、信息咨询、语言服务、场内引导等志愿服务', '杭州（余杭区会场）', 50, 0, 0, '赛会服务', '英语翻译', '英语,商务英语', '年满18周岁至形象气质良好、身心健康至沟通协调能力强，英语口语流利，具备中英文写作能力（非中国国籍志愿者需具备基本汉语交流能力）至要求全勤上岗，需请假至少提前3天告知负责人。', '无', '国志协', '未开始');
INSERT INTO `t_zyhd` VALUES (38, '校友返校日1对1接待志愿者招募', '2025-12-07 09:00:00', '2025-12-27 16:00:00', '2025-12-28 09:00:00', '2025-12-28 17:00:00', '提前联络校友并确认抵离信息至引导校友参与不同活动至作为观众参与校友会活动至对接用餐至确认离校时间并收尾。', '浙江外国语学院（校内）', 35, 0, 0, '赛会服务', '礼仪接待', NULL, '无', '无', '党群组织', '报名中');

-- ----------------------------
-- Table structure for t_zyhdbmb
-- ----------------------------
DROP TABLE IF EXISTS `t_zyhdbmb`;
CREATE TABLE `t_zyhdbmb`  (
  `ID` int NOT NULL AUTO_INCREMENT,
  `XS_XH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '学生学号',
  `XS_XM` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '学生姓名',
  `SS_XY` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '所属学院',
  `HD_BH` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '活动编号',
  `HD_MC` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '已报名活动名称',
  `HD_SJ` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '已报名活动的活动时间(快照)',
  `HD_DD` varchar(255) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '已报名活动的活动点',
  `BM_ZT` varchar(10) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '报名状态：0-未审核 1-已审核通过 2-已拒绝',
  `QD_SJ` datetime NULL DEFAULT NULL COMMENT '签到时间',
  `QT_SJ` datetime NULL DEFAULT NULL COMMENT '签退时间',
  `QD_ZT` int NULL DEFAULT 0 COMMENT '考勤状态: 0-未签 1-正常 2-迟到 3-缺勤',
  `HD_SC` int NULL DEFAULT NULL COMMENT '参与活动时长',
  `HD_XF` int NULL DEFAULT NULL COMMENT '获得学分',
  `ZYZ_PJ` varchar(200) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NULL DEFAULT NULL COMMENT '志愿者评价',
  `PF` int NULL DEFAULT 0 COMMENT '评分(1-5分, 用于协同过滤)',
  PRIMARY KEY (`ID`) USING BTREE
) ENGINE = InnoDB AUTO_INCREMENT = 2 CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '志愿活动报名表' ROW_FORMAT = Dynamic;

-- ----------------------------
-- Records of t_zyhdbmb
-- ----------------------------
INSERT INTO `t_zyhdbmb` VALUES (1, '2024104', '李胜男', '语言文化学院', '38', '校友返校日1对1接待志愿者招募', '2025-12-28 09:00-17:00', '浙江外国语学院（校内）', '未审核', NULL, NULL, 0, NULL, NULL, NULL, 0);

-- ----------------------------
-- View structure for academies
-- ----------------------------
DROP VIEW IF EXISTS `academies`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `academies` AS select `t_xy`.`XYBH` AS `academy_id`,`t_xy`.`XYMC` AS `academy_name` from `t_xy`;

-- ----------------------------
-- View structure for activity_registration
-- ----------------------------
DROP VIEW IF EXISTS `activity_registration`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `activity_registration` AS select `t_zyhdbm`.`XSXH` AS `student_id`,`t_zyhdbm`.`HDBH` AS `activity_id`,`t_zyhdbm`.`HDSC` AS `duration_hours`,`t_zyhdbm`.`BMSJ` AS `register_time`,`t_zyhdbm`.`BMZT` AS `registration_status`,`t_zyhdbm`.`HDPJ` AS `evaluation` from `t_zyhdbm`;

-- ----------------------------
-- View structure for classes
-- ----------------------------
DROP VIEW IF EXISTS `classes`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `classes` AS select `t_bj`.`BJBH` AS `class_id`,`t_bj`.`BJMC` AS `class_name`,`t_bj`.`ZYBH` AS `major_id`,`t_bj`.`SSNJ` AS `grade_year` from `t_bj`;

-- ----------------------------
-- View structure for departments
-- ----------------------------
DROP VIEW IF EXISTS `departments`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `departments` AS select `t_bm`.`BMBH` AS `dept_id`,`t_bm`.`BMMC` AS `dept_name`,`t_bm`.`BMLX` AS `dept_type`,`t_bm`.`FZRXM` AS `manager_name`,`t_bm`.`FZRMM` AS `manager_password`,`t_bm`.`FZRDH` AS `manager_phone` from `t_bm`;

-- ----------------------------
-- View structure for majors
-- ----------------------------
DROP VIEW IF EXISTS `majors`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `majors` AS select `t_zy`.`ZYBH` AS `major_id`,`t_zy`.`ZYMC` AS `major_name`,`t_zy`.`ZYXK` AS `major_subject`,`t_zy`.`ZYXZ` AS `major_attr`,`t_zy`.`BMBH` AS `dept_id` from `t_zy`;

-- ----------------------------
-- View structure for school_officers
-- ----------------------------
DROP VIEW IF EXISTS `school_officers`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `school_officers` AS select `t_xjfzr`.`XJFZRZH` AS `officer_username`,`t_xjfzr`.`XJFZRMM` AS `officer_password`,`t_xjfzr`.`XJFZRXM` AS `officer_name` from `t_xjfzr`;

-- ----------------------------
-- View structure for students
-- ----------------------------
DROP VIEW IF EXISTS `students`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `students` AS select `t_xs`.`XSXH` AS `student_id`,`t_xs`.`XSXM` AS `student_name`,`t_xs`.`XSMM` AS `password`,`t_xs`.`LXDH` AS `phone`,`t_xs`.`XSXB` AS `gender`,`t_xs`.`ZZMM` AS `political_status`,`t_xs`.`XYBH` AS `academy_id`,`t_xs`.`BJBH` AS `class_id`,`t_xs`.`XQ_BQ` AS `interest_tags`,`t_xs`.`JN_BQ` AS `skill_tags`,`t_xs`.`GXQK` AS `bio` from `t_xs`;

-- ----------------------------
-- View structure for sys_admins
-- ----------------------------
DROP VIEW IF EXISTS `sys_admins`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `sys_admins` AS select `t_xtgly`.`XTGLYZH` AS `admin_username`,`t_xtgly`.`XTGLYMM` AS `admin_password`,`t_xtgly`.`XTGLYXM` AS `admin_name` from `t_xtgly`;

-- ----------------------------
-- View structure for view_students
-- ----------------------------
DROP VIEW IF EXISTS `view_students`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `view_students` AS select `t_xs`.`XS_XH` AS `student_id`,`t_xs`.`XS_XM` AS `student_name` from `t_xs`;

-- ----------------------------
-- View structure for volunteer_activity
-- ----------------------------
DROP VIEW IF EXISTS `volunteer_activity`;
CREATE ALGORITHM = UNDEFINED SQL SECURITY DEFINER VIEW `volunteer_activity` AS select `t_zyhd`.`HDBH` AS `activity_id`,`t_zyhd`.`HDMC` AS `activity_name`,`t_zyhd`.`HDLX` AS `activity_type`,`t_zyhd`.`KSSJ` AS `start_time`,`t_zyhd`.`HDSC` AS `duration_hours`,`t_zyhd`.`XYRS` AS `capacity`,`t_zyhd`.`JZSJ` AS `deadline`,`t_zyhd`.`BMBH` AS `dept_id`,`t_zyhd`.`HDZT` AS `status`,`t_zyhd`.`HDDD` AS `location`,`t_zyhd`.`HDMS` AS `description`,`t_zyhd`.`HDBQ` AS `tags`,`t_zyhd`.`HDTP` AS `image_url` from `t_zyhd`;

SET FOREIGN_KEY_CHECKS = 1;
