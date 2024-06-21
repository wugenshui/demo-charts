cat > /opt/efk/filebeat.yaml << 'EOF'
apiVersion: v1
kind: ConfigMap
metadata:
  name: filebeat-config
  namespace: kube-system
  labels:
    k8s-app: filebeat
data:
  filebeat.yml: |-
    filebeat.inputs:
    - type: log
      enabled: true
      paths:
      - /var/lib/docker/containers/*/*.log
      exclude_lines: ['Non-zero metrics in the last']
      # 对于同名的key，覆盖原有key值
      json.overwrite_keys: true
      # 让字段位于根节点
      json.keys_under_root: false
      fields_under_root: false
      # 如果启用此设置，则在出现JSON解组错误或配置中定义了message_key但无法使用的情况下，Filebeat将添加“error.message”和“error.type：json”键。
      json.add_error_key: true
      # 一个可选的配置设置，用于指定应用行筛选和多行设置的JSON密钥。 如果指定，键必须位于JSON对象的顶层，且与键关联的值必须是字符串，否则不会发生过滤或多行聚合。
      json.message_key: log
      tail_files: true
      # 将error日志合并到一行
      multiline.pattern: '^([0-9]{4}|[0-9]{2})-[0-9]{2}'
      multiline.negate: true
      multiline.match: after
      multiline.timeout: 10s
      # registry_file: /opt/filebeat/registry
    filebeat.config.modules:
      path: ${path.config}/modules.d/*.yml
      reload.enabled: false
    setup.template.enabled: true
    setup.template.settings:
      index.number_of_shards: 1
    setup.template.name: "filebeat"
    setup.template.pattern: "filebeat-*"
    # 关闭ilm
    setup.ilm.enabled: false
    #-------------------------- Elasticsearch output -------------------------------
    output.elasticsearch:
      # 需要修改ES的配置
      hosts: ["http://192.168.0.80:30006"]
      index: "filebeat-%{+yyyy.MM.dd}"
    processors:
      - add_docker_metadata: ~
      - add_kubernetes_metadata: ~
      #- drop_fields:
      #    fields: ["input_type", "offset", "stream", "beat"]
---
apiVersion: apps/v1
kind: DaemonSet
metadata:
  name: filebeat
  namespace: kube-system
  labels:
    k8s-app: filebeat
spec:
  selector:
    matchLabels:
      k8s-app: filebeat
  template:
    metadata:
      labels:
        k8s-app: filebeat
    spec:
      tolerations:
      - key: node-role.kubernetes.io/master
        effect: NoSchedule
      terminationGracePeriodSeconds: 30
      hostNetwork: true
      containers:
      - name: filebeat
        image: elastic/filebeat:7.17.4
        securityContext:
          runAsUser: 0
        resources:
          limits:
            memory: 2000Mi
        volumeMounts:
        - name: config
          mountPath: /usr/share/filebeat/filebeat.yml
          readOnly: true
          subPath: filebeat.yml
        - name: data
          mountPath: /usr/share/filebeat/data
        - name: docker-log
          mountPath: /var/lib/docker/containers/
        - name: docker-sock
          mountPath: /var/run/docker.sock
      volumes:
      - name: config
        configMap:
          defaultMode: 0640
          name: filebeat-config
      - name: data
        hostPath:
          path: /data/filebeat/data
      - name: docker-log
        hostPath:
          path: /var/lib/docker/containers/
      - name: docker-sock
        hostPath:
          path: /var/run/docker.sock
EOF

kubectl apply -f /opt/efk/filebeat.yaml
