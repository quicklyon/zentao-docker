<!-- 这里写应用的【环境变量信息】 -->
| 变量名                    | 默认值                        | 说明                             |
| ------------------------ | ---------------------------- | -------------------------------- |
| DEBUG                    | false                        | 是否打开调试信息，默认关闭       |
| PHP_SESSION_TYPE         | files                        | php session 类型，files \| redis |
| PHP_SESSION_PATH         | /data/php/session            | php session 存储路径             |
| PHP_MAX_EXECUTION_TIME   | 120                          | 最大执行时间，单位秒，有助于防止有问题程序占尽服务器资源。默认120             |
| PHP_MEMORY_LIMIT         | 256M                         | 单个php进程允许分配的最大内存             |
| PHP_POST_MAX_SIZE        | 128M                         | 允许最大Post数据大小             |
| PHP_UPLOAD_MAX_FILESIZE  | 128M                         | 单个文件上传的最大值             |
| MYSQL_INTERNAL           | false                        | 使用内部的MySQL，默认关闭          |
| MYSQL_HOST               | 127.0.0.1                    | MySQL 主机地址                   |
| MYSQL_PORT               | 3306                         | MySQL 端口                       |
| MYSQL_DB                 | zentao                       | zentao数据库名称                 |
| MYSQL_USER               | root                         | MySQL用户名                      |
| MYSQL_PASSWORD           | pass4zenTao                  | MySQL密码                        |
| LDAP_ENABLED             | false                        | 是否启用LDAP                      |
| LDAP_HOST                | 127.0.0.1                    | LDAP服务主机地址   |
| LDAP_PORT                | 389                          | LDAP服务端口      |
| LDAP_BASEDN              | dc=quickon,dc=org            | LDAP BaseDN  |
| LDAP_ADMINUSER           | cn=admin,dc=quickon,dc=org   | LDAP 管理员  |
| LDAP_BINDPASSWORD        | pass4zenTao                  | LDAP Bind 密码                |
| LDAP_USERKEY             | uid                          | LDAP 用户名称的字段名       |
| LDAP_EMAILKEY            | mail                         | LDAP 用户邮箱的字段名       |
| LDAP_GROUP| 1| 默认用户组(1: 管理员, 2: 研发, 3: 测试, 类比)       |
| LDAP_REALNAME| name| LDAP 用户真实姓名的字段名       |
| LDAP_REPEATPOLICY| number | LDAP 用户重名策略，number:数字后缀，dept:部门后缀|
| LDAP_AUTOCREATE| 1| LDAP 用户自动创建，1:自动创建，0:不自动创建 |
| SMTP_ENABLED             | false                        | 启用SMTP       |
| SMTP_FROMNAME            | ZenTao $VERSION              | SMTP发件人显示名称       |
| SMTP_HOST                | 127.0.0.1                    | SMTP 服务主机地址       |
| SMTP_PORT                | 25                           | SMTP 服务端口号       |
| SMTP_USER                | zentao@easycorp.cn           | SMTP发件人邮箱地址       |
| SMTP_PASS                | pass4zenTao                  | SMTP发件人邮箱密码       |
| LINK_GIT                 | false                        | DevOps模块，是否链接Git服务|
| GIT_TYPE                 | gitea                        | 连接的git服务名称，目前支持 gitea/gogs/gitlab|
| GIT_INSTANCE_NAME        | gitea                        | Git 服务名称|
| GIT_USERNAME             | root                         | Git 管理员账号名称，用于生成token|
| GIT_PASSWORD             | pass4QuickOn                 | Git 管理员密码，用于生成token|
| GIT_PROTOCOL             | https                        | Git 服务协议类型，http或https(废弃)|
| GIT_DOMAIN               | https://git.haogs.cn         | Git 服务域名(完整域名包含协议头) |
| GIT_TOKEN                | -                            | Git Token优先级高于用户名, 默认为空 |
| LINK_CI                  | false                        | DevOps模块，是否链接CI服务|
| CI_TYPE                  | jenkins                      | 连接的ci服务名称，目前支持 jenkins|
| CI_USERNAME              | root                         | CI 管理员账号名称，用于生成token|
| CI_PASSWORD              | pass4QuickOn                 | CI 管理员密码，用于生成token|
| CI_PROTOCOL              | https                        | CI 协议类型，http或https(废弃)|
| CI_URL                   | https://jenkins.haogs.cn     | CI 服务域名(完整域名包含协议头) |
| CI_TOKEN                 | -                            | CI Token优先级高于用户名, 默认为空 |
| LINK_SCAN                | false                        | DevOps模块，是否链接扫描服务|
| SCAN_TYPE                | sonarqube                    | 连接的扫描服务名称，目前支持 sonarqube|
| SCAN_USERNAME            | admin                        | SCAN 管理员账号名称，用于生成token|
| SCAN_PASSWORD            | pass4QuickOn                 | SCAN 管理员密码，用于生成token|
| SCAN_PROTOCOL            | https                        | SCAN 协议类型，http或https(废弃)|
| SCAN_URL                 | https://sonarqube.haogs.cn   | SCAN 服务域名(完整域名包含协议头) |
| IS_CONTAINER             | true                         | 是否在容器内运行，zentao更新时使用|

