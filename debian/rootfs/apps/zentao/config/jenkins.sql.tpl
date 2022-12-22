 REPLACE INTO `{{TABLE_PREFIX}}pipeline` (`type`,`name`,`url`,`account`,`password`,`token`,`createdBy`,`createdDate`,`editedBy`,`editedDate`) \
 VALUES ('jenkins','quickon-jenkins','{{JENKINS_PROTOCOL}}://{{JENKINS_URL}}','{{JENKINS_USERNAME}}','','{{JENKINS_TOKEN}}','QuickOn',now(),'','1970-01-01 00:00:01');
