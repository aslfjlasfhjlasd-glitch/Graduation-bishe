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

 Date: 10/12/2025 22:10:52
*/

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

-- ----------------------------
-- Table structure for t_xy
-- ----------------------------
DROP TABLE IF EXISTS `t_xy`;
CREATE TABLE `t_xy`  (
  `XY_MC` varchar(50) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院名称',
  `XY_ZH` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院账号',
  `XY_MM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院密码',
  `FZR_XM` varchar(20) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '负责人姓名',
  `XY_DH` varchar(13) CHARACTER SET utf8mb3 COLLATE utf8mb3_general_ci NOT NULL COMMENT '学院电话',
  PRIMARY KEY (`XY_ZH`) USING BTREE
) ENGINE = InnoDB CHARACTER SET = utf8mb3 COLLATE = utf8mb3_general_ci COMMENT = '学校各学院信息表' ROW_FORMAT = DYNAMIC;

-- ----------------------------
-- Records of t_xy
-- ----------------------------
INSERT INTO `t_xy` VALUES ('语言文化学院', '100001', '100001', '张伟', '0576100001');
INSERT INTO `t_xy` VALUES ('国商学院', '100002', '100002', '赵思远', '0576100002');
INSERT INTO `t_xy` VALUES ('教育学院', '100003', '100003', '黄晓敏', '0576100003');
INSERT INTO `t_xy` VALUES ('文化和旅游学院', '100004', '100004', '刘佳', '0576100004');
INSERT INTO `t_xy` VALUES ('艺术学院', '100005', '100005', '李静怡', '0576100005');
INSERT INTO `t_xy` VALUES ('马克思主义学院', '100006', '100006', '陈铭', '0576100006');

SET FOREIGN_KEY_CHECKS = 1;
