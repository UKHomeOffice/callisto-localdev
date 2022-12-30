# Callisto LocalDev

## Intruduction and motivation

The purpose of this repository is to allow the Callisto application with all its dependencies to run on the local computer and minimize user input to do so.

The motivation to create this solution was the growing number of dependencies included in Callisto, their configuration and possible avoidance of manual downloading and running dependencies from repositories when it is not necessary.

`Example`: I am a developer working on the UI. I don't have to edit the code for e.g. Timecard-restapi or any other servivces, so I don't need to access their code base directly. I'm only interested in the current, working versions of Timecard-restapi and all other services. For this purpose, I can run Timecard-restapi (and any other Callisto services/dependencies) in the local environment as Docker containers based on the images located and downloaded from Callisto AWS ECR repository. I am going to need only the code base for the UI, where I can work with the code and run it as a Docker container so the UI can easily communicate with other Callisto services/dependencies.

Of course, it is also possible to run a working version of Callisto for testing or demonstration purposes for people who do not want or need to edit the code of any of the services.
This is done by executing the docker compose up -d command from the root of the repository.

## Requirements

> Docker & Docker Compose

> Configured ECR Repo for Docker to pull Docker images (https://collaboration.homeoffice.gov.uk/display/EAHW/Configure+ECR+Repo+for+Docker). Most likely, you will need permissions to be able to download the images from the ECR. Ask the person with administrator privileges to grant access.

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

# How to work with LocalDev ?

## Run latest, working version of Callisto without need to edit code base

This is the most basic way to run Callisto LocalDev.
To do this, follow the next steps

- download the Callisto LocalDev repository
- run the Docker environment on the given machine
- from the main repository, run the docker compose up -d command
  After executing the above command, you should see in Docker Desktop how individual services start.

The first launch may take a while as Keycloak and other SpringBoot-based applications take some time to start.

At this point, all the services you need should be up and running. This can be determined by the greenish color of the icons for each service in Docker Desktop and/or their status shown as 'running'. Some of the services will have a gray icon color, or the status 'Exited', which means that these services are not running at the moment. In most cases, it is a correct behavior of the service. Services such as DB migrations, Kafka producer/consumer setup have only been started to perform their tasks, and these containers should exit when they are done.

## Help

### **'Your connection is not private' message ?**

Click **Advanced** and then **Proceed to \<service URL> (unsafe)**.

### **UI url works, but the page is blank ?**

Do the same as above for each required service url.

- [13 Dec 2022] Keycloak, Timecard REST API
