[client]
port   = 3306
socket = /data/mysql/tmp/mysql.sock
default-character-set=utf8mb4

[mysqld_safe]
socket = /data/mysql/tmp/mysql.sock
nice   = 0

[mysqld]
user     = nobody
pid-file = /data/mysql/tmp/mysqld.pid
socket   = /data/mysql/tmp/mysql.sock
port     = 3306
basedir  = /opt/zbox/run/mysql
datadir  = /data/mysql/data
tmpdir   = /data/mysql/tmp
skip-external-locking

character-set-client-handshake = FALSE
character-set-server = utf8mb4
collation-server = utf8mb4_unicode_ci
init_connect='SET NAMES utf8mb4'

bind-address            = 127.0.0.1
key_buffer_size         = 16M
max_allowed_packet      = 16M
thread_stack		    = 192K
thread_cache_size       = 8
table_open_cache        = 64
sort_buffer_size        = 512K
net_buffer_length       = 8K
read_buffer_size        = 256K
read_rnd_buffer_size    = 512K
myisam_sort_buffer_size = 8M
query_cache_limit = 1M
query_cache_size  = 16M
log_error  = /data/mysql/logs/mysql_error.log

explicit_defaults_for_timestamp
default-storage-engine=InnoDB
default-tmp-storage-engine=InnoDB

server-id  = 1
sql_mode = ""
[mysqldump]
quick
quote-names
max_allowed_packet = 16M

[mysql]
no-auto-rehash
default-character-set=utf8mb4

[isamchk]
key_buffer_size  = 20M
sort_buffer_size = 20M
read_buffer      = 2M
write_buffer     = 2M

[myisamchk]
key_buffer_size  = 20M
sort_buffer_size = 20M
read_buffer      = 2M
write_buffer     = 2M

[mysqlhotcopy]
interactive-timeout