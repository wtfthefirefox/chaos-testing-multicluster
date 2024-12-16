#!/bin/bash

set -e
set -o pipefail
set -o errexit

GREEN='\033[1;32m'
NoColor='\033[0m'
function output_information () { 
    echo -e "${GREEN}$1${NoColor}"
}

#Two k8s clusters - base and external. 
./create-clusters.sh
output_information "Cluster creation completed"

#Verfiy access to both clusters
kubectl config get-contexts

#Retrieve kubeconfig from external cluster, store it in a secret for Chaos mesh
kubectl config use external

external_cluster_ip=$(minikube ip -p external)
external_cluster_address="https:\/\/$external_cluster_ip:8443"
proxy_address_port=8112
real_ip=$(curl https://ipinfo.io/ip)
proxy_address="http:\/\/$real_ip:$proxy_address_port"

nohup minikube -p external kubectl -- proxy --address='0.0.0.0' --accept-hosts='.*' --port $proxy_address_port &

kubectl config view --raw --minify | sed "s/$external_cluster_address/$proxy_address/g" > debug/kubeconfig_output.txt

kubectl config view --raw --minify | sed "s/$external_cluster_address/$proxy_address/g" | base64 -w 0 >> K8s-yaml-files/secret-kubeconfig.yaml

#Create deploy for external cluster, create namespace for chaos-mesh
kubectl apply -f K8s-yaml-files/nginx-deployment.yaml
kubectl create namespace chaos-mesh
sleep 15
kubectl wait pods -n default -l app=nginx --for condition=Ready --timeout=600s
output_information "External cluster workload deployment completed"

#Go to base cluster, install chaos mesh
kubectl config use base
helm repo add chaos-mesh https://charts.chaos-mesh.org
helm search repo chaos-mesh
helm install chaos-mesh chaos-mesh/chaos-mesh -n chaos-mesh --set dashboard.create=true --create-namespace -f basic-setup/chaos-mesh-setup/mesh.yaml

#Verify installation
kubectl wait pods -n chaos-mesh -l app.kubernetes.io/instance=chaos-mesh --for condition=Ready --timeout=600s 
kubectl get po -n chaos-mesh
output_information "Chaos mesh installation on base cluster completed"

#Add cluster to chaos mesh
kubectl apply -f K8s-yaml-files/secret-kubeconfig.yaml
kubectl apply -f K8s-yaml-files/remote-cluster.yaml

#Wait for Chaos Mesh installation on remote cluster
kubectl config use external
output_information "Waiting for Helm to install chaos mesh on External cluster"
sleep 15

kubectl wait pods -n chaos-mesh -l app.kubernetes.io/instance=chaos-mesh --for condition=Ready --timeout=600s
output_information "Chaos mesh installation on External cluster completed"

external_chaos_dashboards_url=$(kubectl get service/chaos-dashboard -n chaos-mesh -o jsonpath='{.spec.clusterIP}')
external_chaos_manager_url=$(kubectl get service/chaos-mesh-controller-manager -n chaos-mesh -o jsonpath='{.spec.clusterIP}')

# add chaos mesh base cluster metrics
kubectl apply -f basic-setup/chaos-mesh-setup/cluster-external-ingress.yaml

#Run chaos experiment
kubectl config use base
kubectl apply -f K8s-yaml-files/chaos-experiments-remote/pod-kill-experiment.yaml

minikube addons enable ingress -p base
minikube addons enable ingress -p external

# add chaos mesh base cluster metrics
kubectl apply -f basic-setup/chaos-mesh-setup/cluster-base-ingress.yaml

# TODO: thefirefox15 move dasboards stuff to basic-setup/dashboards script
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts

# install prometheus
CHAOS_DASHBOARD_1_METRICS_URL=`kubectl get service/chaos-dashboard -n chaos-mesh -o jsonpath='{.spec.clusterIP}'` \
CHAOS_MANAGER_1_METRICS_URL=`kubectl get service/chaos-mesh-controller-manager -n chaos-mesh -o jsonpath='{.spec.clusterIP}'` \
CHAOS_DASHBOARD_2_METRICS_URL=`echo -n $external_chaos_dashboards_url`
CHAOS_MANAGER_2_METRICS_URL=`echo -n $external_chaos_manager_url`
eval 'helm install -f basic-setup/dashboards/prometheus.yaml prometheus prometheus-community/prometheus -n monitoring --create-namespace \
--set serverFiles."prometheus\.yml".scrape_configs[0].static_configs[0].targets[1]=$CHAOS_DASHBOARD_1_METRICS_URL:2334,serverFiles."prometheus\.yml".scrape_configs[0].static_configs[0].targets[2]=$CHAOS_MANAGER_1_METRICS_URL:10080 \
--set serverFiles."prometheus\.yml".scrape_configs[1].static_configs[0].targets[1]=$CHAOS_DASHBOARD_2_METRICS_URL:2334,serverFiles."prometheus\.yml".scrape_configs[1].static_configs[0].targets[2]=$CHAOS_MANAGER_2_METRICS_URL:10080'

output_information "Prometheus installation completed"

# install prometheus ingress
kubectl apply -f basic-setup/dashboards/prometheus-ingress.yaml

# install grafana
helm install grafana grafana/grafana -n grafana --create-namespace -f basic-setup/dashboards/grafana.yaml

output_information "Grafana installation completed"
