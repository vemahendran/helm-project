#!/usr/bin/env bash


cd terraform
terraform init
terraform validate
terraform plan
echo "yes" | terraform apply
cd ..

echo "Create cluster through Terraform commands"
gcloud container clusters get-credentials abc-cluster --zone us-west1-a --project thrashingcorecode-249409

printf "\n---------\n"
echo "Give permission to tiller pod in Cluster"
kubectl apply -f ./helpers/helm-auth.yml

printf "\n---------\n"
echo "Install tiller on kube-system namespace on the current cluster context"
helm init --service-account tiller --upgrade --wait

printf "\n---------\n"
echo "The installed tiller pod name on kube-system"
kubectl get pods -n kube-system --no-headers=true | awk '/tiller*/{print $1}'

helm version

kubectl create ns pirates || true

echo "Run helm lint"
helm lint helm-demo

ls helm-demo

printf "\n---------\n"
echo "Clean up the resources from any previous deployments:"
kubectl delete all --selector app=helm-demo

printf "\n---------\n"
echo "Deploy manifest on K8s"

helm install --name myapp helm-demo

printf "\n---------\n"
echo "Test the container changes"
kubectl get svc,po,deployments -n pirates

printf "\n---------\n"
echo "The output:"
curl http://$(kubectl get svc/helm-demo-service -n pirates -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):9090/demo-service/v1.0/names
