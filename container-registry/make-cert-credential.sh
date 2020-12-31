#!/bin/bash

set -ex

registry_fqdn=$1
echo $registry_fqdn

rm -rf auth && mkdir -p auth && pushd auth

registry_port="5000"
cert_file="registry.crt"
cert_valid_days=3650
key_file="registry.key"
username="registry"
password="secret"
htpasswd="htpasswd"

{
   printf "[req]\n"
   printf "distinguished_name = req_distinguished_name\n"
   printf "x509_extensions = v3_req\n"
   printf "prompt = no\n"
   printf "\n"
   printf "[req_distinguished_name]\n"
   printf "C = CA\n"
   printf "ST = Quebec\n"
   printf "L = Montreal\n"
   printf "O = Pepe\n"
   printf "CN = $registry_fqdn\n"
   printf "\n"
   printf "[v3_req]\n"
   printf "subjectKeyIdentifier = hash\n"
   printf "authorityKeyIdentifier = keyid,issuer\n"
   printf "basicConstraints = CA:TRUE\n"
   printf "subjectAltName = @alt_names\n"
   printf "\n"
   printf "[alt_names]\n"
   printf "DNS.1 = $registry_fqdn\n"
   printf "DNS.2 = localhost\n"
} > registry.cnf



if [ ! -e "${cert_file}" ]; then
    openssl req -newkey rsa:4096 -nodes -sha256 \
            -keyout ${key_file} -x509 -days "${cert_valid_days}" \
            -out ${cert_file} \
            -config registry.cnf
fi


htpasswd -Bbn "${username}" "${password}" > ${htpasswd}

reg_domain="${registry_fqdn}:${registry_port}"
export reg_domain
localhost="localhost:${registry_port}"
export localhost
token=$(echo -n "${username}:${password}" | base64 )
export token
email="${username}@${registry_fqdn}"
export email
jq -n '
{"auths": {
        (env.reg_domain) :{
            "auth": env.token,
            "email": env.email
        },
        (env.localhost) :{
            "auth": env.token,
            "email": env.email }
       }
}' > "pull-secret.yaml"

popd
