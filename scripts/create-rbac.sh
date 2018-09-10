#!/bin/bash

{
echo && echo "$0: " && echo

cat > rbac-cr.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRole
metadata:
  annotations:
    rbac.authorization.kubernetes.io/autoupdate: "true"
  labels:
    kubernetes.io/bootstrapping: rbac-defaults
  name: system:kube-apiserver-to-kubelet
rules:
  - apiGroups:
      - ""
    resources:
      - nodes/proxy
      - nodes/stats
      - nodes/log
      - nodes/spec
      - nodes/metrics
    verbs:
      - "*"
EOF

kubectl apply --kubeconfig admin.kubeconfig -f rbac-cr.yaml

cat > rbac-crb.yaml <<EOF
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: system:kube-apiserver
  namespace: ""
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: system:kube-apiserver-to-kubelet
subjects:
  - apiGroup: rbac.authorization.k8s.io
    kind: User
    name: kubernetes
EOF

kubectl apply --kubeconfig admin.kubeconfig -f rbac-crb.yaml

exit 0 # Exit with exit status because kube is complaining about ClusterRole and ClusterRoleBinding not playing well with API version v1beta1...¯\_(ツ)_/¯
} >> cloudinit.log
