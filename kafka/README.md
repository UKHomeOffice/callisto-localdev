# Securing Kafka with Mutual TLS

## Introduction
In simple terms Mutual TLS is like having a mutual friend, if my trusted friend
says I can trust you, then I'll trust you. In Kafka, trust has to be established
between the broker and the client. To achieve this, they both have to trust the
same Certificate Authority (CA) (their mutual friend). The broker and the client
each create their own private key (a secret only they will know) and a public
certificate that they ask the CA to sign. Now, when the broker and client
exchange certificates they will trust each other because their certificates
are signed by a mutually trusted CA.

## Certificate creation
The repository contains a CA to facilitate docker compose when configuring the
broker and clients. It is importnant not to import this certificate into any
trust store outside of this environment as it poses a significant security risk
if for example you were to import this certificate into your KeyChain when the
private key is publically distributed.

If you prefer you can create your own CA key pair and keep the private key safe.
to do this, run the following command

```
openssl req -x509 -nodes -days 14600 -newkey rsa:2048 -keyout ./kafka/ca.key -out ./kafka/ca.crt -subj "/C=GB/O=UK Home Office/CN=Callisto Localhost" -passin pass:changeit -passout pass:changeit
```

### Broker & Client Certificates
The broker and client certificates will be created on independent volumes that
will then be mounted to the kafka (broker) service and the clients. Containers
requiring a certificate will then depend on a services with the sole 
responsibility of creating the certificate and signing it with the CA. This will
ensure that the volume contains a keystore by the time it is mounted to the 
relevant container (i.e. broker or client).


## Acknowledgements

[Securing Kafka with Mutual TLS and ACLs](https://medium.com/lydtech-consulting/securing-kafka-with-mutual-tls-and-acls-b235a077f3e3)

## Useful commands

**Command to read topic (to be run from a Kafka container, e.g. kafka-tester)**

```
kafka-console-consumer --bootstrap-server kafka:9093 --from-beginning --topic callisto-timecard-timeentries --consumer.config /tmp/kafka-consumer.properties
```
