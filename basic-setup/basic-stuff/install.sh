# Install deps
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add chaos-mesh https://charts.chaos-mesh.org

# Install all stuff
helm install prometheus prometheus-community/kube-prometheus-stack --namespace monitoring -f values.yaml --create-namespace
helm install chaos-mesh chaos-mesh/chaos-mesh -n chaos-mesh --set dashboard.create=true --create-namespace
