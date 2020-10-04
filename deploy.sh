#!/bin/bash

####################### SET ENVIRONMENT ############################

# Setting the necessary environment variables
export OPENSHIFT_PROJECT_NAME="wso2apim"

#Keystore Details
export KEYSTORE_PASSWORD="wso2carbon"
export TRUSTORE_PASSWORD="wso2carbon"

# Docker image names # Do Not change these names
export IMAGE_ANALYTICS_WORKER="docker.wso2.com/wso2am-analytics-worker:3.1.0"
export IMAGE_ANALYTICS_DASHBOARD="docker.wso2.com/wso2am-analytics-worker:3.1.0"
export IMAGE_APIM="docker.wso2.com/wso2am-analytics-dashboard:3.1.0"

# Settings limits to resources
export RESOURCES_LIMITS_CPU="3000m"
export RESOURCES_LIMITS_MEMORY="3Gi"

export RESOURCES_REQUEST_CPU="2000m"
export RESOURCES_REQUEST_MEMORY="2Gi"

export RESOURCES_LIMITS_CPU_KM="3000m"
export RESOURCES_LIMITS_MEMORY_KM="3Gi"

export RESOURCES_LIMITS_CPU_GW="3000m"
export RESOURCES_LIMITS_MEMORY_GW="3Gi"

export RESOURCES_LIMITS_CPU_ANALYTICS_WORKER="2000m"
export RESOURCES_LIMITS_MEMORY_ANALYTICS_WORKER="4Gi"

export RESOURCES_LIMITS_CPU_ANALYTICS_DASHBOARD="2000m"
export RESOURCES_LIMITS_MEMORY_ANALYTICS_DASHBOARD="4Gi"

####################### END SET ENVIRONMENT ############################

####################### SET INIT DEPLOYMENT  ############################
oc=`which oc`

SCRIPT_WSO2AM_MYSQL_DB_SERVICE_PATH="../wso2apim-db/scripts/deploy.sh"
SCRIPT_WSO2AM_AM_ANALYTICS_PATH="../wso2apim-analytics/scripts/deploy.sh"
SCRIPT_WSO2AM_KM_DEPLOYMENT_PATH="../wso2apim-keymanager/scripts/deploy.sh"
SCRIPT_WSO2AM_GATEWAY_PATH="../wso2apim-gateway/scripts/deploy.sh"
SCRIPT_WWSO2AM_AM_PATH="../wso2apim-manager/scripts/deploy.sh"

oc new-project wso2apim --description="Test Wso2 Api Manager Project for Ingoing Requests" --display-name="wso2-am"
oc project wso2apim

cd `dirname "$0"`
# Functions
function echoBold () {
    echo -e $'\e[1m'"${1}"$'\e[0m'
}

echoBold "Initiating deploying APIM Full Distribuid Pattern........"

echoBold 'Creating ConfigMaps for Generics...'
# create the Generics ConfigMaps
oc apply -f generic/config/wso2am-svc-account.yaml
oc apply -f generic/config/endpoints-reader-role.yaml
oc apply -f generic/config/endpoints-reader-role-wso2-binding.yaml
oc apply -f generic/config/wso2am-svc-account-security-context.yaml
####################### END SET INIT DEPLOYMENT ############################

####################### SET wso2am-mysql-db-service DEPLOYMENT  ############################
echoBold 'Deploying wso2am-mysql-db-service'

echoBold 'Creating ConfigMaps for wso2am-mysql-db-service...'
# create the wso2am-mysql-db-service ConfigMaps
oc apply -f wso2apim-db/config/mysql-db-service-configuration.yaml
oc apply -f wso2apim-db/config/wso2am-mysql-db-service-initialization.yaml
oc apply -f wso2apim-db/config/wso2am-mysql-db-service-test.yaml
oc apply -f wso2apim-db/config/wso2am-mysql-db-service.yaml

echoBold 'Persisting VolumesClaim for wso2am-mysql-db-service...'
# persistent volumeClaim wso2am-mysql-db-service
oc apply -f wso2apim-db/volumes/wso2am-mysql-db-service-volume-claim.yaml

echoBold 'Deploying WSO2 wso2am-mysql-db-service...'
# deploy deploymentConfig wso2am-mysql-db-service
oc apply -f wso2apim-db/deployments/wso2am-mysql-db-deployment.yaml
sleep 1m

