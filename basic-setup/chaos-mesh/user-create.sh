kubectl apply -f user-creation.yaml
echo "Creating user account-cluster-manager-admin-2 with passsword:"
kubectl create token account-cluster-manager-admin-2 | echo account_password.txt
