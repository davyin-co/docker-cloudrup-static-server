# 介绍
站群系统使用的webserver的docker镜像，基于ubuntu 18.04,安装配置了apache/php/ssh等。

# docker-compose example
```
version: '3'
services:
  static-server:
    image: davyinsa/cloudrup-static-server
    container_name: static-server
    hostname: cloudrup-static-server.docker
    restart: always
    environment:
      - APACHE_MAX_THREAD=100
      - APACHE_MPM_PREFORK_START_SERVERS=30
      - APACHE_MPM_PREFORK_MIN_SPARE_SERVERS=10
      - APACHE_MPM_PREFORK_MAX_SPARE_SERVERS=30
      - APACHE_MPM_PREFORK_MAX_REQUEST_WORKERS=200
      - APACHE_MPM_PREFORK_MAX_CONNECTIONS_PER_CHILD=10000
      - APACHE_MPM_PREFORK_SERVER_LIMIT=300
    volumes:
      - ./aegir:/var/aegir
    ports:
      - "8080:80"
      - "8022:22"
```

#### apache config
|Name|Desciption|
|----|----------|
|APACHE_MPM_PREFORK_START_SERVERS|The config for mpm_prefork module StartServers, default value: 10|
|APACHE_MPM_PREFORK_MIN_SPARE_SERVERS|The config for mpm_prefork module MinSpareServers, default value: 10|
|APACHE_MPM_PREFORK_MAX_SPARE_SERVERS|The config for mpm_prefork module MaxSpareServers, default value: 30|
|APACHE_MPM_PREFORK_MAX_REQUEST_WORKERS|The config for mpm_prefork module MaxRequestWorkers, default value: 200|
|APACHE_MPM_PREFORK_MAX_CONNECTIONS_PER_CHILD|The config for mpm_prefork module MaxConnectionsPerChild, default value: 2000|
|APACHE_MPM_PREFORK_SERVER_LIMIT|The config for mpm_prefork module ServerLimit, default value: 200|
