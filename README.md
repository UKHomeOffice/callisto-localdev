## Requirements

> Docker & Docker Compose

> Configured ECR Repo for Docker to pull Docker images (https://collaboration.homeoffice.gov.uk/display/EAHW/Configure+ECR+Repo+for+Docker)

## How to run it ?

> Run `docker compose up -d` command from the main directory level

## Accessing UI & other URLs

> UI: https://web.callisto.localhost

> Keycloak: https://keycloak.callisto.localhost

> Timecard REST API Swagger: https://timecard-restapi.callisto.localhost/swagger-ui/index.html

> Other services: https://docker-compose-service-name.callisto.localhost

## Creating a self signed cert for ingress

The ingress folder contains a key and certificate for SSL termination in an nginx reverse proxy.
This key and cert should only be used for the local development environment. This is done to
reduce the burden on anyone trying to run the solution locally but it does mean that you're
being asked to trust a certificate from a public repository
(see [Trusting the certificate](#trusting-the-certificate))

If you would like to create your own certificate you can execute the command below to generate
your own unique certificate that you can then trust.

```
openssl req -x509 -nodes -days 14600 -newkey rsa:2048 -keyout ./ingress/nginx-selfsigned.key -out ./ingress/nginx-selfsigned.crt -config ./ingress/openssl.cnf -sha256 -extensions v3_req -subj "/C=GB/O=UK Home Office/CN=Callisto Localhost"
```

## Trusting the certificate

These are the steps for trusting the certificate used by the nginx reverse proxy. These steps work
for the certificate used by the site so it doesn't matter if you used the provided certificate
or chose to generate your own unique certificate.

### Issues

An issue with anti-virus software was noticed on Chrome on MacOS. The anti-virus software
was scanning https traffic. To achieve this it issues its own certificate in order to decrypt the
traffic but because the anti-virus software doesn't trust the self signed certificate, the
trust chain is broken. Depending on the software, you may be able to configure it to trust the
certificate or you may need to add `localhost` as an exception.

In this case the software was AVG Antivirus and `localhost` was added as an exception. This is
done through Preferences > Core Shields > Web Shield > Add exceptions.

![Add exception in AVG Antivirus](./avg_exception.png)

### MacOS + Chrome

- Locate the certificate [nginx-selfsigned.crt](./ingress/nginx-selfsigned.crt) and open it
- This will import the certificate into your Keychain.
- Open Keychain and locate the certificate.
- Expand the trust section and change `When using this certificate` to `Always Trust`
- Close the window to save the changes
- Refresh your browser window

## Port allocation for services

- starting in 50000 range
- C4 containers will jump by 100s
- core service will be undefined/ephemeral/dynamically selected by docker e.g. postgres & kafka

## Help

### **'Your connection is not private' message ?**

Click **Advanced** and then **Proceed to \<service URL> (unsafe)**.

### **UI url works, but the page is blank ?**

Do the same as above for each required service url.

- [13 Dec 2022] Keycloak, Timecard REST API
