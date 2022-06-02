# 禅道官方Docker镜像

[toc]

## 一、关于禅道

禅道是一款开源的全生命周期项目管理软件，基于敏捷和CMMI管理理念进行设计，集产品管理、项目管理、质量管理、文档管理、组织管理和事务管理于一体，完整地覆盖了项目管理的核心流程。

禅和道是中国文化中极具代表意义的两个字，是中国传统文化的结晶。我们之所以选用“禅道”作为我们软件的名字，是希望通过这两个字来传达我们对管理的理解和思考。我们希望通过禅道来进行的管理，可以摒弃繁文缛节，还原管理的本质！

官网：https://www.zentao.net/


## 二、支持的标签
- 开源版：16.3
- 企业版：6.3
- 旗舰版：2.6 【目前只支持该标签】

## 三、获取镜像
推荐从 [Docker Hub Registry](https://hub.docker.com/r/easysoft/zentao) 拉取我们构建好的官方Docker镜像【目前提供国内加速镜像地址】
```bash
docker pull ccr.ccs.tencentyun.com/easysoft/zentao:max-2.6
```

如需使用指定的版本，可以拉取一个包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表](https://hub.docker.com/r/easysoft/zentao/tags/) 【目前仅支持:max-2.6】

```bash
docker pull ccr.ccs.tencentyun.com/easysoft/zentao:[TAG]
```

## 四、持久化数据
如果你删除容器，所有的数据都将被删除，下次运行镜像时会重新初始化数据。为了避免数据丢失，你应该为容器提供一个挂在卷，这样可以将数据进行持久化存储。

为了数据持久化，你应该挂载2个目录：

- /data 禅道数据
- /var/lib/mysql MySQL数据库 (如果设置 ENABLE_MYSQL=true 会启动MySQL服务 )
如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
$ docker run -it \
    -e ENABLE_MYSQL=true \
    -v $PWD/mysql:/var/lib/mysql \
    -v $PWD/data:/data \
    ccr.ccs.tencentyun.com/easysoft/zentao:max-2.6
```
或者修改docker-compose.yml 文件，添加持久化目录配置

```bash
services:
  zentao:
  ...
    volumes:
      - /path/to/zentao-persistence:/data
      - /path/to/zentao-mysql:/var/lib/mysql
  ...
```
## 五、环境变量

| 变量名           | 默认值        | 说明                             |
| ---------------- | ------------- | -------------------------------- |
| DEBUG            | false         | 是否打开调试信息，默认关闭       |
| ENABLE_MYSQL     | false         | 是否启动MySQL服务，默认关闭      |
| PHP_SESSION_TYPE | files         | php session 类型，files \| redis |
| PHP_SESSION_PATH | /data/session | php session 存储路径             |
| MYSQL_HOST       | 127.0.0.1     | MySQL 主机地址                   |
| MYSQL_PORT       | 3306          | MySQL 端口                       |
| MYSQL_DATABASE   | zentao        | zentao数据库名称                 |
| MYSQL_USER       | root          | MySQL用户名                      |
| MYSQL_PASSWORD   | pass4zenTao   | MySQL密码                        |




## 六、运行 
### 6.1 单机Docker命令运行

```bash
docker run -it -e DEBUG=true \
               -e ENABLE_MYSQL=true \
               -v $PWD/data:/data \
               -v $PWD/mysql:/var/lib/mysql \
               -p 8080:80 \
           	   ccr.ccs.tencentyun.com/easysoft/zentao:max-2.6
```

> **说明：**
>
> - 设置环境变量 `ENABLE_MYSQL=true` 会启动镜像中内置的MySQL服务
> - 如果不指定MySQL密码，会使用默认值：`pass4zenTao`
> - 首次启动成功后，打开浏览器访问 `http://<IP>:8080/` 会打开禅道安装向导页面
>   - ![数据库设置向导页](https://doc-pic-1308438674.cos.ap-shanghai.myqcloud.com/project/cloud-zentao/20220223/OByTww.png)

### 6.2 单机Docker-compose方式运行

通过Docker-compse运行禅道，默认会运行一个独立的MySQL服务，相关命令如下：

```bash
# 启动服务（zentao和mysql）
docker-compose up -d

# 查看服务状态
docker-compose ps

# 查看服务日志
docker-compose logs -f zentao # 查看zentao日志
docker-compose logs -f mysql # 查看mysql日志
```



以下是docker-compose.yml文件详情

```yml
version: '2'
services:

# mysql service for zentao
  mysql:
    image: mysql:5.7
    container_name: mysql
    ports:
      - '3306:3306'
    volumes:
      - 'db:/var/lib/mysql'
    environment:
      - MYSQL_ROOT_PASSWORD=pass4Zentao
      - MYSQL_DATABASE=zentao

# zentao service
  zentao:
    image: ccr.ccs.tencentyun.com/easysoft/zentao:max-2.6
    container_name: zentao
    ports:
      - '8080:80'
    volumes:
      - 'zentao_data:/data'
    depends_on:
      - mysql
    environment:
      - MYSQL_HOST=mysql
      - MYSQL_PORT=3306
      - MYSQL_USER=root
      - MYSQL_PASSWORD=pass4Zentao
      - MYSQL_DB=zentao
      - DEBUG=true

# persistence for mysql and zentao
volumes:
  db:
    driver: local
  zentao_data:
    driver: local
```

> **说明：**
>
> - 通过docker-compose运行，会拉取mysql和redis镜像，并运行
> - 启动成功后，打开浏览器输入 `http://<你的IP>:8080` 通过向导页面进行安装
> - 数据库配置参考 [单机Docker命令运行](#6.1 单机Docker命令运行)

### 6.3 在 Kubernetes 中运行

我们通过 Helm封装了禅道应用，包含禅道Web服务，MySQL服务，Redis服务。

#### 6.3.1 前提条件

1. Kubernetes 1.19+ 最佳
2. Helm 3.2.0+
3. K8S集群需要提前配置默认的共享存储（分布式存储），通过`kubectl get sc` 查看

#### 6.3.2 特性

- 支持禅道web服务多副本运行（需要K8S持久化目录支持分布式存储）
- MySQL服务独立运行（当前交付版本 只支持单节点）
- Redis作为Session存储，并独立运行（当前交付版本 只支持单节点）

#### 6.3.3 安装命令

```bash
# 配置Helm仓库
helm repo add zentao https://helm.external-prod.chandao.net
helm repo update

# 为禅道服务创建独立namespace
kubectl create ns zentao-app

# 启动禅道服务
helm upgrade -i zentao zentao/zentao -n zentao-app --set ingress.hostname=zentao.local --set replicaCount=2 --set image.pullPolicy=Always

# 卸载服务
helm delete zentao -n zentao-app # 删除服务
kubectl delete pvc --all -n zentao-app # 清理持久化存储
```

> **说明：**
>
> 1. ingress.hostname=< 设置内部可用域名 > 需要设置域名
> 2. 可以通过修改helm的配置来定制安装
>
> ```bash
> # 下载helm配置
> cd /tmp
> helm pull zentao/zentao --untar
> 
> # 切换到配置目录
> cd /tmp/zentao
> 
> # 修改自定配置
> vi /tmp/zentao/values.yaml
> ```
>
> 



## 七、已知问题

- K8S中运行时，MySQL和Redis均为单点，后续版本提供集群部署
- 禅道Web端多副本运行时，某些需要管理员确认的操作，如创建 ok.txt 文件以便验证的功能，后续版本修复
- 禅道Web端多副本运行时，计划任务不支持多节点运行，后续版本修复
