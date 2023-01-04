#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=arm64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88

package_update: true
package_upgrade: true

packages:
  - screen
  - rsync
  - git
  - curl
  - docker-ce
  - docker-ce-cli
  - python3-pip
  - python3-dev
  - python3-selinux
  - python3-setuptools
  - python3-venv
  - libffi-dev
  - gcc
  - libssl-dev

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
  - echo "!!!!!!!!!! DOCKER !!!!!!!!!!"
  - cp /home/ubuntu/daemon.json /etc/docker/daemon.json
  - systemctl restart docker
  - echo "!!!!!!!!!! DOCKER:Registry !!!!!!!!!!"
  - docker run -d --name registry --restart=always -p 4000:5000  -v registry:/var/lib/registry registry:2
  - echo "!!!!!!!!!! DeathStarBench !!!!!!!!!!"
  - cd /opt && git clone https://github.com/delimitrou/DeathStarBench.git 
  - echo "!!!!!!!!!! DeathStarBench:Build openresty-thrift !!!!!!!!!!"
  - cd /opt/DeathStarBench/socialNetwork/docker/openresty-thrift && docker build --no-cache -t dsb/openresty-thrift -f xenial/Dockerfile .
  - echo "!!!!!!!!!! DeathStarBench:Build thrift-microservice-deps !!!!!!!!!!"
  - cd /opt/DeathStarBench/socialNetwork/docker/thrift-microservice-deps && docker build --no-cache -t dsb/thrift-microservice-deps -f cpp/Dockerfile .
  - echo "!!!!!!!!!! DeathStarBench:Build media-frontend !!!!!!!!!!"
  - cd /opt/DeathStarBench/socialNetwork/docker/media-frontend && docker build --no-cache -t dsb/mediafrontend -f xenial/Dockerfile .
  - echo "!!!!!!!!!! DeathStarBench:Build social-network-microservices !!!!!!!!!!"
  - sed -i "1s/yg397/dsb/" /opt/DeathStarBench/socialNetwork/Dockerfile
  - sed -i "1s/xenial/latest/" /opt/DeathStarBench/socialNetwork/Dockerfile
  - cd /opt/DeathStarBench/socialNetwork && docker build --no-cache -t dsb/social-network-microservices -f Dockerfile .
#  - curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--flannel-backend=none --cluster-cidr=192.168.0.0/16 --disable-network-policy --disable=traefik" sh -
  - echo 'OCI Ampere A1 - DeathStarBench' >> /etc/motd
