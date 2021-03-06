resource "kubectl_manifest" "deploy" {
    yaml_body = <<YAML
---
apiVersion: v1
kind: PersistentVolumeClaim
metadata:
  name: azure-managed-disk
spec:
  accessModes:
  - ReadWriteOnce
  storageClassName: default
  resources:
    requests:
      storage: 1Gi
---
apiVersion: apps/v1
kind: StatefulSet
metadata:
  name: mantisdb
spec:
  serviceName: mantisdb
  replicas: 1
  selector:
    matchLabels:
      app: mantisdb
  template:
    metadata:
      labels:
        app: mantisdb
    spec:
      #terminationGracePeriodSeconds: 10
      containers:
        - name: mantisdb
          image: mysql:latest
          env:
          - name: MYSQL_ROOT_PASSWORD
            valueFrom:
              secretKeyRef:
               name: msecrets
               key: password  
          ports:
            - containerPort: 3306
          volumeMounts:
            - name: mantisdb-storage
              mountPath: /var/lib/mysql
      volumes:
        - name: mantisdb-storage
          persistentVolumeClaim:
            claimName: azure-managed-disk
---
apiVersion: v1
kind: Service
metadata:
  name: mantisdb
spec:
  ports:
  - port: 3306
  selector:
    app: mantisdb
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mantisbt
spec:
  replicas: 2
  selector:
    matchLabels:
      app: mantisbt
  strategy:
    rollingUpdate:
      maxSurge: 1
      maxUnavailable: 1
    type: RollingUpdate
  template:
    metadata:
      labels:
        app: mantisbt
    spec:
      nodeSelector:
        "beta.kubernetes.io/os": linux
      containers:
      - name: mantisbt
        image: mantiscr.azurecr.io/mantis:latest
        imagePullPolicy: "Always"
        resources:
          requests:
            cpu: 100m
            memory: 128Mi
          limits:
            cpu: 250m
            memory: 256Mi
        ports:
        - containerPort: 80
        env:
        - name: mantis-db
          value: "mantisbt"
---
apiVersion: v1
kind: Service
metadata:
  name: mantisbt
spec:
  type: ClusterIP
  #type: LoadBalancer
  ports:
  - port: 80
  selector:
    app: mantisbt

YAML
} 
