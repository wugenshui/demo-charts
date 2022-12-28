# charts-demo
charts demo

# 使用说明
```bash
# 克隆
git clone git@github.com:wugenshui/charts-demo.git
cd charts-demo

# 推送并运行
appname=nginx-gateway
version=0.2.0
git pull && helm package $appname && helm push $appname-$version.tgz oci://registry-1.docker.io/wugenshui
helm upgrade $appname oci://registry-1.docker.io/wugenshui/$appname --install

appname=demo-service
version=0.0.1
git pull && helm package $appname && helm push $appname-$version.tgz oci://registry-1.docker.io/wugenshui
helm upgrade $appname oci://registry-1.docker.io/wugenshui/$appname --install
```
