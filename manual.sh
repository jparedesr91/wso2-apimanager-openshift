oc new-project kcb-wso2apim --description="Test Wso2 Api Manager Project for Ingoing Requests" --display-name="kcb-wso2-am"
oc project kcb-wso2apim
oc adm policy add-scc-to-user privileged system:serviceaccount:kcb-wso2apim:kcb-wso2am-svc-account
oc adm policy add-scc-to-user anyuid system:serviceaccount:kcb-wso2apim:kcb-wso2am-svc-account

oc apply -f generic/config/wso2am-svc-account.yaml
oc apply -f generic/config/endpoints-reader-role.yaml
oc apply -f generic/config/endpoints-reader-role-wso2-binding.yaml
oc apply -f generic/config/wso2am-svc-account-security-context.yaml

oc apply -f wso2apim-db/config/mysql-db-service-configuration.yaml
oc apply -f wso2apim-db/config/wso2am-mysql-db-service-initialization.yaml
oc apply -f wso2apim-db/config/wso2am-mysql-db-service-test.yaml
oc apply -f wso2apim-db/config/wso2am-mysql-db-service.yaml
oc apply -f wso2apim-db/volumes/wso2am-mysql-db-service-volume-claim.yaml
oc apply -f wso2apim-db/deployments/wso2am-mysql-db-deployment.yaml
oc apply -f wso2apim-db/services/wso2am-mysql-db-service.yaml
oc apply -f wso2apim-db/routes/wso2am-mysql-db-route.yaml

oc apply -f wso2apim-keymanager/config/wso2am-km-conf.yaml
oc apply -f wso2apim-keymanager/deployments/wso2am-km-deployment.yaml
oc apply -f wso2apim-keymanager/services/wso2am-km-service.yaml

oc apply -f wso2apim-tm/config/wso2am-tm-conf-entrypoint.yaml
oc apply -f wso2apim-tm/config/wso2am-tm-conf.yaml
oc apply -f wso2apim-tm/volumes/wso2am-tm-volume-claim.yaml
oc apply -f wso2apim-tm/deployments/wso2am-tm-deployment.yaml
oc apply -f wso2apim-tm/services/wso2am-tm-service.yaml

oc apply -f wso2apim-publisher/config/wso2am-publisher-conf-entrypoint.yaml
oc apply -f wso2apim-publisher/config/wso2am-publisher-conf.yaml
oc apply -f wso2apim-publisher/volumes/wso2am-publisher-volume-claims.yaml
oc apply -f wso2apim-publisher/deployments/wso2am-publisher-deployment.yaml
oc apply -f wso2apim-publisher/services/wso2am-publisher-service.yaml
oc apply -f wso2apim-publisher/routes/wso2am-publisher-route.yaml

oc apply -f wso2apim-devportal/config/wso2am-devportal-conf-entrypoint.yaml
oc apply -f wso2apim-devportal/config/wso2am-devportal-conf.yaml
oc apply -f wso2apim-devportal/volumes/wso2am-devportal-volume-claims.yaml
oc apply -f wso2apim-devportal/deployments/wso2am-devportal-deployment.yaml
oc apply -f wso2apim-devportal/services/wso2am-devportal-service.yaml
oc apply -f wso2apim-devportal/routes/wso2am-devportal-route.yaml

oc apply -f wso2apim-gateway/config/wso2am-gateway-conf.yaml
oc apply -f wso2apim-gateway/config/wso2am-gateway-conf-entrypoint.yaml
oc apply -f wso2apim-gateway/volumes/wso2am-volume-claim-synapse-configs-volumen-claim.yaml
oc apply -f wso2apim-gateway/deployments/wso2am-gateway-deployment.yaml
oc apply -f wso2apim-gateway/services/wso2am-gateway-service.yaml
oc apply -f wso2apim-gateway/routes/wso2am-gateway-route.yaml
