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

kubectl delete -f prometheus.yaml
kubectl delete -f grafana.yaml
kubectl delete -f node-export.yaml
```

# 默认账户密码
admin admin -> 123456
