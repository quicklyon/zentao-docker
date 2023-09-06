# httpd.conf

ServerRoot      "/opt/zbox/run/apache"
PidFile         /opt/zbox/tmp/apache/httpd.pid
DocumentRoot    "{{DOCUMENT_ROOT}}"

Listen          {{APP_DEFAULT_PORT}}
User            nobody
Group           nogroup

ServerAdmin     zentao@localhost.net

ServerName      localhost

EnableMMAP      off
EnableSendfile  off

TypesConfig     /opt/zbox/etc/apache/mime.types

# performance settings.
Timeout                 300
KeepAlive               On
MaxKeepAliveRequests    100
KeepAliveTimeout        10
UseCanonicalName        Off
HostnameLookups         Off

# security.

ServerTokens            Prod
ServerSignature         Off

# deflat.
AddType image/x-icon .ico
AddType image/gif .gif
AddType image/jpeg .jpg .jpeg
AddType image/png .png
AddType application/javascript .js
DeflateCompressionLevel 9
AddOutputFilterByType DEFLATE text/html text/css application/javascript

# modules.
LoadModule mpm_prefork_module modules/mod_mpm_prefork.so
<IfModule mpm_prefork_module>
	StartServers            5
	MinSpareServers         5
	MaxSpareServers         10
	MaxRequestWorkers       150
	MaxConnectionsPerChild  0
</IfModule>

LoadModule authn_file_module modules/mod_authn_file.so
LoadModule access_compat_module modules/mod_access_compat.so
LoadModule alias_module modules/mod_alias.so
LoadModule authn_core_module modules/mod_authn_core.so
LoadModule auth_basic_module modules/mod_auth_basic.so
LoadModule authz_core_module modules/mod_authz_core.so
LoadModule authz_host_module modules/mod_authz_host.so
LoadModule authz_user_module modules/mod_authz_user.so
LoadModule autoindex_module modules/mod_autoindex.so
LoadModule headers_module modules/mod_headers.so
LoadModule deflate_module modules/mod_deflate.so
LoadModule dir_module modules/mod_dir.so
LoadModule env_module modules/mod_env.so
LoadModule expires_module modules/mod_expires.so
LoadModule filter_module modules/mod_filter.so
LoadModule log_config_module modules/mod_log_config.so
LoadModule mime_module modules/mod_mime.so
LoadModule rewrite_module modules/mod_rewrite.so
LoadModule setenvif_module modules/mod_setenvif.so
LoadModule unixd_module modules/mod_unixd.so
LoadModule ssl_module modules/mod_ssl.so
LoadModule socache_shmcb_module modules/mod_socache_shmcb.so

SSLSessionCache         "shmcb:/opt/zbox/logs/ssl_scache(512000)"
SSLSessionCacheTimeout  300

# php module.
LoadModule php7_module modules/libphp.so


<IfModule php7_module>
    DirectoryIndex index.html default.php index.php
    AddHandler application/x-httpd-php .php
</IfModule>

AddType application/x-httpd-php .php .php3 .php4

<FilesMatch ".+\.ph(ar|p|tml)$">
    SetHandler application/x-httpd-php
</FilesMatch>

<FilesMatch ".+\.phps$">
    SetHandler application/x-httpd-php-source
    Require all denied
</FilesMatch>

# Deny access to files without filename (e.g. '.php')
<FilesMatch "^\.ph(ar|p|ps|tml)$">
    Require all denied
</FilesMatch>

<Files ".zt*">
  Require all denied
</Files>

<Files ".ht*">
  Require all denied
</Files>

# directory settings.
DirectoryIndex index.html index.htm index.php

# logs
ErrorLog "/dev/stderr"
LogLevel warn
LogFormat "%h %l %u %t \"%r\" %>s %b \"%{Referer}i\" \"%{User-Agent}i\"" combined
CustomLog "/dev/stdout" combined

<Directory "/apps/zentao/www">
  Options  FollowSymLinks
  AllowOverride All
  Require all granted
</Directory>

<VirtualHost *:{{APP_DEFAULT_PORT}}>
 ServerAdmin zentao@local.net
 DocumentRoot "{{DOCUMENT_ROOT}}"
 ServerName localhost
 
 <Directory />
   AllowOverride all
   Require all granted
 </Directory>

# setting for admin
 Alias /adminer "{{DOCUMENT_ROOT}}/adminer"
 <Directory "{{DOCUMENT_ROOT}}/adminer">
    DirectoryIndex index.php
    <Files "index.php">
        SetHandler application/x-httpd-php
    </Files>
 </Directory>
 <DirectoryMatch "{{DOCUMENT_ROOT}}/adminer/.+/.*">
    <FilesMatch ".+\.ph(p[3457]?|t|tml)$">
        SetHandler text/plain
    </FilesMatch>
 </DirectoryMatch>
 
 ErrorLog "/dev/stderr"
 CustomLog "/dev/stdout" combined
</VirtualHost>

TraceEnable off
