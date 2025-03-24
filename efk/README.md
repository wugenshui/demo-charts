# deploy

## 安装前执行
```bash
docker pull elastic/filebeat:7.17.4
docker pull elasticsearch:8.12.2
docker pull kibana:8.12.2

# 目录初始化
mkdir -p /data/filebeat/log
mkdir -p /data/filebeat/data
mkdir -p /data/es/data
mkdir -p /data/es/plugins
mkdir -p /data/filebeat/data
chmod 777 /data/es/data
chmod 777 /data/es/plugins
chmod 777 /data/filebeat/data
mkdir -p /opt/efk

# ES需求
# 修改配置文件增加配置
cat >> /etc/security/limits.conf <<EOF
*               soft    nofile          65536
*               hard    nofile          65536
*               soft    nproc           4096
*               hard    nproc           4096
EOF

cat >> /etc/sysctl.conf <<EOF
vm.max_map_count=262144
EOF
# 使配置生效
sysctl -p
```

## 安装后执行
```bash
bin/elasticsearch-plugin install https://get.infini.cloud/elasticsearch/analysis-ik/8.12.2
curl es/_cat/plugins
```
