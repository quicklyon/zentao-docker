<?php
$basePath = '/apps/zentao';
$dbHost   = getenv('ZT_MYSQL_HOST') ? getenv('ZT_MYSQL_HOST') : '127.0.0.1';
$dbPort   = getenv('ZT_MYSQL_PORT') ? getenv('ZT_MYSQL_PORT') : '3306';
$dbUser   = getenv('ZT_MYSQL_USER') ? getenv('ZT_MYSQL_USER') : 'root';
$dbPWD    = getenv('ZT_MYSQL_PASSWORD') ? getenv('ZT_MYSQL_PASSWORD') : '123456';
$dbName   = getenv('ZT_MYSQL_DB') ? getenv('ZT_MYSQL_DB') : 'zentao';
$ztVer   = getenv('ZENTAO_VER') ? getenv('ZENTAO_VER') : 'zentao';
$configDbFile = "$basePath/tmp/$dbName.sql";
$checkfile = "/data/zentao/.devops";

if (!file_exists($checkfile)) {
  initDB($basePath, $dbHost, $dbUser, $dbPWD, $configDbFile, $dbName, $ztVer);
  echo "DevOps init success.";
} else {
  echo "DevOps has been initialized.";
}

function initDB($basePath, $dbHost, $dbUser, $dbPWD, $dbFile, $dbName, $ztVer)
{
    $baseDbFile = "$basePath/db/zentao.sql";
    $tableContent = preg_replace('/__DELIMITER__+/', ";", file_get_contents($baseDbFile));
    $tableContent = preg_replace('/__TABLE__+/', $dbName, $tableContent);
    $tableContent = preg_replace('/^CREATE\s+FUNCTION+/m', "DELIMITER ;;\nCREATE FUNCTION", $tableContent);
    $tableContent = preg_replace('/END;+/', "END;; \nDELIMITER ;", $tableContent);

    file_put_contents($dbFile, "SET @@sql_mode='';\nSET NAMES utf8;" . $tableContent);
    if (stripos($ztVer, "ipd") !== false) {
      file_put_contents($dbFile, "\nREPLACE INTO `zt_config` (`vision`, `owner`, `module`, `section`, `key`, `value`) VALUES ('', 'system', 'common', 'global', 'mode', 'PLM');", FILE_APPEND);
    }
    `mysql -u{$dbUser} -p{$dbPWD} -h{$dbHost} -D{$dbName} < $dbFile`;
}
