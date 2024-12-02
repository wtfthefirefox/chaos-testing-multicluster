helm repo add grafana https://grafana.github.io/helm-charts
helm repo update
kubectl create namespace monitoring
helm install my-grafana grafana/grafana --namespace monitoring
helm upgrade --install my-grafana grafana/grafana -f values.yaml
