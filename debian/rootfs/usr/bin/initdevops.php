<?php
$basePath = '/apps/zentao';
$dbHost   = getenv('ZT_MYSQL_HOST') ? getenv('ZT_MYSQL_HOST') : '127.0.0.1';
$dbPort   = getenv('ZT_MYSQL_PORT') ? getenv('ZT_MYSQL_PORT') : '3306';
$dbUser   = getenv('ZT_MYSQL_USER') ? getenv('ZT_MYSQL_USER') : 'root';
$dbPWD    = getenv('ZT_MYSQL_PASSWORD') ? getenv('ZT_MYSQL_PASSWORD') : '123456';
$dbName   = getenv('ZT_MYSQL_DB') ? getenv('ZT_MYSQL_DB') : 'zentao';
$configDbFile = "$basePath/tmp/$dbName";
$checkfile = "/data/zentao/.devops";

if (!file_exists($checkfile)) {
  initDB($basePath, $dbHost, $dbUser, $dbPWD, $configDbFile, $dbName);
  echo "DevOps init success.";
} else {
  echo "DevOps has been initialized.";
}

function initDB($basePath, $dbHost, $dbUser, $dbPWD, $dbFile, $dbName)
{
    $baseDbFile = "$basePath/db/zentao.sql";
    $tableContent = preg_replace('/__DELIMITER__+/', ";", file_get_contents($baseDbFile));
    $tableContent = preg_replace('/__TABLE__+/', $dbName, $tableContent);
    $tableContent = preg_replace('/^CREATE\s+FUNCTION+/m', "DELIMITER ;;\nCREATE FUNCTION", $tableContent);
    $tableContent = preg_replace('/END;+/', "END;; \nDELIMITER ;", $tableContent);

    file_put_contents($dbFile, "SET @@sql_mode='';\nSET NAMES utf8;" . $tableContent);
    `mysql -u{$dbUser} -p{$dbPWD} -h{$dbHost} -D{$dbName} < $dbFile`;
}
