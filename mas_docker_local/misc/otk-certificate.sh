#!/usr/bin/env bash

if ! [[ "${INSTALL_CERT_AND_FIP}" == "true" ]]; then
    echo "com.ca.otk-certificate.sh : Will not install cert and FIP automatically, configure INSTALL_CERT_AND_FIP to true to do so."
else

    # Read the subject line from the certificate
    cnline=$(openssl x509 -noout -subject -in /tmp/localhost.pem)
    cnValue=${cnline#*CN=}

    # Extract the body from certificate
    cp /tmp/localhost.pem /tmp/localhost.tmp

    sed -i.bak "s/-----BEGIN CERTIFICATE-----//g" /tmp/localhost.tmp
    sed -i.bak "s/-----END CERTIFICATE-----//g" /tmp/localhost.tmp

    certValue=`cat /tmp/localhost.tmp | tr '\n' ' '`

    # Check if Certificate already exist
    certExist=$(curl --insecure --cacert /tmp/localhost.pem --user admin:password https://localhost:8443/restman/1.0/trustedCertificates?name=$cnValue | grep "l7:Item")

    # Create the certificate if not exist, else grab the certificate id.
    if [[ ! -n "$certExist" ]]; then
        #### Begin install certificate ######

        # Detemplatize the bundle file
        sed -i.bak "s|\\\$#{CERT_NAME}#|${cnValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/trusted_cert.xml
        sed -i.bak "s|\\\$#{ISSUER_NAME}#|${cnValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/trusted_cert.xml
        sed -i.bak "s|\\\$#{SUBJECT_NAME}#|${cnValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/trusted_cert.xml
        sed -i.bak "s|\\\$#{ENCODED_CERT}#|${certValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/trusted_cert.xml

        rm -f /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/localhost.tmp.bak
        rm -f /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/trusted_cert.xml.bak

        # Call Restman to put the certificate.
        certIdLine=$(curl --insecure -X POST -H "Content-Type: application/xml"  --cacert /tmp/localhost.pem -d @/opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/trusted_cert.xml -u admin:password https://localhost:8443/restman/1.0/trustedCertificates | grep "l7:Id")

    else
        certIdLine=$(curl --insecure --cacert /tmp/localhost.pem --user admin:password https://localhost:8443/restman/1.0/trustedCertificates?name=$cnValue | grep "l7:Id")
    fi

    tmp=${certIdLine#*<l7\:Id>}
    certId=${tmp%*<\/l7\:Id>}

    #### Begin install SAML Provider ######

    # Detemplatize the bundle file
    sed -i.bak "s|\\\$#{CERT_ID}#|${certId}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/saml.bundle

    rm -f /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/saml.bundle.bak

    # Call Restman to put the SAML Provider.
    curl --insecure -X PUT -H "Content-Type: application/xml"  --cacert /tmp/localhost.pem -d @/opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/saml.bundle -u admin:password https://localhost:8443/restman/1.0/bundle


    #### Begin install FIP ######

    # Detemplatize the bundle file
    sed -i.bak "s|\\\$#{ISSUER_NAME}#|${cnValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/fip_user.bundle
    sed -i.bak "s|\\\$#{SUBJECT_NAME}#|${cnValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/fip_user.bundle
    sed -i.bak "s|\\\$#{ENCODED_CERT}#|${certValue}|g" /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/fip_user.bundle

    rm -f /opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/fip_user.bundle.bak

    # Call Restman to put the FIP user.
    curl --insecure -X PUT -H "Content-Type: application/xml"  --cacert /tmp/localhost.pem -d @/opt/SecureSpan/Gateway/node/default/etc/bootstrap/bundle/after-start/fip_user.bundle -u admin:password https://localhost:8443/restman/1.0/bundle


fi