helm uninstall quickstart -n kong
kubectl delete pvc --all -n kong
sleep 10
kubectl delete po --all -n kong
kubectl delete jobs --all -n kong
kubectl delete ns kong --grace-period=0 --force

kubectl create namespace kong

kubectl create secret tls kong-tls-cert --cert=./newcerts/kong-tls-bundle.crt --key=./newcerts/kong-tls.key -n kong


kubectl create secret generic kong-config-secret -n kong \
    --from-literal=portal_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"portal_session","cookie_same_site":"Lax","cookie_secure":false, "cookie_domain": ".us-east-2.elb.amazonaws.com"}' \
    --from-literal=admin_gui_session_conf='{"storage":"kong","secret":"super_secret_salt_string","cookie_name":"admin_session","cookie_same_site":"Lax","cookie_secure":false, "cookie_domain": ".us-east-2.elb.amazonaws.com"}'
    
kubectl create secret generic kong-admin-secret -n kong \
    --from-literal=kong_admin_password=kong

kubectl create secret generic quickstart-postgresql -n kong \
    --from-literal=pg_host="enterprise-postgresql.kong.svc.cluster.local" \
    --from-literal=password=kong12345

kubectl create secret generic kong-enterprise-license --from-file=license=license.json -n kong --dry-run=client -o yaml | kubectl apply -f -

helm repo add jetstack https://charts.jetstack.io ; helm repo update

helm upgrade --install cert-manager jetstack/cert-manager \
    --set installCRDs=true --namespace cert-manager --create-namespace

kubectl apply -f selfsigned-issuer.yaml -n kong

helm repo add kong https://charts.konghq.com ; helm repo update

helm upgrade --install quickstart kong/kong --namespace kong --values quickstart.yaml

sleep 5

kubectl get po --namespace kong -w
