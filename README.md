# Helm Notes

#### Install Helm client
```
$brew install kubernetes-helm
```

#### Check Helm version
```
$helm version
```
- It shows both client and server version
- The server is called tiller

#### Set the cluster context on terminal
```
$gcloud container clusters get-credentials <cluster_name> --zone <zone> --project <project_name>
$kubectl config get-contexts
$kubectl cluster-info
```

#### Helm Init
```
$helm init
```
- installs tiller on kube-system namespace in the current cluster context
	`$kubectl get pods --all-namespaces`
- You can see tiller pod in the list

#### Give permission to tiller pod in Cluster

- Step 1 - Create ServiceAccount `tiller` in `kube-system` namespace
#### helm-tiller-serviceaccount.yml
```
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
```

- Step 2 - Create ClusterRoleBinding tiller
#### helm-tiller-rolebinding.yml
```
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRoleBinding
metadata:
  name: tiller
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
```

- Step 3 - Run both files
```
$kubectl apply -f ./helpers/helm-*.yaml
```

#### Create a manifest
```
$helm create <app-name>
```
e.g. helm create helm-demo

<update the templates as you wish>

#### Validate helm templates
```
$helm lint
```

#### Deploy manifest on K8s
```
$helm install --name myapp helm-demo
```

#### Test the container changes
```
$kubectl get svc,po,deployments
$curl http://$(kubectl get svc/helm-demo-service -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):80/hello
```

#### Update the manifest
```
$helm upgrade myapp helm-demo
```

#### Delete the manifest on K8s
```
$ helm ls
$ helm delete helm-demo
```
