# Mobile API Gateway (MAS): MAG-4.2, OTK-4.3.1, GW-9.4

## <a name="configuration"></a>Configuration:

Theses steps will setup the environment to showcase the use-cases above. The FQDN references in the tutorial will be **mas.docker.local**, **msgw.docker.local**, **lac.docker.local** for the MAS/OTK, MGW, and LAC UI external services respectively. **consul.docker.local** will be used to reference the Consul UI. The FQDNs point to your Docker Engine IP address so update your local */etc/hosts* file accordingly. *For native Docker on the MAC, this is the loopback IP: **127.0.0.1**.* The FQDNs can be changed to suite your needs, but the coresponding environment variables and x509 certificates should also be changed (see [development](#development))

Custom environment variables are exported from the Makefile for every *make* command vi the [.custom.env](.custom.env) file. These custom environment variables include application specific hostnames, certificates, and user credentials:

```
## Export some application specific environment variables

# certificates
export MGW_SSL_KEY_B64="$(cat config/certs/msgw.cert.p12 | base64)"
export MGW_SSL_KEY_PASS=password
export MGW_SSL_PUBLIC_CERT_B64="$(cat config/certs/msgw.cert.pem | base64)"
export MAS_SSL_KEY_B64="$(cat config/certs/mas.cert.p12 | base64)"
export MAS_SSL_KEY_PASS=password
export MAS_SSL_PUBLIC_CERT_B64="$(cat config/certs/mas.cert.pem | base64)"

# MAS/MAG/OTK
export MAS_HOSTNAME=mas.docker.local
export MDC_HOSTNAME=${MAS_HOSTNAME}
export OTK_HOSTNAME=${MAS_HOSTNAME}
...
```

## <a name="installation"></a>Installation:

Start the main application via the **make** command. You can tail the logs in this terminal via *make log* or open a new one (docker-compose -f docker-compose.yml logs -f)

	make