### 5.1 调整最大上传文件的限制

通过设置 `PHP_POST_MAX_SIZE` 、`PHP_UPLOAD_MAX_FILESIZE` 这两个环境变量的值来调整最大上传文件的限制，另外，如果考虑到用户网速的因素，建议把`PHP_MAX_EXECUTION_TIME` 也加大一些，这样可以保证用户的文件可以上传完成。

**示例：**

```bash
# 运行mysql
docker run -d --rm --name mysql -e MYSQL_ROOT_PASSWORD=pass4you mysql:5.7.38-debian

# 运行禅道
docker run -d --rm --name zentao \
--link mysql \
--link redis \
-e MYSQL_HOST=mysql \
-e MYSQL_PORT=3306 \
-e MYSQL_USER=root \
-e MYSQL_PASSWORD=pass4you \
-e MYSQL_DB=zentao \
-e PHP_MAX_EXECUTION_TIME=300 \
-e PHP_POST_MAX_SIZE=512M \
-e PHP_UPLOAD_MAX_FILESIZE=512M \
-v /data/zentao:/data \
-p 8088:80 \
easysoft/quickon-zentao:latest
```

> - PHP_MAX_EXECUTION_TIME 设置为300秒
> - PHP_POST_MAX_SIZE 设置为512M
> - PHP_UPLOAD_MAX_FILESIZE 设置为 512M

## 六、将Session存储在Redis

禅道默认是将Session存储在共享存储中，因此多节点部署也可以满足Session共享的需求，但如果你想通过Redis来存储Session也是可以的，只需要在启动容器是传入两个参数即可：

- `PHP_SESSION_TYPE`
- `PHP_SESSION_PATH`

启动命令示例如下：

```bash
# 运行redis
docker run -d --rm --name redis redis:3.2.12-alpine3.8

# 运行mysql
docker run -d --rm --name mysql -e MYSQL_ROOT_PASSWORD=pass4you mysql:5.7.38-debian

# 运行禅道
docker run -d --rm --name zentao \
--link mysql \
--link redis \
-e MYSQL_HOST=mysql \
-e MYSQL_PORT=3306 \
-e MYSQL_USER=root \
-e MYSQL_PASSWORD=pass4you \
-e MYSQL_DB=zentao \
-e PHP_SESSION_TYPE=redis \
-e PHP_SESSION_PATH=tcp://redis:6379 \
-v /data/zentao:/data \
-p 8088:80 \
easysoft/quickon-zentao:latest
```

指定上面两个环境变量，实际上就是修改了`php.ini`中关于Session的配置：

```ini
session.save_handler = redis
session.save_path = "tcp://redis:6379"
```

**注意**：

- 镜像内的脚本已经做了特殊处理，因此环境变量的值加不加引号，都不影响正常使用。
- 示例使用了link的方式连接了mysql和redis，因此可以直接使用连接名称来连接mysql和redis。
