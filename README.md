# Callisto LocalDev

## Introduction and motivation

The purpose of this repository is to enable the Callisto application to run for development or demo/test purposes on a local machine and to minimize the user's input to do so.

The motivation to create this solution was the growing number of dependencies included in Callisto, their configuration and possible avoidance of manual downloading and running dependencies from repositories when it is not necessary.

`Example scenario`: I am a developer working on the UI. I don't have to edit the code for e.g. Timecard-restapi or any other servivces, so I don't need to access their code base directly. I'm only interested in the current, working versions of Timecard-restapi and all other services. For this purpose, I can run Timecard-restapi (and any other Callisto dependencies) in the local environment as Docker containers based on the images located and downloaded from Callisto AWS ECR repository. I am going to need only the code base for the UI, where I can work with the code while it is running as a Docker container so the UI can easily communicate with other Callisto dependencies.

It is also possible to run a working version of the Callisto for testing or demonstration purposes for those people, who do not want or need to edit the code of any of the services.

## Requirements

> Docker & Docker Compose

> Configured ECR Repo for Docker to pull Docker images (https://collaboration.homeoffice.gov.uk/display/EAHW/Configure+ECR+Repo+for+Docker). Most likely, you will need permissions to be able to download the images from the ECR. Ask the person with administrator privileges to grant access.

## How to run it ?

> Run `docker compose up -d` command from the project root directory

### Scenario 1: Running Callisto without need to edit code base (e.g. demo purposes)

This is the most basic way to run Callisto LocalDev.
To do this, follow steps below:

- start Docker environment on your machine
- download the Callisto LocalDev repository
- from the repository root directory, run the `docker compose up -d` command.
  Docker will download and run any services needed to run Callisto.

Wait for Docker to download all the images needed to run the services. Starting services, especially those based on Spring, also takes a while. Watch the Docker logs to notice when the Callisto application is completely running.

At this point, all the services you need should be up and running. This can be determined by the greenish color of the icons for each service in Docker Desktop and/or their status shown as 'running'. Some of the services will have a gray icon color, or the status 'Exited', which means that these services are not running at the moment. In most cases, it is a correct behavior of the service. Services such as DB migrations, Kafka producer/consumer setup have only been started to perform their setup/update tasks, and these containers should exit when they are done.

Now access Callisto UI here: https://web.callisto.localhost

**_If any issues or certificate problems, check Help section._**

### Scenario 2: I want to develop code for an individual service only

These steps apply to all services including Callisto UI:
- Perform all steps from Scenario 1
- Stop the Docker service you'd like to develop/debug (this would have been started by following the steps from Scenario 1)
- Checkout code repository for the service you'd like to develop/debug
- From its root directory, run `docker compose up -d` command

After a successful start, check if you have access to the service (e.g access the UI via your browser or hit the Open API doc URL, if it's a REST API service). If everything went well, you can edit the code and preview the changes reflected in your localdev context.

The service can also be debugged. To do so in a JetBrains IDE, a debugger has to be added (Run -> Edit Configurations.. -> Add Remote JVM Debug), with the port matching the external port mapped in the docker compose file of the service to debug. For example, that would be 50211 for callisto-balance-calculator service

### Debugging code while running service on Docker

**_If any issues or certificate problems, check Help section._**

## .env

This holds any environment variables required to run the solution so that no custom configuration is required. 
If a variable needs to be modified, for example to run a specific TAG, prefix the docker command with the variable

e.g. This would run the solution using the UI docker image that had been tagged with `EAHW-2300`

```
WEB_TAG=EAHW-2300 docker compose up -d
```

## Accessing UI & other URLs

The pattern to access services directly from the browser -
https://\<docker-compose-service-name\>.callisto.localhost

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
- This will allow you to import the certificate into your Keychain, it should be added to 'login' or errors will occur.
- Open Keychain and locate the certificate.
- Expand the trust section and change `When using this certificate` to `Always Trust`
- Close the window to save the changes
- Refresh your browser window

## Port allocation for services

- starting in 50000 range
- C4 containers will jump by 100s
- core service will be undefined/ephemeral/dynamically selected by docker e.g. postgres & kafka
