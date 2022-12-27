# charts-demo
charts demo

# 使用说明
```bash
# 克隆
git clone https://github.com/wugenshui/charts-demo.git
cd charts-demo

# 推送
git pull && helm package nginx-gateway && helm push nginx-gateway-0.2.0.tgz oci://registry-1.docker.io/wugenshui

# 运行
helm upgrade nginx-gateway oci://registry-1.docker.io/wugenshui/nginx-gateway --install
```
