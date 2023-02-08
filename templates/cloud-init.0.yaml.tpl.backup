#cloud-config

apt:
  sources:
    docker.list:
      source: deb [arch=arm64] https://download.docker.com/linux/ubuntu $RELEASE stable
      keyid: 9DC858229FC7DD38854AE2D88D81803C0EBFCD88
    kubernetes.list:
      source: deb https://apt.kubernetes.io/ kubernetes-xenial main
      keyid: A362B822F6DEDC652817EA46B53DC80D13EDEF05

package_update: true
package_upgrade: true

packages:
  - build-essential 
  - openssl 
  - libssl-dev 
  - libz-dev 
  - libreadline-dev 
  - unzip 
  - lua5.1 
  - luarocks
  - ca-certificates
  - lsb-release
  - gnupg
  - screen
  - rsync
  - git
  - curl
  - docker-ce
  - docker-ce-cli
  - containerd.io
  - docker-compose-plugin
  - python3-pip
  - python3-dev
  - python3-selinux
  - python3-setuptools
  - python3-venv
  - python3-aiohttp 
  - libffi-dev
  - gcc
  - libssl-dev
  - apt-transport-https

groups:
  - docker
system_info:
  default_user:
    groups: [docker]

runcmd:
# Needed for building containers
# - luarocks install luasocket
  - apt-get update -y
  - apt-get install kubeadm kubectl kubelet -y
  - wget -qO- https://get.helm.sh/helm-v3.10.3-linux-arm64.tar.gz | tar xvz -C /usr/local/bin
  - mv /usr/local/bin/linux-arm64/helm /usr/local/bin/
  - rm -rf /usr/local/bin/linux-arm64
  - sed -i 's/disabled_plugins/#disabled_plugins/g' /etc/containerd/config.toml
  - systemctl restart containerd
  - iptables -P INPUT ACCEPT
  - iptables -P FORWARD ACCEPT
  - iptables -P OUTPUT ACCEPT
  - iptables -t nat -F
  - iptables -t mangle -F
  - iptables -F
  - iptables -X
  - kubeadm init --pod-network-cidr=192.168.0.0/16
  - mkdir - p /home/ubuntu/.kube
  - cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
  - chown -R ubuntu:ubuntu /home/ubuntu/.kube/config
  - sleep 2
  - sudo -u ubuntu kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/tigera-operator.yaml
  - sleep 2
  - sudo -u ubuntu kubectl create -f https://raw.githubusercontent.com/projectcalico/calico/v3.24.5/manifests/custom-resources.yaml
  - sleep 180
  - sudo -u ubuntu kubectl taint nodes --all node-role.kubernetes.io/control-plane-
  - sleep 5
# DSB
  - cd /home/ubuntu && git clone ${dsb_repo} 
# Enable LoadBalancer
# - "sed -i '/  name: nginx-thrift/a \\ \\ type: LoadBalancer' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/charts/nginx-thrift/values.yaml"
  - "sed -i '0,/name: nginx-thrift/a type: NodePort' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/charts/nginx-thrift/values.yaml"
  - "sed -i '/    targetPort: 8080/a \\ \\ \\ \\ nodePort: 32080' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/charts/nginx-thrift/values.yaml"
  - "sed -i '/    targetPort: {{ .targetPort }}/a \\ \\ \\ \\ nodePort: {{ .nodePort }}' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/socialnetwork/templates/_baseService.tpl"
  - chown -R ubuntu:ubuntu /home/ubuntu
# Needed for building containers
# - rm -rf /home/ubuntu/DeathStarBench/socialNetwork/wrk2/deps/luajit
# - cd /home/ubuntu/DeathStarBench/socialNetwork/wrk2/deps/ && git clone https://luajit.org/git/luajit.git
# - cd /home/ubuntu/DeathStarBench/socialNetwork/wrk2/deps/luajit && make && sudo make install && sudo ln -sf luajit-2.1.0-beta3 /usr/local/bin/luajit
# - cd /home/ubuntu/DeathStarBench/socialNetwork/wrk2/ && sed -i 's/#include <x86intrin.h>/#ifdef __x86_64__\n #include <x86intrin.h>\n#endif\n/g' src/hdr_histogram.c
# - cd /home/ubuntu/DeathStarBench/socialNetwork/wrk2/ && make
  - cd /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/ && chmod +x create delete describe install installdefault logs watch
  - sudo -u ubuntu /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/create
  - sudo -u ubuntu sed -i 's/10m0s/25m0s/g' /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/install
  - sudo -u ubuntu cp /home/ubuntu/install2 /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/install2
  - sudo -u ubuntu /home/ubuntu/DeathStarBench/socialNetwork/helm-chart/install
# - sleep 12m
# - sudo -u ubuntu python3 /home/ubuntu/DeathStarBench/socialNetwork/scripts/init_social_graph.py --graph=socfb-Reed98 --ip=10.0.10.236 --port=32080

write_files:
  - content: |
      #!/usr/bin/env bash
      helm install social-network ./socialnetwork/ \
      -n social-network \
      --set \
      global.mongodb.sharding.enabled=true,\
      global.mongodb.standalone.enabled=false,\
      global.redis.cluster.enabled=true,\
      global.redis.standalone.enabled=false,\
      global.memcached.cluster.enabled=false,\
      global.memcached.standalone.enabled=true,\
      nginx-thrift.replicas=1,\
      mongodb-sharded.shards=1,\
      mongodb-sharded.shardsvr.dataNode.replicaCount=1,\
      mcrouter.memcached.replicaCount=1,\
      global.replicas=1 \
      --timeout 25m0s &
    path: /home/ubuntu/install2
  - content: |
      file=io.open("path.txt","w")
      io.output(file)
      io.write(string.format("'"..package.path.."'"))
      io.close(file)
      cfile=io.open("cpath.txt","w")
      io.output(cfile)
      io.write(string.format("'"..package.cpath.."'"))
      io.close(cfile)
    path: /home/ubuntu/luapaths.lua
