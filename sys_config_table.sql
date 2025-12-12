-- ----------------------------
-- 新增表：系统配置表 (sys_config)
-- 用于存储大屏的标题、公告、开关状态、目标数值等
-- ----------------------------
DROP TABLE IF EXISTS `sys_config`;
CREATE TABLE `sys_config` (
  `config_id` int NOT NULL AUTO_INCREMENT COMMENT '配置ID',
  `config_key` varchar(100) NOT NULL COMMENT '配置键名 (唯一标识)',
  `config_value` text COMMENT '配置键值 (可以是文本、数字或JSON)',
  `config_name` varchar(100) DEFAULT NULL COMMENT '配置中文名称 (用于前端显示)',
  `description` varchar(255) DEFAULT NULL COMMENT '描述说明',
  `update_time` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',
  PRIMARY KEY (`config_id`),
  UNIQUE KEY `uk_config_key` (`config_key`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='系统全局配置表';

-- ----------------------------
-- 初始化默认数据 (根据大屏需求预设)
-- ----------------------------
INSERT INTO `sys_config` (`config_key`, `config_value`, `config_name`, `description`) VALUES 
('dashboard_title', '高校志愿活动智能大数据平台', '大屏主标题', '大屏顶部显示的系统名称'),
('dashboard_notice', '欢迎各位领导莅临指导，本学期志愿活动火热进行中！', '大屏滚动公告', '大屏顶部的跑马灯文字'),
('goal_total_hours', '5000', '学期目标工时', '用于展示仪表盘进度的分母值'),
('show_academy_rank', 'true', '显示学院排名', '控制是否显示学院活跃度排行 (true/false)');

-- ----------------------------
-- 验证数据插入
-- ----------------------------
SELECT * FROM `sys_config`;