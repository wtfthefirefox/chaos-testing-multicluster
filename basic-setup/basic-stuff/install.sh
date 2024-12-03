helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

kubectl create namespace monitoring
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring -f values.yaml

# TODO: add auto run grafana
