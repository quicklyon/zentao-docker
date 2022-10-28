<!-- 该文档是模板生成，手动修改的内容会被覆盖，详情参见：https://github.com/quicklyon/template-toolkit -->
# QuickOn ZenTao 应用镜像

![GitHub Workflow Status (event)](https://img.shields.io/github/workflow/status/quicklyon/zentao-docker/build?style=flat-square)
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

## 镜像版本

镜像地址: [easysoft/quickon-zentao](https://hub.docker.com/repository/docker/easysoft/quickon-zentao)

- 开源版
  - [`17.7-20221028`](https://www.zentao.net/download/zentaopms17.7-81744.html)
  - [`17.6.2-20220929`](https://www.zentao.net/dynamic/zentaopms17.6.2-81636.html)
  - [`17.6.1-20220916`](https://www.zentao.net/download/zentaopms17.6.1-81580.html)
  - [`17.6-20220901`](https://www.zentao.net/download/zentaopms17.6-81531.html)
  - [`17.5-20220818`](https://www.zentao.net/download/zentaopms17.5-81507.html)
  - [`17.4-20220818`](https://www.zentao.net/download/zentaopms17.4-81093.html)
  - [`17.3-20220729`](https://www.zentao.net/download/zentaopms17.3-81058.html)

- 企业版
  - [`biz7.7-20221028`](https://www.zentao.net/download/zentaopms.biz7.7-81745.html)
  - [`biz7.7.k8s-20221028`](https://www.zentao.net/download/zentaopms.biz7.7-81745.html)
  - [`biz7.6.2-20220929`](https://www.zentao.net/dynamic/zentaopms.biz7.6.2-81637.html)
  - [`biz7.6.2.k8s-20220929`](https://www.zentao.net/dynamic/zentaopms.biz7.6.2-81637.html)
  - [`biz7.6.1-20220916`](https://www.zentao.net/download/zentaopms.biz7.6.1-81581.html)
  - [`biz7.6-20220901`](https://www.zentao.net/download/zentaopms.biz7.6-81529.html)
  - [`biz7.5-20220818`](https://www.zentao.net/download/zentaopms.biz7.5-81508.html)
  - [`biz7.4-20220818`](https://www.zentao.net/download/zentaopms.biz7.4-81094.html)
  - [`biz7.3-20220729`](https://www.zentao.net/download/zentaopms.biz7.3-81060.html)

- 旗舰版
  - [`max3.7-20221028`](https://www.zentao.net/download/max3.7-81746.html)
  - [`max3.7.k8s-20221028`](https://www.zentao.net/download/max3.7-81746.html)
  - [`max3.6.3-20220929`](https://www.zentao.net/dynamic/max3.6.3-81638.html)
  - [`max3.6.3.k8s-20220929`](https://www.zentao.net/dynamic/max3.6.3-81638.html)
  - [`max3.6.2-20220916`](https://www.zentao.net/download/max3.6.1-81530.html)
  - [`max3.6.1-20220901`](https://www.zentao.net/download/max3.6.1-81530.html)
  - [`max3.6-20220818`](https://www.zentao.net/download/max3.6-81509.html)
  - [`max3.5-20220818`](https://www.zentao.net/download/max3.5-81095.html)
  - [`max3.4-20220729`](https://www.zentao.net/download/max3.4-81061.html)
  - [`max3.3-20220729`](https://www.zentao.net/dynamic/max3.3-81023.html)

- 迅捷版
  - [`lite1.2-20220818`](https://www.zentao.net/download/zentaolitev1.2-80982.html)

- 迅捷企业版
  - [`litevip1.2-20220818`](https://www.zentao.net/download/zentaolitevipv1.2-80983.html)

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

如果你删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，你应该为容器提供一个挂在卷，这样可以将数据进行持久化存储。

为了数据持久化，你应该挂载持久化目录：

- /data 持久化数据

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
      - /path/to/gogs-persistence:/data
  ...
```

## 五、环境变量

<!-- 这里写应用的【环境变量信息】 -->
| 变量名           | 默认值        | 说明                             |
| ---------------- | ------------- | -------------------------------- |
| DEBUG            | false         | 是否打开调试信息，默认关闭       |
| PHP_SESSION_TYPE | files         | php session 类型，files \| redis |
| PHP_SESSION_PATH | /data/php/session | php session 存储路径             |
| PHP_MAX_EXECUTION_TIME | 120 | 最大执行时间，单位秒，有助于防止有问题程序占尽服务器资源。默认设置为 120             |
| PHP_MEMORY_LIMIT | 256M | 单个php进程允许分配的最大内存             |
| PHP_POST_MAX_SIZE | 128M | 允许最大Post数据大小             |
| PHP_UPLOAD_MAX_FILESIZE | 128M | 单个文件上传的最大值             |
| MYSQL_HOST       | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DB         | zentao        | zentao数据库名称                 |
| MYSQL_USER       | root          | MySQL用户名                      |
| MYSQL_PASSWORD   | pass4zenTao   | MySQL密码                        |
| LDAP_ENABLED     | false         | 是否启用LDAP                      |
| LDAP_HOST        | 127.0.0.1     | LDAP服务主机地址   |
| LDAP_PORT        | 389           | LDAP服务端口      |
| LDAP_BASEDN      | dc=quickon,dc=org | LDAP BaseDN  |
| LDAP_ADMINUSER   | cn=admin,dc=quickon,dc=org | LDAP 管理员  |
| LDAP_BINDPASSWORD| pass4zenTao   | LDAP Bind 密码                |
| LDAP_USERKEY     | uid           | LDAP 用户名称的字段名       |
| LDAP_EMAILKEY    | mail          | LDAP 用户邮箱的字段名       |
| IS_CONTAINER     | true          | 是否在容器内运行，zentao更新时使用|

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
# 启动服务
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
