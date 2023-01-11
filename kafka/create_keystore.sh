#!/usr/bin/env sh
set -e

dir=/keystore/$1
alias=$1
days=14600
password=changeit

if test -f "$dir/${alias}_creds"; then
    echo Keystore already created
    exit
fi

rm -rf $dir
mkdir -p $dir

# Create a private key
keytool -genkey -validity $days -alias $alias -dname "C=GB, O=UK Home Office, CN=Callisto $alias" -keystore $dir/$alias.keystore.jks -keyalg RSA  -storepass $password  -keypass $password -ext SAN=dns:$alias
 
# Create CSR
keytool -keystore $dir/$alias.keystore.jks -alias $alias -certreq -file $dir/$alias.csr -storepass $password -keypass $password -ext SAN=dns:alias

# Create extensions file for SAN
printf "[SAN]\nsubjectAltName=DNS:%s" $alias  > $dir/ext.cnf

# Create cert signed by CA
openssl x509 -req -CA ./ca.crt -CAkey ./ca.key -in $dir/$alias.csr -out $dir/$alias-ca-signed.crt -days $days -CAserial $dir/ca.srl -CAcreateserial -passin pass:$password -extfile $dir/ext.cnf -extensions SAN
 
# Import CA cert into keystore
keytool -keystore $dir/$alias.keystore.jks -alias Callisto -import -noprompt -file ./ca.crt -storepass $password -keypass $password
 
# Import signed cert into keystore
keytool -keystore $dir/$alias.keystore.jks -alias $alias -import -noprompt -file $dir/$alias-ca-signed.crt -storepass $password -keypass $password

# import CA cert into truststore
keytool -keystore $dir/$alias.truststore.jks -alias Callisto -import -noprompt -file ./ca.crt -storepass $password -keypass $password

echo -n $password > $dir/${alias}_creds

# Inspect keystore contents
# keytool -list -v -keystore $dir/$alias.keystore.jks -storepass $password
# keytool -list -v -keystore $dir/$alias.truststore.jks -storepass $password
