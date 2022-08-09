DNMP（Docker + Nginx + MySQL + PHP + Redis）是一款优雅的**LNMP一键安装程序，支持Arm CPU**。

> 使用前最好提前阅读一遍[目录](#目录)，以便快速上手，遇到问题也能及时排除。

[**[GitHub地址]**](https://github.com/imeepo/dnmp) -
[**[Gitee地址]**](https://gitee.com/imeepo/dnmp)

DNMP项目特点：
1. `100%`开源
2. `100%`遵循Docker标准
3. 支持**多版本PHP**共存，可任意切换（PHP5.6、PHP7.1、PHP7.2、PHP7.3、PHP7.4、PHP8.0、PHP8.1)
4. 支持**多版本MySQL**共存，（MySQL5.7、MySQL8.0)
5. 支持绑定**任意多个域名**
6. 支持**HTTPS和HTTP/2**
7. **PHP源代码、MySQL数据、配置文件、日志文件**都可在Host中直接修改查看
8. 内置**完整PHP扩展安装**命令，支持常用热门扩展，可根据环境灵活配置
9. 可一键选配常用服务：
    - 多PHP版本：PHP5.6、PHP7.0-7.4、PHP8.0-8.1
    - Web服务：Nginx
    - 数据库：MySQL5.7、MySQL8.0、Redis
10. 实际项目中应用，确保`100%`可用
11. 所有镜像源于[Docker官方仓库](https://hub.docker.com)，安全可靠
12. 一次配置，**Windows、Linux、MacOs**皆可用
13. 支持快速安装扩展命令 `install-php-extensions apcu`

# 目录
- [目录](#目录)
  - [1.目录结构](#1目录结构)
  - [2.快速使用](#2快速使用)
  - [3.PHP和扩展](#3php和扩展)
    - [3.1 切换Nginx使用的PHP版本](#31-切换nginx使用的php版本)
    - [3.2 安装PHP扩展](#32-安装php扩展)
    - [3.3 快速安装php扩展](#33-快速安装php扩展)
    - [3.4 使用composer](#34-使用composer)
  - [4.管理命令](#4管理命令)
    - [4.1 服务器启动和构建命令](#41-服务器启动和构建命令)
    - [4.2 添加快捷命令](#42-添加快捷命令)
    - [4.3 查看docker网络](#43-查看docker网络)
    - [4.4 查看docker容器ip](#44-查看docker容器ip)
  - [5.使用Log](#5使用log)
    - [5.1 Nginx日志](#51-nginx日志)
    - [5.2 PHP-FPM日志](#52-php-fpm日志)
    - [5.3 MySQL日志](#53-mysql日志)
  - [6.在正式环境中安全使用](#6在正式环境中安全使用)
  - [7 常见问题](#7-常见问题)
    - [7.1 Docker容器时间](#71-docker容器时间)
    - [7.2 如何连接MySQL和Redis服务器](#72-如何连接mysql和redis服务器)
    - [7.3 容器内的php如何连接宿主机MySQL](#73-容器内的php如何连接宿主机mysql)
    - [7.4 SQLSTATE[HY000] [1130] Host '172.19.0.2' is not allowed to connect to this MySQL server](#74-sqlstatehy000-1130-host-1721902-is-not-allowed-to-connect-to-this-mysql-server)


## 1.目录结构

```text
├── data                        数据库数据目录
│   └── mysql57                 MySQL5.7 数据目录
│   ├── mysql80                 MySQL8.0 数据目录
│   ├── redis                   Redis 数据目录
├── logs                        日志目录
├── services                    服务构建文件和配置文件目录
│   ├── mysql80                 MySQL8.0 配置文件目录
│   ├── mysql57                 MySQL5.7 配置文件目录
│   ├── nginx                   Nginx 配置文件目录
│   ├── php                     PHP5.6 - PHP8.1 配置目录
│   └── redis                   Redis 配置目录
└── www                         项目目录
│   └── default                 Nginx 默认目录
├── .env.smaple                 环境配置示例文件
├── .gitignore                  Git忽略文件列表
├── docker-compose.sample.yml   Docker 服务配置示例文件
├── imeepo-delete.sh            脚本：一键删除所有容器&镜像
├── imeepo-init.sh              脚本：首次运行(配置文件初始化)
├── imeepo-start.sh             脚本：一键构建/启动
└── README.md                   自述文件
```

## 2.快速使用
1. 本地安装
    - `git`
    - `Docker`(系统需为Linux，Windows 10 Build 15063+，或MacOS 10.12+，且必须要`64`位）
    - `docker-compose 1.7.0+`
    > [安装Docker及docker-compose教程](https://www.imeepo.com/?p=10)

2. `clone`项目：
    ```bash
    # Gitee(推荐)
    git clone https://gitee.com/imeepo/dnmp.git
    # Github
    git clone https://github.com/imeepo/dnmp.git
    # 米波Gitea
    git clone https://git.imeepo.com/docker/dnmp.git
    ```

3. 如果主机是 Linux系统，且当前用户不是`root`用户，还需将当前用户加入`docker`用户组：
    ```bash
    sudo gpasswd -a ${USER} docker
    ```

4.  > 脚本一键安装（推荐）

    运行初始化脚本后，运行一键启动脚本，即可自动构建
    
    ```bash
	# 进入项目目录
    cd dnmp
    # 赋予初始化脚本执行权限
    chmod +x imeepo-init.sh
    # 初始化配置文件
    ./imeepo-init.sh

    # 默认启动4个服务：Nginx、MySQL5.7、PHP7.0、Redis，要开启更多其他服务请删除服务块前的#注释

    # 一键安装
    ./imeepo-start.sh

    # 删除全部容器和镜像 (如不需要可删除此脚本！！！)
    ./imeepo-delete.sh
    ```
    
    > 手动安装
    
    拷贝并命名配置文件（Windows系统请用`copy`命令），启动：
    ```bash
    # 进入项目目录
    cd dnmp
    # 复制环境变量文件
    cp .env.example .env
    # 复制 docker-compose 配置文件
    cp docker-compose.sample.yml docker-compose.yml 

    # 默认启动4个服务：Nginx、MySQL5.7、PHP7.0、Redis，要开启更多其他服务请删除服务块前的#注释

    # 赋予Mysql日志权限
    chmod -R 777 ./logs/mysql57
    chmod -R 777 ./logs/mysql80

    # 复制redis配置文件
    cp ./services/redis/redis.conf.example ./services/redis/redis.conf
    # 启动
    docker-compose up -d                              
    ```
    赋予MySQL日志目录777权限的讲解请看[5.3 MySQL日志](#53-mysql日志)


5. > 本地搭建：在浏览器中访问：`http://localhost`
   
   > 服务器搭建：在浏览器中访问：`http://你的ip地址`

   即可看到nginx默认404页面

## 3.PHP和扩展
### 3.1 切换Nginx使用的PHP版本
首先，需要启动对应版本的PHP，比如PHP8.0，那就先在`./services/nginx/conf.d/`目录下，你网站的配置文件中，删除PHP版本选择下一句代码前面的注释，把`php70`改为你的版本，如`php80`，然后重启nginx

其中 `php70` 和 `php80` 是`docker-compose.yml`文件中容器的名称。

最后，**重启 Nginx** 生效（以下方法二选一即可）。

```bash
# 直接重启nginx容器
docker restart nginx

# 或者单独重载nginx容器内nginx服务
# 这里两个`nginx`，第一个是容器名，第二个是容器中的`nginx`程序。
docker exec -it nginx nginx -s reload
```

### 3.2 安装PHP扩展
PHP的很多功能都是通过扩展实现，而安装扩展是一个略费时间的过程，
所以，除PHP内置扩展外，在`.env.example`文件中我们仅默认安装少量扩展，
如果要安装更多扩展，请打开你的`.env`文件修改如下的PHP配置，
增加需要的PHP扩展：
```bash
# PHP7.0 要安装的扩展列表，英文逗号隔开
PHP_70_EXTENSIONS=pdo_mysql,opcache,redis
# PHP8.0 要安装的扩展列表，英文逗号隔开
PHP_80_EXTENSIONS=opcache,redis                 
```

然后重新构建 PHP7.0镜像。
```bash
docker-compose build php70
```

不同版本可用的扩展请查看`.env.example`不同PHP版本扩展上方注释块说明。

### 3.3 快速安装php扩展
1.进入容器:

```sh
docker exec -it php /bin/sh
# 安装apcu扩展
install-php-extensions apcu 
```

2.支持快速安装扩展列表
<!-- START OF EXTENSIONS TABLE -->
<!-- ########################################################### -->
<!-- #                                                         # -->
<!-- #  DO NOT EDIT THIS TABLE: IT IS GENERATED AUTOMATICALLY  # -->
<!-- #                                                         # -->
<!-- #  EDIT THE data/supported-extensions FILE INSTEAD        # -->
<!-- #                                                         # -->
<!-- ########################################################### -->
| Extension | PHP 5.5 | PHP 5.6 | PHP 7.0 | PHP 7.1 | PHP 7.2 | PHP 7.3 | PHP 7.4 | PHP 8.0 | PHP 8.1 | PHP 8.2 |
|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|:---:|
| amqp | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| apcu | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| apcu_bc |  |  | &check; | &check; | &check; | &check; | &check; |  |  |  |
| ast |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| bcmath | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| blackfire | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| bz2 | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| calendar | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| cmark |  |  | &check; | &check; | &check; | &check; | &check; |  |  |  |
| csv |  |  |  |  |  | &check; | &check; | &check; | &check; | &check; |
| dba | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ddtrace[*](#special-requirements-for-ddtrace) |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| decimal |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ds |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| enchant | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ev | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| event | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| excimer |  |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| exif | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ffi |  |  |  |  |  |  | &check; | &check; | &check; | &check; |
| gd | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| gearman | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |
| geoip | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |
| geos[*](#special-requirements-for-geos) | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |
| geospatial | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| gettext | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| gmagick | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| gmp | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| gnupg | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| grpc | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| http | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| igbinary | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| imagick | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| imap | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| inotify | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| interbase | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |  |
| intl | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ion |  |  |  |  |  |  |  |  | &check; | &check; |
| ioncube_loader | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |
| jsmin | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |
| json_post | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ldap | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| luasandbox | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| lz4[*](#special-requirements-for-lz4) |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| lzf | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| mailparse | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| maxminddb |  |  |  |  | &check; | &check; | &check; | &check; | &check; | &check; |
| mcrypt | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| memcache | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| memcached | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| memprof[*](#special-requirements-for-memprof) | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| mongo | &check; | &check; |  |  |  |  |  |  |  |  |
| mongodb | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| mosquitto | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |
| msgpack | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| mssql | &check; | &check; |  |  |  |  |  |  |  |  |
| mysql | &check; | &check; |  |  |  |  |  |  |  |  |
| mysqli | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| oauth | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| oci8 | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| odbc | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| opcache | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| opencensus |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| openswoole |  |  |  |  | &check; | &check; | &check; | &check; | &check; |  |
| parallel[*](#special-requirements-for-parallel) |  |  |  | &check; | &check; | &check; | &check; |  |  |  |
| parle[*](#special-requirements-for-parle) |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pcntl | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pcov |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_dblib | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_firebird | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_mysql | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_oci |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_odbc | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_pgsql | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pdo_sqlsrv[*](#special-requirements-for-pdo_sqlsrv) |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pgsql | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| php_trie |  |  |  |  |  | &check; | &check; | &check; | &check; | &check; |
| propro | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |
| protobuf | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pspell | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| pthreads[*](#special-requirements-for-pthreads) | &check; | &check; | &check; |  |  |  |  |  |  |  |
| raphf | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| rdkafka | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| recode | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |  |
| redis | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| seaslog | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| shmop | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| smbclient | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| snappy | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| snmp | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| snuffleupagus |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| soap | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| sockets | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| sodium[*](#special-requirements-for-sodium) |  | &check; | &check; | &check; |  |  |  |  |  |  |
| solr | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |
| sourceguardian | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  |
| spx |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| sqlsrv[*](#special-requirements-for-sqlsrv) |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| ssh2 | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| stomp | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |  | &check; |
| swoole | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| sybase_ct | &check; | &check; |  |  |  |  |  |  |  |  |
| sysvmsg | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| sysvsem | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| sysvshm | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| tensor[*](#special-requirements-for-tensor) |  |  |  |  | &check; | &check; | &check; | &check; |  |  |
| tidy | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| timezonedb | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| uopz | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| uploadprogress | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| uuid | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| vips[*](#special-requirements-for-vips) |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| wddx | &check; | &check; | &check; | &check; | &check; | &check; |  |  |  |  |
| xdebug | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| xdiff | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| xhprof | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| xlswriter |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| xmldiff | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| xmlrpc | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| xsl | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| yac |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| yaml | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| yar | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| zephir_parser |  |  | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| zip | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |
| zookeeper | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |  |
| zstd | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; | &check; |

*Number of supported extensions: 127*
<!-- END OF EXTENSIONS TABLE -->

此扩展来自[https://github.com/mlocati/docker-php-extension-installer](https://github.com/mlocati/docker-php-extension-installer)
参考示例文件

### 3.4 使用composer
**进入容器内使用composer命令**
进入容器，再执行`composer`命令，以PHP7.0容器为例：
```bash
docker exec -it php70 /bin/sh
# 查看composer版本
composer -V
```

## 4.管理命令
### 4.1 服务器启动和构建命令
如需管理服务，请在命令后面加上服务器名称，例如：
```bash
$ docker-compose up                         # 创建并且启动所有容器
$ docker-compose up -d                      # 创建并且后台运行方式启动所有容器
$ docker-compose up nginx php70 mysql       # 创建并且启动nginx、php70、mysql的多个容器
$ docker-compose up -d nginx php70 mysql    # 创建并且已后台运行的方式启动nginx、php70、mysql容器

$ docker-compose start php                  # 启动服务
$ docker-compose stop php                   # 停止服务
$ docker-compose restart php                # 重启服务
$ docker-compose build php                  # 构建或者重新构建服务

$ docker-compose rm php                     # 删除并且停止php容器
$ docker-compose down                       # 停止并删除容器，网络，图像和挂载卷
```

### 4.2 添加快捷命令
在开发的时候，我们可能经常使用`docker exec -it`进入到容器中，把常用的做成命令别名是个省事的方法。

首先，在主机中查看可用的容器：
```bash
$ docker ps           # 查看所有运行中的容器
$ docker ps -a        # 所有容器
```

输出的`NAMES`那一列就是容器的名称，如果使用默认配置，那么名称就是`nginx`、`php`、`php56`、`mysql`等。

然后，打开`~/.bashrc`或者`~/.zshrc`文件，加上：
```bash
alias dnginx='docker exec -it nginx /bin/sh'
alias dmysql='docker exec -it mysql /bin/bash'
alias dphp70='docker exec -it php70 /bin/sh'
alias dredis='docker exec -it redis /bin/sh'
```

下次进入容器就非常快捷了，如进入php70容器：
```bash
$ dphp70
```

### 4.3 查看docker网络
用于容器访问宿主机的`hosts`地址，一般默认是172.17.0.1
```bash
ifconfig docker0
```

### 4.4 查看docker容器ip
进入容器后输入以下命令查看容器内网ip
```bash
cat /etc/hosts 1
```

## 5.使用Log

Log文件生成的位置依赖于conf下各log配置的值。

### 5.1 Nginx日志
`./logs/nginx`会映射Nginx容器的`/var/log/nginx`目录，所以在Nginx配置文件中，需要输出日志的位置，我们需要配置到`/var/log/nginx`目录，如：
```
error_log /var/log/nginx/test.imeepo.com.error.log
```

### 5.2 PHP-FPM日志
大部分情况下，PHP-FPM的日志都会输出到Nginx的日志中，所以不需要额外配置。

另外，建议直接在PHP中打开错误日志：
```php
error_reporting(E_ALL);
ini_set('error_reporting', 'on');
ini_set('display_errors', 'on');
```

如果确实需要，可按一下步骤开启（在容器中）。

1. 进入容器，创建日志文件并修改权限：
    ```bash
    $ docker exec -it php /bin/sh
    $ mkdir /var/log/php
    $ cd /var/log/php
    $ touch php-fpm.error.log
    $ chmod a+w php-fpm.error.log
    ```
2. 主机上打开并修改PHP-FPM的配置文件`conf/php-fpm.conf`，找到如下一行，删除注释，并改值为：
    ```
    php_admin_value[error_log] = /var/log/php/php-fpm.error.log
    ```
3. 重启PHP-FPM容器。

### 5.3 MySQL日志
因为MySQL容器中的MySQL使用的是`mysql`用户启动，它无法自行在`/var/log`下的增加日志文件。所以，需要赋予映射目录777权限。
```bash
slow-query-log-file     = /var/log/mysql/mysql.slow.log
log-error               = /var/log/mysql/mysql.error.log
```

以上是mysql.conf中的日志文件的配置。

## 6.在正式环境中安全使用
要在正式环境中使用，请：
1. 在php.ini中关闭XDebug调试
2. 增强MySQL数据库访问的安全策略
3. 增强redis访问的安全策略


## 7 常见问题
### 7.1 Docker容器时间
容器时间在.env文件中配置`TZ`变量，所有支持的时区请看[时区列表·维基百科](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)或者[PHP所支持的时区列表·PHP官网](https://www.php.net/manual/zh/timezones.php)。

### 7.2 如何连接MySQL和Redis服务器
这要分两种情况，

第一种情况，在**PHP代码中**。
```php
// 连接MySQL
$dbh = new PDO('mysql:host=mysql57;dbname=mysql', 'root', '123456');

// 连接Redis
$redis = new Redis();
$redis->connect('redis', 6379);
$redis->auth('123456');

```
因为容器与容器是`expose`端口联通的，而且在同一个`networks`下，所以连接的`host`参数直接用容器名称，`port`参数就是容器内部的端口。

第二种情况，**在主机中**通过**命令行**或者**Navicat**等工具连接。主机要连接mysql和redis的话，要求容器必须经过`ports`把端口映射到主机了。以 mysql 为例，`docker-compose.yml`文件中有这样的`ports`配置：`3306:3306`，就是主机的3306和容器的3306端口形成了映射，所以我们可以这样连接：
```bash
$ mysql -h127.0.0.1 -uroot -p123456 -P3306
$ redis-cli -h127.0.0.1
```
这里`host`参数不能用localhost是因为它默认是通过sock文件与mysql通信，而容器与主机文件系统已经隔离，所以需要通过TCP方式连接，所以需要指定IP。

### 7.3 容器内的php如何连接宿主机MySQL
1.宿主机执行`ifconfig docker0`得到`inet`就是要连接的`ip`地址
```sh
$ ifconfig docker0
docker0: flags=4099<UP,BROADCAST,MULTICAST>  mtu 1500
        inet 172.17.0.1  netmask 255.255.0.0  broadcast 172.17.255.255
        ...
```
2.运行宿主机Mysql命令行
```bash
# 其中各字符的含义：
# *.* 对任意数据库任意表有效
# "root" "123456" 是数据库用户名和密码
# '%' 允许访问数据库的IP地址，%意思是任意IP，也可以指定IP
# flush privileges 刷新权限信息
 mysql>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%' IDENTIFIED BY '123456' WITH GRANT OPTION;
 mysql>flush privileges;
```

3.接着直接php容器使用`172.0.17.1:3306`连接即可

### 7.4 SQLSTATE[HY000] [1130] Host '172.19.0.2' is not allowed to connect to this MySQL server
1. 目前使用mysql-server `8.0.28`以上的版本,php版本需要`7.4.7`以上才能连接