echoBold 'Creating the wso2am-mysql-db-service service...'
# create the wso2am-mysql-db-service service
oc apply -f wso2apim-db/services/wso2am-mysql-db-service.yaml
sleep 2

echoBold 'Creating the wso2am-mysql-db-service route...'
# create the wso2am-mysql-db-route route
oc apply -f wso2apim-db/routes/wso2am-mysql-db-route.yaml
sleep 2

echoBold "Deployment of wso2am-mysql-db-service is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-mysql-db-service DEPLOYMENT ############################

####################### SET wso2am-am-analytics-worker and wso2am-am-analytics-dashboard DEPLOYMENT  ############################
echoBold 'Deploying wso2am-am-analytics-worker and wso2am-am-analytics-dashboard'

echoBold 'Creating ConfigMaps for wso2am-am-analytics-worker and wso2am-am-analytics-dashboard...'
# create the wso2am-am-analytics-worker and wso2am-am-analytics-dashboard ConfigMaps
oc apply -f wso2apim-analytics/config/wso2am-am-analytics-dashboard-conf.yaml
oc apply -f wso2apim-analytics/config/wso2am-am-analytics-dashboard-bin.yaml
oc apply -f wso2apim-analytics/config/wso2am-am-analytics-dashboard-conf-entrypoint.yaml
oc apply -f wso2apim-analytics/config/wso2am-analytics-worker-conf.yaml

echoBold 'Persisting VolumesClaim for wso2am-am-analytics-worker and wso2am-am-analytics-dashboard...'
# persistent volumeClaim wso2am-mysql-db-service

echoBold 'Deploying WSO2 wso2am-am-analytics-worker and wso2am-am-analytics-dashboard...'
# deploy deploymentConfig wso2am-am-analytics-worker and wso2am-am-analytics-dashboard
oc apply -f wso2apim-analytics/deployments/wso2am-am-analytics-worker-deployment.yaml
oc apply -f wso2apim-analytics/deployments/wso2am-am-analytics-dashboard-deployment.yaml

echoBold 'Creating the wso2am-am-analytics-worker and wso2am-am-analytics-dashboard service...'
# create the wso2am-am-analytics-worker and wso2am-am-analytics-dashboard
oc apply -f wso2apim-analytics/services/wso2am-analytics-worker-service.yaml
oc apply -f wso2apim-analytics/services/wso2am-am-analytics-dashboard-service.yaml

echoBold 'Deploying Routes for API Manager, Gateway and Identity Server......'
oc apply -f wso2apim-analytics/routes/wso2am-analytics-dashboard-route.yaml

echoBold "Deployment of wso2am-am-analytics-worker and wso2am-am-analytics-dashboard is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-mysql-db-service and wso2am-am-analytics-dashboard DEPLOYMENT ############################

####################### SET wso2am-km-deployment DEPLOYMENT  ############################
echoBold 'Deploying wso2am-km-deployment'

echoBold 'Creating ConfigMaps for wso2am-km-deployment...'
# create the wso2am-km-deployment ConfigMaps
oc apply -f wso2apim-keymanager/config/wso2am-entrypoint.yaml
oc apply -f wso2apim-keymanager/config/wso2am-km-conf.yaml

echoBold 'Persisting VolumesClaim for wso2am-km-deployment...'
# persistent volumeClaim wso2am-mysql-db-service

echoBold 'Deploying WSO2 wso2am-km...'
# deploy deploymentConfig wso2am-km-deployment
oc apply -f wso2apim-keymanager/deployments/wso2am-km-deployment.yaml

echoBold 'Creating the wso2am-km-deployment...'
# create the wso2am-km-deployment
oc apply -f wso2apim-keymanager/services/wso2am-km-service.yaml

echoBold "Deployment of wso2am-km is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-km-deployment DEPLOYMENT ############################

####################### SET wso2am-tm DEPLOYMENT  ############################
echoBold 'Deploying wso2am-tm'

echoBold 'Creating ConfigMaps for wso2am-tm...'
# create the wso2am-tm ConfigMaps
oc apply -f wso2apim-tm/config/wso2am-tm-conf-entrypoint.yaml
oc apply -f wso2apim-tm/config/wso2am-tm-conf.yaml

echoBold 'Persisting VolumesClaim for wso2am-tm...'
# persistent volumeClaim wso2am-tm
oc apply -f wso2apim-tm/volumes/wso2am-tm-volume-claim.yaml

