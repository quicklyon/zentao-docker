[PHP]
engine = On
short_open_tag = On
asp_tags = Off
precision = 14
y2k_compliance = On
output_buffering = 4096
zlib.output_compression = Off
implicit_flush = Off
unserialize_callback_func =
serialize_precision = 100
allow_call_time_pass_reference = Off
safe_mode = Off
safe_mode_gid = Off
safe_mode_include_dir =
safe_mode_exec_dir =
safe_mode_allowed_env_vars = PHP_
safe_mode_protected_env_vars = LD_LIBRARY_PATH
disable_functions =
disable_classes =
expose_php = Off
max_execution_time = {{PHP_MAX_EXECUTION_TIME}}
max_input_time = 60
max_input_vars = {{PHP_MAX_INPUT_VARS}}
memory_limit = {{PHP_MEMORY_LIMIT}}
error_reporting = E_ALL | E_STRICT
display_errors = On
display_startup_errors = On
log_errors = On
log_errors_max_len = 1024
ignore_repeated_errors = Off
ignore_repeated_source = Off
report_memleaks = On
html_errors = On
error_log =  "{{PHP_ERROR_LOG}}"
variables_order = "GPCS"
request_order = "GP"
register_globals = Off
register_long_arrays = Off
register_argc_argv = Off
auto_globals_jit = On
post_max_size = {{PHP_POST_MAX_SIZE}}
magic_quotes_gpc = Off
magic_quotes_runtime = Off
magic_quotes_sybase = Off
auto_prepend_file =
auto_append_file =
default_mimetype = "text/html"
doc_root =
user_dir =
enable_dl = Off
file_uploads = On
upload_max_filesize = {{PHP_UPLOAD_MAX_FILESIZE}}
allow_url_fopen = On
allow_url_include = Off
default_socket_timeout = 60
extension_dir = /opt/zbox/run/php/extensions/

[Date]
date.timezone = Asia/Shanghai

[Pdo_mysql]
pdo_mysql.cache_size = 2000
pdo_mysql.default_socket= /opt/zbox/tmp/mysql/mysql.sock

[MySQL]
mysql.allow_local_infile = On
mysql.allow_persistent = On
mysql.cache_size = 2000
mysql.max_persistent = -1
mysql.max_links = -1
mysql.default_port =
mysql.default_socket = /opt/zbox/tmp/mysql/mysql.sock
mysql.default_host =
mysql.default_user =
mysql.default_password =
mysql.connect_timeout = 60
mysql.trace_mode = Off

[MySQLi]
mysqli.max_persistent = -1
mysqli.max_links = -1
mysqli.cache_size = 2000
mysqli.default_port =
mysqli.default_socket = /opt/zbox/tmp/mysql/mysql.sock
mysqli.default_host =
mysqli.default_user =
mysqli.default_pw =
mysqli.reconnect = Off

[mysqlnd]
mysqlnd.collect_statistics = On
mysqlnd.collect_memory_statistics = On

[Session]
session.save_handler = {{PHP_SESSION_TYPE}}
session.save_path =  "{{PHP_SESSION_PATH}}"
session.use_cookies = 1
session.use_only_cookies = 1
session.name = PHPSESSID
session.auto_start = 0
session.cookie_lifetime = 0
session.cookie_path = /
session.cookie_domain =
session.cookie_httponly =
session.serialize_handler = php
session.gc_probability = 1
session.gc_divisor = 1000
session.gc_maxlifetime = 1440
session.bug_compat_42 = On
session.bug_compat_warn = On
session.referer_check =
session.entropy_length = 0
session.entropy_file =
session.cache_limiter = nocache
session.cache_expire = 180
session.use_trans_sid = 0
session.hash_function = 0
session.hash_bits_per_character = 5
url_rewriter.tags = "a=href,area=href,frame=src,input=src,form=fakeentry"

[ldap]
ldap.max_links = -1

[openssl]

[opcache]
opcache.memory_consumption=128
opcache.interned_strings_buffer=8
opcache.max_accelerated_files=4000
opcache.revalidate_freq=0
opcache.fast_shutdown=1
opcache.enable_cli=1
