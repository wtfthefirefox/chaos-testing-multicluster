#!/bin/bash

set -e
set -o pipefail
set -o errexit

GREEN='\033[1;32m'
NoColor='\033[0m'
function output_information () { 
    echo -e "${GREEN}$1${NoColor}"
}

minikube start

#!/bin/bash

helm repo add chaos-mesh https://charts.chaos-mesh.org
helm search repo chaos-mesh
helm install chaos-mesh chaos-mesh/chaos-mesh -n chaos-mesh --set dashboard.create=true --create-namespace -f setup/common/chaos-mesh-setup/mesh.yaml

#Verify installation
kubectl wait pods -n chaos-mesh -l app.kubernetes.io/instance=chaos-mesh --for condition=Ready --timeout=600s 
kubectl get po -n chaos-mesh
output_information "Chaos mesh installation on base cluster completed"

minikube addons enable ingress
sleep 60 
kubectl apply -f setup/common/chaos-mesh-setup/cluster-base-ingress.yaml

kubectl apply -f K8s-yaml-files/secret-kubeconfig.yaml
kubectl apply -f K8s-yaml-files/remote-cluster.yaml

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

output_information "All chaos preparations done. Setting up monitoring staff"

# install prometheus
helm install -f setup/common/monitoring/prometheus.yaml prometheus prometheus-community/prometheus -n monitoring --create-namespace

# install prometheus ingress
kubectl apply -f setup/common/monitoring/prometheus-ingress.yaml

# install grafana
helm install grafana grafana/grafana -n grafana --create-namespace -f setup/common/monitoring/grafana.yaml

MINIKUBE_IP=$(minikube ip)
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination $(echo $MINIKUBE_IP):80
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

output_information "Enabling chaos on external"
sleep 150
output_information "Waiting some time before chaos mesh is start his work on external"
# testing external cluster can make chaos 
kubectl apply -f K8s-yaml-files/chaos-experiments-remote/pod-kill-experiment.yaml
