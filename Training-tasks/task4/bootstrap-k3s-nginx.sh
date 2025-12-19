#!/bin/bash
# =====================================================
# COMPLETE BOOTSTRAP SCRIPT
# - Install K3s (Amazon Linux compatible)
# - Deploy NGINX
# - Expose via NodePort 30080
# - (Optional) Apply Ingress
# =====================================================

set -e

echo "==============================="
echo "STEP 1: Install K3s"
echo "==============================="

curl -sfL https://get.k3s.io | INSTALL_K3S_SKIP_SELINUX_RPM=true sh -

echo "Waiting for K3s to start..."
sleep 30

echo "==============================="
echo "STEP 2: Verify K3s"
echo "==============================="

systemctl status k3s --no-pager
k3s kubectl get nodes

echo "==============================="
echo "STEP 3: Deploy NGINX"
echo "==============================="

cat <<EOF | k3s kubectl apply -f -
apiVersion: apps/v1
kind: Deployment
metadata:
  name: nginx
spec:
  replicas: 2
  selector:
    matchLabels:
      app: nginx
  template:
    metadata:
      labels:
        app: nginx
    spec:
      containers:
      - name: nginx
        image: nginx
        ports:
        - containerPort: 80
EOF

k3s kubectl get pods

echo "==============================="
echo "STEP 4: Create NodePort Service"
echo "==============================="

cat <<EOF | k3s kubectl apply -f -
apiVersion: v1
kind: Service
metadata:
  name: nginx-nodeport
spec:
  type: NodePort
  selector:
    app: nginx
  ports:
  - port: 80
    targetPort: 80
    nodePort: 30080
EOF

k3s kubectl get svc nginx-nodeport

echo "==============================="
echo "STEP 5: Local Validation"
echo "==============================="

echo "Testing NodePort locally..."
curl -s http://localhost:30080 | head -n 5 || true

echo "==============================="
echo "STEP 6 (OPTIONAL): Apply Ingress"
echo "==============================="

cat <<EOF | k3s kubectl apply -f -
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: nginx-ingress
spec:
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: nginx-nodeport
            port:
              number: 80
EOF

k3s kubectl get ingress

echo "==============================="
echo "✅ ALL DONE"
echo "==============================="

echo "NodePort Access (internal test): http://<EC2-IP>:30080"
echo "ALB Access: http://<ALB-DNS>"
