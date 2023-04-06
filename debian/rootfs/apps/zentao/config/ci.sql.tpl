 REPLACE INTO `{{TABLE_PREFIX}}pipeline` (`type`,`name`,`url`,`account`,`password`,`token`,`createdBy`,`createdDate`,`editedBy`,`editedDate`) \
 VALUES ('{{CI_TYPE}}','quickon-{{CI_TYPE}}','{{CI_URL}}','{{CI_USERNAME}}','','{{CI_TOKEN}}','QuickOn',now(),'','1970-01-01 00:00:01');
