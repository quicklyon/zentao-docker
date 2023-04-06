 REPLACE INTO `{{TABLE_PREFIX}}pipeline` (`type`,`name`,`url`,`account`,`password`,`token`,`createdBy`,`createdDate`,`editedBy`,`editedDate`) \
 VALUES ('{{SCAN_TYPE}}','quickon-{{SCAN_TYPE}}','{{SCAN_URL}}','{{SCAN_USERNAME}}','{{SCAN_PASSWORD_ENCODE}}','{{SCAN_TOKEN_ENCODE}}','QuickOn',now(),'','1970-01-01 00:00:01');
