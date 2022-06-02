# ZenTao official Docker image

## 1.What is ZenTao?

ZenTao is an open-source project management software, developed by Nature EasyCorp. Combining product management, project management, test management, document management, company management, and todo management. It is a professional project management software, covering the core process of software development projects.

ZenTao is practical and pragmatic. It has full features and beautiful interfaces and is easy to use. ZenTao is well structured and can be flexibly extended. It also has powerful search features, various forms of statistical reports, and complete API.

ZenTao focuses on development project management!

Official website: www.zentao.pm


## 2.Supported tags
- 开源版：16.3
- 企业版：6.3
- 旗舰版：2.6

## 3.Get this image
The recommended way to get the zentao official  Docker Image is to pull the prebuilt image from the [Docker Hub Registry](https://hub.docker.com/r/easysoft/zentao).
```bash
docker pull easysoft/zentao:latest
```

To use a specific version, you can pull a versioned tag. You can view the [list of available versions](https://hub.docker.com/r/easysoft/zentao/tags/) in the Docker Hub Registry.

```bash
docker pull easysoft/zentao:[TAG]
```

## 4.Persisting your database
If you remove the container all your data will be lost, and the next time you run the image the database will be reinitialized. To avoid this loss of data, you should mount a volume that will persist even after the container is removed.

For data persistence, you should mount two directories:
- /data ZenTao data
- /var/lib/mysql MySQL database files ( If ENABLE_MYSQL=true is set, the MySQL service will be started)

```bash
$ docker run -it \
    -e ENABLE_MYSQL=true \
    -v $PWD/mysql:/var/lib/mysql \
    -v $PWD/data:/data \
    easysoft/zentao:latest
```
or by modifying the docker-compose.yml file add persistent directory configuration

```bash
services:
  zentao:
  ...
    volumes:
      - /path/to/zentao-mysql:/var/lib/mysql
  ...
```
## 5. Environment Variables

| 变量名           | 默认值             | 说明                        |
| ---------------- | ------------------ | --------------------------- |
| DEBUG            | false              | 是否打开调试信息，默认关闭  |
| ENABLE_MYSQL     | false              | 是否启动MySQL服务，默认关闭 |
| PHP_SESSION_TYPE | files              | php session 类型            |
| PHP_SESSION_PATH | /opt/zbox/tmp/php/ | php session 存储路径        |
| MYSQL_HOST       | 127.0.0.1          | MySQL 主机地址              |
| MYSQL_PORT       | 3306               | MySQL 端口                  |
| MYSQL_DB         | zentao             | zentao数据库名称            |
| MYSQL_USER       | root               | MySQL用户名                 |
| MYSQL_PASSWORD   | pass4zenTao        | MySQL密码                   |




## 6.运行 
### 6.1 单机Docker命令运行

```bash
docker run -it -e DEBUG=true \
               -e ENABLE_MYSQL=true \
               -v $PWD/data:/data \
               -v $PWD/mysql:/var/lib/mysql \
               -p 8080:80 \
           	   easysoft/zentao:max-2.6
```



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
    build: .
    image: easysoft/zentao:max-2.6
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



### 6.3 在 Kubernetes 中运行