<!-- 该文档是模板生成，手动修改的内容会被覆盖，详情参见：https://github.com/quicklyon/template-toolkit -->
# QuickOn ZenTao 应用镜像

![GitHub Workflow Status (event)](https://img.shields.io/github/actions/workflow/status/quicklyon/zentao-docker/zentao.yml?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/easysoft/quickon-zentao?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/easysoft/quickon-zentao?style=flat-square)
![GitHub tag](https://img.shields.io/github/v/tag/quicklyon/zentao-docker?style=flat-square)

## 快速参考

- 通过 [渠成软件百宝箱](https://www.qucheng.com/app-install/install-zentao-126.html) 一键安装 **ZenTao**
- [Dockerfile 源码](https://github.com/quicklyon/zentao-docker)
- [ZenTao 源码](https://github.com/easysoft/zentaopms)
- [ZenTao 官网](https://zentao.net/)

## 一、关于 ZenTao

<!-- 这里写应用的【介绍信息】 -->

禅道是一款开源的全生命周期项目管理软件，基于敏捷和CMMI管理理念进行设计，集产品管理、项目管理、质量管理、文档管理、组织管理和事务管理于一体，完整地覆盖了项目管理的核心流程。

禅和道是中国文化中极具代表意义的两个字，是中国传统文化的结晶。我们之所以选用“禅道”作为我们软件的名字，是希望通过这两个字来传达我们对管理的理解和思考。我们希望通过禅道来进行的管理，可以摒弃繁文缛节，还原管理的本质！

![screenshots](https://raw.githubusercontent.com/quicklyon/zentao-docker/master/.template/screenshots.png)

ZenTao官网：[https://zentao.net/](https://zentao.net/)


<!-- 这里写应用的【附加信息】 -->

## 二、支持的版本(Tag)

由于版本比较多,这里只列出最新的5个版本,更详细的版本列表请参考:[可用版本列表](https://hub.docker.com/r/easysoft/quickon-zentao/tags/)

y## 镜像版本

镜像地址:

- [easysoft/quickon-zentao](https://hub.docker.com/r/easysoft/quickon-zentao)
- `ccr.ccs.tencentyun.com/easysoft/quickon-zentao`(mirror镜像)

- 开源版
  - [`latest`, `18.5`, `18.5-20230713`](https://www.zentao.net/download/zentaopms18.5-82695.html)
  - [`18.4`, `18.4-20230625`](https://www.zentao.net/download/zentaopms18.4-82629.html)
  - [`18.3-20230424`](https://www.zentao.net/download/zentaopms18.3-82231.html)
  - [`18.2-20230315`](https://www.zentao.net/dynamic/zentaopms18.2-82151.html)
  - [`18.1-20230216`](https://www.zentao.net/download/zentaopms18.1-82069.html)
  - [`18.0-20230112`](https://www.zentao.net/download/zentaopms18.0-81998.html)

- 企业版
  - [`biz8.5`, `biz8.5-20230713`](https://www.zentao.net/download/biz8.5-82696.html)
  - [`biz8.5.k8s`, `biz8.5.k8s-20230713`](https://www.zentao.net/download/biz8.5-82696.html)
  - [`biz8.4`, `biz8.4-20230625`](https://www.zentao.net/download/biz8.4-82630.html)
  - [`biz8.4.k8s`, `biz8.4.k8s-20230625`](https://www.zentao.net/download/biz8.4-82630.html)
  - [`biz8.3-20230424`](https://www.zentao.net/download/biz8.3-82232.html)
  - [`biz8.3.k8s-20230424`](https://www.zentao.net/download/biz8.3-82232.html)
  - [`biz8.2-20230315`](https://www.zentao.net/dynamic/biz8.2-82152.html)
  - [`biz8.2.k8s-20230315`](https://www.zentao.net/dynamic/biz8.2-82152.html)
  - [`biz8.1-20230216`](https://www.zentao.net/download/biz8.1-82070.html)
  - [`biz8.1.k8s-20230216`](https://www.zentao.net/download/biz8.1-82070.html)
  - [`biz8.0-20230112`](https://www.zentao.net/download/zentaopms.biz8.0-81999.html)
  - [`biz8.0.k8s-20230112`](https://www.zentao.net/download/zentaopms.biz8.0-81999.html)

- 旗舰版
  - [`max4.5`, `max4.5-20230713`](https://www.zentao.net/download/max4.5-82697.html)
  - [`max4.5.k8s`, `max4.5.k8s-20230713`](https://www.zentao.net/download/max4.5-82697.html)
  - [`max4.4`, `max4.4-20230625`](https://www.zentao.net/download/max4.4-82631.html)
  - [`max4.4.k8s`, `max4.4.k8s-20230625`](https://www.zentao.net/download/max4.4-82631.html)
  - [`max4.3-20230424`](https://www.zentao.net/download/max4.3-82233.html)
  - [`max4.3.k8s-20230424`](https://www.zentao.net/download/max4.3-82233.html)
  - [`max4.2-20230315`](https://www.zentao.net/dynamic/max4.2-82153.html)
  - [`max4.2.k8s-20230315`](https://www.zentao.net/dynamic/max4.2-82153.html)
  - [`max4.1-20230216`](https://www.zentao.net/download/max4.1-82071.html)
  - [`max4.1.k8s-20230216`](https://www.zentao.net/download/max4.1-82071.html)
  - [`max4.0-20230112`](https://www.zentao.net/download/max4.0-82000.html)
  - [`max4.0.k8s-20230112`](https://www.zentao.net/download/max4.0-82000.html)

- 迅捷版
  - [`lite1.2-20221205`](https://www.zentao.net/download/zentaolitev1.2-80982.html)

- 迅捷企业版
  - [`litevip1.2-20221205`](https://www.zentao.net/download/zentaolitevipv1.2-80983.html)

- IPD版本
  - [`ipd1.0.beta1-20230522`](https://www.zentao.net/download/zentao-ipd-82471.html)

## 三、获取镜像

推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/quickon-zentao) 拉取我们构建好的官方Docker镜像。

```bash
docker pull easysoft/quickon-zentao:latest
```

如需使用指定的版本，可以拉取一个包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/quickon-zentao/tags/)

```bash
docker pull easysoft/quickon-zentao:[TAG]
```

## 四、持久化数据

禅道容器镜像做了特殊处理，将所有需要持久化的数据都保存到了 `/data` 目录，因此，运行禅道容器镜像，您只需要将持久化目录挂载到容器的 `/data` 目录即可。

如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
    easysoft/quickon-zentao:latest
```

或者修改 docker-compose.yml 文件，添加持久化目录配置

```bash
services:
  ZenTao:
  ...
    volumes:
      - /path/to/zentao-persistence:/data
  ...
```

## 五、环境变量

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

## 七、运行

### 7.1 单机Docker-compose方式运行

```bash
# 启动开源版及相关的服务
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f quickon-zentao

```

<!-- 这里写应用的【make命令的备注信息】位于文档最后端 -->
**说明:**

- [VERSION](https://github.com/quicklyon/zentao-docker/blob/master/VERSION) 文件中详细的定义了Makefile可以操作的版本
- [docker-compose.yml](https://github.com/quicklyon/zentao-docker/blob/master/docker-compose.yml)

### 7.2 Kubernetes通过helm命令安装开源版示例

```bash
helm repo add zentao https://hub.qucheng.com/chartrepo/stable
helm repo update
helm search repo zentao/zentao
helm upgrade -i zentao-open zentao/zentao --set ingress.enabled=true --set ingress.host=zentao.example.local
```

#### 高级自定义配置

```bash
# 下载zentao charts
helm pull zentao/zentao --untar
# 自定义配置 zentao/values.yaml, 示例
helm upgrade -i zentao-open zentao/zentao -f custom.yaml
```

## 八、版本升级

<!-- 这里是应用的【应用升级】信息，通过命令维护，详情参考：https://github.com/quicklyon/doc-toolkit -->
容器镜像已为版本升级做了特殊处理，当检测数据（数据库/持久化文件）版本与镜像内运行的程序版本不一致时，会进行数据库结构的检查，并自动进行数据库升级操作。

因此，升级版本只需要更换镜像版本号即可：

> 修改 docker-compose.yml 文件

```diff
...
  zentao:
-    image: easysoft/quickon-zentao:17.3-20220729
+    image: easysoft/quickon-zentao:17.4-20220817
    container_name: zentao
...
```

更新服务

```bash
# 是用新版本镜像更新服务
docker-compose up -d

# 查看服务状态和镜像版本
docker-compose ps
```

## 九、其他

### 9.1 容器内安装软件

容器内临时安装软件，可以通过封装好的 `/usr/sbin/install_packages` 命令，该命令支持设置`MIRROR`参数，国内使用时，指定 `MIRROR=true` 会使用国内的加速源。实例如下：

```bash
export MIRROR=true;install_packages vim
```
