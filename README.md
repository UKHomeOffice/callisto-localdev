## port allocation
starting in 50000 range
C4 containers will jump by 100s 
core service will be undefined/ephemeral/dynamically selected by docker e.g. postgres & kafka

## Creating a self signed cert for ingress
The ingress folder contains a key and certificate for SSL termination in an nginx reverse proxy.
This key and cert should only be used for the local development environment. This is done to
reduce the burden on anyone trying to run the solution locally but it does mean that you're
being asked to trust a certificate from a public repository 
(see [Trusting the certificate](#trusting-the-certificate))

If you would like to create your own certificate you can execute the commands below to generate
you're own unique certificate that you can then trust.

```
openssl genrsa -out ./ingress/hostname.key 2048
openssl rsa -in ./ingress/hostname.key -out ./ingress/hostname-key.pem
openssl req -new -key ./ingress/hostname-key.pem -out ./ingress/hostname-request.csr -subj "/C=GB/O=UK Home Office/CN=*.callisto.localhost"
openssl x509 -req -extensions v3_req -days 14600 -in ./ingress/hostname-request.csr -signkey ./ingress/hostname-key.pem -out ./ingress/hostname-cert.crt -extfile ./ingress/openssl.cnf
```

## Trusting the certificate

These are the steps for trusting the certificate used by the nginx reverse proxy. These steps work
for the certificate used by the site so it doesn't matter if you used the provided certificate
or chose to generate you're own unique certificate.

### MacOS + Chrome
* Ensure the solution is running. 
  
  At a minimum, ingress must be running. To check run `docker compose ps --filter status=running`
  and that an ingress contain is listed.
* Open [Callisto](https://web.callisto.localhost) in Chrome.
* If you have not already trusted the certificate, or you have created a new certificate, Chrome
should display a privacy error. 
* Next to the address bar there should be a message saying `Not Secure`. Click `Not Secure` and
then select `Certificate is not valid` from the displayed dropdown. 
* A window will appear with the general details of the certificate, select the details
tab.
* In the bottom right of the details tab their is an export button
* Export the certificate the locate the certificate in finder and open it.
* This will import the certificate into your Keychain.
* Open Keychain and locate the certificate.
* Expand the trust section and change `When using this certificate` to `Always Trust`
* Close the window to save the changes
* Refresh your browser window
