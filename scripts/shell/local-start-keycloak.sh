#!/bin/bash

# https://github.com/thomassuedbroecker/keycloak-create-realm-bash

export KEYCLOAK_ADMIN=admin
export KEYCLOAK_ADMIN_PASSWORD=admin
export KEYCLOAK_PORT="8080:8080"
export KEYCLOAK_IMAGE="quay.io/keycloak/keycloak:26.0.2"
export KEYCLOAK_MODE="start-dev"
export SOURCE_VOLUME=$(pwd)
export DESTINATION_VOLUME=tmp
export KEYCLOAK_URL=http://localhost:8080

# **************** Global variables

# **********************************************************************************
# Functions definition
# **********************************************************************************

function startKeycloak () {
    # docker run -it --name openid-server -p 8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.0.2 start-dev
    docker run -it -e KC_BOOTSTRAP_ADMIN_USERNAME=$KEYCLOAK_ADMIN \
                   -e KC_BOOTSTRAP_ADMIN_PASSWORD=$KEYCLOAK_ADMIN_PASSWORD \
                   -p $KEYCLOAK_PORT $KEYCLOAK_IMAGE $KEYCLOAK_MODE \ 
                   -v $SOURCE_VOLUME:$DESTINATION_VOLUME 
}

#**********************************************************************************
# Execution
# **********************************************************************************

startKeycloak