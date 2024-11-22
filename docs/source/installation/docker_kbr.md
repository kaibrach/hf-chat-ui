# Running on Docker

Pre-built docker images are provided with and without MongoDB built in. Refer to the [configuration section](../configuration/overview) for env variables that must be provided. We recommend using the `--env-file` option to avoid leaking secrets into your shell history.

```bash
# Without built-in DB
docker run -p 3000:3000 --env-file .env.local --name chat-ui ghcr.io/huggingface/chat-ui

# With built-in DB
DOTENV_LOCAL=$(<.env.local) 
docker run -p 3000:3000 -e DOTENV_LOCAL -v chat-ui:/data --name chat-ui ghcr.io/huggingface/chat-ui-db 
docker run -p 3000:3000 --env-file .env.local -v chat-ui:/data --name chat-ui ghcr.io/huggingface/chat-ui-db

# KBR
# Build docker with database
docker build -t synergy:0.2 --build-arg INCLUDE_DB=true --no-cache .
# Run docker with database
docker run --rm -e DOTENV_LOCAL -p 3000:3000 -v synergy:/data --name synergy synergy:0.2

# Build docker without database 
docker build -t synergy:0.1

# Store env.local in variable (cannot be used with docker --env-file because it is getting some errors)
export DOTENV_LOCAL=$(<.env.local) && docker run --rm -e DOTENV_LOCAL -p 3000:3000 -v synergy:/data --name synergy synergy:0.3

# This should also work, but not tested
docker run --mount type=bind,source="$(pwd)/.env.local",target=/app/.env.local -p 3000:3000

# If you have not build docker with database but want to do everything within docker, you need to create a network
## see https://www.tutorialworks.com/container-networking/
## Create the network 
docker network create synergy-network
## Start Mongo-Db within the network
docker run --rm --net synergy-network -p 27017:27017 --name synergy-db mongo:latest 
## Start application within the docker network
export DOTENV_LOCAL=$(<.env.local)  
docker run --rm --network synergy-network -e DOTENV_LOCAL -p 3000:3000 -v synergy:/data --name synergy synergy:0.1
docker run --rm --network synergy-network -e DOTENV_LOCAL -p 3000:3000 --name synergy synergy:0.1



## Start keycloak within the docker network
docker run --rm --network synergy-network --name openid-server3  -p 8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin quay.io/keycloak/keycloak:26.0.2 start-dev --features organization

## if you want to change the ports you have to follow these setps
# 1. Create a docker image of the current container
docker commit openid-server openid-server-image
# 2. Delete the docker container
docker remove openid-server
# 3. Run the new container with different setup
docker run --rm --network synergy-network -d -p 0.0.0.0:8080:8080 --name openid-server -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin -e KC_PROXY=edge \ openid-server-image start-dev --features organization 

docker run -p 0.0.0.0:8080:8080 -e KC_BOOTSTRAP_ADMIN_USERNAME=admin -e KC_BOOTSTRAP_ADMIN_PASSWORD=admin  --name openid-server openid-server-image start-dev --features organization


```

export DOTENV_LOCAL=$(<.env.local) && docker run --rm -e DOTENV_LOCAL -p 3000:3000 -v synergy:/data --network synergy_synergy-network --name synergy synergy:0.3

docker run -p 5173:5173 -e DOTENV_LOCAL -v synergy:/data --name synergy
