minikube start -p external --embed-certs

external_cluster_ip=$(minikube ip -p external)
external_cluster_address="https:\/\/$external_cluster_ip:8443"
proxy_address_port=8112
real_ip=$(curl https://ipinfo.io/ip)
proxy_address="http:\/\/$real_ip:$proxy_address_port"

# idk how to do this other way..
# make avail our cluster from the net
nohup minikube -p external kubectl -- proxy --address='0.0.0.0' --accept-hosts='.*' --port $proxy_address_port &

kubectl config view --raw --minify | sed "s/$external_cluster_address/$proxy_address/g" > debug/kubeconfig_output.txt
kubectl config view --raw --minify | sed "s/$external_cluster_address/$proxy_address/g" | base64 -w 0 >> K8s-yaml-files/secret-kubeconfig.yaml

#Create deploy for external cluster, create namespace for chaos-mesh
kubectl apply -f K8s-yaml-files/nginx-deployment.yaml
kubectl create namespace chaos-mesh
sleep 15
kubectl wait pods -n default -l app=nginx --for condition=Ready --timeout=600s

MINIKUBE_IP=$(minikube ip)
sudo iptables -P FORWARD ACCEPT
sudo iptables -t nat -A PREROUTING -i eth0 -p tcp --dport 80 -j DNAT --to-destination $(echo $MINIKUBE_IP):80
sudo iptables -t nat -A POSTROUTING -o eth0 -j MASQUERADE

minikube addons enable ingress
sleep 60
kubectl apply -f setup/common/chaos-mesh-setup/cluster-external-ingress.yaml
