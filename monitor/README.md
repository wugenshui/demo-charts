# 初始化数据目录
mkdir -p /data/prometheus
mkdir -p /data/grafana/
chmod 777 /data/prometheus
chmod 777 /data/grafana/

# 启动
```bash
# 绑定默认角色授权
kubectl create clusterrolebinding prometheus-crb -n monitor --clusterrole=cluster-admin --user=system:serviceaccount:monitor:default

kubectl apply -f prometheus.yaml
kubectl apply -f grafana.yaml
kubectl apply -f node-export.yaml

# 异常情况先删除，再重建，一般不需要执行
kubectl delete -f prometheus.yaml
kubectl delete -f grafana.yaml
kubectl delete -f node-export.yaml
```

# 默认账户密码
admin admin -> 123456

# prometheus 中 kubernetes-service-endpoints 服务自动抓取配置
```yaml
metadata:
  annotations:
    prometheus.io/scrape: 'true'
```


# 安装模板文件

## k8s
- docker.json
- k8s集群监控.json

## 普通服务器
- docker.json
