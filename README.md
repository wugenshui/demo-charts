# charts-demo
charts demo

# 使用说明
```bash
# 克隆
git clone https://github.com/wugenshui/charts-demo.git
cd charts-demo

# 推送
git pull && helm package nginx-gateway && helm push nginx-gateway-0.2.0.tgz oci://registry-1.docker.io/wugenshui
git pull && helm package demo-service && helm push demo-service-0.0.1.tgz oci://registry-1.docker.io/wugenshui

# 运行
helm upgrade nginx-gateway oci://registry-1.docker.io/wugenshui/nginx-gateway --install
helm upgrade demo-service oci://registry-1.docker.io/wugenshui/demo-service --install
```
