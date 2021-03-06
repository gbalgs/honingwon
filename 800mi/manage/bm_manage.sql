/*
SQLyog 企业版 - MySQL GUI v8.14 
MySQL - 5.1.33-community-log : Database - bm_manage
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`bm_manage` /*!40100 DEFAULT CHARACTER SET utf8 */;

/*Table structure for table `bm_account` */

DROP TABLE IF EXISTS `bm_account`;

CREATE TABLE `bm_account` (
  `account_id` int(11) NOT NULL AUTO_INCREMENT,
  `account` varchar(64) NOT NULL,
  `account_pasword` varchar(32) NOT NULL,
  `account_name` varchar(256) NOT NULL COMMENT '升级根骨失败次数',
  `account_type` smallint(6) NOT NULL COMMENT '1普通用户\n            2供货商\n            4管理员\n            ',
  `account_money` int(11) NOT NULL,
  `account_level` smallint(6) NOT NULL,
  `account_state` smallint(6) NOT NULL COMMENT '开启,锁定,申请',
  `add_time` int(11) NOT NULL,
  `account_remark` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `bm_account` */

insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (1,'liaoxb','dc483e80a7a0bd9ef71d8cf973673924','廖小波',1,0,1,1,1,'ycchen');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (2,'stest','1f2de15d680024fca36c47e16f5c95d2','setset',0,0,0,99,1388655011,'set');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (3,'test','1f2de15d680024fca36c47e16f5c95d2','ss',2,0,1,99,1388655324,'set');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (4,'test','1f2de15d680024fca36c47e16f5c95d2','sees',2,0,1,0,1388655754,'set');
insert  into `bm_account`(`account_id`,`account`,`account_pasword`,`account_name`,`account_type`,`account_money`,`account_level`,`account_state`,`add_time`,`account_remark`) values (5,'12w','1f2de15d680024fca36c47e16f5c95d2','23',2,0,1,99,1388656191,'23');

/*Table structure for table `bm_account_group` */

DROP TABLE IF EXISTS `bm_account_group`;

CREATE TABLE `bm_account_group` (
  `group_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`group_id`,`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_account_group` */

insert  into `bm_account_group`(`group_id`,`account_id`) values (1,1);

/*Table structure for table `bm_account_module` */

DROP TABLE IF EXISTS `bm_account_module`;

CREATE TABLE `bm_account_module` (
  `module_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  PRIMARY KEY (`module_id`,`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_account_module` */

insert  into `bm_account_module`(`module_id`,`account_id`) values (1,1);
insert  into `bm_account_module`(`module_id`,`account_id`) values (11,1);
insert  into `bm_account_module`(`module_id`,`account_id`) values (13,1);

/*Table structure for table `bm_brand_type3` */

DROP TABLE IF EXISTS `bm_brand_type3`;

CREATE TABLE `bm_brand_type3` (
  `brand_id` int(11) NOT NULL,
  `type3_id` int(11) NOT NULL,
  PRIMARY KEY (`brand_id`,`type3_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_brand_type3` */

insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (1,1);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (1,2);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (1,3);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (1,4);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (1,8);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (2,5);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (2,6);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (2,7);
insert  into `bm_brand_type3`(`brand_id`,`type3_id`) values (2,8);

/*Table structure for table `bm_event_log` */

DROP TABLE IF EXISTS `bm_event_log`;

CREATE TABLE `bm_event_log` (
  `event_log_id` bigint(20) NOT NULL AUTO_INCREMENT,
  `account_id` varchar(64) DEFAULT NULL,
  `event_type` smallint(6) NOT NULL,
  `operate_ip` varchar(32) NOT NULL,
  `event_desc` varchar(2048) NOT NULL,
  `add_time` datetime NOT NULL,
  PRIMARY KEY (`event_log_id`)
) ENGINE=MyISAM AUTO_INCREMENT=209 DEFAULT CHARSET=utf8;

/*Data for the table `bm_event_log` */

insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (1,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2013-12-26 11:37:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (2,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2013-12-26 11:38:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (3,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2013-12-26 11:41:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (4,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:05:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (5,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:06:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (6,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:18:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (7,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:30:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (8,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:31:03');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (9,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 11:31:09');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (10,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 14:58:04');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (11,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 14:58:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (12,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 14:58:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (13,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:01:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (14,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:02:28');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (15,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:03:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (16,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:04:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (17,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (18,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:20');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (19,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (20,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:05:48');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (21,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:06:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (22,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:06:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (23,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:06:47');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (24,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (25,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:03');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (26,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (27,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (28,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:36');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (29,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:07:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (30,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:08:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (31,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:08:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (32,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:08:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (33,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:16:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (34,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (35,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (36,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (37,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:46');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (38,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:17:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (39,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (40,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (41,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (42,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:18:53');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (43,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:19:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (44,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:19:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (45,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:20:57');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (46,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:01');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (47,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:04');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (48,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (49,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (50,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (51,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:21:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (52,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:22:26');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (53,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:23:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (54,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:34:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (55,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:35:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (56,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:38:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (57,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-30 15:39:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (58,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 15:54:40');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (59,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:04:55');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (60,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:18:09');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (61,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:18:32');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (62,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:18:35');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (63,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 16:57:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (64,'1',1,'127.0.0.1','廖小波操作：新增分组：管理员','2013-12-30 16:58:12');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (65,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:04:51');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (66,'1',1,'127.0.0.1','廖小波操作：修改分组ID：1','2013-12-30 17:06:43');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (67,'1',1,'127.0.0.1','廖小波操作：修改分组ID：1','2013-12-30 17:06:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (68,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:11:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (69,'1',1,'127.0.0.1','廖小波操作：更新分组模块权限ID：1，新增：(1,1),(1,11),(1,12),(1,13),删除：','2013-12-30 17:32:23');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (70,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:39:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (71,'1',1,'127.0.0.1','廖小波操作：更新分组模块权限ID：1，新增：,删除：12','2013-12-30 17:55:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (72,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-30 17:56:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (73,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 09:16:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (74,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 09:52:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (75,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 10:01:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (76,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 10:01:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (77,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 10:04:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (78,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-31 13:03:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (79,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2013-12-31 13:03:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (80,'1',1,'192.168.3.14','廖小波操作：账号登陆：liaoxb','2013-12-31 13:21:53');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (81,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 15:24:09');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (82,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 15:42:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (83,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2013-12-31 15:48:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (84,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 10:37:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (85,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 10:58:48');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (86,'1',1,'192.168.3.105','廖小波操作：更新分组模块权限ID：1，新增：(1,12),删除：','2014-01-02 10:59:20');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (87,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 11:50:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (88,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 14:24:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (89,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 16:03:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (90,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：13','2014-01-02 16:11:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (91,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：(1,13),删除：','2014-01-02 16:11:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (92,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 16:18:11');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (93,'1',1,'192.168.3.105','廖小波操作：更新账号分组ID：1，新增：(1,1),删除：','2014-01-02 16:18:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (94,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：1,11,12,13','2014-01-02 16:18:59');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (95,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：1,11,12,13','2014-01-02 16:19:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (96,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：12','2014-01-02 16:19:15');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (97,'1',1,'192.168.3.105','廖小波操作：更新账号分组ID：1，新增：,删除：1','2014-01-02 16:19:30');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (98,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：(1,1),(1,11),(1,12),(1,13),删除：','2014-01-02 16:19:40');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (99,'1',1,'192.168.3.105','廖小波操作：更新模块权限ID：1，新增：,删除：12','2014-01-02 16:19:50');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (100,'1',1,'192.168.3.105','廖小波操作：更新账号分组ID：1，新增：(1,1),删除：','2014-01-02 16:19:55');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (101,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:05:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (102,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:06:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (103,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:06:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (104,'1',1,'192.168.3.105','廖小波操作：新增账号：test001','2014-01-02 17:09:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (105,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:20:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (106,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:23:36');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (107,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-02 17:24:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (108,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:24:16');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (109,'1',1,'192.168.3.105','廖小波操作：新增账号：1212','2014-01-02 17:28:19');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (110,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:28:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (111,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:29:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (112,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:30:11');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (113,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:30:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (114,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:30:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (115,'1',1,'192.168.3.105','廖小波操作：新增账号：stest','2014-01-02 17:32:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (116,'1',1,'192.168.3.105','廖小波操作：新增账号：tste','2014-01-02 17:33:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (117,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：2','2014-01-02 17:34:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (118,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:35:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (119,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：2','2014-01-02 17:37:41');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (120,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：3','2014-01-02 17:37:51');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (121,'1',1,'192.168.3.105','廖小波操作：新增账号：test','2014-01-02 17:42:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (122,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:43:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (123,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:43:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (124,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:44:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (125,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:45:47');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (126,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:46:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (127,'1',1,'192.168.3.105','廖小波操作：新增账号：123','2014-01-02 17:48:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (128,'1',1,'192.168.3.105','廖小波操作：新增账号：liaoxb','2014-01-02 17:49:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (129,'1',1,'192.168.3.105','廖小波操作：新增账号：liaoxb','2014-01-02 17:49:46');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (130,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:49:51');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (131,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:50:20');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (132,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:50:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (133,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:50:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (134,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:52:00');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (135,'1',1,'192.168.3.105','廖小波操作：新增账号：12w','2014-01-02 17:52:22');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (136,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 17:58:12');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (137,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:00:26');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (138,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:00:35');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (139,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:00:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (140,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:14:42');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (141,'1',1,'192.168.3.105','廖小波操作：修改账号信息ID：5','2014-01-02 18:14:53');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (142,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-06 15:39:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (143,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-06 15:43:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (144,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-09 10:33:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (145,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-10 15:39:28');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (146,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-16 10:18:14');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (147,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 10:36:01');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (148,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 10:45:21');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (149,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-16 11:24:52');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (150,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-01-16 14:27:53');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (151,'1',1,'192.168.3.105','廖小波操作：新增物品：name','2014-01-16 14:30:24');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (152,'1',1,'192.168.3.105','廖小波操作：新增物品：name','2014-01-16 14:31:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (153,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-16 14:33:07');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (154,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-16 14:34:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (155,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:43:08');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (156,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:43:13');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (157,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:43:45');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (158,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:44:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (159,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:44:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (160,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:44:32');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (161,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-16 15:44:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (162,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-17 11:09:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (163,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-17 11:11:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (164,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-17 11:11:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (165,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-17 11:11:07');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (166,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-17 11:11:37');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (167,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 15:57:59');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (168,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 16:06:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (169,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:03:05');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (170,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:37:44');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (171,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:39:47');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (172,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:39:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (173,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:47:07');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (174,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:52:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (175,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:53:15');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (176,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:53:33');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (177,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:55:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (178,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:55:46');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (179,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-01-17 17:56:06');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (180,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-20 10:43:19');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (181,'1',1,'127.0.0.1','廖小波操作：新增物品：1','2014-01-20 11:12:41');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (182,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-20 11:14:38');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (183,'1',1,'192.168.3.25','廖小波操作：新增物品：','2014-01-20 11:32:15');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (184,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-20 15:15:21');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (185,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-21 14:53:59');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (186,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-22 15:54:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (187,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-23 09:28:11');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (188,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-01-23 16:02:02');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (189,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-26 10:04:54');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (190,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-01-27 11:52:29');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (191,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-02-07 14:36:13');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (192,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-02-08 09:27:56');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (193,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-02-08 16:40:49');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (194,'1',1,'192.168.3.25','廖小波操作：新增物品：大好大瓜子','2014-02-08 16:50:57');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (195,'1',1,'192.168.3.25','廖小波操作：新增物品：大好大2','2014-02-08 16:58:10');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (196,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-02-10 11:39:46');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (197,'1',1,'192.168.3.25','廖小波操作：新增物品：大好大香瓜子','2014-02-10 14:29:12');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (198,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-02-10 14:54:12');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (199,'1',1,'192.168.3.25','廖小波操作：新增物品：大好大香瓜子','2014-02-10 15:00:19');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (200,'1',1,'192.168.3.25','廖小波操作：新增物品：大好大香瓜子','2014-02-10 15:00:26');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (201,'1',1,'192.168.3.25','廖小波操作：新增物品：大好大香瓜子','2014-02-10 15:01:58');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (202,'1',1,'127.0.0.1','廖小波操作：账号登陆：liaoxb','2014-02-10 18:20:31');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (203,'1',1,'192.168.3.25','廖小波操作：账号登陆：liaoxb','2014-02-11 14:37:39');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (204,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-02-11 16:07:34');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (205,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-02-11 16:11:26');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (206,'1',1,'192.168.3.25','廖小波操作：新增物品：1','2014-02-11 16:25:27');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (207,'1',1,'192.168.3.105','廖小波操作：账号登陆：liaoxb','2014-02-11 16:42:11');
insert  into `bm_event_log`(`event_log_id`,`account_id`,`event_type`,`operate_ip`,`event_desc`,`add_time`) values (208,'1',1,'192.168.3.14','廖小波操作：账号登陆：liaoxb','2014-02-11 18:10:14');

/*Table structure for table `bm_favorites` */

DROP TABLE IF EXISTS `bm_favorites`;

CREATE TABLE `bm_favorites` (
  `account_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`goods_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_favorites` */

/*Table structure for table `bm_goods` */

DROP TABLE IF EXISTS `bm_goods`;

CREATE TABLE `bm_goods` (
  `goods_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `brand_id` int(11) NOT NULL,
  `type3_id` int(11) NOT NULL,
  `goods_barcode` bigint(20) NOT NULL,
  `goods_name` varchar(246) NOT NULL,
  `goods_unit` varchar(16) NOT NULL,
  `goods_weight` varchar(64) NOT NULL,
  `goods_active_stime` int(11) NOT NULL,
  `goods_active_etime` int(11) NOT NULL,
  `goods_pic_url` varchar(246) NOT NULL,
  `goods_state` smallint(6) NOT NULL,
  `goods_number` int(11) NOT NULL,
  `goods_price` int(11) NOT NULL,
  `goods_active_price` int(11) NOT NULL,
  `goods_remark` varchar(128) NOT NULL,
  PRIMARY KEY (`goods_id`)
) ENGINE=MyISAM AUTO_INCREMENT=9 DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods` */

insert  into `bm_goods`(`goods_id`,`account_id`,`brand_id`,`type3_id`,`goods_barcode`,`goods_name`,`goods_unit`,`goods_weight`,`goods_active_stime`,`goods_active_etime`,`goods_pic_url`,`goods_state`,`goods_number`,`goods_price`,`goods_active_price`,`goods_remark`) values (8,1,0,0,0,'1','','',0,0,'',0,0,0,0,'');
insert  into `bm_goods`(`goods_id`,`account_id`,`brand_id`,`type3_id`,`goods_barcode`,`goods_name`,`goods_unit`,`goods_weight`,`goods_active_stime`,`goods_active_etime`,`goods_pic_url`,`goods_state`,`goods_number`,`goods_price`,`goods_active_price`,`goods_remark`) values (6,1,0,0,0,'1','','',0,0,'',0,0,0,0,'');
insert  into `bm_goods`(`goods_id`,`account_id`,`brand_id`,`type3_id`,`goods_barcode`,`goods_name`,`goods_unit`,`goods_weight`,`goods_active_stime`,`goods_active_etime`,`goods_pic_url`,`goods_state`,`goods_number`,`goods_price`,`goods_active_price`,`goods_remark`) values (7,1,0,0,0,'1','','',0,0,'',0,0,0,0,'');
insert  into `bm_goods`(`goods_id`,`account_id`,`brand_id`,`type3_id`,`goods_barcode`,`goods_name`,`goods_unit`,`goods_weight`,`goods_active_stime`,`goods_active_etime`,`goods_pic_url`,`goods_state`,`goods_number`,`goods_price`,`goods_active_price`,`goods_remark`) values (5,1,2,5,9001,'大好大香瓜子','袋','260',1,2,'/500mi/app/img/1.jpg',0,4,6,5,'备注');

/*Table structure for table `bm_goods_brand` */

DROP TABLE IF EXISTS `bm_goods_brand`;

CREATE TABLE `bm_goods_brand` (
  `brand_id` int(11) NOT NULL,
  `brand_name` varchar(64) NOT NULL,
  `brand_order` int(11) NOT NULL,
  `brand_state` smallint(6) NOT NULL,
  PRIMARY KEY (`brand_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_brand` */

insert  into `bm_goods_brand`(`brand_id`,`brand_name`,`brand_order`,`brand_state`) values (1,'上好佳',1,0);
insert  into `bm_goods_brand`(`brand_id`,`brand_name`,`brand_order`,`brand_state`) values (2,'大好大',2,0);

/*Table structure for table `bm_goods_type1` */

DROP TABLE IF EXISTS `bm_goods_type1`;

CREATE TABLE `bm_goods_type1` (
  `type1_id` int(11) NOT NULL AUTO_INCREMENT,
  `type1_name` varchar(64) NOT NULL,
  `type1_order` int(11) NOT NULL,
  `type1_state` smallint(6) NOT NULL,
  PRIMARY KEY (`type1_id`)
) ENGINE=MyISAM AUTO_INCREMENT=6 DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_type1` */

insert  into `bm_goods_type1`(`type1_id`,`type1_name`,`type1_order`,`type1_state`) values (1,'日化',1,0);
insert  into `bm_goods_type1`(`type1_id`,`type1_name`,`type1_order`,`type1_state`) values (2,'食品',2,0);
insert  into `bm_goods_type1`(`type1_id`,`type1_name`,`type1_order`,`type1_state`) values (3,'饮料',3,0);
insert  into `bm_goods_type1`(`type1_id`,`type1_name`,`type1_order`,`type1_state`) values (4,'服饰',4,0);
insert  into `bm_goods_type1`(`type1_id`,`type1_name`,`type1_order`,`type1_state`) values (5,'家电',5,0);

/*Table structure for table `bm_goods_type2` */

DROP TABLE IF EXISTS `bm_goods_type2`;

CREATE TABLE `bm_goods_type2` (
  `type2_id` int(11) NOT NULL AUTO_INCREMENT,
  `type1_id` int(11) NOT NULL,
  `type2_name` varchar(64) NOT NULL,
  `type2_order` int(11) NOT NULL,
  `type2_state` smallint(6) NOT NULL,
  PRIMARY KEY (`type2_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_type2` */

insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (1,1,'洗发水',1,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (2,1,'洗衣液',2,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (3,2,'瓜子',1,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (4,2,'面包',2,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (5,1,'毛巾',3,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (6,2,'巧克力',3,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (7,3,'果汁',1,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (8,3,'茶饮',2,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (9,4,'男装',1,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (10,4,'下装',2,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (11,4,'鞋子',3,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (12,5,'厨房家电',1,0);
insert  into `bm_goods_type2`(`type2_id`,`type1_id`,`type2_name`,`type2_order`,`type2_state`) values (13,5,'大家电',2,0);

/*Table structure for table `bm_goods_type3` */

DROP TABLE IF EXISTS `bm_goods_type3`;

CREATE TABLE `bm_goods_type3` (
  `type3_id` int(11) NOT NULL AUTO_INCREMENT,
  `type2_id` int(11) NOT NULL,
  `type3_name` varchar(64) NOT NULL,
  `type3_order` int(11) NOT NULL,
  `type3_state` smallint(6) NOT NULL,
  PRIMARY KEY (`type3_id`)
) ENGINE=MyISAM AUTO_INCREMENT=47 DEFAULT CHARSET=utf8;

/*Data for the table `bm_goods_type3` */

insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (1,1,'天然沐浴露',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (2,1,'力士',5,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (3,2,'自然堂',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (4,2,'兰芝',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (5,3,'口水娃',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (6,3,'洽洽',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (7,4,'盼盼',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (8,4,'普通',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (9,1,'美肌',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (10,1,'六神',4,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (11,2,'玉兰油',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (12,2,'旁氏',4,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (13,3,'华味亨',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (14,4,'达利圆',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (15,5,'洁利亚',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (16,5,'亚光',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (17,5,'洁玉',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (18,6,'瑞士莲',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (19,6,'德芙',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (20,1,'都乐',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (21,2,'汇源',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (22,8,'三德立',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (23,8,'康师傅',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (24,6,'费列罗',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (25,7,'汇源',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (26,7,'光明',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (27,7,'统一',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (28,7,'哇哈哈',4,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (29,8,'立顿',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (30,9,'恒源祥',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (31,9,'唐狮',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (32,9,'耐克',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (33,10,'韩都衣舍',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (34,10,'秋水依人',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (35,10,'布叶',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (36,11,'耐克',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (37,11,'阿迪达斯',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (38,11,'奥康',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (39,12,'美的',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (40,12,'九阳',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (41,12,'奔腾',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (42,12,'格力',4,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (43,13,'平板电视',1,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (44,13,'空调',2,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (45,13,'洗衣机',3,0);
insert  into `bm_goods_type3`(`type3_id`,`type2_id`,`type3_name`,`type3_order`,`type3_state`) values (46,13,'冰箱',4,0);

/*Table structure for table `bm_group` */

DROP TABLE IF EXISTS `bm_group`;

CREATE TABLE `bm_group` (
  `group_id` int(11) NOT NULL AUTO_INCREMENT,
  `group_name` varchar(64) NOT NULL,
  `group_remark` varchar(1024) DEFAULT NULL,
  PRIMARY KEY (`group_id`)
) ENGINE=MyISAM AUTO_INCREMENT=2 DEFAULT CHARSET=utf8;

/*Data for the table `bm_group` */

insert  into `bm_group`(`group_id`,`group_name`,`group_remark`) values (1,'管理员','管理员系统后台管理人员');

/*Table structure for table `bm_group_module` */

DROP TABLE IF EXISTS `bm_group_module`;

CREATE TABLE `bm_group_module` (
  `group_id` int(11) NOT NULL,
  `module_id` int(11) NOT NULL,
  PRIMARY KEY (`group_id`,`module_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_group_module` */

insert  into `bm_group_module`(`group_id`,`module_id`) values (1,1);
insert  into `bm_group_module`(`group_id`,`module_id`) values (1,11);
insert  into `bm_group_module`(`group_id`,`module_id`) values (1,12);
insert  into `bm_group_module`(`group_id`,`module_id`) values (1,13);

/*Table structure for table `bm_module` */

DROP TABLE IF EXISTS `bm_module`;

CREATE TABLE `bm_module` (
  `module_id` int(11) NOT NULL AUTO_INCREMENT,
  `module_name` varchar(32) NOT NULL,
  `fmodule_id` int(11) NOT NULL,
  `module_level` int(11) NOT NULL,
  `module_url` varchar(256) NOT NULL,
  `fmodule_url` varchar(256) NOT NULL,
  `module_pri` smallint(6) NOT NULL,
  `module_state` smallint(6) NOT NULL,
  `module_remark` varchar(128) DEFAULT NULL,
  PRIMARY KEY (`module_id`)
) ENGINE=MyISAM AUTO_INCREMENT=14 DEFAULT CHARSET=utf8;

/*Data for the table `bm_module` */

insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (1,'基础数据维护',0,1,'/view/sszt/OnlineLog.php','',1,3,'');
insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (11,'功能模块维护',1,1,'/view/BaseData/ModuleManage.php','',1,1,'功能模块维护');
insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (12,'分组管理',1,1,'/view/BaseData/GroupManage.php','',2,1,'分组管理');
insert  into `bm_module`(`module_id`,`module_name`,`fmodule_id`,`module_level`,`module_url`,`fmodule_url`,`module_pri`,`module_state`,`module_remark`) values (13,'账号管理',1,1,'/view/BaseData/AccountManage.php','',3,1,'账号管理');

/*Table structure for table `bm_purchase_info` */

DROP TABLE IF EXISTS `bm_purchase_info`;

CREATE TABLE `bm_purchase_info` (
  `shopping_cart_id` bigint(20) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `goods_num` int(11) NOT NULL,
  `purchase_goods_price` int(11) NOT NULL,
  `purchase_state` smallint(6) NOT NULL COMMENT '正常\n            缺货\n            退货\n            ',
  PRIMARY KEY (`shopping_cart_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_purchase_info` */

/*Table structure for table `bm_purchase_list` */

DROP TABLE IF EXISTS `bm_purchase_list`;

CREATE TABLE `bm_purchase_list` (
  `purchase_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `add_time` int(11) NOT NULL,
  `purchase_state` smallint(6) NOT NULL COMMENT '提交，发货，收货，退货，关闭',
  `return_time` int(11) NOT NULL,
  `purchase_price` int(11) NOT NULL,
  `purchase_remark` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`purchase_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_purchase_list` */

/*Table structure for table `bm_return_info` */

DROP TABLE IF EXISTS `bm_return_info`;

CREATE TABLE `bm_return_info` (
  `shopping_cart_id` bigint(20) NOT NULL,
  `purchase_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `return_goods_num` int(11) NOT NULL,
  `return_goods_price` int(11) NOT NULL,
  `return_state` smallint(6) NOT NULL COMMENT '正常\n            缺货\n            退货\n            ',
  PRIMARY KEY (`shopping_cart_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_return_info` */

/*Table structure for table `bm_return_list` */

DROP TABLE IF EXISTS `bm_return_list`;

CREATE TABLE `bm_return_list` (
  `purchase_id` int(11) NOT NULL,
  `account_id` int(11) NOT NULL,
  `shop_id` int(11) NOT NULL,
  `return_price` int(11) NOT NULL,
  `return_state` smallint(6) NOT NULL COMMENT '提交，发货，收货，退货，关闭',
  `return_time` int(11) NOT NULL,
  `return_remark` varchar(256) DEFAULT NULL,
  PRIMARY KEY (`purchase_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_return_list` */

/*Table structure for table `bm_shop_point_supplier` */

DROP TABLE IF EXISTS `bm_shop_point_supplier`;

CREATE TABLE `bm_shop_point_supplier` (
  `account_id` int(11) NOT NULL,
  `supplier_account_id` int(11) NOT NULL,
  PRIMARY KEY (`account_id`,`supplier_account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_shop_point_supplier` */

/*Table structure for table `bm_shopping_cart` */

DROP TABLE IF EXISTS `bm_shopping_cart`;

CREATE TABLE `bm_shopping_cart` (
  `shopping_cart_id` bigint(20) NOT NULL,
  `account_id` int(11) NOT NULL,
  `goods_id` int(11) NOT NULL,
  `goods_num` int(11) NOT NULL,
  `add_time` int(11) NOT NULL,
  PRIMARY KEY (`shopping_cart_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_shopping_cart` */

/*Table structure for table `bm_store_info` */

DROP TABLE IF EXISTS `bm_store_info`;

CREATE TABLE `bm_store_info` (
  `shop_id` int(11) NOT NULL AUTO_INCREMENT,
  `account_id` int(11) NOT NULL,
  `shop_name` varchar(200) NOT NULL,
  `shop_province` varchar(16) NOT NULL,
  `shop_city` varchar(16) NOT NULL,
  `shop_district` varchar(16) NOT NULL,
  `shop_addr` varchar(200) NOT NULL,
  `shop_contacts` varchar(64) NOT NULL,
  `shop_phone` varchar(50) NOT NULL,
  `shop_state` smallint(6) NOT NULL COMMENT '营业中\n            关闭',
  PRIMARY KEY (`shop_id`)
) ENGINE=MyISAM AUTO_INCREMENT=3 DEFAULT CHARSET=utf8;

/*Data for the table `bm_store_info` */

insert  into `bm_store_info`(`shop_id`,`account_id`,`shop_name`,`shop_province`,`shop_city`,`shop_district`,`shop_addr`,`shop_contacts`,`shop_phone`,`shop_state`) values (1,1,'白马湖超市','浙江省','杭州市','滨江区','白马湖002','联系方式???','110',0);
insert  into `bm_store_info`(`shop_id`,`account_id`,`shop_name`,`shop_province`,`shop_city`,`shop_district`,`shop_addr`,`shop_contacts`,`shop_phone`,`shop_state`) values (2,1,'江南铭庭超市','浙江省','杭州市','滨江区','江南铭庭002','联系方式???','120',0);

/*Table structure for table `bm_supplier` */

DROP TABLE IF EXISTS `bm_supplier`;

CREATE TABLE `bm_supplier` (
  `account_id` int(11) NOT NULL,
  `supplier_name` varchar(200) NOT NULL,
  `supplier_province` varchar(16) NOT NULL,
  `supplier_city` varchar(16) NOT NULL,
  `supplier_district` varchar(16) NOT NULL,
  `supplier_addr` varchar(200) NOT NULL,
  `supplier_person` varchar(50) NOT NULL,
  `supplier_type` int(11) NOT NULL,
  `supplier_level` int(11) NOT NULL,
  `supplier_phone` int(11) NOT NULL,
  `supplier_remark` varchar(800) DEFAULT NULL,
  PRIMARY KEY (`account_id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

/*Data for the table `bm_supplier` */

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
