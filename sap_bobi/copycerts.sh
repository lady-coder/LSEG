#!/bin/sh

echo "Downloading certificates from S3 bucket ${BUCKET_NAME}"

cert=`aws s3 cp s3://${BUCKET_NAME}/bobi-certs/sslcertificatebody.pem ./Certificate.pem`
if [[ -z "${cert}" ]];
then
    echo "Cerificate body download failed"
    exit 1
fi

chain=`aws s3 cp s3://${BUCKET_NAME}/bobi-certs/sslcertificatechain.pem ./CertificateChain.pem`
if [[ -z "${chain}" ]];
then
    echo "Cerificate chain download failed"
    exit 1
fi

key=`aws s3 cp s3://${BUCKET_NAME}/bobi-certs/sslprivatekey.key ./PrivateKey.pem`
if [[ -z "${key}" ]];
then
    echo "Private key download failed"
    exit 1
fi

echo "Importing certificates in ACM"
importcerts=`aws acm import-certificate --certificate fileb://Certificate.pem --certificate-chain fileb://CertificateChain.pem --private-key fileb://PrivateKey.pem`

if [[ -z "${importcerts}" ]];
then
    echo "Error importing certificates! Please check the keys."
    exit 1
else
    echo "Certificate imported successfully in ACM!"
fi

rm Certificate.pem
rm CertificateChain.pem
rm PrivateKey.pem