init-cluster:
	gcloud beta container --project "k8s-clusters" clusters create "istio-lab" --zone "europe-west4-c" --username "admin" --cluster-version "1.10.7-gke.6" --machine-type "n1-standard-1" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --scopes "https://www.googleapis.com/auth/devstorage.read_only","https://www.googleapis.com/auth/logging.write","https://www.googleapis.com/auth/monitoring","https://www.googleapis.com/auth/servicecontrol","https://www.googleapis.com/auth/service.management.readonly","https://www.googleapis.com/auth/trace.append" --num-nodes "3" --enable-cloud-logging --enable-cloud-monitoring --network "projects/k8s-clusters/global/networks/default" --subnetwork "projects/k8s-clusters/regions/europe-west4/subnetworks/default" --enable-autoscaling --min-nodes "2" --max-nodes "5" --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair

init-istio:
	kubectl create clusterrolebinding cluster-admin-binding  --clusterrole=cluster-admin  --user="m.ramadanb@gmail.com"
  
	kubectl apply -f /home/mrb/istio/istio-1.0.2/install/kubernetes/istio-demo-auth.yaml

others:
	kubectl apply -f /home/mrb/istio/istio-1.0.2/install/kubernetes/istio-demo.yaml

	kubectl config set-context $(kubectl config current-context) --namespace=istio-system

	kubectl get pods

setup-istio-demo-bookinfo:
	kubectl apply -f <(istioctl kube-inject -f /home/mrb/istio/istio-1.0.2/samples/bookinfo/platform/kube/bookinfo.yaml)

	kubectl get services

	kubectl apply -f /home/mrb/istio/istio-1.0.2/samples/bookinfo/networking/bookinfo-gateway.yaml

	kubectl get svc istio-ingressgateway -n istio-system
