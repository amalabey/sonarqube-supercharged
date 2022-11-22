# Overview
This repository builds and publishes Docker image of SonarQube with a number of useful plugins pre-installed. A set of IaC templates have been provided to easily spinup SonarQube environments in corresponding cloud providers.

# Build Container Image
```sh
docker build -t amalabey/sonarqube-supercharged:<tagname> .
```

# Deploy to Azure
```sh
cd azure
az deployment group create -g <your-resource-group> --template-file .\main.bicep  --parameters dbAdminPassword=<your-db-password>
```