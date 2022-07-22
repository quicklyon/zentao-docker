# 禅道官方Docker镜像

## 一、关于禅道

禅道是一款开源的全生命周期项目管理软件，基于敏捷和CMMI管理理念进行设计，集产品管理、项目管理、质量管理、文档管理、组织管理和事务管理于一体，完整地覆盖了项目管理的核心流程。

禅和道是中国文化中极具代表意义的两个字，是中国传统文化的结晶。我们之所以选用“禅道”作为我们软件的名字，是希望通过这两个字来传达我们对管理的理解和思考。我们希望通过禅道来进行的管理，可以摒弃繁文缛节，还原管理的本质！

官网：[www.zentao.net](https://www.zentao.net/)

## 二、支持的版本(Tag)

> 历史版本比较多，下面只列出最新的3个版本，详细版本请参考 [版本列表](https://hub.docker.com/r/easysoft/zentao/tags)

- 开源版
  - [`17.3-20220722`](https://www.zentao.net/download/zentaopms17.3-81058.html)
  - [`17.2`](https://www.zentao.net/dynamic/zentaopms17.2-81021.html)
  - [`17.1`](https://www.zentao.net/download/zentaopms17.1-80973.html)

- 企业版
  - [`biz7.3-20220722`](https://www.zentao.net/download/zentaopms.biz7.3-81060.html)
  - [`biz7.2`](https://www.zentao.net/dynamic/zentaopms.biz7.2-81022.html)
  - [`biz7.1`](https://www.zentao.net/download/zentaopms.biz7.1-80974.html)

- 旗舰版
  - [`max3.4-20220722`](https://www.zentao.net/download/max3.4-81061.html)
  - [`max3.3-20220722`](https://www.zentao.net/dynamic/max3.3-81023.html)
  - [`max3.2`](https://www.zentao.net/download/max3.2-80975.html)

- 迅捷版
  - [`lite1.2-20220722`](https://www.zentao.net/download/zentaolitev1.2-80982.html)
  - [`lite1.1`](https://www.zentao.net/dynamic/zentaolitev1.1-80683.html)

- 迅捷企业版
  - [`litevip1.2-20220722`](https://www.zentao.net/download/zentaolitevipv1.2-80983.html)
  - [`litevip1.1`](https://www.zentao.net/dynamic/zentaolitevipv1.1-80684.html)

## 三、获取镜像

推荐从 渠成镜像仓库 拉取我们构建好的官方Docker镜像

```bash
docker pull hub.qucheng.com/app/zentao:[TAG]
```

## 四、持久化数据

如果删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，应该为容器提供一个挂载卷，这样可以将数据进行持久化存储。

- /data 禅道数据
如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -v $PWD/data:/data \
    hub.qucheng.com/app/zentao:max3.1
```

## 五、环境变量

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
hub.qucheng.com/app/zentao:17.2
```

指定上面两个环境变量，实际上就是修改了`php.ini`中关于Session的配置：

```ini
session.save_handler = redis
session.save_path = "tcp://192.168.0.99:6379?auth=Reids验证密码"
```

**注意**：镜像内的脚本已经做了特殊处理，因此环境变量的值加不加引号，都不影响正常使用。

## 七、运行

### 7.1 通过make命令运行

[Makefile](https://github.com/quicklyon/zentao-docker/blob/master/Makefile)中详细的定义了可以使用的参数。

```bash
# 运行禅道开源版
make run

# 关闭禅道开源版
make stop

# 清理容器与持久化数据
make clean

# 构建镜像
# 构建开源版镜像
make build

# 构建旗舰版镜像
make build-max

```

说明

- [VERSION](https://github.com/quicklyon/zentao-docker/blob/master/VERSION) 文件中详细的定义了Makefile可以操作的版本
- [docker-compose.yml](https://github.com/quicklyon/zentao-docker/blob/master/docker-compose.yml)
