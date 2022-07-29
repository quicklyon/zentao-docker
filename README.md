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

![screenshots](https://github.com/quicklyon/zentao-docker/blob/master/.template/screenshots.png)

ZenTao官网：[https://zentao.net/](https://zentao.net/)


<!-- 这里写应用的【附加信息】 -->

## 二、支持的版本(Tag)

由于版本比较多,这里只列出最新的5个版本,更详细的版本列表请参考:[可用版本列表](https://hub.docker.com/r/easysoft/quickon-zentao/tags/)

<!-- 这里是应用的【Tag】信息，通过命令维护，详情参考：https://github.com/quicklyon/doc-toolkit -->

- 开源版
  - [`17.3-20220725`](https://www.zentao.net/download/zentaopms17.3-81058.html)

- 企业版
  - [`biz7.3-20220725`](https://www.zentao.net/download/zentaopms.biz7.3-81060.html)

- 旗舰版
  - [`max3.4-20220725`](https://www.zentao.net/download/max3.4-81061.html)
  - [`max3.3-20220722`](https://www.zentao.net/dynamic/max3.3-81023.html)

- 迅捷版
  - [`lite1.2-20220725`](https://www.zentao.net/download/zentaolitev1.2-80982.html)

- 迅捷企业版
  - [`litevip1.2-20220725`](https://www.zentao.net/download/zentaolitevipv1.2-80983.html)

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
| MYSQL_HOST       | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DB         | zentao        | zentao数据库名称                 |
| MYSQL_USER       | root          | MySQL用户名                      |
| MYSQL_PASSWORD   | pass4zenTao   | MySQL密码                        |

## 六、将Session存储在Redis

禅道默认是将Session存储在共享存储中，因此多节点部署也可以满足Session共享的需求，但如果你想通过Redis来存储Session也是可以的，只需要在启动容器是传入两个参数即可：

- `PHP_SESSION_TYPE`
- `PHP_SESSION_PATH`

启动命令示例如下：

```bash
docker run -d --restart unless-stopped --name zentao \
-e MYSQL_HOST=192.168.0.88 \
-e MYSQL_PORT=3306 \
-e MYSQL_USER=root \
-e MYSQL_PASSWORD=MySQL密码 \
-e MYSQL_DB=zentao \
-e PHP_SESSION_TYPE=redis \
-e PHP_SESSION_PATH=tcp://192.168.0.99:6379?auth=Reids验证密码 \
-v /data/zentao:/data \
-p 8088:80 \
easysoft/quickon-zentao:latest
```

指定上面两个环境变量，实际上就是修改了`php.ini`中关于Session的配置：

```ini
session.save_handler = redis
session.save_path = "tcp://192.168.0.99:6379?auth=Reids验证密码"
```

**注意**：镜像内的脚本已经做了特殊处理，因此环境变量的值加不加引号，都不影响正常使用。

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
