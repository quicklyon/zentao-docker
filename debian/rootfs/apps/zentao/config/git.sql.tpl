 REPLACE INTO `{{TABLE_PREFIX}}pipeline` (`id`,`type`,`name`,`url`,`account`,`password`,`token`,`createdBy`,`createdDate`,`editedBy`,`editedDate`) \
 VALUES (999,'{{GIT_TYPE}}','{{GIT_INSTANCE_NAME}}','{{GIT_DOMAIN}}',NULL,'','{{GIT_TOKEN}}','QuickOn',now(),'','1970-01-01 00:00:01');
