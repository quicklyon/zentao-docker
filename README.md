# 禅道官方Docker镜像

[toc]

## 一、关于禅道

禅道是一款开源的全生命周期项目管理软件，基于敏捷和CMMI管理理念进行设计，集产品管理、项目管理、质量管理、文档管理、组织管理和事务管理于一体，完整地覆盖了项目管理的核心流程。

禅和道是中国文化中极具代表意义的两个字，是中国传统文化的结晶。我们之所以选用“禅道”作为我们软件的名字，是希望通过这两个字来传达我们对管理的理解和思考。我们希望通过禅道来进行的管理，可以摒弃繁文缛节，还原管理的本质！

官网：https://www.zentao.net/

## 二、支持的标签

- 开源版：17.0
- 企业版：biz7.0
- 旗舰版：max2.8 max3.1

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

## 六、运行

### 6.1 通过make命令运行

[Makefile](./Makefile)中详细的定义了可以使用的参数。

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

- [VERSION](./VERSION) 文件中详细的定义了Makefile可以操作的版本
- [docker-compose.yml](./docker-compose.yml)

### 6.3 在 Kubernetes 中运行

我们通过 Helm封装了禅道应用，供[渠成平台](https://www.qucheng.com)使用，包含禅道Web服务，MySQL服务，您可以直接通过Helm命令添加渠成的Helm仓库。

#### 6.3.1 前提条件

1. Kubernetes 1.19+ 最佳
2. Helm 3.2.0+
3. K8S集群需要提前配置默认的共享存储（分布式存储），通过`kubectl get sc` 查看

#### 6.3.2 特性

- 支持禅道web服务多副本运行（需要K8S持久化目录支持分布式存储）
- MySQL服务独立运行（当前交付版本 只支持单节点）

#### 6.3.3 安装命令

```bash
# 配置Helm仓库
helm repo add qucheng-market https://hub.qucheng.com/chartrepo/stable
helm repo update

# 为禅道服务创建独立namespace
kubectl create ns easysoft

# 启动禅道旗舰版
helm upgrade -i zentao-max qucheng-market/zentao-max -n easysoft --set ingress.hostname=zentao.local --set replicaCount=2 --set image.pullPolicy=Always

# 卸载服务
helm delete zentao-max -n easysoft # 删除服务
kubectl delete pvc --all -n easysoft # 清理持久化存储
```

> **说明：**
>
> 1. ingress.hostname=< 设置内部可用域名 > 需要设置域名
> 2. 通过helm安装的禅道是当前最新版本，详情可通过 `helm search repo zentao` 查看
