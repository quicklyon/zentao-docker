{{WARNING}}
# QuickOn {{APP_NAME}} 应用镜像

![GitHub Workflow Status (event)](https://img.shields.io/github/actions/workflow/status/quicklyon/{{app_name}}-docker/zentao.yml?style=flat-square)
![Docker Pulls](https://img.shields.io/docker/pulls/easysoft/{{APP_DOCKER_IMAGE_NAME}}?style=flat-square)
![Docker Image Size](https://img.shields.io/docker/image-size/easysoft/{{APP_DOCKER_IMAGE_NAME}}?style=flat-square)
![GitHub tag](https://img.shields.io/github/v/tag/quicklyon/{{app_name}}-docker?style=flat-square)

## 快速参考

- 通过 [渠成软件百宝箱]({{APP_INSTALL_DOC_URL}}) 一键安装 **{{APP_NAME}}**
- [Dockerfile 源码]({{APP_DOCKERFILE_GIT_URL}})
- [{{APP_NAME}} 源码]({{APP_GIT_URL}})
- [{{APP_NAME}} 官网]({{APP_HOME}})

## 一、关于 {{APP_NAME}}

{{APP_DESC}}

{{APP_NAME}}官网：[{{APP_HOME}}]({{APP_HOME}})


{{APP_EXTRA_INFO}}

## 二、支持的版本(Tag)

由于版本比较多,这里只列出最新的5个版本,更详细的版本列表请参考:[可用版本列表]({{APP_DOCKER_HUB_TAG_URL}})

{{APP_DOCKER_TAG}}

## 三、获取镜像

推荐从 [Docker Hub Registry]({{APP_DOCKER_HUB_URL}}) 拉取我们构建好的官方Docker镜像。

```bash
docker pull easysoft/{{APP_DOCKER_IMAGE_NAME}}:latest
```

如需使用指定的版本，可以拉取一个包含版本标签的镜像，在Docker Hub仓库中查看 [可用版本列表]({{APP_DOCKER_HUB_TAG_URL}})

```bash
docker pull easysoft/{{APP_DOCKER_IMAGE_NAME}}:[TAG]
```

## 四、运行镜像

禅道容器镜像做了特殊处理，将所有需要持久化的数据都保存到了 `/data` 目录，因此，运行禅道容器镜像，您只需要将持久化目录挂载到容器的 `/data` 目录即可。

如果挂载的目录为空，首次启动会自动初始化相关文件

```bash
docker run -it \
    -v $PWD/data:/data \
    -e MYSQL_INTERNAL=true \
    easysoft/{{APP_DOCKER_IMAGE_NAME}}:latest
```

> 执行上面的命令后，会启动禅道镜像，通过设置 `MYSQL_INTERNAL=true` 会启动内置的MySQL服务。

### 4.1 使用外部的MySQL服务

连接到外部MySQL服务：
```bash
docker run -it \
    -v $PWD/data:/data \
    -e MYSQL_INTERNAL=false \
    -e ZT_MYSQL_HOST=<你的MySQL服务地址> \
    -e ZT_MYSQL_PORT=<你的MySQL服务端口> \
    -e ZT_MYSQL_USER=<你的MySQL服务用户名> \
    -e ZT_MYSQL_PASSWORD=<你的MySQL服务密码> \
    easysoft/{{APP_DOCKER_IMAGE_NAME}}:latest
```

> 通过设置 `MYSQL_INTERNAL=false` ，并且设置MySQL相关的环境变量，运行镜像后，可以连接到外部的MySQL

如果用dockoer-compose运行，可以参考 [docker-compose.yml.example](./docker-compose.yml.example) 文件:

```yaml
...
# mysql service for zentao
  zentao-mysql:
    image: mysql:5.7
    container_name: zentao-mysql
    ports:
      - '13306:3306'
    volumes:
      - /data/zentao/db:/var/lib/mysql
    environment:
      - MYSQL_ROOT_PASSWORD=pass4Zentao
      - ZT_MYSQL_DB=zentao
    networks:
      - zentao-net
...
```

## 五、环境变量

{{APP_ENVS}}

## 七、运行

### 7.1 单机Docker-compose方式运行

```bash
# 启动开源版及相关的服务
make run

# 查看服务状态
make ps

# 查看服务日志
docker-compose logs -f {{APP_DOCKER_IMAGE_NAME}}

```

{{MAKE_EXTRA_INFO}}

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

{{APP_UPDATE}}

## 九、其他

### 9.1 容器内安装软件

容器内临时安装软件，可以通过封装好的 `/usr/sbin/install_packages` 命令，该命令支持设置`MIRROR`参数，国内使用时，指定 `MIRROR=true` 会使用国内的加速源。实例如下：

```bash
export MIRROR=true;install_packages vim
```
