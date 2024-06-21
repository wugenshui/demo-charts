cat > /opt/efk/kibana.yaml << EOF
apiVersion: v1
kind: ConfigMap
metadata:
  name: kibana-config
  namespace: kube-system
data:
  kibana.yml: |-
    server.name: kibana
    server.host: 0.0.0.0
    server.publicBaseUrl: http://192.168.0.80:30006
    elasticsearch.hosts: ["http://es"]
    i18n.locale: "zh-CN"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: kibana
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: kibana
  replicas: 1
  template:
    metadata:
      labels:
        app: kibana
    spec:
      nodeName: k8s-master # 指定部署节点
      containers:
      - name: kibana
        image: docker.elastic.co/kibana/kibana:8.12.2
        # 只有镜像不存在时，才会进行镜像拉取
        imagePullPolicy: IfNotPresent
        ports:
        - containerPort: 5601
        volumeMounts:
        - name: config
          mountPath: /usr/share/kibana/config/kibana.yml
          readOnly: true
          subPath: kibana.yml
      volumes:
      - name: config
        configMap:
          defaultMode: 0640
          name: kibana-config
---
apiVersion: v1
kind: Service
metadata:
  name: kibana
  namespace: kube-system
spec:
  selector:
    app: kibana
  type: NodePort
  ports:
  - name: kibana
    port: 80
    targetPort: 5601
    nodePort: 30005
EOF

kubectl apply -f /opt/efk/kibana.yaml
