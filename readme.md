## Update EE license
> Update your license into license.json file in this directory

## Create OpenSSL certificates for the elb hostnames

> the sh file creates certs for `us-east-2` region, please change accordingly
_Note: If you are in the same region, you can reuse the certs in the `newcerts` folder. No need to regenerate with the sh file._

```bash
chmod +x ./certs.sh
./certs.sh
```

## Run the installation

> the sh file contains cookie domain configuration for `us-east-2` region, please change accordingly

```bash
chmod +x ./install.sh
./install.sh
```

The install.sh file has the following steps:

- Delete previous installation objects
- Create secrets
  - tls certificate
  - admin and portal configration
  - admin password
  - postgres password
  - enterprise license
- Install cert manager
- Issuers created for self signed using cert manager
- Install Kong Gateway

## Update the elb addresses for the endpoints in quickstart.yaml

```bash
kubectl get svc -n kong
```

Update the endpoints as below

- admin
  - admin ingress block
  - env variable for `admin_gui_api_url`
- manager
  - manager ingress block
  - env variable for `admin_gui_host` and `admin_gui_url`
- portal
  - portal ingress block
  - env variable for `portal_gui_host` and `portal_gui_url`
- portalapi
  - portalapi ingress block
  - env variable for `portal_api_url`

## Upgrade the kong URLs

> Once the endpoints are updated in the yaml, upgrade the helm installation

_Only running upgrade will not change the elb addresses again. But rerunning install.sh changes these everytime_

```bash
helm upgrade --install quickstart kong/kong --namespace kong --values quickstart.yaml
```

----

## To disable dev portal authentication
- Click on `Dev Portals` in the top header
- `Enable Dev Portal` (If not already enabled)
- Click on the URL of the dev portal to make sure the elb works properly
- In the manager, go to default workspace
  - In the left panel, select `Dev Portal`
  - In the subsection in the left panel, select `Settings`
  - Under `Authentication` tab, Authentication Plugin -> Select `Disable Authentication`
- If you refresh the dev portal now, the login and signup buttons will not be there.
