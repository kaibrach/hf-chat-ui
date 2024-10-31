#!/bin/sh
# 1. Create docker container
# docker run -p 7777:8080 --name OpenID-Server \
#  -e KEYCLOAK_USER=myuser \
#  -e KEYCLOAK_PASSWORD=test \
#  -e DB_VENDOR=H2 \
#  -d keycloak/keycloak


# https://www.keycloak.org/getting-started/getting-started-docker

docker run -p 8080:8080 --name openid-server \
 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin \
 -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin \
 -e KEYCLOAK_USER=myuser \
 -e KEYCLOAK_PASSWORD=test \
quay.io/keycloak/keycloak:26.0.2 start-dev

# 2. Copy setup-client to container
# docker cp setup-client.sh OpenID-Server:/opt/keycloak/setup-client.sh
#
# 3. Run setup-client
# docker exec OpenID-Server /opt/keycloak/setup-client.sh

docker run --name openid-server -p 8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.0.2 start-dev

# https://www.keycloak.org/getting-started/getting-started-docker


docker exec openid-server /opt/keycloak/bin/kcreg.sh config credentials --server http://localhost:8080 --realm demo --user user --password password --client reg-cli
docker exec openid-server /opt/keycloak/bin/kcreg.sh create --server http://localhost:8080 --user admin --password admin --realm demo -s clientId=my_client -s 'redirectUris=["http://localhost:5173/login/*"]'

docker exec openid-server /opt/keycloak/bin/kcreg.sh config credentials \
  --server http://localhost:8080/auth \
  --realm master \
  --user admin \
  --password admin

docker exec openid-server /opt/keycloak/bin/kcreg.sh create \
  -s clientId="myclient" \
  -s 'redirectUris=["http://localhost:5173/login/*"]'

docker exec openid-server /opt/keycloak/bin/kcreg.sh get "myclient" | jq '.secret'