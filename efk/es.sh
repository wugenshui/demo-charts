cat > /opt/efk/es.yaml << EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: es
  namespace: kube-system
spec:
  selector:
    matchLabels:
      app: es
  replicas: 1
  template:
    metadata:
      labels:
        app: es
    spec:
      nodeName: k8s-master # 指定部署节点
      containers:
      - name: es
        image: docker.elastic.co/elasticsearch/elasticsearch:8.12.2
        # 只有镜像不存在时，才会进行镜像拉取
        imagePullPolicy: IfNotPresent
        env:
        - name: xpack.security.enabled
          value: "false"
        - name: xpack.security.http.ssl.enabled
          value: "false"
        - name: cluster.name
          value: k8s-es
        - name: node.name
          value: es
        - name: cluster.initial_master_nodes
          value: es
        ports:
        - containerPort: 9200
        volumeMounts:
        - name: data
          mountPath: /usr/share/elasticsearch/data
        - name: plugins
          mountPath: /usr/share/elasticsearch/plugins
      volumes:
      - name: data
        hostPath:
          path: /data/es/data
      - name: plugins
        hostPath:
          path: /data/es/plugins
---
apiVersion: v1
kind: Service
metadata:
  name: es
  namespace: kube-system
spec:
  selector:
    app: es
  type: NodePort
  ports:
  - name: es
    port: 80
    targetPort: 9200
    nodePort: 30006
EOF

kubectl apply -f /opt/efk/es.yaml
