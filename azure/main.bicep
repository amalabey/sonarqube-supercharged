
@description('Environment prefix')
param envPrefix string = 'prod'

@description('Solution name')
param solutionName string = 'sonarqube-sc'

@description('Location for the resources. Defaults to resource groups location')
param location string = resourceGroup().location

@description('User name for the postgresql database')
param dbAdminUserName string = 'sqscuser' 

@description('Password for the sonarqube database')
@secure()
param dbAdminPassword string

var servicePlanName = 'asp-${solutionName}-${envPrefix}'
var webAppName = 'web-${solutionName}-${envPrefix}'
var dbServerName = 'postgre-${solutionName}-${envPrefix}'
var dbName = '${webAppName}database'
var jdbcSonarUserName = '${dbAdminUserName}@${dbServerName}'

resource dbServer 'Microsoft.DBforPostgreSQL/servers@2017-12-01' = {
  name: dbServerName
  location: location
  sku: {
    name: 'GP_Gen5_2'
    tier: 'GeneralPurpose'
    capacity: 2
    size: '51200'
    family: 'Gen5'
  }
  properties: {
    createMode: 'Default'
    version: '9.6'
    administratorLogin: dbAdminUserName
    administratorLoginPassword: dbAdminPassword
  }
}

resource fireWallRules 'Microsoft.DBforPostgreSQL/servers/firewallRules@2017-12-01' = {
  name: '${dbServerName}-firewall'
  parent: dbServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '0.0.0.0'
  }
}

resource database 'Microsoft.DBforPostgreSQL/servers/databases@2017-12-01' = {
  name: dbName
  parent: dbServer
  properties: {
    charset: 'utf8'
    collation: 'English_United States.1252'
  }
}

resource servicePlan 'Microsoft.Web/serverfarms@2016-09-01' = {
  kind: 'linux'
  name: servicePlanName
  location: location
  properties: {
    name: servicePlanName
    reserved: true
  }
  sku: {
    name: 'B3'
    tier: 'Basic'
    size: 'B3'
    family: 'B'
    capacity: 1
  }
}

resource webApp 'Microsoft.Web/sites@2016-08-01' = {
  name: webAppName
  location: location
  properties: {
    siteConfig: {
      appSettings: [
        {
          name: 'WEBSITES_ENABLE_APP_SERVICE_STORAGE'
          value: 'false'
        }
        {
          name: 'WEBSITES_PORT'
          value: '9000'
        }
      ]
      linuxFxVersion: 'DOCKER|amalabey/sonarqube-supercharged:9.5.2'
    }
    serverFarmId: servicePlan.id  
  }
  dependsOn:[database]
}

resource siteName_appsettings 'Microsoft.Web/sites/config@2020-06-01' = {
  parent: webApp
  name: 'appsettings'
  properties: {
    SONARQUBE_JDBC_URL: 'jdbc:postgresql://${dbServer.properties.fullyQualifiedDomainName}:5432/${dbName}?user=${jdbcSonarUserName}&password=${dbAdminPassword}&ssl=true&sslfactory=org.postgresql.ssl.DefaultJavaSSLFactory'
    SONARQUBE_JDBC_USERNAME: jdbcSonarUserName
    SONARQUBE_JDBC_PASSWORD: dbAdminPassword
    SONAR_ES_BOOTSTRAP_CHECKS_DISABLE: 'true'
  }
}


