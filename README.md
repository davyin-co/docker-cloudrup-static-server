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
      - APACHE_LOGS_KEEP_DAYS=180
    volumes:
      - ./aegir:/var/aegir
      - /var/log/apache2:/var/log/apache2
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
|APACHE_LOGS_KEEP_DAYS|by default the logs files store in /var/log/apache2, and spilit by days, default value: 180 days|


#### 日志处理
默认安装了logrotate.

如果期望使用自定义的方式进行日志处理，建议如下：

运行容器的时候，./conf/hosting_log:/etc/logrotate.d/hosting_log

./conf/hosting_log内容如下:
* 按照大小(超过10M进行分割，保留4个文件）：
```
/var/log/aegir/*.log {
         size 10M
         create 644 aegir aegir
         rotate 4
	 dateext
         compress
         copytruncate
}
```
* 按照日期(每天一个，保留30天)：
```
/var/log/aegir/*.log {
        daily
        missingok
        rotate 30
        compress
        delaycompress
        notifempty
        create 644 aegir aegir
        sharedscripts
        postrotate
                /etc/init.d/apache2 reload > /dev/null
        endscript
}
```
