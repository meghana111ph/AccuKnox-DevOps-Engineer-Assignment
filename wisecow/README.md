# Cow wisdom web server

## Prerequisites

```
sudo apt install fortune-mod cowsay -y
```

## How to use?

1. Run `./wisecow.sh`
2. Point the browser to server port (default 4499)

## What to expect?
![wisecow](https://github.com/nyrahul/wisecow/assets/9133227/8d6bfde3-4a5a-480e-8d55-3fef60300d98)

# Problem Statement
Deploy the wisecow application as a k8s app

## Requirement
1. Create Dockerfile for the image and corresponding k8s manifest to deploy in k8s env. The wisecow service should be exposed as k8s service.
2. Github action for creating new image when changes are made to this repo
3. [Challenge goal]: Enable secure TLS communication for the wisecow app.

## Expected Artifacts
1. Github repo containing the app with corresponding dockerfile, k8s manifest, any other artifacts needed.
2. Github repo with corresponding github action.
3. Github repo should be kept private and the access should be enabled for following github IDs: nyrahul

# to build dockerfile
#Build Docker image cmds
#docker build -t wisecow:v1 .

# to Run the container
#docker run -d -p 4499:4499 --name wisecow wisecow:v1

# Open the browser
http://localhost:4499

# To check logs
docker logs wisecow


# To  deploy 
#kubectl apply -f k8s/deployment.yaml
#kubectl apply -f k8s/service.yaml

# To Verify deployment
kubectl get pods
kubectl get deployments
kubectl get services

# Ingress and TLS

Generate a TLS certificate
TLS requires two files:
- tls.crt – Public certificate.
- tls.key – Private key.

# Generate a self-signed certificate

openssl req -x509 -nodes -days 365 \
-newkey rsa:2048 \
-keyout tls.key \
-out tls.crt \
-subj "/CN=wisecow.local/O=Wisecow" \
-addext "subjectAltName=DNS:wisecow.local"

# Create a Kubernetes TLS Secret

kubectl create secret tls wisecow-tls \
  --cert=certs/tls.crt \
  --key=certs/tls.key

# To the Ingress configuration

kubectl apply -f k8s/ingress.yaml
kubectl get ingress
