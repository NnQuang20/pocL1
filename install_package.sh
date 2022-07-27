minikube start --driver=none --kubernetes-version v1.23.8
minikube addons enable ingress

#add lable for default namespace
kubectl label namespace default istio-injection=enabled

# install istio
helm repo add istio https://istio-release.storage.googleapis.com/charts
helm repo update

kubectl create namespace istio-system
helm install istio-base istio/base -n istio-system
helm install istiod istio/istiod -n istio-system --wait
#helm show values istio/gateway |nano -
helm install istio-ingress istio/gateway -f nnq.yaml -n istio-system --wait
#install prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm install prometheus prometheus-community/prometheus
kubectl expose service prometheus-server --type=NodePort --target-port=9090 --name=prometheus-server-np
minikube service prometheus-server-np

#install grafana
helm repo add bitnami https://charts.bitnami.com/bitnami
helm install grafana bitnami/grafana
kubectl expose service grafana --type=NodePort --target-port=3000 --name=grafana-np
kubectl get secret --namespace default grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
minikube service grafana-np

