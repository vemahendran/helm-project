helm ls

echo "Delete helm manifest resources"
helm delete myapp

echo "Delete cluster"
cd terraform
terraform plan
echo "yes" | terraform destroy
cd ..
