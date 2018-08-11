# INTRODUCTION
This chart bootstraps my custom Let's Encrypt Cert Renewer, <br></br>
a CronJob on [Kubernetes](http://kubernetes.io) using the [Helm](https://helm.sh).

## INSTRUCTIONS
### 1. Generate certs via Let's Encrypt
Example:
```bash
docker run \
--rm \
--interactive \
--tty \
--volume ${PWD}/certs/:/root/certs/ \
certbot/certbot \
certonly \
--cert-path=/root/certs/cert.pem \
--key-path=/root/certs/privkey.pem \
--fullchain-path=/root/certs/fullchain.pem \
--chain-path=/root/certs/chain.pem \
--config-dir=/root/certbot/config/ \
--work-dir=/root/certbot/work/ \
--logs-dir=/root/certbot/logs/ \
--keep-until-expiring \
--manual \
--manual-public-ip-logging-ok \
--agree-tos \
--email=example@gmail.com \
--email=example@outlook.com \
--domain=www.example.com \
--domain=example.com
```
* Initial certs must be done manually via manual acme challenge

### 2. Store certs in generic secret
```bash
kubectl create secret generic ${MY_SECRET_NAME} \
--from-file='cert.pem=cert.pem' \
--from-file='privkey.pem=privkey.pem' \
--from-file='fullchain.pem=fullchain.pem' \
--from-file='chain.pem=chain.pem'
```
* helm value: `--set 'certSecret=${MY_SECRET_NAME}'`

### 3. Store certs in tls secret
```bash
kubectl create secret tls my-tls \
--cert='fullchain.pem' \
--key='privkey.pem'
```
* helm value: `--set 'tlsSecret=${MY_SECRET_NAME}'`

### 4. Create generic secret for acme challenge
```bash
kubectl create secret tls ${MY_SECRET_NAME} \
--cert='fullchain.pem' \
--key='privkey.pem'
```
* helm value: `--set 'acmeSecret=${MY_SECRET_NAME}'`

This secret must be VolumeMounted in your web server's `public` folder,<br></br>
at the path `.well-known/acme-challenge/`, so that Let's Encrypt can renew/challenge.<br></br>
See, [CertBot Manual Mode](https://certbot.eff.org/docs/using.html#manual).
Or see, [How It Works](https://letsencrypt.org/how-it-works/)

### 5. (OPTIONAL) Custom [hooks](https://certbot.eff.org/docs/using.html#pre-and-post-validation-hooks)
The default hooks only work to verify web server public endpoint running inside kubernetes.<br></br>
Default hooks work by propogating `acme` challenges through `volumeMount` of the `acmeSecret`.<br></br>
If you need to verify endpoints outside of Kubernetes, you can build custom hook scripts to override the defaults.
```bash
kubectl create configmap ${MY_CONFIGMAP_NAME} \
--from-file='auth.sh=./custom_auth.sh' \
--from-file='cleanup.sh=./custom_cleanup.sh'
```
* helm value: `--set 'hookConfigmap=${MY_CONFIGMAP_NAME}'`

## INSTALLING
##### Tillerless (client mode)
```bash
helm template \
--name='some-domain' \
--namespace='default' \
--kube-version='1.9.6' \
--set='domains=example.com,www.example.com' \
--set='emails=example@gmail.com,example@outlook.com' \
--set='certSecret=example-certs' \
--set='tlsSecret=example-tls' \
${PWD}/ \
| kubectl apply -f -
```
##### With Tiller
```bash
helm install \
--name 'some-domain' \
--set='domains=example.com,www.example.com' \
--set='emails=example@gmail.com,example@outlook.com' \
--set='certSecret=example-certs' \
--set='tlsSecret=example-tls' \
${PWD}/
```
## UNINSTALL
##### Tillerless (client mode)
```bash
helm template \
--name='some-domain' \
--namespace='default' \
--kube-version='1.9.6' \
--set='domains=example.com,www.example.com' \
--set='emails=example@gmail.com,example@outlook.com' \
--set='certSecret=example-certs' \
--set='tlsSecret=example-tls' \
${PWD}/ \
| kubectl delete -f -
```
##### With Tiller
```bash
helm delete \
--purge \
--name 'some-domain'
```

## CONFIGURATIONS
The following table lists the configurable parameters of this chart and their default values.

| Parameter | Description | Default | Required |
| --------- | ----------- | ------- | -------- |
| `domains` | list of cert's domains | `nil` | `True` |
| `emails` | list of registration emails | `nil` | `True` |
| `certSecret` | secret name containing certs | `nil` | `True` |
| `tlsSecret` | secret name containing tls | `nil` | `True` |
| `acmeSecret` | secret name for acme challenge | `nil` | `True` |
| `hookConfigmap` | configmap name containing custom hooks | `nil` | `False` |
| `cron` | cron schedule for renewer | `0 5 * * 1` | `False` |
| `serviceAccount` | `True`, `nil` or sa name | `True` | `False` |

Specify each parameter using the `--set key=value[,key=value]` argument to `helm install`. For example,
```bash
$ helm install --name my-release --set 'domains=example.com,www.example.com' ./
```
Alternatively, a YAML file that specifies the values for the parameters can be provided while installing the chart. For example,
```bash
$ helm install --name my-release --values values.yaml ./
```
> **Tip**: The default [values.yaml](values.yaml) should work out-of-the-box (see commands in TL;DR).