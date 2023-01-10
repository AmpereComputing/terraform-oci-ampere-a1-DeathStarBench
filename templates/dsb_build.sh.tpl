#!/usr/bin/env bash

PROJECT_DIR='/opt/DeathStarBench'
LOGFILE=$PROJECT_DIR/dsb-build_containers.log
exec >> $LOGFILE 2>&1

echo "!!!!!!!!!! DeathStarBench !!!!!!!!!!"
cd /opt
git clone https://github.com/delimitrou/DeathStarBench.git 

echo "!!!!!!!!!! DeathStarBench:Build openresty-thrift !!!!!!!!!!"
cd /opt/DeathStarBench/socialNetwork/docker/openresty-thrift
docker build --no-cache -t dsb/openresty-thrift -f xenial/Dockerfile .
docker image tag dsb/openresty-thrift ${public_ip}:4000/dsb/openresty-thrift:latest
docker image push ${public_ip}:4000/dsb/openresty-thrift:latest

echo "!!!!!!!!!! DeathStarBench:Build thrift-microservice-deps !!!!!!!!!!"
cd /opt/DeathStarBench/socialNetwork/docker/thrift-microservice-deps
docker build --no-cache -t dsb/thrift-microservice-deps -f cpp/Dockerfile .
docker image tag dsb/thrift-microservice-deps:latest ${public_ip}:4000/dsb/thrift-microservice-deps:latest
docker image push ${public_ip}:4000/dsb/thrift-microservice-deps:latest


echo "!!!!!!!!!! DeathStarBench:Build media-frontend !!!!!!!!!!"
cd /opt/DeathStarBench/socialNetwork/docker/media-frontend
docker build --no-cache -t dsb/media-frontend -f xenial/Dockerfile .
docker image tag dsb/media-frontend ${public_ip}:4000/dsb/openresty-thrift:latest
docker image push ${public_ip}:4000/dsb/openresty-thrift:latest


echo "!!!!!!!!!! DeathStarBench:Build social-network-microservices !!!!!!!!!!"
sed -i "1s/yg397/dsb/" /opt/DeathStarBench/socialNetwork/Dockerfile
sed -i "1s/xenial/latest/" /opt/DeathStarBench/socialNetwork/Dockerfile
cd /opt/DeathStarBench/socialNetwork
# Build currently fails
docker build --no-cache -t dsb/social-network-microservices -f Dockerfile .

# kolla-build -b ${kolla_base_image} -t source --registry ${public_ip}:4000 --push
