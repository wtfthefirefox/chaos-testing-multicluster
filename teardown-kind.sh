#Remove all kind clusters when done with the demo
minikube delete --all

#Restore K8s secret
git restore K8s-yaml-files/secret-kubeconfig.yaml