echoBold 'Deploying WSO2 wso2am-tm...'
# deploy deploymentConfig wso2am-tm
oc apply -f wso2apim-tm/deployments/wso2am-tm-deployment.yaml

echoBold 'Creating the wso2am-tm service...'
# create the wso2am-tm service
oc apply -f wso2apim-tm/services/wso2am-tm-service.yaml

echoBold "Deployment of wso2am-tm is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-tm DEPLOYMENT ############################

####################### SET wso2am-devportal DEPLOYMENT  ############################
echoBold 'Deploying wso2am-publisher'

echoBold 'Creating ConfigMaps for wso2am-publisher...'
# create the wso2am-publisher-deployment ConfigMaps

oc apply -f wso2apim-publisher/config/wso2am-publisher-conf-entrypoint.yaml
oc apply -f wso2apim-publisher/config/wso2am-publisher-conf.yaml

echoBold 'Persisting VolumesClaim for wso2am-publisher...'
# persistent volumeClaim wso2am-publisher
oc apply -f wso2apim-publisher/volumes/wso2am-publisher-volume-claims.yaml

echoBold 'Deploying WSO2 wso2am-publisher...'
# deploy deploymentConfig wso2am-publisher
oc apply -f wso2apim-publisher/deployments/wso2am-publisher-deployment.yaml

echoBold 'Creating the wso2am-publisher service...'
# create the wso2am-publisher service
oc apply -f wso2apim-publisher/services/wso2am-publisher-service.yaml

echoBold 'Creating the wso2am-publisher route...'
# create the wso2am-route service
oc apply -f wso2apim-publisher/routes/wso2am-publisher-route.yaml

echoBold "Deployment of wso2am-publisher is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-devportal DEPLOYMENT ############################

####################### SET wso2am-devportal DEPLOYMENT  ############################
echoBold 'Deploying wso2am-devportal'

echoBold 'Creating ConfigMaps for wso2am-devportal...'
# create the wso2am-devportal-deployment ConfigMaps
oc apply -f wso2apim-devportal/config/wso2am-devportal-conf-entrypoint.yaml
oc apply -f wso2apim-devportal/config/wso2am-devportal-conf.yaml

echoBold 'Persisting VolumesClaim for wso2am-devportal...'
# persistent volumeClaim wso2am-devportal
oc apply -f wso2apim-devportal/volumes/wso2am-devportal-volume-claims.yaml

echoBold 'Deploying WSO2 wso2am-devportal...'
# deploy deploymentConfig wso2am-devportal
oc apply -f wso2apim-devportal/deployments/wso2am-devportal-deployment.yaml

echoBold 'Creating the wso2am-devportal service...'
# create the wso2am-devportal service
oc apply -f wso2apim-devportal/services/wso2am-devportal-service.yaml

echoBold 'Creating the wso2am-devportal routes...'
# create the wso2am-devportal routes
oc apply -f wso2apim-devportal/routes/wso2am-devportal-route.yaml

echoBold "Deployment of wso2am-devportal is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-devportal DEPLOYMENT ############################

####################### SET wso2am-gateway DEPLOYMENT  ############################
echoBold 'Deploying wso2am-gateway'

echoBold 'Creating ConfigMaps for wso2am-gateway...'
# create the wso2am-km-deployment ConfigMaps
oc apply -f wso2apim-gateway/config/wso2am-gateway-conf.yaml
oc apply -f wso2apim-gateway/config/wso2am-gateway-conf-entrypoint.yaml

echoBold 'Persisting VolumesClaim for wso2am-gateway...'
# persistent volumeClaim wso2am-gateway
oc apply -f wso2apim-gateway/volumes/wso2am-volume-claim-synapse-configs-volumen-claim.yaml

echoBold 'Deploying WSO2 wso2am-gateway...'
# deploy deploymentConfig wso2am-gateway
oc apply -f wso2apim-gateway/deployments/wso2am-gateway-deployment.yaml

echoBold 'Creating the wso2am-gateway service...'
# create the wso2am-gateway service
oc apply -f wso2apim-gateway/services/wso2am-gateway-service.yaml

echoBold 'Creating the wso2am-gateway route...'
# create the wso2am-gateway route
oc apply -f wso2apim-gateway/routes/wso2am-gateway-route.yaml

echoBold "Deployment of wso2am-gateway is happening in the backgroud please check the Openshift console for the status."
echoBold "After completion you can get the access details of the Server by navigating to Routes page in Openshift Console. "
####################### END SET wso2am-gateway DEPLOYMENT ############################